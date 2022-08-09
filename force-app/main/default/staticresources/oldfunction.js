import { readFileSync } from "fs";
import moment from "moment-timezone";
import {
  uniqueNamesGenerator,
  adjectives,
  colors,
  animals
} from "unique-names-generator";
import PDFDocument from "pdfkit";
import getStream from "get-stream";
import ObjectsToCsv from "objects-to-csv";
import AdmZip from "adm-zip";

const sampleData = JSON.parse(
  readFileSync(new URL("./data/sample-data.json", import.meta.url))
);

//image attachment, use a logo in a known place - base64 is needed for ContentVersion in Salesforce
const imageData = readFileSync("./data/logo.jpg", { encoding: "base64" });

/**
 * From a large JSON payload calculates the distance between a supplied
 * point of origin cordinate and the data, sorts it, and returns the nearest x results.
 *
 * The exported method is the entry point for your code when the function is invoked.
 *
 * Following parameters are pre-configured and provided to your function on execution:
 * @param event: represents the data associated with the occurrence of an event, and
 *                 supporting metadata about the source of that occurrence.
 * @param context: represents the connection to Functions and your Salesforce org.
 * @param logger: logging handler used to capture application logs and trace specifically
 *                 to a given execution of a function.
 */

export default async function execute(event, context, logger) {
  const data = event.data || {};
  logger.info("CONTEXT LOGGING START ****");
  logger.info(
    `event===>${JSON.stringify(event)} context====>${JSON.stringify(context)}`
  );
  logger.info("CONTEXT LOGGING END ****");

  logger.info(
    `Invoking Mikes MyFunctions-myfunction with payload ${JSON.stringify(data)}`
  );

  // validate the payload params
  if (!data.latitude || !data.longitude) {
    throw new Error(`Please provide latitude and longitude`);
  }

  // Sets 5 if length is not provided, also accepts length = 0
  const length = data.length ?? 5;

  const datasetsize = sampleData.schools.length;

  // Iterate through the schools in the file and calculate the distance using the distance function below
  const schools = sampleData.schools
    .map((school) => {
      return Object.assign({}, school, {
        distance: distance(
          data.latitude,
          data.longitude,
          school.latitude,
          school.longitude
        )
      });
    })
    // Sort schools by distance distance from the provided location
    .sort((a, b) => parseFloat(a.distance) - parseFloat(b.distance));

  // Assign the nearest x schools to the results constant based on the length property provided in the payload
  const results = schools.slice(0, length);

  /**** Prepare CSV and ZIP  ****/

  // A simple query to populate our CSV attachment
  logger.info(`Querying Salesforce: select id,name from Account`);
  const qryresults = await context.org.dataApi.query(
    `SELECT Id, Name FROM Account`
  );

  //parse out the salesforce id, name fields into an array ready for csv processing
  const qryobj = qryresults.records.map((rec) => {
    return { Id: rec.fields.id, Name: rec.fields.name };
  });

  // use an open source library to generate CSV from the query
  const querycsv = new ObjectsToCsv(qryobj);

  //write the CSV to disk
  await querycsv.toDisk("./data/test.csv");

  // we might as well Zip the CSV while we are here - again use an open source library
  const queryzip = new AdmZip();
  await queryzip.addLocalFile("./data/test.csv");
  await queryzip.writeZip("./data/test.zip");

  /**** Prepare PDF ****/

  //just for fun generate a random string for the file name
  let randomName = uniqueNamesGenerator({
    dictionaries: [adjectives, colors, animals]
  }); // big_red_donkey

  //Generate PDF - it will be in Base64 format
  var pdfData = "";
  //let timestamp = new Date().toString();
  let time = moment.tz(
    new Date(),
    "Australia/Sydney"
  ); /* timezone_string = "Australia/Sydney" */
  let timestring = time.format("D/MM/YYYY hh:mm A");
  createPdf(
    `You succesfully executed a Salesforce function at ${timestring}. \n\nYour randomly generated run name is ${randomName}.\n`
  ).then((data) => {
    pdfData = data;
  });

  /**  UOW - Write results to Salesforce - Use a Unit of Work **/
  logger.info(`Commencing UOW process`);

  /* Create a Unit of Work to store Function Log and Attachment */
  const uow = context.org.dataApi.newUnitOfWork();

  /*create a custom object FunctionRunLog__c */
  const functionRunlogId = uow.registerCreate({
    type: "FunctionRunLog__c",
    fields: {
      LogText__c: `My Node.js function returned random string: [${randomName}]. Plotted ${length} closest schools from the sample dataset of ${datasetsize} records. Finally, used open source libraries to create Zip, CSV, PNG and PDF files, and via the Unit Of Work framework attach them to this record.`,
      LogDateTime__c: `${Date.now()}`
    }
  });

  var frlid; // a var to store the functionrunlogid

  /* Commit the Unit of Work with all the previous registered operations */
  try {
    const response = await context.org.dataApi.commitUnitOfWork(uow);
    frlid = response.get(functionRunlogId).id;
    // Construct the result by getting the Id from the successful inserts
    const result = {
      functionRunLogId: response.get(functionRunlogId).id
      //attachmentId: response.get(attachmentId).id
    };
    logger.info(`UOW returned result: ${JSON.stringify(result)}`);
  } catch (err) {
    const errorMessage = `Failed to insert record. Root Cause : ${err.message}`;
    logger.error(errorMessage);
    throw new Error(errorMessage);
  }
  /**  END UOW **/

  /** ADD png, csv, zip and pdf ATTACHMENTS TO THE FunctionRunLog__c record created above **/

  /* Image */
  logger.info("Storing Image to Content Version ");
  const img = {
    type: "ContentVersion",
    fields: {
      VersionData: imageData,
      Title: "logo.png",
      PathOnClient: "logo.jpg",
      ContentLocation: "S",
      FirstPublishLocationId: frlid // FunctionRunLog__c record id
    }
  };

  try {
    /*Insert the record using the SalesforceSDK DataApi and get the new Record Id from the result */
    const { id: recordId } = await context.org.dataApi.create(img);
    logger.info(`CV returned ${recordId}`);
  } catch (err) {
    /* Catch any DML errors and pass the throw an error with the message */
    const errorMessage = `Failed to insert CV record. Root Cause: ${err.message}`;
    logger.error(errorMessage);
    throw new Error(errorMessage);
  }

  /* CSV */
  logger.info("Storing CSV file to Content Version ");
  const csvfile = readFileSync("./data/test.csv", { encoding: "base64" });
  const csv = {
    type: "ContentVersion",
    fields: {
      VersionData: csvfile,
      Title: "test.csv",
      PathOnClient: "test.csv",
      ContentLocation: "S",
      FirstPublishLocationId: frlid // FunctionRunLog__c record id
    }
  };

  try {
    /* Insert the record using the SalesforceSDK DataApi and get the new Record Id from the result */
    const { id: recordId } = await context.org.dataApi.create(csv);
    logger.info(`CV returned ${recordId}`);
  } catch (err) {
    /* Catch any DML errors and pass the throw an error with the message  */
    const errorMessage = `Failed to insert CV record. Root Cause: ${err.message}`;
    logger.error(errorMessage);
    throw new Error(errorMessage);
  }

  /* Zip */
  logger.info("Storing ZIP file to Content Version ");
  const zipfile = readFileSync("./data/test.zip", { encoding: "base64" });
  const zip = {
    type: "ContentVersion",
    fields: {
      VersionData: zipfile,
      Title: "test.zip",
      PathOnClient: "test.zip",
      ContentLocation: "S",
      FirstPublishLocationId: frlid // FunctionRunLog__c record id
    }
  };

  try {
    /* Insert the record using the SalesforceSDK DataApi and get the new Record Id from the result */
    const { id: recordId } = await context.org.dataApi.create(zip);
    logger.info(`CV returned ${recordId}`);
  } catch (err) {
    /* Catch any DML errors and pass the throw an error with the message */
    const errorMessage = `Failed to insert CV record. Root Cause: ${err.message}`;
    logger.error(errorMessage);
    throw new Error(errorMessage);
  }

  /* PDF */
  logger.info("Storing PDF to Content Version ");
  const cv = {
    type: "ContentVersion",
    fields: {
      VersionData: pdfData,
      Title: `${randomName}` + ".pdf",
      PathOnClient: "Function_Generated.pdf",
      ContentLocation: "S",
      FirstPublishLocationId: frlid // FunctionRunLog__c record id
    }
  };

  try {
    /* Insert the record using the SalesforceSDK DataApi and get the new Record Id from the result */
    const { id: recordId } = await context.org.dataApi.create(cv);
    logger.info(`CV returned ${recordId}`);
  } catch (err) {
    // Catch any DML errors and pass the throw an error with the message
    const errorMessage = `Failed to insert CV record. Root Cause: ${err.message}`;
    logger.error(errorMessage);
    throw new Error(errorMessage);
  }
  /** end ADDING ATTACHMENTS */

  return { schools: results };
}

/**
 * Calculate distance between two geographical points
 *
 * @param {string} latitudeSt:  represents the latitude of the origin point
 * @param {string} longitudeSt:  represents the longitude of the origin point
 * @param {string} latitudeSch:  represents the latitude of the school
 * @param {string} longitudeSch:  represents the longitude of the school
 * ....
 * @returns {number} distance between point a and b
 */
function distance(latitudeSt, longitudeSt, latitudeSch, longitudeSch) {
  if (latitudeSt == latitudeSch && longitudeSt == longitudeSch) {
    return 0;
  } else {
    const radLatitudeSf = (Math.PI * latitudeSt) / 180;
    const radLatitudeSch = (Math.PI * latitudeSch) / 180;
    const theta = longitudeSt - longitudeSch;
    const radTheta = (Math.PI * theta) / 180;
    let dist =
      Math.sin(radLatitudeSf) * Math.sin(radLatitudeSch) +
      Math.cos(radLatitudeSf) * Math.cos(radLatitudeSch) * Math.cos(radTheta);
    if (dist > 1) {
      dist = 1;
    }
    dist = Math.acos(dist);
    dist = (dist * 180) / Math.PI;
    dist = dist * 60 * 1.1515 * 1.609344;
    return dist;
  }
}

/**
 * asynch function to create a PDF
 *
 * @param {string} text:  text to be included in the PDF
 * @returns {Buffer} base64 version of the PDF document
 */
async function createPdf(text) {
  const doc = new PDFDocument();
  doc.moveDown();
  doc.moveDown();
  doc.fontSize(14).text(text, 50, 50);
  doc
    .fontSize(20)
    .text(
      "This Salesforce Function used the open source 'pdfKit' library to write and format all the text in this PDF document and also to build the simple vector graphic above.",
      100,
      300
    );

  doc.save().moveTo(100, 150).lineTo(100, 250).lineTo(200, 250).fill("#FF3300");
  //doc.fontSize(14).text(text, 50, 50);
  doc.addPage();
  // Create a clipping path
  doc.circle(100, 100, 100).clip();

  // Draw a checkerboard pattern
  for (let row = 0; row < 10; row++) {
    for (let col = 0; col < 10; col++) {
      const color = (col % 2) - (row % 2) ? "#eee" : "#4183C4";
      doc.rect(row * 20, col * 20, 20, 20).fill(color);
    }
  }
  doc.addPage();
  const lorem =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam in suscipit purus.  Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Vivamus nec hendrerit felis. Morbi aliquam facilisis risus eu lacinia. Sed eu leo in turpis fringilla hendrerit. Ut nec accumsan nisl.";

  doc.fontSize(12);
  doc.text(`This text is left aligned. ${lorem} ${lorem} ${lorem}`, {
    width: 410,
    align: "left"
  });
  doc.end();

  const data = await getStream.buffer(doc);
  let b64 = Buffer.from(data).toString("base64");
  return b64;
}

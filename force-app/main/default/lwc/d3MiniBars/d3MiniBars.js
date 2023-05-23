import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript } from "lightning/platformResourceLoader";
import D3 from "@salesforce/resourceUrl/d3";
import generateD3COTimeSeriesByStatusJson from "@salesforce/apex/L4LTimeSeries.generateD3COTimeSeriesByStatusJson";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";
//import getD3StatusYAxisScale from "@salesforce/apex/L4LSessionStatsController.getD3StatusYAxisScale";

const COMPONENT = "D3MiniBars";
const TAG = "L4L-Session-Statistics-D3MiniBars";
const SCENARIO = "Viewing D3 Client Objectiive mini line charts - LWC";
const UI_EVENT_TRACKING_SCENARIO = "d3MiniBars LWC UI Event Tracking";
const APEX_EVENT_TRACKING_SCENARIO = "d3MiniBars LWC APEX Event Tracking";
export default class D3MiniBars extends LightningElement {
  @api recordId;
  d3Initialized = false;
  @track result = [];
  mode = "All";
  //yAxisScale = 50;

  // @wire(getD3StatusYAxisScale, { clientId: "$recordId" })
  // wiredYaxis({ error, data }) {
  //   if (data) {
  //     console.log(`raw yAxisScale= ${data}`);
  //     this.yAxisScale = Math.ceil(data / 20) * 20;
  //     console.log(`rounded yAxisScale=${this.yAxisScale}`);
  //   } else if (error) {
  //     console.log("error");
  //   }
  // }
  connectedCallback() {
    console.log("in connectedCallback recordId=" + this.recordId);
    setNewSession()
      .then((returnVal) => {
        console.log("Success");

        logInfo(
          this.recordId,
          `${COMPONENT}: connectedCallback`,
          `${UI_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking

        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): all good, call to L4LNebulaComponentController setupCache completed `,
          `${SCENARIO}`,
          `${TAG}`
        );
      })
      .catch((error) => {
        console.log("Error");
        logError(
          this.recordId,
          `${COMPONENT}.connectedCallback() returned error: ${JSON.stringify(
            error
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }

  renderedCallback() {
    if (this.d3Initialized) {
      return;
    }
    this.d3Initialized = true;
    console.log("in  renderedCallback");
    loadScript(this, D3 + "/d3.v5.min.js")
      .then(() => {
        console.log("calling apex");

        logDebug(
          this.recordId,
          `${COMPONENT}.renderedCallback(): calling generateD3COTimeSeriesByStatusJson`,
          `${SCENARIO}`,
          `${TAG}`
        );

        logInfo(
          this.recordId,
          `${COMPONENT}: Apex Call: L4LTimeSeries.generateD3COTimeSeriesByStatusJson`,
          `${APEX_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking

        return generateD3COTimeSeriesByStatusJson({
          clientId: this.recordId
        });
      })
      .then((response) => {
        console.log("response=" + JSON.stringify(response));

        logDebug(
          this.recordId,
          `${COMPONENT}.renderedCallback(): generateD3COTimeSeriesByStatusJson returned ${response}`,
          `${SCENARIO}`,
          `${TAG}`
        );

        this.renderLineChart(response);
      })
      .catch((error) => {
        logError(
          this.recordId,
          `${COMPONENT}.renderedCallback(): error: ${JSON.stringify(error)}`,
          `${SCENARIO}`,
          `${TAG}`
        );

        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error loading D3",
            message: error.message,
            variant: "error"
          })
        );
      });
  }

  renderLineChart(response) {
    // let data = JSON.parse(
    //   '[{"rundate":"2022-11-26","val":60,"status":ACQ},{"rundate":"2022-12-19","val":64,"status":"ACQ"}]'
    // );

    logDebug(
      this.recordId,
      `${COMPONENT}.renderLineChart(): wrangling data and drawing mini line charts`,
      `${SCENARIO}`,
      `${TAG}`
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.renderLineChart(): parameter is response=${response}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    let datatmp = JSON.parse(response);
    let data = datatmp.map(myfunction);

    // var sumstat = d3
    //   .nest() // nest function allows to group the calculation per level of a factor
    //   .key(function (d) {
    //     return d.name;
    //   })
    //   .entries(data);

    const sumstat = d3.group(data, (d) => d.status); // nest function allows to group the calculation per level of a factor

    // What is the list of groups?
    const allKeys = new Set(data.map((d) => d.status));

    console.log(allKeys);

    function myfunction(d) {
      return {
        rundate: d3.timeParse("%Y-%m-%d")(d.rundate),
        val: d.val,
        status: d.status
      };
    }

    function make_y_gridlines() {
      return d3.axisLeft(y).ticks(5);
    }

    function make_x_gridlines() {
      return d3.axisBottom(x).ticks(5);
    }

    console.log("data " + JSON.stringify(data));

    logDebug(
      this.recordId,
      `${COMPONENT}.renderLineChart(): data=${JSON.stringify(data)}`,
      `${COMPONENT}.renderLineChart(): preparing to draw multiple mini linecharts, data logged`,
      `${TAG}`
    );

    // set the dimensions and margins of the graph
    var margin = { top: 40, right: 30, bottom: 40, left: 50 },
      width = 600 - margin.left - margin.right,
      height = 500 - margin.top - margin.bottom;

    logDebug(
      this.recordId,
      `${COMPONENT}.renderLineChart(): width=${width} height=${height} margin=${JSON.stringify(
        margin
      )}`,
      `${COMPONENT}.renderLineChart(): width=${width} height=${height} margin=${JSON.stringify(
        margin
      )}`,
      `${TAG}`
    );

    console.log("cleaning  up  svg");
    // let svg = d3.select(this.template.querySelector(".d3-minibars-chart"));
    // svg.selectAll("*").remove();
    let svg = d3.select(this.template.querySelector("div"));
    svg.selectAll("*").remove();

    console.log("set up svg");

    svg = d3
      .select(this.template.querySelector("div"))
      .selectAll("uniqueChart")
      .data(sumstat)
      .enter()
      .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", `translate(${margin.left},${margin.top})`);

    // Add X axis --> it is a date format
    console.log("set up X");

    const x = d3
      .scaleTime()
      .domain(
        d3.extent(data, function (d) {
          return d.rundate;
        })
      )
      .range([0, width]);

    svg
      .append("g")
      .attr("transform", `translate(0, ${height})`)
      .call(d3.axisBottom(x).ticks(5))
      .selectAll("text")
      .style("text-anchor", "end")
      .attr("dx", "-.8em")
      .attr("dy", ".15em")
      .attr("transform", "rotate(-45)");

    svg
      .append("g")
      .attr("class", "grid")
      .attr("transform", "translate(0," + height + ")")
      .call(make_x_gridlines().tickSize(-height).tickFormat(""));

    console.log("set up Y");

    const y = d3
      .scaleLinear()
      .domain([
        0,
        d3.max(data, function (d) {
          return Math.ceil(d.val / 20) * 20 + 5;
          //+d.val;
        })
      ])
      .range([height, 0]);
    svg.append("g").call(d3.axisLeft(y).ticks(5));

    svg
      .append("g")
      .attr("class", "grid")
      .call(make_y_gridlines().tickSize(-width).tickFormat(""));

    d3.selectAll(".grid  line")
      .style("stroke", "lightgrey")
      .style("stroke-opacity", 0.7)
      .style("shape-rendering", "crispEdges");

    d3.selectAll(".grid  path").style("stroke-width", 0);

    console.log("set up color");
    // color palette
    const color = d3
      .scaleOrdinal()
      //.domain(allKeys)
      .range([
        "#e41a1c",
        "#377eb8",
        "#4daf4a",
        "#984ea3",
        "#ff7f00",
        "#ffdd33",
        "#a65628",
        "#f781bf",
        "#999999"
      ]);

    console.log("draw the Line");

    // Draw the line

    svg
      .append("path")
      .attr("fill", "none")
      .attr("stroke", function (d) {
        return color(d[0]);
      })
      .attr("stroke-width", 2.3)
      .attr("d", function (d) {
        console.log("path " + JSON.stringify(d));
        return d3
          .line()
          .x(function (d) {
            return x(d.rundate);
          })
          .y(function (d) {
            return y(+d.val);
          })(d[1]);
      });

    console.log("add the titles");

    // Add titles
    svg
      .append("text")
      .attr("text-anchor", "start")
      .attr("y", -5)
      .attr("x", 0)
      .text(function (d) {
        return d[0];
      })
      .style("fill", function (d) {
        return color(d[0]);
      });

    // Add the points
    // svg
    //   .append("g")
    //   .selectAll("dot")
    //   .data(sumstat)
    //   .enter()
    //   .append("circle")
    //   .attr("cx", function (d) {
    //     return x(d.rundate);
    //   })
    //   .attr("cy", function (d) {
    //     return y(d.val);
    //   })
    //   .attr("r", 5)
    //   .attr("fill", "#69b3a2");

    let titlesvg = d3
      .select(this.template.querySelector(".title"))
      .attr("width", 800)
      .attr("height", 60)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    titlesvg
      .append("text")
      .attr("x", 50)
      //.attr("x", 200)
      .attr("y", 0)
      .attr("text-anchor", "left")
      .style("font-size", "18px")
      .style("fill", "grey")
      .style("max-width", 800)
      .text(`EXPERIMENTAL: Client Objective Counts by Status`);

    titlesvg
      .append("text")
      .attr("x", 50)
      //.attr("x", 200)
      .attr("y", 15)
      .attr("text-anchor", "left")
      .style("font-size", "14px")
      .style("fill", "grey")
      .style("max-width", 800)
      .text(`Client Objective Time Series, auto refreshed Sunday 10pm`);
  }
}

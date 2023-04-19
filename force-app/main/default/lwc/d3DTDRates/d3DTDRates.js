import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript } from "lightning/platformResourceLoader";
import D3 from "@salesforce/resourceUrl/d3";
import getDTDRateArray from "@salesforce/apex/LFLDTDRateMaster.getDTDRateArray";

import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";

const COMPONENT = "D3DTDRates";
const TAG = "L4L-Session-Statistics-D3DTDRatesChart";
const SCENARIO = "View the D3 DTD Acquisition Rate chart";

export default class D3DTDRates extends LightningElement {
  @api recordId;
  d3Initialized = false;
  @track result = [];
  mode = "All";
  yAxisScale = 20;
  yAxisMax = 20;
  yAxisMin = -5;
  yAxisMaxSessions = 10;
  yAxisMinSessions = 0;

  // @wire(getD3YAxisScale, { clientId: "$recordId" })
  // wiredYaxis({ error, data }) {
  //   if (data) {
  //     console.log(`yAxisScale= ${data}`);
  //     //this.yAxisScale = Math.ceil(data / 20) * 20;
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
          `${COMPONENT}.renderedCallback(): calling getDTDArray, iters=26`,
          `${SCENARIO}`,
          `${TAG}`
        );
        return getDTDRateArray({
          clientId: this.recordId,
          iters: "26"
        });
      })
      .then((response) => {
        console.log("response=" + response);
        logDebug(
          this.recordId,
          `${COMPONENT}.renderedCallback(): returned ${response}
          }`,
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
    //   '[{"rundate":"2022-11-26","val":60},{"rundate":"2022-12-19","val":64}]'

    logDebug(
      this.recordId,
      `${COMPONENT}.renderLineChart(): wrangling data and drawing the Line chart`,
      `${SCENARIO}`,
      `${TAG}`
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.renderLineChart(): parameter is response=${response})`,
      `${SCENARIO}`,
      `${TAG}`
    );

    let parsedResponse = JSON.parse(response);
    console.log("Session duration = " + parsedResponse.duration);
    let datatmp = parsedResponse.data;

    // datatmp.sort(function (a, b) {
    //   if (a.endd < b.endd) {
    //     return -1;
    //   }
    // });

    function findMinMax(key) {
      const datas = datatmp.map((node) => node[key]);

      return {
        min: Math.min(...datas),
        max: Math.max(...datas)
      };
    }
    console.log(findMinMax("rate").max);
    console.log(findMinMax("rate").min);
    this.yAxisMax = findMinMax("rate").max + 5;
    this.yAxisMin = findMinMax("rate").min - 5;

    // console.log(findMinMax("sessionCount").max);
    // console.log(findMinMax("sessionCount").min);

    let data = datatmp.map(myfunction);
    let sessiondata = datatmp.map(mysessionfunction);

    function myfunction(d) {
      return {
        endd: d3.timeParse("%Y-%m-%d")(d.endd),
        val: d.rate
      };
    }

    function mysessionfunction(d) {
      return {
        endd: d3.timeParse("%Y-%m-%d")(d.endd),
        val: d.sessionCount
      };
    }

    function make_y_gridlines() {
      return d3.axisLeft(y).ticks(10);
    }
    function make_x_gridlines() {
      return d3.axisBottom(x).ticks(10);
    }

    console.log("data " + JSON.stringify(data));

    logDebug(
      this.recordId,
      `${COMPONENT}.renderLineChart: data=${JSON.stringify(data)}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    // set the dimensions and margins of the graph
    const margin = { top: 40, right: 30, bottom: 40, left: 50 },
      width = 1150 - margin.left - margin.right,
      height = 400 - margin.top - margin.bottom;

    logDebug(
      this.recordId,
      `${COMPONENT}.renderLineChart: width=${width} height=${height} margin=${JSON.stringify(
        margin
      )}`,
      `${SCENARIO}`,
      `${TAG}`
    );
    console.log("cleaning  up  svg");
    let svg = d3.select(
      this.template.querySelector(".horizontal-lollipop-chart")
    );
    svg.selectAll("*").remove();

    svg = d3
      .select(this.template.querySelector(".horizontal-lollipop-chart"))
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var x = d3
      .scaleTime()
      .domain(
        d3.extent(data, function (d) {
          return d.endd;
        })
      )
      .range([0, width]);

    svg
      .append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x))
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

    // Add Y axis (curr hard coded to 50)
    var y = d3
      .scaleLinear()
      .domain([this.yAxisMin, this.yAxisMax])
      .range([height, 0]);
    //todo - build a better y-Axis scale as per d3Lollipop

    svg.append("g").call(d3.axisLeft(y));

    svg
      .append("g")
      .attr("class", "grid")
      .call(make_y_gridlines().tickSize(-width).tickFormat(""));

    // Add the line
    svg
      .append("path")
      .datum(data)
      .transition()
      .duration(2000)
      .attr("fill", "none")
      .attr("stroke", "#69b3a2")
      .attr("stroke-width", 2.5)
      .attr(
        "d",
        d3
          .line()
          .x(function (d) {
            return x(d.endd);
          })
          .y(function (d) {
            return y(d.val);
          })
      );
    // Add the points

    svg
      .append("g")
      .selectAll("dot")
      .data(data)
      .enter()
      .append("circle")
      .attr("cx", function (d) {
        return x(d.endd);
      })
      .attr("cy", function (d) {
        return y(d.val);
      })
      .attr("r", 5)
      .attr("fill", "#69b3a2");

    svg
      .append("text")
      .attr("x", (width - 300) / 2)
      .attr("y", 0)
      .attr("text-anchor", "left")
      .style("font-size", "18px")
      .style("fill", "grey")
      .style("max-width", 400)
      .text(`EXPERIMENTAL: Skills Acquisition Rate (ACQ/Week)`);

    svg
      .append("text")
      .attr("x", (width - 300) / 2)
      .attr("y", 20)
      .attr("text-anchor", "left")
      .style("font-size", "14px")
      .style("fill", "grey")
      .style("max-width", 400)
      .text("Source: Client Objective Time Series, auto refreshed Sunday 10pm")
      .attr("x", (width - 300) / 2)
      .attr("y", 40)
      .attr("text-anchor", "left")
      .style("font-size", "14px")
      .style("fill", "grey")
      .style("max-width", 400)
      .text(
        "Remember this is a view of RATE, not the number of skills acquired."
      );

    /* sessions*/

    let sessionssvg = d3.select(this.template.querySelector(".sessions"));
    sessionssvg.selectAll("*").remove();

    // append the svg object to the body of the page

    sessionssvg = d3
      .select(this.template.querySelector(".sessions"))
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    x = d3
      .scaleTime()
      .domain(
        d3.extent(sessiondata, function (d) {
          return d.endd;
        })
      )
      .range([0, width]);

    sessionssvg
      .append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x))
      .selectAll("text")
      .style("text-anchor", "end")
      .attr("dx", "-.8em")
      .attr("dy", ".15em")
      .attr("transform", "rotate(-45)");

    sessionssvg
      .append("g")
      .attr("class", "grid")
      .attr("transform", "translate(0," + height + ")")
      .call(make_x_gridlines().tickSize(-height).tickFormat(""));

    // Add Y axis (curr hard coded to 50)
    y = d3
      .scaleLinear()
      .domain([this.yAxisMinSessions, this.yAxisMaxSessions])
      .range([height, 0]);
    //todo - build a better y-Axis scale as per d3Lollipop

    sessionssvg.append("g").call(d3.axisLeft(y));

    sessionssvg
      .append("g")
      .attr("class", "grid")
      .call(make_y_gridlines().tickSize(-width).tickFormat(""));

    // Add the line
    sessionssvg
      .append("path")
      .datum(sessiondata)
      .transition()
      .duration(2000)
      .attr("fill", "none")
      .attr("stroke", "#69b3a2")
      .attr("stroke-width", 2.5)
      .attr(
        "d",
        d3
          .line()
          .x(function (d) {
            return x(d.endd);
          })
          .y(function (d) {
            return y(d.val);
          })
      );
    // Add the points

    sessionssvg
      .append("g")
      .selectAll("dot")
      .data(sessiondata)
      .enter()
      .append("circle")
      .attr("cx", function (d) {
        return x(d.endd);
      })
      .attr("cy", function (d) {
        return y(d.val);
      })
      .attr("r", 5)
      .attr("fill", "#69b3a2");

    sessionssvg
      .append("text")
      .attr("x", (width - 300) / 2)
      .attr("y", 0)
      .attr("text-anchor", "left")
      .style("font-size", "18px")
      .style("fill", "grey")
      .style("max-width", 400)
      .text(`EXPERIMENTAL: Sessions`);

    sessionssvg
      .append("text")
      .attr("x", (width - 300) / 2)
      .attr("y", 20)
      .attr("text-anchor", "left")
      .style("font-size", "14px")
      .style("fill", "grey")
      .style("max-width", 400)
      .text("Source: Client Objective Time Series, auto refreshed Sunday 10pm")
      .attr("x", (width - 300) / 2)
      .attr("y", 40)
      .attr("text-anchor", "left")
      .style("font-size", "14px")
      .style("fill", "grey")
      .style("max-width", 400)
      .text("Remember this is a view of sessions.");
  }
}

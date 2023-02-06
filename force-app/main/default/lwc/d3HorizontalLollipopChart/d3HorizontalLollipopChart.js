import { LightningElement, wire, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript } from "lightning/platformResourceLoader";
import D3 from "@salesforce/resourceUrl/d3";
import generateD3COTimeSeriesJson from "@salesforce/apex/L4LTimeSeries.generateD3COTimeSeriesJson";
import getD3YAxisScale from "@salesforce/apex/L4LSessionStatsController.getD3YAxisScale";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { logDebug, logError } from "c/l4lNebulaUtil";

const COMPONENT = "D3HorizontalLollipopChart";
const TAG = "L4L-Session-Statistics-D3HorizontalLollipopChart";

/**
 * Example taken from https://www.d3-graph-gallery.com/graph/lollipop_horizontal.html
 */
export default class D3HorizontalLollipopChart extends LightningElement {
  @api recordId;
  d3Initialized = false;
  @track result = [];
  mode = "All";
  yAxisScale = 100;

  @wire(getD3YAxisScale, { clientId: "$recordId" })
  wiredYaxis({ error, data }) {
    if (data) {
      console.log(`yAxisScale= ${data}`);
      this.yAxisScale = Math.ceil(data / 50) * 50;
    } else if (error) {
      console.log("error");
    }
  }

  connectedCallback() {
    console.log("in connectedCallback recordId=" + this.recordId);
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logDebug(
          this.recordId,
          `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
          `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
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
          `${COMPONENT}.connectedCallback() returned error: ${JSON.stringify(
            error
          )}`,
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
          `${COMPONENT}.renderedCallback(): calling generateD3COTimeSeriesJson, status=All`,
          `${COMPONENT}.renderedCallback(): calling generateD3COTimeSeriesJson, status=All`,
          `${TAG}`
        );
        return generateD3COTimeSeriesJson({
          clientId: this.recordId,
          status: "All"
        });
      })
      .then((response) => {
        logDebug(
          this.recordId,
          `${COMPONENT}.renderedCallback(): generateD3COTimeSeriesJson returned ${response}`,
          `${COMPONENT}.renderedCallback(): generateD3COTimeSeriesJson returned ${response}`,
          `${TAG}`
        );

        this.renderLineChart(response);
      })
      .catch((error) => {
        logError(
          this.recordId,
          `${COMPONENT}.renderedCallback(): error: ${JSON.stringify(error)}`,
          `${COMPONENT}.renderedCallback(): error: ${JSON.stringify(error)}`,
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
      `${COMPONENT}.renderLineChart(): parameter is response=${response})`,
      `${COMPONENT}.renderLineChart(): in renderLineChart(response), logged parameter`,
      `${TAG}`
    );

    let datatmp = JSON.parse(response);
    let data = datatmp.map(myfunction);

    function myfunction(d) {
      return { rundate: d3.timeParse("%Y-%m-%d")(d.rundate), val: d.val };
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
      `${COMPONENT}.renderLineChart(): data=${JSON.stringify(data)}`,
      `${COMPONENT}.renderLineChart(): preparing to draw a line chart, data logged`,
      `${TAG}`
    );

    // set the dimensions and margins of the graph
    const margin = { top: 40, right: 30, bottom: 40, left: 50 },
      width = 1150 - margin.left - margin.right,
      height = 400 - margin.top - margin.bottom;

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
    let svg = d3.select(
      this.template.querySelector(".horizontal-lollipop-chart")
    );
    svg.selectAll("*").remove();

    // append the svg object to the body of the page
    console.log(
      `setting up svg yAxisScale= ${JSON.stringify(this.yAxisScale)})`
    );

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
          return d.rundate;
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

    // Add Y axis
    var y = d3.scaleLinear().domain([0, this.yAxisScale]).range([height, 0]);

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
            return x(d.rundate);
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
        return x(d.rundate);
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
      .text(`EXPERIMENTAL - Plotting ${this.mode} Client Objectives`);

    svg
      .append("text")
      .attr("x", (width - 300) / 2)
      .attr("y", 20)
      .attr("text-anchor", "left")
      .style("font-size", "14px")
      .style("fill", "grey")
      .style("max-width", 400)
      .text("Client Objective Time Series, auto refreshed Sunday 10pm");

    // Parse the Data
    // Add X axis

    // svg
    //   .selectAll("mybar")
    //   .data(data)
    //   .enter()
    //   .append("rect")
    //   .attr("x", function (d) {
    //     return x(d.week);
    //   })
    //   .attr("y", function (d) {
    //     return y(d.val);
    //   })
    //   .attr("width", x.bandwidth())
    //   .attr("height", function (d) {
    //     return height - y(d.val);
    //   })
    //   .attr("fill", "#69b3a2");
  }

  // handleClickMax(event) {
  //   this.clickedButtonLabel = event.target.label;
  //   this.renderHorizontalLollipopChart(this.mydata, "MaxEmployees");
  // }
  // handleClickAvg(event) {
  //   this.clickedButtonLabel = event.target.label;
  //   this.renderHorizontalLollipopChart(this.mydata, "AvgEmployees");
  // }

  handleClick(event) {
    this.mode = event.target.label;

    logDebug(
      this.recordId,
      `${COMPONENT}.handleClick(): this.mode=${this.mode}, calling generateD3COTimeSeriesJson`,
      `Clicked ${this.mode}, calling generateD3COTimeSeriesJson `,
      `${TAG}`
    );

    generateD3COTimeSeriesJson({
      clientId: this.recordId,
      status: this.mode
    }).then((response) => {
      logDebug(
        this.recordId,
        `${COMPONENT}.handleClick(): Apex returned reponse ${response}`,
        `${COMPONENT}.handleClick(): Apex response returned and logged, calling this.renderLineChart(response)`,
        `${TAG}`
      );

      console.log(
        "calling generateD3COTimeSeriesJson,response=" +
          JSON.stringify(response)
      );
      this.renderLineChart(response);
    });
  }
}

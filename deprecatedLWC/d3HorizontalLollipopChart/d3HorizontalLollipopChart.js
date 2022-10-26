import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript } from "lightning/platformResourceLoader";
import D3 from "@salesforce/resourceUrl/d3";
import getClientObjectivesByProgram from "@salesforce/apex/L4LSessionStatsController.getClientObjectivesByProgram";

/**
 * Example taken from https://www.d3-graph-gallery.com/graph/lollipop_horizontal.html
 */
export default class D3HorizontalLollipopChart extends LightningElement {
  @api recordId;
  d3Initialized = false;
  @track result = [];

  renderedCallback() {
    if (this.d3Initialized) {
      return;
    }
    this.d3Initialized = true;
    console.log("in  renderedCallback");
    loadScript(this, D3 + "/d3.v5.min.js")
      .then(() => {
        console.log("calling apex");
        return getClientObjectivesByProgram({ clientId: this.recordId });
      })
      .then((response) => {
        console.log("calling lollipop, response=" + JSON.stringify(response));
        this.renderHorizontalLollipopChart(response);
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error loading D3",
            message: error.message,
            variant: "error"
          })
        );
      });
  }

  renderHorizontalLollipopChart(data) {
    console.log("received " + JSON.stringify(data));

    console.log("in renderH...");
    console.log("received " + JSON.stringify(data));

    console.log("margins....");

    // set the dimensions and margins of the graph
    const margin = { top: 10, right: 30, bottom: 40, left: 200 },
      width = 760 - margin.left - margin.right,
      height = 500 - margin.top - margin.bottom;

    console.log("cleaning  up  svg");
    let svg = d3.select(
      this.template.querySelector(".horizontal-lollipop-chart")
    );
    svg.selectAll("*").remove();

    // append the svg object to the body of the page
    console.log("setting up svg");

    svg = d3
      .select(this.template.querySelector(".horizontal-lollipop-chart"))
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    // Parse the Data
    // Add X axis
    console.log("setting up X");

    const x = d3.scaleLinear().domain([0, 10]).range([0, width]);

    svg
      .append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x))
      .selectAll("text")
      .attr("transform", "translate(-10,0)rotate(-45)")
      .style("text-anchor", "end");

    console.log("setting up Y");

    console.log(JSON.stringify(data));

    // Y axis
    const y = d3
      .scaleBand()
      .range([0, height])
      .domain(
        data.map(function (d) {
          return d["Name"];
        })
      )
      .padding(1);
    svg.append("g").call(d3.axisLeft(y));

    //.call(d3.axisLeft(y));

    console.log("lines...");
    svg
      .selectAll("myline")
      .data(data)
      .enter()
      .append("line")
      .attr("x1", (d) => x(d.objectiveCount))
      .attr("x2", x(0))
      .attr("y1", (d) => y(d.Name))
      .attr("y2", (d) => y(d.Name))
      .attr("stroke", "grey");

    console.log("circles...");

    svg
      .selectAll("mycircle")
      .data(data)
      .enter()
      .append("circle")
      .attr("cx", (d) => x(d.objectiveCount))
      .attr("cy", (d) => y(d.Name))
      .attr("r", "6")

      .style("fill", "#69b3a2")
      .attr("stroke", "black");

    svg
      .append("text")
      .attr("x", 10)
      .attr("y", -20)
      .attr("text-anchor", "left")
      .style("font-size", "16px")
      .style("fill", "grey")
      .style("max-width", 400)
      .text("Number of Objectives oer Program");
  }

  // handleClickMax(event) {
  //   this.clickedButtonLabel = event.target.label;
  //   this.renderHorizontalLollipopChart(this.mydata, "MaxEmployees");
  // }
  // handleClickAvg(event) {
  //   this.clickedButtonLabel = event.target.label;
  //   this.renderHorizontalLollipopChart(this.mydata, "AvgEmployees");
  // }
}

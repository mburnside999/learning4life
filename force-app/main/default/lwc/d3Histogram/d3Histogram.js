import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript } from "lightning/platformResourceLoader";
import D3 from "@salesforce/resourceUrl/d3";
import getD3SessionStatsHistogramData from "@salesforce/apex/L4LSessionStatsController.getD3SessionStatsHistogramData";

/**
 * Example taken from https://www.d3-graph-gallery.com/graph/lollipop_horizontal.html
 */
export default class D3Histogram extends LightningElement {
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
        return getD3SessionStatsHistogramData({ clientId: this.recordId });
      })
      .then((response) => {
        console.log("calling histo, response=" + JSON.stringify(response));
        this.renderHistogram(response);
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

  renderHistogram(data) {
    console.log("received " + JSON.stringify(data));

    console.log("in renderH...");
    console.log("received " + JSON.stringify(data));

    console.log("margins....");

    // set the dimensions and margins of the graph
    var margin = { top: 50, right: 30, bottom: 60, left: 100 },
      width = 1000 - margin.left - margin.right,
      height = 600 - margin.top - margin.bottom;

    console.log("cleaning  up  svg");
    let svg = d3.select(this.template.querySelector(".histo"));
    svg.selectAll("*").remove();

    // append the svg object to the body of the page
    console.log("setting up svg");

    svg = d3
      .select(this.template.querySelector(".histo"))
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    // Parse the Data
    // Add X axis
    console.log("setting up X");

    const x = d3.scaleLinear().domain([0, 100]).range([0, width]);

    svg
      .append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x));

    var histogram = d3
      .histogram()
      .value(function (d) {
        return d.Percent_Correct__c;
      }) // I need to give the vector of value
      .domain(x.domain()) // then the domain of the graphic
      .thresholds(x.ticks(20)); // then the numbers of bins

    var bins = histogram(data);

    var y = d3.scaleLinear().range([height, 0]);
    y.domain([
      0,
      d3.max(bins, function (d) {
        return d.length;
      })
    ]); // d3.hist has to be called before the Y axis obviously

    svg.append("g").call(d3.axisLeft(y).tickFormat(d3.format("d")));

    svg
      .selectAll("rect")
      .data(bins)
      .enter()
      .append("rect")
      .attr("x", 1)
      .attr("transform", function (d) {
        return "translate(" + x(d.x0) + "," + y(d.length) + ")";
      })
      .attr("width", function (d) {
        return x(d.x1) - x(d.x0) - 1;
      })
      .attr("height", function (d) {
        return height - y(d.length);
      })
      .style("fill", function (d) {
        if (d.x0 < 50) {
          return "orange";
        } else {
          return "#69b3a2";
        }
      });

    svg
      .append("text")
      .attr("x", (width - 18) / 2)
      .attr("y", 0)
      .attr("text-anchor", "left")
      .style("font-size", "18px")
      .style("fill", "grey")
      .style("max-width", 400)
      .text("% Correct Responses");

    svg
      .append("text")
      .attr("class", "x label")
      .attr("text-anchor", "end")
      .attr("x", (width - 25) / 2)
      .attr("y", height + 40)
      .text("SD % of Responses Correct");

    svg
      .append("text")
      .attr("class", "y label")
      .attr("text-anchor", "end")
      .attr("x", (-1 * (height - 20)) / 2)
      .attr("y", -40)
      .attr("dy", ".75em")
      .attr("transform", "rotate(-90)")
      .text("Number of Responses");
  }
}

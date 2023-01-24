import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript } from "lightning/platformResourceLoader";
import D3 from "@salesforce/resourceUrl/d3";
import generateD3COTimeSeriesJson from "@salesforce/apex/L4LTimeSeries.generateD3COTimeSeriesJson";

/**
 * Example taken from https://www.d3-graph-gallery.com/graph/lollipop_horizontal.html
 */
export default class D3HorizontalLollipopChart extends LightningElement {
  @api recordId;
  d3Initialized = false;
  @track result = [];
  mode = "All";

  renderedCallback() {
    if (this.d3Initialized) {
      return;
    }
    this.d3Initialized = true;
    console.log("in  renderedCallback");
    loadScript(this, D3 + "/d3.v5.min.js")
      .then(() => {
        console.log("calling apex");
        return generateD3COTimeSeriesJson({
          clientId: this.recordId,
          status: "All"
        });
      })
      .then((response) => {
        console.log("calling lollipop, response=" + JSON.stringify(response));
        this.renderLineChart(response);
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

  renderLineChart(response) {
    // let data = JSON.parse(
    //   '[{"rundate":"2022-11-26","val":60},{"rundate":"2022-12-19","val":64}]'
    // );

    let datatmp = JSON.parse(response);

    let data = datatmp.map(myfunction);

    function myfunction(d) {
      return { rundate: d3.timeParse("%Y-%m-%d")(d.rundate), val: d.val };
    }

    console.log("data " + JSON.stringify(data));

    // set the dimensions and margins of the graph
    const margin = { top: 40, right: 30, bottom: 40, left: 200 },
      width = 1200 - margin.left - margin.right,
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
      .call(d3.axisBottom(x));

    // Add Y axis
    var y = d3.scaleLinear().domain([0, 160]).range([height, 0]);
    svg.append("g").call(d3.axisLeft(y));
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
      .attr("x", (width - 44) / 2)
      .attr("y", 0)
      .attr("text-anchor", "left")
      .style("font-size", "18px")
      .style("fill", "grey")
      .style("max-width", 400)
      .text(`EXPERIMENTAL - Plotting ${this.mode} Client Objectives`);

    svg
      .append("text")
      .attr("x", (width - 30) / 2)
      .attr("y", 20)
      .attr("text-anchor", "left")
      .style("font-size", "14px")
      .style("fill", "grey")
      .style("max-width", 400)
      .text("Client Objective Time Series.");

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
    generateD3COTimeSeriesJson({
      clientId: this.recordId,
      status: this.mode
    }).then((response) => {
      console.log(
        "calling generateD3COTimeSeriesJson,response=" +
          JSON.stringify(response)
      );
      this.renderLineChart(response);
    });
  }
}

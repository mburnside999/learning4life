import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript } from "lightning/platformResourceLoader";
import D3 from "@salesforce/resourceUrl/d3";
import getAvgEmployeesByType from "@salesforce/apex/D3PlaygroundController.getAvgEmployeesByType";

/**
 * Example taken from https://www.d3-graph-gallery.com/graph/lollipop_horizontal.html
 */
export default class D3HorizontalLollipopChart extends LightningElement {
  d3Initialized = false;
  selectedVar = "AvgEmployees";
  mydata;
  renderedCallback() {
    if (this.d3Initialized) {
      return;
    }
    this.d3Initialized = true;
    loadScript(this, D3 + "/d3.v5.min.js")
      .then(() => {
        return getAvgEmployeesByType();
      })
      .then((response) => {
        this.mydata = response;
        this.renderHorizontalLollipopChart(response, this.selectedVar);
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error loading D3",
            message: error.message,
            constiant: "error"
          })
        );
      });
  }

  renderHorizontalLollipopChart(data, selectedVar) {
    // set the dimensions and margins of the graph
    const margin = { top: 10, right: 30, bottom: 40, left: 200 },
      width = 760 - margin.left - margin.right,
      height = 500 - margin.top - margin.bottom;

    let svg = d3.select(
      this.template.querySelector(".horizontal-lollipop-chart")
    );
    svg.selectAll("*").remove();

    // append the svg object to the body of the page
    svg = d3
      .select(this.template.querySelector(".horizontal-lollipop-chart"))
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    // Parse the Data
    // Add X axis
    const x = d3
      .scaleLinear()
      .domain(d3.extent(data, (d) => d[selectedVar]))
      .range([0, width])
      .interpolate(d3.interpolateRound);
    svg
      .append("g")
      .attr("transform", "translate(0," + height + ")")
      .transition()
      .duration(1000)
      .call(d3.axisBottom(x))
      .selectAll("text")
      .attr("transform", "translate(-10,0)rotate(-45)")
      .style("text-anchor", "end");

    // Y axis
    const y = d3
      .scaleBand()
      .range([0, height])
      .domain(data.map((d) => d.Type))
      .padding(1);

    svg.append("g").transition().duration(1000).call(d3.axisLeft(y));

    // Lines
    svg
      .selectAll("myline")
      .data(data)
      .enter()
      .append("line")
      .transition()
      .duration(1000)
      .attr("x1", (d) => x(d[selectedVar]))
      .attr("x2", x(0))
      .attr("y1", (d) => y(d.Type))
      .attr("y2", (d) => y(d.Type))
      .attr("stroke", "grey");

    // Circles
    svg
      .selectAll("mycircle")
      .data(data)
      .enter()
      .append("circle")
      .transition()
      .duration(1000)
      .attr("cx", (d) => x(d[selectedVar]))
      .attr("cy", (d) => y(d.Type))
      .attr("r", "4")

      .style("fill", "#69b3a2")
      .attr("stroke", "black");
  }

  handleClickMax(event) {
    this.clickedButtonLabel = event.target.label;
    this.renderHorizontalLollipopChart(this.mydata, "MaxEmployees");
  }
  handleClickAvg(event) {
    this.clickedButtonLabel = event.target.label;
    this.renderHorizontalLollipopChart(this.mydata, "AvgEmployees");
  }
}

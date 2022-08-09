import { LightningElement } from "lwc";
import D3 from "@salesforce/resourceUrl/d3";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";

export default class D3ToolTipTest extends LightningElement {
  //chart dimensions
  svgWidth = 1000;
  svgHeight = 600;
  renderedCallback() {
    if (this.d3Initialized) {
      return;
    }
    this.d3Initialized = true;

    //load D3
    Promise.all([
      loadScript(this, D3 + "/d3.v5.min.js"),
      loadStyle(this, D3 + "/style.css")
    ])
      .then(() => {
        console.log("calling initializeD3()");
        this.initializeD3();
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

  initializeD3() {
    let svg = d3
      .select(this.template.querySelector("svg.d3"))
      .append("svg")
      .attr("width", 400)
      .attr("height", 400);

    // Append a circle
    svg
      .append("circle")
      .attr("id", "circleBasicTooltip")
      .attr("cx", 150)
      .attr("cy", 200)
      .attr("r", 40)
      .attr("fill", "#69b3a2")
      .on("mouseover", function () {
        return tooltip.style("visibility", "visible");
      })
      .on("mousemove", function () {
        return tooltip.style("top", 150 + "px").style("left", 200 + "px");
      })
      .on("mouseout", function () {
        return tooltip.style("visibility", "hidden");
      });

    // create a tooltip
    var tooltip = d3
      .select(this.template.querySelector("svg.d3"))
      .append("div")
      .style("position", "absolute")
      .style("visibility", "hidden")
      .text("I'm a circle!");

    //
  }
}

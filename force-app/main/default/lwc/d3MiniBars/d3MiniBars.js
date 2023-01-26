import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript } from "lightning/platformResourceLoader";
import D3 from "@salesforce/resourceUrl/d3";
import generateD3COTimeSeriesByStatusJson from "@salesforce/apex/L4LTimeSeries.generateD3COTimeSeriesByStatusJson";

/**
 * Example taken from https://www.d3-graph-gallery.com/graph/lollipop_horizontal.html
 */
export default class D3MiniBars extends LightningElement {
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
        return generateD3COTimeSeriesByStatusJson({
          clientId: this.recordId
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
    //   '[{"rundate":"2022-11-26","val":60,"status":ACQ},{"rundate":"2022-12-19","val":64,"status":"ACQ"}]'
    // );

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

    // set the dimensions and margins of the graph
    var margin = { top: 50, right: 30, bottom: 30, left: 50 },
      width = 350 - margin.left - margin.right,
      height = 300 - margin.top - margin.bottom;

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
      .call(d3.axisBottom(x).ticks(5));
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
          return Math.ceil(d.val / 50) * 50;
          //+d.val;
        })
      ])
      .range([height, 0]);
    svg.append("g").call(d3.axisLeft(y).ticks(5));

    svg
      .append("g")
      .attr("class", "grid")
      .call(make_y_gridlines().tickSize(-width).tickFormat(""));

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
      .attr("y", 20)
      .attr("text-anchor", "left")
      .style("font-size", "14px")
      .style("fill", "grey")
      .style("max-width", 800)
      .text(`Client Objective Time Series, auto refreshed Sunday 10pm`);

    // svg
    //   .append("text")
    //   .attr("x", 1170 / 2 - 150)
    //   // .attr("x", 200)
    //   .attr("y", 20)
    //   .attr("text-anchor", "left")
    //   .style("font-size", "14px")
    //   .style("fill", "grey")
    //   .style("max-width", 400)
    //   .text("Client Objective Time Series.");

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

  handleClickAll(event) {
    this.mode = "All";
    generateD3COTimeSeriesByStatusJson({
      clientId: this.recordId
    }).then((response) => {
      console.log("calling lollipop, response=" + JSON.stringify(response));
      this.renderLineChart(response);
    });
  }

  handleClickACQ(event) {
    this.mode = "ACQ";
    generateD3COTimeSeriesByStatusJson({
      clientId: this.recordId
    }).then((response) => {
      console.log("calling lollipop, response=" + JSON.stringify(response));
      this.renderLineChart(response);
    });
  }
}

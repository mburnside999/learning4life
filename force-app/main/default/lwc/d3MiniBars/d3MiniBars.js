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
const UI_EVENT_TRACKING_SCENARIO = "LWC UI: d3MiniBars";
const APEX_EVENT_TRACKING_SCENARIO = "LWC Apex: d3MiniBars";
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

    let datatmp = JSON.parse(response);
    let data = datatmp.map(myfunction);

    function make_y_gridlines() {
      return d3.axisLeft(y).ticks(10);
    }
    function make_x_gridlines() {
      return d3.axisBottom(x).ticks(10);
    }

    function myfunction(d) {
      return {
        rundate: d3.timeParse("%Y-%m-%d")(d.rundate),
        status: d.status,
        val: d.val
      };
    }

    console.log("===== testdata ====" + JSON.stringify(data));

    const margin = { top: 10, right: 100, bottom: 50, left: 50 },
      width = 1150 - margin.left - margin.right,
      height = 400 - margin.top - margin.bottom;

    console.log("cleaning  up  svg");
    // let svg = d3.select(this.template.querySelector(".d3-minibars-chart"));
    // svg.selectAll("*").remove();
    let svg = d3.select(this.template.querySelector(".my_dataviz"));
    svg.selectAll("*").remove();

    console.log("set up svg");

    svg = d3
      .select(this.template.querySelector(".my_dataviz"))
      .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", `translate(${margin.left},${margin.top})`);

    const tooltip = d3
      .select(this.template.querySelector(".my_dataviz"))
      .append("span")
      .style("opacity", 0)
      .attr("class", "tooltip")
      .style("font-size", "12px");

    const mouseover = (e, d) => {
      let _datetext = String(d.rundate);
      let _briefdate = _datetext.substring(0, 15);
      tooltip.transition().duration(600).style("opacity", 0.9);
      tooltip
        .html(
          `<span style='color:white'>${_briefdate}<br/>Status: ${d.status}<br/>Objectives: ${d.val}<br/></span>`
        )
        .style("left", d3.pointer(e)[0] + 70 + "px")
        .style("top", d3.pointer(e)[1] + 30 + "px");
    };
    const mousemove = (e) => {
      tooltip
        .style("left", d3.pointer(e)[0] + 70 + "px")
        .style("top", d3.pointer(e)[1] + 30 + "px");
    };
    const mouseleave = (e) => {
      tooltip.transition().duration(200).style("opacity", 0);
    };

    const sumstat = d3.group(data, (d) => d.status); // nest function allows to group the calculation per level of a factor

    // Add X axis --> it is a date format
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

    const y = d3
      .scaleLinear()
      .domain([
        0,
        d3.max(data, function (d) {
          return +d.val;
        })
      ])
      .range([height, 0]);
    svg.append("g").call(d3.axisLeft(y));

    const color = d3
      .scaleOrdinal()
      .range([
        "#e41a1c",
        "#377eb8",
        "#4daf4a",
        "#984ea3",
        "#ff7f00",
        "#ffff33",
        "#a65628",
        "#f781bf",
        "#999999"
      ]);

    svg
      .append("g")
      .attr("class", "grid")
      .call(make_y_gridlines().tickSize(-width).tickFormat(""));

    svg
      .selectAll(".line")
      .data(sumstat)
      .join("path")
      .attr("fill", "none")
      .attr("stroke", function (d) {
        return color(d[0]);
      })
      .attr("stroke-width", 2.5)
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
      .attr("fill", function (d) {
        return color(d.status);
      })

      .on("mouseover", mouseover)
      .on("mousemove", mousemove)
      .on("mouseleave", mouseleave);

    var legend = d3
      .select("svg")
      .selectAll("g.legend")
      .data(sumstat)
      .enter()
      .append("g")
      .attr("class", "legend");

    legend
      .append("circle")
      .attr("cx", width + margin.left + margin.right - 50)
      .attr("cy", (d, i) => i * 20 + 205)
      .attr("r", 6)
      .attr("fill", function (d) {
        return color(d[0]);
      });

    legend
      .append("text")
      .attr("x", width + margin.left + margin.right - 40)
      .attr("y", (d, i) => i * 20 + 210)
      .text(function (d) {
        console.log("+++++" + JSON.stringify(d));
        return d[0];
      });

    // svg
    //   .append("text")
    //   .attr("x", 185)
    //   .attr("y", 5)
    //   .attr("text-anchor", "middle")
    //   .text("Client Objective Status Summary")
    //   .style("fill", "black")
    //   .style("font-size", "18px")
    //   .style("font-family", "Arial Black");

    legend
      .append("text")
      .attr("x", width + margin.left + margin.right - 60)
      .attr("y", 180)
      .text("Legend")
      .style("fill", "black")
      .style("font-size", "14px");

    legend
      .append("text")
      .attr("x", width + margin.left + margin.right - 60)
      .attr("y", 190)
      .text("--------")
      .style("fill", "black")
      .style("font-size", "14px");

    //apend source
  }
}

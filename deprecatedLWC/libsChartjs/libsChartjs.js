import { LightningElement } from "lwc";
import { loadScript } from "lightning/platformResourceLoader";
import chartjs from "@salesforce/resourceUrl/chartJs";
import luxon from "@salesforce/resourceUrl/luxon";
import luxonadapter from "@salesforce/resourceUrl/luxonadapter";

export default class LibsChartjs extends LightningElement {
  error;
  chart;
  chartjsInitialized = false;

  config = {
    type: "line",
    data: {
      datasets: [
        {
          label: "First dataset",
          data: [
            {
              x: "2015-03-15T13:03:00Z",
              y: 1
            },
            {
              x: "2015-04-15T13:03:00Z",
              y: 10
            }
          ]
        }
      ]
    },
    options: {
      scales: {
        xAxes: [
          {
            type: "time",
            time: {
              unit: "month"
            }
          }
        ]
      }
    }
  };

  renderedCallback() {
    if (this.chartjsInitialized) {
      return;
    }

    Promise.all([
      loadScript(this, luxon),
      loadScript(this, luxonadapter),
      loadScript(this, chartjs)
    ])
      .then(() => {
        const canvas = document.createElement("canvas");
        this.template.querySelector("div.chart").appendChild(canvas);
        const ctx = canvas.getContext("2d");
        this.chart = new window.Chart(ctx, this.config);
      })
      .catch((error) => {
        this.error = error;
      });
  }
}

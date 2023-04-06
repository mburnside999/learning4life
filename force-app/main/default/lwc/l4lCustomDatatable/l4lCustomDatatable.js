/**************************************************************
 * @name l4lCustomDataTable
 * @author Mike Burnside
 * @date	2022
 * @group Learning For Life
 *
 * @description	non UI LWC to extend OOTB datatable to support a custom datatable for the presentation of red/yellow/green scoring logos
 */

import LightningDatatable from "lightning/datatable";
import imageTableControl from "./imageTableControl.html";

export default class L4lCustomDatatable extends LightningDatatable {
  static customTypes = {
    image: {
      template: imageTableControl
    }
  };
}

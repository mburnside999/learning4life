Webruntime.moduleRegistry.define('c/lwcpopulatesessionobjectives', ['lwc', 'force/lds', 'wire-service'], function (lwc, lds, wireService) { 'use strict';

    function tmpl($api, $cmp, $slotset, $ctx) {
      return [];
    }

    var _tmpl = lwc.registerTemplate(tmpl);
    tmpl.stylesheets = [];
    tmpl.stylesheetTokens = {
      hostAttribute: "lwc-lwcpopulatesessionobjectives_lwcpopulatesessionobjectives-host",
      shadowAttribute: "lwc-lwcpopulatesessionobjectives_lwcpopulatesessionobjectives"
    };

    const apexInvoker = lds.getApexInvoker("", "MBSessionObjectives", "getObjectives", false);
    wireService.register(apexInvoker, lds.generateGetApexWireAdapter("", "MBSessionObjectives", "getObjectives", false));

    const columns = [{
      label: 'Name',
      fieldName: 'Name',
      type: 'text'
    }, {
      label: 'Program',
      fieldName: 'Program__c',
      type: 'text'
    }];

    class Lwcpopulatesessionobjectives extends lwc.LightningElement {
      constructor(...args) {
        super(...args);
        this.recordId = 'a3N2v000003GqRzEAK';
        this.objectives = void 0;
        this.error = void 0;
        this.columns = columns;
      }

      getSelectedName(event) {
        let myselectedRows = event.detail.selectedRows;
        this.selectedRows = myselectedRows; // Display that fieldName of the selected rows
        //for (let i = 0; i < selectedRows.length; i++){
        //alert("You selected: " + selectedRows[i].Name);
        //}
      }

    }

    lwc.registerDecorators(Lwcpopulatesessionobjectives, {
      publicProps: {
        recordId: {
          config: 0
        }
      },
      wire: {
        objectives: {
          adapter: apexInvoker,
          params: {
            sess: "recordId"
          },
          static: {}
        }
      },
      track: {
        error: 1,
        columns: 1
      }
    });

    var lwcpopulatesessionobjectives = lwc.registerComponent(Lwcpopulatesessionobjectives, {
      tmpl: _tmpl
    });

    return lwcpopulatesessionobjectives;

});

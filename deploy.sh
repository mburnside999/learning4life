sfdx force:source:deploy -m "LightningComponentBundle:d3Nest,LightningComponentBundle:d3HeatMap,LightningComponentBundle:l4lCreateClientObjectives,LightningComponentBundle:l4lCreateIncidentData,LightningComponentBundle:l4lGetSetSessionObjectives,LightningComponentBundle:l4lPopulateSessionObjectives,LightningComponentBundle:l4lRelatedClientObjectives,LightningComponentBundle:l4lCustomDatatable" -u LFLHyperDevPro
sfdx force:source:deploy -m "ApexClass" -u LFLHyperDevPro --verbose -l RunLocalTests
sfdx force:source:deploy -m "ApexClass" -u LFLHyperDevPro --verbose -l RunSpecifiedTests -r TestL4LController,TestL4LSessionStatsController


sf project deploy start -m "ApexClass:L4LSessionStatsController" "ApexClass:TestL4LSessionStatsController" --target-org LFLHyperPARTIAL --test-level RunSpecifiedTests --tests TestL4LSessionStatsController        
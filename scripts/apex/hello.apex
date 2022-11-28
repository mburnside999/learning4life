// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);

L4LSessionStatsController.getD3SessionStatsHistogramData();

L4LTimeSeries x = new L4LTimeSeries();

System.debug(x.loadCOTimeSeries());

L4LTimeSeriesScheduler m = new L4LTimeSeriesScheduler();
String sch = '0 0 22 ? 1 *';
String jobID = System.schedule('Time Series Schedule', sch, m);

/**************************************************************
 * @name LFLDTDRateMaster
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description	methods to support the Rate calculations
 *
 */


public with sharing class LFLDTDRateMaster {

   /*******************************************************************************************************
   * @name getDTDRateArray
   * @description sets up a retrospective set of weekly periods, relative to today(), iterates calls to the LFLDTDRates class and returns a
   * combined JSON string 
   *
   *
   * @param clientId, the clientId
   * @param iters, the integer number of iterations (weeks) - so "4" means 4 weeks up until now

   * @return JSON string
   *
   * @example
   * String jsonStr = LFLDTDRateMaster.getDTDRateArray(clientId, 4);
   */

  @AuraEnabled(cacheable=true)
  public static String getDTDRateArray(String clientId, Integer iters) {
    String jsonStr;

    List<String> dtdRateArray = new List<String>();
    DateTime thismoment = DateTime.now();
   
    jsonStr = '[';
    for (Integer i = 0; i < iters; i++) {
      DateTime e = thismoment.addDays(-1 * 7 * i);
      DateTime s = thismoment.addDays(-1 * ((7 * i) + 14));
      System.debug('s=' + s + ', e=' + e);
      jsonStr += LFLDTDRates.getAcquisitionRateByDates(clientId, s, e);
      jsonStr += ',';
    }

    jsonStr += ']';
    String target = ',]';
    String replacement = ']';
    jsonStr = jsonStr.replace(target, replacement);

    List<LFLDTDRateMaster.RateStats> rateStatResults = (List<LFLDTDRateMaster.RateStats>) JSON.deserializeStrict(
      jsonStr,
      List<LFLDTDRateMaster.RateStats>.class
    );


    Decimal totalHours = 0;
    Integer numberAcquiredInPeriod = 0;

    for (LFLDTDRateMaster.RateStats r : rateStatResults) {
     
      totalHours += r.totalSessionDurationHrs;
      numberAcquiredInPeriod += r.numberAcquiredInPeriod;
    }

    jsonStr = '{"data":' + jsonStr;
    jsonStr += ',"duration":' + totalHours + '}';
    System.debug('jsonStr====>' + jsonStr);
    return jsonStr;
  }


/**************************************************************
 * @name LFLDTDSRateMAster.RateStats
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description	inner class to represent the structure of the returned JSON
 *
 */
  public class RateStats {
    public Decimal rate { get; set; }
    public Date startd { get; set; }
    public Date endd { get; set; }
    public Decimal elapsed { get; set; }
    public Integer startAcquiredCount { get; set; }
    public Integer endAcquiredCount { get; set; }
    public Integer numberAcquiredInPeriod { get; set; }
    public Integer sessionCount { get; set; }
    public Decimal weeks { get; set; }
    public Decimal acquiredPerSession { get; set; }
    public Decimal totalSessionDurationHrs { get; set; }
  }
}

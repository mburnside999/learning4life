public with sharing class LFLDTDRateMaster {
  @AuraEnabled(cacheable=true)
  public static String getDTDRateArray(String clientId, Integer iters) {
    String jsonStr;

    List<String> dtdRateArray = new List<String>();
    DateTime thismoment = DateTime.now();
    // DateTime firstSession = [
    //   SELECT date__c
    //   FROM session__c
    //   WHERE client__c = :clientId
    //   ORDER BY date__c
    //   LIMIT 1
    // ]
    // .date__c;
    jsonStr = '[';
    for (Integer i = 0; i < iters; i++) {
      DateTime e = thismoment.addDays(-1 * 7 * i);
      DateTime s = thismoment.addDays(-1 * ((7 * i) + 14));
      // for (Integer i = 0; i < 1000; i++) {
      //   DateTime s = firstSession.addDays(1 * 7 * i);
      //   DateTime e = firstSession.addDays(1 * ((7 * i) + 14));
      System.debug('s=' + s + ', e=' + e);
      // if (s > DateTime.now())
      //   break;
      //   dtdRateArray.add(
      //     LFLDTDRates.getAcquisitionRateByDates('0018t000002vfSfAAI', s, e)
      //   );
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

    //System.debug('====' + rateStatResults);

    Decimal totalHours = 0;
    Integer numberAcquiredInPeriod = 0;

    for (LFLDTDRateMaster.RateStats r : rateStatResults) {
      //System.debug('startd =' + r.startd);
      // System.debug('Acquired =' + r.numberAcquiredInPeriod);
      totalHours += r.totalSessionDurationHrs;
      numberAcquiredInPeriod += r.numberAcquiredInPeriod;
    }

    //System.debug('Hrs=' + totalHours + ' ,acquired==' + numberAcquiredInPeriod);

    jsonStr = '{"data":' + jsonStr;
    jsonStr += ',"duration":' + totalHours + '}';

    System.debug('jsonStr====>' + jsonStr);
    return jsonStr;
  }

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

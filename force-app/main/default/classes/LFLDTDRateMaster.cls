public with sharing class LFLDTDRateMaster {
  @AuraEnabled(cacheable=true)
  public static String getDTDRateArray(String clientId, Integer iters) {
    String jsonStr;
    List<String> dtdRateArray = new List<String>();
    DateTime thismoment = DateTime.now();
    jsonStr = '[';
    for (Integer i = 0; i < iters; i++) {
      DateTime e = thismoment.addDays(-1 * 7 * i);
      DateTime s = thismoment.addDays(-1 * ((7 * i) + 14));
      //   dtdRateArray.add(
      //     LFLDTDRates.getAcquisitionRateByDates('0018t000002vfSfAAI', s, e)
      //   );
      jsonStr += LFLDTDRates.getAcquisitionRateByDates(clientId, s, e);
      jsonStr += ',';
    }

    jsonStr += ']';
    System.debug(jsonStr);
    String target = ',]';
    String replacement = ']';
    jsonStr = jsonStr.replace(target, replacement);

    System.debug(jsonStr);

    return jsonStr;
  }
}

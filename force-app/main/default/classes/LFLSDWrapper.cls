public class LFLSDWrapper implements Comparable {
  public sd__c sd;

  // Constructor
  public LFLSDWrapper(sd__c sdin) {
    // Guard against wrapping a null
    if (sdin == null) {
      Exception ex = new NullPointerException();
      ex.setMessage('sd__c argument cannot be null');
      throw ex;
    }
    sd = sdin;
  }

  // Compare SD based on the name 
  public Integer compareTo(Object compareTo) {
    // Cast argument to LFLSDWrapper
    LFLSDWrapper compareToSD = (LFLSDWrapper) compareTo;

    // The return value of 0 indicates that both elements are equal.
    Integer returnValue = 0;
    // if (
    //   (sd.Objective_Count__c == null) &&
    //   (compareToSD.sd.Objective_Count__c == null)
    // ) {
    //   // both wrappers have null Amounts
    //   returnValue = 0;
    // } else if (sd.Objective_Count__c < compareToSD.sd.Objective_Count__c) {
    //   // Set return value to a positive value.
    //   returnValue = 1;
    // } else if (sd.Objective_Count__c > compareToSD.sd.Objective_Count__c) {
    //   // Set return value to a negative value.
    //   returnValue = -1;
    // }
    if (sd.Name > compareToSD.sd.Name) {
      // Set return value to a positive value.
      returnValue = 1;
    } else if (sd.Name < compareToSD.sd.Name) {
      // Set return value to a negative value.
      returnValue = -1;
    }
    return returnValue;
  }
}

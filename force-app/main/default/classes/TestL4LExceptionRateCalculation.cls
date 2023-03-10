@isTest
private class TestL4LExceptionRateCalculation {
  @isTest
  static void test1() {
    //L4LClientObjectiveMissingException e = new L4LClientObjectiveMissingException();
    boolean caughtexception = false;
    try {
      throw new L4LRateCalculationException('hello');
    } catch (L4LRateCalculationException e) {
      caughtexception = true;
    }
    System.assert(caughtexception);
  }
}

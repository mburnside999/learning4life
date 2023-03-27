@isTest
private class TestL4LExceptionRateCalculation {
  @isTest
  static void test1() {
    boolean caughtexception = false;
    try {
      throw new L4LRateCalculationException('hello');
    } catch (L4LRateCalculationException e) {
      caughtexception = true;
    }
    System.assert(caughtexception);
  }
}

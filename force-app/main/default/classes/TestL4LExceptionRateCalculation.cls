@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestL4LExceptionRateCalculation
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for L4LRateCalculationException
 *
 */
private class TestL4LExceptionRateCalculation {
  /*******************************************************************************************************
   * @description Test L4LClientObjectiveMissingException
   * @param void
   *
   *
   * @example
   * TestL4LExceptionRateCalculation.test1();
   */

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

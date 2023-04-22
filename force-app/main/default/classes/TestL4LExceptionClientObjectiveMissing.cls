@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestL4LExceptionClientObjectiveMissing
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for L4LClientObjectiveMissingException
 *
 */

private class TestL4LExceptionClientObjectiveMissing {
  /*******************************************************************************************************
   * @description Test L4LClientObjectiveMissingException
   * @param void
   *
   *
   * @example
   * TestL4LExceptionClientObjectiveMissing.test1();
   */

  @isTest
  static void test1() {
    //L4LClientObjectiveMissingException e = new L4LClientObjectiveMissingException();
    boolean caughtexception = false;
    try {
      throw new L4LClientObjectiveMissingException('hello');
    } catch (L4LClientObjectiveMissingException e) {
      caughtexception = true;
    }
    System.assert(caughtexception);
  }
}

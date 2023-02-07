@isTest
private class TestL4LExceptionClientObjectiveMissing {
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

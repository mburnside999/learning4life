@isTest
private class TestLFLUtil {
  @isTest
  static void testUtil() {
    Boolean response = LFLUtil.isValidJSON('{"name":"xxx"}');
    System.assert(response, 'expexted valid JSON');

    response = LFLUtil.isValidJSON('this is not JSON');
    System.assert(
      response == false,
      'this should have failed to parse as json'
    );
  }
}

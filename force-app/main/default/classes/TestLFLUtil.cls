@isTest
private class TestLFLUtil {
  @isTest
  static void testUtil() {
    Boolean response = LFLUtil.parse('{"name":"xxx"}');
    System.assert(response, 'expexted valid JSON');
  }
}

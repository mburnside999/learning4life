@isTest
private class TestLFLBackupUtil {
  @isTest
  static void testcleanup() {
    ContentVersion cv = new ContentVersion(
      Title = 'BACKUP',
      PathOnClient = 'BACKUP.zip',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    insert cv;
    cv = new ContentVersion(
      Title = 'BACKUP',
      PathOnClient = 'BACKUP.zip',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    insert cv;
    cv = new ContentVersion(
      Title = 'BACKUP',
      PathOnClient = 'BACKUP.zip',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    insert cv;
    cv = new ContentVersion(
      Title = 'BACKUP',
      PathOnClient = 'BACKUP.zip',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    insert cv;
    cv = new ContentVersion(
      Title = 'BACKUP2',
      PathOnClient = 'BACKUP2.zip',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    insert cv;
    cv = new ContentVersion(
      Title = 'BACKUP2',
      PathOnClient = 'BACKUP2.zip',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    insert cv;
    cv = new ContentVersion(
      Title = 'BACKUP2',
      PathOnClient = 'BACKUP2.zip',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    insert cv;
    cv = new ContentVersion(
      Title = 'BACKUP2',
      PathOnClient = 'BACKUP2.zip',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    insert cv;
    cv = new ContentVersion(
      Title = 'BACKUP2',
      PathOnClient = 'BACKUP2.zip',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    insert cv;

    cv = new ContentVersion(
      Title = 'BACKUP2',
      PathOnClient = 'BACKUP2.zip',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    insert cv;

    Test.startTest();
    LFLBackupUtil l = new LFLBackupUtil();
    Integer x = l.cleanupbackups();
    System.debug(x + ' backup files retained');
    System.Assert(x >= 0, 'expected at least a zero');
    Test.stopTest();
  }
}

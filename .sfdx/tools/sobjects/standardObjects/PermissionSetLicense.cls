// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class PermissionSetLicense {
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global String DeveloperName;
    global Date ExpirationDate;
    global List<GrantedByLicense> GrantedByLicenses;
    global Id Id;
    global Boolean IsDeleted;
    global String Language;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global List<PermissionSet> License;
    global String MasterLabel;
    global Boolean MaximumPermissionsAccessCMC;
    global Boolean MaximumPermissionsAccountIQUser;
    global Boolean MaximumPermissionsActivateContract;
    global Boolean MaximumPermissionsActivateOrder;
    global Boolean MaximumPermissionsActivitiesAccess;
    global Boolean MaximumPermissionsAddAnalyticsRemoteConnections;
    global Boolean MaximumPermissionsAddDirectMessageMembers;
    global Boolean MaximumPermissionsAdminAnalyticsUser;
    global Boolean MaximumPermissionsAdoptionAnalyticsUser;
    global Boolean MaximumPermissionsAllowEmailIC;
    global Boolean MaximumPermissionsAllowLightningLogin;
    global Boolean MaximumPermissionsAllowUniversalSearch;
    global Boolean MaximumPermissionsAllowViewEditConvertedLeads;
    global Boolean MaximumPermissionsAllowViewKnowledge;
    global Boolean MaximumPermissionsApexRestServices;
    global Boolean MaximumPermissionsApiEnabled;
    global Boolean MaximumPermissionsApiUserOnly;
    global Boolean MaximumPermissionsAppointmentBookingUserAccess;
    global Boolean MaximumPermissionsApproveContract;
    global Boolean MaximumPermissionsArchiveArticles;
    global Boolean MaximumPermissionsAssignPermissionSets;
    global Boolean MaximumPermissionsAssignTopics;
    global Boolean MaximumPermissionsAssignUserToSkill;
    global Boolean MaximumPermissionsAuthorApex;
    global Boolean MaximumPermissionsAutomatedDataEntry;
    global Boolean MaximumPermissionsAutomaticActivityCapture;
    global Boolean MaximumPermissionsBulkApiHardDelete;
    global Boolean MaximumPermissionsBulkMacrosAllowed;
    global Boolean MaximumPermissionsBypassEmailApproval;
    global Boolean MaximumPermissionsCampaignInfluence2;
    global Boolean MaximumPermissionsCampaignInsightsUser;
    global Boolean MaximumPermissionsCanApproveFeedPost;
    global Boolean MaximumPermissionsCanEditAnalysis;
    global Boolean MaximumPermissionsCanEditDataPrepRecipe;
    global Boolean MaximumPermissionsCanEditPrompts;
    global Boolean MaximumPermissionsCanInsertFeedSystemFields;
    global Boolean MaximumPermissionsCanManageMaps;
    global Boolean MaximumPermissionsCanRunAnalysis;
    global Boolean MaximumPermissionsCanUseNewDashboardBuilder;
    global Boolean MaximumPermissionsCanVerifyComment;
    global Boolean MaximumPermissionsChangeDashboardColors;
    global Boolean MaximumPermissionsChatterComposeUiCodesnippet;
    global Boolean MaximumPermissionsChatterEditOwnPost;
    global Boolean MaximumPermissionsChatterEditOwnRecordPost;
    global Boolean MaximumPermissionsChatterFileLink;
    global Boolean MaximumPermissionsChatterInternalUser;
    global Boolean MaximumPermissionsChatterInviteExternalUsers;
    global Boolean MaximumPermissionsChatterOwnGroups;
    global Boolean MaximumPermissionsCloseConversations;
    global Boolean MaximumPermissionsConfigCustomRecs;
    global Boolean MaximumPermissionsConfigureLiveMessage;
    global Boolean MaximumPermissionsConnectOrgToEnvironmentHub;
    global Boolean MaximumPermissionsContentAdministrator;
    global Boolean MaximumPermissionsContentHubOnPremiseUser;
    global Boolean MaximumPermissionsContentHubUser;
    global Boolean MaximumPermissionsContentWorkspaces;
    global Boolean MaximumPermissionsConvertLeads;
    global Boolean MaximumPermissionsCreateAuditFields;
    global Boolean MaximumPermissionsCreateContentSpace;
    global Boolean MaximumPermissionsCreateCustomizeDashboards;
    global Boolean MaximumPermissionsCreateCustomizeFilters;
    global Boolean MaximumPermissionsCreateCustomizeReports;
    global Boolean MaximumPermissionsCreateDashboardFolders;
    global Boolean MaximumPermissionsCreateLtngTempFolder;
    global Boolean MaximumPermissionsCreateLtngTempInPub;
    global Boolean MaximumPermissionsCreatePackaging;
    global Boolean MaximumPermissionsCreateReductionOrder;
    global Boolean MaximumPermissionsCreateReportFolders;
    global Boolean MaximumPermissionsCreateReportInLightning;
    global Boolean MaximumPermissionsCreateTopics;
    global Boolean MaximumPermissionsCreateUpdateSDDDataset;
    global Boolean MaximumPermissionsCreateUpdateSDDStory;
    global Boolean MaximumPermissionsCreateWorkBadgeDefinition;
    global Boolean MaximumPermissionsCreateWorkspaces;
    global Boolean MaximumPermissionsCustomMobileAppsAccess;
    global Boolean MaximumPermissionsCustomizeApplication;
    global Boolean MaximumPermissionsDataExport;
    global Boolean MaximumPermissionsDebugApex;
    global Boolean MaximumPermissionsDelegatedPortalUserAdmin;
    global Boolean MaximumPermissionsDelegatedTwoFactor;
    global Boolean MaximumPermissionsDeleteActivatedContract;
    global Boolean MaximumPermissionsDeleteTopics;
    global Boolean MaximumPermissionsDistributeFromPersWksp;
    global Boolean MaximumPermissionsEditActivatedOrders;
    global Boolean MaximumPermissionsEditBillingInfo;
    global Boolean MaximumPermissionsEditBrandTemplates;
    global Boolean MaximumPermissionsEditCaseComments;
    global Boolean MaximumPermissionsEditEvent;
    global Boolean MaximumPermissionsEditHtmlTemplates;
    global Boolean MaximumPermissionsEditKnowledge;
    global Boolean MaximumPermissionsEditMyDashboards;
    global Boolean MaximumPermissionsEditMyReports;
    global Boolean MaximumPermissionsEditOppLineItemUnitPrice;
    global Boolean MaximumPermissionsEditPublicDocuments;
    global Boolean MaximumPermissionsEditPublicFilters;
    global Boolean MaximumPermissionsEditPublicTemplates;
    global Boolean MaximumPermissionsEditReadonlyFields;
    global Boolean MaximumPermissionsEditTask;
    global Boolean MaximumPermissionsEditTopics;
    global Boolean MaximumPermissionsEditTranslation;
    global Boolean MaximumPermissionsEinsteinAgentUser;
    global Boolean MaximumPermissionsEinsteinArticleRecUser;
    global Boolean MaximumPermissionsEinsteinAssistantUser;
    global Boolean MaximumPermissionsEmailAdministration;
    global Boolean MaximumPermissionsEmailMass;
    global Boolean MaximumPermissionsEmailSingle;
    global Boolean MaximumPermissionsEmailTemplateManagement;
    global Boolean MaximumPermissionsEnableCommunityAppLauncher;
    global Boolean MaximumPermissionsEnableNotifications;
    global Boolean MaximumPermissionsEnableSOS;
    global Boolean MaximumPermissionsExportReport;
    global Boolean MaximumPermissionsFeedPinning;
    global Boolean MaximumPermissionsFieldServiceAccess;
    global Boolean MaximumPermissionsFieldServiceDispatcher;
    global Boolean MaximumPermissionsFieldServiceMobileApp;
    global Boolean MaximumPermissionsFieldServiceScheduling;
    global Boolean MaximumPermissionsFlowUFLRequired;
    global Boolean MaximumPermissionsForceTwoFactor;
    global Boolean MaximumPermissionsGetSmartDataDiscovery;
    global Boolean MaximumPermissionsGiveRecognitionBadge;
    global Boolean MaximumPermissionsGovernNetworks;
    global Boolean MaximumPermissionsHasUnlimitedNBAExecutions;
    global Boolean MaximumPermissionsHideReadByList;
    global Boolean MaximumPermissionsIPRestrictRequests;
    global Boolean MaximumPermissionsIdentityConnect;
    global Boolean MaximumPermissionsIdentityEnabled;
    global Boolean MaximumPermissionsImportCustomObjects;
    global Boolean MaximumPermissionsImportLeads;
    global Boolean MaximumPermissionsImportPersonal;
    global Boolean MaximumPermissionsInboundMigrationToolsUser;
    global Boolean MaximumPermissionsInsightsAppAdmin;
    global Boolean MaximumPermissionsInsightsAppDashboardEditor;
    global Boolean MaximumPermissionsInsightsAppEltEditor;
    global Boolean MaximumPermissionsInsightsAppUploadUser;
    global Boolean MaximumPermissionsInsightsAppUser;
    global Boolean MaximumPermissionsInsightsCreateApplication;
    global Boolean MaximumPermissionsInstallPackaging;
    global Boolean MaximumPermissionsLMOutboundMessagingUserPerm;
    global Boolean MaximumPermissionsLeadIQReservedUserPerm;
    global Boolean MaximumPermissionsLeadScoreUser;
    global Boolean MaximumPermissionsLightningConsoleAllowedForUser;
    global Boolean MaximumPermissionsLightningExperienceUser;
    global Boolean MaximumPermissionsLightningSchedulerUserAccess;
    global Boolean MaximumPermissionsListEmailSend;
    global Boolean MaximumPermissionsLiveMessageAgent;
    global Boolean MaximumPermissionsLtngPromoReserved01UserPerm;
    global Boolean MaximumPermissionsManageAnalyticSnapshots;
    global Boolean MaximumPermissionsManageAuthProviders;
    global Boolean MaximumPermissionsManageBusinessHourHolidays;
    global Boolean MaximumPermissionsManageCallCenters;
    global Boolean MaximumPermissionsManageCases;
    global Boolean MaximumPermissionsManageCategories;
    global Boolean MaximumPermissionsManageCertificates;
    global Boolean MaximumPermissionsManageChatterMessages;
    global Boolean MaximumPermissionsManageContentPermissions;
    global Boolean MaximumPermissionsManageContentProperties;
    global Boolean MaximumPermissionsManageContentTypes;
    global Boolean MaximumPermissionsManageCssUsers;
    global Boolean MaximumPermissionsManageCustomPermissions;
    global Boolean MaximumPermissionsManageCustomReportTypes;
    global Boolean MaximumPermissionsManageDashbdsInPubFolders;
    global Boolean MaximumPermissionsManageDataCategories;
    global Boolean MaximumPermissionsManageDataIntegrations;
    global Boolean MaximumPermissionsManageDynamicDashboards;
    global Boolean MaximumPermissionsManageEmailClientConfig;
    global Boolean MaximumPermissionsManageEncryptionKeys;
    global Boolean MaximumPermissionsManageEntitlements;
    global Boolean MaximumPermissionsManageExchangeConfig;
    global Boolean MaximumPermissionsManageHealthCheck;
    global Boolean MaximumPermissionsManageInteraction;
    global Boolean MaximumPermissionsManageInternalUsers;
    global Boolean MaximumPermissionsManageIpAddresses;
    global Boolean MaximumPermissionsManageKnowledge;
    global Boolean MaximumPermissionsManageKnowledgeImportExport;
    global Boolean MaximumPermissionsManageLeads;
    global Boolean MaximumPermissionsManageLoginAccessPolicies;
    global Boolean MaximumPermissionsManageMobile;
    global Boolean MaximumPermissionsManageNetworks;
    global Boolean MaximumPermissionsManagePartnerNetConn;
    global Boolean MaximumPermissionsManagePartners;
    global Boolean MaximumPermissionsManagePasswordPolicies;
    global Boolean MaximumPermissionsManageProfilesPermissionsets;
    global Boolean MaximumPermissionsManagePropositions;
    global Boolean MaximumPermissionsManagePvtRptsAndDashbds;
    global Boolean MaximumPermissionsManageQuotas;
    global Boolean MaximumPermissionsManageRecommendationStrategies;
    global Boolean MaximumPermissionsManageRemoteAccess;
    global Boolean MaximumPermissionsManageReportsInPubFolders;
    global Boolean MaximumPermissionsManageRoles;
    global Boolean MaximumPermissionsManageSandboxes;
    global Boolean MaximumPermissionsManageSearchPromotionRules;
    global Boolean MaximumPermissionsManageSessionPermissionSets;
    global Boolean MaximumPermissionsManageSharing;
    global Boolean MaximumPermissionsManageSmartDataDiscovery;
    global Boolean MaximumPermissionsManageSmartDataDiscoveryModel;
    global Boolean MaximumPermissionsManageSolutions;
    global Boolean MaximumPermissionsManageSubscriptions;
    global Boolean MaximumPermissionsManageSurveys;
    global Boolean MaximumPermissionsManageSynonyms;
    global Boolean MaximumPermissionsManageTemplatedApp;
    global Boolean MaximumPermissionsManageTerritories;
    global Boolean MaximumPermissionsManageTranslation;
    global Boolean MaximumPermissionsManageTwoFactor;
    global Boolean MaximumPermissionsManageUnlistedGroups;
    global Boolean MaximumPermissionsManageUsers;
    global Boolean MaximumPermissionsMassInlineEdit;
    global Boolean MaximumPermissionsMergeTopics;
    global Boolean MaximumPermissionsModerateChatter;
    global Boolean MaximumPermissionsModerateNetworkFeeds;
    global Boolean MaximumPermissionsModerateNetworkFiles;
    global Boolean MaximumPermissionsModerateNetworkMessages;
    global Boolean MaximumPermissionsModerateNetworkUsers;
    global Boolean MaximumPermissionsModifyAllData;
    global Boolean MaximumPermissionsModifyDataClassification;
    global Boolean MaximumPermissionsModifyMetadata;
    global Boolean MaximumPermissionsModifySecureAgents;
    global Boolean MaximumPermissionsMyTrailheadBranding;
    global Boolean MaximumPermissionsMyTrailheadContentAccess;
    global Boolean MaximumPermissionsMyTrailheadContentCreation;
    global Boolean MaximumPermissionsMyTrailheadCustomSteps;
    global Boolean MaximumPermissionsMyTrailheadPreviewMode;
    global Boolean MaximumPermissionsMyTrailheadReleaseMgmt;
    global Boolean MaximumPermissionsNewReportBuilder;
    global Boolean MaximumPermissionsOpportunityIQUser;
    global Boolean MaximumPermissionsOpportunityScoreUser;
    global Boolean MaximumPermissionsOptOutGeoLocationTracking;
    global Boolean MaximumPermissionsOutboundMigrationToolsUser;
    global Boolean MaximumPermissionsOverrideForecasts;
    global Boolean MaximumPermissionsPackaging2;
    global Boolean MaximumPermissionsPardotUser;
    global Boolean MaximumPermissionsPasswordNeverExpires;
    global Boolean MaximumPermissionsPortalSuperUser;
    global Boolean MaximumPermissionsPredictivePlatformAnalyze;
    global Boolean MaximumPermissionsPredictivePlatformQuery;
    global Boolean MaximumPermissionsPreventClassicExperience;
    global Boolean MaximumPermissionsPrivacyDataAccess;
    global Boolean MaximumPermissionsPublishArticles;
    global Boolean MaximumPermissionsPublishPackaging;
    global Boolean MaximumPermissionsPublishTranslation;
    global Boolean MaximumPermissionsQueryAllFiles;
    global Boolean MaximumPermissionsRecordVisibilityAPI;
    global Boolean MaximumPermissionsRemoveDirectMessageMembers;
    global Boolean MaximumPermissionsResetPasswords;
    global Boolean MaximumPermissionsRunFlow;
    global Boolean MaximumPermissionsRunReports;
    global Boolean MaximumPermissionsSalesAnalyticsUser;
    global Boolean MaximumPermissionsSalesConsole;
    global Boolean MaximumPermissionsSalesforceIQInbox;
    global Boolean MaximumPermissionsSandboxTestingInCommunityApp;
    global Boolean MaximumPermissionsScheduleJob;
    global Boolean MaximumPermissionsScheduleReports;
    global Boolean MaximumPermissionsSelectFilesFromSalesforce;
    global Boolean MaximumPermissionsSendAnnouncementEmails;
    global Boolean MaximumPermissionsSendSitRequests;
    global Boolean MaximumPermissionsShareInternalArticles;
    global Boolean MaximumPermissionsShareSmartDataDiscoveryStory;
    global Boolean MaximumPermissionsShowCompanyNameAsUserBadge;
    global Boolean MaximumPermissionsSmartDataDiscoveryForCommunity;
    global Boolean MaximumPermissionsSocialInsightsLogoAdmin;
    global Boolean MaximumPermissionsSolutionImport;
    global Boolean MaximumPermissionsStdAutomaticActivityCapture;
    global Boolean MaximumPermissionsStoryOnDSWithPredicate;
    global Boolean MaximumPermissionsSubmitForTranslation;
    global Boolean MaximumPermissionsSubmitMacrosAllowed;
    global Boolean MaximumPermissionsSubscribeDashboardRolesGrps;
    global Boolean MaximumPermissionsSubscribeDashboardToOtherUsers;
    global Boolean MaximumPermissionsSubscribeReportRolesGrps;
    global Boolean MaximumPermissionsSubscribeReportToOtherUsers;
    global Boolean MaximumPermissionsSubscribeReportsRunAsUser;
    global Boolean MaximumPermissionsSubscribeToLightningDashboards;
    global Boolean MaximumPermissionsSubscribeToLightningReports;
    global Boolean MaximumPermissionsTagManager;
    global Boolean MaximumPermissionsTestInstanceCreate;
    global Boolean MaximumPermissionsTransactionalEmailSend;
    global Boolean MaximumPermissionsTransferAnyCase;
    global Boolean MaximumPermissionsTransferAnyEntity;
    global Boolean MaximumPermissionsTransferAnyLead;
    global Boolean MaximumPermissionsTwoFactorApi;
    global Boolean MaximumPermissionsUpdateWithInactiveOwner;
    global Boolean MaximumPermissionsUseSmartDataDiscovery;
    global Boolean MaximumPermissionsUseTeamReassignWizards;
    global Boolean MaximumPermissionsUseTemplatedApp;
    global Boolean MaximumPermissionsUseWebLink;
    global Boolean MaximumPermissionsViewAllActivities;
    global Boolean MaximumPermissionsViewAllData;
    global Boolean MaximumPermissionsViewAllForecasts;
    global Boolean MaximumPermissionsViewAllUsers;
    global Boolean MaximumPermissionsViewContent;
    global Boolean MaximumPermissionsViewCustomerSentiment;
    global Boolean MaximumPermissionsViewDataAssessment;
    global Boolean MaximumPermissionsViewDataCategories;
    global Boolean MaximumPermissionsViewEncryptedData;
    global Boolean MaximumPermissionsViewEventLogFiles;
    global Boolean MaximumPermissionsViewFlowUsageAndFlowEventData;
    global Boolean MaximumPermissionsViewForecastingPredictive;
    global Boolean MaximumPermissionsViewGlobalHeader;
    global Boolean MaximumPermissionsViewHealthCheck;
    global Boolean MaximumPermissionsViewHelpLink;
    global Boolean MaximumPermissionsViewMyTeamsDashboards;
    global Boolean MaximumPermissionsViewOnlyEmbeddedAppUser;
    global Boolean MaximumPermissionsViewPrivateStaticResources;
    global Boolean MaximumPermissionsViewPublicDashboards;
    global Boolean MaximumPermissionsViewPublicReports;
    global Boolean MaximumPermissionsViewRoles;
    global Boolean MaximumPermissionsViewSetup;
    global Boolean MaximumPermissionsVoiceCoach;
    global Boolean MaximumPermissionsVoiceInbound;
    global Boolean MaximumPermissionsVoiceMinutes;
    global Boolean MaximumPermissionsVoiceOutbound;
    global Boolean MaximumPermissionsWaveManagePrivateAssetsUser;
    global Boolean MaximumPermissionsWaveTabularDownload;
    global Boolean MaximumPermissionsWaveTrendReports;
    global Boolean MaximumPermissionsWorkCalibrationUser;
    global Boolean MaximumPermissionsWorkDotComUserPerm;
    global List<PermissionSetLicenseAssign> PermissionSetLicenseAssignments;
    global String PermissionSetLicenseKey;
    global String Status;
    global Datetime SystemModstamp;
    global Integer TotalLicenses;
    global Integer UsedLicenses;

    global PermissionSetLicense () 
    {
    }
}
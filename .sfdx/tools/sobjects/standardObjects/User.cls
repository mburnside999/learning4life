// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class User {
    global String AboutMe;
    global List<AcceptedEventRelation> AcceptedEventRelations;
    global Account Account;
    global String AccountID__c;
    global Id AccountId;
    global String AccountName2__c;
    global String AccountName__c;
    global List<AccountTeamMember> AccountTeams;
    global List<AccountUserTerritory2View> AccountUserTerritory2Views;
    global String Account_Id_Formula__c;
    global List<OrderChangeEvent> ActivatedBy;
    global List<ProcessInstanceWorkitem> Actor;
    global Address Address;
    global Boolean Admin_User__c;
    global List<AgentWork__c> AgentWorkRelated__r;
    global String Alias;
    global List<Knowledge__kav> ArchivedBy;
    global List<Knowledge__kav> ArticleArchivedBy;
    global List<Knowledge__kav> ArticleCreatedBy;
    global List<Knowledge__kav> AssignedBy;
    global List<Knowledge__kav> AssignedTo;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Document> Author;
    global String BadgeText;
    global List<WorkBadge> Badges;
    global String BannerPhotoUrl;
    global String Branding_Template__c;
    global List<FieldDefinition> BusinessOwner;
    global CallCenter CallCenter;
    global Id CallCenterId;
    global List<CaseHistory__c> CaseHistoryRelated__r;
    global List<CaseTimer19__Session_Time__c> CaseTimer19__Session_Times__r;
    global List<SFDC_Channel_Account_Plan__c> Channel_Plans__r;
    global String City;
    global Boolean Closed_Credit_Account__c;
    global List<CombinedAttachment> CombinedAttachments;
    global String CommunityNickname;
    global List<OrderChangeEvent> CompanyAuthorizedBy;
    global String CompanyName;
    global List<ContractChangeEvent> CompanySigned;
    global Boolean Consumer_User__c;
    global Contact Contact;
    global Id ContactId;
    global String ContactId__c;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<ContentVersion> ContentModifiedBy;
    global List<Contract> ContractsSigned;
    global List<ConversationEntry> ConversationEntries;
    global String Country;
    global List<scrubDemo_Interaction_Analysis__c> CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global List<DeclinedEventRelation> DeclinedEventRelations;
    global String DefaultGroupNotificationFrequency;
    global List<UserChangeEvent> DelegatedApprover;
    global Id DelegatedApproverId;
    global List<User> DelegatedUsers;
    global List<SocialPost> DeletedBy;
    global List<Shipment> DeliveredToShipments;
    global String Department;
    global String DigestFrequency;
    global String Division;
    global Boolean EDY_ORGCUSTOM__DB__c;
    global String EDY_ORGCUSTOM__Old_First_Name__c;
    global String EDY_ORGCUSTOM__Old_Last_Name__c;
    global String Email;
    global String EmailEncodingKey;
    global List<EmailMessageRelation> EmailMessageRelations;
    global Boolean EmailPreferencesAutoBcc;
    global Boolean EmailPreferencesAutoBccStayInTouch;
    global Boolean EmailPreferencesStayInTouchReminder;
    global String EmployeeNumber;
    global String Employee_Number__c;
    global List<NetworkActivityAudit> EntityCreators;
    global List<ContentNotification> EntityIdentifier;
    global List<EventRelation> EventRelations;
    global List<NetworkSelfRegistration> ExecuteApexHandlerAs;
    global List<SamlSsoConfig> ExecutionUser;
    global String Extension;
    global List<ExternalDataUserAuth> ExternalDataUserAuths;
    global String External_ID__c;
    global List<FSL__UserSetting__c> FSL__User_Settings__r;
    global List<FSL__User_Territory__c> FSL__User_Territories__r;
    global String Fax;
    global String FederationIdentifier;
    global List<EntitySubscription> FeedSubscriptions;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<UserFeed> Feeds;
    global Boolean Field_Service_User__c;
    global String FirstName;
    global List<ContentVersion> FirstPublishLocation;
    global List<EmailTemplate> Folder;
    global Boolean ForecastEnabled;
    global List<ForecastingPredictionTrend> ForecastOwner;
    global List<UserRole> ForecastUser;
    global String Forecast_Doc__c;
    global String FullPhotoUrl;
    global String GeocodeAccuracy;
    global List<WorkThanks> GivenThanks;
    global List<WorkBadge> Giver;
    global List<CollaborationGroupMemberRequest> GroupMembershipRequests;
    global List<CollaborationGroupMember> GroupMemberships;
    global List<Site> GuestUser;
    global List<HR_Applicant__c> HR_Applicant_HR_Contacts__r;
    global List<HR_Applicant__c> HR_Hiring_Managers__r;
    global List<HR_Job_Requisition__c> HR_Job_Requisitions_Hiring_Manager__r;
    global List<SocialPost> HiddenBy;
    global Id Id;
    global Individual Individual;
    global Id IndividualId;
    global List<mcdm_15__MarketingCloudJourney__Feed> InsertedBy;
    global List<InstalledMobileApp> InstalledMobileApps;
    global List<CollaborationInvitation> Inviter;
    global List<PlatformAction> InvokedByUser;
    global Boolean IsActive;
    global Boolean IsExtIndicatorVisible;
    global Boolean IsPortalEnabled;
    global Boolean IsPortalSelfRegistered;
    global Boolean IsPrmSuperUser;
    global Boolean IsProfilePhotoActive;
    global Boolean Key_User__c;
    global String LanguageLocaleKey;
    global List<ProcessInstanceNode> LastActor;
    global List<FeedItem> LastEditBy;
    global Datetime LastLoginDate;
    global List<scrubDemo_Interaction_Analysis__c> LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global String LastName;
    global List<OpportunityContactRoleSuggestionInsight> LastOperationUser;
    global Datetime LastPasswordChangeDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global Double Latitude;
    global List<CampaignMember> LeadOrContactOwner;
    global Boolean Lightning_Scheduler_User__c;
    global List<LiveChatTranscriptEvent> LiveChatTranscriptEvents;
    global List<LiveAgentSession> LiveChatTranscripts;
    global List<LiveChatTranscript> Live_Chat_Transcripts__r;
    global String LocaleSidKey;
    global List<ApexLog> LogUser;
    global Double Longitude;
    global List<User> ManagedUsers;
    global List<UserProvisioningRequest> Manager;
    global Id ManagerId;
    global Id Manager_PTO__c;
    global User Manager_PTO__r;
    global String MediumBannerPhotoUrl;
    global String MediumPhotoUrl;
    global List<ContentWorkspaceMember> Member;
    global String MobilePhone;
    global String Name;
    global List<NetworkMember> NetworkMemberUsers;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToUser;
    global Integer NumberOfFailedLogins;
    global Datetime OfflinePdaTrialExpirationDate;
    global Datetime OfflineTrialExpirationDate;
    global Boolean Omni_Supervisor__c;
    global List<Opportunity> Opportunities1__r;
    global List<Opportunity> Opportunities__r;
    global List<OpportunitySplit> OpportunitySplits;
    global List<OpportunityTeamMember> OpportunityTeams;
    global List<ProcessInstanceWorkitem> OriginalActor;
    global String OutOfOfficeMessage;
    global List<OutgoingEmailRelation> OutgoingEmailRelations;
    global List<QueueRoutingConfig> OverflowAssignee;
    global List<OwnedContentDocument> OwnedContentDocuments;
    global List<pi__Pardot_Scoring_Category__c> Owner;
    global List<FeedItem> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global List<PermissionSetAssignment> PermissionSetAssignments;
    global List<PermissionSetLicenseAssign> PermissionSetLicenseAssignments;
    global List<UserEmailPreferredPerson> PersonRecord;
    global String Phone;
    global List<UserRole> PortalAccountOwner;
    global String PortalRole;
    global List<HR_Job_Requisition__c> Positions__r;
    global String PostalCode;
    global List<PendingServiceRouting> PreferredUser;
    global List<PartnerNetworkConnection> PrimaryContact;
    global Profile Profile;
    global Id ProfileId;
    global List<Milestone1_Expense__c> Project_Expenses_Incurred__r;
    global List<Milestone1_Task__c> Project_Tasks_Assigned__r;
    global List<Milestone1_Time__c> Project_Times_Incurred__r;
    global List<SecureAgent> ProxyUser;
    global List<PromptVersion> PublishedByUser;
    global List<ForecastingQuota> QuotaOwner;
    global List<User> R00N2v00000V7irkEAB;
    global List<Idea_Team__c> R00N2v00000V7ivBEAR;
    global List<Idea_Issues__c> R00N2v00000V7ivaEAB;
    global List<SFDC_Plan_Resource_Association__c> R00N2v00000V7iveEAB;
    global List<ProductTransfer> ReceivedByProductTransfers;
    global Boolean ReceivesAdminInfoEmails;
    global Boolean ReceivesInfoEmails;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global List<Group> Related;
    global List<EventRelationChangeEvent> Relation;
    global List<ReturnOrder> ReturnedBy;
    global List<EmailServicesAddress> RunAsUser;
    global List<Dashboard> RunningUser;
    global List<UserProvisioningRequest> SalesforceUser;
    global String SenderEmail;
    global String SenderName;
    global List<ServiceResource> ServiceResources;
    global List<SessionPermSetActivation> SessionPermSetActivations;
    global List<Session__c> Sessions__r;
    global List<CollaborationInvitation> SharedEntity;
    global List<UserShare> Shares;
    global Boolean Show_on_Checkin_Map__c;
    global String Signature;
    global Boolean Single_Time_Setup__c;
    global String SmallBannerPhotoUrl;
    global String SmallPhotoUrl;
    global String State;
    global String StayInTouchNote;
    global String StayInTouchSignature;
    global String StayInTouchSubject;
    global String Street;
    global List<StampAssignment> Subject;
    global List<ProcessInstance> SubmittedBy;
    global List<SurveyResponse> Submitter;
    global List<ContentUserSubscription> SubscribedToUser;
    global List<ContentUserSubscription> SubscriberUser;
    global List<SurveyInvitation> SurveyInvitations;
    global List<SurveySubject> SurveySubjectEntities;
    global List<SurveyTaker__c> Surveys_Taken__r;
    global Datetime SystemModstamp;
    global List<MessagingSession> TargetUser;
    global String Team_Doc__c;
    global String TimeZoneSidKey;
    global List<Time_Off_Info__c> Time_Off_Balances__r;
    global List<Time_Off_Request__c> Time_Off_Requests__r;
    global String Title;
    global Datetime TrialforceDate__c;
    global List<UndecidedEventRelation> UndecidedEventRelations;
    global List<VerificationHistory> User;
    global List<UserAccountTeamMember> UserAccountTeams;
    global List<UserEntityAccess> UserEntityAccessRights;
    global List<UserFieldAccess> UserFieldAccessRights;
    global List<pi__Pardot_Scoring_Category__Share> UserOrGroup;
    global Boolean UserPermissionsAvantgoUser;
    global Boolean UserPermissionsCallCenterAutoLogin;
    global Boolean UserPermissionsInteractionUser;
    global Boolean UserPermissionsKnowledgeUser;
    global Boolean UserPermissionsLiveAgentUser;
    global Boolean UserPermissionsMarketingUser;
    global Boolean UserPermissionsMobileUser;
    global Boolean UserPermissionsOfflineUser;
    global Boolean UserPermissionsSFContentUser;
    global Boolean UserPermissionsSiteforceContributorUser;
    global Boolean UserPermissionsSiteforcePublisherUser;
    global Boolean UserPermissionsSupportUser;
    global Boolean UserPermissionsWorkDotComUserFeature;
    global List<UserPreference> UserPreferences;
    global Boolean UserPreferencesActivityRemindersPopup;
    global Boolean UserPreferencesApexPagesDeveloperMode;
    global Boolean UserPreferencesCacheDiagnostics;
    global Boolean UserPreferencesContentEmailAsAndWhen;
    global Boolean UserPreferencesContentNoEmail;
    global Boolean UserPreferencesCreateLEXAppsWTShown;
    global Boolean UserPreferencesDisCommentAfterLikeEmail;
    global Boolean UserPreferencesDisMentionsCommentEmail;
    global Boolean UserPreferencesDisProfPostCommentEmail;
    global Boolean UserPreferencesDisableAllFeedsEmail;
    global Boolean UserPreferencesDisableBookmarkEmail;
    global Boolean UserPreferencesDisableChangeCommentEmail;
    global Boolean UserPreferencesDisableEndorsementEmail;
    global Boolean UserPreferencesDisableFeedbackEmail;
    global Boolean UserPreferencesDisableFileShareNotificationsForApi;
    global Boolean UserPreferencesDisableFollowersEmail;
    global Boolean UserPreferencesDisableLaterCommentEmail;
    global Boolean UserPreferencesDisableLikeEmail;
    global Boolean UserPreferencesDisableMentionsPostEmail;
    global Boolean UserPreferencesDisableMessageEmail;
    global Boolean UserPreferencesDisableProfilePostEmail;
    global Boolean UserPreferencesDisableRewardEmail;
    global Boolean UserPreferencesDisableSharePostEmail;
    global Boolean UserPreferencesDisableWorkEmail;
    global Boolean UserPreferencesEnableAutoSubForFeeds;
    global Boolean UserPreferencesEventRemindersCheckboxDefault;
    global Boolean UserPreferencesExcludeMailAppAttachments;
    global Boolean UserPreferencesFavoritesShowTopFavorites;
    global Boolean UserPreferencesFavoritesWTShown;
    global Boolean UserPreferencesGlobalNavBarWTShown;
    global Boolean UserPreferencesGlobalNavGridMenuWTShown;
    global Boolean UserPreferencesHasCelebrationBadge;
    global Boolean UserPreferencesHideBiggerPhotoCallout;
    global Boolean UserPreferencesHideCSNDesktopTask;
    global Boolean UserPreferencesHideCSNGetChatterMobileTask;
    global Boolean UserPreferencesHideChatterOnboardingSplash;
    global Boolean UserPreferencesHideEndUserOnboardingAssistantModal;
    global Boolean UserPreferencesHideLightningMigrationModal;
    global Boolean UserPreferencesHideS1BrowserUI;
    global Boolean UserPreferencesHideSecondChatterOnboardingSplash;
    global Boolean UserPreferencesHideSfxWelcomeMat;
    global Boolean UserPreferencesLightningExperiencePreferred;
    global Boolean UserPreferencesNewLightningReportRunPageEnabled;
    global Boolean UserPreferencesPathAssistantCollapsed;
    global Boolean UserPreferencesPipelineViewHideHelpPopover;
    global Boolean UserPreferencesPreviewCustomTheme;
    global Boolean UserPreferencesPreviewLightning;
    global Boolean UserPreferencesReceiveNoNotificationsAsApprover;
    global Boolean UserPreferencesReceiveNotificationsAsDelegatedApprover;
    global Boolean UserPreferencesRecordHomeReservedWTShown;
    global Boolean UserPreferencesRecordHomeSectionCollapseWTShown;
    global Boolean UserPreferencesReminderSoundOff;
    global Boolean UserPreferencesSRHOverrideActivities;
    global Boolean UserPreferencesShowCityToExternalUsers;
    global Boolean UserPreferencesShowCityToGuestUsers;
    global Boolean UserPreferencesShowCountryToExternalUsers;
    global Boolean UserPreferencesShowCountryToGuestUsers;
    global Boolean UserPreferencesShowEmailToExternalUsers;
    global Boolean UserPreferencesShowEmailToGuestUsers;
    global Boolean UserPreferencesShowFaxToExternalUsers;
    global Boolean UserPreferencesShowFaxToGuestUsers;
    global Boolean UserPreferencesShowManagerToExternalUsers;
    global Boolean UserPreferencesShowManagerToGuestUsers;
    global Boolean UserPreferencesShowMobilePhoneToExternalUsers;
    global Boolean UserPreferencesShowMobilePhoneToGuestUsers;
    global Boolean UserPreferencesShowPostalCodeToExternalUsers;
    global Boolean UserPreferencesShowPostalCodeToGuestUsers;
    global Boolean UserPreferencesShowProfilePicToGuestUsers;
    global Boolean UserPreferencesShowStateToExternalUsers;
    global Boolean UserPreferencesShowStateToGuestUsers;
    global Boolean UserPreferencesShowStreetAddressToExternalUsers;
    global Boolean UserPreferencesShowStreetAddressToGuestUsers;
    global Boolean UserPreferencesShowTitleToExternalUsers;
    global Boolean UserPreferencesShowTitleToGuestUsers;
    global Boolean UserPreferencesShowWorkPhoneToExternalUsers;
    global Boolean UserPreferencesShowWorkPhoneToGuestUsers;
    global Boolean UserPreferencesSortFeedByComment;
    global Boolean UserPreferencesSuppressEventSFXReminders;
    global Boolean UserPreferencesSuppressTaskSFXReminders;
    global Boolean UserPreferencesTaskRemindersCheckboxDefault;
    global Boolean UserPreferencesUserDebugModePref;
    global List<ProfileSkillUser> UserProfileSkillChildren;
    global List<ProfileSkillEndorsement> UserProfileSkillUserEndorsements;
    global UserRole UserRole;
    global Id UserRoleId;
    global List<Site> UserSites;
    global List<UserTeamMember> UserTeams;
    global List<UserTerritory2Association> UserTerritory2Associations;
    global String UserType;
    global List<DEMODATA__c> User__r;
    global String Username;
    global List<LoginIp> Users;
    global List<User> Users__r;
    global List<Organization> WebToCaseDefaultCreator;
    global List<Organization> WebToCaseDefaultOwner;
    global List<Organization> WebToLeadDefaultCreator;
    global List<Organization> WebToLeadDefaultOwner;
    global Double Work_com_Points__c;
    global String analyticsdemo_batch_id__c;
    global List<aqi_ltng_mng__Article_Quality__c> aqi_ltng_mng__Article_Quality_Index__r;
    global List<aqi_ltng_mng__Article_Quality__c> aqi_ltng_mng__Articles_Quality1__r;
    global List<aqi_ltng_mng__Article_Quality__c> aqi_ltng_mng__Articles_Quality2__r;
    global List<aqi_ltng_mng__Article_Quality__c> aqi_ltng_mng__Articles_Quality3__r;
    global List<aqi_ltng_mng__Article_Quality__c> aqi_ltng_mng__Articles_Quality__r;
    global List<artfeed__Article_Feedback__c> artfeed__Article_Feedbacks__r;
    global List<ccrz__E_Invoice__c> ccrz__CCInvoices__r;
    global List<ccrz__E_Subscription__c> ccrz__CCSubscriptions__r;
    global List<ccrz__E_AccountAddressBook__c> ccrz__CC_Account_Address_Books__r;
    global List<ccrz__E_AddressBook__c> ccrz__CC_Address_Books__r;
    global String ccrz__CC_CurrencyCode__c;
    global List<ccrz__E_StoredPayment__c> ccrz__CC_Stored_Payments__r;
    global String ccrz__CompanyType__c;
    global String ccrz__ContactTypeRole__c;
    global String ccrz__DataId__c;
    global List<ccrz__E_Cart__c> ccrz__E_Carts__r;
    global List<ccrz__E_Order__c> ccrz__E_Orders__r;
    global List<ccrz__E_RecentItem__c> ccrz__E_RECENT_ITEMS__r;
    global List<ccrz__E_Review__c> ccrz__E_Reviews__r;
    global List<ccrz__L_Exception__c> ccrz__G2WExceptions__r;
    global List<ccrz__E_ReviewLike__c> ccrz__Review_Helpful__r;
    global List<ccrz__E_Seller__c> ccrz__SellerReps__r;
    global Boolean ccrz__Tax_Exempt__c;
    global List<ccrz__E_TransactionPayment__c> ccrz__TransactionPayments__r;
    global List<ccrz__E_UserInventoryLocation__c> ccrz__UserInventoryLocation__r;
    global String ccrz__User_Industry__c;
    global String ccrz__User_Salutation__c;
    global String et4ae5__Default_ET_Page__c;
    global String et4ae5__Default_MID__c;
    global Boolean et4ae5__ExactTargetForAppExchangeAdmin__c;
    global Boolean et4ae5__ExactTargetForAppExchangeUser__c;
    global String et4ae5__ExactTargetUsername__c;
    global String et4ae5__ExactTarget_OAuth_Token__c;
    global List<et4ae5__SMSDefinition__c> et4ae5__Mobile_Sends__r;
    global Boolean et4ae5__ValidExactTargetAdmin__c;
    global Boolean et4ae5__ValidExactTargetUser__c;
    global List<mcdm_15__ApprovalsPageSettings__c> mcdm_15__User__r;
    global Boolean pi__Can_View_Not_Assigned_Prospects__c;
    global List<pi__EngageCampaignRecipient__c> pi__EngageCampaign_User__r;
    global List<pi__LDFilter__c> pi__Lead_Deck_Filters__r;
    global String pi__Pardot_Api_Key__c;
    global String pi__Pardot_Api_Version__c;
    global String pi__Pardot_User_Id__c;
    global String pi__Pardot_User_Key__c;
    global String pi__Pardot_User_Role__c;
    global Id sales_management__c;
    global User sales_management__r;

    global User () 
    {
    }
}
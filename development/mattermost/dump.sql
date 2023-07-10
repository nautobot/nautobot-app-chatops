
/*!40000 DROP DATABASE IF EXISTS `mattermost_test`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mattermost_test` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `mattermost_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Audits` (
  `Id` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UserId` varchar(26) DEFAULT NULL,
  `Action` text,
  `ExtraInfo` text,
  `IpAddress` varchar(64) DEFAULT NULL,
  `SessionId` varchar(26) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_audits_user_id` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Bots` (
  `UserId` varchar(26) NOT NULL,
  `Description` text,
  `OwnerId` varchar(190) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `LastIconUpdate` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ChannelMemberHistory` (
  `ChannelId` varchar(26) NOT NULL,
  `UserId` varchar(26) NOT NULL,
  `JoinTime` bigint(20) NOT NULL,
  `LeaveTime` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ChannelId`,`UserId`,`JoinTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ChannelMembers` (
  `ChannelId` varchar(26) NOT NULL,
  `UserId` varchar(26) NOT NULL,
  `Roles` text,
  `LastViewedAt` bigint(20) DEFAULT NULL,
  `MsgCount` bigint(20) DEFAULT NULL,
  `MentionCount` bigint(20) DEFAULT NULL,
  `NotifyProps` json DEFAULT NULL,
  `LastUpdateAt` bigint(20) DEFAULT NULL,
  `SchemeUser` tinyint(4) DEFAULT NULL,
  `SchemeAdmin` tinyint(4) DEFAULT NULL,
  `SchemeGuest` tinyint(4) DEFAULT NULL,
  `MentionCountRoot` bigint(20) DEFAULT NULL,
  `MsgCountRoot` bigint(20) DEFAULT NULL,
  `UrgentMentionCount` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ChannelId`,`UserId`),
  KEY `idx_channelmembers_user_id_channel_id_last_viewed_at` (`UserId`,`ChannelId`,`LastViewedAt`),
  KEY `idx_channelmembers_channel_id_scheme_guest_user_id` (`ChannelId`,`SchemeGuest`,`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Channels` (
  `Id` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `TeamId` varchar(26) DEFAULT NULL,
  `Type` enum('D','O','G','P') DEFAULT NULL,
  `DisplayName` varchar(64) DEFAULT NULL,
  `Name` varchar(64) DEFAULT NULL,
  `Header` text,
  `Purpose` varchar(250) DEFAULT NULL,
  `LastPostAt` bigint(20) DEFAULT NULL,
  `TotalMsgCount` bigint(20) DEFAULT NULL,
  `ExtraUpdateAt` bigint(20) DEFAULT NULL,
  `CreatorId` varchar(26) DEFAULT NULL,
  `SchemeId` varchar(26) DEFAULT NULL,
  `GroupConstrained` tinyint(1) DEFAULT NULL,
  `Shared` tinyint(1) DEFAULT NULL,
  `TotalMsgCountRoot` bigint(20) DEFAULT NULL,
  `LastRootPostAt` bigint(20) DEFAULT '0',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Name` (`Name`,`TeamId`),
  KEY `idx_channels_update_at` (`UpdateAt`),
  KEY `idx_channels_create_at` (`CreateAt`),
  KEY `idx_channels_delete_at` (`DeleteAt`),
  KEY `idx_channels_scheme_id` (`SchemeId`),
  KEY `idx_channels_team_id_display_name` (`TeamId`,`DisplayName`),
  KEY `idx_channels_team_id_type` (`TeamId`,`Type`),
  FULLTEXT KEY `idx_channel_search_txt` (`Name`,`DisplayName`,`Purpose`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ClusterDiscovery` (
  `Id` varchar(26) NOT NULL,
  `Type` varchar(64) DEFAULT NULL,
  `ClusterName` varchar(64) DEFAULT NULL,
  `Hostname` text,
  `GossipPort` int(11) DEFAULT NULL,
  `Port` int(11) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `LastPingAt` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CommandWebhooks` (
  `Id` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `CommandId` varchar(26) DEFAULT NULL,
  `UserId` varchar(26) DEFAULT NULL,
  `ChannelId` varchar(26) DEFAULT NULL,
  `RootId` varchar(26) DEFAULT NULL,
  `UseCount` int(11) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_command_webhook_create_at` (`CreateAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Commands` (
  `Id` varchar(26) NOT NULL,
  `Token` varchar(26) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `CreatorId` varchar(26) DEFAULT NULL,
  `TeamId` varchar(26) DEFAULT NULL,
  `Trigger` varchar(128) DEFAULT NULL,
  `Method` varchar(1) DEFAULT NULL,
  `Username` varchar(64) DEFAULT NULL,
  `IconURL` text,
  `AutoComplete` tinyint(1) DEFAULT NULL,
  `AutoCompleteDesc` text,
  `AutoCompleteHint` text,
  `DisplayName` varchar(64) DEFAULT NULL,
  `Description` varchar(128) DEFAULT NULL,
  `URL` text,
  `PluginId` varchar(190) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_command_team_id` (`TeamId`),
  KEY `idx_command_update_at` (`UpdateAt`),
  KEY `idx_command_create_at` (`CreateAt`),
  KEY `idx_command_delete_at` (`DeleteAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Compliances` (
  `Id` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UserId` varchar(26) DEFAULT NULL,
  `Status` varchar(64) DEFAULT NULL,
  `Count` int(11) DEFAULT NULL,
  `Desc` text,
  `Type` varchar(64) DEFAULT NULL,
  `StartAt` bigint(20) DEFAULT NULL,
  `EndAt` bigint(20) DEFAULT NULL,
  `Keywords` text,
  `Emails` text,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Drafts` (
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `UserId` varchar(26) NOT NULL,
  `ChannelId` varchar(26) NOT NULL,
  `RootId` varchar(26) NOT NULL DEFAULT '',
  `Message` text,
  `Props` text,
  `FileIds` text,
  `Priority` text,
  PRIMARY KEY (`UserId`,`ChannelId`,`RootId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Emoji` (
  `Id` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `CreatorId` varchar(26) DEFAULT NULL,
  `Name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Name` (`Name`,`DeleteAt`),
  KEY `idx_emoji_update_at` (`UpdateAt`),
  KEY `idx_emoji_create_at` (`CreateAt`),
  KEY `idx_emoji_delete_at` (`DeleteAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FileInfo` (
  `Id` varchar(26) NOT NULL,
  `CreatorId` varchar(26) DEFAULT NULL,
  `PostId` varchar(26) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `Path` text,
  `ThumbnailPath` text,
  `PreviewPath` text,
  `Name` text,
  `Extension` varchar(64) DEFAULT NULL,
  `Size` bigint(20) DEFAULT NULL,
  `MimeType` text,
  `Width` int(11) DEFAULT NULL,
  `Height` int(11) DEFAULT NULL,
  `HasPreviewImage` tinyint(1) DEFAULT NULL,
  `MiniPreview` mediumblob,
  `Content` longtext,
  `RemoteId` varchar(26) DEFAULT NULL,
  `Archived` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  KEY `idx_fileinfo_update_at` (`UpdateAt`),
  KEY `idx_fileinfo_create_at` (`CreateAt`),
  KEY `idx_fileinfo_delete_at` (`DeleteAt`),
  KEY `idx_fileinfo_postid_at` (`PostId`),
  KEY `idx_fileinfo_extension_at` (`Extension`),
  FULLTEXT KEY `idx_fileinfo_name_txt` (`Name`),
  FULLTEXT KEY `idx_fileinfo_content_txt` (`Content`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GroupChannels` (
  `GroupId` varchar(26) NOT NULL,
  `AutoAdd` tinyint(1) DEFAULT NULL,
  `SchemeAdmin` tinyint(1) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `ChannelId` varchar(26) NOT NULL,
  PRIMARY KEY (`GroupId`,`ChannelId`),
  KEY `idx_groupchannels_schemeadmin` (`SchemeAdmin`),
  KEY `idx_groupchannels_channelid` (`ChannelId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GroupMembers` (
  `GroupId` varchar(26) NOT NULL,
  `UserId` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`GroupId`,`UserId`),
  KEY `idx_groupmembers_create_at` (`CreateAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GroupTeams` (
  `GroupId` varchar(26) NOT NULL,
  `AutoAdd` tinyint(1) DEFAULT NULL,
  `SchemeAdmin` tinyint(1) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `TeamId` varchar(26) NOT NULL,
  PRIMARY KEY (`GroupId`,`TeamId`),
  KEY `idx_groupteams_schemeadmin` (`SchemeAdmin`),
  KEY `idx_groupteams_teamid` (`TeamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_Category` (
  `ID` varchar(26) NOT NULL,
  `Name` varchar(512) NOT NULL,
  `TeamID` varchar(26) NOT NULL,
  `UserID` varchar(26) NOT NULL,
  `Collapsed` tinyint(1) DEFAULT '0',
  `CreateAt` bigint(20) NOT NULL,
  `UpdateAt` bigint(20) NOT NULL DEFAULT '0',
  `DeleteAt` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `IR_Category_TeamID_UserID` (`TeamID`,`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_Category_Item` (
  `Type` varchar(1) NOT NULL,
  `CategoryID` varchar(26) NOT NULL,
  `ItemID` varchar(26) NOT NULL,
  PRIMARY KEY (`CategoryID`,`ItemID`,`Type`),
  KEY `IR_Category_Item_CategoryID` (`CategoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_ChannelAction` (
  `ID` varchar(26) NOT NULL,
  `ChannelID` varchar(26) DEFAULT NULL,
  `Enabled` tinyint(1) DEFAULT '0',
  `DeleteAt` bigint(20) NOT NULL DEFAULT '0',
  `ActionType` text NOT NULL,
  `TriggerType` text NOT NULL,
  `Payload` json NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `IR_ChannelAction_ChannelID` (`ChannelID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_Incident` (
  `ID` varchar(26) NOT NULL,
  `Name` varchar(1024) NOT NULL,
  `Description` varchar(4096) NOT NULL,
  `IsActive` tinyint(1) NOT NULL,
  `CommanderUserID` varchar(26) NOT NULL,
  `TeamID` varchar(26) NOT NULL,
  `ChannelID` varchar(26) NOT NULL,
  `CreateAt` bigint(20) NOT NULL,
  `EndAt` bigint(20) NOT NULL DEFAULT '0',
  `DeleteAt` bigint(20) NOT NULL DEFAULT '0',
  `ActiveStage` bigint(20) NOT NULL,
  `PostID` varchar(26) NOT NULL DEFAULT '',
  `PlaybookID` varchar(26) NOT NULL DEFAULT '',
  `ChecklistsJSON` text NOT NULL,
  `ActiveStageTitle` varchar(1024) DEFAULT '',
  `ReminderPostID` varchar(26) DEFAULT NULL,
  `BroadcastChannelID` varchar(26) DEFAULT '',
  `PreviousReminder` bigint(20) NOT NULL DEFAULT '0',
  `ReminderMessageTemplate` text,
  `CurrentStatus` varchar(1024) NOT NULL DEFAULT 'Active',
  `ReporterUserID` varchar(26) NOT NULL DEFAULT '',
  `ConcatenatedInvitedUserIDs` text,
  `DefaultCommanderID` varchar(26) DEFAULT '',
  `AnnouncementChannelID` varchar(26) DEFAULT '',
  `ConcatenatedWebhookOnCreationURLs` text,
  `ConcatenatedInvitedGroupIDs` text,
  `Retrospective` text,
  `MessageOnJoin` text,
  `RetrospectivePublishedAt` bigint(20) NOT NULL DEFAULT '0',
  `RetrospectiveReminderIntervalSeconds` bigint(20) NOT NULL DEFAULT '0',
  `RetrospectiveWasCanceled` tinyint(1) DEFAULT '0',
  `ConcatenatedWebhookOnStatusUpdateURLs` text,
  `LastStatusUpdateAt` bigint(20) DEFAULT '0',
  `ExportChannelOnFinishedEnabled` tinyint(1) NOT NULL DEFAULT '0',
  `CategorizeChannelEnabled` tinyint(1) DEFAULT '0',
  `CategoryName` text,
  `ConcatenatedBroadcastChannelIds` text,
  `ChannelIDToRootID` text,
  `ReminderTimerDefaultSeconds` bigint(20) NOT NULL DEFAULT '0',
  `StatusUpdateEnabled` tinyint(1) DEFAULT '1',
  `RetrospectiveEnabled` tinyint(1) DEFAULT '1',
  `StatusUpdateBroadcastChannelsEnabled` tinyint(1) DEFAULT '0',
  `StatusUpdateBroadcastWebhooksEnabled` tinyint(1) DEFAULT '0',
  `SummaryModifiedAt` bigint(20) NOT NULL DEFAULT '0',
  `CreateChannelMemberOnNewParticipant` tinyint(1) DEFAULT '1',
  `RemoveChannelMemberOnRemovedParticipant` tinyint(1) DEFAULT '1',
  `RunType` varchar(32) DEFAULT 'playbook',
  `WebhookOnCreationURL` text,
  `WebhookOnStatusUpdateURL` text,
  `ExportChannelOnArchiveEnabled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `IR_Incident_TeamID` (`TeamID`),
  KEY `IR_Incident_TeamID_CommanderUserID` (`TeamID`,`CommanderUserID`),
  KEY `IR_Incident_ChannelID` (`ChannelID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_Metric` (
  `IncidentID` varchar(26) NOT NULL,
  `MetricConfigID` varchar(26) NOT NULL,
  `Value` bigint(20) DEFAULT NULL,
  `Published` tinyint(1) NOT NULL,
  PRIMARY KEY (`IncidentID`,`MetricConfigID`),
  KEY `IR_Metric_IncidentID` (`IncidentID`),
  KEY `IR_Metric_MetricConfigID` (`MetricConfigID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_MetricConfig` (
  `ID` varchar(26) NOT NULL,
  `PlaybookID` varchar(26) NOT NULL,
  `Title` varchar(512) NOT NULL,
  `Description` varchar(4096) NOT NULL,
  `Type` varchar(32) NOT NULL,
  `Target` bigint(20) DEFAULT NULL,
  `Ordering` tinyint(4) NOT NULL DEFAULT '0',
  `DeleteAt` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `IR_MetricConfig_PlaybookID` (`PlaybookID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_Playbook` (
  `ID` varchar(26) NOT NULL,
  `Title` varchar(1024) NOT NULL,
  `Description` varchar(4096) NOT NULL,
  `TeamID` varchar(26) NOT NULL,
  `CreatePublicIncident` tinyint(1) NOT NULL,
  `CreateAt` bigint(20) NOT NULL,
  `DeleteAt` bigint(20) NOT NULL DEFAULT '0',
  `ChecklistsJSON` text NOT NULL,
  `NumStages` bigint(20) NOT NULL DEFAULT '0',
  `NumSteps` bigint(20) NOT NULL DEFAULT '0',
  `BroadcastChannelID` varchar(26) DEFAULT '',
  `ReminderMessageTemplate` text,
  `ReminderTimerDefaultSeconds` bigint(20) NOT NULL DEFAULT '0',
  `ConcatenatedInvitedUserIDs` text,
  `InviteUsersEnabled` tinyint(1) DEFAULT '0',
  `DefaultCommanderID` varchar(26) DEFAULT '',
  `DefaultCommanderEnabled` tinyint(1) DEFAULT '0',
  `AnnouncementChannelID` varchar(26) DEFAULT '',
  `AnnouncementChannelEnabled` tinyint(1) DEFAULT '0',
  `ConcatenatedWebhookOnCreationURLs` text,
  `WebhookOnCreationEnabled` tinyint(1) DEFAULT '0',
  `ConcatenatedInvitedGroupIDs` text,
  `MessageOnJoin` text,
  `MessageOnJoinEnabled` tinyint(1) DEFAULT '0',
  `RetrospectiveReminderIntervalSeconds` bigint(20) NOT NULL DEFAULT '0',
  `RetrospectiveTemplate` text,
  `ConcatenatedWebhookOnStatusUpdateURLs` text,
  `WebhookOnStatusUpdateEnabled` tinyint(1) DEFAULT '0',
  `ConcatenatedSignalAnyKeywords` text,
  `SignalAnyKeywordsEnabled` tinyint(1) DEFAULT '0',
  `UpdateAt` bigint(20) NOT NULL DEFAULT '0',
  `ExportChannelOnFinishedEnabled` tinyint(1) NOT NULL DEFAULT '0',
  `CategorizeChannelEnabled` tinyint(1) DEFAULT '0',
  `CategoryName` text,
  `ConcatenatedBroadcastChannelIds` text,
  `BroadcastEnabled` tinyint(1) DEFAULT '0',
  `RunSummaryTemplate` text,
  `ChannelNameTemplate` text,
  `StatusUpdateEnabled` tinyint(1) DEFAULT '1',
  `RetrospectiveEnabled` tinyint(1) DEFAULT '1',
  `Public` tinyint(1) DEFAULT '0',
  `RunSummaryTemplateEnabled` tinyint(1) DEFAULT '1',
  `CreateChannelMemberOnNewParticipant` tinyint(1) DEFAULT '1',
  `RemoveChannelMemberOnRemovedParticipant` tinyint(1) DEFAULT '1',
  `ChannelID` varchar(26) DEFAULT '',
  `ChannelMode` varchar(32) DEFAULT 'create_new_channel',
  `WebhookOnCreationURL` text,
  `WebhookOnStatusUpdateURL` text,
  `ExportChannelOnArchiveEnabled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `IR_Playbook_TeamID` (`TeamID`),
  KEY `IR_PlaybookMember_PlaybookID` (`ID`),
  KEY `IR_Playbook_UpdateAt` (`UpdateAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_PlaybookAutoFollow` (
  `PlaybookID` varchar(26) NOT NULL,
  `UserID` varchar(26) NOT NULL,
  PRIMARY KEY (`PlaybookID`,`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_PlaybookMember` (
  `PlaybookID` varchar(26) NOT NULL,
  `MemberID` varchar(26) NOT NULL,
  `Roles` text,
  PRIMARY KEY (`MemberID`,`PlaybookID`),
  KEY `IR_PlaybookMember_PlaybookID` (`PlaybookID`),
  KEY `IR_PlaybookMember_MemberID` (`MemberID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_Run_Participants` (
  `IncidentID` varchar(26) NOT NULL,
  `UserID` varchar(26) NOT NULL,
  `IsFollower` tinyint(1) NOT NULL DEFAULT '0',
  `IsParticipant` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`IncidentID`,`UserID`),
  KEY `IR_Run_Participants_UserID` (`UserID`),
  KEY `IR_Run_Participants_IncidentID` (`IncidentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_StatusPosts` (
  `IncidentID` varchar(26) NOT NULL,
  `PostID` varchar(26) NOT NULL,
  PRIMARY KEY (`IncidentID`,`PostID`),
  KEY `IR_StatusPosts_IncidentID` (`IncidentID`),
  KEY `IR_StatusPosts_PostID` (`PostID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_System` (
  `SKey` varchar(64) NOT NULL,
  `SValue` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`SKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_TimelineEvent` (
  `ID` varchar(26) NOT NULL,
  `IncidentID` varchar(26) NOT NULL,
  `CreateAt` bigint(20) NOT NULL,
  `DeleteAt` bigint(20) NOT NULL DEFAULT '0',
  `EventAt` bigint(20) NOT NULL,
  `EventType` varchar(32) NOT NULL DEFAULT '',
  `Summary` varchar(256) NOT NULL DEFAULT '',
  `Details` varchar(4096) NOT NULL DEFAULT '',
  `PostID` varchar(26) NOT NULL DEFAULT '',
  `SubjectUserID` varchar(26) NOT NULL DEFAULT '',
  `CreatorUserID` varchar(26) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `IR_TimelineEvent_ID` (`ID`),
  KEY `IR_TimelineEvent_IncidentID` (`IncidentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_UserInfo` (
  `ID` varchar(26) NOT NULL,
  `LastDailyTodoDMAt` bigint(20) DEFAULT NULL,
  `DigestNotificationSettingsJSON` json DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_ViewedChannel` (
  `ChannelID` varchar(26) NOT NULL,
  `UserID` varchar(26) NOT NULL,
  PRIMARY KEY (`ChannelID`,`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IncomingWebhooks` (
  `Id` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `UserId` varchar(26) DEFAULT NULL,
  `ChannelId` varchar(26) DEFAULT NULL,
  `TeamId` varchar(26) DEFAULT NULL,
  `DisplayName` varchar(64) DEFAULT NULL,
  `Description` text,
  `Username` varchar(255) DEFAULT NULL,
  `IconURL` text,
  `ChannelLocked` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_incoming_webhook_user_id` (`UserId`),
  KEY `idx_incoming_webhook_team_id` (`TeamId`),
  KEY `idx_incoming_webhook_update_at` (`UpdateAt`),
  KEY `idx_incoming_webhook_create_at` (`CreateAt`),
  KEY `idx_incoming_webhook_delete_at` (`DeleteAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Jobs` (
  `Id` varchar(26) NOT NULL,
  `Type` varchar(32) DEFAULT NULL,
  `Priority` bigint(20) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `StartAt` bigint(20) DEFAULT NULL,
  `LastActivityAt` bigint(20) DEFAULT NULL,
  `Status` varchar(32) DEFAULT NULL,
  `Progress` bigint(20) DEFAULT NULL,
  `Data` json DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_jobs_type` (`Type`),
  KEY `idx_jobs_status_type` (`Status`,`Type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Licenses` (
  `Id` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `Bytes` text,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LinkMetadata` (
  `Hash` bigint(20) NOT NULL,
  `URL` text,
  `Timestamp` bigint(20) DEFAULT NULL,
  `Type` varchar(16) DEFAULT NULL,
  `Data` json DEFAULT NULL,
  PRIMARY KEY (`Hash`),
  KEY `idx_link_metadata_url_timestamp` (`URL`(512),`Timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `NotifyAdmin` (
  `UserId` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `RequiredPlan` varchar(100) NOT NULL,
  `RequiredFeature` varchar(255) NOT NULL,
  `Trial` tinyint(1) NOT NULL,
  `SentAt` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`UserId`,`RequiredFeature`,`RequiredPlan`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OAuthAccessData` (
  `Token` varchar(26) NOT NULL,
  `RefreshToken` varchar(26) DEFAULT NULL,
  `RedirectUri` text,
  `ClientId` varchar(26) DEFAULT NULL,
  `UserId` varchar(26) DEFAULT NULL,
  `ExpiresAt` bigint(20) DEFAULT NULL,
  `Scope` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`Token`),
  UNIQUE KEY `ClientId` (`ClientId`,`UserId`),
  KEY `idx_oauthaccessdata_user_id` (`UserId`),
  KEY `idx_oauthaccessdata_refresh_token` (`RefreshToken`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OAuthApps` (
  `Id` varchar(26) NOT NULL,
  `CreatorId` varchar(26) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `ClientSecret` varchar(128) DEFAULT NULL,
  `Name` varchar(64) DEFAULT NULL,
  `Description` text,
  `CallbackUrls` text,
  `Homepage` text,
  `IsTrusted` tinyint(1) DEFAULT NULL,
  `IconURL` text,
  `MattermostAppID` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`Id`),
  KEY `idx_oauthapps_creator_id` (`CreatorId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OAuthAuthData` (
  `ClientId` varchar(26) DEFAULT NULL,
  `UserId` varchar(26) DEFAULT NULL,
  `Code` varchar(128) NOT NULL,
  `ExpiresIn` int(11) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `RedirectUri` text,
  `State` text,
  `Scope` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`Code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OutgoingWebhooks` (
  `Id` varchar(26) NOT NULL,
  `Token` varchar(26) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `CreatorId` varchar(26) DEFAULT NULL,
  `ChannelId` varchar(26) DEFAULT NULL,
  `TeamId` varchar(26) DEFAULT NULL,
  `TriggerWords` text,
  `CallbackURLs` text,
  `DisplayName` varchar(64) DEFAULT NULL,
  `ContentType` varchar(128) DEFAULT NULL,
  `TriggerWhen` int(11) DEFAULT NULL,
  `Username` varchar(64) DEFAULT NULL,
  `IconURL` text,
  `Description` text,
  PRIMARY KEY (`Id`),
  KEY `idx_outgoing_webhook_team_id` (`TeamId`),
  KEY `idx_outgoing_webhook_update_at` (`UpdateAt`),
  KEY `idx_outgoing_webhook_create_at` (`CreateAt`),
  KEY `idx_outgoing_webhook_delete_at` (`DeleteAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PluginKeyValueStore` (
  `PluginId` varchar(190) NOT NULL,
  `PKey` varchar(150) NOT NULL,
  `PValue` mediumblob,
  `ExpireAt` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PluginId`,`PKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PostAcknowledgements` (
  `PostId` varchar(26) NOT NULL,
  `UserId` varchar(26) NOT NULL,
  `AcknowledgedAt` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PostId`,`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PostReminders` (
  `PostId` varchar(26) NOT NULL,
  `UserId` varchar(26) NOT NULL,
  `TargetTime` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PostId`,`UserId`),
  KEY `idx_postreminders_targettime` (`TargetTime`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Posts` (
  `Id` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `UserId` varchar(26) DEFAULT NULL,
  `ChannelId` varchar(26) DEFAULT NULL,
  `RootId` varchar(26) DEFAULT NULL,
  `OriginalId` varchar(26) DEFAULT NULL,
  `Message` text,
  `Type` varchar(26) DEFAULT NULL,
  `Props` json DEFAULT NULL,
  `Hashtags` text,
  `Filenames` text,
  `FileIds` text,
  `HasReactions` tinyint(1) DEFAULT NULL,
  `EditAt` bigint(20) DEFAULT NULL,
  `IsPinned` tinyint(1) DEFAULT NULL,
  `RemoteId` varchar(26) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_posts_update_at` (`UpdateAt`),
  KEY `idx_posts_create_at` (`CreateAt`),
  KEY `idx_posts_delete_at` (`DeleteAt`),
  KEY `idx_posts_user_id` (`UserId`),
  KEY `idx_posts_is_pinned` (`IsPinned`),
  KEY `idx_posts_channel_id_update_at` (`ChannelId`,`UpdateAt`),
  KEY `idx_posts_channel_id_delete_at_create_at` (`ChannelId`,`DeleteAt`,`CreateAt`),
  KEY `idx_posts_root_id_delete_at` (`RootId`,`DeleteAt`),
  KEY `idx_posts_create_at_id` (`CreateAt`,`Id`),
  KEY `idx_posts_original_id` (`OriginalId`),
  FULLTEXT KEY `idx_posts_message_txt` (`Message`),
  FULLTEXT KEY `idx_posts_hashtags_txt` (`Hashtags`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PostsPriority` (
  `PostId` varchar(26) NOT NULL,
  `ChannelId` varchar(26) NOT NULL,
  `Priority` varchar(32) NOT NULL,
  `RequestedAck` tinyint(1) DEFAULT NULL,
  `PersistentNotifications` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`PostId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Preferences` (
  `UserId` varchar(26) NOT NULL,
  `Category` varchar(32) NOT NULL,
  `Name` varchar(32) NOT NULL,
  `Value` text,
  PRIMARY KEY (`UserId`,`Category`,`Name`),
  KEY `idx_preferences_category` (`Category`),
  KEY `idx_preferences_name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProductNoticeViewState` (
  `UserId` varchar(26) NOT NULL,
  `NoticeId` varchar(26) NOT NULL,
  `Viewed` int(11) DEFAULT NULL,
  `Timestamp` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`UserId`,`NoticeId`),
  KEY `idx_notice_views_timestamp` (`Timestamp`),
  KEY `idx_notice_views_notice_id` (`NoticeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PublicChannels` (
  `Id` varchar(26) NOT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `TeamId` varchar(26) DEFAULT NULL,
  `DisplayName` varchar(64) DEFAULT NULL,
  `Name` varchar(64) DEFAULT NULL,
  `Header` text,
  `Purpose` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Name` (`Name`,`TeamId`),
  KEY `idx_publicchannels_team_id` (`TeamId`),
  KEY `idx_publicchannels_delete_at` (`DeleteAt`),
  FULLTEXT KEY `idx_publicchannels_search_txt` (`Name`,`DisplayName`,`Purpose`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Reactions` (
  `UserId` varchar(26) NOT NULL,
  `PostId` varchar(26) NOT NULL,
  `EmojiName` varchar(64) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `RemoteId` varchar(26) DEFAULT NULL,
  `ChannelId` varchar(26) NOT NULL DEFAULT '',
  PRIMARY KEY (`PostId`,`UserId`,`EmojiName`),
  KEY `idx_reactions_channel_id` (`ChannelId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RecentSearches` (
  `UserId` char(26) NOT NULL,
  `SearchPointer` int(11) NOT NULL,
  `Query` json DEFAULT NULL,
  `CreateAt` bigint(20) NOT NULL,
  PRIMARY KEY (`UserId`,`SearchPointer`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RemoteClusters` (
  `RemoteId` varchar(26) NOT NULL,
  `RemoteTeamId` varchar(26) DEFAULT NULL,
  `Name` varchar(64) NOT NULL,
  `DisplayName` varchar(64) DEFAULT NULL,
  `SiteURL` text,
  `CreateAt` bigint(20) DEFAULT NULL,
  `LastPingAt` bigint(20) DEFAULT NULL,
  `Token` varchar(26) DEFAULT NULL,
  `RemoteToken` varchar(26) DEFAULT NULL,
  `Topics` text,
  `CreatorId` varchar(26) DEFAULT NULL,
  PRIMARY KEY (`RemoteId`,`Name`),
  UNIQUE KEY `remote_clusters_site_url_unique` (`RemoteTeamId`,`SiteURL`(168))
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RetentionPolicies` (
  `Id` varchar(26) NOT NULL,
  `DisplayName` varchar(64) DEFAULT NULL,
  `PostDuration` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IDX_RetentionPolicies_DisplayName` (`DisplayName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RetentionPoliciesChannels` (
  `PolicyId` varchar(26) DEFAULT NULL,
  `ChannelId` varchar(26) NOT NULL,
  PRIMARY KEY (`ChannelId`),
  KEY `IDX_RetentionPoliciesChannels_PolicyId` (`PolicyId`),
  CONSTRAINT `FK_RetentionPoliciesChannels_RetentionPolicies` FOREIGN KEY (`PolicyId`) REFERENCES `RetentionPolicies` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RetentionPoliciesTeams` (
  `PolicyId` varchar(26) DEFAULT NULL,
  `TeamId` varchar(26) NOT NULL,
  PRIMARY KEY (`TeamId`),
  KEY `IDX_RetentionPoliciesTeams_PolicyId` (`PolicyId`),
  CONSTRAINT `FK_RetentionPoliciesTeams_RetentionPolicies` FOREIGN KEY (`PolicyId`) REFERENCES `RetentionPolicies` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Roles` (
  `Id` varchar(26) NOT NULL,
  `Name` varchar(64) DEFAULT NULL,
  `DisplayName` varchar(128) DEFAULT NULL,
  `Description` text,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `Permissions` longtext,
  `SchemeManaged` tinyint(1) DEFAULT NULL,
  `BuiltIn` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Schemes` (
  `Id` varchar(26) NOT NULL,
  `Name` varchar(64) DEFAULT NULL,
  `DisplayName` varchar(128) DEFAULT NULL,
  `Description` text,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `Scope` varchar(32) DEFAULT NULL,
  `DefaultTeamAdminRole` varchar(64) DEFAULT NULL,
  `DefaultTeamUserRole` varchar(64) DEFAULT NULL,
  `DefaultChannelAdminRole` varchar(64) DEFAULT NULL,
  `DefaultChannelUserRole` varchar(64) DEFAULT NULL,
  `DefaultTeamGuestRole` varchar(64) DEFAULT NULL,
  `DefaultChannelGuestRole` varchar(64) DEFAULT NULL,
  `DefaultPlaybookAdminRole` varchar(64) DEFAULT '',
  `DefaultPlaybookMemberRole` varchar(64) DEFAULT '',
  `DefaultRunAdminRole` varchar(64) DEFAULT '',
  `DefaultRunMemberRole` varchar(64) DEFAULT '',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Name` (`Name`),
  KEY `idx_schemes_channel_guest_role` (`DefaultChannelGuestRole`),
  KEY `idx_schemes_channel_user_role` (`DefaultChannelUserRole`),
  KEY `idx_schemes_channel_admin_role` (`DefaultChannelAdminRole`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Sessions` (
  `Id` varchar(26) NOT NULL,
  `Token` varchar(26) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `ExpiresAt` bigint(20) DEFAULT NULL,
  `LastActivityAt` bigint(20) DEFAULT NULL,
  `UserId` varchar(26) DEFAULT NULL,
  `DeviceId` text,
  `Roles` text,
  `IsOAuth` tinyint(1) DEFAULT NULL,
  `Props` json DEFAULT NULL,
  `ExpiredNotify` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_sessions_user_id` (`UserId`),
  KEY `idx_sessions_token` (`Token`),
  KEY `idx_sessions_expires_at` (`ExpiresAt`),
  KEY `idx_sessions_create_at` (`CreateAt`),
  KEY `idx_sessions_last_activity_at` (`LastActivityAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SharedChannelAttachments` (
  `Id` varchar(26) NOT NULL,
  `FileId` varchar(26) DEFAULT NULL,
  `RemoteId` varchar(26) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `LastSyncAt` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `FileId` (`FileId`,`RemoteId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SharedChannelRemotes` (
  `Id` varchar(26) NOT NULL,
  `ChannelId` varchar(26) NOT NULL,
  `CreatorId` varchar(26) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `IsInviteAccepted` tinyint(1) DEFAULT NULL,
  `IsInviteConfirmed` tinyint(1) DEFAULT NULL,
  `RemoteId` varchar(26) DEFAULT NULL,
  `LastPostUpdateAt` bigint(20) DEFAULT NULL,
  `LastPostId` varchar(26) DEFAULT NULL,
  PRIMARY KEY (`Id`,`ChannelId`),
  UNIQUE KEY `ChannelId` (`ChannelId`,`RemoteId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SharedChannelUsers` (
  `Id` varchar(26) NOT NULL,
  `UserId` varchar(26) DEFAULT NULL,
  `RemoteId` varchar(26) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `LastSyncAt` bigint(20) DEFAULT NULL,
  `ChannelId` varchar(26) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `UserId` (`UserId`,`ChannelId`,`RemoteId`),
  KEY `idx_sharedchannelusers_remote_id` (`RemoteId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SharedChannels` (
  `ChannelId` varchar(26) NOT NULL,
  `TeamId` varchar(26) DEFAULT NULL,
  `Home` tinyint(1) DEFAULT NULL,
  `ReadOnly` tinyint(1) DEFAULT NULL,
  `ShareName` varchar(64) DEFAULT NULL,
  `ShareDisplayName` varchar(64) DEFAULT NULL,
  `SharePurpose` varchar(250) DEFAULT NULL,
  `ShareHeader` text,
  `CreatorId` varchar(26) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `RemoteId` varchar(26) DEFAULT NULL,
  PRIMARY KEY (`ChannelId`),
  UNIQUE KEY `ShareName` (`ShareName`,`TeamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SidebarCategories` (
  `Id` varchar(128) NOT NULL,
  `UserId` varchar(26) DEFAULT NULL,
  `TeamId` varchar(26) DEFAULT NULL,
  `SortOrder` bigint(20) DEFAULT NULL,
  `Sorting` varchar(64) DEFAULT NULL,
  `Type` varchar(64) DEFAULT NULL,
  `DisplayName` varchar(64) DEFAULT NULL,
  `Muted` tinyint(1) DEFAULT NULL,
  `Collapsed` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_sidebarcategories_userid_teamid` (`UserId`,`TeamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SidebarChannels` (
  `ChannelId` varchar(26) NOT NULL,
  `UserId` varchar(26) NOT NULL,
  `CategoryId` varchar(128) NOT NULL,
  `SortOrder` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ChannelId`,`UserId`,`CategoryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Status` (
  `UserId` varchar(26) NOT NULL,
  `Status` varchar(32) DEFAULT NULL,
  `Manual` tinyint(1) DEFAULT NULL,
  `LastActivityAt` bigint(20) DEFAULT NULL,
  `DNDEndTime` bigint(20) DEFAULT NULL,
  `PrevStatus` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`UserId`),
  KEY `idx_status_status_dndendtime` (`Status`,`DNDEndTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Systems` (
  `Name` varchar(64) NOT NULL,
  `Value` text,
  PRIMARY KEY (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TeamMembers` (
  `TeamId` varchar(26) NOT NULL,
  `UserId` varchar(26) NOT NULL,
  `Roles` text,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `SchemeUser` tinyint(4) DEFAULT NULL,
  `SchemeAdmin` tinyint(4) DEFAULT NULL,
  `SchemeGuest` tinyint(4) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT '0',
  PRIMARY KEY (`TeamId`,`UserId`),
  KEY `idx_teammembers_user_id` (`UserId`),
  KEY `idx_teammembers_delete_at` (`DeleteAt`),
  KEY `idx_teammembers_createat` (`CreateAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Teams` (
  `Id` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `DisplayName` varchar(64) DEFAULT NULL,
  `Name` varchar(64) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Email` varchar(128) DEFAULT NULL,
  `Type` enum('I','O') DEFAULT NULL,
  `CompanyName` varchar(64) DEFAULT NULL,
  `AllowedDomains` text,
  `InviteId` varchar(32) DEFAULT NULL,
  `SchemeId` varchar(26) DEFAULT NULL,
  `AllowOpenInvite` tinyint(1) DEFAULT NULL,
  `LastTeamIconUpdate` bigint(20) DEFAULT NULL,
  `GroupConstrained` tinyint(1) DEFAULT NULL,
  `CloudLimitsArchived` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Name` (`Name`),
  KEY `idx_teams_invite_id` (`InviteId`),
  KEY `idx_teams_update_at` (`UpdateAt`),
  KEY `idx_teams_create_at` (`CreateAt`),
  KEY `idx_teams_delete_at` (`DeleteAt`),
  KEY `idx_teams_scheme_id` (`SchemeId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TermsOfService` (
  `Id` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UserId` varchar(26) DEFAULT NULL,
  `Text` text,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ThreadMemberships` (
  `PostId` varchar(26) NOT NULL,
  `UserId` varchar(26) NOT NULL,
  `Following` tinyint(1) DEFAULT NULL,
  `LastViewed` bigint(20) DEFAULT NULL,
  `LastUpdated` bigint(20) DEFAULT NULL,
  `UnreadMentions` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PostId`,`UserId`),
  KEY `idx_thread_memberships_last_update_at` (`LastUpdated`),
  KEY `idx_thread_memberships_last_view_at` (`LastViewed`),
  KEY `idx_thread_memberships_user_id` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Threads` (
  `PostId` varchar(26) NOT NULL,
  `ReplyCount` bigint(20) DEFAULT NULL,
  `LastReplyAt` bigint(20) DEFAULT NULL,
  `Participants` json DEFAULT NULL,
  `ChannelId` varchar(26) DEFAULT NULL,
  `ThreadDeleteAt` bigint(20) DEFAULT NULL,
  `ThreadTeamId` varchar(26) DEFAULT NULL,
  PRIMARY KEY (`PostId`),
  KEY `idx_threads_channel_id_last_reply_at` (`ChannelId`,`LastReplyAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Tokens` (
  `Token` varchar(64) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `Type` varchar(64) DEFAULT NULL,
  `Extra` text,
  PRIMARY KEY (`Token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TrueUpReviewHistory` (
  `DueDate` bigint(20) NOT NULL,
  `Completed` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`DueDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UploadSessions` (
  `Id` varchar(26) NOT NULL,
  `Type` enum('attachment','import') DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UserId` varchar(26) DEFAULT NULL,
  `ChannelId` varchar(26) DEFAULT NULL,
  `Filename` text,
  `Path` text,
  `FileSize` bigint(20) DEFAULT NULL,
  `FileOffset` bigint(20) DEFAULT NULL,
  `RemoteId` varchar(26) DEFAULT NULL,
  `ReqFileId` varchar(26) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `idx_uploadsessions_user_id` (`UserId`),
  KEY `idx_uploadsessions_create_at` (`CreateAt`),
  KEY `idx_uploadsessions_type` (`Type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserAccessTokens` (
  `Id` varchar(26) NOT NULL,
  `Token` varchar(26) DEFAULT NULL,
  `UserId` varchar(26) DEFAULT NULL,
  `Description` text,
  `IsActive` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Token` (`Token`),
  KEY `idx_user_access_tokens_user_id` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserGroups` (
  `Id` varchar(26) NOT NULL,
  `Name` varchar(64) DEFAULT NULL,
  `DisplayName` varchar(128) DEFAULT NULL,
  `Description` text,
  `Source` varchar(64) DEFAULT NULL,
  `RemoteId` varchar(48) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `AllowReference` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Name` (`Name`),
  UNIQUE KEY `Source` (`Source`,`RemoteId`),
  KEY `idx_usergroups_remote_id` (`RemoteId`),
  KEY `idx_usergroups_delete_at` (`DeleteAt`),
  KEY `idx_usergroups_displayname` (`DisplayName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserTermsOfService` (
  `UserId` varchar(26) NOT NULL,
  `TermsOfServiceId` varchar(26) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Users` (
  `Id` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `UpdateAt` bigint(20) DEFAULT NULL,
  `DeleteAt` bigint(20) DEFAULT NULL,
  `Username` varchar(64) DEFAULT NULL,
  `Password` varchar(128) DEFAULT NULL,
  `AuthData` varchar(128) DEFAULT NULL,
  `AuthService` varchar(32) DEFAULT NULL,
  `Email` varchar(128) DEFAULT NULL,
  `EmailVerified` tinyint(1) DEFAULT NULL,
  `Nickname` varchar(64) DEFAULT NULL,
  `FirstName` varchar(64) DEFAULT NULL,
  `LastName` varchar(64) DEFAULT NULL,
  `Roles` text,
  `AllowMarketing` tinyint(1) DEFAULT NULL,
  `Props` json DEFAULT NULL,
  `NotifyProps` json DEFAULT NULL,
  `LastPasswordUpdate` bigint(20) DEFAULT NULL,
  `LastPictureUpdate` bigint(20) DEFAULT NULL,
  `FailedAttempts` int(11) DEFAULT NULL,
  `Locale` varchar(5) DEFAULT NULL,
  `MfaActive` tinyint(1) DEFAULT NULL,
  `MfaSecret` varchar(128) DEFAULT NULL,
  `Position` varchar(128) DEFAULT NULL,
  `Timezone` json DEFAULT NULL,
  `RemoteId` varchar(26) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Username` (`Username`),
  UNIQUE KEY `AuthData` (`AuthData`),
  UNIQUE KEY `Email` (`Email`),
  KEY `idx_users_update_at` (`UpdateAt`),
  KEY `idx_users_create_at` (`CreateAt`),
  KEY `idx_users_delete_at` (`DeleteAt`),
  FULLTEXT KEY `idx_users_all_txt` (`Username`,`FirstName`,`LastName`,`Nickname`,`Email`),
  FULLTEXT KEY `idx_users_all_no_full_name_txt` (`Username`,`Nickname`,`Email`),
  FULLTEXT KEY `idx_users_names_txt` (`Username`,`FirstName`,`LastName`,`Nickname`),
  FULLTEXT KEY `idx_users_names_no_full_name_txt` (`Username`,`Nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `db_lock` (
  `Id` varchar(64) NOT NULL,
  `ExpireAt` bigint(20) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `db_migrations` (
  `Version` bigint(20) NOT NULL,
  `Name` varchar(64) NOT NULL,
  PRIMARY KEY (`Version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_blocks` (
  `id` varchar(36) NOT NULL,
  `insert_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `parent_id` varchar(36) DEFAULT NULL,
  `schema` bigint(20) DEFAULT NULL,
  `type` text,
  `title` text,
  `fields` text,
  `create_at` bigint(20) DEFAULT NULL,
  `update_at` bigint(20) DEFAULT NULL,
  `delete_at` bigint(20) DEFAULT NULL,
  `root_id` varchar(36) DEFAULT NULL,
  `modified_by` varchar(36) NOT NULL,
  `channel_id` varchar(36) NOT NULL,
  `created_by` varchar(36) NOT NULL,
  `board_id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_blocks_board_id_parent_id` (`board_id`,`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_blocks_history` (
  `id` varchar(36) NOT NULL,
  `insert_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `parent_id` varchar(36) DEFAULT NULL,
  `schema` bigint(20) DEFAULT NULL,
  `type` text,
  `title` text,
  `fields` text,
  `create_at` bigint(20) DEFAULT NULL,
  `update_at` bigint(20) DEFAULT NULL,
  `delete_at` bigint(20) DEFAULT NULL,
  `root_id` varchar(36) DEFAULT NULL,
  `modified_by` varchar(36) DEFAULT NULL,
  `channel_id` varchar(36) DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `board_id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`,`insert_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_board_members` (
  `board_id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `roles` varchar(64) DEFAULT NULL,
  `scheme_admin` tinyint(1) DEFAULT NULL,
  `scheme_editor` tinyint(1) DEFAULT NULL,
  `scheme_commenter` tinyint(1) DEFAULT NULL,
  `scheme_viewer` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`board_id`,`user_id`),
  KEY `idx_board_members_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_board_members_history` (
  `board_id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `action` varchar(10) DEFAULT NULL,
  `insert_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`board_id`,`user_id`,`insert_at`),
  KEY `idx_board_members_history_user_id` (`user_id`),
  KEY `idx_board_members_history_board_id_user_id` (`board_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_boards` (
  `id` varchar(36) NOT NULL,
  `insert_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `team_id` varchar(36) NOT NULL,
  `channel_id` varchar(36) DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `modified_by` varchar(36) DEFAULT NULL,
  `type` varchar(1) NOT NULL,
  `title` text NOT NULL,
  `description` text,
  `icon` varchar(256) DEFAULT NULL,
  `show_description` tinyint(1) DEFAULT NULL,
  `is_template` tinyint(1) DEFAULT NULL,
  `template_version` int(11) DEFAULT '0',
  `properties` json DEFAULT NULL,
  `card_properties` json DEFAULT NULL,
  `create_at` bigint(20) DEFAULT NULL,
  `update_at` bigint(20) DEFAULT NULL,
  `delete_at` bigint(20) DEFAULT NULL,
  `minimum_role` varchar(36) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_boards_team_id_is_template` (`team_id`,`is_template`),
  KEY `idx_boards_channel_id` (`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_boards_history` (
  `id` varchar(36) NOT NULL,
  `insert_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `team_id` varchar(36) NOT NULL,
  `channel_id` varchar(36) DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `modified_by` varchar(36) DEFAULT NULL,
  `type` varchar(1) NOT NULL,
  `title` text NOT NULL,
  `description` text,
  `icon` varchar(256) DEFAULT NULL,
  `show_description` tinyint(1) DEFAULT NULL,
  `is_template` tinyint(1) DEFAULT NULL,
  `template_version` int(11) DEFAULT '0',
  `properties` json DEFAULT NULL,
  `card_properties` json DEFAULT NULL,
  `create_at` bigint(20) DEFAULT NULL,
  `update_at` bigint(20) DEFAULT NULL,
  `delete_at` bigint(20) DEFAULT NULL,
  `minimum_role` varchar(36) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`insert_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_categories` (
  `id` varchar(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `team_id` varchar(36) NOT NULL,
  `channel_id` varchar(36) DEFAULT NULL,
  `create_at` bigint(20) DEFAULT NULL,
  `update_at` bigint(20) DEFAULT NULL,
  `delete_at` bigint(20) DEFAULT NULL,
  `collapsed` tinyint(1) DEFAULT '0',
  `type` varchar(64) DEFAULT NULL,
  `sort_order` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_categories_user_id_team_id` (`user_id`,`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_category_boards` (
  `id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `category_id` varchar(36) NOT NULL,
  `board_id` varchar(36) NOT NULL,
  `create_at` bigint(20) DEFAULT NULL,
  `update_at` bigint(20) DEFAULT NULL,
  `sort_order` bigint(20) DEFAULT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_category_board` (`user_id`,`board_id`),
  KEY `idx_category_boards_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_file_info` (
  `id` varchar(26) NOT NULL,
  `create_at` bigint(20) NOT NULL,
  `delete_at` bigint(20) DEFAULT NULL,
  `name` text NOT NULL,
  `extension` varchar(50) NOT NULL,
  `size` bigint(20) NOT NULL,
  `archived` tinyint(1) DEFAULT NULL,
  `path` varchar(512) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_notification_hints` (
  `block_type` varchar(10) DEFAULT NULL,
  `block_id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) DEFAULT NULL,
  `modified_by_id` varchar(36) DEFAULT NULL,
  `create_at` bigint(20) DEFAULT NULL,
  `notify_at` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`block_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_preferences` (
  `userid` varchar(36) NOT NULL,
  `category` varchar(32) NOT NULL,
  `name` varchar(32) NOT NULL,
  `value` text,
  PRIMARY KEY (`userid`,`category`,`name`),
  KEY `idx_preferences_category` (`category`),
  KEY `idx_preferences_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_schema_migrations` (
  `Version` bigint(20) NOT NULL,
  `Name` varchar(64) NOT NULL,
  PRIMARY KEY (`Version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_sessions` (
  `id` varchar(100) NOT NULL,
  `token` varchar(100) DEFAULT NULL,
  `user_id` varchar(100) DEFAULT NULL,
  `props` text,
  `create_at` bigint(20) DEFAULT NULL,
  `update_at` bigint(20) DEFAULT NULL,
  `auth_service` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_sharing` (
  `id` varchar(36) NOT NULL,
  `enabled` tinyint(1) DEFAULT NULL,
  `token` varchar(100) DEFAULT NULL,
  `modified_by` varchar(36) DEFAULT NULL,
  `update_at` bigint(20) DEFAULT NULL,
  `workspace_id` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_subscriptions` (
  `block_type` varchar(10) DEFAULT NULL,
  `block_id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) DEFAULT NULL,
  `subscriber_type` varchar(10) DEFAULT NULL,
  `subscriber_id` varchar(36) NOT NULL,
  `notified_at` bigint(20) DEFAULT NULL,
  `create_at` bigint(20) DEFAULT NULL,
  `delete_at` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`block_id`,`subscriber_id`),
  KEY `idx_subscriptions_subscriber_id` (`subscriber_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_system_settings` (
  `id` varchar(100) NOT NULL,
  `value` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_teams` (
  `id` varchar(36) NOT NULL,
  `signup_token` varchar(100) NOT NULL,
  `settings` text,
  `modified_by` varchar(36) DEFAULT NULL,
  `update_at` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_users` (
  `id` varchar(100) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `mfa_secret` varchar(100) DEFAULT NULL,
  `auth_service` varchar(20) DEFAULT NULL,
  `auth_data` varchar(255) DEFAULT NULL,
  `props` text,
  `create_at` bigint(20) DEFAULT NULL,
  `update_at` bigint(20) DEFAULT NULL,
  `delete_at` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_workspaces` (
  `id` varchar(36) NOT NULL,
  `signup_token` varchar(100) NOT NULL,
  `settings` text,
  `modified_by` varchar(36) DEFAULT NULL,
  `update_at` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mattermost_test` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `mattermost_test`;
INSERT INTO `Bots` VALUES ('6g9zjk1d7brz8rqiypd9kypn5c','Feedbackbot collects user feedback to improve Mattermost. [Learn more](https://mattermost.com/pl/default-nps).','com.mattermost.nps',1684139058981,1684139058981,0,0);
INSERT INTO `Bots` VALUES ('d6eb3jh8iprzpxim14w9hkopbr','Created by Boards plugin.','focalboard',1684139114835,1684139114835,0,0);
INSERT INTO `Bots` VALUES ('dk8nggnjtt8yipcbmuqem4rfkc','','jactwicuqb8bu8pau8mgjydzeo',1684139700012,1684139700012,0,0);
INSERT INTO `Bots` VALUES ('k8crtspa5bfadc6iu6m93p4orh','Nautobot Test Bot','jactwicuqb8bu8pau8mgjydzeo',1684146025510,1684146025510,0,0);
INSERT INTO `Bots` VALUES ('o113xcgte78kpezuouwcr6abpo','Calls Bot','com.mattermost.calls',1684139059888,1684139059888,0,0);
INSERT INTO `Bots` VALUES ('ozpddc4xxi85tmrwaqsjmgw1kc','Playbooks bot.','playbooks',1684139059822,1684139059822,0,0);
INSERT INTO `Bots` VALUES ('qmaiqbz1e3fo8qz1nsmkhqbznh','Mattermost Apps Registry and API proxy.','com.mattermost.apps',1684139059460,1684139059460,0,0);
INSERT INTO `ChannelMembers` VALUES ('8sz36rga1in69gaunpogq95r1w','jactwicuqb8bu8pau8mgjydzeo','',1684153509947,2,0,'{\"push\": \"default\", \"email\": \"default\", \"desktop\": \"default\", \"mark_unread\": \"all\", \"ignore_channel_mentions\": \"default\"}',1684153509947,1,1,0,0,2,0);
INSERT INTO `ChannelMembers` VALUES ('8sz36rga1in69gaunpogq95r1w','k8crtspa5bfadc6iu6m93p4orh','',0,0,0,'{\"push\": \"default\", \"email\": \"default\", \"desktop\": \"default\", \"mark_unread\": \"all\", \"ignore_channel_mentions\": \"default\"}',1684146863323,1,0,0,0,0,0);
INSERT INTO `ChannelMembers` VALUES ('9g8qo5udpp8dzdud8jex1m6kuh','jactwicuqb8bu8pau8mgjydzeo','',1684146025577,1,0,'{\"push\": \"default\", \"email\": \"default\", \"desktop\": \"default\", \"mark_unread\": \"all\", \"ignore_channel_mentions\": \"default\"}',1684146025577,1,0,0,0,1,0);
INSERT INTO `ChannelMembers` VALUES ('9g8qo5udpp8dzdud8jex1m6kuh','k8crtspa5bfadc6iu6m93p4orh','',0,0,0,'{\"push\": \"default\", \"email\": \"default\", \"desktop\": \"default\", \"mark_unread\": \"all\", \"ignore_channel_mentions\": \"default\"}',1684146025519,1,0,0,0,0,0);
INSERT INTO `ChannelMembers` VALUES ('fi1muawz1bybue4gwu95kni4eh','jactwicuqb8bu8pau8mgjydzeo','',1684139716016,0,0,'{\"push\": \"default\", \"email\": \"default\", \"desktop\": \"default\", \"mark_unread\": \"all\", \"ignore_channel_mentions\": \"default\"}',1684139716016,1,1,0,0,0,0);
INSERT INTO `ChannelMembers` VALUES ('fi1muawz1bybue4gwu95kni4eh','k8crtspa5bfadc6iu6m93p4orh','',0,0,1,'{\"push\": \"default\", \"email\": \"default\", \"desktop\": \"default\", \"mark_unread\": \"all\", \"ignore_channel_mentions\": \"default\"}',1684146863438,1,0,0,1,0,0);
INSERT INTO `Channels` VALUES ('8sz36rga1in69gaunpogq95r1w',1684139715853,1684139715853,0,'35odngbgr7yw3bf13o8kg85ngh','O','Town Square','town-square','','',1684153509947,2,0,'',NULL,NULL,NULL,2,1684153509947);
INSERT INTO `Channels` VALUES ('9g8qo5udpp8dzdud8jex1m6kuh',1684146025517,1684146025517,0,'','D','','jactwicuqb8bu8pau8mgjydzeo__k8crtspa5bfadc6iu6m93p4orh','','',1684146025577,1,0,'k8crtspa5bfadc6iu6m93p4orh',NULL,NULL,0,1,1684146025577);
INSERT INTO `Channels` VALUES ('fi1muawz1bybue4gwu95kni4eh',1684139715866,1684139715866,0,'35odngbgr7yw3bf13o8kg85ngh','O','Off-Topic','off-topic','','',1684146863411,0,0,'',NULL,NULL,NULL,0,1684146863411);
INSERT INTO `Commands` VALUES ('yhepukctj7r1jgr8kappi7mb7e','tc1u8wbh53fwxxdkhswbmu9wsa',1685617546901,1685618110521,0,'jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh','aci','P','','',0,'','','Cisco ACI','Cisco ACI Slash Command','http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/','');
INSERT INTO `Commands` VALUES ('846xisdqmtro9yd3eg8m45co3o','c7udax974iymjkmoyhi1a11cpy',1685089324429,1685089324429,0,'jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh','ansible','P','','',0,'','','Ansible','Ansible Slash Command','http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/','');
INSERT INTO `Commands` VALUES ('561dqoomjt8ixqc3td9m53i3mh','p7phuwhpaiddjxqf8c1hnw33yh',1686737880192,1686737880192,0,'jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh','clear','P','','',0,'','','Clear','Clear Slash Command','http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/','');
INSERT INTO `Commands` VALUES ('z7bmireh6tgpzgkujc4moaaiqe','pxannsh78iyhbm8fumz8mxk9ih',1685442897799,1685442897799,0,'jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh','cloudvision','P','','',0,'','','Arista CloudVision','Arista CloudVision Slash Command','http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/','');
INSERT INTO `Commands` VALUES ('px7ae4ik6idp7pb51hx5ms4x3w','o1yiadnpifbzddt3umcedeypdr',1684405443321,1684405443321,0,'jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh','grafana','P','','',0,'','','Grafana','Grafana Slash Command','http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/','');
INSERT INTO `Commands` VALUES ('f74t71u6p7rpbmz7ruebja7ana','uqydyxkx4tykinw5z5u9dany1o',1685099154275,1685099154275,0,'jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh','ipfabric','P','','',0,'','','IP Fabric','IP Fabric Slash Command','http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/','');
INSERT INTO `Commands` VALUES ('j5pnszdfcpbt3f6yfs63o5bwhw','t9irqwjni3dozf3yx6tzak7k3w',1685532127072,1685532127072,0,'jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh','meraki','P','','',0,'','','Cisco Meraki','Cisco Meraki Slash Command','http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/','');
INSERT INTO `Commands` VALUES ('d9irq7zuwt84pr77crnteso6da','rmdpfdjhnpg988e7ujzyom4euh',1684146546769,1684152166227,0,'jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh','nautobot','P','','',0,'','','Nautobot','Nautobot Slash Command','http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/','');
INSERT INTO `Commands` VALUES ('uooffhygyigtfb4454k9yxm81h','6nf5cmz1ft8bdfykz46cs5pofo',1685702889199,1685702889199,0,'jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh','panorama','P','','',0,'','','Panorama','Panorama Slash Command','http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/','');
INSERT INTO `Drafts` VALUES (1684146834706,1684335673276,1684335673276,'jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','','/nautobot','{}','[]','null');
INSERT INTO `IR_System` VALUES ('DatabaseVersion','0.63.0');
INSERT INTO `IR_UserInfo` VALUES ('jactwicuqb8bu8pau8mgjydzeo',1684387012504,'{\"disable_daily_digest\": false, \"disable_weekly_digest\": false}');
INSERT INTO `Jobs` VALUES ('kwwq4cbzu3nmxdewywnouh48xo','migrations',0,1684139119925,1684139134240,1684139136273,'success',0,'{\"last_done\": \"{\\\"current_table\\\":\\\"ChannelMembers\\\",\\\"last_team_id\\\":\\\"00000000000000000000000000\\\",\\\"last_channel_id\\\":\\\"00000000000000000000000000\\\",\\\"last_user\\\":\\\"00000000000000000000000000\\\"}\", \"migration_key\": \"migration_advanced_permissions_phase_2\"}');
INSERT INTO `PluginKeyValueStore` VALUES ('com.mattermost.apps','mmi_botid',_binary 'qmaiqbz1e3fo8qz1nsmkhqbznh',0);
INSERT INTO `PluginKeyValueStore` VALUES ('com.mattermost.calls','mmi_botid',_binary 'o113xcgte78kpezuouwcr6abpo',0);
INSERT INTO `PluginKeyValueStore` VALUES ('com.mattermost.nps','ServerUpgrade-7.10.0',_binary '{\"server_version\":\"7.10.0\",\"upgrade_at\":\"2023-05-15T08:24:19.013024124Z\"}',0);
INSERT INTO `PluginKeyValueStore` VALUES ('com.mattermost.nps','Survey-7.10.0',_binary '{\"server_version\":\"7.10.0\",\"create_at\":\"2023-05-15T08:24:19.013024124Z\",\"start_at\":\"2023-06-29T08:24:19.013024124Z\"}',0);
INSERT INTO `PluginKeyValueStore` VALUES ('com.mattermost.nps','WelcomeFeedbackMigration',_binary '{\"CreateAt\":\"2023-05-15T08:24:19.013024124Z\"}',0);
INSERT INTO `PluginKeyValueStore` VALUES ('focalboard','mmi_botid',_binary 'd6eb3jh8iprzpxim14w9hkopbr',0);
INSERT INTO `PluginKeyValueStore` VALUES ('playbooks','mmi_botid',_binary 'ozpddc4xxi85tmrwaqsjmgw1kc',0);
INSERT INTO `Preferences` VALUES ('jactwicuqb8bu8pau8mgjydzeo','channel_approximate_view_time','','1684386592335');
INSERT INTO `Preferences` VALUES ('jactwicuqb8bu8pau8mgjydzeo','channel_open_time','9g8qo5udpp8dzdud8jex1m6kuh','1684335914329');
INSERT INTO `Preferences` VALUES ('jactwicuqb8bu8pau8mgjydzeo','direct_channel_show','k8crtspa5bfadc6iu6m93p4orh','true');
INSERT INTO `Preferences` VALUES ('jactwicuqb8bu8pau8mgjydzeo','drafts','drafts_tour_tip_showed','{\"drafts_tour_tip_showed\":true}');
INSERT INTO `Preferences` VALUES ('jactwicuqb8bu8pau8mgjydzeo','insights','insights_tutorial_state','{\"insights_modal_viewed\":true}');
INSERT INTO `Preferences` VALUES ('jactwicuqb8bu8pau8mgjydzeo','onboarding_task_list','onboarding_task_list_open','false');
INSERT INTO `Preferences` VALUES ('jactwicuqb8bu8pau8mgjydzeo','onboarding_task_list','onboarding_task_list_show','false');
INSERT INTO `Preferences` VALUES ('jactwicuqb8bu8pau8mgjydzeo','recommended_next_steps','hide','true');
INSERT INTO `Preferences` VALUES ('jactwicuqb8bu8pau8mgjydzeo','touched','invite_members','true');
INSERT INTO `Preferences` VALUES ('jactwicuqb8bu8pau8mgjydzeo','tutorial_step','jactwicuqb8bu8pau8mgjydzeo','0');
INSERT INTO `ProductNoticeViewState` VALUES ('jactwicuqb8bu8pau8mgjydzeo','crt-admin-default_off',1,1684139698);
INSERT INTO `ProductNoticeViewState` VALUES ('jactwicuqb8bu8pau8mgjydzeo','crt-admin-disabled',1,1684139698);
INSERT INTO `ProductNoticeViewState` VALUES ('jactwicuqb8bu8pau8mgjydzeo','crt-user-always-on',1,1684139698);
INSERT INTO `ProductNoticeViewState` VALUES ('jactwicuqb8bu8pau8mgjydzeo','crt-user-default-on',1,1684139698);
INSERT INTO `ProductNoticeViewState` VALUES ('jactwicuqb8bu8pau8mgjydzeo','desktop_upgrade_v5.2',1,1684139698);
INSERT INTO `ProductNoticeViewState` VALUES ('jactwicuqb8bu8pau8mgjydzeo','server_upgrade_v7.9',1,1684139698);
INSERT INTO `ProductNoticeViewState` VALUES ('jactwicuqb8bu8pau8mgjydzeo','unsupported-server-v5.37',1,1684139698);
INSERT INTO `PublicChannels` VALUES ('8sz36rga1in69gaunpogq95r1w',0,'35odngbgr7yw3bf13o8kg85ngh','Town Square','town-square','','');
INSERT INTO `PublicChannels` VALUES ('fi1muawz1bybue4gwu95kni4eh',0,'35odngbgr7yw3bf13o8kg85ngh','Off-Topic','off-topic','','');
INSERT INTO `Roles` VALUES ('13bs7grka7f45g6eskmqbuypbw','team_user','authentication.roles.team_user.name','authentication.roles.team_user.description',1684139050819,1684139055707,0,' playbook_public_create list_team_channels join_public_channels playbook_private_create create_private_channel add_user_to_team read_public_channel view_team create_public_channel invite_user',1,1);
INSERT INTO `Roles` VALUES ('1assaqn3tt899xeda1aiop8bky','run_admin','authentication.roles.run_admin.name','authentication.roles.run_admin.description',1684139050763,1684139055713,0,' run_manage_properties run_manage_members',1,1);
INSERT INTO `Roles` VALUES ('7eh3dpufq7g4zfza5ku6zacgdo','run_member','authentication.roles.run_member.name','authentication.roles.run_member.description',1684139050908,1684139055719,0,' run_view',1,1);
INSERT INTO `Roles` VALUES ('99faipwtbf8sbes7ipkdfz348e','system_post_all_public','authentication.roles.system_post_all_public.name','authentication.roles.system_post_all_public.description',1684139050876,1684139055725,0,' use_channel_mentions create_post_public use_group_mentions',0,1);
INSERT INTO `Roles` VALUES ('9wqa3318s3fw781rjkpjwbchaw','team_guest','authentication.roles.team_guest.name','authentication.roles.team_guest.description',1684139050859,1684139055732,0,' view_team',1,1);
INSERT INTO `Roles` VALUES ('a8fy4zx49trbbfi45wexsqmxdy','system_user','authentication.roles.global_user.name','authentication.roles.global_user.description',1684139050913,1684139055739,0,' delete_custom_group delete_emojis view_members create_team edit_custom_group create_group_channel manage_custom_group_members create_direct_channel restore_custom_group list_public_teams create_custom_group join_public_teams create_emojis',1,1);
INSERT INTO `Roles` VALUES ('bb9guastc3f99bqd91szo7dkch','team_post_all','authentication.roles.team_post_all.name','authentication.roles.team_post_all.description',1684139050903,1684139055745,0,' create_post use_channel_mentions use_group_mentions',0,1);
INSERT INTO `Roles` VALUES ('djorm5qfbpdimcdg8b8wdku5na','system_user_manager','authentication.roles.system_user_manager.name','authentication.roles.system_user_manager.description',1684139050798,1684139055752,0,' sysconsole_read_authentication_saml read_ldap_sync_job delete_public_channel sysconsole_read_authentication_ldap test_ldap sysconsole_write_user_management_teams convert_public_channel_to_private join_public_teams add_user_to_team sysconsole_read_user_management_groups manage_public_channel_members sysconsole_write_user_management_channels read_channel view_team manage_channel_roles sysconsole_read_user_management_permissions manage_team_roles read_private_channel_groups sysconsole_read_authentication_password remove_user_from_team join_private_teams sysconsole_read_user_management_channels sysconsole_read_authentication_email sysconsole_read_authentication_signup sysconsole_read_authentication_mfa sysconsole_read_authentication_openid list_private_teams list_public_teams sysconsole_write_user_management_groups delete_private_channel manage_public_channel_properties manage_team read_public_channel convert_private_channel_to_public manage_private_channel_members sysconsole_read_authentication_guest_access sysconsole_read_user_management_teams read_public_channel_groups manage_private_channel_properties',0,1);
INSERT INTO `Roles` VALUES ('jbrz4h5gqt877cuxh57absnc7c','custom_group_user','authentication.roles.custom_group_user.name','authentication.roles.custom_group_user.description',1684139050893,1684139055757,0,'',0,0);
INSERT INTO `Roles` VALUES ('jfuzyuzguiysmcb1fmtfnme6sc','system_admin','authentication.roles.global_admin.name','authentication.roles.global_admin.description',1684139050846,1684139055764,0,' sysconsole_read_experimental_feature_flags run_view import_team delete_emojis playbook_public_manage_members manage_team sysconsole_read_site_posts list_users_without_team get_saml_cert_status sysconsole_write_experimental_features sysconsole_read_user_management_users run_manage_members join_public_channels restore_custom_group remove_others_reactions create_compliance_export_job sysconsole_read_environment_performance_monitoring sysconsole_write_integrations_cors test_elasticsearch remove_reaction read_public_channel manage_roles sysconsole_write_environment_push_notification_server create_custom_group sysconsole_write_environment_database create_ldap_sync_job sysconsole_write_integrations_integration_management sysconsole_write_site_notices create_post_public use_group_mentions sysconsole_write_compliance_custom_terms_of_service create_post_ephemeral sysconsole_read_products_boards sysconsole_write_integrations_gif sysconsole_write_environment_performance_monitoring manage_license_information get_logs read_data_retention_job add_saml_idp_cert sysconsole_write_authentication_signup manage_slash_commands download_compliance_export_result invalidate_email_invite add_saml_public_cert read_other_users_teams use_channel_mentions sysconsole_read_environment_logging sysconsole_read_compliance_compliance_monitoring manage_system assign_bot invalidate_caches manage_bots invite_guest sysconsole_read_compliance_data_retention_policy view_members purge_bleve_indexes sysconsole_read_site_announcement_banner sysconsole_read_user_management_channels create_group_channel sysconsole_read_site_notifications sysconsole_write_authentication_password create_elasticsearch_post_indexing_job playbook_private_make_public sysconsole_read_environment_developer manage_shared_channels sysconsole_read_reporting_server_logs sysconsole_read_compliance_compliance_export manage_others_slash_commands create_direct_channel demote_to_guest read_others_bots manage_team_roles sysconsole_write_about_edition_and_license run_create sysconsole_write_user_management_channels sysconsole_read_plugins delete_public_channel sysconsole_read_reporting_team_statistics playbook_public_make_private add_ldap_public_cert create_team sysconsole_read_authentication_openid create_post edit_brand manage_others_bots delete_others_posts use_slash_commands read_audits edit_post remove_saml_private_cert sysconsole_write_compliance_compliance_monitoring reload_config sysconsole_write_plugins sysconsole_read_user_management_groups playbook_private_view test_email playbook_private_create add_saml_private_cert sysconsole_read_site_users_and_teams manage_private_channel_members remove_ldap_public_cert create_post_bleve_indexes_job manage_public_channel_members promote_guest delete_post playbook_private_manage_properties sysconsole_write_experimental_feature_flags test_site_url manage_others_incoming_webhooks read_private_channel_groups sysconsole_read_site_public_links sysconsole_write_products_boards sysconsole_read_integrations_integration_management playbook_private_manage_roles edit_other_users sysconsole_write_compliance_compliance_export sysconsole_read_authentication_email sysconsole_write_site_public_links sysconsole_write_environment_session_lengths sysconsole_write_site_emoji remove_saml_idp_cert edit_others_posts sysconsole_read_site_notices create_private_channel sysconsole_write_environment_image_proxy list_public_teams sysconsole_read_authentication_password join_public_teams read_jobs sysconsole_write_authentication_email manage_private_channel_properties read_license_information sysconsole_read_authentication_ldap create_data_retention_job manage_oauth assign_system_admin_role remove_saml_public_cert sysconsole_write_environment_elasticsearch list_team_channels list_private_teams sysconsole_read_environment_web_server test_ldap convert_private_channel_to_public create_user_access_token sysconsole_write_user_management_groups read_user_access_token create_bot sysconsole_write_integrations_bot_accounts create_emojis sysconsole_write_reporting_server_logs manage_others_outgoing_webhooks sysconsole_read_user_management_permissions manage_secure_connections sysconsole_write_reporting_team_statistics manage_system_wide_oauth read_channel playbook_public_create playbook_public_manage_roles revoke_user_access_token get_analytics get_public_link sysconsole_write_authentication_mfa sysconsole_write_user_management_permissions read_elasticsearch_post_indexing_job delete_private_channel sysconsole_read_authentication_saml add_reaction sysconsole_write_site_notifications sysconsole_write_site_announcement_banner sysconsole_write_experimental_bleve view_team invite_user sysconsole_read_environment_push_notification_server manage_public_channel_properties sysconsole_read_reporting_site_statistics remove_user_from_team sysconsole_write_authentication_openid playbook_private_manage_members sysconsole_write_environment_rate_limiting sysconsole_write_site_customization sysconsole_read_integrations_cors sysconsole_write_environment_web_server delete_custom_group purge_elasticsearch_indexes add_user_to_team edit_custom_group sysconsole_write_environment_smtp read_public_channel_groups sysconsole_write_environment_logging sysconsole_read_site_emoji sysconsole_read_environment_file_storage sysconsole_write_user_management_users manage_custom_group_members sysconsole_read_about_edition_and_license sysconsole_read_site_file_sharing_and_downloads sysconsole_read_site_localization sysconsole_read_integrations_gif sysconsole_read_environment_elasticsearch sysconsole_write_site_localization sysconsole_read_site_customization remove_ldap_private_cert playbook_public_view read_compliance_export_job sysconsole_write_billing sysconsole_write_user_management_teams join_private_teams sysconsole_write_site_users_and_teams sysconsole_write_site_file_sharing_and_downloads get_saml_metadata_from_idp read_elasticsearch_post_aggregation_job delete_others_emojis run_manage_properties sysconsole_read_environment_high_availability sysconsole_read_environment_rate_limiting create_public_channel sysconsole_read_environment_smtp manage_outgoing_webhooks sysconsole_write_environment_file_storage sysconsole_read_integrations_bot_accounts sysconsole_write_user_management_system_roles manage_jobs sysconsole_read_environment_image_proxy sysconsole_write_authentication_ldap sysconsole_read_environment_session_lengths playbook_public_manage_properties sysconsole_write_reporting_site_statistics upload_file sysconsole_read_environment_database sysconsole_read_experimental_features sysconsole_read_experimental_bleve sysconsole_write_authentication_guest_access read_ldap_sync_job recycle_database_connections sysconsole_read_authentication_mfa sysconsole_read_compliance_custom_terms_of_service manage_incoming_webhooks sysconsole_read_user_management_system_roles create_elasticsearch_post_aggregation_job convert_public_channel_to_private sysconsole_write_authentication_saml sysconsole_read_authentication_signup sysconsole_write_compliance_data_retention_policy read_bots test_s3 sysconsole_write_site_posts add_ldap_private_cert manage_channel_roles sysconsole_read_authentication_guest_access sysconsole_read_billing sysconsole_write_environment_developer sysconsole_read_user_management_teams read_deleted_posts sysconsole_write_environment_high_availability',1,1);
INSERT INTO `Roles` VALUES ('jh5f5efjm38ebdsypjutm1zjzr','system_manager','authentication.roles.system_manager.name','authentication.roles.system_manager.description',1684139050838,1684139055771,0,' sysconsole_write_site_public_links sysconsole_write_integrations_bot_accounts test_elasticsearch sysconsole_write_site_notices sysconsole_write_site_customization sysconsole_read_environment_developer sysconsole_read_authentication_password sysconsole_write_environment_logging sysconsole_write_environment_session_lengths sysconsole_read_products_boards manage_team test_email sysconsole_read_environment_logging sysconsole_write_site_localization get_logs read_ldap_sync_job read_license_information list_public_teams sysconsole_read_environment_rate_limiting sysconsole_write_user_management_groups join_public_teams join_private_teams sysconsole_read_site_emoji manage_team_roles sysconsole_read_user_management_groups sysconsole_write_integrations_gif sysconsole_write_environment_web_server sysconsole_read_site_announcement_banner sysconsole_write_user_management_teams sysconsole_write_site_notifications invalidate_caches sysconsole_write_site_announcement_banner test_site_url sysconsole_read_user_management_teams test_ldap sysconsole_read_site_posts sysconsole_write_site_file_sharing_and_downloads sysconsole_read_authentication_signup view_team recycle_database_connections sysconsole_write_environment_push_notification_server sysconsole_read_environment_session_lengths sysconsole_read_environment_smtp get_analytics sysconsole_read_site_notices sysconsole_read_user_management_permissions sysconsole_read_authentication_email purge_elasticsearch_indexes read_elasticsearch_post_indexing_job sysconsole_write_site_emoji convert_public_channel_to_private manage_private_channel_properties sysconsole_read_reporting_site_statistics read_elasticsearch_post_aggregation_job read_public_channel_groups create_elasticsearch_post_indexing_job sysconsole_write_integrations_cors manage_public_channel_members sysconsole_read_authentication_guest_access create_elasticsearch_post_aggregation_job sysconsole_write_environment_performance_monitoring sysconsole_write_products_boards sysconsole_write_environment_developer sysconsole_read_site_public_links sysconsole_write_user_management_permissions sysconsole_read_environment_push_notification_server sysconsole_write_environment_image_proxy sysconsole_write_site_users_and_teams sysconsole_read_site_file_sharing_and_downloads sysconsole_read_environment_performance_monitoring sysconsole_write_environment_smtp sysconsole_read_environment_elasticsearch delete_private_channel sysconsole_read_plugins sysconsole_read_site_users_and_teams sysconsole_read_environment_file_storage read_private_channel_groups read_public_channel sysconsole_read_site_localization sysconsole_write_environment_high_availability add_user_to_team sysconsole_write_integrations_integration_management sysconsole_read_reporting_team_statistics sysconsole_read_environment_image_proxy manage_private_channel_members sysconsole_read_authentication_mfa sysconsole_write_environment_file_storage reload_config sysconsole_read_authentication_openid sysconsole_write_environment_database sysconsole_read_environment_web_server sysconsole_write_environment_rate_limiting test_s3 remove_user_from_team list_private_teams read_channel sysconsole_read_authentication_saml edit_brand sysconsole_read_integrations_bot_accounts sysconsole_read_site_customization sysconsole_read_environment_database sysconsole_read_integrations_cors sysconsole_read_integrations_integration_management sysconsole_read_reporting_server_logs sysconsole_read_about_edition_and_license sysconsole_read_user_management_channels convert_private_channel_to_public sysconsole_write_site_posts sysconsole_write_environment_elasticsearch sysconsole_read_environment_high_availability sysconsole_read_authentication_ldap manage_public_channel_properties delete_public_channel sysconsole_read_site_notifications sysconsole_read_integrations_gif sysconsole_write_user_management_channels manage_channel_roles',0,1);
INSERT INTO `Roles` VALUES ('jsp8rgiy3tdwi8s3734gqn1t8a','team_admin','authentication.roles.team_admin.name','authentication.roles.team_admin.description',1684139050825,1684139055777,0,' remove_reaction create_post playbook_private_manage_roles read_private_channel_groups manage_team_roles convert_private_channel_to_public import_team read_public_channel_groups delete_others_posts manage_private_channel_members manage_public_channel_members manage_others_slash_commands manage_others_incoming_webhooks manage_incoming_webhooks manage_channel_roles convert_public_channel_to_private add_reaction manage_outgoing_webhooks manage_team use_group_mentions remove_user_from_team manage_others_outgoing_webhooks playbook_public_manage_roles use_channel_mentions manage_slash_commands delete_post',1,1);
INSERT INTO `Roles` VALUES ('jy7kh7nt8pbeuq3y9xnk99ofhy','playbook_admin','authentication.roles.playbook_admin.name','authentication.roles.playbook_admin.description',1684139050831,1684139055783,0,' playbook_private_manage_properties playbook_public_make_private playbook_public_manage_members playbook_public_manage_roles playbook_public_manage_properties playbook_private_manage_members playbook_private_manage_roles',1,1);
INSERT INTO `Roles` VALUES ('kfsh3mwix7gf7nmbz9osxu7w3h','system_user_access_token','authentication.roles.system_user_access_token.name','authentication.roles.system_user_access_token.description',1684139050917,1684139055789,0,' read_user_access_token revoke_user_access_token create_user_access_token',0,1);
INSERT INTO `Roles` VALUES ('mg3ei79rwjbb9cisojazuetrer','channel_admin','authentication.roles.channel_admin.name','authentication.roles.channel_admin.description',1684139050812,1684139055795,0,' remove_reaction read_public_channel_groups add_reaction use_channel_mentions use_group_mentions manage_private_channel_members manage_public_channel_members manage_channel_roles read_private_channel_groups create_post',1,1);
INSERT INTO `Roles` VALUES ('nnt36qb6ebgx9jp4jjstmm4x8c','channel_guest','authentication.roles.channel_guest.name','authentication.roles.channel_guest.description',1684139050898,1684139055801,0,' use_slash_commands read_channel add_reaction remove_reaction upload_file edit_post create_post use_channel_mentions',1,1);
INSERT INTO `Roles` VALUES ('u61ohe941brj9rbwji51s4umpy','team_post_all_public','authentication.roles.team_post_all_public.name','authentication.roles.team_post_all_public.description',1684139050865,1684139055808,0,' create_post_public use_channel_mentions use_group_mentions',0,1);
INSERT INTO `Roles` VALUES ('u74k94nxqtri7q4mrkanrwj4ky','system_custom_group_admin','authentication.roles.system_custom_group_admin.name','authentication.roles.system_custom_group_admin.description',1684139050805,1684139055815,0,' edit_custom_group delete_custom_group restore_custom_group manage_custom_group_members create_custom_group',0,1);
INSERT INTO `Roles` VALUES ('u9kkc9q3hfnbzn7cqh1ekqxxzr','system_post_all','authentication.roles.system_post_all.name','authentication.roles.system_post_all.description',1684139050791,1684139055821,0,' use_channel_mentions use_group_mentions create_post',0,1);
INSERT INTO `Roles` VALUES ('w393gw6mfi8djnr1iak81zsz9e','channel_user','authentication.roles.channel_user.name','authentication.roles.channel_user.description',1684139050853,1684139055827,0,' manage_public_channel_properties remove_reaction use_channel_mentions delete_post manage_public_channel_members read_private_channel_groups delete_private_channel add_reaction use_slash_commands upload_file use_group_mentions read_public_channel_groups get_public_link manage_private_channel_members read_channel manage_private_channel_properties create_post edit_post delete_public_channel',1,1);
INSERT INTO `Roles` VALUES ('ww84ayxwipyg9eyrcz3ikffy9e','system_read_only_admin','authentication.roles.system_read_only_admin.name','authentication.roles.system_read_only_admin.description',1684139050889,1684139055833,0,' sysconsole_read_integrations_gif sysconsole_read_site_users_and_teams read_elasticsearch_post_aggregation_job list_private_teams sysconsole_read_user_management_channels read_channel get_logs sysconsole_read_reporting_site_statistics sysconsole_read_products_boards sysconsole_read_about_edition_and_license sysconsole_read_experimental_feature_flags sysconsole_read_site_customization read_other_users_teams read_license_information sysconsole_read_authentication_password read_audits sysconsole_read_integrations_bot_accounts view_team sysconsole_read_environment_smtp sysconsole_read_site_localization sysconsole_read_experimental_features sysconsole_read_compliance_compliance_export sysconsole_read_authentication_saml test_ldap read_private_channel_groups sysconsole_read_authentication_signup download_compliance_export_result sysconsole_read_compliance_compliance_monitoring sysconsole_read_reporting_server_logs sysconsole_read_authentication_mfa sysconsole_read_integrations_integration_management sysconsole_read_environment_database sysconsole_read_site_file_sharing_and_downloads sysconsole_read_environment_elasticsearch sysconsole_read_user_management_permissions sysconsole_read_site_announcement_banner sysconsole_read_site_posts sysconsole_read_reporting_team_statistics sysconsole_read_authentication_openid sysconsole_read_user_management_teams sysconsole_read_plugins list_public_teams sysconsole_read_experimental_bleve sysconsole_read_integrations_cors sysconsole_read_environment_push_notification_server sysconsole_read_site_notices read_data_retention_job read_public_channel sysconsole_read_compliance_custom_terms_of_service sysconsole_read_authentication_guest_access sysconsole_read_environment_session_lengths sysconsole_read_environment_performance_monitoring sysconsole_read_environment_file_storage sysconsole_read_environment_high_availability sysconsole_read_compliance_data_retention_policy sysconsole_read_site_public_links sysconsole_read_authentication_email sysconsole_read_environment_image_proxy read_ldap_sync_job sysconsole_read_site_notifications read_elasticsearch_post_indexing_job get_analytics sysconsole_read_user_management_users sysconsole_read_environment_web_server sysconsole_read_environment_logging sysconsole_read_site_emoji sysconsole_read_user_management_groups sysconsole_read_environment_developer sysconsole_read_environment_rate_limiting sysconsole_read_authentication_ldap read_public_channel_groups read_compliance_export_job',0,1);
INSERT INTO `Roles` VALUES ('wxi1n6jnp7yt9xxezd6xtg43nh','system_guest','authentication.roles.global_guest.name','authentication.roles.global_guest.description',1684139050871,1684139055839,0,' create_group_channel create_direct_channel',1,1);
INSERT INTO `Roles` VALUES ('zdz95ncqn38ijggoho6h3e4ghr','playbook_member','authentication.roles.playbook_member.name','authentication.roles.playbook_member.description',1684139050738,1684139055845,0,' playbook_private_view playbook_private_manage_members playbook_private_manage_properties run_create playbook_public_view playbook_public_manage_members playbook_public_manage_properties',1,1);
INSERT INTO `SidebarCategories` VALUES ('channels_jactwicuqb8bu8pau8mgjydzeo_35odngbgr7yw3bf13o8kg85ngh','jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh',10,'','channels','Channels',0,0);
INSERT INTO `SidebarCategories` VALUES ('channels_k8crtspa5bfadc6iu6m93p4orh_35odngbgr7yw3bf13o8kg85ngh','k8crtspa5bfadc6iu6m93p4orh','35odngbgr7yw3bf13o8kg85ngh',10,'','channels','Channels',0,0);
INSERT INTO `SidebarCategories` VALUES ('direct_messages_jactwicuqb8bu8pau8mgjydzeo_35odngbgr7yw3bf13o8kg85ngh','jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh',20,'recent','direct_messages','Direct Messages',0,0);
INSERT INTO `SidebarCategories` VALUES ('direct_messages_k8crtspa5bfadc6iu6m93p4orh_35odngbgr7yw3bf13o8kg85ngh','k8crtspa5bfadc6iu6m93p4orh','35odngbgr7yw3bf13o8kg85ngh',20,'recent','direct_messages','Direct Messages',0,0);
INSERT INTO `SidebarCategories` VALUES ('favorites_jactwicuqb8bu8pau8mgjydzeo_35odngbgr7yw3bf13o8kg85ngh','jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh',0,'','favorites','Favorites',0,0);
INSERT INTO `SidebarCategories` VALUES ('favorites_k8crtspa5bfadc6iu6m93p4orh_35odngbgr7yw3bf13o8kg85ngh','k8crtspa5bfadc6iu6m93p4orh','35odngbgr7yw3bf13o8kg85ngh',0,'','favorites','Favorites',0,0);
INSERT INTO `Status` VALUES ('jactwicuqb8bu8pau8mgjydzeo','away',0,1684387416906,0,'');
INSERT INTO `Status` VALUES ('k8crtspa5bfadc6iu6m93p4orh','offline',0,1684153509983,0,'');
INSERT INTO `Systems` VALUES ('about_subsection_permissions','true');
INSERT INTO `Systems` VALUES ('add_billing_permissions','true');
INSERT INTO `Systems` VALUES ('add_bot_permissions','true');
INSERT INTO `Systems` VALUES ('add_convert_channel_permissions','true');
INSERT INTO `Systems` VALUES ('add_manage_guests_permissions','true');
INSERT INTO `Systems` VALUES ('add_system_console_permissions','true');
INSERT INTO `Systems` VALUES ('add_system_roles_permissions','true');
INSERT INTO `Systems` VALUES ('add_use_group_mentions_permission','true');
INSERT INTO `Systems` VALUES ('AdvancedPermissionsMigrationComplete','true');
INSERT INTO `Systems` VALUES ('apply_channel_manage_delete_to_channel_user','true');
INSERT INTO `Systems` VALUES ('AsymmetricSigningKey','{\"ecdsa_key\":{\"curve\":\"P-256\",\"x\":39885688012791743430902392044132023131306318630717482885626462746284368676562,\"y\":56732587617706431314588083882840694296577699304576161589544790090711522351963,\"d\":61158628144358852948138055426802208098608450055237759428816151150343005223320}}');
INSERT INTO `Systems` VALUES ('authentication_subsection_permissions','true');
INSERT INTO `Systems` VALUES ('channel_moderations_permissions','true');
INSERT INTO `Systems` VALUES ('compliance_subsection_permissions','true');
INSERT INTO `Systems` VALUES ('ContentExtractionConfigDefaultTrueMigrationComplete','true');
INSERT INTO `Systems` VALUES ('CRTChannelMembershipCountsMigrationComplete','true');
INSERT INTO `Systems` VALUES ('CRTThreadCountsAndUnreadsMigrationComplete','true');
INSERT INTO `Systems` VALUES ('CustomGroupAdminRoleCreationMigrationComplete','true');
INSERT INTO `Systems` VALUES ('custom_groups_permissions','true');
INSERT INTO `Systems` VALUES ('custom_groups_permission_restore','true');
INSERT INTO `Systems` VALUES ('DiagnosticId','6nz6d7fp5tdcbrfui1xnubzr8o');
INSERT INTO `Systems` VALUES ('download_compliance_export_results','true');
INSERT INTO `Systems` VALUES ('EmojisPermissionsMigrationComplete','true');
INSERT INTO `Systems` VALUES ('emoji_permissions_split','true');
INSERT INTO `Systems` VALUES ('environment_subsection_permissions','true');
INSERT INTO `Systems` VALUES ('experimental_subsection_permissions','true');
INSERT INTO `Systems` VALUES ('FirstServerRunTimestamp','1684139050764');
INSERT INTO `Systems` VALUES ('GuestRolesCreationMigrationComplete','true');
INSERT INTO `Systems` VALUES ('InstallationDate','1684139058969');
INSERT INTO `Systems` VALUES ('integrations_subsection_permissions','true');
INSERT INTO `Systems` VALUES ('LastSecurityTime','1684386571805');
INSERT INTO `Systems` VALUES ('list_join_public_private_teams','true');
INSERT INTO `Systems` VALUES ('manage_secure_connections_permissions','true');
INSERT INTO `Systems` VALUES ('manage_shared_channel_permissions','true');
INSERT INTO `Systems` VALUES ('migration_advanced_permissions_phase_2','true');
INSERT INTO `Systems` VALUES ('PlaybookRolesCreationMigrationComplete','true');
INSERT INTO `Systems` VALUES ('playbooks_manage_roles','true');
INSERT INTO `Systems` VALUES ('playbooks_permissions','true');
INSERT INTO `Systems` VALUES ('PostActionCookieSecret','{\"key\":\"YotujW0OeUnuIjCwfomw+BuaoB63KtxoBb6NLLrlzIA=\"}');
INSERT INTO `Systems` VALUES ('PostPriorityConfigDefaultTrueMigrationComplete','true');
INSERT INTO `Systems` VALUES ('products_boards','true');
INSERT INTO `Systems` VALUES ('RemainingSchemaMigrations','true');
INSERT INTO `Systems` VALUES ('remove_channel_manage_delete_from_team_user','true');
INSERT INTO `Systems` VALUES ('remove_permanent_delete_user','true');
INSERT INTO `Systems` VALUES ('reporting_subsection_permissions','true');
INSERT INTO `Systems` VALUES ('site_subsection_permissions','true');
INSERT INTO `Systems` VALUES ('SystemConsoleRolesCreationMigrationComplete','true');
INSERT INTO `Systems` VALUES ('test_email_ancillary_permission','true');
INSERT INTO `Systems` VALUES ('view_members_new_permission','true');
INSERT INTO `Systems` VALUES ('webhook_permissions_split','true');
INSERT INTO `TeamMembers` VALUES ('35odngbgr7yw3bf13o8kg85ngh','jactwicuqb8bu8pau8mgjydzeo','',0,1,1,0,1684139715876);
INSERT INTO `TeamMembers` VALUES ('35odngbgr7yw3bf13o8kg85ngh','k8crtspa5bfadc6iu6m93p4orh','',0,1,0,0,1684146863252);
INSERT INTO `Teams` VALUES ('35odngbgr7yw3bf13o8kg85ngh',1684139715847,1684139715847,0,'nautobot-test-team','nautobot-test-team','','admin@example.com','O','','','p6beof3e5fyxzgboo3ana6ra6c',NULL,0,0,NULL,0);
INSERT INTO `UserAccessTokens` VALUES ('pjz3u1ru3jfkt8ib5fz4sraybw','5qsffxoapt883qfdygbdgf17jy','k8crtspa5bfadc6iu6m93p4orh','nautobot',1);
INSERT INTO `Users` VALUES ('6g9zjk1d7brz8rqiypd9kypn5c',1684139058969,1684139059003,0,'feedbackbot','',NULL,'','feedbackbot@localhost',0,'','Feedbackbot','','system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684139058969,1684139059003,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL);
INSERT INTO `Users` VALUES ('d6eb3jh8iprzpxim14w9hkopbr',1684139114820,1684139114820,0,'boards','',NULL,'','boards@localhost',0,'','Boards','','system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684139114820,0,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL);
INSERT INTO `Users` VALUES ('dk8nggnjtt8yipcbmuqem4rfkc',1684139700005,1684139700005,0,'system-bot','',NULL,'','system-bot@localhost',0,'','System','','system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684139700005,0,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL);
INSERT INTO `Users` VALUES ('jactwicuqb8bu8pau8mgjydzeo',1684139698424,1684251561795,0,'admin','$2a$10$FA7sexy5OipYSWLIYaKTQOHrgRCFSUkxoGRA1X4nXvX3oSL2dEMoG',NULL,'','admin@example.com',0,'','','','system_admin system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684251561795,0,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL);
INSERT INTO `Users` VALUES ('k8crtspa5bfadc6iu6m93p4orh',1684146025502,1684146863269,0,'nautobot-test-bot','',NULL,'','nautobot-test-bot@localhost',0,'','Nautobot Test Bot','','system_user system_admin',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684146025502,0,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL);
INSERT INTO `Users` VALUES ('o113xcgte78kpezuouwcr6abpo',1684139059883,1684139059883,0,'calls','',NULL,'','calls@localhost',0,'','Calls','','system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684139059883,0,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL);
INSERT INTO `Users` VALUES ('ozpddc4xxi85tmrwaqsjmgw1kc',1684139059816,1684387226829,0,'playbooks','',NULL,'','playbooks@localhost',0,'','Playbooks','','system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684139059816,1684387226829,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL);
INSERT INTO `Users` VALUES ('qmaiqbz1e3fo8qz1nsmkhqbznh',1684139059446,1684387226467,0,'appsbot','',NULL,'','appsbot@localhost',0,'','Mattermost Apps','','system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684139059446,1684387226467,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL);
INSERT INTO `db_migrations` VALUES (1,'create_teams');
INSERT INTO `db_migrations` VALUES (2,'create_team_members');
INSERT INTO `db_migrations` VALUES (3,'create_cluster_discovery');
INSERT INTO `db_migrations` VALUES (4,'create_command_webhooks');
INSERT INTO `db_migrations` VALUES (5,'create_compliances');
INSERT INTO `db_migrations` VALUES (6,'create_emojis');
INSERT INTO `db_migrations` VALUES (7,'create_user_groups');
INSERT INTO `db_migrations` VALUES (8,'create_group_members');
INSERT INTO `db_migrations` VALUES (9,'create_group_teams');
INSERT INTO `db_migrations` VALUES (10,'create_group_channels');
INSERT INTO `db_migrations` VALUES (11,'create_link_metadata');
INSERT INTO `db_migrations` VALUES (12,'create_commands');
INSERT INTO `db_migrations` VALUES (13,'create_incoming_webhooks');
INSERT INTO `db_migrations` VALUES (14,'create_outgoing_webhooks');
INSERT INTO `db_migrations` VALUES (15,'create_systems');
INSERT INTO `db_migrations` VALUES (16,'create_reactions');
INSERT INTO `db_migrations` VALUES (17,'create_roles');
INSERT INTO `db_migrations` VALUES (18,'create_schemes');
INSERT INTO `db_migrations` VALUES (19,'create_licenses');
INSERT INTO `db_migrations` VALUES (20,'create_posts');
INSERT INTO `db_migrations` VALUES (21,'create_product_notice_view_state');
INSERT INTO `db_migrations` VALUES (22,'create_sessions');
INSERT INTO `db_migrations` VALUES (23,'create_terms_of_service');
INSERT INTO `db_migrations` VALUES (24,'create_audits');
INSERT INTO `db_migrations` VALUES (25,'create_oauth_access_data');
INSERT INTO `db_migrations` VALUES (26,'create_preferences');
INSERT INTO `db_migrations` VALUES (27,'create_status');
INSERT INTO `db_migrations` VALUES (28,'create_tokens');
INSERT INTO `db_migrations` VALUES (29,'create_bots');
INSERT INTO `db_migrations` VALUES (30,'create_user_access_tokens');
INSERT INTO `db_migrations` VALUES (31,'create_remote_clusters');
INSERT INTO `db_migrations` VALUES (32,'create_sharedchannels');
INSERT INTO `db_migrations` VALUES (33,'create_sidebar_channels');
INSERT INTO `db_migrations` VALUES (34,'create_oauthauthdata');
INSERT INTO `db_migrations` VALUES (35,'create_sharedchannelattachments');
INSERT INTO `db_migrations` VALUES (36,'create_sharedchannelusers');
INSERT INTO `db_migrations` VALUES (37,'create_sharedchannelremotes');
INSERT INTO `db_migrations` VALUES (38,'create_jobs');
INSERT INTO `db_migrations` VALUES (39,'create_channel_member_history');
INSERT INTO `db_migrations` VALUES (40,'create_sidebar_categories');
INSERT INTO `db_migrations` VALUES (41,'create_upload_sessions');
INSERT INTO `db_migrations` VALUES (42,'create_threads');
INSERT INTO `db_migrations` VALUES (43,'thread_memberships');
INSERT INTO `db_migrations` VALUES (44,'create_user_terms_of_service');
INSERT INTO `db_migrations` VALUES (45,'create_plugin_key_value_store');
INSERT INTO `db_migrations` VALUES (46,'create_users');
INSERT INTO `db_migrations` VALUES (47,'create_file_info');
INSERT INTO `db_migrations` VALUES (48,'create_oauth_apps');
INSERT INTO `db_migrations` VALUES (49,'create_channels');
INSERT INTO `db_migrations` VALUES (50,'create_channelmembers');
INSERT INTO `db_migrations` VALUES (51,'create_msg_root_count');
INSERT INTO `db_migrations` VALUES (52,'create_public_channels');
INSERT INTO `db_migrations` VALUES (53,'create_retention_policies');
INSERT INTO `db_migrations` VALUES (54,'create_crt_channelmembership_count');
INSERT INTO `db_migrations` VALUES (55,'create_crt_thread_count_and_unreads');
INSERT INTO `db_migrations` VALUES (56,'upgrade_channels_v6.0');
INSERT INTO `db_migrations` VALUES (57,'upgrade_command_webhooks_v6.0');
INSERT INTO `db_migrations` VALUES (58,'upgrade_channelmembers_v6.0');
INSERT INTO `db_migrations` VALUES (59,'upgrade_users_v6.0');
INSERT INTO `db_migrations` VALUES (60,'upgrade_jobs_v6.0');
INSERT INTO `db_migrations` VALUES (61,'upgrade_link_metadata_v6.0');
INSERT INTO `db_migrations` VALUES (62,'upgrade_sessions_v6.0');
INSERT INTO `db_migrations` VALUES (63,'upgrade_threads_v6.0');
INSERT INTO `db_migrations` VALUES (64,'upgrade_status_v6.0');
INSERT INTO `db_migrations` VALUES (65,'upgrade_groupchannels_v6.0');
INSERT INTO `db_migrations` VALUES (66,'upgrade_posts_v6.0');
INSERT INTO `db_migrations` VALUES (67,'upgrade_channelmembers_v6.1');
INSERT INTO `db_migrations` VALUES (68,'upgrade_teammembers_v6.1');
INSERT INTO `db_migrations` VALUES (69,'upgrade_jobs_v6.1');
INSERT INTO `db_migrations` VALUES (70,'upgrade_cte_v6.1');
INSERT INTO `db_migrations` VALUES (71,'upgrade_sessions_v6.1');
INSERT INTO `db_migrations` VALUES (72,'upgrade_schemes_v6.3');
INSERT INTO `db_migrations` VALUES (73,'upgrade_plugin_key_value_store_v6.3');
INSERT INTO `db_migrations` VALUES (74,'upgrade_users_v6.3');
INSERT INTO `db_migrations` VALUES (75,'alter_upload_sessions_index');
INSERT INTO `db_migrations` VALUES (76,'upgrade_lastrootpostat');
INSERT INTO `db_migrations` VALUES (77,'upgrade_users_v6.5');
INSERT INTO `db_migrations` VALUES (78,'create_oauth_mattermost_app_id');
INSERT INTO `db_migrations` VALUES (79,'usergroups_displayname_index');
INSERT INTO `db_migrations` VALUES (80,'posts_createat_id');
INSERT INTO `db_migrations` VALUES (81,'threads_deleteat');
INSERT INTO `db_migrations` VALUES (82,'upgrade_oauth_mattermost_app_id');
INSERT INTO `db_migrations` VALUES (83,'threads_threaddeleteat');
INSERT INTO `db_migrations` VALUES (84,'recent_searches');
INSERT INTO `db_migrations` VALUES (85,'fileinfo_add_archived_column');
INSERT INTO `db_migrations` VALUES (86,'add_cloud_limits_archived');
INSERT INTO `db_migrations` VALUES (87,'sidebar_categories_index');
INSERT INTO `db_migrations` VALUES (88,'remaining_migrations');
INSERT INTO `db_migrations` VALUES (89,'add-channelid-to-reaction');
INSERT INTO `db_migrations` VALUES (90,'create_enums');
INSERT INTO `db_migrations` VALUES (91,'create_post_reminder');
INSERT INTO `db_migrations` VALUES (92,'add_createat_to_teammembers');
INSERT INTO `db_migrations` VALUES (93,'notify_admin');
INSERT INTO `db_migrations` VALUES (94,'threads_teamid');
INSERT INTO `db_migrations` VALUES (95,'remove_posts_parentid');
INSERT INTO `db_migrations` VALUES (96,'threads_threadteamid');
INSERT INTO `db_migrations` VALUES (97,'create_posts_priority');
INSERT INTO `db_migrations` VALUES (98,'create_post_acknowledgements');
INSERT INTO `db_migrations` VALUES (99,'create_drafts');
INSERT INTO `db_migrations` VALUES (100,'add_draft_priority_column');
INSERT INTO `db_migrations` VALUES (101,'create_true_up_review_history');
INSERT INTO `db_migrations` VALUES (102,'posts_originalid_index');
INSERT INTO `db_migrations` VALUES (103,'add_sentat_to_notifyadmin');
INSERT INTO `db_migrations` VALUES (104,'upgrade_notifyadmin');
INSERT INTO `db_migrations` VALUES (105,'remove_tokens');
INSERT INTO `focalboard_schema_migrations` VALUES (1,'init');
INSERT INTO `focalboard_schema_migrations` VALUES (2,'system_settings_table');
INSERT INTO `focalboard_schema_migrations` VALUES (3,'blocks_rootid');
INSERT INTO `focalboard_schema_migrations` VALUES (4,'auth_table');
INSERT INTO `focalboard_schema_migrations` VALUES (5,'blocks_modifiedby');
INSERT INTO `focalboard_schema_migrations` VALUES (6,'sharing_table');
INSERT INTO `focalboard_schema_migrations` VALUES (7,'workspaces_table');
INSERT INTO `focalboard_schema_migrations` VALUES (8,'teams');
INSERT INTO `focalboard_schema_migrations` VALUES (9,'blocks_history');
INSERT INTO `focalboard_schema_migrations` VALUES (10,'blocks_created_by');
INSERT INTO `focalboard_schema_migrations` VALUES (11,'match_collation');
INSERT INTO `focalboard_schema_migrations` VALUES (12,'match_column_collation');
INSERT INTO `focalboard_schema_migrations` VALUES (13,'millisecond_timestamps');
INSERT INTO `focalboard_schema_migrations` VALUES (14,'add_not_null_constraint');
INSERT INTO `focalboard_schema_migrations` VALUES (15,'blocks_history_no_nulls');
INSERT INTO `focalboard_schema_migrations` VALUES (16,'subscriptions_table');
INSERT INTO `focalboard_schema_migrations` VALUES (17,'add_file_info');
INSERT INTO `focalboard_schema_migrations` VALUES (18,'add_teams_and_boards');
INSERT INTO `focalboard_schema_migrations` VALUES (19,'populate_categories');
INSERT INTO `focalboard_schema_migrations` VALUES (20,'populate_category_blocks');
INSERT INTO `focalboard_schema_migrations` VALUES (21,'create_boards_members_history');
INSERT INTO `focalboard_schema_migrations` VALUES (22,'create_default_board_role');
INSERT INTO `focalboard_schema_migrations` VALUES (23,'persist_category_collapsed_state');
INSERT INTO `focalboard_schema_migrations` VALUES (24,'mark_existsing_categories_collapsed');
INSERT INTO `focalboard_schema_migrations` VALUES (25,'indexes_update');
INSERT INTO `focalboard_schema_migrations` VALUES (26,'create_preferences_table');
INSERT INTO `focalboard_schema_migrations` VALUES (27,'migrate_user_props_to_preferences');
INSERT INTO `focalboard_schema_migrations` VALUES (28,'remove_template_channel_link');
INSERT INTO `focalboard_schema_migrations` VALUES (29,'add_category_type_field');
INSERT INTO `focalboard_schema_migrations` VALUES (30,'add_category_sort_order');
INSERT INTO `focalboard_schema_migrations` VALUES (31,'add_category_boards_sort_order');
INSERT INTO `focalboard_schema_migrations` VALUES (32,'move_boards_category_to_end');
INSERT INTO `focalboard_system_settings` VALUES ('CategoryUuidIdMigrationComplete','true');
INSERT INTO `focalboard_system_settings` VALUES ('DeletedMembershipBoardsMigrationComplete','true');
INSERT INTO `focalboard_system_settings` VALUES ('TeamLessBoardsMigrationComplete','true');
INSERT INTO `focalboard_system_settings` VALUES ('UniqueIDsMigrationComplete','true');

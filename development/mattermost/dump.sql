-- MySQL dump 10.13  Distrib 5.7.42, for Linux (x86_64)
--
-- Host: localhost    Database: mattermost_test
-- ------------------------------------------------------
-- Server version	5.7.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `mattermost_test`
--

/*!40000 DROP DATABASE IF EXISTS `mattermost_test`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mattermost_test` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `mattermost_test`;

--
-- Table structure for table `Audits`
--

DROP TABLE IF EXISTS `Audits`;
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

--
-- Dumping data for table `Audits`
--

LOCK TABLES `Audits` WRITE;
/*!40000 ALTER TABLE `Audits` DISABLE KEYS */;
INSERT INTO `Audits` VALUES ('1qi5ohrrcbbq7rmexmq8u7cuac',1684145291469,'','/api/v4/users/login','attempt - login_id=admin','192.168.48.1',''),('36e8ix6owt83dcwdobchwfp6ra',1684152166233,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/commands/d9irq7zuwt84pr77crnteso6da','success','192.168.64.1','dw6g5oeycbdi5gyw64u8p1nofh'),('4qrc4pmfb7nxpro6bfe8i9astr',1684139698831,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/users/login','authenticated','172.28.0.1',''),('4ugke7ppjpg7uperipryq33f8y',1684146025788,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/users/k8crtspa5bfadc6iu6m93p4orh/tokens','','192.168.48.1','dw6g5oeycbdi5gyw64u8p1nofh'),('4uhwbubi8bfxzgu3caqqb1hm7h',1684145971645,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/config','updateConfig','192.168.48.1','dw6g5oeycbdi5gyw64u8p1nofh'),('6axpbhxogjni5nizy9rwnacjgo',1684139698687,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/users/login','attempt - login_id=','172.28.0.1',''),('6k7w89gsb7rcpgiu1jp6oc8kmr',1684152166219,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/commands/d9irq7zuwt84pr77crnteso6da','attempt','192.168.64.1','dw6g5oeycbdi5gyw64u8p1nofh'),('7sf9meyfktyapmbzzsf9o9qx8a',1684147036292,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/commands/d9irq7zuwt84pr77crnteso6da','attempt','192.168.48.1','dw6g5oeycbdi5gyw64u8p1nofh'),('a9oryxpz6id4td5wqnbbdez7ao',1684145275246,'','/api/v4/users/login','attempt - login_id=admin','192.168.48.1',''),('amx4k5ttkpyq7pgnckoc4w1f1h',1684139698841,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/users/login','success session_user=jactwicuqb8bu8pau8mgjydzeo','172.28.0.1','jnxgm3466bnipmud87ksmobhqo'),('apu674aertb3zjo4mturasz4ch',1684146025872,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/users/k8crtspa5bfadc6iu6m93p4orh/roles','user=k8crtspa5bfadc6iu6m93p4orh roles=system_user system_admin','192.168.48.1','dw6g5oeycbdi5gyw64u8p1nofh'),('az3rf37jffg9x8eg8es79rugmy',1684146546774,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/commands','success','192.168.48.1','dw6g5oeycbdi5gyw64u8p1nofh'),('cqtfs4r1c7r3ukq4fdjzqo6rxa',1684145275472,'','/api/v4/users/login','failure - login_id=admin','192.168.48.1',''),('dus67hkw8f8ymdezxtiomakknc',1684146025799,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/users/k8crtspa5bfadc6iu6m93p4orh/tokens','success - token_id=jkfdci9k97fk3j5wkofqjfmnte','192.168.48.1','dw6g5oeycbdi5gyw64u8p1nofh'),('ec13bjm5rprgik6sor1wwrdior',1684145291718,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/users/login','success session_user=jactwicuqb8bu8pau8mgjydzeo','192.168.48.1','dw6g5oeycbdi5gyw64u8p1nofh'),('h3yww66zyigtud1yjwewn817or',1684147036308,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/commands/d9irq7zuwt84pr77crnteso6da','success','192.168.48.1','dw6g5oeycbdi5gyw64u8p1nofh'),('i3gonnqn43bjmrts5fyrdcepuo',1684139741482,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/config','updateConfig','172.28.0.1','jnxgm3466bnipmud87ksmobhqo'),('p17kc5cnnib9trra959t8qojna',1684145291692,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/users/login','authenticated','192.168.48.1',''),('rb6qyfm6nffh5ps7u4686iu3fa',1684146546759,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/commands','attempt','192.168.48.1','dw6g5oeycbdi5gyw64u8p1nofh'),('xjhur44i4ig79f4badhji5g31e',1684146025686,'jactwicuqb8bu8pau8mgjydzeo','/api/v4/users/k8crtspa5bfadc6iu6m93p4orh/image','','192.168.48.1','dw6g5oeycbdi5gyw64u8p1nofh');
/*!40000 ALTER TABLE `Audits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Bots`
--

DROP TABLE IF EXISTS `Bots`;
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

--
-- Dumping data for table `Bots`
--

LOCK TABLES `Bots` WRITE;
/*!40000 ALTER TABLE `Bots` DISABLE KEYS */;
INSERT INTO `Bots` VALUES ('6g9zjk1d7brz8rqiypd9kypn5c','Feedbackbot collects user feedback to improve Mattermost. [Learn more](https://mattermost.com/pl/default-nps).','com.mattermost.nps',1684139058981,1684139058981,0,0),('d6eb3jh8iprzpxim14w9hkopbr','Created by Boards plugin.','focalboard',1684139114835,1684139114835,0,0),('dk8nggnjtt8yipcbmuqem4rfkc','','jactwicuqb8bu8pau8mgjydzeo',1684139700012,1684139700012,0,0),('k8crtspa5bfadc6iu6m93p4orh','Nautobot Test Bot','jactwicuqb8bu8pau8mgjydzeo',1684146025510,1684146025510,0,0),('o113xcgte78kpezuouwcr6abpo','Calls Bot','com.mattermost.calls',1684139059888,1684139059888,0,0),('ozpddc4xxi85tmrwaqsjmgw1kc','Playbooks bot.','playbooks',1684139059822,1684139059822,0,0),('qmaiqbz1e3fo8qz1nsmkhqbznh','Mattermost Apps Registry and API proxy.','com.mattermost.apps',1684139059460,1684139059460,0,0);
/*!40000 ALTER TABLE `Bots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ChannelMemberHistory`
--

DROP TABLE IF EXISTS `ChannelMemberHistory`;
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

--
-- Dumping data for table `ChannelMemberHistory`
--

LOCK TABLES `ChannelMemberHistory` WRITE;
/*!40000 ALTER TABLE `ChannelMemberHistory` DISABLE KEYS */;
INSERT INTO `ChannelMemberHistory` VALUES ('8sz36rga1in69gaunpogq95r1w','jactwicuqb8bu8pau8mgjydzeo',1684139715936,NULL),('8sz36rga1in69gaunpogq95r1w','k8crtspa5bfadc6iu6m93p4orh',1684146863338,NULL),('9g8qo5udpp8dzdud8jex1m6kuh','jactwicuqb8bu8pau8mgjydzeo',1684146025550,NULL),('9g8qo5udpp8dzdud8jex1m6kuh','k8crtspa5bfadc6iu6m93p4orh',1684146025541,NULL),('fi1muawz1bybue4gwu95kni4eh','jactwicuqb8bu8pau8mgjydzeo',1684139716008,NULL),('fi1muawz1bybue4gwu95kni4eh','k8crtspa5bfadc6iu6m93p4orh',1684146863404,NULL);
/*!40000 ALTER TABLE `ChannelMemberHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ChannelMembers`
--

DROP TABLE IF EXISTS `ChannelMembers`;
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

--
-- Dumping data for table `ChannelMembers`
--

LOCK TABLES `ChannelMembers` WRITE;
/*!40000 ALTER TABLE `ChannelMembers` DISABLE KEYS */;
INSERT INTO `ChannelMembers` VALUES ('8sz36rga1in69gaunpogq95r1w','jactwicuqb8bu8pau8mgjydzeo','',1684153509947,2,0,'{\"push\": \"default\", \"email\": \"default\", \"desktop\": \"default\", \"mark_unread\": \"all\", \"ignore_channel_mentions\": \"default\"}',1684153509947,1,1,0,0,2,0),('8sz36rga1in69gaunpogq95r1w','k8crtspa5bfadc6iu6m93p4orh','',0,0,0,'{\"push\": \"default\", \"email\": \"default\", \"desktop\": \"default\", \"mark_unread\": \"all\", \"ignore_channel_mentions\": \"default\"}',1684146863323,1,0,0,0,0,0),('9g8qo5udpp8dzdud8jex1m6kuh','jactwicuqb8bu8pau8mgjydzeo','',1684146025577,1,0,'{\"push\": \"default\", \"email\": \"default\", \"desktop\": \"default\", \"mark_unread\": \"all\", \"ignore_channel_mentions\": \"default\"}',1684146025577,1,0,0,0,1,0),('9g8qo5udpp8dzdud8jex1m6kuh','k8crtspa5bfadc6iu6m93p4orh','',0,0,0,'{\"push\": \"default\", \"email\": \"default\", \"desktop\": \"default\", \"mark_unread\": \"all\", \"ignore_channel_mentions\": \"default\"}',1684146025519,1,0,0,0,0,0),('fi1muawz1bybue4gwu95kni4eh','jactwicuqb8bu8pau8mgjydzeo','',1684139716016,0,0,'{\"push\": \"default\", \"email\": \"default\", \"desktop\": \"default\", \"mark_unread\": \"all\", \"ignore_channel_mentions\": \"default\"}',1684139716016,1,1,0,0,0,0),('fi1muawz1bybue4gwu95kni4eh','k8crtspa5bfadc6iu6m93p4orh','',0,0,1,'{\"push\": \"default\", \"email\": \"default\", \"desktop\": \"default\", \"mark_unread\": \"all\", \"ignore_channel_mentions\": \"default\"}',1684146863438,1,0,0,1,0,0);
/*!40000 ALTER TABLE `ChannelMembers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Channels`
--

DROP TABLE IF EXISTS `Channels`;
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

--
-- Dumping data for table `Channels`
--

LOCK TABLES `Channels` WRITE;
/*!40000 ALTER TABLE `Channels` DISABLE KEYS */;
INSERT INTO `Channels` VALUES ('8sz36rga1in69gaunpogq95r1w',1684139715853,1684139715853,0,'35odngbgr7yw3bf13o8kg85ngh','O','Town Square','town-square','','',1684153509947,2,0,'',NULL,NULL,NULL,2,1684153509947),('9g8qo5udpp8dzdud8jex1m6kuh',1684146025517,1684146025517,0,'','D','','jactwicuqb8bu8pau8mgjydzeo__k8crtspa5bfadc6iu6m93p4orh','','',1684146025577,1,0,'k8crtspa5bfadc6iu6m93p4orh',NULL,NULL,0,1,1684146025577),('fi1muawz1bybue4gwu95kni4eh',1684139715866,1684139715866,0,'35odngbgr7yw3bf13o8kg85ngh','O','Off-Topic','off-topic','','',1684146863411,0,0,'',NULL,NULL,NULL,0,1684146863411);
/*!40000 ALTER TABLE `Channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ClusterDiscovery`
--

DROP TABLE IF EXISTS `ClusterDiscovery`;
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

--
-- Dumping data for table `ClusterDiscovery`
--

LOCK TABLES `ClusterDiscovery` WRITE;
/*!40000 ALTER TABLE `ClusterDiscovery` DISABLE KEYS */;
/*!40000 ALTER TABLE `ClusterDiscovery` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CommandWebhooks`
--

DROP TABLE IF EXISTS `CommandWebhooks`;
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

--
-- Dumping data for table `CommandWebhooks`
--

LOCK TABLES `CommandWebhooks` WRITE;
/*!40000 ALTER TABLE `CommandWebhooks` DISABLE KEYS */;
INSERT INTO `CommandWebhooks` VALUES ('34x3f6yci38nfbyk388giw7scy',1684153509146,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('54kkj95xmpny5jjq884gryjh1y',1684151992215,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('6hqj5yebt7fuignbzju6hkb1ke',1684151874168,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('8ja448eyh7ghjbn7thbdnkej3o',1684152425434,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('acazxm9nmjr5iyxjg4zi4nssoo',1684151581835,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('dapf9z48apb17mr9ochs94qh5o',1684151708143,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('dzry9xe8yfdh9emp51euyjy8he',1684152200905,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('hh9hj96ssj8xiyob9xokbhhqaa',1684153523427,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('io33b7kizjfmzdsghad3mi7dga',1684152038770,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('j3me9kwm5tnkdmstrc4s5uqaxw',1684151822564,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('kaj154ar7jgpur8ggato7bdynw',1684151883749,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('oagfq1zj7igoxg9rqoo7qg3gca',1684152445945,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('pnef7aj6d3yydqya1br3h45dce',1684153462525,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('ut9ukstarjypfmroufa9xfp9bh',1684152134404,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('wkgq35wpd78xinwyasq8dhz4rr',1684152618302,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0),('xwzhchse1frft8xxu46tiu4owa',1684152175408,'d9irq7zuwt84pr77crnteso6da','jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','',0);
/*!40000 ALTER TABLE `CommandWebhooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Commands`
--

DROP TABLE IF EXISTS `Commands`;
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

--
-- Dumping data for table `Commands`
--

LOCK TABLES `Commands` WRITE;
/*!40000 ALTER TABLE `Commands` DISABLE KEYS */;
INSERT INTO `Commands` VALUES ('d9irq7zuwt84pr77crnteso6da','rmdpfdjhnpg988e7ujzyom4euh',1684146546769,1684152166227,0,'jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh','nautobot','P','','',0,'','','Nautobot','Nautobot Slash Command','http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/','');
/*!40000 ALTER TABLE `Commands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Compliances`
--

DROP TABLE IF EXISTS `Compliances`;
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

--
-- Dumping data for table `Compliances`
--

LOCK TABLES `Compliances` WRITE;
/*!40000 ALTER TABLE `Compliances` DISABLE KEYS */;
/*!40000 ALTER TABLE `Compliances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Drafts`
--

DROP TABLE IF EXISTS `Drafts`;
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

--
-- Dumping data for table `Drafts`
--

LOCK TABLES `Drafts` WRITE;
/*!40000 ALTER TABLE `Drafts` DISABLE KEYS */;
INSERT INTO `Drafts` VALUES (1684146834706,1684149534264,1684149534264,'jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','','','{}','[]','null');
/*!40000 ALTER TABLE `Drafts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Emoji`
--

DROP TABLE IF EXISTS `Emoji`;
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

--
-- Dumping data for table `Emoji`
--

LOCK TABLES `Emoji` WRITE;
/*!40000 ALTER TABLE `Emoji` DISABLE KEYS */;
/*!40000 ALTER TABLE `Emoji` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FileInfo`
--

DROP TABLE IF EXISTS `FileInfo`;
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

--
-- Dumping data for table `FileInfo`
--

LOCK TABLES `FileInfo` WRITE;
/*!40000 ALTER TABLE `FileInfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `FileInfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GroupChannels`
--

DROP TABLE IF EXISTS `GroupChannels`;
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

--
-- Dumping data for table `GroupChannels`
--

LOCK TABLES `GroupChannels` WRITE;
/*!40000 ALTER TABLE `GroupChannels` DISABLE KEYS */;
/*!40000 ALTER TABLE `GroupChannels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GroupMembers`
--

DROP TABLE IF EXISTS `GroupMembers`;
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

--
-- Dumping data for table `GroupMembers`
--

LOCK TABLES `GroupMembers` WRITE;
/*!40000 ALTER TABLE `GroupMembers` DISABLE KEYS */;
/*!40000 ALTER TABLE `GroupMembers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GroupTeams`
--

DROP TABLE IF EXISTS `GroupTeams`;
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

--
-- Dumping data for table `GroupTeams`
--

LOCK TABLES `GroupTeams` WRITE;
/*!40000 ALTER TABLE `GroupTeams` DISABLE KEYS */;
/*!40000 ALTER TABLE `GroupTeams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_Category`
--

DROP TABLE IF EXISTS `IR_Category`;
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

--
-- Dumping data for table `IR_Category`
--

LOCK TABLES `IR_Category` WRITE;
/*!40000 ALTER TABLE `IR_Category` DISABLE KEYS */;
/*!40000 ALTER TABLE `IR_Category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_Category_Item`
--

DROP TABLE IF EXISTS `IR_Category_Item`;
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

--
-- Dumping data for table `IR_Category_Item`
--

LOCK TABLES `IR_Category_Item` WRITE;
/*!40000 ALTER TABLE `IR_Category_Item` DISABLE KEYS */;
/*!40000 ALTER TABLE `IR_Category_Item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_ChannelAction`
--

DROP TABLE IF EXISTS `IR_ChannelAction`;
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

--
-- Dumping data for table `IR_ChannelAction`
--

LOCK TABLES `IR_ChannelAction` WRITE;
/*!40000 ALTER TABLE `IR_ChannelAction` DISABLE KEYS */;
/*!40000 ALTER TABLE `IR_ChannelAction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_Incident`
--

DROP TABLE IF EXISTS `IR_Incident`;
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
  PRIMARY KEY (`ID`),
  KEY `IR_Incident_TeamID` (`TeamID`),
  KEY `IR_Incident_TeamID_CommanderUserID` (`TeamID`,`CommanderUserID`),
  KEY `IR_Incident_ChannelID` (`ChannelID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IR_Incident`
--

LOCK TABLES `IR_Incident` WRITE;
/*!40000 ALTER TABLE `IR_Incident` DISABLE KEYS */;
/*!40000 ALTER TABLE `IR_Incident` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_Metric`
--

DROP TABLE IF EXISTS `IR_Metric`;
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

--
-- Dumping data for table `IR_Metric`
--

LOCK TABLES `IR_Metric` WRITE;
/*!40000 ALTER TABLE `IR_Metric` DISABLE KEYS */;
/*!40000 ALTER TABLE `IR_Metric` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_MetricConfig`
--

DROP TABLE IF EXISTS `IR_MetricConfig`;
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

--
-- Dumping data for table `IR_MetricConfig`
--

LOCK TABLES `IR_MetricConfig` WRITE;
/*!40000 ALTER TABLE `IR_MetricConfig` DISABLE KEYS */;
/*!40000 ALTER TABLE `IR_MetricConfig` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_Playbook`
--

DROP TABLE IF EXISTS `IR_Playbook`;
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
  PRIMARY KEY (`ID`),
  KEY `IR_Playbook_TeamID` (`TeamID`),
  KEY `IR_PlaybookMember_PlaybookID` (`ID`),
  KEY `IR_Playbook_UpdateAt` (`UpdateAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IR_Playbook`
--

LOCK TABLES `IR_Playbook` WRITE;
/*!40000 ALTER TABLE `IR_Playbook` DISABLE KEYS */;
/*!40000 ALTER TABLE `IR_Playbook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_PlaybookAutoFollow`
--

DROP TABLE IF EXISTS `IR_PlaybookAutoFollow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_PlaybookAutoFollow` (
  `PlaybookID` varchar(26) NOT NULL,
  `UserID` varchar(26) NOT NULL,
  PRIMARY KEY (`PlaybookID`,`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IR_PlaybookAutoFollow`
--

LOCK TABLES `IR_PlaybookAutoFollow` WRITE;
/*!40000 ALTER TABLE `IR_PlaybookAutoFollow` DISABLE KEYS */;
/*!40000 ALTER TABLE `IR_PlaybookAutoFollow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_PlaybookMember`
--

DROP TABLE IF EXISTS `IR_PlaybookMember`;
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

--
-- Dumping data for table `IR_PlaybookMember`
--

LOCK TABLES `IR_PlaybookMember` WRITE;
/*!40000 ALTER TABLE `IR_PlaybookMember` DISABLE KEYS */;
/*!40000 ALTER TABLE `IR_PlaybookMember` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_Run_Participants`
--

DROP TABLE IF EXISTS `IR_Run_Participants`;
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

--
-- Dumping data for table `IR_Run_Participants`
--

LOCK TABLES `IR_Run_Participants` WRITE;
/*!40000 ALTER TABLE `IR_Run_Participants` DISABLE KEYS */;
/*!40000 ALTER TABLE `IR_Run_Participants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_StatusPosts`
--

DROP TABLE IF EXISTS `IR_StatusPosts`;
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

--
-- Dumping data for table `IR_StatusPosts`
--

LOCK TABLES `IR_StatusPosts` WRITE;
/*!40000 ALTER TABLE `IR_StatusPosts` DISABLE KEYS */;
/*!40000 ALTER TABLE `IR_StatusPosts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_System`
--

DROP TABLE IF EXISTS `IR_System`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_System` (
  `SKey` varchar(64) NOT NULL,
  `SValue` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`SKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IR_System`
--

LOCK TABLES `IR_System` WRITE;
/*!40000 ALTER TABLE `IR_System` DISABLE KEYS */;
INSERT INTO `IR_System` VALUES ('DatabaseVersion','0.63.0');
/*!40000 ALTER TABLE `IR_System` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_TimelineEvent`
--

DROP TABLE IF EXISTS `IR_TimelineEvent`;
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

--
-- Dumping data for table `IR_TimelineEvent`
--

LOCK TABLES `IR_TimelineEvent` WRITE;
/*!40000 ALTER TABLE `IR_TimelineEvent` DISABLE KEYS */;
/*!40000 ALTER TABLE `IR_TimelineEvent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_UserInfo`
--

DROP TABLE IF EXISTS `IR_UserInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_UserInfo` (
  `ID` varchar(26) NOT NULL,
  `LastDailyTodoDMAt` bigint(20) DEFAULT NULL,
  `DigestNotificationSettingsJSON` json DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IR_UserInfo`
--

LOCK TABLES `IR_UserInfo` WRITE;
/*!40000 ALTER TABLE `IR_UserInfo` DISABLE KEYS */;
INSERT INTO `IR_UserInfo` VALUES ('jactwicuqb8bu8pau8mgjydzeo',1684139716690,'{\"disable_daily_digest\": false, \"disable_weekly_digest\": false}');
/*!40000 ALTER TABLE `IR_UserInfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IR_ViewedChannel`
--

DROP TABLE IF EXISTS `IR_ViewedChannel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IR_ViewedChannel` (
  `ChannelID` varchar(26) NOT NULL,
  `UserID` varchar(26) NOT NULL,
  PRIMARY KEY (`ChannelID`,`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IR_ViewedChannel`
--

LOCK TABLES `IR_ViewedChannel` WRITE;
/*!40000 ALTER TABLE `IR_ViewedChannel` DISABLE KEYS */;
/*!40000 ALTER TABLE `IR_ViewedChannel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IncomingWebhooks`
--

DROP TABLE IF EXISTS `IncomingWebhooks`;
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

--
-- Dumping data for table `IncomingWebhooks`
--

LOCK TABLES `IncomingWebhooks` WRITE;
/*!40000 ALTER TABLE `IncomingWebhooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `IncomingWebhooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Jobs`
--

DROP TABLE IF EXISTS `Jobs`;
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

--
-- Dumping data for table `Jobs`
--

LOCK TABLES `Jobs` WRITE;
/*!40000 ALTER TABLE `Jobs` DISABLE KEYS */;
INSERT INTO `Jobs` VALUES ('kwwq4cbzu3nmxdewywnouh48xo','migrations',0,1684139119925,1684139134240,1684139136273,'success',0,'{\"last_done\": \"{\\\"current_table\\\":\\\"ChannelMembers\\\",\\\"last_team_id\\\":\\\"00000000000000000000000000\\\",\\\"last_channel_id\\\":\\\"00000000000000000000000000\\\",\\\"last_user\\\":\\\"00000000000000000000000000\\\"}\", \"migration_key\": \"migration_advanced_permissions_phase_2\"}');
/*!40000 ALTER TABLE `Jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Licenses`
--

DROP TABLE IF EXISTS `Licenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Licenses` (
  `Id` varchar(26) NOT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  `Bytes` text,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Licenses`
--

LOCK TABLES `Licenses` WRITE;
/*!40000 ALTER TABLE `Licenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `Licenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LinkMetadata`
--

DROP TABLE IF EXISTS `LinkMetadata`;
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

--
-- Dumping data for table `LinkMetadata`
--

LOCK TABLES `LinkMetadata` WRITE;
/*!40000 ALTER TABLE `LinkMetadata` DISABLE KEYS */;
/*!40000 ALTER TABLE `LinkMetadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `NotifyAdmin`
--

DROP TABLE IF EXISTS `NotifyAdmin`;
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

--
-- Dumping data for table `NotifyAdmin`
--

LOCK TABLES `NotifyAdmin` WRITE;
/*!40000 ALTER TABLE `NotifyAdmin` DISABLE KEYS */;
/*!40000 ALTER TABLE `NotifyAdmin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OAuthAccessData`
--

DROP TABLE IF EXISTS `OAuthAccessData`;
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

--
-- Dumping data for table `OAuthAccessData`
--

LOCK TABLES `OAuthAccessData` WRITE;
/*!40000 ALTER TABLE `OAuthAccessData` DISABLE KEYS */;
/*!40000 ALTER TABLE `OAuthAccessData` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OAuthApps`
--

DROP TABLE IF EXISTS `OAuthApps`;
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

--
-- Dumping data for table `OAuthApps`
--

LOCK TABLES `OAuthApps` WRITE;
/*!40000 ALTER TABLE `OAuthApps` DISABLE KEYS */;
/*!40000 ALTER TABLE `OAuthApps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OAuthAuthData`
--

DROP TABLE IF EXISTS `OAuthAuthData`;
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

--
-- Dumping data for table `OAuthAuthData`
--

LOCK TABLES `OAuthAuthData` WRITE;
/*!40000 ALTER TABLE `OAuthAuthData` DISABLE KEYS */;
/*!40000 ALTER TABLE `OAuthAuthData` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OutgoingWebhooks`
--

DROP TABLE IF EXISTS `OutgoingWebhooks`;
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

--
-- Dumping data for table `OutgoingWebhooks`
--

LOCK TABLES `OutgoingWebhooks` WRITE;
/*!40000 ALTER TABLE `OutgoingWebhooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `OutgoingWebhooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PluginKeyValueStore`
--

DROP TABLE IF EXISTS `PluginKeyValueStore`;
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

--
-- Dumping data for table `PluginKeyValueStore`
--

LOCK TABLES `PluginKeyValueStore` WRITE;
/*!40000 ALTER TABLE `PluginKeyValueStore` DISABLE KEYS */;
INSERT INTO `PluginKeyValueStore` VALUES ('com.mattermost.apps','mmi_botid',_binary 'qmaiqbz1e3fo8qz1nsmkhqbznh',0),('com.mattermost.calls','mmi_botid',_binary 'o113xcgte78kpezuouwcr6abpo',0),('com.mattermost.nps','ServerUpgrade-7.10.0',_binary '{\"server_version\":\"7.10.0\",\"upgrade_at\":\"2023-05-15T08:24:19.013024124Z\"}',0),('com.mattermost.nps','Survey-7.10.0',_binary '{\"server_version\":\"7.10.0\",\"create_at\":\"2023-05-15T08:24:19.013024124Z\",\"start_at\":\"2023-06-29T08:24:19.013024124Z\"}',0),('com.mattermost.nps','WelcomeFeedbackMigration',_binary '{\"CreateAt\":\"2023-05-15T08:24:19.013024124Z\"}',0),('focalboard','mmi_botid',_binary 'd6eb3jh8iprzpxim14w9hkopbr',0),('playbooks','mmi_botid',_binary 'ozpddc4xxi85tmrwaqsjmgw1kc',0);
/*!40000 ALTER TABLE `PluginKeyValueStore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PostAcknowledgements`
--

DROP TABLE IF EXISTS `PostAcknowledgements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PostAcknowledgements` (
  `PostId` varchar(26) NOT NULL,
  `UserId` varchar(26) NOT NULL,
  `AcknowledgedAt` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PostId`,`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PostAcknowledgements`
--

LOCK TABLES `PostAcknowledgements` WRITE;
/*!40000 ALTER TABLE `PostAcknowledgements` DISABLE KEYS */;
/*!40000 ALTER TABLE `PostAcknowledgements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PostReminders`
--

DROP TABLE IF EXISTS `PostReminders`;
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

--
-- Dumping data for table `PostReminders`
--

LOCK TABLES `PostReminders` WRITE;
/*!40000 ALTER TABLE `PostReminders` DISABLE KEYS */;
/*!40000 ALTER TABLE `PostReminders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Posts`
--

DROP TABLE IF EXISTS `Posts`;
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

--
-- Dumping data for table `Posts`
--

LOCK TABLES `Posts` WRITE;
/*!40000 ALTER TABLE `Posts` DISABLE KEYS */;
INSERT INTO `Posts` VALUES ('1xgmcd59qibs9yuuo7ca319usr',1684139715944,1684139715944,0,'jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','','','admin joined the team.','system_join_team','{\"username\": \"admin\"}','','[]','[]',0,0,0,NULL),('3o9to5xhe7byp8zsh4hxqpemir',1684139715963,1684139715963,0,'jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','','','','system_welcome_post','{}','','[]','[]',0,0,0,NULL),('5ejdapm8wjbytdiwwt41s79e4e',1684146863352,1684146863352,0,'jactwicuqb8bu8pau8mgjydzeo','8sz36rga1in69gaunpogq95r1w','','','nautobot-test-bot added to the team by admin.','system_add_to_team','{\"userId\": \"jactwicuqb8bu8pau8mgjydzeo\", \"username\": \"admin\", \"addedUserId\": \"k8crtspa5bfadc6iu6m93p4orh\", \"addedUsername\": \"nautobot-test-bot\"}','','[]','[]',0,0,0,NULL),('7eexxn81i3dt3j8m7qpx4wm3ro',1684146863411,1684146863411,0,'jactwicuqb8bu8pau8mgjydzeo','fi1muawz1bybue4gwu95kni4eh','','','nautobot-test-bot added to the channel by admin.','system_add_to_channel','{\"userId\": \"jactwicuqb8bu8pau8mgjydzeo\", \"username\": \"admin\", \"addedUserId\": \"k8crtspa5bfadc6iu6m93p4orh\", \"addedUsername\": \"nautobot-test-bot\"}','','[]','[]',0,0,0,NULL),('7hzsww8dsby6jg6q1m3oh4y9jh',1684153509947,1684153509947,0,'k8crtspa5bfadc6iu6m93p4orh','8sz36rga1in69gaunpogq95r1w','','','','','{\"from_bot\": \"true\", \"attachments\": [{\"id\": 0, \"ts\": null, \"text\": \"More Chat commands can be found at [Nautobot Apps](https://www.networktocode.com/nautobot/apps/)\", \"color\": \"\", \"title\": \"\", \"fields\": null, \"footer\": \"\", \"pretext\": \"\", \"fallback\": \"\", \"image_url\": \"\", \"thumb_url\": \"\", \"title_link\": \"\", \"author_icon\": \"\", \"author_link\": \"\", \"author_name\": \"\", \"footer_icon\": \"\"}]}','','[]','[]',0,0,0,NULL),('s74e1o15t7b758axznq8r5euzo',1684146025577,1684146025577,0,'k8crtspa5bfadc6iu6m93p4orh','9g8qo5udpp8dzdud8jex1m6kuh','','','Please add me to teams and channels you want me to interact in. To do this, use the browser or Mattermost Desktop App.','add_bot_teams_channels','{\"from_bot\": \"true\"}','','[]','[]',0,0,0,NULL),('x5kszdx16bnhzx4ixhqe5oxe5h',1684139716016,1684139716016,0,'jactwicuqb8bu8pau8mgjydzeo','fi1muawz1bybue4gwu95kni4eh','','','admin joined the channel.','system_join_channel','{\"username\": \"admin\"}','','[]','[]',0,0,0,NULL);
/*!40000 ALTER TABLE `Posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PostsPriority`
--

DROP TABLE IF EXISTS `PostsPriority`;
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

--
-- Dumping data for table `PostsPriority`
--

LOCK TABLES `PostsPriority` WRITE;
/*!40000 ALTER TABLE `PostsPriority` DISABLE KEYS */;
/*!40000 ALTER TABLE `PostsPriority` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Preferences`
--

DROP TABLE IF EXISTS `Preferences`;
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

--
-- Dumping data for table `Preferences`
--

LOCK TABLES `Preferences` WRITE;
/*!40000 ALTER TABLE `Preferences` DISABLE KEYS */;
INSERT INTO `Preferences` VALUES ('jactwicuqb8bu8pau8mgjydzeo','channel_approximate_view_time','','1684153464464'),('jactwicuqb8bu8pau8mgjydzeo','channel_open_time','9g8qo5udpp8dzdud8jex1m6kuh','1684152192107'),('jactwicuqb8bu8pau8mgjydzeo','direct_channel_show','k8crtspa5bfadc6iu6m93p4orh','true'),('jactwicuqb8bu8pau8mgjydzeo','drafts','drafts_tour_tip_showed','{\"drafts_tour_tip_showed\":true}'),('jactwicuqb8bu8pau8mgjydzeo','insights','insights_tutorial_state','{\"insights_modal_viewed\":true}'),('jactwicuqb8bu8pau8mgjydzeo','onboarding_task_list','onboarding_task_list_open','false'),('jactwicuqb8bu8pau8mgjydzeo','onboarding_task_list','onboarding_task_list_show','false'),('jactwicuqb8bu8pau8mgjydzeo','recommended_next_steps','hide','true'),('jactwicuqb8bu8pau8mgjydzeo','touched','invite_members','true'),('jactwicuqb8bu8pau8mgjydzeo','tutorial_step','jactwicuqb8bu8pau8mgjydzeo','0');
/*!40000 ALTER TABLE `Preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProductNoticeViewState`
--

DROP TABLE IF EXISTS `ProductNoticeViewState`;
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

--
-- Dumping data for table `ProductNoticeViewState`
--

LOCK TABLES `ProductNoticeViewState` WRITE;
/*!40000 ALTER TABLE `ProductNoticeViewState` DISABLE KEYS */;
INSERT INTO `ProductNoticeViewState` VALUES ('jactwicuqb8bu8pau8mgjydzeo','crt-admin-default_off',1,1684139698),('jactwicuqb8bu8pau8mgjydzeo','crt-admin-disabled',1,1684139698),('jactwicuqb8bu8pau8mgjydzeo','crt-user-always-on',1,1684139698),('jactwicuqb8bu8pau8mgjydzeo','crt-user-default-on',1,1684139698),('jactwicuqb8bu8pau8mgjydzeo','desktop_upgrade_v5.2',1,1684139698),('jactwicuqb8bu8pau8mgjydzeo','server_upgrade_v7.9',1,1684139698),('jactwicuqb8bu8pau8mgjydzeo','unsupported-server-v5.37',1,1684139698);
/*!40000 ALTER TABLE `ProductNoticeViewState` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PublicChannels`
--

DROP TABLE IF EXISTS `PublicChannels`;
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

--
-- Dumping data for table `PublicChannels`
--

LOCK TABLES `PublicChannels` WRITE;
/*!40000 ALTER TABLE `PublicChannels` DISABLE KEYS */;
INSERT INTO `PublicChannels` VALUES ('8sz36rga1in69gaunpogq95r1w',0,'35odngbgr7yw3bf13o8kg85ngh','Town Square','town-square','',''),('fi1muawz1bybue4gwu95kni4eh',0,'35odngbgr7yw3bf13o8kg85ngh','Off-Topic','off-topic','','');
/*!40000 ALTER TABLE `PublicChannels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reactions`
--

DROP TABLE IF EXISTS `Reactions`;
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

--
-- Dumping data for table `Reactions`
--

LOCK TABLES `Reactions` WRITE;
/*!40000 ALTER TABLE `Reactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `Reactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RecentSearches`
--

DROP TABLE IF EXISTS `RecentSearches`;
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

--
-- Dumping data for table `RecentSearches`
--

LOCK TABLES `RecentSearches` WRITE;
/*!40000 ALTER TABLE `RecentSearches` DISABLE KEYS */;
/*!40000 ALTER TABLE `RecentSearches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RemoteClusters`
--

DROP TABLE IF EXISTS `RemoteClusters`;
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

--
-- Dumping data for table `RemoteClusters`
--

LOCK TABLES `RemoteClusters` WRITE;
/*!40000 ALTER TABLE `RemoteClusters` DISABLE KEYS */;
/*!40000 ALTER TABLE `RemoteClusters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RetentionPolicies`
--

DROP TABLE IF EXISTS `RetentionPolicies`;
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

--
-- Dumping data for table `RetentionPolicies`
--

LOCK TABLES `RetentionPolicies` WRITE;
/*!40000 ALTER TABLE `RetentionPolicies` DISABLE KEYS */;
/*!40000 ALTER TABLE `RetentionPolicies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RetentionPoliciesChannels`
--

DROP TABLE IF EXISTS `RetentionPoliciesChannels`;
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

--
-- Dumping data for table `RetentionPoliciesChannels`
--

LOCK TABLES `RetentionPoliciesChannels` WRITE;
/*!40000 ALTER TABLE `RetentionPoliciesChannels` DISABLE KEYS */;
/*!40000 ALTER TABLE `RetentionPoliciesChannels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RetentionPoliciesTeams`
--

DROP TABLE IF EXISTS `RetentionPoliciesTeams`;
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

--
-- Dumping data for table `RetentionPoliciesTeams`
--

LOCK TABLES `RetentionPoliciesTeams` WRITE;
/*!40000 ALTER TABLE `RetentionPoliciesTeams` DISABLE KEYS */;
/*!40000 ALTER TABLE `RetentionPoliciesTeams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Roles`
--

DROP TABLE IF EXISTS `Roles`;
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

--
-- Dumping data for table `Roles`
--

LOCK TABLES `Roles` WRITE;
/*!40000 ALTER TABLE `Roles` DISABLE KEYS */;
INSERT INTO `Roles` VALUES ('13bs7grka7f45g6eskmqbuypbw','team_user','authentication.roles.team_user.name','authentication.roles.team_user.description',1684139050819,1684139055707,0,' playbook_public_create list_team_channels join_public_channels playbook_private_create create_private_channel add_user_to_team read_public_channel view_team create_public_channel invite_user',1,1),('1assaqn3tt899xeda1aiop8bky','run_admin','authentication.roles.run_admin.name','authentication.roles.run_admin.description',1684139050763,1684139055713,0,' run_manage_properties run_manage_members',1,1),('7eh3dpufq7g4zfza5ku6zacgdo','run_member','authentication.roles.run_member.name','authentication.roles.run_member.description',1684139050908,1684139055719,0,' run_view',1,1),('99faipwtbf8sbes7ipkdfz348e','system_post_all_public','authentication.roles.system_post_all_public.name','authentication.roles.system_post_all_public.description',1684139050876,1684139055725,0,' use_channel_mentions create_post_public use_group_mentions',0,1),('9wqa3318s3fw781rjkpjwbchaw','team_guest','authentication.roles.team_guest.name','authentication.roles.team_guest.description',1684139050859,1684139055732,0,' view_team',1,1),('a8fy4zx49trbbfi45wexsqmxdy','system_user','authentication.roles.global_user.name','authentication.roles.global_user.description',1684139050913,1684139055739,0,' delete_custom_group delete_emojis view_members create_team edit_custom_group create_group_channel manage_custom_group_members create_direct_channel restore_custom_group list_public_teams create_custom_group join_public_teams create_emojis',1,1),('bb9guastc3f99bqd91szo7dkch','team_post_all','authentication.roles.team_post_all.name','authentication.roles.team_post_all.description',1684139050903,1684139055745,0,' create_post use_channel_mentions use_group_mentions',0,1),('djorm5qfbpdimcdg8b8wdku5na','system_user_manager','authentication.roles.system_user_manager.name','authentication.roles.system_user_manager.description',1684139050798,1684139055752,0,' sysconsole_read_authentication_saml read_ldap_sync_job delete_public_channel sysconsole_read_authentication_ldap test_ldap sysconsole_write_user_management_teams convert_public_channel_to_private join_public_teams add_user_to_team sysconsole_read_user_management_groups manage_public_channel_members sysconsole_write_user_management_channels read_channel view_team manage_channel_roles sysconsole_read_user_management_permissions manage_team_roles read_private_channel_groups sysconsole_read_authentication_password remove_user_from_team join_private_teams sysconsole_read_user_management_channels sysconsole_read_authentication_email sysconsole_read_authentication_signup sysconsole_read_authentication_mfa sysconsole_read_authentication_openid list_private_teams list_public_teams sysconsole_write_user_management_groups delete_private_channel manage_public_channel_properties manage_team read_public_channel convert_private_channel_to_public manage_private_channel_members sysconsole_read_authentication_guest_access sysconsole_read_user_management_teams read_public_channel_groups manage_private_channel_properties',0,1),('jbrz4h5gqt877cuxh57absnc7c','custom_group_user','authentication.roles.custom_group_user.name','authentication.roles.custom_group_user.description',1684139050893,1684139055757,0,'',0,0),('jfuzyuzguiysmcb1fmtfnme6sc','system_admin','authentication.roles.global_admin.name','authentication.roles.global_admin.description',1684139050846,1684139055764,0,' sysconsole_read_experimental_feature_flags run_view import_team delete_emojis playbook_public_manage_members manage_team sysconsole_read_site_posts list_users_without_team get_saml_cert_status sysconsole_write_experimental_features sysconsole_read_user_management_users run_manage_members join_public_channels restore_custom_group remove_others_reactions create_compliance_export_job sysconsole_read_environment_performance_monitoring sysconsole_write_integrations_cors test_elasticsearch remove_reaction read_public_channel manage_roles sysconsole_write_environment_push_notification_server create_custom_group sysconsole_write_environment_database create_ldap_sync_job sysconsole_write_integrations_integration_management sysconsole_write_site_notices create_post_public use_group_mentions sysconsole_write_compliance_custom_terms_of_service create_post_ephemeral sysconsole_read_products_boards sysconsole_write_integrations_gif sysconsole_write_environment_performance_monitoring manage_license_information get_logs read_data_retention_job add_saml_idp_cert sysconsole_write_authentication_signup manage_slash_commands download_compliance_export_result invalidate_email_invite add_saml_public_cert read_other_users_teams use_channel_mentions sysconsole_read_environment_logging sysconsole_read_compliance_compliance_monitoring manage_system assign_bot invalidate_caches manage_bots invite_guest sysconsole_read_compliance_data_retention_policy view_members purge_bleve_indexes sysconsole_read_site_announcement_banner sysconsole_read_user_management_channels create_group_channel sysconsole_read_site_notifications sysconsole_write_authentication_password create_elasticsearch_post_indexing_job playbook_private_make_public sysconsole_read_environment_developer manage_shared_channels sysconsole_read_reporting_server_logs sysconsole_read_compliance_compliance_export manage_others_slash_commands create_direct_channel demote_to_guest read_others_bots manage_team_roles sysconsole_write_about_edition_and_license run_create sysconsole_write_user_management_channels sysconsole_read_plugins delete_public_channel sysconsole_read_reporting_team_statistics playbook_public_make_private add_ldap_public_cert create_team sysconsole_read_authentication_openid create_post edit_brand manage_others_bots delete_others_posts use_slash_commands read_audits edit_post remove_saml_private_cert sysconsole_write_compliance_compliance_monitoring reload_config sysconsole_write_plugins sysconsole_read_user_management_groups playbook_private_view test_email playbook_private_create add_saml_private_cert sysconsole_read_site_users_and_teams manage_private_channel_members remove_ldap_public_cert create_post_bleve_indexes_job manage_public_channel_members promote_guest delete_post playbook_private_manage_properties sysconsole_write_experimental_feature_flags test_site_url manage_others_incoming_webhooks read_private_channel_groups sysconsole_read_site_public_links sysconsole_write_products_boards sysconsole_read_integrations_integration_management playbook_private_manage_roles edit_other_users sysconsole_write_compliance_compliance_export sysconsole_read_authentication_email sysconsole_write_site_public_links sysconsole_write_environment_session_lengths sysconsole_write_site_emoji remove_saml_idp_cert edit_others_posts sysconsole_read_site_notices create_private_channel sysconsole_write_environment_image_proxy list_public_teams sysconsole_read_authentication_password join_public_teams read_jobs sysconsole_write_authentication_email manage_private_channel_properties read_license_information sysconsole_read_authentication_ldap create_data_retention_job manage_oauth assign_system_admin_role remove_saml_public_cert sysconsole_write_environment_elasticsearch list_team_channels list_private_teams sysconsole_read_environment_web_server test_ldap convert_private_channel_to_public create_user_access_token sysconsole_write_user_management_groups read_user_access_token create_bot sysconsole_write_integrations_bot_accounts create_emojis sysconsole_write_reporting_server_logs manage_others_outgoing_webhooks sysconsole_read_user_management_permissions manage_secure_connections sysconsole_write_reporting_team_statistics manage_system_wide_oauth read_channel playbook_public_create playbook_public_manage_roles revoke_user_access_token get_analytics get_public_link sysconsole_write_authentication_mfa sysconsole_write_user_management_permissions read_elasticsearch_post_indexing_job delete_private_channel sysconsole_read_authentication_saml add_reaction sysconsole_write_site_notifications sysconsole_write_site_announcement_banner sysconsole_write_experimental_bleve view_team invite_user sysconsole_read_environment_push_notification_server manage_public_channel_properties sysconsole_read_reporting_site_statistics remove_user_from_team sysconsole_write_authentication_openid playbook_private_manage_members sysconsole_write_environment_rate_limiting sysconsole_write_site_customization sysconsole_read_integrations_cors sysconsole_write_environment_web_server delete_custom_group purge_elasticsearch_indexes add_user_to_team edit_custom_group sysconsole_write_environment_smtp read_public_channel_groups sysconsole_write_environment_logging sysconsole_read_site_emoji sysconsole_read_environment_file_storage sysconsole_write_user_management_users manage_custom_group_members sysconsole_read_about_edition_and_license sysconsole_read_site_file_sharing_and_downloads sysconsole_read_site_localization sysconsole_read_integrations_gif sysconsole_read_environment_elasticsearch sysconsole_write_site_localization sysconsole_read_site_customization remove_ldap_private_cert playbook_public_view read_compliance_export_job sysconsole_write_billing sysconsole_write_user_management_teams join_private_teams sysconsole_write_site_users_and_teams sysconsole_write_site_file_sharing_and_downloads get_saml_metadata_from_idp read_elasticsearch_post_aggregation_job delete_others_emojis run_manage_properties sysconsole_read_environment_high_availability sysconsole_read_environment_rate_limiting create_public_channel sysconsole_read_environment_smtp manage_outgoing_webhooks sysconsole_write_environment_file_storage sysconsole_read_integrations_bot_accounts sysconsole_write_user_management_system_roles manage_jobs sysconsole_read_environment_image_proxy sysconsole_write_authentication_ldap sysconsole_read_environment_session_lengths playbook_public_manage_properties sysconsole_write_reporting_site_statistics upload_file sysconsole_read_environment_database sysconsole_read_experimental_features sysconsole_read_experimental_bleve sysconsole_write_authentication_guest_access read_ldap_sync_job recycle_database_connections sysconsole_read_authentication_mfa sysconsole_read_compliance_custom_terms_of_service manage_incoming_webhooks sysconsole_read_user_management_system_roles create_elasticsearch_post_aggregation_job convert_public_channel_to_private sysconsole_write_authentication_saml sysconsole_read_authentication_signup sysconsole_write_compliance_data_retention_policy read_bots test_s3 sysconsole_write_site_posts add_ldap_private_cert manage_channel_roles sysconsole_read_authentication_guest_access sysconsole_read_billing sysconsole_write_environment_developer sysconsole_read_user_management_teams read_deleted_posts sysconsole_write_environment_high_availability',1,1),('jh5f5efjm38ebdsypjutm1zjzr','system_manager','authentication.roles.system_manager.name','authentication.roles.system_manager.description',1684139050838,1684139055771,0,' sysconsole_write_site_public_links sysconsole_write_integrations_bot_accounts test_elasticsearch sysconsole_write_site_notices sysconsole_write_site_customization sysconsole_read_environment_developer sysconsole_read_authentication_password sysconsole_write_environment_logging sysconsole_write_environment_session_lengths sysconsole_read_products_boards manage_team test_email sysconsole_read_environment_logging sysconsole_write_site_localization get_logs read_ldap_sync_job read_license_information list_public_teams sysconsole_read_environment_rate_limiting sysconsole_write_user_management_groups join_public_teams join_private_teams sysconsole_read_site_emoji manage_team_roles sysconsole_read_user_management_groups sysconsole_write_integrations_gif sysconsole_write_environment_web_server sysconsole_read_site_announcement_banner sysconsole_write_user_management_teams sysconsole_write_site_notifications invalidate_caches sysconsole_write_site_announcement_banner test_site_url sysconsole_read_user_management_teams test_ldap sysconsole_read_site_posts sysconsole_write_site_file_sharing_and_downloads sysconsole_read_authentication_signup view_team recycle_database_connections sysconsole_write_environment_push_notification_server sysconsole_read_environment_session_lengths sysconsole_read_environment_smtp get_analytics sysconsole_read_site_notices sysconsole_read_user_management_permissions sysconsole_read_authentication_email purge_elasticsearch_indexes read_elasticsearch_post_indexing_job sysconsole_write_site_emoji convert_public_channel_to_private manage_private_channel_properties sysconsole_read_reporting_site_statistics read_elasticsearch_post_aggregation_job read_public_channel_groups create_elasticsearch_post_indexing_job sysconsole_write_integrations_cors manage_public_channel_members sysconsole_read_authentication_guest_access create_elasticsearch_post_aggregation_job sysconsole_write_environment_performance_monitoring sysconsole_write_products_boards sysconsole_write_environment_developer sysconsole_read_site_public_links sysconsole_write_user_management_permissions sysconsole_read_environment_push_notification_server sysconsole_write_environment_image_proxy sysconsole_write_site_users_and_teams sysconsole_read_site_file_sharing_and_downloads sysconsole_read_environment_performance_monitoring sysconsole_write_environment_smtp sysconsole_read_environment_elasticsearch delete_private_channel sysconsole_read_plugins sysconsole_read_site_users_and_teams sysconsole_read_environment_file_storage read_private_channel_groups read_public_channel sysconsole_read_site_localization sysconsole_write_environment_high_availability add_user_to_team sysconsole_write_integrations_integration_management sysconsole_read_reporting_team_statistics sysconsole_read_environment_image_proxy manage_private_channel_members sysconsole_read_authentication_mfa sysconsole_write_environment_file_storage reload_config sysconsole_read_authentication_openid sysconsole_write_environment_database sysconsole_read_environment_web_server sysconsole_write_environment_rate_limiting test_s3 remove_user_from_team list_private_teams read_channel sysconsole_read_authentication_saml edit_brand sysconsole_read_integrations_bot_accounts sysconsole_read_site_customization sysconsole_read_environment_database sysconsole_read_integrations_cors sysconsole_read_integrations_integration_management sysconsole_read_reporting_server_logs sysconsole_read_about_edition_and_license sysconsole_read_user_management_channels convert_private_channel_to_public sysconsole_write_site_posts sysconsole_write_environment_elasticsearch sysconsole_read_environment_high_availability sysconsole_read_authentication_ldap manage_public_channel_properties delete_public_channel sysconsole_read_site_notifications sysconsole_read_integrations_gif sysconsole_write_user_management_channels manage_channel_roles',0,1),('jsp8rgiy3tdwi8s3734gqn1t8a','team_admin','authentication.roles.team_admin.name','authentication.roles.team_admin.description',1684139050825,1684139055777,0,' remove_reaction create_post playbook_private_manage_roles read_private_channel_groups manage_team_roles convert_private_channel_to_public import_team read_public_channel_groups delete_others_posts manage_private_channel_members manage_public_channel_members manage_others_slash_commands manage_others_incoming_webhooks manage_incoming_webhooks manage_channel_roles convert_public_channel_to_private add_reaction manage_outgoing_webhooks manage_team use_group_mentions remove_user_from_team manage_others_outgoing_webhooks playbook_public_manage_roles use_channel_mentions manage_slash_commands delete_post',1,1),('jy7kh7nt8pbeuq3y9xnk99ofhy','playbook_admin','authentication.roles.playbook_admin.name','authentication.roles.playbook_admin.description',1684139050831,1684139055783,0,' playbook_private_manage_properties playbook_public_make_private playbook_public_manage_members playbook_public_manage_roles playbook_public_manage_properties playbook_private_manage_members playbook_private_manage_roles',1,1),('kfsh3mwix7gf7nmbz9osxu7w3h','system_user_access_token','authentication.roles.system_user_access_token.name','authentication.roles.system_user_access_token.description',1684139050917,1684139055789,0,' read_user_access_token revoke_user_access_token create_user_access_token',0,1),('mg3ei79rwjbb9cisojazuetrer','channel_admin','authentication.roles.channel_admin.name','authentication.roles.channel_admin.description',1684139050812,1684139055795,0,' remove_reaction read_public_channel_groups add_reaction use_channel_mentions use_group_mentions manage_private_channel_members manage_public_channel_members manage_channel_roles read_private_channel_groups create_post',1,1),('nnt36qb6ebgx9jp4jjstmm4x8c','channel_guest','authentication.roles.channel_guest.name','authentication.roles.channel_guest.description',1684139050898,1684139055801,0,' use_slash_commands read_channel add_reaction remove_reaction upload_file edit_post create_post use_channel_mentions',1,1),('u61ohe941brj9rbwji51s4umpy','team_post_all_public','authentication.roles.team_post_all_public.name','authentication.roles.team_post_all_public.description',1684139050865,1684139055808,0,' create_post_public use_channel_mentions use_group_mentions',0,1),('u74k94nxqtri7q4mrkanrwj4ky','system_custom_group_admin','authentication.roles.system_custom_group_admin.name','authentication.roles.system_custom_group_admin.description',1684139050805,1684139055815,0,' edit_custom_group delete_custom_group restore_custom_group manage_custom_group_members create_custom_group',0,1),('u9kkc9q3hfnbzn7cqh1ekqxxzr','system_post_all','authentication.roles.system_post_all.name','authentication.roles.system_post_all.description',1684139050791,1684139055821,0,' use_channel_mentions use_group_mentions create_post',0,1),('w393gw6mfi8djnr1iak81zsz9e','channel_user','authentication.roles.channel_user.name','authentication.roles.channel_user.description',1684139050853,1684139055827,0,' manage_public_channel_properties remove_reaction use_channel_mentions delete_post manage_public_channel_members read_private_channel_groups delete_private_channel add_reaction use_slash_commands upload_file use_group_mentions read_public_channel_groups get_public_link manage_private_channel_members read_channel manage_private_channel_properties create_post edit_post delete_public_channel',1,1),('ww84ayxwipyg9eyrcz3ikffy9e','system_read_only_admin','authentication.roles.system_read_only_admin.name','authentication.roles.system_read_only_admin.description',1684139050889,1684139055833,0,' sysconsole_read_integrations_gif sysconsole_read_site_users_and_teams read_elasticsearch_post_aggregation_job list_private_teams sysconsole_read_user_management_channels read_channel get_logs sysconsole_read_reporting_site_statistics sysconsole_read_products_boards sysconsole_read_about_edition_and_license sysconsole_read_experimental_feature_flags sysconsole_read_site_customization read_other_users_teams read_license_information sysconsole_read_authentication_password read_audits sysconsole_read_integrations_bot_accounts view_team sysconsole_read_environment_smtp sysconsole_read_site_localization sysconsole_read_experimental_features sysconsole_read_compliance_compliance_export sysconsole_read_authentication_saml test_ldap read_private_channel_groups sysconsole_read_authentication_signup download_compliance_export_result sysconsole_read_compliance_compliance_monitoring sysconsole_read_reporting_server_logs sysconsole_read_authentication_mfa sysconsole_read_integrations_integration_management sysconsole_read_environment_database sysconsole_read_site_file_sharing_and_downloads sysconsole_read_environment_elasticsearch sysconsole_read_user_management_permissions sysconsole_read_site_announcement_banner sysconsole_read_site_posts sysconsole_read_reporting_team_statistics sysconsole_read_authentication_openid sysconsole_read_user_management_teams sysconsole_read_plugins list_public_teams sysconsole_read_experimental_bleve sysconsole_read_integrations_cors sysconsole_read_environment_push_notification_server sysconsole_read_site_notices read_data_retention_job read_public_channel sysconsole_read_compliance_custom_terms_of_service sysconsole_read_authentication_guest_access sysconsole_read_environment_session_lengths sysconsole_read_environment_performance_monitoring sysconsole_read_environment_file_storage sysconsole_read_environment_high_availability sysconsole_read_compliance_data_retention_policy sysconsole_read_site_public_links sysconsole_read_authentication_email sysconsole_read_environment_image_proxy read_ldap_sync_job sysconsole_read_site_notifications read_elasticsearch_post_indexing_job get_analytics sysconsole_read_user_management_users sysconsole_read_environment_web_server sysconsole_read_environment_logging sysconsole_read_site_emoji sysconsole_read_user_management_groups sysconsole_read_environment_developer sysconsole_read_environment_rate_limiting sysconsole_read_authentication_ldap read_public_channel_groups read_compliance_export_job',0,1),('wxi1n6jnp7yt9xxezd6xtg43nh','system_guest','authentication.roles.global_guest.name','authentication.roles.global_guest.description',1684139050871,1684139055839,0,' create_group_channel create_direct_channel',1,1),('zdz95ncqn38ijggoho6h3e4ghr','playbook_member','authentication.roles.playbook_member.name','authentication.roles.playbook_member.description',1684139050738,1684139055845,0,' playbook_private_view playbook_private_manage_members playbook_private_manage_properties run_create playbook_public_view playbook_public_manage_members playbook_public_manage_properties',1,1);
/*!40000 ALTER TABLE `Roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Schemes`
--

DROP TABLE IF EXISTS `Schemes`;
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

--
-- Dumping data for table `Schemes`
--

LOCK TABLES `Schemes` WRITE;
/*!40000 ALTER TABLE `Schemes` DISABLE KEYS */;
/*!40000 ALTER TABLE `Schemes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sessions`
--

DROP TABLE IF EXISTS `Sessions`;
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

--
-- Dumping data for table `Sessions`
--

LOCK TABLES `Sessions` WRITE;
/*!40000 ALTER TABLE `Sessions` DISABLE KEYS */;
INSERT INTO `Sessions` VALUES ('3k7yt98etb8qbjt61mucnfqjzo','t3sjcihsbbyh5pns49ujga4aba',1684147695312,0,1684147695312,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('458u7z4eptyduygkekefpae6qc','s8fughc67idc9dx43xkqfj4xhw',1684139059905,0,1684139059905,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('4injinmbxj8j7pwpxirice1p3a','cbesp8eno3bm5gw7kz1kqqb8eo',1684147435167,0,1684147435167,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('6dr39dnkdf84ubih8jhfnezgkr','15p9kygg3bf18pxp5tn3b4oezc',1684147835285,0,1684147835285,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('746qpae8uir7ip7chng7iwhmth','6gxkr8fe4ig4bcxqx1ntf5dimh',1684148501680,0,1684148501680,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('7mrf1xmcsirgbfosem5a7cf7jy','s38e7kg7sf86bmrs765gohmqtw',1684149691677,0,1684149691677,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('8teqpzws1tddid4upe1aunbyew','cupq8yhb6ifaxc7k8gheh4xn9e',1684147204845,0,1684147204845,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('9rjb7z3d4iy8tmtcd7z3qrwhne','p7dx1e48a3gzigcnsbdxcypnte',1684147599878,0,1684147599878,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('dw6g5oeycbdi5gyw64u8p1nofh','5en8gfezoprmfpjdjdkxu3fmxw',1684145291697,1686737291697,1684153454668,'jactwicuqb8bu8pau8mgjydzeo','','system_admin system_user',0,'{\"os\": \"Linux\", \"csrf\": \"3q9jae15fffypxsmftx4g8wc8c\", \"isSaml\": \"false\", \"browser\": \"Chrome/113.0\", \"isMobile\": \"false\", \"is_guest\": \"false\", \"platform\": \"Linux\", \"isOAuthUser\": \"false\"}',0),('hz1zz8ya53f5tq1txtufsq6pwo','ggrtcmxx93dc7jrm9y6cyxio4w',1684152125460,0,1684152125460,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('isz4jhobhbyemmg4y1xwzttmhw','beyuukwks3rq5dn3qzub84a33y',1684151693274,0,1684151693274,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('jnxgm3466bnipmud87ksmobhqo','xunhq31bctf9mqxwcw4j9y81my',1684139698835,1686731698835,1684142497891,'jactwicuqb8bu8pau8mgjydzeo','','system_admin system_user',0,'{\"os\": \"Linux\", \"csrf\": \"f3hfmztmmpyy7f463b13ipqwwy\", \"isSaml\": \"false\", \"browser\": \"Chrome/113.0\", \"isMobile\": \"false\", \"is_guest\": \"false\", \"platform\": \"Linux\", \"isOAuthUser\": \"false\"}',0),('m7tqkdh8jinfxfi78jdd4ko77h','ocp8z7e88jf6pq1o9ez7b7skoe',1684151796794,0,1684151796794,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('mwb83syk3br67m8m9kurd9ghqo','tefqmrxrxfgtpfpzo3p6jdwege',1684145253048,0,1684145253048,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('nb6431ofxtdijcyb7y61of4j3e','p7x6t7b347gdzfcn3cxr5dkmuo',1684148163138,0,1684148163138,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('nqtoks3ym3ryfmmdcxts38ijqw','6w37qrkda7rdjkzf5ub57meqzy',1684148761540,4837748761540,1684153509993,'k8crtspa5bfadc6iu6m93p4orh','','system_user system_admin',0,'{\"type\": \"UserAccessToken\", \"is_bot\": \"true\", \"is_guest\": \"false\", \"user_access_token_id\": \"jkfdci9k97fk3j5wkofqjfmnte\"}',0),('qxrwwy1wzjf6zgs6yeocjr19th','cpa1oqmn6jbepf54jtyhjysoow',1684147764367,0,1684147764367,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('umap36kjjtrt8kc4jmwcm4d46a','tz8e1ymgktg8x8zzs43rb1nadc',1684151983385,0,1684151983385,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0),('yd8z9p965fg1z84kddmhn4r9pa','5sd4ndi5jf8ijrmrp77inmp7je',1684152027663,0,1684152027663,'o113xcgte78kpezuouwcr6abpo','','',0,'{}',0);
/*!40000 ALTER TABLE `Sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SharedChannelAttachments`
--

DROP TABLE IF EXISTS `SharedChannelAttachments`;
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

--
-- Dumping data for table `SharedChannelAttachments`
--

LOCK TABLES `SharedChannelAttachments` WRITE;
/*!40000 ALTER TABLE `SharedChannelAttachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `SharedChannelAttachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SharedChannelRemotes`
--

DROP TABLE IF EXISTS `SharedChannelRemotes`;
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

--
-- Dumping data for table `SharedChannelRemotes`
--

LOCK TABLES `SharedChannelRemotes` WRITE;
/*!40000 ALTER TABLE `SharedChannelRemotes` DISABLE KEYS */;
/*!40000 ALTER TABLE `SharedChannelRemotes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SharedChannelUsers`
--

DROP TABLE IF EXISTS `SharedChannelUsers`;
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

--
-- Dumping data for table `SharedChannelUsers`
--

LOCK TABLES `SharedChannelUsers` WRITE;
/*!40000 ALTER TABLE `SharedChannelUsers` DISABLE KEYS */;
/*!40000 ALTER TABLE `SharedChannelUsers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SharedChannels`
--

DROP TABLE IF EXISTS `SharedChannels`;
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

--
-- Dumping data for table `SharedChannels`
--

LOCK TABLES `SharedChannels` WRITE;
/*!40000 ALTER TABLE `SharedChannels` DISABLE KEYS */;
/*!40000 ALTER TABLE `SharedChannels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SidebarCategories`
--

DROP TABLE IF EXISTS `SidebarCategories`;
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

--
-- Dumping data for table `SidebarCategories`
--

LOCK TABLES `SidebarCategories` WRITE;
/*!40000 ALTER TABLE `SidebarCategories` DISABLE KEYS */;
INSERT INTO `SidebarCategories` VALUES ('channels_jactwicuqb8bu8pau8mgjydzeo_35odngbgr7yw3bf13o8kg85ngh','jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh',10,'','channels','Channels',0,0),('channels_k8crtspa5bfadc6iu6m93p4orh_35odngbgr7yw3bf13o8kg85ngh','k8crtspa5bfadc6iu6m93p4orh','35odngbgr7yw3bf13o8kg85ngh',10,'','channels','Channels',0,0),('direct_messages_jactwicuqb8bu8pau8mgjydzeo_35odngbgr7yw3bf13o8kg85ngh','jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh',20,'recent','direct_messages','Direct Messages',0,0),('direct_messages_k8crtspa5bfadc6iu6m93p4orh_35odngbgr7yw3bf13o8kg85ngh','k8crtspa5bfadc6iu6m93p4orh','35odngbgr7yw3bf13o8kg85ngh',20,'recent','direct_messages','Direct Messages',0,0),('favorites_jactwicuqb8bu8pau8mgjydzeo_35odngbgr7yw3bf13o8kg85ngh','jactwicuqb8bu8pau8mgjydzeo','35odngbgr7yw3bf13o8kg85ngh',0,'','favorites','Favorites',0,0),('favorites_k8crtspa5bfadc6iu6m93p4orh_35odngbgr7yw3bf13o8kg85ngh','k8crtspa5bfadc6iu6m93p4orh','35odngbgr7yw3bf13o8kg85ngh',0,'','favorites','Favorites',0,0);
/*!40000 ALTER TABLE `SidebarCategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SidebarChannels`
--

DROP TABLE IF EXISTS `SidebarChannels`;
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

--
-- Dumping data for table `SidebarChannels`
--

LOCK TABLES `SidebarChannels` WRITE;
/*!40000 ALTER TABLE `SidebarChannels` DISABLE KEYS */;
/*!40000 ALTER TABLE `SidebarChannels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Status`
--

DROP TABLE IF EXISTS `Status`;
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

--
-- Dumping data for table `Status`
--

LOCK TABLES `Status` WRITE;
/*!40000 ALTER TABLE `Status` DISABLE KEYS */;
INSERT INTO `Status` VALUES ('jactwicuqb8bu8pau8mgjydzeo','away',0,1684152644818,0,''),('k8crtspa5bfadc6iu6m93p4orh','online',0,1684153509983,0,'');
/*!40000 ALTER TABLE `Status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Systems`
--

DROP TABLE IF EXISTS `Systems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Systems` (
  `Name` varchar(64) NOT NULL,
  `Value` text,
  PRIMARY KEY (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Systems`
--

LOCK TABLES `Systems` WRITE;
/*!40000 ALTER TABLE `Systems` DISABLE KEYS */;
INSERT INTO `Systems` VALUES ('about_subsection_permissions','true'),('add_billing_permissions','true'),('add_bot_permissions','true'),('add_convert_channel_permissions','true'),('add_manage_guests_permissions','true'),('add_system_console_permissions','true'),('add_system_roles_permissions','true'),('add_use_group_mentions_permission','true'),('AdvancedPermissionsMigrationComplete','true'),('apply_channel_manage_delete_to_channel_user','true'),('AsymmetricSigningKey','{\"ecdsa_key\":{\"curve\":\"P-256\",\"x\":39885688012791743430902392044132023131306318630717482885626462746284368676562,\"y\":56732587617706431314588083882840694296577699304576161589544790090711522351963,\"d\":61158628144358852948138055426802208098608450055237759428816151150343005223320}}'),('authentication_subsection_permissions','true'),('channel_moderations_permissions','true'),('compliance_subsection_permissions','true'),('ContentExtractionConfigDefaultTrueMigrationComplete','true'),('CRTChannelMembershipCountsMigrationComplete','true'),('CRTThreadCountsAndUnreadsMigrationComplete','true'),('CustomGroupAdminRoleCreationMigrationComplete','true'),('custom_groups_permissions','true'),('custom_groups_permission_restore','true'),('DiagnosticId','6nz6d7fp5tdcbrfui1xnubzr8o'),('download_compliance_export_results','true'),('EmojisPermissionsMigrationComplete','true'),('emoji_permissions_split','true'),('environment_subsection_permissions','true'),('experimental_subsection_permissions','true'),('FirstServerRunTimestamp','1684139050764'),('GuestRolesCreationMigrationComplete','true'),('InstallationDate','1684139058969'),('integrations_subsection_permissions','true'),('LastSecurityTime','1684139050738'),('list_join_public_private_teams','true'),('manage_secure_connections_permissions','true'),('manage_shared_channel_permissions','true'),('migration_advanced_permissions_phase_2','true'),('PlaybookRolesCreationMigrationComplete','true'),('playbooks_manage_roles','true'),('playbooks_permissions','true'),('PostActionCookieSecret','{\"key\":\"YotujW0OeUnuIjCwfomw+BuaoB63KtxoBb6NLLrlzIA=\"}'),('PostPriorityConfigDefaultTrueMigrationComplete','true'),('products_boards','true'),('RemainingSchemaMigrations','true'),('remove_channel_manage_delete_from_team_user','true'),('remove_permanent_delete_user','true'),('reporting_subsection_permissions','true'),('site_subsection_permissions','true'),('SystemConsoleRolesCreationMigrationComplete','true'),('test_email_ancillary_permission','true'),('view_members_new_permission','true'),('webhook_permissions_split','true');
/*!40000 ALTER TABLE `Systems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TeamMembers`
--

DROP TABLE IF EXISTS `TeamMembers`;
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

--
-- Dumping data for table `TeamMembers`
--

LOCK TABLES `TeamMembers` WRITE;
/*!40000 ALTER TABLE `TeamMembers` DISABLE KEYS */;
INSERT INTO `TeamMembers` VALUES ('35odngbgr7yw3bf13o8kg85ngh','jactwicuqb8bu8pau8mgjydzeo','',0,1,1,0,1684139715876),('35odngbgr7yw3bf13o8kg85ngh','k8crtspa5bfadc6iu6m93p4orh','',0,1,0,0,1684146863252);
/*!40000 ALTER TABLE `TeamMembers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Teams`
--

DROP TABLE IF EXISTS `Teams`;
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

--
-- Dumping data for table `Teams`
--

LOCK TABLES `Teams` WRITE;
/*!40000 ALTER TABLE `Teams` DISABLE KEYS */;
INSERT INTO `Teams` VALUES ('35odngbgr7yw3bf13o8kg85ngh',1684139715847,1684139715847,0,'nautobot-test-team','nautobot-test-team','','admin@example.com','O','','','p6beof3e5fyxzgboo3ana6ra6c',NULL,0,0,NULL,0);
/*!40000 ALTER TABLE `Teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TermsOfService`
--

DROP TABLE IF EXISTS `TermsOfService`;
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

--
-- Dumping data for table `TermsOfService`
--

LOCK TABLES `TermsOfService` WRITE;
/*!40000 ALTER TABLE `TermsOfService` DISABLE KEYS */;
/*!40000 ALTER TABLE `TermsOfService` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ThreadMemberships`
--

DROP TABLE IF EXISTS `ThreadMemberships`;
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

--
-- Dumping data for table `ThreadMemberships`
--

LOCK TABLES `ThreadMemberships` WRITE;
/*!40000 ALTER TABLE `ThreadMemberships` DISABLE KEYS */;
/*!40000 ALTER TABLE `ThreadMemberships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Threads`
--

DROP TABLE IF EXISTS `Threads`;
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

--
-- Dumping data for table `Threads`
--

LOCK TABLES `Threads` WRITE;
/*!40000 ALTER TABLE `Threads` DISABLE KEYS */;
/*!40000 ALTER TABLE `Threads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tokens`
--

DROP TABLE IF EXISTS `Tokens`;
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

--
-- Dumping data for table `Tokens`
--

LOCK TABLES `Tokens` WRITE;
/*!40000 ALTER TABLE `Tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `Tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TrueUpReviewHistory`
--

DROP TABLE IF EXISTS `TrueUpReviewHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TrueUpReviewHistory` (
  `DueDate` bigint(20) NOT NULL,
  `Completed` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`DueDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TrueUpReviewHistory`
--

LOCK TABLES `TrueUpReviewHistory` WRITE;
/*!40000 ALTER TABLE `TrueUpReviewHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `TrueUpReviewHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UploadSessions`
--

DROP TABLE IF EXISTS `UploadSessions`;
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

--
-- Dumping data for table `UploadSessions`
--

LOCK TABLES `UploadSessions` WRITE;
/*!40000 ALTER TABLE `UploadSessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `UploadSessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserAccessTokens`
--

DROP TABLE IF EXISTS `UserAccessTokens`;
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

--
-- Dumping data for table `UserAccessTokens`
--

LOCK TABLES `UserAccessTokens` WRITE;
/*!40000 ALTER TABLE `UserAccessTokens` DISABLE KEYS */;
INSERT INTO `UserAccessTokens` VALUES ('jkfdci9k97fk3j5wkofqjfmnte','6w37qrkda7rdjkzf5ub57meqzy','k8crtspa5bfadc6iu6m93p4orh','Default Token',1);
/*!40000 ALTER TABLE `UserAccessTokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserGroups`
--

DROP TABLE IF EXISTS `UserGroups`;
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

--
-- Dumping data for table `UserGroups`
--

LOCK TABLES `UserGroups` WRITE;
/*!40000 ALTER TABLE `UserGroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserGroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserTermsOfService`
--

DROP TABLE IF EXISTS `UserTermsOfService`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserTermsOfService` (
  `UserId` varchar(26) NOT NULL,
  `TermsOfServiceId` varchar(26) DEFAULT NULL,
  `CreateAt` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserTermsOfService`
--

LOCK TABLES `UserTermsOfService` WRITE;
/*!40000 ALTER TABLE `UserTermsOfService` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserTermsOfService` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
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

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES ('6g9zjk1d7brz8rqiypd9kypn5c',1684139058969,1684139059003,0,'feedbackbot','',NULL,'','feedbackbot@localhost',0,'','Feedbackbot','','system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684139058969,1684139059003,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL),('d6eb3jh8iprzpxim14w9hkopbr',1684139114820,1684139114820,0,'boards','',NULL,'','boards@localhost',0,'','Boards','','system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684139114820,0,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL),('dk8nggnjtt8yipcbmuqem4rfkc',1684139700005,1684139700005,0,'system-bot','',NULL,'','system-bot@localhost',0,'','System','','system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684139700005,0,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL),('jactwicuqb8bu8pau8mgjydzeo',1684139698424,1684139715885,0,'admin','$2a$10$SihF59keV85viDliVM2Y3ODTupnPKlp//A1Y/pXcedL1nCBY7AxHi',NULL,'','admin@example.com',0,'','','','system_admin system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684139698424,0,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL),('k8crtspa5bfadc6iu6m93p4orh',1684146025502,1684146863269,0,'nautobot-test-bot','',NULL,'','nautobot-test-bot@localhost',0,'','Nautobot Test Bot','','system_user system_admin',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684146025502,0,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL),('o113xcgte78kpezuouwcr6abpo',1684139059883,1684139059883,0,'calls','',NULL,'','calls@localhost',0,'','Calls','','system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684139059883,0,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL),('ozpddc4xxi85tmrwaqsjmgw1kc',1684139059816,1684148501629,0,'playbooks','',NULL,'','playbooks@localhost',0,'','Playbooks','','system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684139059816,1684148501629,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL),('qmaiqbz1e3fo8qz1nsmkhqbznh',1684139059446,1684148501226,0,'appsbot','',NULL,'','appsbot@localhost',0,'','Mattermost Apps','','system_user',0,'{}','{\"push\": \"mention\", \"email\": \"true\", \"channel\": \"true\", \"desktop\": \"mention\", \"comments\": \"never\", \"first_name\": \"false\", \"push_status\": \"away\", \"mention_keys\": \"\", \"push_threads\": \"all\", \"desktop_sound\": \"true\", \"email_threads\": \"all\", \"desktop_threads\": \"all\"}',1684139059446,1684148501226,0,'en',0,'','','{\"manualTimezone\": \"\", \"automaticTimezone\": \"\", \"useAutomaticTimezone\": \"true\"}',NULL);
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `db_lock`
--

DROP TABLE IF EXISTS `db_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `db_lock` (
  `Id` varchar(64) NOT NULL,
  `ExpireAt` bigint(20) NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `db_lock`
--

LOCK TABLES `db_lock` WRITE;
/*!40000 ALTER TABLE `db_lock` DISABLE KEYS */;
/*!40000 ALTER TABLE `db_lock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `db_migrations`
--

DROP TABLE IF EXISTS `db_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `db_migrations` (
  `Version` bigint(20) NOT NULL,
  `Name` varchar(64) NOT NULL,
  PRIMARY KEY (`Version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `db_migrations`
--

LOCK TABLES `db_migrations` WRITE;
/*!40000 ALTER TABLE `db_migrations` DISABLE KEYS */;
INSERT INTO `db_migrations` VALUES (1,'create_teams'),(2,'create_team_members'),(3,'create_cluster_discovery'),(4,'create_command_webhooks'),(5,'create_compliances'),(6,'create_emojis'),(7,'create_user_groups'),(8,'create_group_members'),(9,'create_group_teams'),(10,'create_group_channels'),(11,'create_link_metadata'),(12,'create_commands'),(13,'create_incoming_webhooks'),(14,'create_outgoing_webhooks'),(15,'create_systems'),(16,'create_reactions'),(17,'create_roles'),(18,'create_schemes'),(19,'create_licenses'),(20,'create_posts'),(21,'create_product_notice_view_state'),(22,'create_sessions'),(23,'create_terms_of_service'),(24,'create_audits'),(25,'create_oauth_access_data'),(26,'create_preferences'),(27,'create_status'),(28,'create_tokens'),(29,'create_bots'),(30,'create_user_access_tokens'),(31,'create_remote_clusters'),(32,'create_sharedchannels'),(33,'create_sidebar_channels'),(34,'create_oauthauthdata'),(35,'create_sharedchannelattachments'),(36,'create_sharedchannelusers'),(37,'create_sharedchannelremotes'),(38,'create_jobs'),(39,'create_channel_member_history'),(40,'create_sidebar_categories'),(41,'create_upload_sessions'),(42,'create_threads'),(43,'thread_memberships'),(44,'create_user_terms_of_service'),(45,'create_plugin_key_value_store'),(46,'create_users'),(47,'create_file_info'),(48,'create_oauth_apps'),(49,'create_channels'),(50,'create_channelmembers'),(51,'create_msg_root_count'),(52,'create_public_channels'),(53,'create_retention_policies'),(54,'create_crt_channelmembership_count'),(55,'create_crt_thread_count_and_unreads'),(56,'upgrade_channels_v6.0'),(57,'upgrade_command_webhooks_v6.0'),(58,'upgrade_channelmembers_v6.0'),(59,'upgrade_users_v6.0'),(60,'upgrade_jobs_v6.0'),(61,'upgrade_link_metadata_v6.0'),(62,'upgrade_sessions_v6.0'),(63,'upgrade_threads_v6.0'),(64,'upgrade_status_v6.0'),(65,'upgrade_groupchannels_v6.0'),(66,'upgrade_posts_v6.0'),(67,'upgrade_channelmembers_v6.1'),(68,'upgrade_teammembers_v6.1'),(69,'upgrade_jobs_v6.1'),(70,'upgrade_cte_v6.1'),(71,'upgrade_sessions_v6.1'),(72,'upgrade_schemes_v6.3'),(73,'upgrade_plugin_key_value_store_v6.3'),(74,'upgrade_users_v6.3'),(75,'alter_upload_sessions_index'),(76,'upgrade_lastrootpostat'),(77,'upgrade_users_v6.5'),(78,'create_oauth_mattermost_app_id'),(79,'usergroups_displayname_index'),(80,'posts_createat_id'),(81,'threads_deleteat'),(82,'upgrade_oauth_mattermost_app_id'),(83,'threads_threaddeleteat'),(84,'recent_searches'),(85,'fileinfo_add_archived_column'),(86,'add_cloud_limits_archived'),(87,'sidebar_categories_index'),(88,'remaining_migrations'),(89,'add-channelid-to-reaction'),(90,'create_enums'),(91,'create_post_reminder'),(92,'add_createat_to_teammembers'),(93,'notify_admin'),(94,'threads_teamid'),(95,'remove_posts_parentid'),(96,'threads_threadteamid'),(97,'create_posts_priority'),(98,'create_post_acknowledgements'),(99,'create_drafts'),(100,'add_draft_priority_column'),(101,'create_true_up_review_history'),(102,'posts_originalid_index'),(103,'add_sentat_to_notifyadmin'),(104,'upgrade_notifyadmin'),(105,'remove_tokens');
/*!40000 ALTER TABLE `db_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_blocks`
--

DROP TABLE IF EXISTS `focalboard_blocks`;
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

--
-- Dumping data for table `focalboard_blocks`
--

LOCK TABLES `focalboard_blocks` WRITE;
/*!40000 ALTER TABLE `focalboard_blocks` DISABLE KEYS */;
INSERT INTO `focalboard_blocks` VALUES ('a14yt5umqginsdnp67tq5ztugkw','2023-05-15 08:25:18.162171','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Post-sales follow up','{\"value\":true}',1684139118159,1684139118159,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a15gffdupj3y4zyxcmhwswreero','2023-05-15 08:25:19.377431','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Send proposal','{}',1684139119373,1684139119373,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a179zkj8ngfbd3k38nkwxpg9wmh','2023-05-15 08:25:19.610753','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'text','## Notes\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.','{}',1684139119607,1684139119606,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a19rb5s9qspdy789wpzat34bdjy','2023-05-15 08:25:38.972068','ck1c13wxrg3fnpxem5d8cu76s4o',1,'text','## Media','{}',1684139138966,1684139138966,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('a1dbxk43ombn4fm1ew8x1qhku3r','2023-05-15 08:25:31.052550','c1axsmo6e5i8tf8xun3qyk57ytr',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139131049,1684139131049,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('a1ewhbrp883bpbjrc89n35buyjh','2023-05-15 08:25:15.939629','cbr1qix816jfyfkm5fcfen13a9e',1,'checkbox','','{\"value\":false}',1684139115936,1684139115936,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a1fj9z7tsejrbux6tbscguca59r','2023-05-15 08:25:34.509254','c485y8w5cnfy47mpyp4mmgbe39r',1,'text','## Interview Notes\n- ...\n- ...\n- ... ','{}',1684139134507,1684139134507,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('a1kiesdgeutgzdyw1ez1ypqzbpe','2023-05-15 08:25:39.070912','ciynnywbiz7rujm5aiphkq3hpmo',1,'text','## Research\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n\n## Notes\n- ...\n- ...','{}',1684139139068,1684139139068,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('a1pu3zj9hpfr1zebdha8j4dp3iw','2023-05-15 08:25:38.950791','ck1c13wxrg3fnpxem5d8cu76s4o',1,'text','## Research\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n\n## Notes\n- ...\n- ...','{}',1684139138947,1684139138947,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('a1u4upynm4jfp5k7q5y9easu5ty','2023-05-15 08:25:36.470860','cs8yd11z8eirpjdf6eu8h1uhpjc',1,'text','## Summary\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.\n## Strengths\n- ...\n- ...\n## Weaknesses\n- ...\n- ...\n## Opportunities\n- ...\n- ...\n## Threats\n- ...\n- ...','{}',1684139136468,1684139136468,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('a1u5t8yxj5jn7dpd1m4gjty71yr','2023-05-15 08:25:18.663074','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Send initial email','{\"value\":false}',1684139118660,1684139118660,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a1wp1k1zieighmg39wyjjygcxre','2023-05-15 08:25:23.757392','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'checkbox','[Subtask 3]','{\"value\":false}',1684139123756,1684139123756,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('a38oj36uc8iys5c6adxsw1korzy','2023-05-15 08:25:18.650074','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Hand-off to customer success','{}',1684139118647,1684139118647,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a3anidddoojytdns14cexrxbo9c','2023-05-15 08:25:15.764557','corc1ng7xtbdqx8po63utq491ro',1,'checkbox','','{\"value\":false}',1684139115762,1684139115762,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a3du3x3wpsfdtidw5xsdt1714ze','2023-05-15 08:25:15.893286','cywrn8u5uqjba9d7dmzk6xrowoe',1,'checkbox','','{\"value\":false}',1684139115892,1684139115892,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a3hdpmeq3zbfrtfgoqafmey7eia','2023-05-15 08:25:44.541759','ctqcabnjrgpbr3pw5nf6q1cugzr',1,'text','Keep stakeholders and customers up-to-date on project progress by sharing your board.','{}',1684139144539,1684139144539,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('a3njt16yxsff4xgy6a7esb9acza','2023-05-15 08:25:17.992418','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Schedule initial sales call','{\"value\":true}',1684139117989,1684139117989,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a3of5ugr877yxufkiujjb5gcooa','2023-05-15 08:25:15.958723','ckf7h5amk87fftmj33mk5gf78ih',1,'divider','','{}',1684139115957,1684139115957,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a3rbis1zhofnefmroitqsp1bcce','2023-05-15 08:25:44.782730','cqmgjgha55p8ktp9wo46nksj5qo',1,'text','Customize cards to fit your needs and track the information most important to you. Boards supports a wide range of fully customizable property types. For example, you can:\n- Use the **Date** property for things like deadlines or milestones.\n- Assign owners to tasks with the **Person** property.\n- Define statuses and priorities with the **Select** property.\n- Create tags with the **Multi Select** property.\n- Link cards to webpages with the **URL** property.','{}',1684139144779,1684139144779,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('a3xqbjspfy3bmpek81gk3jcqd9r','2023-05-15 08:25:18.188863','cdykszx7gffnibcgf4p9gzdit9a',1,'text','## Notes\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.','{}',1684139118186,1684139118186,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a43erpy3dgbg5pr7z8xhogczaqh','2023-05-15 08:25:21.631899','cncphrte4e7b8zke1wcjoia415w',1,'checkbox','Bread','{\"value\":false}',1684139121629,1684139121629,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('a44hj6n51d3bdzfkkbczsgrmhpw','2023-05-15 08:25:18.096925','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Finalize contract','{\"value\":true}',1684139118094,1684139118094,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a49urkhwkbtr18qeqq8k7kfncho','2023-05-15 08:25:22.114184','c48fsy6msutb6i8pcnd7axut6kr',1,'text','## Route','{}',1684139122111,1684139122111,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('a4d4xc3pcx3fxtj6d66gmgam3nc','2023-05-15 08:25:36.484249','cj4fk3wp3rtn1dyeci9basq1w5o',1,'text','## Summary\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.\n\n## Strengths\n- ...\n- ...\n## Weaknesses\n- ...\n- ...\n## Opportunities\n- ...\n- ...\n## Threats\n- ...\n- ...','{}',1684139136481,1684139136481,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('a4gqcqo3h1bn1xkn7cycwj4k6rc','2023-05-15 08:25:15.828180','ch798q5ucefyobf5bymgqjt4f3h',1,'divider','','{}',1684139115816,1684139115816,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a4oacqw9rgtbo5ri9wzijhz1wdw','2023-05-15 08:25:23.766543','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'text','## Description\n*[Brief description of this task]*','{}',1684139123765,1684139123765,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('a4zjojnhsrbfkzbf5ukno7g6yey','2023-05-15 08:25:21.586468','ci6nx4shmpffitmrx951e4oiptw',1,'checkbox','Mobile phone','{\"value\":true}',1684139121584,1684139121584,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('a5g5byxhrgpdrbn3k8z3xor3btr','2023-05-15 08:25:23.830742','cwjh3qjukx38gipog474tobdb3w',1,'text','## Checklist','{}',1684139123829,1684139123829,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('a5jcamahzc7rcdn8rawt9jqs7jh','2023-05-15 08:25:41.772194','cwrq9ag3p5pgzzy98nfd3wwra1w',1,'text','## Summary\n*[Brief description of what this epic is about]*\n## Motivation\n*[Brief description on why this is needed]*\n## Acceptance Criteria\n- *[Criteron 1]*\n- *[Criteron 2]*\n- ...\n## Personas\n- *[Persona A]*\n- *[Persona B]*\n- ...\n## Reference Materials\n- *[Links to other relevant documents as needed]*\n- ...','{}',1684139141769,1684139141769,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('a5ooaofewzinbfn4bczt4ykp3we','2023-05-15 08:25:32.087041','c9iwbjcg8w38ip8m9xizycdmesc',1,'text','## Summary\n*[Brief description of what this epic is about]*\n\n## Motivation\n*[Brief description on why this is needed]*\n\n## Acceptance Criteria\n - *[Criteron 1]*\n - *[Criteron 2]*\n - ...\n\n## Personas\n - *[Persona A]*\n - *[Persona B]*\n - ...\n\n## Reference Materials\n - *[Links to other relevant documents as needed]*\n - ...','{}',1684139132084,1684139132084,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('a5owboss9ytnwzqsg838ax9c7sa','2023-05-15 08:25:18.409495','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Schedule initial sales call','{\"value\":true}',1684139118406,1684139118406,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a5w8x3eswhiyojrmstdzo593nhr','2023-05-15 08:25:17.737523','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Send proposal','{\"value\":true}',1684139117734,1684139117734,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a66pjy1kyx3fw5exrswewq76pbr','2023-05-15 08:25:15.837015','ch798q5ucefyobf5bymgqjt4f3h',1,'checkbox','','{\"value\":false}',1684139115835,1684139115835,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a676u5r9tbpnsumpr67ea3zo6qw','2023-05-15 08:25:44.422918','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Set priorities and update statuses','{\"value\":false}',1684139144420,1684139144420,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('a6etuyneqg3n4jyfr7zn6aqsgia','2023-05-15 08:25:15.851296','ch798q5ucefyobf5bymgqjt4f3h',1,'checkbox','','{\"value\":false}',1684139115850,1684139115850,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a6fageyupsfbyfqebz7opgx9sqy','2023-05-15 08:25:44.649409','ckjptgsceu3fq5fmjmn9d7ugpiw',1,'text','After you\'ve copied the link, paste it into any channel or Direct Message to share the card. A preview of the card will display within the channel with a link back to the card on Boards.','{}',1684139144646,1684139144646,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('a74eggha9pigfmcqrt5hq8fo6ny','2023-05-15 08:25:24.405986','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'checkbox','[Subtask 3]','{\"value\":false}',1684139124403,1684139124403,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('a873fa3hbs3ytumfax4m65fwzgc','2023-05-15 08:25:44.502322','c8x3s1st6ijfzuxhrf5aaei76my',1,'text','A board helps you manage your project, organize tasks, and collaborate with your team all in one place.','{}',1684139144499,1684139144499,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('a87rgrpj9hj8i8egtxphp9qt7rr','2023-05-15 08:25:44.049891','cwchj4bcga7b558k6waqjian4ey',1,'text','Mattermost Boards makes it easy for you to update certain properties on cards through our drag and drop functionality. Simply drag this card from the **Later** column to the **Completed** column to automatically update the status and mark this task as complete.','{}',1684139144046,1684139144046,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('a8m4xntgjujnu9pr359cxagaiqa','2023-05-15 08:25:32.060104','cfmk7771httynm8r7rm8cbrmrya',1,'text','## Steps to reproduce the behavior\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n*[A clear and concise description of what you expected to happen.]*\n\n## Edition and Platform\n- Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n- Version: *[e.g. v0.9.0]*\n- Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n*[Add any other context about the problem here.]*','{}',1684139132057,1684139132057,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('a8qa1t9oegpdtxr1w8inab4o19c','2023-05-15 08:25:21.609002','cncphrte4e7b8zke1wcjoia415w',1,'checkbox','Cereal','{\"value\":false}',1684139121606,1684139121606,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('a91j3t8w9fbye5datoay1to58ho','2023-05-15 08:25:38.999375','cff1jmrxfrirgbeebhr9qd7nida',1,'text','## Research\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n\n## Notes\n- ...\n- ...','{}',1684139138986,1684139138986,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('a94xcxp1iu7yxfxzcide3nkh81o','2023-05-15 08:25:18.714761','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Schedule follow-up sales call','{\"value\":false}',1684139118712,1684139118712,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a96ku8fdcoirf3gcnhs84ro7wce','2023-05-15 08:25:23.826189','cwjh3qjukx38gipog474tobdb3w',1,'text','## Description\n*[Brief description of this task]*','{}',1684139123825,1684139123825,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('a9bqmd5hph3bkpgc1bu6j95btqa','2023-05-15 08:25:19.489151','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Schedule initial sales call','{\"value\":false}',1684139119486,1684139119486,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a9jwwi6qx1j85zpkkr9nfkkkxda','2023-05-15 08:25:21.597777','ci6nx4shmpffitmrx951e4oiptw',1,'checkbox','Internet','{\"value\":true}',1684139121595,1684139121595,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('a9k51ioai67fmjnqsmjwezs1fbe','2023-05-15 08:25:17.847092','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'text','## Checklist','{}',1684139117844,1684139117844,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a9xctw6b81bgrfju1a5hwcq36ra','2023-05-15 08:25:31.137252','cipuiirpksj84xjb69fzyjorysr',1,'text','## Steps to reproduce the behavior\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n*[A clear and concise description of what you expected to happen.]*\n\n## Edition and Platform\n- Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n- Version: *[e.g. v0.9.0]*\n- Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n*[Add any other context about the problem here.]*','{}',1684139131134,1684139131134,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('a9yckxr9rbpyqbx8wxjc5c5tkgc','2023-05-15 08:25:19.506449','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Post-sales follow up','{}',1684139119501,1684139119501,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aa6m58nop8jd5pg94uzgbtkr9dw','2023-05-15 08:25:32.032497','cipuiirpksj84xjb69fzyjorysr',1,'text','## Screenshots\n*[If applicable, add screenshots to elaborate on the problem.]*','{}',1684139132029,1684139132029,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('aa6w5auxnw3d83dioa7ztm54i7o','2023-05-15 08:25:34.482631','cu91c9dt6otycpm7pnep9rgn8ky',1,'text','## Interview Notes\n- ...\n- ...\n- ... ','{}',1684139134480,1684139134479,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('aah9qr9gabiykuxy85dfmojep4r','2023-05-15 08:25:23.780272','cqfonaty9ifrg9mxbr5xk5fyowo',1,'checkbox','[Subtask 1]','{\"value\":false}',1684139123779,1684139123779,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aaigoezzch3fy9knkd3gdjczqzw','2023-05-15 08:25:17.795511','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Hand-off to customer success','{}',1684139117792,1684139117792,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aasewtfi5nigy5feaxy6ps8a53y','2023-05-15 08:25:17.876770','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Send initial email','{\"value\":true}',1684139117873,1684139117873,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ab5zk7prdiiyopkqnb97ntnxqxh','2023-05-15 08:25:21.658565','cncphrte4e7b8zke1wcjoia415w',1,'checkbox','Bananas','{\"value\":false}',1684139121656,1684139121656,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('ab7k61ow3str93y8yt4xzt6fx1h','2023-05-15 08:25:24.435048','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'checkbox','[Subtask 2]','{\"value\":false}',1684139124432,1684139124432,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ac4aoo5dcz38gmbd6yrwwzuy94c','2023-05-15 08:25:21.669593','cncphrte4e7b8zke1wcjoia415w',1,'checkbox','Eggs','{\"value\":false}',1684139121667,1684139121667,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('ac8chzuh3bbrj78copndmi6p38r','2023-05-15 08:25:44.704903','c8xeju51trbg38x6xq6spazwsnc',1,'text','Organize and find the cards you\'re looking for with our filter, sort, and grouping options. From the Board header, you can quickly toggle on different properties, change the group display, set filters, and change how the cards are sorted.','{}',1684139144701,1684139144701,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('acjb5kah4xp835qecaxb6n7nfah','2023-05-15 08:25:18.636342','c7ho5n7y4t7fyimowcpjxuumtea',1,'text','## Checklist','{}',1684139118633,1684139118633,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('acok1kgr63fdhxyc75nx7y1cnpc','2023-05-15 08:25:21.620361','cncphrte4e7b8zke1wcjoia415w',1,'checkbox','Butter','{\"value\":false}',1684139121618,1684139121618,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('acxfipystmbympxztfx5kiqosry','2023-05-15 08:25:19.550951','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Hand-off to customer success','{}',1684139119540,1684139119540,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ad1zwi9jox7dk5njpgjd46briih','2023-05-15 08:25:32.142758','c8z9b6w6757nojkqi5k4kc1eggy',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139132140,1684139132140,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ad3t6abgiytfx3p5cp4tdj7t33a','2023-05-15 08:25:44.676691','ckjptgsceu3fq5fmjmn9d7ugpiw',1,'text','Cards can be linked and shared with teammates directly on Channels. Card previews are displayed when shared on Channels, so your team can discuss work items and get the relevant context without having to switch over to Boards.','{}',1684139144674,1684139144674,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ad4jkwdrk8tygixputknzh3tm9e','2023-05-15 08:25:23.840057','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'checkbox','[Subtask 1]','{\"value\":false}',1684139123839,1684139123839,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ad4napirz73dpzp944nognud99o','2023-05-15 08:25:23.789600','cqfonaty9ifrg9mxbr5xk5fyowo',1,'divider','','{}',1684139123788,1684139123788,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ad65s85n7c3y8pctg9nfdd6z3dc','2023-05-15 08:25:18.753322','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Schedule initial sales call','{\"value\":false}',1684139118750,1684139118750,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('adb14fy97ktr79grpj9dzd3pomh','2023-05-15 08:25:44.464580','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Manage deadlines and milestones','{\"value\":false}',1684139144462,1684139144461,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('adddhxyhoyp8tfme6amns76ssth','2023-05-15 08:25:24.500775','cwzr9jf3kbpnobqdx18edtbxyze',1,'divider','','{}',1684139124498,1684139124498,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('adyads1uwsj8qfeq5mfh4jaz18a','2023-05-15 08:25:18.425220','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Finalize contract','{}',1684139118422,1684139118421,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ae4ya94cgbj8gjfmahfw5dosu7e','2023-05-15 08:25:18.005434','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Send follow-up email','{\"value\":true}',1684139118002,1684139118002,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ae8cp3nwpc3g3m8ujo9rcsd7p4c','2023-05-15 08:25:24.488077','cwzr9jf3kbpnobqdx18edtbxyze',1,'checkbox','[Subtask 3]','{\"value\":false}',1684139124485,1684139124485,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aecekjo6toigp9k9izqesci8uuw','2023-05-15 08:25:32.046693','cuadbgz3yhpbwxcdaco3xhhzqic',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139132043,1684139132043,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('aeh7xbty5s7nhzbtk8181cn778h','2023-05-15 08:25:39.038105','cff1jmrxfrirgbeebhr9qd7nida',1,'text','## Research\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n\n## Notes\n- ...\n- ...','{}',1684139139034,1684139139034,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('aenz8dktc4ifxdgerg1o5m4tgfc','2023-05-15 08:25:17.952910','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Finalize contract','{}',1684139117950,1684139117950,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aeoe3d6d8zbnwjfwcpmbzgmicir','2023-05-15 08:25:15.910284','cywrn8u5uqjba9d7dmzk6xrowoe',1,'text','## Action Items','{}',1684139115907,1684139115907,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('aeorq3aruibgampujchzws9um7r','2023-05-15 08:25:41.572731','cjztn4z4c53dem8kdnkkq6tc8fa',1,'text','## Screenshots\n*[If applicable, add screenshots to elaborate on the problem.]*','{}',1684139141570,1684139141570,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('aepo996a5ainqbr1syz3u19oxuy','2023-05-15 08:25:41.670020','cfefgwjke6bbxpjpig618g9bpte',1,'text','## Steps to reproduce the behavior\n\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n\n*[A clear and concise description of what you expected to happen.]*\n\n## Screenshots\n\n*[If applicable, add screenshots to elaborate on the problem.]*\n\n## Edition and Platform\n\n - Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n - Version: *[e.g. v0.9.0]*\n - Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n\n*[Add any other context about the problem here.]*','{}',1684139141667,1684139141667,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('aeqhexi8j9pykich95cew93h6dh','2023-05-15 08:25:15.984517','ckf7h5amk87fftmj33mk5gf78ih',1,'text','## Notes\n*[Add meeting notes here]*','{}',1684139115983,1684139115983,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('aeqr1qzecppgkjqhe7obwf1ehxy','2023-05-15 08:25:41.708991','cidz4imnqhir48brz6e8hxhfrhy',1,'text','## Requirements\n- [Requirement 1]\n- [Requirement 2]\n- ...','{}',1684139141706,1684139141706,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('aerxw6a5f6tbq5cfuo97h1dcp1w','2023-05-15 08:25:38.892295','cb89odozjd788py34ggamhsyo1h',1,'text','## Research\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n\n## Notes\n- ...\n- ...','{}',1684139138885,1684139138885,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('aeuc3ii3akir43j81makf3hxuay','2023-05-15 08:25:39.056548','c8n4xu7ntq7bbbd14noats457ro',1,'text','## Research\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n\n## Notes\n- ...\n- ...','{}',1684139139053,1684139139052,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('aeyxha9paaf8etxhfbkyqcmd9qa','2023-05-15 08:25:24.551989','cwzr9jf3kbpnobqdx18edtbxyze',1,'text','## Checklist','{}',1684139124549,1684139124549,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('afbqaohnf8fdi7k43xo86jcri1a','2023-05-15 08:25:18.536069','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Post-sales follow up','{}',1684139118533,1684139118533,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('afbrk7aqnsigijbmueau4r1mhzy','2023-05-15 08:25:44.809807','cyw3bxrbfepf3tq4m8yfag5h3wo',1,'text','To mention a teammate use the **@ symbol with their username** in the comments or description section. They\'ll get a Direct Message notification via Channels and also be added as a [follower](https://docs.mattermost.com/boards/work-with-cards.html#receive-updates) to the card. \n\nWhenever any changes are made to the card, they\'ll automatically get notified on Channels.','{}',1684139144807,1684139144807,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('afgz6ufu6xjbdpjke4gjhxrzbpa','2023-05-15 08:25:18.018676','cow8jauqkabgb8etq9ckdo8nhrh',1,'text','## Notes\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.','{}',1684139118016,1684139118015,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('afniyj7y9hbbabkshk1bdoiekjc','2023-05-15 08:25:18.701445','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Send follow-up email','{\"value\":false}',1684139118698,1684139118698,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('afst5iycoy3rhixsdjihf3peoey','2023-05-15 08:25:17.860439','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'text','## Notes\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.','{}',1684139117857,1684139117857,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ag34x3ougupbrfd5ypsbrqueb5e','2023-05-15 08:25:44.581965','cbokq5iftypbs3gspcn15kp1u4r',1,'text','To create a new card, simply do any of the following:\n- Select \"**New**\" on the top right header\n- Select \"**+ New**\" below any column\n- Select \"**+**\" to the right of any columnn header','{}',1684139144579,1684139144579,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ag351ba8q87rjzy868zsaoxu36y','2023-05-15 08:25:41.588004','cffwedhcphjnxdnx7gi5ef487mc',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139141585,1684139141585,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('agbstqsrjejd6iemscpeixjpj8o','2023-05-15 08:25:18.378032','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Schedule follow-up sales call','{\"value\":true}',1684139118375,1684139118375,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('agdze3c4gu78m5bke4qwwpigika','2023-05-15 08:25:44.824377','cyw3bxrbfepf3tq4m8yfag5h3wo',1,'text','Collaborate with teammates directly on each card using @mentions and have all the relevant context in one place.','{}',1684139144821,1684139144821,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('age6hf4ppq3gy7y8y44mhrdsifr','2023-05-15 08:25:18.453822','c8tf9wun9gtyc7bzize8f513eqc',1,'text','## Notes\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.','{}',1684139118451,1684139118451,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ageiia35pfjrsfcdyn6fbxbtt4r','2023-05-15 08:25:19.399358','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Send initial email','{\"value\":true}',1684139119395,1684139119395,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('agh8493dxoff6ucoi993ym6o1cw','2023-05-15 08:25:18.110007','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Schedule follow-up sales call','{\"value\":true}',1684139118107,1684139118107,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('agjiprrojcjyg9x9q7kxe8n8eyr','2023-05-15 08:25:36.458055','c4htpxn8wxpd6pffpjo4u8xxxxc',1,'text','## Summary\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.\n## Strengths\n- ...\n- ...\n## Weaknesses\n- ...\n- ...\n## Opportunities\n- ...\n- ...\n## Threats\n- ...\n- ...','{}',1684139136455,1684139136455,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('agp4hy9m6hjbkdqtohoeia1yenh','2023-05-15 08:25:21.644069','cncphrte4e7b8zke1wcjoia415w',1,'checkbox','Milk','{\"value\":false}',1684139121641,1684139121641,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('agpfti6dum7f1tg3uid8uy1wbza','2023-05-15 08:25:17.965997','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Post-sales follow up','{}',1684139117963,1684139117963,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('agzumfpbi1bg37gj3d7zkwj8c1o','2023-05-15 08:25:31.105971','cot7fjjb68pgn9xdgr4yy3pwfur',1,'text','## Screenshots\n*[If applicable, add screenshots to elaborate on the problem.]*','{}',1684139131103,1684139131103,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ah8yjnketf7rcxyegsef1gmkjow','2023-05-15 08:25:18.575319','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Schedule demo','{\"value\":false}',1684139118572,1684139118572,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ahact8zrmctbnzknxe9udhawjfe','2023-05-15 08:25:19.591936','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'text','## Checklist','{}',1684139119587,1684139119587,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ahcc7baon8irodktqpfj1db4mdw','2023-05-15 08:25:34.502360','c8ra694tq4bfm5czq11g6wnq3re',1,'text','## Interview Notes\n- ...\n- ...\n- ... ','{}',1684139134501,1684139134501,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('ahd73ykmw6pd9bqqwsppk6wx9ty','2023-05-15 08:25:18.480743','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Schedule initial sales call','{\"value\":false}',1684139118477,1684139118477,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ahf6q3fi9xtykfjcmx4sibf67cw','2023-05-15 08:25:21.574986','ci6nx4shmpffitmrx951e4oiptw',1,'checkbox','Utilities','{\"value\":true}',1684139121572,1684139121572,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('ahpe1ytxnebr5zgh3ryz31u8fxh','2023-05-15 08:25:41.652483','cfefgwjke6bbxpjpig618g9bpte',1,'text','## Steps to reproduce the behavior\n\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n\nA clear and concise description of what you expected to happen.\n\n## Edition and Platform\n\n - Edition: Personal Desktop / Personal Server / Mattermost plugin\n - Version: [e.g. v0.9.0]\n - Browser and OS: [e.g. Chrome 91 on macOS, Edge 93 on Windows]\n\n## Additional context\n\nAdd any other context about the problem here.','{}',1684139141649,1684139141649,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('ahpm1u53gepnn5c5mnkp68radgh','2023-05-15 08:25:22.100362','c48fsy6msutb6i8pcnd7axut6kr',1,'text','## Goal\nWalk at least 10,000 steps every day.','{}',1684139122096,1684139122096,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('ai9de4de7atrujridwbungisg6o','2023-05-15 08:25:15.844743','ch798q5ucefyobf5bymgqjt4f3h',1,'checkbox','','{\"value\":false}',1684139115843,1684139115843,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('aidjkys6sw387xd5d5yxqsr7cqe','2023-05-15 08:25:19.473847','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Schedule demo','{\"value\":false}',1684139119471,1684139119471,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aif8a8d7kjfrg5k8ni856wp454r','2023-05-15 08:25:23.775738','cqfonaty9ifrg9mxbr5xk5fyowo',1,'checkbox','...','{\"value\":false}',1684139123774,1684139123774,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aihg18paddjdimcdnh71bjwkhoo','2023-05-15 08:25:18.727635','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Send proposal','{}',1684139118725,1684139118725,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aikzfeo3qytg9bym53moh3iwryo','2023-05-15 08:25:31.091027','cot7fjjb68pgn9xdgr4yy3pwfur',1,'text','## Steps to reproduce the behavior\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n*[A clear and concise description of what you expected to happen.]*\n\n## Edition and Platform\n- Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n- Version: *[e.g. v0.9.0]*\n- Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n*[Add any other context about the problem here.]*','{}',1684139131088,1684139131087,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ainarjkocuiduxrbb63t9xoyper','2023-05-15 08:25:17.764262','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Schedule initial sales call','{\"value\":true}',1684139117761,1684139117761,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aip3g6feocp8i9fbxf8mtnsomny','2023-05-15 08:25:23.784986','cqfonaty9ifrg9mxbr5xk5fyowo',1,'checkbox','[Subtask 3]','{\"value\":false}',1684139123784,1684139123784,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aiw8kpb5u1tnmxqkq6p5tpybdqc','2023-05-15 08:25:23.743434','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'checkbox','[Subtask 2]','{\"value\":false}',1684139123742,1684139123742,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aixwwtex9ofbo58tws4p8kzzzhh','2023-05-15 08:25:18.621509','c7ho5n7y4t7fyimowcpjxuumtea',1,'text','## Notes\n[Enter notes here...]','{}',1684139118618,1684139118618,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aj3idc59csjbhupc81cr5drn1eh','2023-05-15 08:25:18.071215','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Send follow-up email','{\"value\":true}',1684139118068,1684139118068,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ajg45nyrs7jyubdb8ugpjrasctc','2023-05-15 08:25:19.455944','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Schedule follow-up sales call','{\"value\":false}',1684139119453,1684139119452,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ajguuc7nfctfptbaq8k1cnz7smc','2023-05-15 08:25:32.129239','cec73iz548tyzfeagiummkqyh6c',1,'text','## Screenshots\n*[If applicable, add screenshots to elaborate on the problem.]*','{}',1684139132126,1684139132126,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ajgws6yq75tgm3yg8u39gs9mana','2023-05-15 08:25:17.922046','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Send proposal','{\"value\":true}',1684139117919,1684139117919,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ajofqzk5biighxbxuu5hrz9hqrr','2023-05-15 08:25:17.750974','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Finalize contract','{}',1684139117748,1684139117748,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ajuuacx8d33f19nha8m71pbwuih','2023-05-15 08:25:18.740609','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Follow up after demo','{}',1684139118737,1684139118737,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ak16ghrgwzpfcibwxfaensud9ch','2023-05-15 08:25:23.794307','cqfonaty9ifrg9mxbr5xk5fyowo',1,'text','## Checklist','{}',1684139123793,1684139123793,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ak6e7c8z5k7yr9gzcss76ndkmna','2023-05-15 08:25:15.808723','corc1ng7xtbdqx8po63utq491ro',1,'text','## Action Items','{}',1684139115806,1684139115806,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('ak7rktdxk4tbtuxuitq5p37ficr','2023-05-15 08:25:18.520115','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Finalize contract','{}',1684139118516,1684139118516,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('akft6riy6zfgwbjowd4746t431o','2023-05-15 08:25:15.865841','ch798q5ucefyobf5bymgqjt4f3h',1,'text','# Notes\n*[Add meeting notes here]*','{}',1684139115864,1684139115864,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('akgbx1ddui38sirbij6aan5sbur','2023-05-15 08:25:24.539460','cwzr9jf3kbpnobqdx18edtbxyze',1,'text','## Description\n*[Brief description of this task]*','{}',1684139124536,1684139124536,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('akja3h5qikjrzxmutooteo9196a','2023-05-15 08:25:23.771252','cqfonaty9ifrg9mxbr5xk5fyowo',1,'checkbox','[Subtask 2]','{\"value\":false}',1684139123770,1684139123770,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('akqw19ofqotr78g78jobfykj3ia','2023-05-15 08:25:41.759409','cbm9y3gmqqjd6uewottgm8mocwh',1,'text','## Steps to reproduce the behavior\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n*[A clear and concise description of what you expected to happen.]*\n\n## Edition and Platform\n- Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n- Version: *[e.g. v0.9.0]*\n- Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n*[Add any other context about the problem here.]*','{}',1684139141756,1684139141756,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('aksausnmc93dtjjzu86yuqeedze','2023-05-15 08:25:18.031940','cow8jauqkabgb8etq9ckdo8nhrh',1,'text','## Checklist','{}',1684139118029,1684139118029,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('am6o87kzyk7gymeyhkq4p48zd1c','2023-05-15 08:25:15.915441','cywrn8u5uqjba9d7dmzk6xrowoe',1,'text','## Notes\n*[Add meeting notes here]*','{}',1684139115914,1684139115914,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('am8qkb9prmtrxjp5gdjgq6quizc','2023-05-15 08:25:18.766363','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Schedule demo','{\"value\":false}',1684139118763,1684139118763,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('amf64og7po7dnxdir6idmyk1qnw','2023-05-15 08:25:32.182931','cczudbnf113g1fezgjcbj8wqd9h',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139132180,1684139132180,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('amho5gxfybbrt5n3ko48x5d8pny','2023-05-15 08:25:41.683485','c4qc8gzhjipf6mmbat9du8ye9kr',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139141680,1684139141680,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('amiis7xbrqtf6dc8ww13heeg6aw','2023-05-15 08:25:15.952489','cbr1qix816jfyfkm5fcfen13a9e',1,'text','## Notes\n*[Add meeting notes here]*','{}',1684139115951,1684139115951,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('amw9356bg67rr881axj93ca7boo','2023-05-15 08:25:23.748311','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'divider','','{}',1684139123747,1684139123747,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('amxzpzr3pf3y49pjgrraceemn7h','2023-05-15 08:25:15.963871','ckf7h5amk87fftmj33mk5gf78ih',1,'checkbox','','{\"value\":false}',1684139115962,1684139115962,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('an1cauynf7i87md78gocifotujo','2023-05-15 08:25:23.807980','cwjh3qjukx38gipog474tobdb3w',1,'checkbox','[Subtask 2]','{\"value\":false}',1684139123807,1684139123807,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('an1ni5jxrkibi3f4pe1wis5kdha','2023-05-15 08:25:18.493963','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Schedule follow-up sales call','{\"value\":false}',1684139118491,1684139118491,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('an3gwsu6ztjrfixpmhdahaqt63h','2023-05-15 08:25:19.414604','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Follow up after demo','{}',1684139119411,1684139119411,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('an935fht14fr8mpjo99fuwaw4zo','2023-05-15 08:25:18.083734','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Send proposal','{\"value\":true}',1684139118081,1684139118081,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('anihyopcbefgpueysxaqwg8emwr','2023-05-15 08:25:19.439991','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Finalize contract','{}',1684139119437,1684139119437,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('anjsttbf3tpbntpgmy63kegm3yc','2023-05-15 08:25:44.555028','ctqcabnjrgpbr3pw5nf6q1cugzr',1,'text','To share a board, select **Share** at the top right of the Board view. Copy the link to share the board internally with your team or generate public link that can be accessed by anyone externally.','{}',1684139144552,1684139144552,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ank4fqmyfotyi9x18g5x1h83d3h','2023-05-15 08:25:23.738148','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'checkbox','[Subtask 1]','{\"value\":false}',1684139123737,1684139123737,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('anoje9s1eqjgrbjierpddcjjych','2023-05-15 08:25:15.793739','corc1ng7xtbdqx8po63utq491ro',1,'checkbox','','{\"value\":false}',1684139115791,1684139115791,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('ansjzguztbiffmmesd9nfrmjz7h','2023-05-15 08:25:44.476632','c1skdp9t1mtnjbxcmoshjj94x8a',1,'text','Cards allow your entire team to manage and collaborate on a task in one place. Within a card, your team can:','{}',1684139144474,1684139144474,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('anuotdyg8ajfo7guetz5npmznqy','2023-05-15 08:25:18.229373','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Hand-off to customer success','{}',1684139118226,1684139118226,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('anxrc977em3gcbj6tuuz3pjse4w','2023-05-15 08:25:18.439982','c8tf9wun9gtyc7bzize8f513eqc',1,'text','## Checklist','{}',1684139118437,1684139118437,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ao5e371hhsid19pys4u7xjngpsr','2023-05-15 08:25:18.675775','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Post-sales follow up','{}',1684139118673,1684139118673,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ao9bnrjmwfb8o8mb4maqr4hjpne','2023-05-15 08:25:18.135484','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Schedule demo','{\"value\":true}',1684139118132,1684139118132,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aoem1zdrjnid3ineo4tene5xo4o','2023-05-15 08:25:18.606853','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Follow up after demo','{}',1684139118603,1684139118603,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aof79cphr9jdntgcw74deqwjypc','2023-05-15 08:25:17.895944','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Schedule follow-up sales call','{\"value\":true}',1684139117893,1684139117893,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aoi7yahtppir47cuch69s1mbrde','2023-05-15 08:25:24.449875','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'text','## Checklist','{}',1684139124446,1684139124446,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aor7ibfgeqj8a7roum58xqcjy5o','2023-05-15 08:25:24.615137','czw9es1e89fdpjr7cqptr1xq7qh',1,'checkbox','...','{\"value\":false}',1684139124612,1684139124612,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aosqp85sp5pbkzfhqkc9f9kx9br','2023-05-15 08:25:18.467021','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Send initial email','{\"value\":false}',1684139118464,1684139118464,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aouftfp6ui3nhz8y3rwwzarnoky','2023-05-15 08:25:21.680995','cncphrte4e7b8zke1wcjoia415w',1,'text','## Grocery list','{}',1684139121678,1684139121678,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('aoxteiun1cj85ppwpw935htrify','2023-05-15 08:25:23.835440','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'divider','','{}',1684139123834,1684139123834,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aoy8dg4jgbfdp8pdm9ga1uk3rrw','2023-05-15 08:25:24.462871','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'text','## Description\n*[Brief description of this task]*','{}',1684139124460,1684139124460,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ap85qk77cspb33rwkgj1f6t5saa','2023-05-15 08:25:15.974260','ckf7h5amk87fftmj33mk5gf78ih',1,'checkbox','','{\"value\":false}',1684139115973,1684139115973,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('apbwgk8edpfnwfkt3gn7m89awce','2023-05-15 08:25:18.794355','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'text','## Notes\n[Enter notes here...]','{}',1684139118791,1684139118791,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('apcmmc1nr47dbfjsue7g8rzjk1h','2023-05-15 08:25:32.156416','cpx6a1cf3u7b73gsdmmehw7gx7c',1,'text','## Summary\n*[Brief description of what this epic is about]*\n\n## Motivation\n*[Brief description on why this is needed]*\n\n## Acceptance Criteria\n - *[Criteron 1]*\n - *[Criteron 2]*\n - ...\n\n## Personas\n - *[Persona A]*\n - *[Persona B]*\n - ...\n\n## Reference Materials\n - *[Links to other relevant documents as needed]*\n - ...','{}',1684139132153,1684139132153,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('aphzuak83niydzqmomg8kerrjzo','2023-05-15 08:25:17.724580','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Send follow-up email','{\"value\":true}',1684139117722,1684139117721,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('apj4n919rn3n5tn44dzozi43b9a','2023-05-15 08:25:44.733136','czphuqnioo7fydrsb8pu7qrosgw',1,'text','Views allow your team to visualize the same cards and data from different perspectives, so they can stay up-to-date in the way that works best for them. To add a new view, go to **Add a new view** from the view drop-down, then select from any of the following views:\n\n- **Board**: Adds a Kanban board, similar to this one, that allows your team to organize cards in swimlanes grouped by any property of your choosing. This view helps you visualize your project progress.\n- **Table**: Displays cards in a table format with rows and columns. Use this view to get an overview of all your project tasks. Easily view and compare the state of all properties across all cards without needing to open individual cards.\n- **Gallery**: Displays cards in a gallery format, so you can manage and organize cards with image attachments.\n- **Calendar**: Adds a calendar view to easily visualize your cards by dates and keep track of deadlines.','{}',1684139144730,1684139144730,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('apjxwm8wbai8puqi5hsyu16ex4a','2023-05-15 08:25:18.175520','cdykszx7gffnibcgf4p9gzdit9a',1,'text','## Checklist','{}',1684139118172,1684139118172,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('apo1h5w4debdjmr9usxauqtqwby','2023-05-15 08:25:15.945955','cbr1qix816jfyfkm5fcfen13a9e',1,'text','## Action Items','{}',1684139115944,1684139115944,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('apqufugtc63fstkgchiayik9uze','2023-05-15 08:25:24.628000','czw9es1e89fdpjr7cqptr1xq7qh',1,'text','## Description\n*[Brief description of this task]*','{}',1684139124625,1684139124625,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aqenhkcet77f1tmexfzbdqu1auo','2023-05-15 08:25:36.512075','c98nnstjzhbgmpj6g88rgpgnheh',1,'text','## Summary\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.\n## Strengths\n- ...\n- ...\n## Weaknesses\n- ...\n- ...\n## Opportunities\n- ...\n- ...\n## Threats\n- ...\n- ...','{}',1684139136509,1684139136509,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('aqfzsxtdkjf8fxn68you4bs5tmw','2023-05-15 08:25:17.711502','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Send initial email','{\"value\":true}',1684139117708,1684139117708,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aqpusoh9o8bndupb7m9sbpqcbmr','2023-05-15 08:25:17.808247','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Follow up after demo','{\"value\":true}',1684139117805,1684139117805,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aqq3gzop1j3r6zry618epesj6da','2023-05-15 08:25:24.475576','cwzr9jf3kbpnobqdx18edtbxyze',1,'checkbox','...','{\"value\":false}',1684139124472,1684139124472,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aqqp3dac3wirhpptohuqz83gkqy','2023-05-15 08:25:44.081271','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Create and manage checklists, like this one... :)','{\"value\":false}',1684139144077,1684139144077,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('aqtr5wbetofb6dfbfqh4k6dmqke','2023-05-15 08:25:18.552988','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Send follow-up email','{\"value\":false}',1684139118550,1684139118550,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('araqcr581mirqjbmhi8x4xd1wza','2023-05-15 08:25:23.821500','cwjh3qjukx38gipog474tobdb3w',1,'checkbox','[Subtask 1]','{\"value\":false}',1684139123820,1684139123820,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('artcz3tm1at8sjbgeft8dqdj1ew','2023-05-15 08:25:24.564795','czw9es1e89fdpjr7cqptr1xq7qh',1,'checkbox','[Subtask 3]','{\"value\":false}',1684139124562,1684139124562,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('arwrz93jeotggxrnn7ryte44wrw','2023-05-15 08:25:17.781183','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Schedule demo','{\"value\":true}',1684139117778,1684139117778,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('arxyp6pddc7dgxqwjsk75ion5ea','2023-05-15 08:25:44.099733','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Add and update descriptions with Markdown','{\"value\":false}',1684139144096,1684139144096,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('as4xgtsyfpbn69k9b5t347dwbde','2023-05-15 08:25:18.364579','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Send initial email','{\"value\":true}',1684139118361,1684139118361,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('as71mueofj78efrn5y758abxbeo','2023-05-15 08:25:41.601833','c6sc3f5fjmf8cbcqchzku19mg9a',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139141599,1684139141599,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('asdeyo96o6ig9bxh16o9zg8q4rc','2023-05-15 08:25:18.688835','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Finalize contract','{}',1684139118686,1684139118686,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('asdxx54r1zjyw9ktjyif8heczza','2023-05-15 08:25:24.602405','czw9es1e89fdpjr7cqptr1xq7qh',1,'checkbox','[Subtask 1]','{\"value\":false}',1684139124599,1684139124599,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('asgcymmis4fdkpqazjh45cupddo','2023-05-15 08:25:41.696441','cidz4imnqhir48brz6e8hxhfrhy',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139141693,1684139141693,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('asiwim3qmcbfpmjyhn5keb1x3ya','2023-05-15 08:25:41.793877','cwrq9ag3p5pgzzy98nfd3wwra1w',1,'text','## Summary\n[Brief description of what this epic is about]\n\n## Motivation\n[Brief description on why this is needed]\n\n## Acceptance Criteria\n - [Criteron 1]\n - [Criteron 2]\n - ...\n\n## Personas\n - [Persona A]\n - [Persona B]\n - ...\n\n## Reference Materials\n - [Links to other relevant documents as needed]\n - ...','{}',1684139141790,1684139141790,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('asu9m4usdcb8y3ka1hegjs3merh','2023-05-15 08:25:15.875730','cywrn8u5uqjba9d7dmzk6xrowoe',1,'divider','','{}',1684139115874,1684139115874,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('asxkajbi1tfrgm8i9d3x84jfmfe','2023-05-15 08:25:15.800180','corc1ng7xtbdqx8po63utq491ro',1,'text','## Notes\n*[Add meeting notes here]*','{}',1684139115798,1684139115798,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('aszwzw4fw8tnzpxmswm3xz19ybh','2023-05-15 08:25:15.902523','cywrn8u5uqjba9d7dmzk6xrowoe',1,'checkbox','','{\"value\":false}',1684139115901,1684139115901,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('at31uh665kjr1tyw77braff6qte','2023-05-15 08:25:24.640746','czw9es1e89fdpjr7cqptr1xq7qh',1,'text','## Checklist','{}',1684139124638,1684139124638,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('at619ib5a4fn19r34tizcab3etw','2023-05-15 08:25:15.968963','ckf7h5amk87fftmj33mk5gf78ih',1,'checkbox','','{\"value\":false}',1684139115967,1684139115967,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('at7h4mzxqw3nx8ctsecufy6zuhe','2023-05-15 08:25:24.526399','cwzr9jf3kbpnobqdx18edtbxyze',1,'checkbox','[Subtask 1]','{\"value\":false}',1684139124523,1684139124523,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('at8yeqopxbbfn5nqzxdyrxqmfyy','2023-05-15 08:25:32.073532','cfmk7771httynm8r7rm8cbrmrya',1,'text','## Screenshots\n*[If applicable, add screenshots to elaborate on the problem.]*','{}',1684139132070,1684139132070,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('atafa47uz7byruq66jaxwpefigh','2023-05-15 08:25:32.169575','c8kkpb6wh7igg7nw88x8nfnwf4c',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139132166,1684139132166,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('athngtrguzfd9jbstjo1iq837hc','2023-05-15 08:25:24.420609','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'checkbox','...','{\"value\":false}',1684139124417,1684139124417,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('atkub6nqtjtbgmrpf5y6isjrfoo','2023-05-15 08:25:41.558716','cjztn4z4c53dem8kdnkkq6tc8fa',1,'text','## Steps to reproduce the behavior\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n*[A clear and concise description of what you expected to happen.]*\n\n## Edition and Platform\n- Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n- Version: *[e.g. v0.9.0]*\n- Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n*[Add any other context about the problem here.]*','{}',1684139141556,1684139141555,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('atuegurdywfr9mm93u779ywkdia','2023-05-15 08:25:18.148466','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Hand-off to customer success','{\"value\":true}',1684139118146,1684139118145,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('atzms9yotn3f87k3sy6c6zecx6e','2023-05-15 08:25:18.215885','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Send proposal','{}',1684139118212,1684139118212,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('au6nr9h1zp3nr78m6ei3sdp8ctw','2023-05-15 08:25:34.469502','ccfkf8w5ntpfx7d7afp8upt6jca',1,'text','## Interview Notes\n- ...\n- ...\n- ... ','{}',1684139134467,1684139134467,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('au6tkhdp3s3fumc4f5yzp6achgc','2023-05-15 08:25:15.932311','cbr1qix816jfyfkm5fcfen13a9e',1,'divider','','{}',1684139115931,1684139115931,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('au98tgq5nctdj9djkoih4n9tf5e','2023-05-15 08:25:18.350340','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Schedule demo','{\"value\":true}',1684139118346,1684139118346,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('auagdeuwwup8k8pdn9fs6joijwo','2023-05-15 08:25:17.908640','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Follow up after demo','{\"value\":true}',1684139117906,1684139117905,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('auc36b1696pnfbgakcmht4jxsph','2023-05-15 08:25:23.816948','cwjh3qjukx38gipog474tobdb3w',1,'checkbox','[Subtask 3]','{\"value\":false}',1684139123816,1684139123815,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aucfbqzo8sbbepbd37tehj6bgky','2023-05-15 08:25:15.785289','corc1ng7xtbdqx8po63utq491ro',1,'divider','','{}',1684139115783,1684139115783,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('aufn3gqypspr89n15aspuo637ir','2023-05-15 08:25:17.834036','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Post-sales follow up','{}',1684139117831,1684139117831,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('auise6ioid3bhxkxx6bbq1zgsga','2023-05-15 08:25:41.631729','cfefgwjke6bbxpjpig618g9bpte',1,'text','## Screenshots\nIf applicable, add screenshots to elaborate on the problem.','{}',1684139141629,1684139141629,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('aumref76zp7n9jjk6yzzthif6rh','2023-05-15 08:25:23.812299','cwjh3qjukx38gipog474tobdb3w',1,'divider','','{}',1684139123811,1684139123811,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aupi3t9ib3jy65qwzme7i4ky8ar','2023-05-15 08:25:23.752886','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'checkbox','...','{\"value\":false}',1684139123751,1684139123751,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aupozsqimzprfpkym5m1dsw17ze','2023-05-15 08:25:41.721493','c3zpru7o6ibfxup6ej47xu8mc4a',1,'text','## Summary\n*[Brief description of what this epic is about]*\n\n## Motivation\n*[Brief description on why this is needed]*\n\n## Acceptance Criteria\n - *[Criteron 1]*\n - *[Criteron 2]*\n - ...\n\n## Personas\n - *[Persona A]*\n - *[Persona B]*\n - ...\n\n## Reference Materials\n - *[Links to other relevant documents as needed]*\n - ...','{}',1684139141719,1684139141719,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('ausby18os4idotruuexr3iunrga','2023-05-15 08:25:15.857523','ch798q5ucefyobf5bymgqjt4f3h',1,'text','# Action Items','{}',1684139115856,1684139115856,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('ausmstaiqf7ghiducjna77chfra','2023-05-15 08:25:32.115782','cec73iz548tyzfeagiummkqyh6c',1,'text','## Steps to reproduce the behavior\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n*[A clear and concise description of what you expected to happen.]*\n\n## Edition and Platform\n- Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n- Version: *[e.g. v0.9.0]*\n- Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n*[Add any other context about the problem here.]*','{}',1684139132111,1684139132111,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('autj3nzqztpbxtqo6iadg3f3psw','2023-05-15 08:25:44.439358','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Provide feedback and ask questions via comments','{\"value\":false}',1684139144435,1684139144435,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('auyfk6pje3fyetngebek4jqxu1h','2023-05-15 08:25:18.044780','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Follow up after demo','{\"value\":true}',1684139118042,1684139118042,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aw456tyy4zjbjpm4kusbxh739qa','2023-05-15 08:25:24.589634','czw9es1e89fdpjr7cqptr1xq7qh',1,'divider','','{}',1684139124587,1684139124587,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('awe76d1gxifg9dcc73rakdnaz1y','2023-05-15 08:25:34.493457','c87rtonnkmpd6umzmppctjhdrgc',1,'text','## Interview Notes\n- ...\n- ...\n- ... ','{}',1684139134491,1684139134491,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('aweccxa5qzbd8ukzpe9d66a6kgy','2023-05-15 08:25:17.821162','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Schedule follow-up sales call','{\"value\":true}',1684139117818,1684139117818,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('awgaxdy4rctnnmptqi1a35dzrzw','2023-05-15 08:25:24.513328','cwzr9jf3kbpnobqdx18edtbxyze',1,'checkbox','[Subtask 2]','{\"value\":false}',1684139124510,1684139124510,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('awgph3xm5finx7ki7nit8t6iuuh','2023-05-15 08:25:18.242748','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Follow up after demo','{}',1684139118239,1684139118239,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('awim8q6fuxjb3fgjkg97qt881qa','2023-05-15 08:25:18.780923','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'text','## Checklist','{}',1684139118778,1684139118778,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('awius1nogcbre3fk3rgqgt95hio','2023-05-15 08:25:44.063524','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Assign tasks to teammates','{\"value\":false}',1684139144060,1684139144060,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('awjcijjpwhbfgjpz6jmfye5gbcw','2023-05-15 08:25:15.884712','cywrn8u5uqjba9d7dmzk6xrowoe',1,'checkbox','','{\"value\":false}',1684139115883,1684139115883,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('awmkaa8ojq3bn5cj75ysw3ahjaa','2023-05-15 08:25:41.747020','cbm9y3gmqqjd6uewottgm8mocwh',1,'text','## Screenshots\n*[If applicable, add screenshots to elaborate on the problem.]*','{}',1684139141744,1684139141744,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('awonjqmd7p7g3d89p8out437tbh','2023-05-15 08:25:39.021675','cff1jmrxfrirgbeebhr9qd7nida',1,'text','## Research\n- ...\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n- ...\n\n## Notes\n- ...\n- ...\n- ...','{}',1684139139018,1684139139018,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('awq3cxngkbfnt5fkzpfxczdmnaw','2023-05-15 08:25:15.979493','ckf7h5amk87fftmj33mk5gf78ih',1,'text','## Action Items','{}',1684139115978,1684139115978,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('awtn5z6btdfy39foagfpnepokya','2023-05-15 08:25:18.393519','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Send follow-up email','{\"value\":true}',1684139118390,1684139118390,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('awu8m855ws7gitfcbakbyq5pe9w','2023-05-15 08:25:23.761860','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'text','## Checklist','{}',1684139123760,1684139123760,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('awuo3zo7wgbb9br1t18d7p7p8ew','2023-05-15 08:25:22.126665','cjsgbbn88fbd8pjcue85wa8xzor',1,'text','','{}',1684139122124,1684139122124,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('ax41nr5o9j7r6bnoukbcxxpkf5y','2023-05-15 08:25:44.515156','c8x3s1st6ijfzuxhrf5aaei76my',1,'text','To create your own board, select the \"+\" on the top of the left hand sidebar. Choose from one of our standard templates and see how they can help you get started with your next project:\n\n- **Project Tasks**: Stay on top of your project tasks, track progress, and set priorities. \n- **Meeting Agenda**: Set your meeting agendas for recurring team meetings and 1:1s.\n- **Roadmap**: Plan your roadmap and manage your releases more efficiently.\n- **Personal Tasks**: Organize your life and track your personal tasks.\n- **Content Calendar**: Plan your editorial content, assign work, and track deadlines.\n- **Personal Goals**: Set and accomplish new personal goals and milestones.','{}',1684139144512,1684139144512,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ax8k51xesh7g3dqri57sbq9zzdo','2023-05-15 08:25:17.978986','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Schedule demo','{\"value\":true}',1684139117976,1684139117976,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('axdnwf9i75byy8pos6dp38zpnmr','2023-05-15 08:25:15.777955','corc1ng7xtbdqx8po63utq491ro',1,'checkbox','','{\"value\":false}',1684139115776,1684139115776,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('axedjwpq1y7ru3c3fne9tuhbiae','2023-05-15 08:25:19.568643','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Send follow-up email','{\"value\":false}',1684139119565,1684139119565,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('axehsiymm93rrpeaumbiuwmkyow','2023-05-15 08:25:44.616709','cbokq5iftypbs3gspcn15kp1u4r',1,'text','Mattermost Boards helps you manage and track all your project tasks with **Cards**.','{}',1684139144592,1684139144592,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('axggtfboiptri8yt6qgkaef7qua','2023-05-15 08:25:44.662698','ckjptgsceu3fq5fmjmn9d7ugpiw',1,'text','To share a card, you\'ll need to copy the card link first. You can:\n\n- Open a card and select the options menu button at the top right of the card.\n- Open the board view and hover your mouse over any card to access the options menu button.','{}',1684139144660,1684139144660,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('axzei9dbwufg8dgkn4is7xhtu7r','2023-05-15 08:25:23.798765','cqfonaty9ifrg9mxbr5xk5fyowo',1,'text','## Description\n*[Brief description of this task]*','{}',1684139123797,1684139123797,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('axznpefqo3jg95ni5yypaigkhhw','2023-05-15 08:25:18.591250','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Hand-off to customer success','{}',1684139118588,1684139118588,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('axzud9xrewbbwtx3wcehhnzadsw','2023-05-15 08:25:18.122781','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Schedule initial sales call','{\"value\":true}',1684139118120,1684139118120,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ay565qgiejjfc8p8qq51b7sfqqe','2023-05-15 08:25:18.506883','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Send proposal','{}',1684139118504,1684139118504,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ay5s6swk76ingpee3uzru1yenoh','2023-05-15 08:25:15.927023','cbr1qix816jfyfkm5fcfen13a9e',1,'checkbox','','{\"value\":false}',1684139115925,1684139115925,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('ay6cwwn63r3bbjke8yyxao5ktga','2023-05-15 08:25:24.577288','czw9es1e89fdpjr7cqptr1xq7qh',1,'checkbox','[Subtask 2]','{\"value\":false}',1684139124574,1684139124574,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ayqepp51fh3d8prg75ockmnfz3e','2023-05-15 08:25:23.803612','cwjh3qjukx38gipog474tobdb3w',1,'checkbox','...','{\"value\":false}',1684139123802,1684139123802,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ayxdnttb5efdifdgs5bc5ttus5o','2023-05-15 08:25:18.058452','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Send initial email','{\"value\":true}',1684139118055,1684139118055,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('az6qkbrr6uidq38o69kenspe9dw','2023-05-15 08:25:18.201420','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Post-sales follow up','{}',1684139118198,1684139118198,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('azeaxw8hwyfrhbfj1swo7uhfmfr','2023-05-15 08:25:15.921112','cbr1qix816jfyfkm5fcfen13a9e',1,'checkbox','','{\"value\":false}',1684139115919,1684139115919,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('azkowzqsoi3nuzysfn67jownt8o','2023-05-15 08:25:44.408744','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Follow cards to get notified on the latest updates','{\"value\":false}',1684139144406,1684139144406,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('azptr4acc6jgt9pbach7gb5837e','2023-05-15 08:25:17.938578','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Hand-off to customer success','{}',1684139117935,1684139117935,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aztpyqdf41tb9z8xzmnfbxak1sh','2023-05-15 08:25:36.498681','cne7na65esjff3bhwjdrd1pea4h',1,'text','## Summary\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.\n## Strengths\n- ...\n- ...\n\n## Weaknesses\n- ...\n- ...\n\n## Opportunities\n- ...\n- ...\n\n## Threats\n- ...\n- ...','{}',1684139136495,1684139136495,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('azwnrkknjp7yspg8ni86okthuuy','2023-05-15 08:25:44.451953','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','@mention teammates so they can follow, and collaborate on, comments and descriptions','{\"value\":false}',1684139144449,1684139144449,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('c18ku7bj113nrbrhc48ugk1fx6y','2023-05-15 08:25:28.221604','bd65qbzuqupfztpg31dgwgwm5ga',1,'card','Learn to paint','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"af6fcbb8-ca56-4b73-83eb-37437b9a667d\":\"77c539af-309c-4db1-8329-d20ef7e9eacd\",\"d6b1249b-bc18-45fc-889e-bec48fce80ef\":\"9a090e33-b110-4268-8909-132c5002c90e\",\"d9725d14-d5a8-48e5-8de1-6f8c004a9680\":\"3245a32d-f688-463b-87f4-8e7142c1b397\"}}',1684139128217,1684139128217,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('c1axsmo6e5i8tf8xun3qyk57ytr','2023-05-15 08:25:29.304043','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','User Story','{\"contentOrder\":[\"a1dbxk43ombn4fm1ew8x1qhku3r\"],\"icon\":\"?\",\"isTemplate\":true,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"apht1nt5ryukdmxkh6fkfn6rgoy\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\"}}',1684139129301,1684139129301,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('c1skdp9t1mtnjbxcmoshjj94x8a','2023-05-15 08:25:43.126037','buixxjic3xjfkieees4iafdrznc',1,'card','Manage tasks with cards','{\"contentOrder\":[\"ansjzguztbiffmmesd9nfrmjz7h\",\"a676u5r9tbpnsumpr67ea3zo6qw\",\"adb14fy97ktr79grpj9dzd3pomh\",\"784uu3ufcgb878ky7hyugmf6xcw\",\"awius1nogcbre3fk3rgqgt95hio\",\"arxyp6pddc7dgxqwjsk75ion5ea\",\"autj3nzqztpbxtqo6iadg3f3psw\",\"7nb8y7jyoetro8cd36qcju53z8c\",\"azkowzqsoi3nuzysfn67jownt8o\",\"azwnrkknjp7yspg8ni86okthuuy\",\"76nwb9tqfsid5jx46yw34itqima\",\"7dy3mcgzgybf1ifa3emgewkzj7e\",\"a5ca6tii33bfw8ba36y1rswq3he\",\"7876od6xhffr6fy69zeogag7eyw\",\"7x7bq9awkatbm5x4docbh5gaw4y\",\"7ghpx9qff43dgtke1rwidmge1ho\",\"7nb8y7jyoetro8cd36qcju53z8c\",\"7hdyxemhbytfm3m83g88djq9nhr\",\"7pgnejxokubbe9kdrxj6g9qa41e\",\"7hw9z6qtx8jyizkmm9g5yq3gxcy\",\"7gk6ooz6npbb8by5rgp9aig7tua\",\"aqqp3dac3wirhpptohuqz83gkqy\"],\"icon\":\"☑️\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/work-with-cards.html\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"amm6wfhnbuxojwssyftgs9dipqe\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aanaehcw3m13jytujsjk5hpf6ry\"}}',1684139143123,1684139143123,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('c31rnabwmciy49reqdtf658scxa','2023-05-15 08:25:40.611921','bsjd59qtpbf888mqez3ge77domw',1,'card','Reschedule planning meeting','{\"contentOrder\":[],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"adjckpdotpgkz7c6wixzw9ipb1e\":\"aok6pgecm85qe9k5kcphzoe63ma\"}}',1684139140608,1684139140608,0,NULL,'system','','system','b7n3rwgpsspbg9drkn8ztit7yxw'),('c3e1n8jh85iy8pgqzz8xcdpejoc','2023-05-15 08:25:23.708492','bc41mwxg9ybb69pn9j5zna6d36c',1,'card','Project budget approval','{\"contentOrder\":[\"aoy8dg4jgbfdp8pdm9ga1uk3rrw\",\"aoxteiun1cj85ppwpw935htrify\",\"aoi7yahtppir47cuch69s1mbrde\",\"ad4jkwdrk8tygixputknzh3tm9e\",\"ab7k61ow3str93y8yt4xzt6fx1h\",\"a74eggha9pigfmcqrt5hq8fo6ny\",\"athngtrguzfd9jbstjo1iq837hc\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a8daz81s4xjgke1ww6cwik5w7ye\":\"16\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ayz81h9f3dwp7rzzbdebesc7ute\",\"d3d682bf-e074-49d9-8df5-7320921c2d23\":\"d3bfb50f-f569-4bad-8a3a-dd15c3f60101\"}}',1684139123707,1684139123707,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('c3zpru7o6ibfxup6ej47xu8mc4a','2023-05-15 08:25:41.390157','bui5izho7dtn77xg3thkiqprc9r',1,'card','Review API design','{\"contentOrder\":[\"aupozsqimzprfpkym5m1dsw17ze\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"424ea5e3-9aa1-4075-8c5c-01b44b66e634\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"8c557f69-b0ed-46ec-83a3-8efab9d47ef5\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"14892380-1a32-42dd-8034-a0cea32bc7e6\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"https://mattermost.com/boards/\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"c62172ea-5da7-4dec-8186-37267d8ee9a7\"}}',1684139141386,1684139141386,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('c485y8w5cnfy47mpyp4mmgbe39r','2023-05-15 08:25:34.438731','bh4pkixqsjift58e1qy6htrgeay',1,'card','Bernadette Powell','{\"contentOrder\":[\"a1fj9z7tsejrbux6tbscguca59r\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"aaebj5fyx493eezx6ukxiwydgty\":\"af6hjb3ysuaxbwnfqpby4wwnkdr\",\"acjq4t5ymytu8x1f68wkggm7ypc\":\"bernadette.powell@email.com\"}}',1684139134437,1684139134437,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('c48fsy6msutb6i8pcnd7axut6kr','2023-05-15 08:25:21.483674','bbn1888mprfrm5fjw9f1je9x3xo',1,'card','Go for a walk','{\"contentOrder\":[\"ahpm1u53gepnn5c5mnkp68radgh\",\"a49urkhwkbtr18qeqq8k7kfncho\",\"iye416ctq8irqmb8oqww6fw96bo\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a9zf59u8x1rf4ywctpcqama7tio\":\"an51dnkenmoog9cetapbc4uyt3y\"}}',1684139121480,1684139121480,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('c4htpxn8wxpd6pffpjo4u8xxxxc','2023-05-15 08:25:36.369782','bkqk6hpfx7pbsucue7jan5n1o1o',1,'card','Liminary Corp.','{\"contentOrder\":[\"agjiprrojcjyg9x9q7kxe8n8eyr\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a1semdhszu1rq17d7et5ydrqqio\":\"abt79uxg5edqojsrrefcnr4eruo\",\"a6cwaq79b1pdpb97wkanmeyy4er\":\"300\",\"ahzspe59iux8wigra8bg6cg18nc\":\"liminarycorp.com\",\"aiefo7nh9jwisn8b4cgakowithy\":\"$25,000,000\",\"an1eerzscfxn6awdfajbg41uz3h\":\"2017\",\"aozntq4go4nkab688j1s7stqtfc\":\"Toronto, Canada\"}}',1684139136366,1684139136366,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('c4qc8gzhjipf6mmbat9du8ye9kr','2023-05-15 08:25:41.375517','bui5izho7dtn77xg3thkiqprc9r',1,'card','Import / Export','{\"contentOrder\":[\"amho5gxfybbrt5n3ko48x5d8pny\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"6eea96c9-4c61-4968-8554-4b7537e8f748\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"ec6d2bc5-df2b-4f77-8479-e59ceb039946\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"c01676ca-babf-4534-8be5-cce2287daa6c\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"https://mattermost.com/boards/\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139141372,1684139141372,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('c5jaxbc9m6jn3dxcfhro94u1hpr','2023-05-15 08:25:17.598217','bbkpwdj8x17bdpdqd176n8ctoua',1,'card','Jonathan Frazier','{\"contentOrder\":[\"afst5iycoy3rhixsdjihf3peoey\",\"a9k51ioai67fmjnqsmjwezs1fbe\",\"aqfzsxtdkjf8fxn68you4bs5tmw\",\"aphzuak83niydzqmomg8kerrjzo\",\"ainarjkocuiduxrbb63t9xoyper\",\"aweccxa5qzbd8ukzpe9d66a6kgy\",\"arwrz93jeotggxrnn7ryte44wrw\",\"aqpusoh9o8bndupb7m9sbpqcbmr\",\"a5w8x3eswhiyojrmstdzo593nhr\",\"ajofqzk5biighxbxuu5hrz9hqrr\",\"aaigoezzch3fy9knkd3gdjczqzw\",\"aufn3gqypspr89n15aspuo637ir\"],\"icon\":\"?‍♂️\",\"isTemplate\":false,\"properties\":{\"a1438fbbhjeffkexmcfhnx99o1h\":\"(999) 123-5678\",\"a5hwxjsmkn6bak6r7uea5bx1kwc\":\"a5txuiubumsmrs8gsd5jz5gc1oa\",\"abru6tz8uebdxy4skheqidh7zxy\":\"jonathan.frazier@email.com\",\"aejo5tcmq54bauuueem9wc4fw4y\":\"0%\",\"ahf43e44h3y8ftanqgzno9z7q7w\":\"$800,000\",\"ainpw47babwkpyj77ic4b9zq9xr\":\"Ositions Inc.\",\"amahgyn9n4twaapg3jyxb6y4jic\":\"as5bk6afoaaa7caewe1zc391sce\",\"aro91wme9kfaie5ceu9qasmtcnw\":\"apiswzj7uiwbh87z8dw8c6mturw\",\"auhf91pm85f73swwidi4wid8jqe\":\"{\\\"from\\\":1669118400000}\"}}',1684139117595,1684139117595,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('c5m8zt49qq7nbbfced77hzy9imh','2023-05-15 08:25:25.759285','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Increase user signups by 30%','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"a6robxx81diugpjq5jkezz3j1fo\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"ao9b5pxyt7tkgdohzh9oaustdhr\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"as555ipyzopjjpfb5rjtssecw5e\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"0%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"1,000\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"acb6dqqs6yson7bbzx6jk9bghjh\",\"azqnyswk6s1boiwuthscm78qwuo\":\"0\",\"azzbawji5bksj69sekcs4srm1ky\":\"afkxpcjqjypu7hhar7banxau91h\"}}',1684139125746,1684139125746,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('c61etzptwef8ydchn9hofc587cw','2023-05-15 08:25:40.582789','bsjd59qtpbf888mqez3ge77domw',1,'card','Tight deadline','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"adjckpdotpgkz7c6wixzw9ipb1e\":\"ar87yh5xmsswqkxmjq1ipfftfpc\"}}',1684139140579,1684139140579,0,NULL,'system','','system','b7n3rwgpsspbg9drkn8ztit7yxw'),('c6qdmkccxdjyhtk3b6iax55twgr','2023-05-15 08:25:28.204049','bd65qbzuqupfztpg31dgwgwm5ga',1,'card','Run 3 times a week','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"af6fcbb8-ca56-4b73-83eb-37437b9a667d\":\"bf52bfe6-ac4c-4948-821f-83eaa1c7b04a\",\"d6b1249b-bc18-45fc-889e-bec48fce80ef\":\"6e7139e4-5358-46bb-8c01-7b029a57b80a\",\"d9725d14-d5a8-48e5-8de1-6f8c004a9680\":\"ffb3f951-b47f-413b-8f1d-238666728008\"}}',1684139128198,1684139128198,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('c6sc3f5fjmf8cbcqchzku19mg9a','2023-05-15 08:25:41.358509','bui5izho7dtn77xg3thkiqprc9r',1,'card','Standard templates','{\"contentOrder\":[\"7uonmjk41nipnrsi6tz8wau5ssh\",\"as71mueofj78efrn5y758abxbeo\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"6eea96c9-4c61-4968-8554-4b7537e8f748\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"ec6d2bc5-df2b-4f77-8479-e59ceb039946\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"ed4a5340-460d-461b-8838-2c56e8ee59fe\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"https://mattermost.com/boards/\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139141354,1684139141354,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('c7ho5n7y4t7fyimowcpjxuumtea','2023-05-15 08:25:17.666662','bbkpwdj8x17bdpdqd176n8ctoua',1,'card','New Prospect','{\"contentOrder\":[\"aixwwtex9ofbo58tws4p8kzzzhh\",\"acjb5kah4xp835qecaxb6n7nfah\",\"aosqp85sp5pbkzfhqkc9f9kx9br\",\"aqtr5wbetofb6dfbfqh4k6dmqke\",\"ahd73ykmw6pd9bqqwsppk6wx9ty\",\"an1ni5jxrkibi3f4pe1wis5kdha\",\"ah8yjnketf7rcxyegsef1gmkjow\",\"aoem1zdrjnid3ineo4tene5xo4o\",\"ay565qgiejjfc8p8qq51b7sfqqe\",\"ak7rktdxk4tbtuxuitq5p37ficr\",\"axznpefqo3jg95ni5yypaigkhhw\",\"afbqaohnf8fdi7k43xo86jcri1a\"],\"icon\":\"?\",\"isTemplate\":true,\"properties\":{\"a5hwxjsmkn6bak6r7uea5bx1kwc\":\"akj61wc9yxdwyw3t6m8igyf9d5o\"}}',1684139117663,1684139117663,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('c87rtonnkmpd6umzmppctjhdrgc','2023-05-15 08:25:34.426657','bh4pkixqsjift58e1qy6htrgeay',1,'card','Claire Hart','{\"contentOrder\":[\"awe76d1gxifg9dcc73rakdnaz1y\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"aaebj5fyx493eezx6ukxiwydgty\":\"aseqq9hrsua56r3s6nbuirj9eec\",\"acjq4t5ymytu8x1f68wkggm7ypc\":\"claire.hart@email.com\",\"aify3r761b9w43bqjtskrzi68tr\":\"Password123\",\"akrxgi7p7w14fym3gbynb98t9fh\":\"{\\\"from\\\":1670500800000}\",\"aqafzdeekpyncwz7m7i54q3iqqy\":\"https://user-images.githubusercontent.com/46905241/121941290-ee355280-cd03-11eb-9b9f-f6f524e4103e.gif\",\"atg9qu6oe4bjm8jczzsn71ff5me\":\"ahn89mqg9u4igk6pdm7333t8i5h\"}}',1684139134425,1684139134425,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('c8kkpb6wh7igg7nw88x8nfnwf4c','2023-05-15 08:25:29.429849','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Global templates','{\"contentOrder\":[\"atafa47uz7byruq66jaxwpefigh\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"a5yxq8rbubrpnoommfwqmty138h\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"a6ghze4iy441qhsh3eijnc8hwze\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"c01676ca-babf-4534-8be5-cce2287daa6c\",\"a1g6i613dpe9oryeo71ex3c86hy\":\"https://mattermost.com/boards/\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"2\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139129427,1684139129427,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('c8n4xu7ntq7bbbd14noats457ro','2023-05-15 08:25:38.073256','brs9cdimfw7fodyi7erqt747rhc',1,'card','Top 10 Must-Have DevOps Tools in 2021','{\"contentOrder\":[\"7fo1utqc8x1z1z6hzg33hes1ktc\",\"aeuc3ii3akir43j81makf3hxuay\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"a39x5cybshwrbjpc3juaakcyj6e\":\"{\\\"from\\\":1636113600000}\",\"ab6mbock6styfe6htf815ph1mhw\":[\"a8xceonxiu4n3c43szhskqizicr\"],\"ae9ar615xoknd8hw8py7mbyr7zo\":\"a9ana1e9w673o5cp8md4xjjwfto\",\"agqsoiipowmnu9rdwxm57zrehtr\":\"{\\\"from\\\":1637323200000}\",\"ap4e7kdg7eip7j3c3oyiz39eaoc\":\"https://www.toolbox.com/tech/devops/articles/best-devops-tools/\",\"aysx3atqexotgwp5kx6h5i5ancw\":\"a3xky7ygn14osr1mokerbfah5cy\"}}',1684139138070,1684139138070,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('c8ra694tq4bfm5czq11g6wnq3re','2023-05-15 08:25:34.432127','bh4pkixqsjift58e1qy6htrgeay',1,'card','Olivia Alsop','{\"contentOrder\":[\"ahcc7baon8irodktqpfj1db4mdw\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"aaebj5fyx493eezx6ukxiwydgty\":\"a7yq89whddzob1futao4rxk3yzc\",\"acjq4t5ymytu8x1f68wkggm7ypc\":\"olivia.alsop@email.com\",\"aify3r761b9w43bqjtskrzi68tr\":\"Password123\",\"akrxgi7p7w14fym3gbynb98t9fh\":\"{\\\"from\\\":1671192000000}\",\"aqafzdeekpyncwz7m7i54q3iqqy\":\"https://user-images.githubusercontent.com/46905241/121941290-ee355280-cd03-11eb-9b9f-f6f524e4103e.gif\",\"atg9qu6oe4bjm8jczzsn71ff5me\":\"a1sxagjgaadym5yrjak6tcup1oa\"}}',1684139134430,1684139134430,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('c8tf9wun9gtyc7bzize8f513eqc','2023-05-15 08:25:17.642046','bbkpwdj8x17bdpdqd176n8ctoua',1,'card','Caitlyn Russel','{\"contentOrder\":[\"age6hf4ppq3gy7y8y44mhrdsifr\",\"anxrc977em3gcbj6tuuz3pjse4w\",\"as4xgtsyfpbn69k9b5t347dwbde\",\"awtn5z6btdfy39foagfpnepokya\",\"a5owboss9ytnwzqsg838ax9c7sa\",\"agbstqsrjejd6iemscpeixjpj8o\",\"au98tgq5nctdj9djkoih4n9tf5e\",\"awgph3xm5finx7ki7nit8t6iuuh\",\"atzms9yotn3f87k3sy6c6zecx6e\",\"adyads1uwsj8qfeq5mfh4jaz18a\",\"anuotdyg8ajfo7guetz5npmznqy\",\"az6qkbrr6uidq38o69kenspe9dw\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"a1438fbbhjeffkexmcfhnx99o1h\":\"(111) 123-1234\",\"a5hwxjsmkn6bak6r7uea5bx1kwc\":\"ah6ehh43rwj88jy4awensin8pcw\",\"abru6tz8uebdxy4skheqidh7zxy\":\"caitlyn.russel@email.com\",\"adtf1151chornmihz4xbgbk9exa\":\"{\\\"from\\\":1689336000000}\",\"aejo5tcmq54bauuueem9wc4fw4y\":\"20%\",\"ahf43e44h3y8ftanqgzno9z7q7w\":\"$250,000\",\"ainpw47babwkpyj77ic4b9zq9xr\":\"Liminary Corp.\",\"amahgyn9n4twaapg3jyxb6y4jic\":\"aafwyza5iwdcwcyfyj6bp7emufw\",\"aro91wme9kfaie5ceu9qasmtcnw\":\"apiswzj7uiwbh87z8dw8c6mturw\",\"auhf91pm85f73swwidi4wid8jqe\":\"{\\\"from\\\":1668168000000}\"}}',1684139117639,1684139117638,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('c8x3s1st6ijfzuxhrf5aaei76my','2023-05-15 08:25:43.142614','buixxjic3xjfkieees4iafdrznc',1,'card','Create your own board','{\"contentOrder\":[\"a873fa3hbs3ytumfax4m65fwzgc\",\"ax41nr5o9j7r6bnoukbcxxpkf5y\",\"7r9my1yuddbn45dojrfht3neg8c\",\"7eir5gdjxgjbsxpbyp3df4npcze\",\"iiz5ur5j5gt8c3ygq7z5kasubwa\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/working-with-boards.html#adding-new-boards\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"amm6wfhnbuxojwssyftgs9dipqe\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aanaehcw3m13jytujsjk5hpf6ry\"}}',1684139143139,1684139143139,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('c8xeju51trbg38x6xq6spazwsnc','2023-05-15 08:25:43.195095','buixxjic3xjfkieees4iafdrznc',1,'card','Filter and sort cards','{\"contentOrder\":[\"a4fz9kcfs9ibj8puk9mux7ac94c\",\"ac8chzuh3bbrj78copndmi6p38r\",\"78i8aqjmqtibr7x4okhz6uqquqr\",\"iupwtx8hqgfn19dxkfj56h48rwo\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ajurey3xkocs1nwx8di5zx6oe7o\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aq6ukoiciyfctgwyhwzpfss8ghe\"}}',1684139143192,1684139143192,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('c8z9b6w6757nojkqi5k4kc1eggy','2023-05-15 08:25:29.394720','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Standard properties','{\"contentOrder\":[\"ad1zwi9jox7dk5njpgjd46briih\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"a5yxq8rbubrpnoommfwqmty138h\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"14892380-1a32-42dd-8034-a0cea32bc7e6\",\"a1g6i613dpe9oryeo71ex3c86hy\":\"https://mattermost.com/boards/\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"3\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139129390,1684139129390,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('c98nnstjzhbgmpj6g88rgpgnheh','2023-05-15 08:25:36.444173','bkqk6hpfx7pbsucue7jan5n1o1o',1,'card','Afformance Ltd.','{\"contentOrder\":[\"aqenhkcet77f1tmexfzbdqu1auo\"],\"icon\":\"⚡\",\"isTemplate\":false,\"properties\":{\"a1semdhszu1rq17d7et5ydrqqio\":\"arfjpz9by5car71tz3behba8yih\",\"a6cwaq79b1pdpb97wkanmeyy4er\":\"1,800\",\"ahzspe59iux8wigra8bg6cg18nc\":\"afformanceltd.com\",\"aiefo7nh9jwisn8b4cgakowithy\":\"$200,000,000\",\"an1eerzscfxn6awdfajbg41uz3h\":\"2002\",\"aozntq4go4nkab688j1s7stqtfc\":\"Palo Alto, CA\"}}',1684139136441,1684139136441,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('c9iwbjcg8w38ip8m9xizycdmesc','2023-05-15 08:25:29.363827','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Cross-team collaboration','{\"contentOrder\":[\"a5ooaofewzinbfn4bczt4ykp3we\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"424ea5e3-9aa1-4075-8c5c-01b44b66e634\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"14892380-1a32-42dd-8034-a0cea32bc7e6\",\"a1g6i613dpe9oryeo71ex3c86hy\":\"https://mattermost.com/boards/\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"3\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"c62172ea-5da7-4dec-8186-37267d8ee9a7\"}}',1684139129361,1684139129361,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('cb89odozjd788py34ggamhsyo1h','2023-05-15 08:25:38.026506','brs9cdimfw7fodyi7erqt747rhc',1,'card','New Project and Workflow Management Solutions for Developers','{\"contentOrder\":[\"71qhnzuec6esdi6fnynwpze4xya\",\"aerxw6a5f6tbq5cfuo97h1dcp1w\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a39x5cybshwrbjpc3juaakcyj6e\":\"{\\\"from\\\":1645790400000}\",\"ab6mbock6styfe6htf815ph1mhw\":[\"a8xceonxiu4n3c43szhskqizicr\",\"a3pdzi53kpbd4okzdkz6khi87zo\",\"a3d9ux4fmi3anyd11kyipfbhwde\"],\"ae9ar615xoknd8hw8py7mbyr7zo\":\"awna1nuarjca99m9s4uiy9kwj5h\",\"ap4e7kdg7eip7j3c3oyiz39eaoc\":\"https://mattermost.com/newsroom/press-releases/mattermost-launches-new-project-and-workflow-management-solutions-for-developers/\",\"aysx3atqexotgwp5kx6h5i5ancw\":\"aywiofmmtd3ofgzj95ysky4pjga\"}}',1684139138021,1684139138021,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('cbm9y3gmqqjd6uewottgm8mocwh','2023-05-15 08:25:41.426922','bui5izho7dtn77xg3thkiqprc9r',1,'card','Icons don\'t display','{\"contentOrder\":[\"akqw19ofqotr78g78jobfykj3ia\",\"awmkaa8ojq3bn5cj75ysw3ahjaa\",\"i6etc7e7omjymxbztaoqp3cpyta\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"1fdbb515-edd2-4af5-80fc-437ed2211a49\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"8c557f69-b0ed-46ec-83a3-8efab9d47ef5\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"ed4a5340-460d-461b-8838-2c56e8ee59fe\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"https://mattermost.com/boards/\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139141424,1684139141424,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('cbokq5iftypbs3gspcn15kp1u4r','2023-05-15 08:25:43.168996','buixxjic3xjfkieees4iafdrznc',1,'card','Create a new card','{\"contentOrder\":[\"axehsiymm93rrpeaumbiuwmkyow\",\"adhsx4h5ss7rqdcjt8xyam6xtqc\",\"ag34x3ougupbrfd5ypsbrqueb5e\",\"7me9p46gbqiyfmfnapi7dyxb5br\",\"irib7x5bb9t8ztxmy68up9dfjaa\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/working-with-boards.html#adding-cards\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"amm6wfhnbuxojwssyftgs9dipqe\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aanaehcw3m13jytujsjk5hpf6ry\"}}',1684139143166,1684139143166,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('cbr1qix816jfyfkm5fcfen13a9e','2023-05-15 08:25:15.724005','b7wnw9awd4pnefryhq51apbzb4c',1,'card','Offsite plans','{\"contentOrder\":[\"amiis7xbrqtf6dc8ww13heeg6aw\",\"au6tkhdp3s3fumc4f5yzp6achgc\",\"apo1h5w4debdjmr9usxauqtqwby\",\"azeaxw8hwyfrhbfj1swo7uhfmfr\",\"ay5s6swk76ingpee3uzru1yenoh\",\"a1ewhbrp883bpbjrc89n35buyjh\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"4cf1568d-530f-4028-8ffd-bdc65249187e\":\"8b05c83e-a44a-4d04-831e-97f01d8e2003\",\"d777ba3b-8728-40d1-87a6-59406bbbbfb0\":\"dabadd9b-adf1-4d9f-8702-805ac6cef602\"}}',1684139115720,1684139115720,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('ccfkf8w5ntpfx7d7afp8upt6jca','2023-05-15 08:25:33.270010','bh4pkixqsjift58e1qy6htrgeay',1,'card','Frank Nash','{\"contentOrder\":[\"au6nr9h1zp3nr78m6ei3sdp8ctw\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"aaebj5fyx493eezx6ukxiwydgty\":\"ap93ysuzy1xa7z818r6myrn4h4y\",\"acjq4t5ymytu8x1f68wkggm7ypc\":\"frank.nash@email.com\",\"aify3r761b9w43bqjtskrzi68tr\":\"Password123\",\"akrxgi7p7w14fym3gbynb98t9fh\":\"{\\\"from\\\":1669896000000}\",\"aqafzdeekpyncwz7m7i54q3iqqy\":\"https://user-images.githubusercontent.com/46905241/121941290-ee355280-cd03-11eb-9b9f-f6f524e4103e.gif\",\"atg9qu6oe4bjm8jczzsn71ff5me\":\"aehc83ffays3gh8myz16a8j7k4e\"}}',1684139133267,1684139133267,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('cczudbnf113g1fezgjcbj8wqd9h','2023-05-15 08:25:29.443726','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Feature','{\"contentOrder\":[\"amf64og7po7dnxdir6idmyk1qnw\"],\"icon\":\"?️\",\"isTemplate\":true,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"a5yxq8rbubrpnoommfwqmty138h\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\"}}',1684139129440,1684139129440,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('cdykszx7gffnibcgf4p9gzdit9a','2023-05-15 08:25:17.627119','bbkpwdj8x17bdpdqd176n8ctoua',1,'card','Byron Cole','{\"contentOrder\":[\"a3xqbjspfy3bmpek81gk3jcqd9r\",\"apjxwm8wbai8puqi5hsyu16ex4a\",\"ayxdnttb5efdifdgs5bc5ttus5o\",\"aj3idc59csjbhupc81cr5drn1eh\",\"axzud9xrewbbwtx3wcehhnzadsw\",\"agh8493dxoff6ucoi993ym6o1cw\",\"ao9bnrjmwfb8o8mb4maqr4hjpne\",\"auyfk6pje3fyetngebek4jqxu1h\",\"an935fht14fr8mpjo99fuwaw4zo\",\"a44hj6n51d3bdzfkkbczsgrmhpw\",\"atuegurdywfr9mm93u779ywkdia\",\"a14yt5umqginsdnp67tq5ztugkw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a1438fbbhjeffkexmcfhnx99o1h\":\"(333) 123-1234\",\"a5hwxjsmkn6bak6r7uea5bx1kwc\":\"acm9q494bcthyoqzmfogxxy5czy\",\"abru6tz8uebdxy4skheqidh7zxy\":\"byron.cole@email.com\",\"adtf1151chornmihz4xbgbk9exa\":\"{\\\"from\\\":1667563200000}\",\"aejo5tcmq54bauuueem9wc4fw4y\":\"100%\",\"ahf43e44h3y8ftanqgzno9z7q7w\":\"$500,000\",\"ainpw47babwkpyj77ic4b9zq9xr\":\"Helx Industries\",\"amahgyn9n4twaapg3jyxb6y4jic\":\"aafwyza5iwdcwcyfyj6bp7emufw\",\"aro91wme9kfaie5ceu9qasmtcnw\":\"apjnaggwixchfxwiatfh7ey7uno\",\"auhf91pm85f73swwidi4wid8jqe\":\"{\\\"from\\\":1667822400000}\"}}',1684139117622,1684139117622,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('cec73iz548tyzfeagiummkqyh6c','2023-05-15 08:25:29.377769','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Bug','{\"contentOrder\":[\"ausmstaiqf7ghiducjna77chfra\",\"ajguuc7nfctfptbaq8k1cnz7smc\",\"i6kfk1wdofpfxjxmwtq8mpg1ohy\"],\"icon\":\"?\",\"isTemplate\":true,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"aomnawq4551cbbzha9gxnmb3z5w\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\"}}',1684139129374,1684139129374,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('cffwedhcphjnxdnx7gi5ef487mc','2023-05-15 08:25:41.340715','bui5izho7dtn77xg3thkiqprc9r',1,'card','Calendar view','{\"contentOrder\":[\"7df11783ny67mdnognqae31ax6y\",\"ag351ba8q87rjzy868zsaoxu36y\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"6eea96c9-4c61-4968-8554-4b7537e8f748\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"849766ba-56a5-48d1-886f-21672f415395\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"c01676ca-babf-4534-8be5-cce2287daa6c\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"https://mattermost.com/boards/\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139141332,1684139141332,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('cgd4a4ph353d48ct6ybq17fhanc','2023-05-15 08:25:25.814468','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Reduce bug backlog by 50%','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"abzfwnn6rmtfzyq5hg8uqmpsncy\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"apqfjst8massbjjhpcsjs3y1yqa\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"a1ts3ftyr8nocsicui98c89uxjy\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"100%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"75\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"awfu37js3fomfkkczm1zppac57a\",\"azqnyswk6s1boiwuthscm78qwuo\":\"75\",\"azzbawji5bksj69sekcs4srm1ky\":\"aw5i7hmpadn6mbwbz955ubarhme\"}}',1684139125809,1684139125809,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('cgf85qmqr7fnyxcfqqw8nf8mn4h','2023-05-15 08:25:23.695738','bc41mwxg9ybb69pn9j5zna6d36c',1,'card','Identify dependencies','{\"contentOrder\":[\"a4oacqw9rgtbo5ri9wzijhz1wdw\",\"amw9356bg67rr881axj93ca7boo\",\"awu8m855ws7gitfcbakbyq5pe9w\",\"ank4fqmyfotyi9x18g5x1h83d3h\",\"aiw8kpb5u1tnmxqkq6p5tpybdqc\",\"a1wp1k1zieighmg39wyjjygcxre\",\"aupi3t9ib3jy65qwzme7i4ky8ar\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a8daz81s4xjgke1ww6cwik5w7ye\":\"16\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ayz81h9f3dwp7rzzbdebesc7ute\",\"d3d682bf-e074-49d9-8df5-7320921c2d23\":\"98a57627-0f76-471d-850d-91f3ed9fd213\"}}',1684139123694,1684139123694,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ci6nx4shmpffitmrx951e4oiptw','2023-05-15 08:25:21.456141','bbn1888mprfrm5fjw9f1je9x3xo',1,'card','Pay bills','{\"contentOrder\":[\"a4zjojnhsrbfkzbf5ukno7g6yey\",\"a9jwwi6qx1j85zpkkr9nfkkkxda\",\"ahf6q3fi9xtykfjcmx4sibf67cw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a9zf59u8x1rf4ywctpcqama7tio\":\"aj4jyekqqssatjcq7r7chmy19ey\",\"abthng7baedhhtrwsdodeuincqy\":\"true\"}}',1684139121453,1684139121452,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('cipuiirpksj84xjb69fzyjorysr','2023-05-15 08:25:29.335591','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Login screen not loading','{\"contentOrder\":[\"a9xctw6b81bgrfju1a5hwcq36ra\",\"aa6m58nop8jd5pg94uzgbtkr9dw\",\"iezeao1oxcjb4jxfb7hs9xhrhur\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"aomnawq4551cbbzha9gxnmb3z5w\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"abrfos7e7eczk9rqw6y5abadm1y\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"c01676ca-babf-4534-8be5-cce2287daa6c\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"1\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"cb8ecdac-38be-4d36-8712-c4d58cc8a8e9\"}}',1684139129332,1684139129332,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ciynnywbiz7rujm5aiphkq3hpmo','2023-05-15 08:25:38.087082','brs9cdimfw7fodyi7erqt747rhc',1,'card','Unblocking Workflows: The Guide to Developer Productivity','{\"contentOrder\":[\"77tz16jtz5x73ncs3dxc3fp1d7h\",\"a1kiesdgeutgzdyw1ez1ypqzbpe\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a39x5cybshwrbjpc3juaakcyj6e\":\"{\\\"from\\\":1638532800000}\",\"ab6mbock6styfe6htf815ph1mhw\":[\"a3pdzi53kpbd4okzdkz6khi87zo\"],\"ae9ar615xoknd8hw8py7mbyr7zo\":\"apy9dcd7zmand615p3h53zjqxjh\",\"agqsoiipowmnu9rdwxm57zrehtr\":\"{\\\"from\\\":1639483200000}\",\"ap4e7kdg7eip7j3c3oyiz39eaoc\":\"https://mattermost.com/newsroom/press-releases/mattermost-unveils-definitive-report-on-the-state-of-developer-productivity-unblocking-workflows-the-guide-to-developer-productivity-2022-edition/\",\"aysx3atqexotgwp5kx6h5i5ancw\":\"a3xky7ygn14osr1mokerbfah5cy\"}}',1684139138084,1684139138084,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('cizmdp6qkrjf9uqixnsu6ea4o8o','2023-05-15 08:25:17.682740','bbkpwdj8x17bdpdqd176n8ctoua',1,'card','Shelby Olson','{\"contentOrder\":[\"a179zkj8ngfbd3k38nkwxpg9wmh\",\"ahact8zrmctbnzknxe9udhawjfe\",\"ageiia35pfjrsfcdyn6fbxbtt4r\",\"axedjwpq1y7ru3c3fne9tuhbiae\",\"a9bqmd5hph3bkpgc1bu6j95btqa\",\"ajg45nyrs7jyubdb8ugpjrasctc\",\"aidjkys6sw387xd5d5yxqsr7cqe\",\"an3gwsu6ztjrfixpmhdahaqt63h\",\"a15gffdupj3y4zyxcmhwswreero\",\"anihyopcbefgpueysxaqwg8emwr\",\"acxfipystmbympxztfx5kiqosry\",\"a9yckxr9rbpyqbx8wxjc5c5tkgc\"],\"icon\":\"?‍♀️\",\"isTemplate\":false,\"properties\":{\"a1438fbbhjeffkexmcfhnx99o1h\":\"(111) 321-5678\",\"a5hwxjsmkn6bak6r7uea5bx1kwc\":\"akj61wc9yxdwyw3t6m8igyf9d5o\",\"abru6tz8uebdxy4skheqidh7zxy\":\"shelby.olson@email.com\",\"ahf43e44h3y8ftanqgzno9z7q7w\":\"$30,000\",\"ainpw47babwkpyj77ic4b9zq9xr\":\"Kadera Global\",\"amahgyn9n4twaapg3jyxb6y4jic\":\"ar6t1ttcumgfuqugg5o4g4mzrza\",\"aro91wme9kfaie5ceu9qasmtcnw\":\"auu9bfzqeuruyjwzzqgz7q8apuw\",\"auhf91pm85f73swwidi4wid8jqe\":\"{\\\"from\\\":1669291200000}\"}}',1684139117679,1684139117679,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('cj4fk3wp3rtn1dyeci9basq1w5o','2023-05-15 08:25:36.406845','bkqk6hpfx7pbsucue7jan5n1o1o',1,'card','Kadera Global','{\"contentOrder\":[\"a4d4xc3pcx3fxtj6d66gmgam3nc\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a1semdhszu1rq17d7et5ydrqqio\":\"aipf3qfgjtkheiayjuxrxbpk9wa\",\"a6cwaq79b1pdpb97wkanmeyy4er\":\"150\",\"ahzspe59iux8wigra8bg6cg18nc\":\"kaderaglobal.com\",\"aiefo7nh9jwisn8b4cgakowithy\":\"$12,000,000\",\"an1eerzscfxn6awdfajbg41uz3h\":\"2015\",\"aozntq4go4nkab688j1s7stqtfc\":\"Seattle, OR\"}}',1684139136402,1684139136402,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('cjhmi67r43pnmtq48nw6jmhxm3a','2023-05-15 08:25:25.679422','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Improve customer NPS score','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"a8nukezwwmknqwjsygg7eaxs9te\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"apqfjst8massbjjhpcsjs3y1yqa\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"as555ipyzopjjpfb5rjtssecw5e\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"82%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"8.5\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"anruuoyez51r3yjxuoc8zoqnwaw\",\"azqnyswk6s1boiwuthscm78qwuo\":\"7\",\"azzbawji5bksj69sekcs4srm1ky\":\"agm9p6gcq15ueuzqq3wd4be39wy\"}}',1684139125676,1684139125676,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('cjsgbbn88fbd8pjcue85wa8xzor','2023-05-15 08:25:21.497557','bbn1888mprfrm5fjw9f1je9x3xo',1,'card','Feed Fluffy','{\"contentOrder\":[\"awuo3zo7wgbb9br1t18d7p7p8ew\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a9zf59u8x1rf4ywctpcqama7tio\":\"an51dnkenmoog9cetapbc4uyt3y\"}}',1684139121494,1684139121494,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('cjztn4z4c53dem8kdnkkq6tc8fa','2023-05-15 08:25:41.318147','bui5izho7dtn77xg3thkiqprc9r',1,'card','App crashing','{\"contentOrder\":[\"79t7rkiuspeneqi9xurou9tqzwh\",\"atkub6nqtjtbgmrpf5y6isjrfoo\",\"aeorq3aruibgampujchzws9um7r\",\"ici1jaxg8j7r68g4bzc6757b7da\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"1fdbb515-edd2-4af5-80fc-437ed2211a49\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"ec6d2bc5-df2b-4f77-8479-e59ceb039946\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"c01676ca-babf-4534-8be5-cce2287daa6c\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"cb8ecdac-38be-4d36-8712-c4d58cc8a8e9\"}}',1684139141315,1684139141315,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('ck1c13wxrg3fnpxem5d8cu76s4o','2023-05-15 08:25:38.044308','brs9cdimfw7fodyi7erqt747rhc',1,'card','[Tweet] Mattermost v6.1 includes card @-mention notifications in Boards','{\"contentOrder\":[\"7i96m7nbsdsex8n6hzuzrmdfjuy\",\"7ed5bwp3gr8yax3mhtuwiaa9gjy\",\"a1pu3zj9hpfr1zebdha8j4dp3iw\",\"a19rb5s9qspdy789wpzat34bdjy\",\"abdasiyq4k7ndtfrdadrias8sjy\",\"id7bu3de1qpf77yr764ts4rnaoe\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a39x5cybshwrbjpc3juaakcyj6e\":\"{\\\"from\\\":1639051200000}\",\"ab6mbock6styfe6htf815ph1mhw\":[\"az8o8pfe9hq6s7xaehoqyc3wpyc\"],\"ae9ar615xoknd8hw8py7mbyr7zo\":\"a9ana1e9w673o5cp8md4xjjwfto\",\"agqsoiipowmnu9rdwxm57zrehtr\":\"{\\\"from\\\":1637668800000}\",\"ap4e7kdg7eip7j3c3oyiz39eaoc\":\"https://twitter.com/Mattermost/status/1463145633162969097?s=20\",\"aysx3atqexotgwp5kx6h5i5ancw\":\"aj8y675weso8kpb6eceqbpj4ruw\"}}',1684139138040,1684139138040,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('ckf7h5amk87fftmj33mk5gf78ih','2023-05-15 08:25:15.740714','b7wnw9awd4pnefryhq51apbzb4c',1,'card','Social Media Strategy','{\"contentOrder\":[\"aeqhexi8j9pykich95cew93h6dh\",\"a3of5ugr877yxufkiujjb5gcooa\",\"awq3cxngkbfnt5fkzpfxczdmnaw\",\"ap85qk77cspb33rwkgj1f6t5saa\",\"amxzpzr3pf3y49pjgrraceemn7h\",\"at619ib5a4fn19r34tizcab3etw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"4cf1568d-530f-4028-8ffd-bdc65249187e\":\"b1abafbf-a038-4a19-8b68-56e0fd2319f7\",\"d777ba3b-8728-40d1-87a6-59406bbbbfb0\":\"d37a61f4-f332-4db9-8b2d-5e0a91aa20ed\"}}',1684139115737,1684139115737,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('ckjptgsceu3fq5fmjmn9d7ugpiw','2023-05-15 08:25:43.181727','buixxjic3xjfkieees4iafdrznc',1,'card','Share cards on Channels','{\"contentOrder\":[\"ad3t6abgiytfx3p5cp4tdj7t33a\",\"axggtfboiptri8yt6qgkaef7qua\",\"a6fageyupsfbyfqebz7opgx9sqy\",\"iiw3hpjncf38ftr5coh8b9gfrna\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/work-with-cards.html#share-card-previews\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"af3p8ztcyxgn8wd9z4az7o9tjeh\",\"acypkejeb5yfujhj9te57p9kaxw\":\"ascd7nm9r491ayot8i86g1gmgqw\"}}',1684139143179,1684139143179,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('cm785iog593gu9c8p3k3wx4eejc','2023-05-15 08:25:40.597938','bsjd59qtpbf888mqez3ge77domw',1,'card','Team communication','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"adjckpdotpgkz7c6wixzw9ipb1e\":\"aq1dwbf661yx337hjcd5q3sbxwa\"}}',1684139140595,1684139140595,0,NULL,'system','','system','b7n3rwgpsspbg9drkn8ztit7yxw'),('cncphrte4e7b8zke1wcjoia415w','2023-05-15 08:25:21.470120','bbn1888mprfrm5fjw9f1je9x3xo',1,'card','Buy groceries','{\"contentOrder\":[\"aouftfp6ui3nhz8y3rwwzarnoky\",\"agp4hy9m6hjbkdqtohoeia1yenh\",\"ac4aoo5dcz38gmbd6yrwwzuy94c\",\"a43erpy3dgbg5pr7z8xhogczaqh\",\"acok1kgr63fdhxyc75nx7y1cnpc\",\"a8qa1t9oegpdtxr1w8inab4o19c\",\"ab5zk7prdiiyopkqnb97ntnxqxh\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a9zf59u8x1rf4ywctpcqama7tio\":\"afpy8s7i45frggprmfsqngsocqh\"}}',1684139121467,1684139121467,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('cne7na65esjff3bhwjdrd1pea4h','2023-05-15 08:25:36.422869','bkqk6hpfx7pbsucue7jan5n1o1o',1,'card','Ositions Inc.','{\"contentOrder\":[\"aztpyqdf41tb9z8xzmnfbxak1sh\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a1semdhszu1rq17d7et5ydrqqio\":\"abajmr34b8g1916w495xjb35iko\",\"a6cwaq79b1pdpb97wkanmeyy4er\":\"2,700\",\"ahzspe59iux8wigra8bg6cg18nc\":\"ositionsinc.com\",\"aiefo7nh9jwisn8b4cgakowithy\":\"$125,000,000\",\"an1eerzscfxn6awdfajbg41uz3h\":\"2004\",\"aozntq4go4nkab688j1s7stqtfc\":\"Berlin, Germany\"}}',1684139136419,1684139136419,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('cnxcks11gwirxjdocdzyzrgupkh','2023-05-15 08:25:25.775971','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Add 10 new customers in the EU','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"apnt1f7na9rzgk1rt49keg7xbiy\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"auw3afh3kfhrfgmjr8muiz137jy\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"a1ts3ftyr8nocsicui98c89uxjy\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"30%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"10\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"acb6dqqs6yson7bbzx6jk9bghjh\",\"azqnyswk6s1boiwuthscm78qwuo\":\"3\",\"azzbawji5bksj69sekcs4srm1ky\":\"agrfeaoj7d8p5ianw5iaf3191ae\"}}',1684139125772,1684139125772,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('corc1ng7xtbdqx8po63utq491ro','2023-05-15 08:25:15.686393','b7wnw9awd4pnefryhq51apbzb4c',1,'card','Team Schedule','{\"contentOrder\":[\"asxkajbi1tfrgm8i9d3x84jfmfe\",\"aucfbqzo8sbbepbd37tehj6bgky\",\"ak6e7c8z5k7yr9gzcss76ndkmna\",\"axdnwf9i75byy8pos6dp38zpnmr\",\"a3anidddoojytdns14cexrxbo9c\",\"anoje9s1eqjgrbjierpddcjjych\"],\"icon\":\"⏰\",\"isTemplate\":false,\"properties\":{\"4cf1568d-530f-4028-8ffd-bdc65249187e\":\"8b05c83e-a44a-4d04-831e-97f01d8e2003\",\"d777ba3b-8728-40d1-87a6-59406bbbbfb0\":\"34eb9c25-d5bf-49d9-859e-f74f4e0030e7\"}}',1684139115677,1684139115677,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('cot7fjjb68pgn9xdgr4yy3pwfur','2023-05-15 08:25:29.321265','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Horizontal scroll issue','{\"contentOrder\":[\"aikzfeo3qytg9bym53moh3iwryo\",\"agzumfpbi1bg37gj3d7zkwj8c1o\",\"ispx6nw5owbd5xpafh3mhngwqho\"],\"icon\":\"〰️\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"aomnawq4551cbbzha9gxnmb3z5w\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"ed4a5340-460d-461b-8838-2c56e8ee59fe\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"1\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139129317,1684139129317,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('cow8jauqkabgb8etq9ckdo8nhrh','2023-05-15 08:25:17.611880','bbkpwdj8x17bdpdqd176n8ctoua',1,'card','Richard Guzman','{\"contentOrder\":[\"afgz6ufu6xjbdpjke4gjhxrzbpa\",\"aksausnmc93dtjjzu86yuqeedze\",\"aasewtfi5nigy5feaxy6ps8a53y\",\"ae4ya94cgbj8gjfmahfw5dosu7e\",\"a3njt16yxsff4xgy6a7esb9acza\",\"aof79cphr9jdntgcw74deqwjypc\",\"ax8k51xesh7g3dqri57sbq9zzdo\",\"auagdeuwwup8k8pdn9fs6joijwo\",\"ajgws6yq75tgm3yg8u39gs9mana\",\"aenz8dktc4ifxdgerg1o5m4tgfc\",\"azptr4acc6jgt9pbach7gb5837e\",\"agpfti6dum7f1tg3uid8uy1wbza\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"a1438fbbhjeffkexmcfhnx99o1h\":\"(222) 123-1234\",\"a5hwxjsmkn6bak6r7uea5bx1kwc\":\"axesd74yuxtbmw1sbk8ufax7z3a\",\"abru6tz8uebdxy4skheqidh7zxy\":\"richard.guzman@email.com\",\"adtf1151chornmihz4xbgbk9exa\":\"{\\\"from\\\":1681992000000}\",\"aejo5tcmq54bauuueem9wc4fw4y\":\"80%\",\"ahf43e44h3y8ftanqgzno9z7q7w\":\"$3,200,000\",\"ainpw47babwkpyj77ic4b9zq9xr\":\"Afformance Ltd.\",\"amahgyn9n4twaapg3jyxb6y4jic\":\"ar6t1ttcumgfuqugg5o4g4mzrza\",\"aro91wme9kfaie5ceu9qasmtcnw\":\"apjnaggwixchfxwiatfh7ey7uno\",\"auhf91pm85f73swwidi4wid8jqe\":\"{\\\"from\\\":1667476800000}\"}}',1684139117609,1684139117609,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('cpx6a1cf3u7b73gsdmmehw7gx7c','2023-05-15 08:25:29.415551','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Epic','{\"contentOrder\":[\"apcmmc1nr47dbfjsue7g8rzjk1h\"],\"icon\":\"?\",\"isTemplate\":true,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"424ea5e3-9aa1-4075-8c5c-01b44b66e634\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\",\"a1g6i613dpe9oryeo71ex3c86hy\":\"https://mattermost.com/boards/\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"3\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"c62172ea-5da7-4dec-8186-37267d8ee9a7\"}}',1684139129412,1684139129412,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('cqbt1rer5kjy57rycqdqac7a6qy','2023-05-15 08:25:28.177841','bd65qbzuqupfztpg31dgwgwm5ga',1,'card','Start a daily journal','{\"contentOrder\":[],\"icon\":\"✍️\",\"isTemplate\":false,\"properties\":{\"af6fcbb8-ca56-4b73-83eb-37437b9a667d\":\"bf52bfe6-ac4c-4948-821f-83eaa1c7b04a\",\"d6b1249b-bc18-45fc-889e-bec48fce80ef\":\"0a82977f-52bf-457b-841b-e2b7f76fb525\",\"d9725d14-d5a8-48e5-8de1-6f8c004a9680\":\"3245a32d-f688-463b-87f4-8e7142c1b397\"}}',1684139128175,1684139128175,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('cqfonaty9ifrg9mxbr5xk5fyowo','2023-05-15 08:25:23.700229','bc41mwxg9ybb69pn9j5zna6d36c',1,'card','Define project scope','{\"contentOrder\":[\"axzei9dbwufg8dgkn4is7xhtu7r\",\"ad4napirz73dpzp944nognud99o\",\"ak16ghrgwzpfcibwxfaensud9ch\",\"aah9qr9gabiykuxy85dfmojep4r\",\"akja3h5qikjrzxmutooteo9196a\",\"aip3g6feocp8i9fbxf8mtnsomny\",\"aif8a8d7kjfrg5k8ni856wp454r\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a8daz81s4xjgke1ww6cwik5w7ye\":\"32\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ar6b8m3jxr3asyxhr8iucdbo6yc\",\"d3d682bf-e074-49d9-8df5-7320921c2d23\":\"87f59784-b859-4c24-8ebe-17c766e081dd\"}}',1684139123699,1684139123699,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('cqmgjgha55p8ktp9wo46nksj5qo','2023-05-15 08:25:43.232118','buixxjic3xjfkieees4iafdrznc',1,'card','Add new properties','{\"contentOrder\":[\"a3rbis1zhofnefmroitqsp1bcce\",\"ayhk11qsuz789fk8bqae4oz8mro\",\"7gc3z8cf8rirgfyutwoke9nn6jy\",\"76cinqnb6k3dzmfbm9fnc8eofny\",\"ite7n89kgf3ymzfirut1aqzuaoa\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/work-with-cards.html#add-and-manage-properties\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"af3p8ztcyxgn8wd9z4az7o9tjeh\",\"acypkejeb5yfujhj9te57p9kaxw\":\"ascd7nm9r491ayot8i86g1gmgqw\"}}',1684139143218,1684139143218,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('cqpnj7sc9tjrypjrg5ogfco1mho','2023-05-15 08:25:40.639273','bsjd59qtpbf888mqez3ge77domw',1,'card','Positive user feedback','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"adjckpdotpgkz7c6wixzw9ipb1e\":\"aq1dwbf661yx337hjcd5q3sbxwa\"}}',1684139140636,1684139140636,0,NULL,'system','','system','b7n3rwgpsspbg9drkn8ztit7yxw'),('cqxa89unw63yguyhmqeeqpred7e','2023-05-15 08:25:25.706232','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Increase customer retention','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"a8nukezwwmknqwjsygg7eaxs9te\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"apqfjst8massbjjhpcsjs3y1yqa\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"a8zg3rjtf4swh7smsjxpsn743rh\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"66%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"90% customer retention rate\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"acb6dqqs6yson7bbzx6jk9bghjh\",\"azqnyswk6s1boiwuthscm78qwuo\":\"60%\",\"azzbawji5bksj69sekcs4srm1ky\":\"afkxpcjqjypu7hhar7banxau91h\"}}',1684139125703,1684139125703,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('cr47yscucgffhdn5ujwd8j9bdxy','2023-05-15 08:25:25.692608','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Generate more Marketing Qualified Leads (MQLs)','{\"contentOrder\":[],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"a8nukezwwmknqwjsygg7eaxs9te\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"auw3afh3kfhrfgmjr8muiz137jy\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"as555ipyzopjjpfb5rjtssecw5e\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"65%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"100\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"ahfbn1jsmhydym33ygxwg5jt3kh\",\"azqnyswk6s1boiwuthscm78qwuo\":\"65\",\"azzbawji5bksj69sekcs4srm1ky\":\"aehoa17cz18rqnrf75g7dwhphpr\"}}',1684139125690,1684139125690,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('cs8yd11z8eirpjdf6eu8h1uhpjc','2023-05-15 08:25:36.388981','bkqk6hpfx7pbsucue7jan5n1o1o',1,'card','Helx Industries','{\"contentOrder\":[\"a1u4upynm4jfp5k7q5y9easu5ty\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a1semdhszu1rq17d7et5ydrqqio\":\"abt79uxg5edqojsrrefcnr4eruo\",\"a6cwaq79b1pdpb97wkanmeyy4er\":\"650\",\"ahzspe59iux8wigra8bg6cg18nc\":\"helxindustries.com\",\"aiefo7nh9jwisn8b4cgakowithy\":\"$50,000,000\",\"an1eerzscfxn6awdfajbg41uz3h\":\"2009\",\"aozntq4go4nkab688j1s7stqtfc\":\"New York, NY\"}}',1684139136381,1684139136381,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('ctqcabnjrgpbr3pw5nf6q1cugzr','2023-05-15 08:25:43.156015','buixxjic3xjfkieees4iafdrznc',1,'card','Share a board','{\"contentOrder\":[\"a3hdpmeq3zbfrtfgoqafmey7eia\",\"anjsttbf3tpbntpgmy63kegm3yc\",\"7r7asyew8d7fyunf4sow8e5iyoc\",\"ad8j3n8tp77bppee3ipjt6odgpe\",\"7w935usqt6pby8qz9x5pxaj7iow\",\"7ogbs8h6q4j8z7ngy1m7eag63nw\",\"7z1jau5qy3jfcxdp5cgq3duk6ne\",\"ibzdeqmg6rpr6zbuepq3dyys9mw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/sharing-boards.html\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ajurey3xkocs1nwx8di5zx6oe7o\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aq6ukoiciyfctgwyhwzpfss8ghe\"}}',1684139143153,1684139143153,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('cu8oe6owyziy5b81m5n4uofi7xc','2023-05-15 08:25:25.726060','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Hit company global sales target','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"a6robxx81diugpjq5jkezz3j1fo\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"auw3afh3kfhrfgmjr8muiz137jy\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"a8zg3rjtf4swh7smsjxpsn743rh\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"15%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"50MM\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"awfu37js3fomfkkczm1zppac57a\",\"azqnyswk6s1boiwuthscm78qwuo\":\"7.5MM\",\"azzbawji5bksj69sekcs4srm1ky\":\"agrfeaoj7d8p5ianw5iaf3191ae\"}}',1684139125723,1684139125723,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('cu91c9dt6otycpm7pnep9rgn8ky','2023-05-15 08:25:34.420773','bh4pkixqsjift58e1qy6htrgeay',1,'card','Richard Parsons','{\"contentOrder\":[\"aa6w5auxnw3d83dioa7ztm54i7o\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"aaebj5fyx493eezx6ukxiwydgty\":\"a7yq89whddzob1futao4rxk3yzc\",\"acjq4t5ymytu8x1f68wkggm7ypc\":\"richard.parsons@email.com\",\"aify3r761b9w43bqjtskrzi68tr\":\"Password123\",\"akrxgi7p7w14fym3gbynb98t9fh\":\"{\\\"from\\\":1671019200000}\",\"aqafzdeekpyncwz7m7i54q3iqqy\":\"https://user-images.githubusercontent.com/46905241/121941290-ee355280-cd03-11eb-9b9f-f6f524e4103e.gif\",\"atg9qu6oe4bjm8jczzsn71ff5me\":\"a1sxagjgaadym5yrjak6tcup1oa\"}}',1684139134419,1684139134419,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('cuadbgz3yhpbwxcdaco3xhhzqic','2023-05-15 08:25:29.350609','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Move cards across boards','{\"contentOrder\":[\"aecekjo6toigp9k9izqesci8uuw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"a5yxq8rbubrpnoommfwqmty138h\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"abrfos7e7eczk9rqw6y5abadm1y\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"ed4a5340-460d-461b-8838-2c56e8ee59fe\",\"a1g6i613dpe9oryeo71ex3c86hy\":\"https://mattermost.com/boards/\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"2\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139129347,1684139129347,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('cupeqsesj6tgaurskg967mtctge','2023-05-15 08:25:21.534781','bbn1888mprfrm5fjw9f1je9x3xo',1,'card','Gardening','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a9zf59u8x1rf4ywctpcqama7tio\":\"afpy8s7i45frggprmfsqngsocqh\"}}',1684139121520,1684139121520,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('cuwu5yqx6xigbjei8gt1foqciic','2023-05-15 08:25:28.235696','bd65qbzuqupfztpg31dgwgwm5ga',1,'card','Open retirement account','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"af6fcbb8-ca56-4b73-83eb-37437b9a667d\":\"bf52bfe6-ac4c-4948-821f-83eaa1c7b04a\",\"d6b1249b-bc18-45fc-889e-bec48fce80ef\":\"0a82977f-52bf-457b-841b-e2b7f76fb525\",\"d9725d14-d5a8-48e5-8de1-6f8c004a9680\":\"80be816c-fc7a-4928-8489-8b02180f4954\"}}',1684139128233,1684139128233,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('cwchj4bcga7b558k6waqjian4ey','2023-05-15 08:25:43.111435','buixxjic3xjfkieees4iafdrznc',1,'card','Drag cards','{\"contentOrder\":[\"apktbgtee5jb8xrnqy3ibiujxew\",\"a87rgrpj9hj8i8egtxphp9qt7rr\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/working-with-boards.html#dragging-cards\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ajurey3xkocs1nwx8di5zx6oe7o\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aq6ukoiciyfctgwyhwzpfss8ghe\"}}',1684139143108,1684139143108,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('cwjh3qjukx38gipog474tobdb3w','2023-05-15 08:25:23.704328','bc41mwxg9ybb69pn9j5zna6d36c',1,'card','Requirements sign-off','{\"contentOrder\":[\"a96ku8fdcoirf3gcnhs84ro7wce\",\"aumref76zp7n9jjk6yzzthif6rh\",\"a5g5byxhrgpdrbn3k8z3xor3btr\",\"araqcr581mirqjbmhi8x4xd1wza\",\"an1cauynf7i87md78gocifotujo\",\"auc36b1696pnfbgakcmht4jxsph\",\"ayqepp51fh3d8prg75ockmnfz3e\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"a8daz81s4xjgke1ww6cwik5w7ye\":\"8\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ayz81h9f3dwp7rzzbdebesc7ute\",\"d3d682bf-e074-49d9-8df5-7320921c2d23\":\"d3bfb50f-f569-4bad-8a3a-dd15c3f60101\"}}',1684139123703,1684139123703,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('cwzr9jf3kbpnobqdx18edtbxyze','2023-05-15 08:25:23.712776','bc41mwxg9ybb69pn9j5zna6d36c',1,'card','Conduct market analysis','{\"contentOrder\":[\"akgbx1ddui38sirbij6aan5sbur\",\"adddhxyhoyp8tfme6amns76ssth\",\"aeyxha9paaf8etxhfbkyqcmd9qa\",\"at7h4mzxqw3nx8ctsecufy6zuhe\",\"awgaxdy4rctnnmptqi1a35dzrzw\",\"ae8cp3nwpc3g3m8ujo9rcsd7p4c\",\"aqq3gzop1j3r6zry618epesj6da\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a8daz81s4xjgke1ww6cwik5w7ye\":\"40\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ar6b8m3jxr3asyxhr8iucdbo6yc\",\"d3d682bf-e074-49d9-8df5-7320921c2d23\":\"87f59784-b859-4c24-8ebe-17c766e081dd\"}}',1684139123711,1684139123711,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('cyumdhwtngffq3cgtynr1rgs4ca','2023-05-15 08:25:40.626030','bsjd59qtpbf888mqez3ge77domw',1,'card','Schedule more time for testing','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"adjckpdotpgkz7c6wixzw9ipb1e\":\"akj3fkmxq7idma55mdt8sqpumyw\"}}',1684139140623,1684139140623,0,NULL,'system','','system','b7n3rwgpsspbg9drkn8ztit7yxw'),('cyw3bxrbfepf3tq4m8yfag5h3wo','2023-05-15 08:25:43.959814','buixxjic3xjfkieees4iafdrznc',1,'card','@mention teammates','{\"contentOrder\":[\"agdze3c4gu78m5bke4qwwpigika\",\"afbrk7aqnsigijbmueau4r1mhzy\",\"7mbw9t71hjbrydgzgkqqaoh8usr\",\"i4kqj6jw98in5tyfhoy761ehfhw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/work-with-cards.html#mention-people\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ajurey3xkocs1nwx8di5zx6oe7o\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aq6ukoiciyfctgwyhwzpfss8ghe\"}}',1684139143941,1684139143941,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('cywrn8u5uqjba9d7dmzk6xrowoe','2023-05-15 08:25:15.704905','b7wnw9awd4pnefryhq51apbzb4c',1,'card','Video production','{\"contentOrder\":[\"am6o87kzyk7gymeyhkq4p48zd1c\",\"asu9m4usdcb8y3ka1hegjs3merh\",\"aeoe3d6d8zbnwjfwcpmbzgmicir\",\"aszwzw4fw8tnzpxmswm3xz19ybh\",\"a3du3x3wpsfdtidw5xsdt1714ze\",\"awjcijjpwhbfgjpz6jmfye5gbcw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"4cf1568d-530f-4028-8ffd-bdc65249187e\":\"b1abafbf-a038-4a19-8b68-56e0fd2319f7\",\"d777ba3b-8728-40d1-87a6-59406bbbbfb0\":\"34eb9c25-d5bf-49d9-859e-f74f4e0030e7\"}}',1684139115701,1684139115701,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('czbrswa1e77n1zyzhit93g8j1ca','2023-05-15 08:25:25.795089','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Launch 3 key features','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"apnt1f7na9rzgk1rt49keg7xbiy\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"ao9b5pxyt7tkgdohzh9oaustdhr\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"a8zg3rjtf4swh7smsjxpsn743rh\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"33%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"3\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"anruuoyez51r3yjxuoc8zoqnwaw\",\"azqnyswk6s1boiwuthscm78qwuo\":\"1\",\"azzbawji5bksj69sekcs4srm1ky\":\"aw5i7hmpadn6mbwbz955ubarhme\"}}',1684139125789,1684139125789,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('czphuqnioo7fydrsb8pu7qrosgw','2023-05-15 08:25:43.208082','buixxjic3xjfkieees4iafdrznc',1,'card','Create a new view','{\"contentOrder\":[\"aozbezukpgif3jpbsq7tahmmp5e\",\"apj4n919rn3n5tn44dzozi43b9a\",\"7owai1ux3h3gtf8byynfk6hyx1c\",\"7n8jq1dizyfgotby3o91arf1hxh\",\"77y4wffj1ctg7xmm9bx45qn6q6o\",\"i9rjjmsuns7g7pphdppgp1wn6ie\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/working-with-boards.html#adding-new-views\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"af3p8ztcyxgn8wd9z4az7o9tjeh\",\"acypkejeb5yfujhj9te57p9kaxw\":\"ascd7nm9r491ayot8i86g1gmgqw\"}}',1684139143205,1684139143205,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('i4kqj6jw98in5tyfhoy761ehfhw','2023-05-15 08:25:44.796813','cyw3bxrbfepf3tq4m8yfag5h3wo',1,'image','','{\"fileId\":\"74nt9eqzea3ydjjpgjtsxcjgrxc.gif\"}',1684139144794,1684139144794,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('i6etc7e7omjymxbztaoqp3cpyta','2023-05-15 08:25:41.734515','cbm9y3gmqqjd6uewottgm8mocwh',1,'image','','{\"fileId\":\"7pbp4qg415pbstc6enzeicnu3qh.png\"}',1684139141731,1684139141731,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('i6kfk1wdofpfxjxmwtq8mpg1ohy','2023-05-15 08:25:32.100702','cec73iz548tyzfeagiummkqyh6c',1,'image','','{\"fileId\":\"7tmfu5iqju3n1mdfwi5gru89qmw.png\"}',1684139132098,1684139132098,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('i9rjjmsuns7g7pphdppgp1wn6ie','2023-05-15 08:25:44.719289','czphuqnioo7fydrsb8pu7qrosgw',1,'image','','{\"fileId\":\"78jws5m1myf8pufewzkaa6i11sc.gif\"}',1684139144716,1684139144716,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ibzdeqmg6rpr6zbuepq3dyys9mw','2023-05-15 08:25:44.528608','ctqcabnjrgpbr3pw5nf6q1cugzr',1,'image','','{\"fileId\":\"7knxbyuiedtdafcgmropgkrtybr.gif\"}',1684139144525,1684139144525,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ici1jaxg8j7r68g4bzc6757b7da','2023-05-15 08:25:41.544899','cjztn4z4c53dem8kdnkkq6tc8fa',1,'image','','{\"fileId\":\"77pe9r4ckbin438ph3f18bpatua.png\"}',1684139141542,1684139141542,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('id7bu3de1qpf77yr764ts4rnaoe','2023-05-15 08:25:38.925343','ck1c13wxrg3fnpxem5d8cu76s4o',1,'image','','{\"fileId\":\"7y5kr8x8ybpnwdykjfuz57rggrh.png\"}',1684139138917,1684139138917,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('iezeao1oxcjb4jxfb7hs9xhrhur','2023-05-15 08:25:31.120895','cipuiirpksj84xjb69fzyjorysr',1,'image','','{\"fileId\":\"7b9xk9boj3fbqfm3umeaaizp8qr.png\"}',1684139131118,1684139131118,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ifh3g5uriziy1ic5ute8a7pc3bh','2023-05-15 08:25:41.615755','cfefgwjke6bbxpjpig618g9bpte',1,'image','','{\"fileId\":\"7pbp4qg415pbstc6enzeicnu3qh.png\"}',1684139141613,1684139141612,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('iiw3hpjncf38ftr5coh8b9gfrna','2023-05-15 08:25:44.635470','ckjptgsceu3fq5fmjmn9d7ugpiw',1,'image','','{\"fileId\":\"7ek6wbpp19jfoujs1goh6kttbby.gif\"}',1684139144632,1684139144632,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('iiz5ur5j5gt8c3ygq7z5kasubwa','2023-05-15 08:25:44.489321','c8x3s1st6ijfzuxhrf5aaei76my',1,'image','','{\"fileId\":\"74uia99m9btr8peydw7oexn37tw.gif\"}',1684139144486,1684139144486,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('irib7x5bb9t8ztxmy68up9dfjaa','2023-05-15 08:25:44.567598','cbokq5iftypbs3gspcn15kp1u4r',1,'image','','{\"fileId\":\"7iw4rxx7jj7bypmdotd9z469cyh.png\"}',1684139144565,1684139144565,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ispx6nw5owbd5xpafh3mhngwqho','2023-05-15 08:25:31.072918','cot7fjjb68pgn9xdgr4yy3pwfur',1,'image','','{\"fileId\":\"7tmfu5iqju3n1mdfwi5gru89qmw.png\"}',1684139131068,1684139131068,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ite7n89kgf3ymzfirut1aqzuaoa','2023-05-15 08:25:44.766110','cqmgjgha55p8ktp9wo46nksj5qo',1,'image','','{\"fileId\":\"7d6hrtig3zt8f9cnbo1um5oxx3y.gif\"}',1684139144755,1684139144755,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('iupwtx8hqgfn19dxkfj56h48rwo','2023-05-15 08:25:44.690543','c8xeju51trbg38x6xq6spazwsnc',1,'image','','{\"fileId\":\"7dybb6t8fj3nrdft7nerhuf784y.png\"}',1684139144687,1684139144687,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('iye416ctq8irqmb8oqww6fw96bo','2023-05-15 08:25:21.692325','c48fsy6msutb6i8pcnd7axut6kr',1,'image','','{\"fileId\":\"76fwrj36hptg6dywka4k5mt3sph.png\"}',1684139121690,1684139121690,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('v1qqyh58bgtnm9brdh9k3cm8sqy','2023-05-15 08:25:36.337512','',1,'view','Competitor List','{\"cardOrder\":[\"c4htpxn8wxpd6pffpjo4u8xxxxc\",\"cs8yd11z8eirpjdf6eu8h1uhpjc\",\"cj4fk3wp3rtn1dyeci9basq1w5o\",\"c98nnstjzhbgmpj6g88rgpgnheh\",\"cne7na65esjff3bhwjdrd1pea4h\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":210,\"a1semdhszu1rq17d7et5ydrqqio\":121,\"aapogff3xoa8ym7xf56s87kysda\":194,\"ahzspe59iux8wigra8bg6cg18nc\":156,\"aiefo7nh9jwisn8b4cgakowithy\":155,\"aozntq4go4nkab688j1s7stqtfc\":151,\"az3jkw3ynd3mqmart7edypey15e\":145},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"ahzspe59iux8wigra8bg6cg18nc\",\"aozntq4go4nkab688j1s7stqtfc\",\"aiefo7nh9jwisn8b4cgakowithy\",\"a6cwaq79b1pdpb97wkanmeyy4er\",\"an1eerzscfxn6awdfajbg41uz3h\",\"a1semdhszu1rq17d7et5ydrqqio\",\"aapogff3xoa8ym7xf56s87kysda\",\"az3jkw3ynd3mqmart7edypey15e\"]}',1684139136334,1684139136334,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('v3cxngzd1tinibq35wzmm1semfh','2023-05-15 08:25:38.154760','brs9cdimfw7fodyi7erqt747rhc',1,'view','Publication Calendar','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"agqsoiipowmnu9rdwxm57zrehtr\",\"defaultTemplateId\":\"cff1jmrxfrirgbeebhr9qd7nida\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139138150,1684139138150,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('v6fcx5rfyftd9ikkuj9ez9mkgga','2023-05-15 08:25:21.550354','bbn1888mprfrm5fjw9f1je9x3xo',1,'view','List View','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":280},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"a9zf59u8x1rf4ywctpcqama7tio\",\"abthng7baedhhtrwsdodeuincqy\"]}',1684139121546,1684139121546,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('v6ygkz5qrb3dmfk1jdect4j1eyo','2023-05-15 08:25:17.698009','bzwb99zf498tsm7mjqbiy7g81ze',1,'view','Open Deals','{\"cardOrder\":[\"c8tf9wun9gtyc7bzize8f513eqc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[{\"condition\":\"includes\",\"propertyId\":\"a5hwxjsmkn6bak6r7uea5bx1kwc\",\"values\":[\"akj61wc9yxdwyw3t6m8igyf9d5o\",\"aic89a5xox4wbppi6mbyx6ujsda\",\"ah6ehh43rwj88jy4awensin8pcw\",\"aprhd96zwi34o9cs4xyr3o9sf3c\",\"axesd74yuxtbmw1sbk8ufax7z3a\"]}],\"operation\":\"and\"},\"groupById\":\"aro91wme9kfaie5ceu9qasmtcnw\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"apjnaggwixchfxwiatfh7ey7uno\",\"apiswzj7uiwbh87z8dw8c6mturw\",\"auu9bfzqeuruyjwzzqgz7q8apuw\",\"\"],\"visiblePropertyIds\":[]}',1684139117695,1684139117695,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('v7fiuehkgg3yw7dp1c4mcsmmcmc','2023-05-15 08:25:43.985053','buixxjic3xjfkieees4iafdrznc',1,'view','Preview: Table View','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":280,\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":100,\"acypkejeb5yfujhj9te57p9kaxw\":169},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\",\"aqh13jabwexjkzr3jqsz1i1syew\",\"acmg7mz1rr1eykfug4hcdpb1y1o\",\"acypkejeb5yfujhj9te57p9kaxw\"]}',1684139143982,1684139143982,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('v865p4fxmcjb5feezsjpdyh6x6w','2023-05-15 08:25:38.133403','brs9cdimfw7fodyi7erqt747rhc',1,'view','Due Date Calendar','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"a39x5cybshwrbjpc3juaakcyj6e\",\"defaultTemplateId\":\"cff1jmrxfrirgbeebhr9qd7nida\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139138115,1684139138115,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('v89itw6ai7bro8bwok7wgz4ax6c','2023-05-15 08:25:44.003337','buixxjic3xjfkieees4iafdrznc',1,'view','Preview: Calendar View','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"acmg7mz1rr1eykfug4hcdpb1y1o\",\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139144000,1684139144000,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('v89qkmtbnfino7jfxfjdmc33zjr','2023-05-15 08:25:44.029586','buixxjic3xjfkieees4iafdrznc',1,'view','Onboarding','{\"cardOrder\":[\"cbokq5iftypbs3gspcn15kp1u4r\",\"c1skdp9t1mtnjbxcmoshjj94x8a\",\"c8x3s1st6ijfzuxhrf5aaei76my\",\"ckjptgsceu3fq5fmjmn9d7ugpiw\",\"cqmgjgha55p8ktp9wo46nksj5qo\",\"czphuqnioo7fydrsb8pu7qrosgw\",\"cyw3bxrbfepf3tq4m8yfag5h3wo\",\"cwchj4bcga7b558k6waqjian4ey\",\"ctqcabnjrgpbr3pw5nf6q1cugzr\",\"c8xeju51trbg38x6xq6spazwsnc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"aqb5x3pt87dcc9stbk4ofodrpoy\",\"a1mtm777bkagq3iuu7xo9b13qfr\",\"auxbwzptiqzkii5r61uz3ndsy1r\",\"aj9386k1bx8qwmepeuxg3b7z4pw\"],\"visiblePropertyIds\":[]}',1684139144027,1684139144026,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('v8tdd9nrpktby5jmsdzkk9zq4oe','2023-05-15 08:25:28.262046','bd65qbzuqupfztpg31dgwgwm5ga',1,'view','Calendar View','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"ajy6xbebzopojaenbnmfpgtdwso\",\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139128259,1684139128259,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('v9ha9nupshtfgifzrunj7ioftze','2023-05-15 08:25:25.615519','',1,'view','By Quarter','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":452,\"a17ryhi1jfsboxkwkztwawhmsxe\":148,\"a6amddgmrzakw66cidqzgk6p4ge\":230,\"azzbawji5bksj69sekcs4srm1ky\":142},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"aqxyzkdrs4egqf7yk866ixkaojc\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"a6amddgmrzakw66cidqzgk6p4ge\",\"a17ryhi1jfsboxkwkztwawhmsxe\",\"azzbawji5bksj69sekcs4srm1ky\",\"adp5ft3kgz7r5iqq3tnwg551der\",\"aqxyzkdrs4egqf7yk866ixkaojc\",\"adu6mebzpibq6mgcswk69xxmnqe\",\"asope3bddhm4gpsng5cfu4hf6rh\",\"ajwxp866f9obs1kutfwaa5ru7fe\",\"azqnyswk6s1boiwuthscm78qwuo\",\"ahz3fmjnaguec8hce7xq3h5cjdr\",\"a17bfcgnzmkwhziwa4tr38kiw5r\"]}',1684139125611,1684139125611,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('va89mmhx8ab8k9mh9wqj1qhg7bo','2023-05-15 08:25:29.458154','bgi1yqiis8t8xdqxgnet8ebutky',1,'view','By Status','{\"cardOrder\":[\"c8kkpb6wh7igg7nw88x8nfnwf4c\",\"cot7fjjb68pgn9xdgr4yy3pwfur\",\"cuadbgz3yhpbwxcdaco3xhhzqic\",\"cipuiirpksj84xjb69fzyjorysr\",\"c8z9b6w6757nojkqi5k4kc1eggy\",\"c9iwbjcg8w38ip8m9xizycdmesc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"cidz4imnqhir48brz6e8hxhfrhy\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"50117d52-bcc7-4750-82aa-831a351c44a0\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\",\"reversed\":false}],\"viewType\":\"board\",\"visibleOptionIds\":[\"aft5bzo7h9aspqgrx3jpy5tzrer\",\"abrfos7e7eczk9rqw6y5abadm1y\",\"ax8wzbka5ahs3zziji3pp4qp9mc\",\"atabdfbdmjh83136d5e5oysxybw\",\"ace1bzypd586kkyhcht5qqd9eca\",\"aay656c9m1hzwxc9ch5ftymh3nw\",\"a6ghze4iy441qhsh3eijnc8hwze\"],\"visiblePropertyIds\":[\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"60985f46-3e41-486e-8213-2b987440ea1c\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\"]}',1684139129454,1684139129454,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('vb8p8npznajgu7jzuoi8omjwwfy','2023-05-15 08:25:23.729054','bc41mwxg9ybb69pn9j5zna6d36c',1,'view','Task Overview','{\"cardOrder\":[\"cqfonaty9ifrg9mxbr5xk5fyowo\",\"cwzr9jf3kbpnobqdx18edtbxyze\",\"cgf85qmqr7fnyxcfqqw8nf8mn4h\",\"c3e1n8jh85iy8pgqzz8xcdpejoc\",\"cwjh3qjukx38gipog474tobdb3w\",\"cz8p8gofakfby8kzz83j97db8ph\",\"ce1jm5q5i54enhuu4h3kkay1hcc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{\"a8daz81s4xjgke1ww6cwik5w7ye\":\"sum\"},\"columnWidths\":{\"2a5da320-735c-4093-8787-f56e15cdfeed\":196,\"__title\":280,\"a8daz81s4xjgke1ww6cwik5w7ye\":139,\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":141,\"d3d682bf-e074-49d9-8df5-7320921c2d23\":110},\"defaultTemplateId\":\"czw9es1e89fdpjr7cqptr1xq7qh\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\",\"d3d682bf-e074-49d9-8df5-7320921c2d23\",\"2a5da320-735c-4093-8787-f56e15cdfeed\",\"a3zsw7xs8sxy7atj8b6totp3mby\",\"axkhqa4jxr3jcqe4k87g8bhmary\",\"a7gdnz8ff8iyuqmzddjgmgo9ery\",\"a8daz81s4xjgke1ww6cwik5w7ye\"]}',1684139123728,1684139123728,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('vc6qq7pxpptfzxrx3pgqhz6t3bo','2023-05-15 08:25:34.453346','bixohg18tt11in4qbtinimk974y',1,'view','By Status','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"af6hjb3ysuaxbwnfqpby4wwnkdr\",\"aotxum1p5bw3xuzqz3ctjw66yww\",\"a7yq89whddzob1futao4rxk3yzc\",\"aseqq9hrsua56r3s6nbuirj9eec\",\"ap93ysuzy1xa7z818r6myrn4h4y\"],\"visiblePropertyIds\":[]}',1684139134449,1684139134449,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('vdm7hc76sq3rf78sbwte58a4uah','2023-05-15 08:25:41.531701','bui5izho7dtn77xg3thkiqprc9r',1,'view','List: Bugs ?','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"50117d52-bcc7-4750-82aa-831a351c44a0\":145,\"__title\":280},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[{\"condition\":\"includes\",\"propertyId\":\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"values\":[\"1fdbb515-edd2-4af5-80fc-437ed2211a49\"]}],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\",\"reversed\":false}],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"50117d52-bcc7-4750-82aa-831a351c44a0\",\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"60985f46-3e41-486e-8213-2b987440ea1c\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\"]}',1684139141529,1684139141528,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('vdtafoycmw3gadf86gumendx8fw','2023-05-15 08:25:23.723776','bc41mwxg9ybb69pn9j5zna6d36c',1,'view','Progress Tracker','{\"cardOrder\":[\"c3e1n8jh85iy8pgqzz8xcdpejoc\",\"cwjh3qjukx38gipog474tobdb3w\",\"cgf85qmqr7fnyxcfqqw8nf8mn4h\",\"cwzr9jf3kbpnobqdx18edtbxyze\",\"cqfonaty9ifrg9mxbr5xk5fyowo\",\"coxnjt3ro1in19dd1e3awdt338r\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{\"\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"adeo5xuwne3qjue83fcozekz8ko\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"afi4o5nhnqc3smtzs1hs3ij34dh\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"ahpyxfnnrzynsw3im1psxpkgtpe\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"ar6b8m3jxr3asyxhr8iucdbo6yc\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"ayz81h9f3dwp7rzzbdebesc7ute\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"}},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"ayz81h9f3dwp7rzzbdebesc7ute\",\"ar6b8m3jxr3asyxhr8iucdbo6yc\",\"afi4o5nhnqc3smtzs1hs3ij34dh\",\"adeo5xuwne3qjue83fcozekz8ko\",\"ahpyxfnnrzynsw3im1psxpkgtpe\",\"\"],\"visiblePropertyIds\":[\"d3d682bf-e074-49d9-8df5-7320921c2d23\",\"a8daz81s4xjgke1ww6cwik5w7ye\"]}',1684139123722,1684139123722,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('veo99rnraz7gx7frqum54qdyo3h','2023-05-15 08:25:28.248903','bd65qbzuqupfztpg31dgwgwm5ga',1,'view','By Status','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"af6fcbb8-ca56-4b73-83eb-37437b9a667d\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"bf52bfe6-ac4c-4948-821f-83eaa1c7b04a\",\"77c539af-309c-4db1-8329-d20ef7e9eacd\",\"98bdea27-0cce-4cde-8dc6-212add36e63a\",\"\"],\"visiblePropertyIds\":[\"d9725d14-d5a8-48e5-8de1-6f8c004a9680\",\"d6b1249b-bc18-45fc-889e-bec48fce80ef\"]}',1684139128246,1684139128246,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('vgjqjigmp93yt9k1frx7kqgqgqh','2023-05-15 08:25:44.016889','buixxjic3xjfkieees4iafdrznc',1,'view','Preview: Gallery View','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"gallery\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139144014,1684139144014,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('vgnezwn91c38e3e8zq9uz6ki3zr','2023-05-15 08:25:38.852743','brs9cdimfw7fodyi7erqt747rhc',1,'view','Content List','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":322,\"ab6mbock6styfe6htf815ph1mhw\":229,\"aysx3atqexotgwp5kx6h5i5ancw\":208},\"defaultTemplateId\":\"cff1jmrxfrirgbeebhr9qd7nida\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"a39x5cybshwrbjpc3juaakcyj6e\",\"reversed\":false}],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"ae9ar615xoknd8hw8py7mbyr7zo\",\"aysx3atqexotgwp5kx6h5i5ancw\",\"ab6mbock6styfe6htf815ph1mhw\",\"ao44fz8nf6z6tuj1x31t9yyehcc\",\"a39x5cybshwrbjpc3juaakcyj6e\",\"agqsoiipowmnu9rdwxm57zrehtr\",\"ap4e7kdg7eip7j3c3oyiz39eaoc\"]}',1684139138847,1684139138847,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('vhkudrzy1fjnyxc7qp5xrxf6m3c','2023-05-15 08:25:29.284712','',1,'view','By Sprint','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{\"ai7ajsdk14w7x5s8up3dwir77te\":\"count\"},\"columnWidths\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":128,\"50117d52-bcc7-4750-82aa-831a351c44a0\":126,\"__title\":280,\"a1g6i613dpe9oryeo71ex3c86hy\":159,\"aeomttrbhhsi8bph31jn84sto6h\":141,\"ax9f8so418s6s65hi5ympd93i6a\":183,\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":100},\"defaultTemplateId\":\"c1axsmo6e5i8tf8xun3qyk57ytr\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"60985f46-3e41-486e-8213-2b987440ea1c\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"50117d52-bcc7-4750-82aa-831a351c44a0\",\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"60985f46-3e41-486e-8213-2b987440ea1c\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\",\"aphg37f7zbpuc3bhwhp19s1ribh\",\"a4378omyhmgj3bex13sj4wbpfiy\",\"ai7ajsdk14w7x5s8up3dwir77te\",\"a1g6i613dpe9oryeo71ex3c86hy\",\"aeomttrbhhsi8bph31jn84sto6h\",\"ax9f8so418s6s65hi5ympd93i6a\"]}',1684139129281,1684139129281,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('vk9swnjd6bbbhxppuanupxkgx8a','2023-05-15 08:25:38.102083','brs9cdimfw7fodyi7erqt747rhc',1,'view','By Status','{\"cardOrder\":[null,\"cdbfkd15d6iy18rgx1tskmfsr6c\",\"cn8yofg9rtkgmzgmb5xdi56p3ic\",\"csgsnnywpuqzs5jgq87snk9x17e\",\"cqwaytore5y487wdu8zffppqnea\",null],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"cff1jmrxfrirgbeebhr9qd7nida\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"awna1nuarjca99m9s4uiy9kwj5h\",\"a9ana1e9w673o5cp8md4xjjwfto\",\"apy9dcd7zmand615p3h53zjqxjh\",\"acri4cm3bmay55f7ksztphmtnga\",\"amsowcd9a8e1kid317r7ttw6uzh\",\"\"],\"visiblePropertyIds\":[\"ab6mbock6styfe6htf815ph1mhw\"]}',1684139138099,1684139138099,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('vm38m6nzr9igxbb1igwucpsng6o','2023-05-15 08:25:28.276067','bd65qbzuqupfztpg31dgwgwm5ga',1,'view','By Date','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"d6b1249b-bc18-45fc-889e-bec48fce80ef\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"9a090e33-b110-4268-8909-132c5002c90e\",\"0a82977f-52bf-457b-841b-e2b7f76fb525\",\"6e7139e4-5358-46bb-8c01-7b029a57b80a\",\"d5371c63-66bf-4468-8738-c4dc4bea4843\",\"\"],\"visiblePropertyIds\":[\"d9725d14-d5a8-48e5-8de1-6f8c004a9680\"]}',1684139128273,1684139128273,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('vnmhimtfhetgutrqj9eeqd46arh','2023-05-15 08:25:34.444782','bh4pkixqsjift58e1qy6htrgeay',1,'view','By Date','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"akrxgi7p7w14fym3gbynb98t9fh\",\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139134443,1684139134443,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('vq5xhbkz5abyadkqiwg7feafgrr','2023-05-15 08:25:15.755276','b7wnw9awd4pnefryhq51apbzb4c',1,'view','Discussion Items','{\"cardOrder\":[\"cjpkiya33qsagr4f9hrdwhgiajc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"d777ba3b-8728-40d1-87a6-59406bbbbfb0\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"4cf1568d-530f-4028-8ffd-bdc65249187e\",\"reversed\":false}],\"viewType\":\"board\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"4cf1568d-530f-4028-8ffd-bdc65249187e\"]}',1684139115752,1684139115752,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('vqignh3q8ej8tzxajzxb844me1y','2023-05-15 08:25:17.569512','',1,'view','All Contacts','{\"cardOrder\":[\"cizmdp6qkrjf9uqixnsu6ea4o8o\",\"c8tf9wun9gtyc7bzize8f513eqc\",\"cow8jauqkabgb8etq9ckdo8nhrh\",\"c5jaxbc9m6jn3dxcfhro94u1hpr\",\"cdykszx7gffnibcgf4p9gzdit9a\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":240,\"a1438fbbhjeffkexmcfhnx99o1h\":151,\"a5hwxjsmkn6bak6r7uea5bx1kwc\":132,\"abru6tz8uebdxy4skheqidh7zxy\":247,\"adtf1151chornmihz4xbgbk9exa\":125,\"aejo5tcmq54bauuueem9wc4fw4y\":127,\"ahf43e44h3y8ftanqgzno9z7q7w\":129,\"ainpw47babwkpyj77ic4b9zq9xr\":157,\"amahgyn9n4twaapg3jyxb6y4jic\":224,\"amba7ot98fh7hwsx8jdcfst5g7h\":171,\"aoheuj1f3mu6eehygr45fxa144y\":130,\"auhf91pm85f73swwidi4wid8jqe\":157},\"defaultTemplateId\":\"c7ho5n7y4t7fyimowcpjxuumtea\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"a5hwxjsmkn6bak6r7uea5bx1kwc\",\"aoheuj1f3mu6eehygr45fxa144y\",\"aro91wme9kfaie5ceu9qasmtcnw\",\"ainpw47babwkpyj77ic4b9zq9xr\",\"ahf43e44h3y8ftanqgzno9z7q7w\",\"amahgyn9n4twaapg3jyxb6y4jic\",\"abru6tz8uebdxy4skheqidh7zxy\",\"a1438fbbhjeffkexmcfhnx99o1h\",\"auhf91pm85f73swwidi4wid8jqe\",\"adtf1151chornmihz4xbgbk9exa\",\"aejo5tcmq54bauuueem9wc4fw4y\",\"amba7ot98fh7hwsx8jdcfst5g7h\"]}',1684139117562,1684139117562,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('vqsbfiew86inqxyxxjddcburbpc','2023-05-15 08:25:41.517969','bui5izho7dtn77xg3thkiqprc9r',1,'view','Board: Status','{\"cardOrder\":[\"cjztn4z4c53dem8kdnkkq6tc8fa\",\"cm4w7cc3aac6s9jdcujbs4j8f4r\",\"c6egh6cpnj137ixdoitsoxq17oo\",\"cct9u78utsdyotmejbmwwg66ihr\",\"cmft87it1q7yebbd51ij9k65xbw\",\"c9fe77j9qcruxf4itzib7ag6f1c\",\"coup7afjknqnzbdwghiwbsq541w\",\"c5ex1hndz8qyc8gx6ofbfeksftc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"cidz4imnqhir48brz6e8hxhfrhy\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"50117d52-bcc7-4750-82aa-831a351c44a0\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\",\"reversed\":false}],\"viewType\":\"board\",\"visibleOptionIds\":[\"8c557f69-b0ed-46ec-83a3-8efab9d47ef5\",\"ec6d2bc5-df2b-4f77-8479-e59ceb039946\",\"849766ba-56a5-48d1-886f-21672f415395\",\"\"],\"visiblePropertyIds\":[\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"60985f46-3e41-486e-8213-2b987440ea1c\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\"]}',1684139141514,1684139141514,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('vr77dgw7znidhbcery4hid5spfy','2023-05-15 08:25:21.563676','bbn1888mprfrm5fjw9f1je9x3xo',1,'view','Board View','{\"cardOrder\":[\"cncphrte4e7b8zke1wcjoia415w\",\"ci6nx4shmpffitmrx951e4oiptw\",\"c48fsy6msutb6i8pcnd7axut6kr\",\"cjsgbbn88fbd8pjcue85wa8xzor\",\"czowhma7rnpgb3eczbqo3t7fijo\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"a9zf59u8x1rf4ywctpcqama7tio\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"an51dnkenmoog9cetapbc4uyt3y\",\"afpy8s7i45frggprmfsqngsocqh\",\"aj4jyekqqssatjcq7r7chmy19ey\",\"\"],\"visiblePropertyIds\":[\"a9zf59u8x1rf4ywctpcqama7tio\"]}',1684139121561,1684139121561,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('vsueronrkbpndijpe65rgud18go','2023-05-15 08:25:23.733652','bc41mwxg9ybb69pn9j5zna6d36c',1,'view','Task Calendar','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"a3zsw7xs8sxy7atj8b6totp3mby\",\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139123732,1684139123732,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('vt67wb991m7nk8xg3qa77d7q58c','2023-05-15 08:25:36.355039','',1,'view','Market Position','{\"cardOrder\":[\"cip8b4jcomfr7by9gtizebikfke\",\"cacs91js1hb887ds41r6dwnd88c\",\"ca3u8edwrof89i8obxffnz4xw3a\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"arfjpz9by5car71tz3behba8yih\",\"abajmr34b8g1916w495xjb35iko\",\"abt79uxg5edqojsrrefcnr4eruo\",\"aipf3qfgjtkheiayjuxrxbpk9wa\"],\"visiblePropertyIds\":[]}',1684139136352,1684139136352,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('vtffntayuetdspgiy86gu6za77y','2023-05-15 08:25:29.472695','bgi1yqiis8t8xdqxgnet8ebutky',1,'view','By Type','{\"cardOrder\":[\"cipuiirpksj84xjb69fzyjorysr\",\"cuadbgz3yhpbwxcdaco3xhhzqic\",\"c8z9b6w6757nojkqi5k4kc1eggy\",\"cot7fjjb68pgn9xdgr4yy3pwfur\",\"c8kkpb6wh7igg7nw88x8nfnwf4c\",\"c9iwbjcg8w38ip8m9xizycdmesc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"cidz4imnqhir48brz6e8hxhfrhy\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\",\"reversed\":false}],\"viewType\":\"board\",\"visibleOptionIds\":[\"424ea5e3-9aa1-4075-8c5c-01b44b66e634\",\"a5yxq8rbubrpnoommfwqmty138h\",\"apht1nt5ryukdmxkh6fkfn6rgoy\",\"aiycbuo3dr5k4xxbfr7coem8ono\",\"aomnawq4551cbbzha9gxnmb3z5w\"],\"visiblePropertyIds\":[\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\"]}',1684139129469,1684139129469,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('vtmbz6e1kabdf7nn73ncnbtk35r','2023-05-15 08:25:40.566147','bjbhs6bos3m8zjouf78xceg9nqw',1,'view','Board view','{\"cardOrder\":[\"cniwb8xwcqtbstbcm3sdfrr854h\",\"cs4qwpzr65fgttd7364dicskanh\",\"c9s78pzbdg3g4jkcdjqahtnfejc\",\"c8utmazns878jtfgtf7exyi9pee\",\"cnobejmb6bf8e3c1w7em5z4pwyh\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"aok6pgecm85qe9k5kcphzoe63ma\",\"aq1dwbf661yx337hjcd5q3sbxwa\",\"ar87yh5xmsswqkxmjq1ipfftfpc\",\"akj3fkmxq7idma55mdt8sqpumyw\"],\"visiblePropertyIds\":[\"aspaay76a5wrnuhtqgm97tt3rer\"]}',1684139140563,1684139140563,0,NULL,'system','','system','b7n3rwgpsspbg9drkn8ztit7yxw'),('vwa8btb3if3rfppqgektkkksyww','2023-05-15 08:25:23.718397','bc41mwxg9ybb69pn9j5zna6d36c',1,'view','Project Priorities','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"d3d682bf-e074-49d9-8df5-7320921c2d23\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{\"\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"87f59784-b859-4c24-8ebe-17c766e081dd\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"98a57627-0f76-471d-850d-91f3ed9fd213\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"d3bfb50f-f569-4bad-8a3a-dd15c3f60101\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"}},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"d3bfb50f-f569-4bad-8a3a-dd15c3f60101\",\"87f59784-b859-4c24-8ebe-17c766e081dd\",\"98a57627-0f76-471d-850d-91f3ed9fd213\",\"\"],\"visiblePropertyIds\":[\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\",\"a8daz81s4xjgke1ww6cwik5w7ye\"]}',1684139123717,1684139123717,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('vx7c7zr5oxjrh7fsfpbep1mhuzo','2023-05-15 08:25:25.633015','',1,'view','By Objectives','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":387,\"a17ryhi1jfsboxkwkztwawhmsxe\":134,\"a6amddgmrzakw66cidqzgk6p4ge\":183,\"aqxyzkdrs4egqf7yk866ixkaojc\":100},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"a6amddgmrzakw66cidqzgk6p4ge\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"a6amddgmrzakw66cidqzgk6p4ge\",\"a17ryhi1jfsboxkwkztwawhmsxe\",\"azzbawji5bksj69sekcs4srm1ky\",\"adp5ft3kgz7r5iqq3tnwg551der\",\"aqxyzkdrs4egqf7yk866ixkaojc\",\"adu6mebzpibq6mgcswk69xxmnqe\",\"asope3bddhm4gpsng5cfu4hf6rh\",\"ajwxp866f9obs1kutfwaa5ru7fe\",\"azqnyswk6s1boiwuthscm78qwuo\",\"ahz3fmjnaguec8hce7xq3h5cjdr\",\"a17bfcgnzmkwhziwa4tr38kiw5r\"]}',1684139125630,1684139125630,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('vx9f7sjs7tiniirhsse5d7iwptc','2023-05-15 08:25:17.583400','',1,'view','Pipeline Tracker','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"akj61wc9yxdwyw3t6m8igyf9d5o\",\"aic89a5xox4wbppi6mbyx6ujsda\",\"ah6ehh43rwj88jy4awensin8pcw\",\"aprhd96zwi34o9cs4xyr3o9sf3c\",\"axesd74yuxtbmw1sbk8ufax7z3a\",\"a5txuiubumsmrs8gsd5jz5gc1oa\",\"acm9q494bcthyoqzmfogxxy5czy\"],\"visiblePropertyIds\":[\"aro91wme9kfaie5ceu9qasmtcnw\",\"amahgyn9n4twaapg3jyxb6y4jic\"]}',1684139117580,1684139117580,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('vxesg73gh878fmbbf378cedsgze','2023-05-15 08:25:25.833106','bm4ubx56krp4zwyfcqh7nxiigbr',1,'view','Departments','{\"cardOrder\":[\"cpa534b5natgmunis8u1ixb55pw\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"azzbawji5bksj69sekcs4srm1ky\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"aw5i7hmpadn6mbwbz955ubarhme\",\"afkxpcjqjypu7hhar7banxau91h\",\"aehoa17cz18rqnrf75g7dwhphpr\",\"agrfeaoj7d8p5ianw5iaf3191ae\",\"agm9p6gcq15ueuzqq3wd4be39wy\",\"aucop7kw6xwodcix6zzojhxih6r\",\"afust91f3g8ht368mkn5x9tgf1o\",\"acocxxwjurud1jixhp7nowdig7y\"],\"visiblePropertyIds\":[]}',1684139125829,1684139125829,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('vy6pu7kjg7bgrxfp1h89d3krh1e','2023-05-15 08:25:41.498342','bui5izho7dtn77xg3thkiqprc9r',1,'view','List: Tasks ?','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"50117d52-bcc7-4750-82aa-831a351c44a0\":139,\"__title\":280},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[{\"condition\":\"includes\",\"propertyId\":\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"values\":[\"6eea96c9-4c61-4968-8554-4b7537e8f748\"]}],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"50117d52-bcc7-4750-82aa-831a351c44a0\",\"reversed\":true}],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"50117d52-bcc7-4750-82aa-831a351c44a0\",\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"60985f46-3e41-486e-8213-2b987440ea1c\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\"]}',1684139141494,1684139141494,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('vyekfi9htpfr8pnc7ea8i6zizsc','2023-05-15 08:25:41.463658','bui5izho7dtn77xg3thkiqprc9r',1,'view','Board: Sprints','{\"cardOrder\":[\"cjztn4z4c53dem8kdnkkq6tc8fa\",\"cffwedhcphjnxdnx7gi5ef487mc\",\"c6sc3f5fjmf8cbcqchzku19mg9a\",\"cbm9y3gmqqjd6uewottgm8mocwh\",\"c4qc8gzhjipf6mmbat9du8ye9kr\",\"c3zpru7o6ibfxup6ej47xu8mc4a\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"60985f46-3e41-486e-8213-2b987440ea1c\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\",\"reversed\":false}],\"viewType\":\"board\",\"visibleOptionIds\":[\"c01676ca-babf-4534-8be5-cce2287daa6c\",\"ed4a5340-460d-461b-8838-2c56e8ee59fe\",\"14892380-1a32-42dd-8034-a0cea32bc7e6\",\"\"],\"visiblePropertyIds\":[\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\"]}',1684139141459,1684139141459,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('vyifygeiis7yefnyg5gu379thdr','2023-05-15 08:25:41.441098','bui5izho7dtn77xg3thkiqprc9r',1,'view','Calendar View','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"a4378omyhmgj3bex13sj4wbpfiy\",\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139141438,1684139141438,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('vyu5phyeg47ncuffagi333r6ofo','2023-05-15 08:25:33.252241','',1,'view','All Users','{\"cardOrder\":[\"ccfkf8w5ntpfx7d7afp8upt6jca\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":280,\"aaebj5fyx493eezx6ukxiwydgty\":146,\"acjq4t5ymytu8x1f68wkggm7ypc\":222,\"akrxgi7p7w14fym3gbynb98t9fh\":131,\"atg9qu6oe4bjm8jczzsn71ff5me\":131},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"akrxgi7p7w14fym3gbynb98t9fh\",\"reversed\":false}],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"aaebj5fyx493eezx6ukxiwydgty\",\"akrxgi7p7w14fym3gbynb98t9fh\",\"atg9qu6oe4bjm8jczzsn71ff5me\",\"acjq4t5ymytu8x1f68wkggm7ypc\",\"aphio1s5gkmpdbwoxynim7acw3e\",\"aqafzdeekpyncwz7m7i54q3iqqy\",\"aify3r761b9w43bqjtskrzi68tr\"]}',1684139133247,1684139133247,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc');
/*!40000 ALTER TABLE `focalboard_blocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_blocks_history`
--

DROP TABLE IF EXISTS `focalboard_blocks_history`;
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

--
-- Dumping data for table `focalboard_blocks_history`
--

LOCK TABLES `focalboard_blocks_history` WRITE;
/*!40000 ALTER TABLE `focalboard_blocks_history` DISABLE KEYS */;
INSERT INTO `focalboard_blocks_history` VALUES ('a14yt5umqginsdnp67tq5ztugkw','2023-05-15 08:25:18.165821','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Post-sales follow up','{\"value\":true}',1684139118159,1684139118159,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a15gffdupj3y4zyxcmhwswreero','2023-05-15 08:25:19.384940','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Send proposal','{}',1684139119373,1684139119373,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a179zkj8ngfbd3k38nkwxpg9wmh','2023-05-15 08:25:19.615023','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'text','## Notes\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.','{}',1684139119607,1684139119606,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a19rb5s9qspdy789wpzat34bdjy','2023-05-15 08:25:38.978591','ck1c13wxrg3fnpxem5d8cu76s4o',1,'text','## Media','{}',1684139138966,1684139138966,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('a1dbxk43ombn4fm1ew8x1qhku3r','2023-05-15 08:25:31.058998','c1axsmo6e5i8tf8xun3qyk57ytr',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139131049,1684139131049,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('a1ewhbrp883bpbjrc89n35buyjh','2023-05-15 08:25:15.941621','cbr1qix816jfyfkm5fcfen13a9e',1,'checkbox','','{\"value\":false}',1684139115936,1684139115936,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a1fj9z7tsejrbux6tbscguca59r','2023-05-15 08:25:34.511408','c485y8w5cnfy47mpyp4mmgbe39r',1,'text','## Interview Notes\n- ...\n- ...\n- ... ','{}',1684139134507,1684139134507,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('a1kiesdgeutgzdyw1ez1ypqzbpe','2023-05-15 08:25:39.074876','ciynnywbiz7rujm5aiphkq3hpmo',1,'text','## Research\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n\n## Notes\n- ...\n- ...','{}',1684139139068,1684139139068,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('a1pu3zj9hpfr1zebdha8j4dp3iw','2023-05-15 08:25:38.955529','ck1c13wxrg3fnpxem5d8cu76s4o',1,'text','## Research\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n\n## Notes\n- ...\n- ...','{}',1684139138947,1684139138947,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('a1u4upynm4jfp5k7q5y9easu5ty','2023-05-15 08:25:36.474928','cs8yd11z8eirpjdf6eu8h1uhpjc',1,'text','## Summary\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.\n## Strengths\n- ...\n- ...\n## Weaknesses\n- ...\n- ...\n## Opportunities\n- ...\n- ...\n## Threats\n- ...\n- ...','{}',1684139136468,1684139136468,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('a1u5t8yxj5jn7dpd1m4gjty71yr','2023-05-15 08:25:18.666735','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Send initial email','{\"value\":false}',1684139118660,1684139118660,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a1wp1k1zieighmg39wyjjygcxre','2023-05-15 08:25:23.758650','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'checkbox','[Subtask 3]','{\"value\":false}',1684139123756,1684139123756,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('a38oj36uc8iys5c6adxsw1korzy','2023-05-15 08:25:18.653886','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Hand-off to customer success','{}',1684139118647,1684139118647,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a3anidddoojytdns14cexrxbo9c','2023-05-15 08:25:15.767170','corc1ng7xtbdqx8po63utq491ro',1,'checkbox','','{\"value\":false}',1684139115762,1684139115762,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a3du3x3wpsfdtidw5xsdt1714ze','2023-05-15 08:25:15.894953','cywrn8u5uqjba9d7dmzk6xrowoe',1,'checkbox','','{\"value\":false}',1684139115892,1684139115892,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a3hdpmeq3zbfrtfgoqafmey7eia','2023-05-15 08:25:44.545679','ctqcabnjrgpbr3pw5nf6q1cugzr',1,'text','Keep stakeholders and customers up-to-date on project progress by sharing your board.','{}',1684139144539,1684139144539,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('a3njt16yxsff4xgy6a7esb9acza','2023-05-15 08:25:17.996066','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Schedule initial sales call','{\"value\":true}',1684139117989,1684139117989,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a3of5ugr877yxufkiujjb5gcooa','2023-05-15 08:25:15.960196','ckf7h5amk87fftmj33mk5gf78ih',1,'divider','','{}',1684139115957,1684139115957,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a3rbis1zhofnefmroitqsp1bcce','2023-05-15 08:25:44.787302','cqmgjgha55p8ktp9wo46nksj5qo',1,'text','Customize cards to fit your needs and track the information most important to you. Boards supports a wide range of fully customizable property types. For example, you can:\n- Use the **Date** property for things like deadlines or milestones.\n- Assign owners to tasks with the **Person** property.\n- Define statuses and priorities with the **Select** property.\n- Create tags with the **Multi Select** property.\n- Link cards to webpages with the **URL** property.','{}',1684139144779,1684139144779,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('a3xqbjspfy3bmpek81gk3jcqd9r','2023-05-15 08:25:18.192471','cdykszx7gffnibcgf4p9gzdit9a',1,'text','## Notes\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.','{}',1684139118186,1684139118186,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a43erpy3dgbg5pr7z8xhogczaqh','2023-05-15 08:25:21.635172','cncphrte4e7b8zke1wcjoia415w',1,'checkbox','Bread','{\"value\":false}',1684139121629,1684139121629,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('a44hj6n51d3bdzfkkbczsgrmhpw','2023-05-15 08:25:18.100603','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Finalize contract','{\"value\":true}',1684139118094,1684139118094,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a49urkhwkbtr18qeqq8k7kfncho','2023-05-15 08:25:22.117715','c48fsy6msutb6i8pcnd7axut6kr',1,'text','## Route','{}',1684139122111,1684139122111,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('a4d4xc3pcx3fxtj6d66gmgam3nc','2023-05-15 08:25:36.488477','cj4fk3wp3rtn1dyeci9basq1w5o',1,'text','## Summary\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.\n\n## Strengths\n- ...\n- ...\n## Weaknesses\n- ...\n- ...\n## Opportunities\n- ...\n- ...\n## Threats\n- ...\n- ...','{}',1684139136481,1684139136481,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('a4gqcqo3h1bn1xkn7cycwj4k6rc','2023-05-15 08:25:15.830506','ch798q5ucefyobf5bymgqjt4f3h',1,'divider','','{}',1684139115816,1684139115816,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a4oacqw9rgtbo5ri9wzijhz1wdw','2023-05-15 08:25:23.767885','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'text','## Description\n*[Brief description of this task]*','{}',1684139123765,1684139123765,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('a4zjojnhsrbfkzbf5ukno7g6yey','2023-05-15 08:25:21.589649','ci6nx4shmpffitmrx951e4oiptw',1,'checkbox','Mobile phone','{\"value\":true}',1684139121584,1684139121584,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('a5g5byxhrgpdrbn3k8z3xor3btr','2023-05-15 08:25:23.832033','cwjh3qjukx38gipog474tobdb3w',1,'text','## Checklist','{}',1684139123829,1684139123829,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('a5jcamahzc7rcdn8rawt9jqs7jh','2023-05-15 08:25:41.780004','cwrq9ag3p5pgzzy98nfd3wwra1w',1,'text','## Summary\n*[Brief description of what this epic is about]*\n## Motivation\n*[Brief description on why this is needed]*\n## Acceptance Criteria\n- *[Criteron 1]*\n- *[Criteron 2]*\n- ...\n## Personas\n- *[Persona A]*\n- *[Persona B]*\n- ...\n## Reference Materials\n- *[Links to other relevant documents as needed]*\n- ...','{}',1684139141769,1684139141769,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('a5ooaofewzinbfn4bczt4ykp3we','2023-05-15 08:25:32.090780','c9iwbjcg8w38ip8m9xizycdmesc',1,'text','## Summary\n*[Brief description of what this epic is about]*\n\n## Motivation\n*[Brief description on why this is needed]*\n\n## Acceptance Criteria\n - *[Criteron 1]*\n - *[Criteron 2]*\n - ...\n\n## Personas\n - *[Persona A]*\n - *[Persona B]*\n - ...\n\n## Reference Materials\n - *[Links to other relevant documents as needed]*\n - ...','{}',1684139132084,1684139132084,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('a5owboss9ytnwzqsg838ax9c7sa','2023-05-15 08:25:18.413335','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Schedule initial sales call','{\"value\":true}',1684139118406,1684139118406,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a5w8x3eswhiyojrmstdzo593nhr','2023-05-15 08:25:17.741406','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Send proposal','{\"value\":true}',1684139117734,1684139117734,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a66pjy1kyx3fw5exrswewq76pbr','2023-05-15 08:25:15.839353','ch798q5ucefyobf5bymgqjt4f3h',1,'checkbox','','{\"value\":false}',1684139115835,1684139115835,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a676u5r9tbpnsumpr67ea3zo6qw','2023-05-15 08:25:44.427993','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Set priorities and update statuses','{\"value\":false}',1684139144420,1684139144420,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('a6etuyneqg3n4jyfr7zn6aqsgia','2023-05-15 08:25:15.852955','ch798q5ucefyobf5bymgqjt4f3h',1,'checkbox','','{\"value\":false}',1684139115850,1684139115850,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('a6fageyupsfbyfqebz7opgx9sqy','2023-05-15 08:25:44.653043','ckjptgsceu3fq5fmjmn9d7ugpiw',1,'text','After you\'ve copied the link, paste it into any channel or Direct Message to share the card. A preview of the card will display within the channel with a link back to the card on Boards.','{}',1684139144646,1684139144646,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('a74eggha9pigfmcqrt5hq8fo6ny','2023-05-15 08:25:24.410327','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'checkbox','[Subtask 3]','{\"value\":false}',1684139124403,1684139124403,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('a873fa3hbs3ytumfax4m65fwzgc','2023-05-15 08:25:44.506014','c8x3s1st6ijfzuxhrf5aaei76my',1,'text','A board helps you manage your project, organize tasks, and collaborate with your team all in one place.','{}',1684139144499,1684139144499,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('a87rgrpj9hj8i8egtxphp9qt7rr','2023-05-15 08:25:44.054349','cwchj4bcga7b558k6waqjian4ey',1,'text','Mattermost Boards makes it easy for you to update certain properties on cards through our drag and drop functionality. Simply drag this card from the **Later** column to the **Completed** column to automatically update the status and mark this task as complete.','{}',1684139144046,1684139144046,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('a8m4xntgjujnu9pr359cxagaiqa','2023-05-15 08:25:32.064087','cfmk7771httynm8r7rm8cbrmrya',1,'text','## Steps to reproduce the behavior\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n*[A clear and concise description of what you expected to happen.]*\n\n## Edition and Platform\n- Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n- Version: *[e.g. v0.9.0]*\n- Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n*[Add any other context about the problem here.]*','{}',1684139132057,1684139132057,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('a8qa1t9oegpdtxr1w8inab4o19c','2023-05-15 08:25:21.612261','cncphrte4e7b8zke1wcjoia415w',1,'checkbox','Cereal','{\"value\":false}',1684139121606,1684139121606,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('a91j3t8w9fbye5datoay1to58ho','2023-05-15 08:25:39.004743','cff1jmrxfrirgbeebhr9qd7nida',1,'text','## Research\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n\n## Notes\n- ...\n- ...','{}',1684139138986,1684139138986,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('a94xcxp1iu7yxfxzcide3nkh81o','2023-05-15 08:25:18.718516','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Schedule follow-up sales call','{\"value\":false}',1684139118712,1684139118712,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a96ku8fdcoirf3gcnhs84ro7wce','2023-05-15 08:25:23.827457','cwjh3qjukx38gipog474tobdb3w',1,'text','## Description\n*[Brief description of this task]*','{}',1684139123825,1684139123825,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('a9bqmd5hph3bkpgc1bu6j95btqa','2023-05-15 08:25:19.493240','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Schedule initial sales call','{\"value\":false}',1684139119486,1684139119486,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a9jwwi6qx1j85zpkkr9nfkkkxda','2023-05-15 08:25:21.600795','ci6nx4shmpffitmrx951e4oiptw',1,'checkbox','Internet','{\"value\":true}',1684139121595,1684139121595,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('a9k51ioai67fmjnqsmjwezs1fbe','2023-05-15 08:25:17.850700','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'text','## Checklist','{}',1684139117844,1684139117844,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('a9xctw6b81bgrfju1a5hwcq36ra','2023-05-15 08:25:31.989024','cipuiirpksj84xjb69fzyjorysr',1,'text','## Steps to reproduce the behavior\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n*[A clear and concise description of what you expected to happen.]*\n\n## Edition and Platform\n- Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n- Version: *[e.g. v0.9.0]*\n- Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n*[Add any other context about the problem here.]*','{}',1684139131134,1684139131134,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('a9yckxr9rbpyqbx8wxjc5c5tkgc','2023-05-15 08:25:19.530156','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Post-sales follow up','{}',1684139119501,1684139119501,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aa6m58nop8jd5pg94uzgbtkr9dw','2023-05-15 08:25:32.036811','cipuiirpksj84xjb69fzyjorysr',1,'text','## Screenshots\n*[If applicable, add screenshots to elaborate on the problem.]*','{}',1684139132029,1684139132029,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('aa6w5auxnw3d83dioa7ztm54i7o','2023-05-15 08:25:34.484777','cu91c9dt6otycpm7pnep9rgn8ky',1,'text','## Interview Notes\n- ...\n- ...\n- ... ','{}',1684139134480,1684139134479,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('aah9qr9gabiykuxy85dfmojep4r','2023-05-15 08:25:23.781662','cqfonaty9ifrg9mxbr5xk5fyowo',1,'checkbox','[Subtask 1]','{\"value\":false}',1684139123779,1684139123779,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aaigoezzch3fy9knkd3gdjczqzw','2023-05-15 08:25:17.799285','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Hand-off to customer success','{}',1684139117792,1684139117792,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aasewtfi5nigy5feaxy6ps8a53y','2023-05-15 08:25:17.885446','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Send initial email','{\"value\":true}',1684139117873,1684139117873,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ab5zk7prdiiyopkqnb97ntnxqxh','2023-05-15 08:25:21.661758','cncphrte4e7b8zke1wcjoia415w',1,'checkbox','Bananas','{\"value\":false}',1684139121656,1684139121656,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('ab7k61ow3str93y8yt4xzt6fx1h','2023-05-15 08:25:24.439350','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'checkbox','[Subtask 2]','{\"value\":false}',1684139124432,1684139124432,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ac4aoo5dcz38gmbd6yrwwzuy94c','2023-05-15 08:25:21.672792','cncphrte4e7b8zke1wcjoia415w',1,'checkbox','Eggs','{\"value\":false}',1684139121667,1684139121667,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('ac8chzuh3bbrj78copndmi6p38r','2023-05-15 08:25:44.709073','c8xeju51trbg38x6xq6spazwsnc',1,'text','Organize and find the cards you\'re looking for with our filter, sort, and grouping options. From the Board header, you can quickly toggle on different properties, change the group display, set filters, and change how the cards are sorted.','{}',1684139144701,1684139144701,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('acjb5kah4xp835qecaxb6n7nfah','2023-05-15 08:25:18.640263','c7ho5n7y4t7fyimowcpjxuumtea',1,'text','## Checklist','{}',1684139118633,1684139118633,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('acok1kgr63fdhxyc75nx7y1cnpc','2023-05-15 08:25:21.623736','cncphrte4e7b8zke1wcjoia415w',1,'checkbox','Butter','{\"value\":false}',1684139121618,1684139121618,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('acxfipystmbympxztfx5kiqosry','2023-05-15 08:25:19.557507','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Hand-off to customer success','{}',1684139119540,1684139119540,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ad1zwi9jox7dk5njpgjd46briih','2023-05-15 08:25:32.146953','c8z9b6w6757nojkqi5k4kc1eggy',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139132140,1684139132140,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ad3t6abgiytfx3p5cp4tdj7t33a','2023-05-15 08:25:44.680454','ckjptgsceu3fq5fmjmn9d7ugpiw',1,'text','Cards can be linked and shared with teammates directly on Channels. Card previews are displayed when shared on Channels, so your team can discuss work items and get the relevant context without having to switch over to Boards.','{}',1684139144674,1684139144674,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ad4jkwdrk8tygixputknzh3tm9e','2023-05-15 08:25:24.395718','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'checkbox','[Subtask 1]','{\"value\":false}',1684139123839,1684139123839,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ad4napirz73dpzp944nognud99o','2023-05-15 08:25:23.790977','cqfonaty9ifrg9mxbr5xk5fyowo',1,'divider','','{}',1684139123788,1684139123788,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ad65s85n7c3y8pctg9nfdd6z3dc','2023-05-15 08:25:18.757221','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Schedule initial sales call','{\"value\":false}',1684139118750,1684139118750,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('adb14fy97ktr79grpj9dzd3pomh','2023-05-15 08:25:44.468135','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Manage deadlines and milestones','{\"value\":false}',1684139144462,1684139144461,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('adddhxyhoyp8tfme6amns76ssth','2023-05-15 08:25:24.504265','cwzr9jf3kbpnobqdx18edtbxyze',1,'divider','','{}',1684139124498,1684139124498,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('adyads1uwsj8qfeq5mfh4jaz18a','2023-05-15 08:25:18.430030','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Finalize contract','{}',1684139118422,1684139118421,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ae4ya94cgbj8gjfmahfw5dosu7e','2023-05-15 08:25:18.009323','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Send follow-up email','{\"value\":true}',1684139118002,1684139118002,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ae8cp3nwpc3g3m8ujo9rcsd7p4c','2023-05-15 08:25:24.491600','cwzr9jf3kbpnobqdx18edtbxyze',1,'checkbox','[Subtask 3]','{\"value\":false}',1684139124485,1684139124485,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aecekjo6toigp9k9izqesci8uuw','2023-05-15 08:25:32.050402','cuadbgz3yhpbwxcdaco3xhhzqic',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139132043,1684139132043,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('aeh7xbty5s7nhzbtk8181cn778h','2023-05-15 08:25:39.044231','cff1jmrxfrirgbeebhr9qd7nida',1,'text','## Research\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n\n## Notes\n- ...\n- ...','{}',1684139139034,1684139139034,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('aenz8dktc4ifxdgerg1o5m4tgfc','2023-05-15 08:25:17.956913','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Finalize contract','{}',1684139117950,1684139117950,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aeoe3d6d8zbnwjfwcpmbzgmicir','2023-05-15 08:25:15.911845','cywrn8u5uqjba9d7dmzk6xrowoe',1,'text','## Action Items','{}',1684139115907,1684139115907,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('aeorq3aruibgampujchzws9um7r','2023-05-15 08:25:41.577030','cjztn4z4c53dem8kdnkkq6tc8fa',1,'text','## Screenshots\n*[If applicable, add screenshots to elaborate on the problem.]*','{}',1684139141570,1684139141570,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('aepo996a5ainqbr1syz3u19oxuy','2023-05-15 08:25:41.674049','cfefgwjke6bbxpjpig618g9bpte',1,'text','## Steps to reproduce the behavior\n\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n\n*[A clear and concise description of what you expected to happen.]*\n\n## Screenshots\n\n*[If applicable, add screenshots to elaborate on the problem.]*\n\n## Edition and Platform\n\n - Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n - Version: *[e.g. v0.9.0]*\n - Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n\n*[Add any other context about the problem here.]*','{}',1684139141667,1684139141667,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('aeqhexi8j9pykich95cew93h6dh','2023-05-15 08:25:15.986008','ckf7h5amk87fftmj33mk5gf78ih',1,'text','## Notes\n*[Add meeting notes here]*','{}',1684139115983,1684139115983,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('aeqr1qzecppgkjqhe7obwf1ehxy','2023-05-15 08:25:41.712702','cidz4imnqhir48brz6e8hxhfrhy',1,'text','## Requirements\n- [Requirement 1]\n- [Requirement 2]\n- ...','{}',1684139141706,1684139141706,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('aerxw6a5f6tbq5cfuo97h1dcp1w','2023-05-15 08:25:38.900907','cb89odozjd788py34ggamhsyo1h',1,'text','## Research\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n\n## Notes\n- ...\n- ...','{}',1684139138885,1684139138885,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('aeuc3ii3akir43j81makf3hxuay','2023-05-15 08:25:39.061131','c8n4xu7ntq7bbbd14noats457ro',1,'text','## Research\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n\n## Notes\n- ...\n- ...','{}',1684139139053,1684139139052,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('aeyxha9paaf8etxhfbkyqcmd9qa','2023-05-15 08:25:24.555587','cwzr9jf3kbpnobqdx18edtbxyze',1,'text','## Checklist','{}',1684139124549,1684139124549,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('afbqaohnf8fdi7k43xo86jcri1a','2023-05-15 08:25:18.539765','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Post-sales follow up','{}',1684139118533,1684139118533,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('afbrk7aqnsigijbmueau4r1mhzy','2023-05-15 08:25:44.813571','cyw3bxrbfepf3tq4m8yfag5h3wo',1,'text','To mention a teammate use the **@ symbol with their username** in the comments or description section. They\'ll get a Direct Message notification via Channels and also be added as a [follower](https://docs.mattermost.com/boards/work-with-cards.html#receive-updates) to the card. \n\nWhenever any changes are made to the card, they\'ll automatically get notified on Channels.','{}',1684139144807,1684139144807,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('afgz6ufu6xjbdpjke4gjhxrzbpa','2023-05-15 08:25:18.022380','cow8jauqkabgb8etq9ckdo8nhrh',1,'text','## Notes\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.','{}',1684139118016,1684139118015,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('afniyj7y9hbbabkshk1bdoiekjc','2023-05-15 08:25:18.705278','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Send follow-up email','{\"value\":false}',1684139118698,1684139118698,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('afst5iycoy3rhixsdjihf3peoey','2023-05-15 08:25:17.864587','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'text','## Notes\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.','{}',1684139117857,1684139117857,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ag34x3ougupbrfd5ypsbrqueb5e','2023-05-15 08:25:44.585766','cbokq5iftypbs3gspcn15kp1u4r',1,'text','To create a new card, simply do any of the following:\n- Select \"**New**\" on the top right header\n- Select \"**+ New**\" below any column\n- Select \"**+**\" to the right of any columnn header','{}',1684139144579,1684139144579,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ag351ba8q87rjzy868zsaoxu36y','2023-05-15 08:25:41.591873','cffwedhcphjnxdnx7gi5ef487mc',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139141585,1684139141585,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('agbstqsrjejd6iemscpeixjpj8o','2023-05-15 08:25:18.382716','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Schedule follow-up sales call','{\"value\":true}',1684139118375,1684139118375,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('agdze3c4gu78m5bke4qwwpigika','2023-05-15 08:25:44.827885','cyw3bxrbfepf3tq4m8yfag5h3wo',1,'text','Collaborate with teammates directly on each card using @mentions and have all the relevant context in one place.','{}',1684139144821,1684139144821,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('age6hf4ppq3gy7y8y44mhrdsifr','2023-05-15 08:25:18.457619','c8tf9wun9gtyc7bzize8f513eqc',1,'text','## Notes\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.','{}',1684139118451,1684139118451,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ageiia35pfjrsfcdyn6fbxbtt4r','2023-05-15 08:25:19.404686','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Send initial email','{\"value\":true}',1684139119395,1684139119395,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('agh8493dxoff6ucoi993ym6o1cw','2023-05-15 08:25:18.113711','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Schedule follow-up sales call','{\"value\":true}',1684139118107,1684139118107,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('agjiprrojcjyg9x9q7kxe8n8eyr','2023-05-15 08:25:36.461969','c4htpxn8wxpd6pffpjo4u8xxxxc',1,'text','## Summary\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.\n## Strengths\n- ...\n- ...\n## Weaknesses\n- ...\n- ...\n## Opportunities\n- ...\n- ...\n## Threats\n- ...\n- ...','{}',1684139136455,1684139136455,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('agp4hy9m6hjbkdqtohoeia1yenh','2023-05-15 08:25:21.647810','cncphrte4e7b8zke1wcjoia415w',1,'checkbox','Milk','{\"value\":false}',1684139121641,1684139121641,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('agpfti6dum7f1tg3uid8uy1wbza','2023-05-15 08:25:17.969751','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Post-sales follow up','{}',1684139117963,1684139117963,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('agzumfpbi1bg37gj3d7zkwj8c1o','2023-05-15 08:25:31.110085','cot7fjjb68pgn9xdgr4yy3pwfur',1,'text','## Screenshots\n*[If applicable, add screenshots to elaborate on the problem.]*','{}',1684139131103,1684139131103,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ah8yjnketf7rcxyegsef1gmkjow','2023-05-15 08:25:18.580138','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Schedule demo','{\"value\":false}',1684139118572,1684139118572,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ahact8zrmctbnzknxe9udhawjfe','2023-05-15 08:25:19.597474','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'text','## Checklist','{}',1684139119587,1684139119587,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ahcc7baon8irodktqpfj1db4mdw','2023-05-15 08:25:34.504272','c8ra694tq4bfm5czq11g6wnq3re',1,'text','## Interview Notes\n- ...\n- ...\n- ... ','{}',1684139134501,1684139134501,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('ahd73ykmw6pd9bqqwsppk6wx9ty','2023-05-15 08:25:18.484402','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Schedule initial sales call','{\"value\":false}',1684139118477,1684139118477,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ahf6q3fi9xtykfjcmx4sibf67cw','2023-05-15 08:25:21.578254','ci6nx4shmpffitmrx951e4oiptw',1,'checkbox','Utilities','{\"value\":true}',1684139121572,1684139121572,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('ahpe1ytxnebr5zgh3ryz31u8fxh','2023-05-15 08:25:41.659127','cfefgwjke6bbxpjpig618g9bpte',1,'text','## Steps to reproduce the behavior\n\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n\nA clear and concise description of what you expected to happen.\n\n## Edition and Platform\n\n - Edition: Personal Desktop / Personal Server / Mattermost plugin\n - Version: [e.g. v0.9.0]\n - Browser and OS: [e.g. Chrome 91 on macOS, Edge 93 on Windows]\n\n## Additional context\n\nAdd any other context about the problem here.','{}',1684139141649,1684139141649,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('ahpm1u53gepnn5c5mnkp68radgh','2023-05-15 08:25:22.104127','c48fsy6msutb6i8pcnd7axut6kr',1,'text','## Goal\nWalk at least 10,000 steps every day.','{}',1684139122096,1684139122096,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('ai9de4de7atrujridwbungisg6o','2023-05-15 08:25:15.846492','ch798q5ucefyobf5bymgqjt4f3h',1,'checkbox','','{\"value\":false}',1684139115843,1684139115843,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('aidjkys6sw387xd5d5yxqsr7cqe','2023-05-15 08:25:19.478428','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Schedule demo','{\"value\":false}',1684139119471,1684139119471,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aif8a8d7kjfrg5k8ni856wp454r','2023-05-15 08:25:23.776996','cqfonaty9ifrg9mxbr5xk5fyowo',1,'checkbox','...','{\"value\":false}',1684139123774,1684139123774,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aihg18paddjdimcdnh71bjwkhoo','2023-05-15 08:25:18.731196','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Send proposal','{}',1684139118725,1684139118725,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aikzfeo3qytg9bym53moh3iwryo','2023-05-15 08:25:31.095172','cot7fjjb68pgn9xdgr4yy3pwfur',1,'text','## Steps to reproduce the behavior\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n*[A clear and concise description of what you expected to happen.]*\n\n## Edition and Platform\n- Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n- Version: *[e.g. v0.9.0]*\n- Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n*[Add any other context about the problem here.]*','{}',1684139131088,1684139131087,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ainarjkocuiduxrbb63t9xoyper','2023-05-15 08:25:17.767862','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Schedule initial sales call','{\"value\":true}',1684139117761,1684139117761,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aip3g6feocp8i9fbxf8mtnsomny','2023-05-15 08:25:23.786357','cqfonaty9ifrg9mxbr5xk5fyowo',1,'checkbox','[Subtask 3]','{\"value\":false}',1684139123784,1684139123784,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aiw8kpb5u1tnmxqkq6p5tpybdqc','2023-05-15 08:25:23.744853','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'checkbox','[Subtask 2]','{\"value\":false}',1684139123742,1684139123742,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aixwwtex9ofbo58tws4p8kzzzhh','2023-05-15 08:25:18.625894','c7ho5n7y4t7fyimowcpjxuumtea',1,'text','## Notes\n[Enter notes here...]','{}',1684139118618,1684139118618,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aj3idc59csjbhupc81cr5drn1eh','2023-05-15 08:25:18.074838','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Send follow-up email','{\"value\":true}',1684139118068,1684139118068,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ajg45nyrs7jyubdb8ugpjrasctc','2023-05-15 08:25:19.460656','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Schedule follow-up sales call','{\"value\":false}',1684139119453,1684139119452,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ajguuc7nfctfptbaq8k1cnz7smc','2023-05-15 08:25:32.132917','cec73iz548tyzfeagiummkqyh6c',1,'text','## Screenshots\n*[If applicable, add screenshots to elaborate on the problem.]*','{}',1684139132126,1684139132126,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ajgws6yq75tgm3yg8u39gs9mana','2023-05-15 08:25:17.928398','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Send proposal','{\"value\":true}',1684139117919,1684139117919,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ajofqzk5biighxbxuu5hrz9hqrr','2023-05-15 08:25:17.754729','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Finalize contract','{}',1684139117748,1684139117748,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ajuuacx8d33f19nha8m71pbwuih','2023-05-15 08:25:18.744122','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Follow up after demo','{}',1684139118737,1684139118737,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ak16ghrgwzpfcibwxfaensud9ch','2023-05-15 08:25:23.795502','cqfonaty9ifrg9mxbr5xk5fyowo',1,'text','## Checklist','{}',1684139123793,1684139123793,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ak6e7c8z5k7yr9gzcss76ndkmna','2023-05-15 08:25:15.811656','corc1ng7xtbdqx8po63utq491ro',1,'text','## Action Items','{}',1684139115806,1684139115806,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('ak7rktdxk4tbtuxuitq5p37ficr','2023-05-15 08:25:18.524134','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Finalize contract','{}',1684139118516,1684139118516,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('akft6riy6zfgwbjowd4746t431o','2023-05-15 08:25:15.870839','ch798q5ucefyobf5bymgqjt4f3h',1,'text','# Notes\n*[Add meeting notes here]*','{}',1684139115864,1684139115864,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('akgbx1ddui38sirbij6aan5sbur','2023-05-15 08:25:24.543090','cwzr9jf3kbpnobqdx18edtbxyze',1,'text','## Description\n*[Brief description of this task]*','{}',1684139124536,1684139124536,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('akja3h5qikjrzxmutooteo9196a','2023-05-15 08:25:23.772592','cqfonaty9ifrg9mxbr5xk5fyowo',1,'checkbox','[Subtask 2]','{\"value\":false}',1684139123770,1684139123770,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('akqw19ofqotr78g78jobfykj3ia','2023-05-15 08:25:41.762918','cbm9y3gmqqjd6uewottgm8mocwh',1,'text','## Steps to reproduce the behavior\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n*[A clear and concise description of what you expected to happen.]*\n\n## Edition and Platform\n- Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n- Version: *[e.g. v0.9.0]*\n- Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n*[Add any other context about the problem here.]*','{}',1684139141756,1684139141756,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('aksausnmc93dtjjzu86yuqeedze','2023-05-15 08:25:18.035686','cow8jauqkabgb8etq9ckdo8nhrh',1,'text','## Checklist','{}',1684139118029,1684139118029,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('am6o87kzyk7gymeyhkq4p48zd1c','2023-05-15 08:25:15.916926','cywrn8u5uqjba9d7dmzk6xrowoe',1,'text','## Notes\n*[Add meeting notes here]*','{}',1684139115914,1684139115914,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('am8qkb9prmtrxjp5gdjgq6quizc','2023-05-15 08:25:18.771282','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Schedule demo','{\"value\":false}',1684139118763,1684139118763,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('amf64og7po7dnxdir6idmyk1qnw','2023-05-15 08:25:32.186784','cczudbnf113g1fezgjcbj8wqd9h',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139132180,1684139132180,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('amho5gxfybbrt5n3ko48x5d8pny','2023-05-15 08:25:41.687037','c4qc8gzhjipf6mmbat9du8ye9kr',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139141680,1684139141680,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('amiis7xbrqtf6dc8ww13heeg6aw','2023-05-15 08:25:15.954420','cbr1qix816jfyfkm5fcfen13a9e',1,'text','## Notes\n*[Add meeting notes here]*','{}',1684139115951,1684139115951,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('amw9356bg67rr881axj93ca7boo','2023-05-15 08:25:23.749597','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'divider','','{}',1684139123747,1684139123747,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('amxzpzr3pf3y49pjgrraceemn7h','2023-05-15 08:25:15.965312','ckf7h5amk87fftmj33mk5gf78ih',1,'checkbox','','{\"value\":false}',1684139115962,1684139115962,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('an1cauynf7i87md78gocifotujo','2023-05-15 08:25:23.809164','cwjh3qjukx38gipog474tobdb3w',1,'checkbox','[Subtask 2]','{\"value\":false}',1684139123807,1684139123807,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('an1ni5jxrkibi3f4pe1wis5kdha','2023-05-15 08:25:18.497605','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Schedule follow-up sales call','{\"value\":false}',1684139118491,1684139118491,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('an3gwsu6ztjrfixpmhdahaqt63h','2023-05-15 08:25:19.425164','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Follow up after demo','{}',1684139119411,1684139119411,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('an935fht14fr8mpjo99fuwaw4zo','2023-05-15 08:25:18.087325','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Send proposal','{\"value\":true}',1684139118081,1684139118081,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('anihyopcbefgpueysxaqwg8emwr','2023-05-15 08:25:19.444687','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Finalize contract','{}',1684139119437,1684139119437,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('anjsttbf3tpbntpgmy63kegm3yc','2023-05-15 08:25:44.558564','ctqcabnjrgpbr3pw5nf6q1cugzr',1,'text','To share a board, select **Share** at the top right of the Board view. Copy the link to share the board internally with your team or generate public link that can be accessed by anyone externally.','{}',1684139144552,1684139144552,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ank4fqmyfotyi9x18g5x1h83d3h','2023-05-15 08:25:23.739529','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'checkbox','[Subtask 1]','{\"value\":false}',1684139123737,1684139123737,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('anoje9s1eqjgrbjierpddcjjych','2023-05-15 08:25:15.796015','corc1ng7xtbdqx8po63utq491ro',1,'checkbox','','{\"value\":false}',1684139115791,1684139115791,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('ansjzguztbiffmmesd9nfrmjz7h','2023-05-15 08:25:44.480328','c1skdp9t1mtnjbxcmoshjj94x8a',1,'text','Cards allow your entire team to manage and collaborate on a task in one place. Within a card, your team can:','{}',1684139144474,1684139144474,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('anuotdyg8ajfo7guetz5npmznqy','2023-05-15 08:25:18.233036','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Hand-off to customer success','{}',1684139118226,1684139118226,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('anxrc977em3gcbj6tuuz3pjse4w','2023-05-15 08:25:18.443970','c8tf9wun9gtyc7bzize8f513eqc',1,'text','## Checklist','{}',1684139118437,1684139118437,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ao5e371hhsid19pys4u7xjngpsr','2023-05-15 08:25:18.679638','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Post-sales follow up','{}',1684139118673,1684139118673,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ao9bnrjmwfb8o8mb4maqr4hjpne','2023-05-15 08:25:18.139406','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Schedule demo','{\"value\":true}',1684139118132,1684139118132,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aoem1zdrjnid3ineo4tene5xo4o','2023-05-15 08:25:18.611286','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Follow up after demo','{}',1684139118603,1684139118603,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aof79cphr9jdntgcw74deqwjypc','2023-05-15 08:25:17.899648','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Schedule follow-up sales call','{\"value\":true}',1684139117893,1684139117893,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aoi7yahtppir47cuch69s1mbrde','2023-05-15 08:25:24.453231','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'text','## Checklist','{}',1684139124446,1684139124446,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aor7ibfgeqj8a7roum58xqcjy5o','2023-05-15 08:25:24.618773','czw9es1e89fdpjr7cqptr1xq7qh',1,'checkbox','...','{\"value\":false}',1684139124612,1684139124612,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aosqp85sp5pbkzfhqkc9f9kx9br','2023-05-15 08:25:18.471290','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Send initial email','{\"value\":false}',1684139118464,1684139118464,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aouftfp6ui3nhz8y3rwwzarnoky','2023-05-15 08:25:21.684258','cncphrte4e7b8zke1wcjoia415w',1,'text','## Grocery list','{}',1684139121678,1684139121678,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('aoxteiun1cj85ppwpw935htrify','2023-05-15 08:25:23.836759','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'divider','','{}',1684139123834,1684139123834,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aoy8dg4jgbfdp8pdm9ga1uk3rrw','2023-05-15 08:25:24.466419','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'text','## Description\n*[Brief description of this task]*','{}',1684139124460,1684139124460,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ap85qk77cspb33rwkgj1f6t5saa','2023-05-15 08:25:15.975751','ckf7h5amk87fftmj33mk5gf78ih',1,'checkbox','','{\"value\":false}',1684139115973,1684139115973,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('apbwgk8edpfnwfkt3gn7m89awce','2023-05-15 08:25:19.355845','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'text','## Notes\n[Enter notes here...]','{}',1684139118791,1684139118791,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('apcmmc1nr47dbfjsue7g8rzjk1h','2023-05-15 08:25:32.160171','cpx6a1cf3u7b73gsdmmehw7gx7c',1,'text','## Summary\n*[Brief description of what this epic is about]*\n\n## Motivation\n*[Brief description on why this is needed]*\n\n## Acceptance Criteria\n - *[Criteron 1]*\n - *[Criteron 2]*\n - ...\n\n## Personas\n - *[Persona A]*\n - *[Persona B]*\n - ...\n\n## Reference Materials\n - *[Links to other relevant documents as needed]*\n - ...','{}',1684139132153,1684139132153,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('aphzuak83niydzqmomg8kerrjzo','2023-05-15 08:25:17.728095','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Send follow-up email','{\"value\":true}',1684139117722,1684139117721,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('apj4n919rn3n5tn44dzozi43b9a','2023-05-15 08:25:44.737281','czphuqnioo7fydrsb8pu7qrosgw',1,'text','Views allow your team to visualize the same cards and data from different perspectives, so they can stay up-to-date in the way that works best for them. To add a new view, go to **Add a new view** from the view drop-down, then select from any of the following views:\n\n- **Board**: Adds a Kanban board, similar to this one, that allows your team to organize cards in swimlanes grouped by any property of your choosing. This view helps you visualize your project progress.\n- **Table**: Displays cards in a table format with rows and columns. Use this view to get an overview of all your project tasks. Easily view and compare the state of all properties across all cards without needing to open individual cards.\n- **Gallery**: Displays cards in a gallery format, so you can manage and organize cards with image attachments.\n- **Calendar**: Adds a calendar view to easily visualize your cards by dates and keep track of deadlines.','{}',1684139144730,1684139144730,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('apjxwm8wbai8puqi5hsyu16ex4a','2023-05-15 08:25:18.179314','cdykszx7gffnibcgf4p9gzdit9a',1,'text','## Checklist','{}',1684139118172,1684139118172,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('apo1h5w4debdjmr9usxauqtqwby','2023-05-15 08:25:15.947907','cbr1qix816jfyfkm5fcfen13a9e',1,'text','## Action Items','{}',1684139115944,1684139115944,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('apqufugtc63fstkgchiayik9uze','2023-05-15 08:25:24.631445','czw9es1e89fdpjr7cqptr1xq7qh',1,'text','## Description\n*[Brief description of this task]*','{}',1684139124625,1684139124625,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aqenhkcet77f1tmexfzbdqu1auo','2023-05-15 08:25:36.516269','c98nnstjzhbgmpj6g88rgpgnheh',1,'text','## Summary\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.\n## Strengths\n- ...\n- ...\n## Weaknesses\n- ...\n- ...\n## Opportunities\n- ...\n- ...\n## Threats\n- ...\n- ...','{}',1684139136509,1684139136509,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('aqfzsxtdkjf8fxn68you4bs5tmw','2023-05-15 08:25:17.715179','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Send initial email','{\"value\":true}',1684139117708,1684139117708,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aqpusoh9o8bndupb7m9sbpqcbmr','2023-05-15 08:25:17.811822','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Follow up after demo','{\"value\":true}',1684139117805,1684139117805,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aqq3gzop1j3r6zry618epesj6da','2023-05-15 08:25:24.479369','cwzr9jf3kbpnobqdx18edtbxyze',1,'checkbox','...','{\"value\":false}',1684139124472,1684139124472,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aqqp3dac3wirhpptohuqz83gkqy','2023-05-15 08:25:44.087019','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Create and manage checklists, like this one... :)','{\"value\":false}',1684139144077,1684139144077,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('aqtr5wbetofb6dfbfqh4k6dmqke','2023-05-15 08:25:18.563065','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Send follow-up email','{\"value\":false}',1684139118550,1684139118550,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('araqcr581mirqjbmhi8x4xd1wza','2023-05-15 08:25:23.822873','cwjh3qjukx38gipog474tobdb3w',1,'checkbox','[Subtask 1]','{\"value\":false}',1684139123820,1684139123820,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('artcz3tm1at8sjbgeft8dqdj1ew','2023-05-15 08:25:24.568222','czw9es1e89fdpjr7cqptr1xq7qh',1,'checkbox','[Subtask 3]','{\"value\":false}',1684139124562,1684139124562,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('arwrz93jeotggxrnn7ryte44wrw','2023-05-15 08:25:17.785559','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Schedule demo','{\"value\":true}',1684139117778,1684139117778,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('arxyp6pddc7dgxqwjsk75ion5ea','2023-05-15 08:25:44.391975','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Add and update descriptions with Markdown','{\"value\":false}',1684139144096,1684139144096,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('as4xgtsyfpbn69k9b5t347dwbde','2023-05-15 08:25:18.368596','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Send initial email','{\"value\":true}',1684139118361,1684139118361,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('as71mueofj78efrn5y758abxbeo','2023-05-15 08:25:41.605831','c6sc3f5fjmf8cbcqchzku19mg9a',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139141599,1684139141599,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('asdeyo96o6ig9bxh16o9zg8q4rc','2023-05-15 08:25:18.692364','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'checkbox','Finalize contract','{}',1684139118686,1684139118686,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('asdxx54r1zjyw9ktjyif8heczza','2023-05-15 08:25:24.605970','czw9es1e89fdpjr7cqptr1xq7qh',1,'checkbox','[Subtask 1]','{\"value\":false}',1684139124599,1684139124599,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('asgcymmis4fdkpqazjh45cupddo','2023-05-15 08:25:41.700141','cidz4imnqhir48brz6e8hxhfrhy',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139141693,1684139141693,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('asiwim3qmcbfpmjyhn5keb1x3ya','2023-05-15 08:25:41.803305','cwrq9ag3p5pgzzy98nfd3wwra1w',1,'text','## Summary\n[Brief description of what this epic is about]\n\n## Motivation\n[Brief description on why this is needed]\n\n## Acceptance Criteria\n - [Criteron 1]\n - [Criteron 2]\n - ...\n\n## Personas\n - [Persona A]\n - [Persona B]\n - ...\n\n## Reference Materials\n - [Links to other relevant documents as needed]\n - ...','{}',1684139141790,1684139141790,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('asu9m4usdcb8y3ka1hegjs3merh','2023-05-15 08:25:15.877870','cywrn8u5uqjba9d7dmzk6xrowoe',1,'divider','','{}',1684139115874,1684139115874,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('asxkajbi1tfrgm8i9d3x84jfmfe','2023-05-15 08:25:15.802124','corc1ng7xtbdqx8po63utq491ro',1,'text','## Notes\n*[Add meeting notes here]*','{}',1684139115798,1684139115798,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('aszwzw4fw8tnzpxmswm3xz19ybh','2023-05-15 08:25:15.904572','cywrn8u5uqjba9d7dmzk6xrowoe',1,'checkbox','','{\"value\":false}',1684139115901,1684139115901,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('at31uh665kjr1tyw77braff6qte','2023-05-15 08:25:24.644484','czw9es1e89fdpjr7cqptr1xq7qh',1,'text','## Checklist','{}',1684139124638,1684139124638,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('at619ib5a4fn19r34tizcab3etw','2023-05-15 08:25:15.970557','ckf7h5amk87fftmj33mk5gf78ih',1,'checkbox','','{\"value\":false}',1684139115967,1684139115967,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('at7h4mzxqw3nx8ctsecufy6zuhe','2023-05-15 08:25:24.530093','cwzr9jf3kbpnobqdx18edtbxyze',1,'checkbox','[Subtask 1]','{\"value\":false}',1684139124523,1684139124523,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('at8yeqopxbbfn5nqzxdyrxqmfyy','2023-05-15 08:25:32.077491','cfmk7771httynm8r7rm8cbrmrya',1,'text','## Screenshots\n*[If applicable, add screenshots to elaborate on the problem.]*','{}',1684139132070,1684139132070,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('atafa47uz7byruq66jaxwpefigh','2023-05-15 08:25:32.173526','c8kkpb6wh7igg7nw88x8nfnwf4c',1,'text','## Description\n*[Brief description of this task]*\n\n## Requirements\n- *[Requirement 1]*\n- *[Requirement 2]*\n- ...','{}',1684139132166,1684139132166,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('athngtrguzfd9jbstjo1iq837hc','2023-05-15 08:25:24.424359','c3e1n8jh85iy8pgqzz8xcdpejoc',1,'checkbox','...','{\"value\":false}',1684139124417,1684139124417,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('atkub6nqtjtbgmrpf5y6isjrfoo','2023-05-15 08:25:41.562349','cjztn4z4c53dem8kdnkkq6tc8fa',1,'text','## Steps to reproduce the behavior\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n*[A clear and concise description of what you expected to happen.]*\n\n## Edition and Platform\n- Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n- Version: *[e.g. v0.9.0]*\n- Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n*[Add any other context about the problem here.]*','{}',1684139141556,1684139141555,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('atuegurdywfr9mm93u779ywkdia','2023-05-15 08:25:18.152537','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Hand-off to customer success','{\"value\":true}',1684139118146,1684139118145,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('atzms9yotn3f87k3sy6c6zecx6e','2023-05-15 08:25:18.219990','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Send proposal','{}',1684139118212,1684139118212,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('au6nr9h1zp3nr78m6ei3sdp8ctw','2023-05-15 08:25:34.472250','ccfkf8w5ntpfx7d7afp8upt6jca',1,'text','## Interview Notes\n- ...\n- ...\n- ... ','{}',1684139134467,1684139134467,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('au6tkhdp3s3fumc4f5yzp6achgc','2023-05-15 08:25:15.934021','cbr1qix816jfyfkm5fcfen13a9e',1,'divider','','{}',1684139115931,1684139115931,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('au98tgq5nctdj9djkoih4n9tf5e','2023-05-15 08:25:18.354214','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Schedule demo','{\"value\":true}',1684139118346,1684139118346,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('auagdeuwwup8k8pdn9fs6joijwo','2023-05-15 08:25:17.912256','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Follow up after demo','{\"value\":true}',1684139117906,1684139117905,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('auc36b1696pnfbgakcmht4jxsph','2023-05-15 08:25:23.818173','cwjh3qjukx38gipog474tobdb3w',1,'checkbox','[Subtask 3]','{\"value\":false}',1684139123816,1684139123815,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aucfbqzo8sbbepbd37tehj6bgky','2023-05-15 08:25:15.787036','corc1ng7xtbdqx8po63utq491ro',1,'divider','','{}',1684139115783,1684139115783,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('aufn3gqypspr89n15aspuo637ir','2023-05-15 08:25:17.837844','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Post-sales follow up','{}',1684139117831,1684139117831,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('auise6ioid3bhxkxx6bbq1zgsga','2023-05-15 08:25:41.636142','cfefgwjke6bbxpjpig618g9bpte',1,'text','## Screenshots\nIf applicable, add screenshots to elaborate on the problem.','{}',1684139141629,1684139141629,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('aumref76zp7n9jjk6yzzthif6rh','2023-05-15 08:25:23.813626','cwjh3qjukx38gipog474tobdb3w',1,'divider','','{}',1684139123811,1684139123811,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aupi3t9ib3jy65qwzme7i4ky8ar','2023-05-15 08:25:23.754172','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'checkbox','...','{\"value\":false}',1684139123751,1684139123751,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('aupozsqimzprfpkym5m1dsw17ze','2023-05-15 08:25:41.725020','c3zpru7o6ibfxup6ej47xu8mc4a',1,'text','## Summary\n*[Brief description of what this epic is about]*\n\n## Motivation\n*[Brief description on why this is needed]*\n\n## Acceptance Criteria\n - *[Criteron 1]*\n - *[Criteron 2]*\n - ...\n\n## Personas\n - *[Persona A]*\n - *[Persona B]*\n - ...\n\n## Reference Materials\n - *[Links to other relevant documents as needed]*\n - ...','{}',1684139141719,1684139141719,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('ausby18os4idotruuexr3iunrga','2023-05-15 08:25:15.859159','ch798q5ucefyobf5bymgqjt4f3h',1,'text','# Action Items','{}',1684139115856,1684139115856,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('ausmstaiqf7ghiducjna77chfra','2023-05-15 08:25:32.119588','cec73iz548tyzfeagiummkqyh6c',1,'text','## Steps to reproduce the behavior\n1. Go to ...\n2. Select  ...\n3. Scroll down to ...\n4. See error\n\n## Expected behavior\n*[A clear and concise description of what you expected to happen.]*\n\n## Edition and Platform\n- Edition: *[e.g. Personal Desktop / Personal Server / Mattermost plugin]*\n- Version: *[e.g. v0.9.0]*\n- Browser and OS: *[e.g. Chrome 91 on macOS, Edge 93 on Windows]*\n\n## Additional context\n*[Add any other context about the problem here.]*','{}',1684139132111,1684139132111,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('autj3nzqztpbxtqo6iadg3f3psw','2023-05-15 08:25:44.442969','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Provide feedback and ask questions via comments','{\"value\":false}',1684139144435,1684139144435,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('auyfk6pje3fyetngebek4jqxu1h','2023-05-15 08:25:18.048501','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Follow up after demo','{\"value\":true}',1684139118042,1684139118042,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aw456tyy4zjbjpm4kusbxh739qa','2023-05-15 08:25:24.593324','czw9es1e89fdpjr7cqptr1xq7qh',1,'divider','','{}',1684139124587,1684139124587,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('awe76d1gxifg9dcc73rakdnaz1y','2023-05-15 08:25:34.496654','c87rtonnkmpd6umzmppctjhdrgc',1,'text','## Interview Notes\n- ...\n- ...\n- ... ','{}',1684139134491,1684139134491,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('aweccxa5qzbd8ukzpe9d66a6kgy','2023-05-15 08:25:17.824747','c5jaxbc9m6jn3dxcfhro94u1hpr',1,'checkbox','Schedule follow-up sales call','{\"value\":true}',1684139117818,1684139117818,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('awgaxdy4rctnnmptqi1a35dzrzw','2023-05-15 08:25:24.517114','cwzr9jf3kbpnobqdx18edtbxyze',1,'checkbox','[Subtask 2]','{\"value\":false}',1684139124510,1684139124510,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('awgph3xm5finx7ki7nit8t6iuuh','2023-05-15 08:25:18.326314','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Follow up after demo','{}',1684139118239,1684139118239,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('awim8q6fuxjb3fgjkg97qt881qa','2023-05-15 08:25:18.785141','ct59gu9j4cpnrtjcpyn3a5okdqa',1,'text','## Checklist','{}',1684139118778,1684139118778,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('awius1nogcbre3fk3rgqgt95hio','2023-05-15 08:25:44.067561','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Assign tasks to teammates','{\"value\":false}',1684139144060,1684139144060,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('awjcijjpwhbfgjpz6jmfye5gbcw','2023-05-15 08:25:15.886649','cywrn8u5uqjba9d7dmzk6xrowoe',1,'checkbox','','{\"value\":false}',1684139115883,1684139115883,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('awmkaa8ojq3bn5cj75ysw3ahjaa','2023-05-15 08:25:41.750609','cbm9y3gmqqjd6uewottgm8mocwh',1,'text','## Screenshots\n*[If applicable, add screenshots to elaborate on the problem.]*','{}',1684139141744,1684139141744,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('awonjqmd7p7g3d89p8out437tbh','2023-05-15 08:25:39.026202','cff1jmrxfrirgbeebhr9qd7nida',1,'text','## Research\n- ...\n- ...\n- ...\n\n## Plan\n- ...\n- ...\n- ...\n\n## Notes\n- ...\n- ...\n- ...','{}',1684139139018,1684139139018,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('awq3cxngkbfnt5fkzpfxczdmnaw','2023-05-15 08:25:15.980946','ckf7h5amk87fftmj33mk5gf78ih',1,'text','## Action Items','{}',1684139115978,1684139115978,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('awtn5z6btdfy39foagfpnepokya','2023-05-15 08:25:18.397916','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Send follow-up email','{\"value\":true}',1684139118390,1684139118390,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('awu8m855ws7gitfcbakbyq5pe9w','2023-05-15 08:25:23.763200','cgf85qmqr7fnyxcfqqw8nf8mn4h',1,'text','## Checklist','{}',1684139123760,1684139123760,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('awuo3zo7wgbb9br1t18d7p7p8ew','2023-05-15 08:25:22.130270','cjsgbbn88fbd8pjcue85wa8xzor',1,'text','','{}',1684139122124,1684139122124,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('ax41nr5o9j7r6bnoukbcxxpkf5y','2023-05-15 08:25:44.518929','c8x3s1st6ijfzuxhrf5aaei76my',1,'text','To create your own board, select the \"+\" on the top of the left hand sidebar. Choose from one of our standard templates and see how they can help you get started with your next project:\n\n- **Project Tasks**: Stay on top of your project tasks, track progress, and set priorities. \n- **Meeting Agenda**: Set your meeting agendas for recurring team meetings and 1:1s.\n- **Roadmap**: Plan your roadmap and manage your releases more efficiently.\n- **Personal Tasks**: Organize your life and track your personal tasks.\n- **Content Calendar**: Plan your editorial content, assign work, and track deadlines.\n- **Personal Goals**: Set and accomplish new personal goals and milestones.','{}',1684139144512,1684139144512,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ax8k51xesh7g3dqri57sbq9zzdo','2023-05-15 08:25:17.982853','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Schedule demo','{\"value\":true}',1684139117976,1684139117976,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('axdnwf9i75byy8pos6dp38zpnmr','2023-05-15 08:25:15.780719','corc1ng7xtbdqx8po63utq491ro',1,'checkbox','','{\"value\":false}',1684139115776,1684139115776,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('axedjwpq1y7ru3c3fne9tuhbiae','2023-05-15 08:25:19.575826','cizmdp6qkrjf9uqixnsu6ea4o8o',1,'checkbox','Send follow-up email','{\"value\":false}',1684139119565,1684139119565,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('axehsiymm93rrpeaumbiuwmkyow','2023-05-15 08:25:44.622074','cbokq5iftypbs3gspcn15kp1u4r',1,'text','Mattermost Boards helps you manage and track all your project tasks with **Cards**.','{}',1684139144592,1684139144592,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('axggtfboiptri8yt6qgkaef7qua','2023-05-15 08:25:44.666842','ckjptgsceu3fq5fmjmn9d7ugpiw',1,'text','To share a card, you\'ll need to copy the card link first. You can:\n\n- Open a card and select the options menu button at the top right of the card.\n- Open the board view and hover your mouse over any card to access the options menu button.','{}',1684139144660,1684139144660,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('axzei9dbwufg8dgkn4is7xhtu7r','2023-05-15 08:25:23.800076','cqfonaty9ifrg9mxbr5xk5fyowo',1,'text','## Description\n*[Brief description of this task]*','{}',1684139123797,1684139123797,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('axznpefqo3jg95ni5yypaigkhhw','2023-05-15 08:25:18.595587','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Hand-off to customer success','{}',1684139118588,1684139118588,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('axzud9xrewbbwtx3wcehhnzadsw','2023-05-15 08:25:18.126307','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Schedule initial sales call','{\"value\":true}',1684139118120,1684139118120,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ay565qgiejjfc8p8qq51b7sfqqe','2023-05-15 08:25:18.510616','c7ho5n7y4t7fyimowcpjxuumtea',1,'checkbox','Send proposal','{}',1684139118504,1684139118504,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('ay5s6swk76ingpee3uzru1yenoh','2023-05-15 08:25:15.928487','cbr1qix816jfyfkm5fcfen13a9e',1,'checkbox','','{\"value\":false}',1684139115925,1684139115925,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('ay6cwwn63r3bbjke8yyxao5ktga','2023-05-15 08:25:24.580792','czw9es1e89fdpjr7cqptr1xq7qh',1,'checkbox','[Subtask 2]','{\"value\":false}',1684139124574,1684139124574,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ayqepp51fh3d8prg75ockmnfz3e','2023-05-15 08:25:23.804834','cwjh3qjukx38gipog474tobdb3w',1,'checkbox','...','{\"value\":false}',1684139123802,1684139123802,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ayxdnttb5efdifdgs5bc5ttus5o','2023-05-15 08:25:18.062024','cdykszx7gffnibcgf4p9gzdit9a',1,'checkbox','Send initial email','{\"value\":true}',1684139118055,1684139118055,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('az6qkbrr6uidq38o69kenspe9dw','2023-05-15 08:25:18.204984','c8tf9wun9gtyc7bzize8f513eqc',1,'checkbox','Post-sales follow up','{}',1684139118198,1684139118198,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('azeaxw8hwyfrhbfj1swo7uhfmfr','2023-05-15 08:25:15.923112','cbr1qix816jfyfkm5fcfen13a9e',1,'checkbox','','{\"value\":false}',1684139115919,1684139115919,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('azkowzqsoi3nuzysfn67jownt8o','2023-05-15 08:25:44.412301','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','Follow cards to get notified on the latest updates','{\"value\":false}',1684139144406,1684139144406,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('azptr4acc6jgt9pbach7gb5837e','2023-05-15 08:25:17.943485','cow8jauqkabgb8etq9ckdo8nhrh',1,'checkbox','Hand-off to customer success','{}',1684139117935,1684139117935,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('aztpyqdf41tb9z8xzmnfbxak1sh','2023-05-15 08:25:36.502446','cne7na65esjff3bhwjdrd1pea4h',1,'text','## Summary\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Duis fermentum aliquet massa in ornare. Pellentesque mollis nisl efficitur, eleifend nisi congue, scelerisque nunc. Aliquam lorem quam, commodo id nunc nec, congue bibendum velit. Vivamus sed mattis libero, et iaculis diam. Suspendisse euismod hendrerit nisl, quis ornare ipsum gravida in.\n## Strengths\n- ...\n- ...\n\n## Weaknesses\n- ...\n- ...\n\n## Opportunities\n- ...\n- ...\n\n## Threats\n- ...\n- ...','{}',1684139136495,1684139136495,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('azwnrkknjp7yspg8ni86okthuuy','2023-05-15 08:25:44.455522','c1skdp9t1mtnjbxcmoshjj94x8a',1,'checkbox','@mention teammates so they can follow, and collaborate on, comments and descriptions','{\"value\":false}',1684139144449,1684139144449,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('c18ku7bj113nrbrhc48ugk1fx6y','2023-05-15 08:25:28.225990','bd65qbzuqupfztpg31dgwgwm5ga',1,'card','Learn to paint','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"af6fcbb8-ca56-4b73-83eb-37437b9a667d\":\"77c539af-309c-4db1-8329-d20ef7e9eacd\",\"d6b1249b-bc18-45fc-889e-bec48fce80ef\":\"9a090e33-b110-4268-8909-132c5002c90e\",\"d9725d14-d5a8-48e5-8de1-6f8c004a9680\":\"3245a32d-f688-463b-87f4-8e7142c1b397\"}}',1684139128217,1684139128217,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('c1axsmo6e5i8tf8xun3qyk57ytr','2023-05-15 08:25:29.308325','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','User Story','{\"contentOrder\":[\"a1dbxk43ombn4fm1ew8x1qhku3r\"],\"icon\":\"?\",\"isTemplate\":true,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"apht1nt5ryukdmxkh6fkfn6rgoy\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\"}}',1684139129301,1684139129301,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('c1skdp9t1mtnjbxcmoshjj94x8a','2023-05-15 08:25:43.132424','buixxjic3xjfkieees4iafdrznc',1,'card','Manage tasks with cards','{\"contentOrder\":[\"ansjzguztbiffmmesd9nfrmjz7h\",\"a676u5r9tbpnsumpr67ea3zo6qw\",\"adb14fy97ktr79grpj9dzd3pomh\",\"784uu3ufcgb878ky7hyugmf6xcw\",\"awius1nogcbre3fk3rgqgt95hio\",\"arxyp6pddc7dgxqwjsk75ion5ea\",\"autj3nzqztpbxtqo6iadg3f3psw\",\"7nb8y7jyoetro8cd36qcju53z8c\",\"azkowzqsoi3nuzysfn67jownt8o\",\"azwnrkknjp7yspg8ni86okthuuy\",\"76nwb9tqfsid5jx46yw34itqima\",\"7dy3mcgzgybf1ifa3emgewkzj7e\",\"a5ca6tii33bfw8ba36y1rswq3he\",\"7876od6xhffr6fy69zeogag7eyw\",\"7x7bq9awkatbm5x4docbh5gaw4y\",\"7ghpx9qff43dgtke1rwidmge1ho\",\"7nb8y7jyoetro8cd36qcju53z8c\",\"7hdyxemhbytfm3m83g88djq9nhr\",\"7pgnejxokubbe9kdrxj6g9qa41e\",\"7hw9z6qtx8jyizkmm9g5yq3gxcy\",\"7gk6ooz6npbb8by5rgp9aig7tua\",\"aqqp3dac3wirhpptohuqz83gkqy\"],\"icon\":\"☑️\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/work-with-cards.html\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"amm6wfhnbuxojwssyftgs9dipqe\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aanaehcw3m13jytujsjk5hpf6ry\"}}',1684139143123,1684139143123,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('c31rnabwmciy49reqdtf658scxa','2023-05-15 08:25:40.616430','bsjd59qtpbf888mqez3ge77domw',1,'card','Reschedule planning meeting','{\"contentOrder\":[],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"adjckpdotpgkz7c6wixzw9ipb1e\":\"aok6pgecm85qe9k5kcphzoe63ma\"}}',1684139140608,1684139140608,0,NULL,'system','','system','b7n3rwgpsspbg9drkn8ztit7yxw'),('c3e1n8jh85iy8pgqzz8xcdpejoc','2023-05-15 08:25:23.709769','bc41mwxg9ybb69pn9j5zna6d36c',1,'card','Project budget approval','{\"contentOrder\":[\"aoy8dg4jgbfdp8pdm9ga1uk3rrw\",\"aoxteiun1cj85ppwpw935htrify\",\"aoi7yahtppir47cuch69s1mbrde\",\"ad4jkwdrk8tygixputknzh3tm9e\",\"ab7k61ow3str93y8yt4xzt6fx1h\",\"a74eggha9pigfmcqrt5hq8fo6ny\",\"athngtrguzfd9jbstjo1iq837hc\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a8daz81s4xjgke1ww6cwik5w7ye\":\"16\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ayz81h9f3dwp7rzzbdebesc7ute\",\"d3d682bf-e074-49d9-8df5-7320921c2d23\":\"d3bfb50f-f569-4bad-8a3a-dd15c3f60101\"}}',1684139123707,1684139123707,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('c3zpru7o6ibfxup6ej47xu8mc4a','2023-05-15 08:25:41.409068','bui5izho7dtn77xg3thkiqprc9r',1,'card','Review API design','{\"contentOrder\":[\"aupozsqimzprfpkym5m1dsw17ze\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"424ea5e3-9aa1-4075-8c5c-01b44b66e634\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"8c557f69-b0ed-46ec-83a3-8efab9d47ef5\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"14892380-1a32-42dd-8034-a0cea32bc7e6\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"https://mattermost.com/boards/\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"c62172ea-5da7-4dec-8186-37267d8ee9a7\"}}',1684139141386,1684139141386,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('c485y8w5cnfy47mpyp4mmgbe39r','2023-05-15 08:25:34.440653','bh4pkixqsjift58e1qy6htrgeay',1,'card','Bernadette Powell','{\"contentOrder\":[\"a1fj9z7tsejrbux6tbscguca59r\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"aaebj5fyx493eezx6ukxiwydgty\":\"af6hjb3ysuaxbwnfqpby4wwnkdr\",\"acjq4t5ymytu8x1f68wkggm7ypc\":\"bernadette.powell@email.com\"}}',1684139134437,1684139134437,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('c48fsy6msutb6i8pcnd7axut6kr','2023-05-15 08:25:21.487934','bbn1888mprfrm5fjw9f1je9x3xo',1,'card','Go for a walk','{\"contentOrder\":[\"ahpm1u53gepnn5c5mnkp68radgh\",\"a49urkhwkbtr18qeqq8k7kfncho\",\"iye416ctq8irqmb8oqww6fw96bo\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a9zf59u8x1rf4ywctpcqama7tio\":\"an51dnkenmoog9cetapbc4uyt3y\"}}',1684139121480,1684139121480,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('c4htpxn8wxpd6pffpjo4u8xxxxc','2023-05-15 08:25:36.373610','bkqk6hpfx7pbsucue7jan5n1o1o',1,'card','Liminary Corp.','{\"contentOrder\":[\"agjiprrojcjyg9x9q7kxe8n8eyr\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a1semdhszu1rq17d7et5ydrqqio\":\"abt79uxg5edqojsrrefcnr4eruo\",\"a6cwaq79b1pdpb97wkanmeyy4er\":\"300\",\"ahzspe59iux8wigra8bg6cg18nc\":\"liminarycorp.com\",\"aiefo7nh9jwisn8b4cgakowithy\":\"$25,000,000\",\"an1eerzscfxn6awdfajbg41uz3h\":\"2017\",\"aozntq4go4nkab688j1s7stqtfc\":\"Toronto, Canada\"}}',1684139136366,1684139136366,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('c4qc8gzhjipf6mmbat9du8ye9kr','2023-05-15 08:25:41.379702','bui5izho7dtn77xg3thkiqprc9r',1,'card','Import / Export','{\"contentOrder\":[\"amho5gxfybbrt5n3ko48x5d8pny\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"6eea96c9-4c61-4968-8554-4b7537e8f748\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"ec6d2bc5-df2b-4f77-8479-e59ceb039946\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"c01676ca-babf-4534-8be5-cce2287daa6c\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"https://mattermost.com/boards/\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139141372,1684139141372,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('c5jaxbc9m6jn3dxcfhro94u1hpr','2023-05-15 08:25:17.602364','bbkpwdj8x17bdpdqd176n8ctoua',1,'card','Jonathan Frazier','{\"contentOrder\":[\"afst5iycoy3rhixsdjihf3peoey\",\"a9k51ioai67fmjnqsmjwezs1fbe\",\"aqfzsxtdkjf8fxn68you4bs5tmw\",\"aphzuak83niydzqmomg8kerrjzo\",\"ainarjkocuiduxrbb63t9xoyper\",\"aweccxa5qzbd8ukzpe9d66a6kgy\",\"arwrz93jeotggxrnn7ryte44wrw\",\"aqpusoh9o8bndupb7m9sbpqcbmr\",\"a5w8x3eswhiyojrmstdzo593nhr\",\"ajofqzk5biighxbxuu5hrz9hqrr\",\"aaigoezzch3fy9knkd3gdjczqzw\",\"aufn3gqypspr89n15aspuo637ir\"],\"icon\":\"?‍♂️\",\"isTemplate\":false,\"properties\":{\"a1438fbbhjeffkexmcfhnx99o1h\":\"(999) 123-5678\",\"a5hwxjsmkn6bak6r7uea5bx1kwc\":\"a5txuiubumsmrs8gsd5jz5gc1oa\",\"abru6tz8uebdxy4skheqidh7zxy\":\"jonathan.frazier@email.com\",\"aejo5tcmq54bauuueem9wc4fw4y\":\"0%\",\"ahf43e44h3y8ftanqgzno9z7q7w\":\"$800,000\",\"ainpw47babwkpyj77ic4b9zq9xr\":\"Ositions Inc.\",\"amahgyn9n4twaapg3jyxb6y4jic\":\"as5bk6afoaaa7caewe1zc391sce\",\"aro91wme9kfaie5ceu9qasmtcnw\":\"apiswzj7uiwbh87z8dw8c6mturw\",\"auhf91pm85f73swwidi4wid8jqe\":\"{\\\"from\\\":1669118400000}\"}}',1684139117595,1684139117595,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('c5m8zt49qq7nbbfced77hzy9imh','2023-05-15 08:25:25.764131','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Increase user signups by 30%','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"a6robxx81diugpjq5jkezz3j1fo\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"ao9b5pxyt7tkgdohzh9oaustdhr\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"as555ipyzopjjpfb5rjtssecw5e\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"0%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"1,000\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"acb6dqqs6yson7bbzx6jk9bghjh\",\"azqnyswk6s1boiwuthscm78qwuo\":\"0\",\"azzbawji5bksj69sekcs4srm1ky\":\"afkxpcjqjypu7hhar7banxau91h\"}}',1684139125746,1684139125746,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('c61etzptwef8ydchn9hofc587cw','2023-05-15 08:25:40.586389','bsjd59qtpbf888mqez3ge77domw',1,'card','Tight deadline','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"adjckpdotpgkz7c6wixzw9ipb1e\":\"ar87yh5xmsswqkxmjq1ipfftfpc\"}}',1684139140579,1684139140579,0,NULL,'system','','system','b7n3rwgpsspbg9drkn8ztit7yxw'),('c6qdmkccxdjyhtk3b6iax55twgr','2023-05-15 08:25:28.209676','bd65qbzuqupfztpg31dgwgwm5ga',1,'card','Run 3 times a week','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"af6fcbb8-ca56-4b73-83eb-37437b9a667d\":\"bf52bfe6-ac4c-4948-821f-83eaa1c7b04a\",\"d6b1249b-bc18-45fc-889e-bec48fce80ef\":\"6e7139e4-5358-46bb-8c01-7b029a57b80a\",\"d9725d14-d5a8-48e5-8de1-6f8c004a9680\":\"ffb3f951-b47f-413b-8f1d-238666728008\"}}',1684139128198,1684139128198,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('c6sc3f5fjmf8cbcqchzku19mg9a','2023-05-15 08:25:41.362575','bui5izho7dtn77xg3thkiqprc9r',1,'card','Standard templates','{\"contentOrder\":[\"7uonmjk41nipnrsi6tz8wau5ssh\",\"as71mueofj78efrn5y758abxbeo\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"6eea96c9-4c61-4968-8554-4b7537e8f748\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"ec6d2bc5-df2b-4f77-8479-e59ceb039946\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"ed4a5340-460d-461b-8838-2c56e8ee59fe\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"https://mattermost.com/boards/\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139141354,1684139141354,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('c7ho5n7y4t7fyimowcpjxuumtea','2023-05-15 08:25:17.671713','bbkpwdj8x17bdpdqd176n8ctoua',1,'card','New Prospect','{\"contentOrder\":[\"aixwwtex9ofbo58tws4p8kzzzhh\",\"acjb5kah4xp835qecaxb6n7nfah\",\"aosqp85sp5pbkzfhqkc9f9kx9br\",\"aqtr5wbetofb6dfbfqh4k6dmqke\",\"ahd73ykmw6pd9bqqwsppk6wx9ty\",\"an1ni5jxrkibi3f4pe1wis5kdha\",\"ah8yjnketf7rcxyegsef1gmkjow\",\"aoem1zdrjnid3ineo4tene5xo4o\",\"ay565qgiejjfc8p8qq51b7sfqqe\",\"ak7rktdxk4tbtuxuitq5p37ficr\",\"axznpefqo3jg95ni5yypaigkhhw\",\"afbqaohnf8fdi7k43xo86jcri1a\"],\"icon\":\"?\",\"isTemplate\":true,\"properties\":{\"a5hwxjsmkn6bak6r7uea5bx1kwc\":\"akj61wc9yxdwyw3t6m8igyf9d5o\"}}',1684139117663,1684139117663,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('c87rtonnkmpd6umzmppctjhdrgc','2023-05-15 08:25:34.428329','bh4pkixqsjift58e1qy6htrgeay',1,'card','Claire Hart','{\"contentOrder\":[\"awe76d1gxifg9dcc73rakdnaz1y\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"aaebj5fyx493eezx6ukxiwydgty\":\"aseqq9hrsua56r3s6nbuirj9eec\",\"acjq4t5ymytu8x1f68wkggm7ypc\":\"claire.hart@email.com\",\"aify3r761b9w43bqjtskrzi68tr\":\"Password123\",\"akrxgi7p7w14fym3gbynb98t9fh\":\"{\\\"from\\\":1670500800000}\",\"aqafzdeekpyncwz7m7i54q3iqqy\":\"https://user-images.githubusercontent.com/46905241/121941290-ee355280-cd03-11eb-9b9f-f6f524e4103e.gif\",\"atg9qu6oe4bjm8jczzsn71ff5me\":\"ahn89mqg9u4igk6pdm7333t8i5h\"}}',1684139134425,1684139134425,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('c8kkpb6wh7igg7nw88x8nfnwf4c','2023-05-15 08:25:29.434105','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Global templates','{\"contentOrder\":[\"atafa47uz7byruq66jaxwpefigh\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"a5yxq8rbubrpnoommfwqmty138h\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"a6ghze4iy441qhsh3eijnc8hwze\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"c01676ca-babf-4534-8be5-cce2287daa6c\",\"a1g6i613dpe9oryeo71ex3c86hy\":\"https://mattermost.com/boards/\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"2\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139129427,1684139129427,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('c8n4xu7ntq7bbbd14noats457ro','2023-05-15 08:25:38.077800','brs9cdimfw7fodyi7erqt747rhc',1,'card','Top 10 Must-Have DevOps Tools in 2021','{\"contentOrder\":[\"7fo1utqc8x1z1z6hzg33hes1ktc\",\"aeuc3ii3akir43j81makf3hxuay\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"a39x5cybshwrbjpc3juaakcyj6e\":\"{\\\"from\\\":1636113600000}\",\"ab6mbock6styfe6htf815ph1mhw\":[\"a8xceonxiu4n3c43szhskqizicr\"],\"ae9ar615xoknd8hw8py7mbyr7zo\":\"a9ana1e9w673o5cp8md4xjjwfto\",\"agqsoiipowmnu9rdwxm57zrehtr\":\"{\\\"from\\\":1637323200000}\",\"ap4e7kdg7eip7j3c3oyiz39eaoc\":\"https://www.toolbox.com/tech/devops/articles/best-devops-tools/\",\"aysx3atqexotgwp5kx6h5i5ancw\":\"a3xky7ygn14osr1mokerbfah5cy\"}}',1684139138070,1684139138070,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('c8ra694tq4bfm5czq11g6wnq3re','2023-05-15 08:25:34.433870','bh4pkixqsjift58e1qy6htrgeay',1,'card','Olivia Alsop','{\"contentOrder\":[\"ahcc7baon8irodktqpfj1db4mdw\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"aaebj5fyx493eezx6ukxiwydgty\":\"a7yq89whddzob1futao4rxk3yzc\",\"acjq4t5ymytu8x1f68wkggm7ypc\":\"olivia.alsop@email.com\",\"aify3r761b9w43bqjtskrzi68tr\":\"Password123\",\"akrxgi7p7w14fym3gbynb98t9fh\":\"{\\\"from\\\":1671192000000}\",\"aqafzdeekpyncwz7m7i54q3iqqy\":\"https://user-images.githubusercontent.com/46905241/121941290-ee355280-cd03-11eb-9b9f-f6f524e4103e.gif\",\"atg9qu6oe4bjm8jczzsn71ff5me\":\"a1sxagjgaadym5yrjak6tcup1oa\"}}',1684139134430,1684139134430,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('c8tf9wun9gtyc7bzize8f513eqc','2023-05-15 08:25:17.653442','bbkpwdj8x17bdpdqd176n8ctoua',1,'card','Caitlyn Russel','{\"contentOrder\":[\"age6hf4ppq3gy7y8y44mhrdsifr\",\"anxrc977em3gcbj6tuuz3pjse4w\",\"as4xgtsyfpbn69k9b5t347dwbde\",\"awtn5z6btdfy39foagfpnepokya\",\"a5owboss9ytnwzqsg838ax9c7sa\",\"agbstqsrjejd6iemscpeixjpj8o\",\"au98tgq5nctdj9djkoih4n9tf5e\",\"awgph3xm5finx7ki7nit8t6iuuh\",\"atzms9yotn3f87k3sy6c6zecx6e\",\"adyads1uwsj8qfeq5mfh4jaz18a\",\"anuotdyg8ajfo7guetz5npmznqy\",\"az6qkbrr6uidq38o69kenspe9dw\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"a1438fbbhjeffkexmcfhnx99o1h\":\"(111) 123-1234\",\"a5hwxjsmkn6bak6r7uea5bx1kwc\":\"ah6ehh43rwj88jy4awensin8pcw\",\"abru6tz8uebdxy4skheqidh7zxy\":\"caitlyn.russel@email.com\",\"adtf1151chornmihz4xbgbk9exa\":\"{\\\"from\\\":1689336000000}\",\"aejo5tcmq54bauuueem9wc4fw4y\":\"20%\",\"ahf43e44h3y8ftanqgzno9z7q7w\":\"$250,000\",\"ainpw47babwkpyj77ic4b9zq9xr\":\"Liminary Corp.\",\"amahgyn9n4twaapg3jyxb6y4jic\":\"aafwyza5iwdcwcyfyj6bp7emufw\",\"aro91wme9kfaie5ceu9qasmtcnw\":\"apiswzj7uiwbh87z8dw8c6mturw\",\"auhf91pm85f73swwidi4wid8jqe\":\"{\\\"from\\\":1668168000000}\"}}',1684139117639,1684139117638,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('c8x3s1st6ijfzuxhrf5aaei76my','2023-05-15 08:25:43.146614','buixxjic3xjfkieees4iafdrznc',1,'card','Create your own board','{\"contentOrder\":[\"a873fa3hbs3ytumfax4m65fwzgc\",\"ax41nr5o9j7r6bnoukbcxxpkf5y\",\"7r9my1yuddbn45dojrfht3neg8c\",\"7eir5gdjxgjbsxpbyp3df4npcze\",\"iiz5ur5j5gt8c3ygq7z5kasubwa\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/working-with-boards.html#adding-new-boards\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"amm6wfhnbuxojwssyftgs9dipqe\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aanaehcw3m13jytujsjk5hpf6ry\"}}',1684139143139,1684139143139,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('c8xeju51trbg38x6xq6spazwsnc','2023-05-15 08:25:43.198830','buixxjic3xjfkieees4iafdrznc',1,'card','Filter and sort cards','{\"contentOrder\":[\"a4fz9kcfs9ibj8puk9mux7ac94c\",\"ac8chzuh3bbrj78copndmi6p38r\",\"78i8aqjmqtibr7x4okhz6uqquqr\",\"iupwtx8hqgfn19dxkfj56h48rwo\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ajurey3xkocs1nwx8di5zx6oe7o\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aq6ukoiciyfctgwyhwzpfss8ghe\"}}',1684139143192,1684139143192,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('c8z9b6w6757nojkqi5k4kc1eggy','2023-05-15 08:25:29.402413','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Standard properties','{\"contentOrder\":[\"ad1zwi9jox7dk5njpgjd46briih\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"a5yxq8rbubrpnoommfwqmty138h\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"14892380-1a32-42dd-8034-a0cea32bc7e6\",\"a1g6i613dpe9oryeo71ex3c86hy\":\"https://mattermost.com/boards/\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"3\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139129390,1684139129390,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('c98nnstjzhbgmpj6g88rgpgnheh','2023-05-15 08:25:36.448436','bkqk6hpfx7pbsucue7jan5n1o1o',1,'card','Afformance Ltd.','{\"contentOrder\":[\"aqenhkcet77f1tmexfzbdqu1auo\"],\"icon\":\"⚡\",\"isTemplate\":false,\"properties\":{\"a1semdhszu1rq17d7et5ydrqqio\":\"arfjpz9by5car71tz3behba8yih\",\"a6cwaq79b1pdpb97wkanmeyy4er\":\"1,800\",\"ahzspe59iux8wigra8bg6cg18nc\":\"afformanceltd.com\",\"aiefo7nh9jwisn8b4cgakowithy\":\"$200,000,000\",\"an1eerzscfxn6awdfajbg41uz3h\":\"2002\",\"aozntq4go4nkab688j1s7stqtfc\":\"Palo Alto, CA\"}}',1684139136441,1684139136441,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('c9iwbjcg8w38ip8m9xizycdmesc','2023-05-15 08:25:29.367764','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Cross-team collaboration','{\"contentOrder\":[\"a5ooaofewzinbfn4bczt4ykp3we\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"424ea5e3-9aa1-4075-8c5c-01b44b66e634\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"14892380-1a32-42dd-8034-a0cea32bc7e6\",\"a1g6i613dpe9oryeo71ex3c86hy\":\"https://mattermost.com/boards/\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"3\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"c62172ea-5da7-4dec-8186-37267d8ee9a7\"}}',1684139129361,1684139129361,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('cb89odozjd788py34ggamhsyo1h','2023-05-15 08:25:38.031473','brs9cdimfw7fodyi7erqt747rhc',1,'card','New Project and Workflow Management Solutions for Developers','{\"contentOrder\":[\"71qhnzuec6esdi6fnynwpze4xya\",\"aerxw6a5f6tbq5cfuo97h1dcp1w\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a39x5cybshwrbjpc3juaakcyj6e\":\"{\\\"from\\\":1645790400000}\",\"ab6mbock6styfe6htf815ph1mhw\":[\"a8xceonxiu4n3c43szhskqizicr\",\"a3pdzi53kpbd4okzdkz6khi87zo\",\"a3d9ux4fmi3anyd11kyipfbhwde\"],\"ae9ar615xoknd8hw8py7mbyr7zo\":\"awna1nuarjca99m9s4uiy9kwj5h\",\"ap4e7kdg7eip7j3c3oyiz39eaoc\":\"https://mattermost.com/newsroom/press-releases/mattermost-launches-new-project-and-workflow-management-solutions-for-developers/\",\"aysx3atqexotgwp5kx6h5i5ancw\":\"aywiofmmtd3ofgzj95ysky4pjga\"}}',1684139138021,1684139138021,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('cbm9y3gmqqjd6uewottgm8mocwh','2023-05-15 08:25:41.431191','bui5izho7dtn77xg3thkiqprc9r',1,'card','Icons don\'t display','{\"contentOrder\":[\"akqw19ofqotr78g78jobfykj3ia\",\"awmkaa8ojq3bn5cj75ysw3ahjaa\",\"i6etc7e7omjymxbztaoqp3cpyta\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"1fdbb515-edd2-4af5-80fc-437ed2211a49\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"8c557f69-b0ed-46ec-83a3-8efab9d47ef5\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"ed4a5340-460d-461b-8838-2c56e8ee59fe\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"https://mattermost.com/boards/\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139141424,1684139141424,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('cbokq5iftypbs3gspcn15kp1u4r','2023-05-15 08:25:43.172605','buixxjic3xjfkieees4iafdrznc',1,'card','Create a new card','{\"contentOrder\":[\"axehsiymm93rrpeaumbiuwmkyow\",\"adhsx4h5ss7rqdcjt8xyam6xtqc\",\"ag34x3ougupbrfd5ypsbrqueb5e\",\"7me9p46gbqiyfmfnapi7dyxb5br\",\"irib7x5bb9t8ztxmy68up9dfjaa\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/working-with-boards.html#adding-cards\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"amm6wfhnbuxojwssyftgs9dipqe\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aanaehcw3m13jytujsjk5hpf6ry\"}}',1684139143166,1684139143166,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('cbr1qix816jfyfkm5fcfen13a9e','2023-05-15 08:25:15.729233','b7wnw9awd4pnefryhq51apbzb4c',1,'card','Offsite plans','{\"contentOrder\":[\"amiis7xbrqtf6dc8ww13heeg6aw\",\"au6tkhdp3s3fumc4f5yzp6achgc\",\"apo1h5w4debdjmr9usxauqtqwby\",\"azeaxw8hwyfrhbfj1swo7uhfmfr\",\"ay5s6swk76ingpee3uzru1yenoh\",\"a1ewhbrp883bpbjrc89n35buyjh\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"4cf1568d-530f-4028-8ffd-bdc65249187e\":\"8b05c83e-a44a-4d04-831e-97f01d8e2003\",\"d777ba3b-8728-40d1-87a6-59406bbbbfb0\":\"dabadd9b-adf1-4d9f-8702-805ac6cef602\"}}',1684139115720,1684139115720,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('ccfkf8w5ntpfx7d7afp8upt6jca','2023-05-15 08:25:33.725967','bh4pkixqsjift58e1qy6htrgeay',1,'card','Frank Nash','{\"contentOrder\":[\"au6nr9h1zp3nr78m6ei3sdp8ctw\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"aaebj5fyx493eezx6ukxiwydgty\":\"ap93ysuzy1xa7z818r6myrn4h4y\",\"acjq4t5ymytu8x1f68wkggm7ypc\":\"frank.nash@email.com\",\"aify3r761b9w43bqjtskrzi68tr\":\"Password123\",\"akrxgi7p7w14fym3gbynb98t9fh\":\"{\\\"from\\\":1669896000000}\",\"aqafzdeekpyncwz7m7i54q3iqqy\":\"https://user-images.githubusercontent.com/46905241/121941290-ee355280-cd03-11eb-9b9f-f6f524e4103e.gif\",\"atg9qu6oe4bjm8jczzsn71ff5me\":\"aehc83ffays3gh8myz16a8j7k4e\"}}',1684139133267,1684139133267,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('cczudbnf113g1fezgjcbj8wqd9h','2023-05-15 08:25:29.447551','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Feature','{\"contentOrder\":[\"amf64og7po7dnxdir6idmyk1qnw\"],\"icon\":\"?️\",\"isTemplate\":true,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"a5yxq8rbubrpnoommfwqmty138h\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\"}}',1684139129440,1684139129440,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('cdykszx7gffnibcgf4p9gzdit9a','2023-05-15 08:25:17.631392','bbkpwdj8x17bdpdqd176n8ctoua',1,'card','Byron Cole','{\"contentOrder\":[\"a3xqbjspfy3bmpek81gk3jcqd9r\",\"apjxwm8wbai8puqi5hsyu16ex4a\",\"ayxdnttb5efdifdgs5bc5ttus5o\",\"aj3idc59csjbhupc81cr5drn1eh\",\"axzud9xrewbbwtx3wcehhnzadsw\",\"agh8493dxoff6ucoi993ym6o1cw\",\"ao9bnrjmwfb8o8mb4maqr4hjpne\",\"auyfk6pje3fyetngebek4jqxu1h\",\"an935fht14fr8mpjo99fuwaw4zo\",\"a44hj6n51d3bdzfkkbczsgrmhpw\",\"atuegurdywfr9mm93u779ywkdia\",\"a14yt5umqginsdnp67tq5ztugkw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a1438fbbhjeffkexmcfhnx99o1h\":\"(333) 123-1234\",\"a5hwxjsmkn6bak6r7uea5bx1kwc\":\"acm9q494bcthyoqzmfogxxy5czy\",\"abru6tz8uebdxy4skheqidh7zxy\":\"byron.cole@email.com\",\"adtf1151chornmihz4xbgbk9exa\":\"{\\\"from\\\":1667563200000}\",\"aejo5tcmq54bauuueem9wc4fw4y\":\"100%\",\"ahf43e44h3y8ftanqgzno9z7q7w\":\"$500,000\",\"ainpw47babwkpyj77ic4b9zq9xr\":\"Helx Industries\",\"amahgyn9n4twaapg3jyxb6y4jic\":\"aafwyza5iwdcwcyfyj6bp7emufw\",\"aro91wme9kfaie5ceu9qasmtcnw\":\"apjnaggwixchfxwiatfh7ey7uno\",\"auhf91pm85f73swwidi4wid8jqe\":\"{\\\"from\\\":1667822400000}\"}}',1684139117622,1684139117622,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('cec73iz548tyzfeagiummkqyh6c','2023-05-15 08:25:29.382074','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Bug','{\"contentOrder\":[\"ausmstaiqf7ghiducjna77chfra\",\"ajguuc7nfctfptbaq8k1cnz7smc\",\"i6kfk1wdofpfxjxmwtq8mpg1ohy\"],\"icon\":\"?\",\"isTemplate\":true,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"aomnawq4551cbbzha9gxnmb3z5w\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\"}}',1684139129374,1684139129374,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('cffwedhcphjnxdnx7gi5ef487mc','2023-05-15 08:25:41.346736','bui5izho7dtn77xg3thkiqprc9r',1,'card','Calendar view','{\"contentOrder\":[\"7df11783ny67mdnognqae31ax6y\",\"ag351ba8q87rjzy868zsaoxu36y\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"6eea96c9-4c61-4968-8554-4b7537e8f748\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"849766ba-56a5-48d1-886f-21672f415395\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"c01676ca-babf-4534-8be5-cce2287daa6c\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"https://mattermost.com/boards/\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139141332,1684139141332,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('cgd4a4ph353d48ct6ybq17fhanc','2023-05-15 08:25:25.819204','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Reduce bug backlog by 50%','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"abzfwnn6rmtfzyq5hg8uqmpsncy\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"apqfjst8massbjjhpcsjs3y1yqa\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"a1ts3ftyr8nocsicui98c89uxjy\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"100%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"75\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"awfu37js3fomfkkczm1zppac57a\",\"azqnyswk6s1boiwuthscm78qwuo\":\"75\",\"azzbawji5bksj69sekcs4srm1ky\":\"aw5i7hmpadn6mbwbz955ubarhme\"}}',1684139125809,1684139125809,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('cgf85qmqr7fnyxcfqqw8nf8mn4h','2023-05-15 08:25:23.696964','bc41mwxg9ybb69pn9j5zna6d36c',1,'card','Identify dependencies','{\"contentOrder\":[\"a4oacqw9rgtbo5ri9wzijhz1wdw\",\"amw9356bg67rr881axj93ca7boo\",\"awu8m855ws7gitfcbakbyq5pe9w\",\"ank4fqmyfotyi9x18g5x1h83d3h\",\"aiw8kpb5u1tnmxqkq6p5tpybdqc\",\"a1wp1k1zieighmg39wyjjygcxre\",\"aupi3t9ib3jy65qwzme7i4ky8ar\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a8daz81s4xjgke1ww6cwik5w7ye\":\"16\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ayz81h9f3dwp7rzzbdebesc7ute\",\"d3d682bf-e074-49d9-8df5-7320921c2d23\":\"98a57627-0f76-471d-850d-91f3ed9fd213\"}}',1684139123694,1684139123694,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('ci6nx4shmpffitmrx951e4oiptw','2023-05-15 08:25:21.460516','bbn1888mprfrm5fjw9f1je9x3xo',1,'card','Pay bills','{\"contentOrder\":[\"a4zjojnhsrbfkzbf5ukno7g6yey\",\"a9jwwi6qx1j85zpkkr9nfkkkxda\",\"ahf6q3fi9xtykfjcmx4sibf67cw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a9zf59u8x1rf4ywctpcqama7tio\":\"aj4jyekqqssatjcq7r7chmy19ey\",\"abthng7baedhhtrwsdodeuincqy\":\"true\"}}',1684139121453,1684139121452,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('cipuiirpksj84xjb69fzyjorysr','2023-05-15 08:25:29.339933','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Login screen not loading','{\"contentOrder\":[\"a9xctw6b81bgrfju1a5hwcq36ra\",\"aa6m58nop8jd5pg94uzgbtkr9dw\",\"iezeao1oxcjb4jxfb7hs9xhrhur\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"aomnawq4551cbbzha9gxnmb3z5w\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"abrfos7e7eczk9rqw6y5abadm1y\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"c01676ca-babf-4534-8be5-cce2287daa6c\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"1\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"cb8ecdac-38be-4d36-8712-c4d58cc8a8e9\"}}',1684139129332,1684139129332,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ciynnywbiz7rujm5aiphkq3hpmo','2023-05-15 08:25:38.091582','brs9cdimfw7fodyi7erqt747rhc',1,'card','Unblocking Workflows: The Guide to Developer Productivity','{\"contentOrder\":[\"77tz16jtz5x73ncs3dxc3fp1d7h\",\"a1kiesdgeutgzdyw1ez1ypqzbpe\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a39x5cybshwrbjpc3juaakcyj6e\":\"{\\\"from\\\":1638532800000}\",\"ab6mbock6styfe6htf815ph1mhw\":[\"a3pdzi53kpbd4okzdkz6khi87zo\"],\"ae9ar615xoknd8hw8py7mbyr7zo\":\"apy9dcd7zmand615p3h53zjqxjh\",\"agqsoiipowmnu9rdwxm57zrehtr\":\"{\\\"from\\\":1639483200000}\",\"ap4e7kdg7eip7j3c3oyiz39eaoc\":\"https://mattermost.com/newsroom/press-releases/mattermost-unveils-definitive-report-on-the-state-of-developer-productivity-unblocking-workflows-the-guide-to-developer-productivity-2022-edition/\",\"aysx3atqexotgwp5kx6h5i5ancw\":\"a3xky7ygn14osr1mokerbfah5cy\"}}',1684139138084,1684139138084,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('cizmdp6qkrjf9uqixnsu6ea4o8o','2023-05-15 08:25:17.688136','bbkpwdj8x17bdpdqd176n8ctoua',1,'card','Shelby Olson','{\"contentOrder\":[\"a179zkj8ngfbd3k38nkwxpg9wmh\",\"ahact8zrmctbnzknxe9udhawjfe\",\"ageiia35pfjrsfcdyn6fbxbtt4r\",\"axedjwpq1y7ru3c3fne9tuhbiae\",\"a9bqmd5hph3bkpgc1bu6j95btqa\",\"ajg45nyrs7jyubdb8ugpjrasctc\",\"aidjkys6sw387xd5d5yxqsr7cqe\",\"an3gwsu6ztjrfixpmhdahaqt63h\",\"a15gffdupj3y4zyxcmhwswreero\",\"anihyopcbefgpueysxaqwg8emwr\",\"acxfipystmbympxztfx5kiqosry\",\"a9yckxr9rbpyqbx8wxjc5c5tkgc\"],\"icon\":\"?‍♀️\",\"isTemplate\":false,\"properties\":{\"a1438fbbhjeffkexmcfhnx99o1h\":\"(111) 321-5678\",\"a5hwxjsmkn6bak6r7uea5bx1kwc\":\"akj61wc9yxdwyw3t6m8igyf9d5o\",\"abru6tz8uebdxy4skheqidh7zxy\":\"shelby.olson@email.com\",\"ahf43e44h3y8ftanqgzno9z7q7w\":\"$30,000\",\"ainpw47babwkpyj77ic4b9zq9xr\":\"Kadera Global\",\"amahgyn9n4twaapg3jyxb6y4jic\":\"ar6t1ttcumgfuqugg5o4g4mzrza\",\"aro91wme9kfaie5ceu9qasmtcnw\":\"auu9bfzqeuruyjwzzqgz7q8apuw\",\"auhf91pm85f73swwidi4wid8jqe\":\"{\\\"from\\\":1669291200000}\"}}',1684139117679,1684139117679,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('cj4fk3wp3rtn1dyeci9basq1w5o','2023-05-15 08:25:36.413221','bkqk6hpfx7pbsucue7jan5n1o1o',1,'card','Kadera Global','{\"contentOrder\":[\"a4d4xc3pcx3fxtj6d66gmgam3nc\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a1semdhszu1rq17d7et5ydrqqio\":\"aipf3qfgjtkheiayjuxrxbpk9wa\",\"a6cwaq79b1pdpb97wkanmeyy4er\":\"150\",\"ahzspe59iux8wigra8bg6cg18nc\":\"kaderaglobal.com\",\"aiefo7nh9jwisn8b4cgakowithy\":\"$12,000,000\",\"an1eerzscfxn6awdfajbg41uz3h\":\"2015\",\"aozntq4go4nkab688j1s7stqtfc\":\"Seattle, OR\"}}',1684139136402,1684139136402,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('cjhmi67r43pnmtq48nw6jmhxm3a','2023-05-15 08:25:25.683225','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Improve customer NPS score','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"a8nukezwwmknqwjsygg7eaxs9te\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"apqfjst8massbjjhpcsjs3y1yqa\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"as555ipyzopjjpfb5rjtssecw5e\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"82%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"8.5\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"anruuoyez51r3yjxuoc8zoqnwaw\",\"azqnyswk6s1boiwuthscm78qwuo\":\"7\",\"azzbawji5bksj69sekcs4srm1ky\":\"agm9p6gcq15ueuzqq3wd4be39wy\"}}',1684139125676,1684139125676,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('cjsgbbn88fbd8pjcue85wa8xzor','2023-05-15 08:25:21.501209','bbn1888mprfrm5fjw9f1je9x3xo',1,'card','Feed Fluffy','{\"contentOrder\":[\"awuo3zo7wgbb9br1t18d7p7p8ew\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a9zf59u8x1rf4ywctpcqama7tio\":\"an51dnkenmoog9cetapbc4uyt3y\"}}',1684139121494,1684139121494,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('cjztn4z4c53dem8kdnkkq6tc8fa','2023-05-15 08:25:41.321943','bui5izho7dtn77xg3thkiqprc9r',1,'card','App crashing','{\"contentOrder\":[\"79t7rkiuspeneqi9xurou9tqzwh\",\"atkub6nqtjtbgmrpf5y6isjrfoo\",\"aeorq3aruibgampujchzws9um7r\",\"ici1jaxg8j7r68g4bzc6757b7da\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"1fdbb515-edd2-4af5-80fc-437ed2211a49\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"ec6d2bc5-df2b-4f77-8479-e59ceb039946\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"c01676ca-babf-4534-8be5-cce2287daa6c\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"cb8ecdac-38be-4d36-8712-c4d58cc8a8e9\"}}',1684139141315,1684139141315,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('ck1c13wxrg3fnpxem5d8cu76s4o','2023-05-15 08:25:38.055001','brs9cdimfw7fodyi7erqt747rhc',1,'card','[Tweet] Mattermost v6.1 includes card @-mention notifications in Boards','{\"contentOrder\":[\"7i96m7nbsdsex8n6hzuzrmdfjuy\",\"7ed5bwp3gr8yax3mhtuwiaa9gjy\",\"a1pu3zj9hpfr1zebdha8j4dp3iw\",\"a19rb5s9qspdy789wpzat34bdjy\",\"abdasiyq4k7ndtfrdadrias8sjy\",\"id7bu3de1qpf77yr764ts4rnaoe\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a39x5cybshwrbjpc3juaakcyj6e\":\"{\\\"from\\\":1639051200000}\",\"ab6mbock6styfe6htf815ph1mhw\":[\"az8o8pfe9hq6s7xaehoqyc3wpyc\"],\"ae9ar615xoknd8hw8py7mbyr7zo\":\"a9ana1e9w673o5cp8md4xjjwfto\",\"agqsoiipowmnu9rdwxm57zrehtr\":\"{\\\"from\\\":1637668800000}\",\"ap4e7kdg7eip7j3c3oyiz39eaoc\":\"https://twitter.com/Mattermost/status/1463145633162969097?s=20\",\"aysx3atqexotgwp5kx6h5i5ancw\":\"aj8y675weso8kpb6eceqbpj4ruw\"}}',1684139138040,1684139138040,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('ckf7h5amk87fftmj33mk5gf78ih','2023-05-15 08:25:15.745033','b7wnw9awd4pnefryhq51apbzb4c',1,'card','Social Media Strategy','{\"contentOrder\":[\"aeqhexi8j9pykich95cew93h6dh\",\"a3of5ugr877yxufkiujjb5gcooa\",\"awq3cxngkbfnt5fkzpfxczdmnaw\",\"ap85qk77cspb33rwkgj1f6t5saa\",\"amxzpzr3pf3y49pjgrraceemn7h\",\"at619ib5a4fn19r34tizcab3etw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"4cf1568d-530f-4028-8ffd-bdc65249187e\":\"b1abafbf-a038-4a19-8b68-56e0fd2319f7\",\"d777ba3b-8728-40d1-87a6-59406bbbbfb0\":\"d37a61f4-f332-4db9-8b2d-5e0a91aa20ed\"}}',1684139115737,1684139115737,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('ckjptgsceu3fq5fmjmn9d7ugpiw','2023-05-15 08:25:43.185697','buixxjic3xjfkieees4iafdrznc',1,'card','Share cards on Channels','{\"contentOrder\":[\"ad3t6abgiytfx3p5cp4tdj7t33a\",\"axggtfboiptri8yt6qgkaef7qua\",\"a6fageyupsfbyfqebz7opgx9sqy\",\"iiw3hpjncf38ftr5coh8b9gfrna\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/work-with-cards.html#share-card-previews\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"af3p8ztcyxgn8wd9z4az7o9tjeh\",\"acypkejeb5yfujhj9te57p9kaxw\":\"ascd7nm9r491ayot8i86g1gmgqw\"}}',1684139143179,1684139143179,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('cm785iog593gu9c8p3k3wx4eejc','2023-05-15 08:25:40.601544','bsjd59qtpbf888mqez3ge77domw',1,'card','Team communication','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"adjckpdotpgkz7c6wixzw9ipb1e\":\"aq1dwbf661yx337hjcd5q3sbxwa\"}}',1684139140595,1684139140595,0,NULL,'system','','system','b7n3rwgpsspbg9drkn8ztit7yxw'),('cncphrte4e7b8zke1wcjoia415w','2023-05-15 08:25:21.473895','bbn1888mprfrm5fjw9f1je9x3xo',1,'card','Buy groceries','{\"contentOrder\":[\"aouftfp6ui3nhz8y3rwwzarnoky\",\"agp4hy9m6hjbkdqtohoeia1yenh\",\"ac4aoo5dcz38gmbd6yrwwzuy94c\",\"a43erpy3dgbg5pr7z8xhogczaqh\",\"acok1kgr63fdhxyc75nx7y1cnpc\",\"a8qa1t9oegpdtxr1w8inab4o19c\",\"ab5zk7prdiiyopkqnb97ntnxqxh\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a9zf59u8x1rf4ywctpcqama7tio\":\"afpy8s7i45frggprmfsqngsocqh\"}}',1684139121467,1684139121467,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('cne7na65esjff3bhwjdrd1pea4h','2023-05-15 08:25:36.427072','bkqk6hpfx7pbsucue7jan5n1o1o',1,'card','Ositions Inc.','{\"contentOrder\":[\"aztpyqdf41tb9z8xzmnfbxak1sh\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a1semdhszu1rq17d7et5ydrqqio\":\"abajmr34b8g1916w495xjb35iko\",\"a6cwaq79b1pdpb97wkanmeyy4er\":\"2,700\",\"ahzspe59iux8wigra8bg6cg18nc\":\"ositionsinc.com\",\"aiefo7nh9jwisn8b4cgakowithy\":\"$125,000,000\",\"an1eerzscfxn6awdfajbg41uz3h\":\"2004\",\"aozntq4go4nkab688j1s7stqtfc\":\"Berlin, Germany\"}}',1684139136419,1684139136419,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('cnxcks11gwirxjdocdzyzrgupkh','2023-05-15 08:25:25.780242','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Add 10 new customers in the EU','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"apnt1f7na9rzgk1rt49keg7xbiy\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"auw3afh3kfhrfgmjr8muiz137jy\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"a1ts3ftyr8nocsicui98c89uxjy\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"30%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"10\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"acb6dqqs6yson7bbzx6jk9bghjh\",\"azqnyswk6s1boiwuthscm78qwuo\":\"3\",\"azzbawji5bksj69sekcs4srm1ky\":\"agrfeaoj7d8p5ianw5iaf3191ae\"}}',1684139125772,1684139125772,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('corc1ng7xtbdqx8po63utq491ro','2023-05-15 08:25:15.692078','b7wnw9awd4pnefryhq51apbzb4c',1,'card','Team Schedule','{\"contentOrder\":[\"asxkajbi1tfrgm8i9d3x84jfmfe\",\"aucfbqzo8sbbepbd37tehj6bgky\",\"ak6e7c8z5k7yr9gzcss76ndkmna\",\"axdnwf9i75byy8pos6dp38zpnmr\",\"a3anidddoojytdns14cexrxbo9c\",\"anoje9s1eqjgrbjierpddcjjych\"],\"icon\":\"⏰\",\"isTemplate\":false,\"properties\":{\"4cf1568d-530f-4028-8ffd-bdc65249187e\":\"8b05c83e-a44a-4d04-831e-97f01d8e2003\",\"d777ba3b-8728-40d1-87a6-59406bbbbfb0\":\"34eb9c25-d5bf-49d9-859e-f74f4e0030e7\"}}',1684139115677,1684139115677,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('cot7fjjb68pgn9xdgr4yy3pwfur','2023-05-15 08:25:29.325120','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Horizontal scroll issue','{\"contentOrder\":[\"aikzfeo3qytg9bym53moh3iwryo\",\"agzumfpbi1bg37gj3d7zkwj8c1o\",\"ispx6nw5owbd5xpafh3mhngwqho\"],\"icon\":\"〰️\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"aomnawq4551cbbzha9gxnmb3z5w\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"ed4a5340-460d-461b-8838-2c56e8ee59fe\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"1\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139129317,1684139129317,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('cow8jauqkabgb8etq9ckdo8nhrh','2023-05-15 08:25:17.615826','bbkpwdj8x17bdpdqd176n8ctoua',1,'card','Richard Guzman','{\"contentOrder\":[\"afgz6ufu6xjbdpjke4gjhxrzbpa\",\"aksausnmc93dtjjzu86yuqeedze\",\"aasewtfi5nigy5feaxy6ps8a53y\",\"ae4ya94cgbj8gjfmahfw5dosu7e\",\"a3njt16yxsff4xgy6a7esb9acza\",\"aof79cphr9jdntgcw74deqwjypc\",\"ax8k51xesh7g3dqri57sbq9zzdo\",\"auagdeuwwup8k8pdn9fs6joijwo\",\"ajgws6yq75tgm3yg8u39gs9mana\",\"aenz8dktc4ifxdgerg1o5m4tgfc\",\"azptr4acc6jgt9pbach7gb5837e\",\"agpfti6dum7f1tg3uid8uy1wbza\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"a1438fbbhjeffkexmcfhnx99o1h\":\"(222) 123-1234\",\"a5hwxjsmkn6bak6r7uea5bx1kwc\":\"axesd74yuxtbmw1sbk8ufax7z3a\",\"abru6tz8uebdxy4skheqidh7zxy\":\"richard.guzman@email.com\",\"adtf1151chornmihz4xbgbk9exa\":\"{\\\"from\\\":1681992000000}\",\"aejo5tcmq54bauuueem9wc4fw4y\":\"80%\",\"ahf43e44h3y8ftanqgzno9z7q7w\":\"$3,200,000\",\"ainpw47babwkpyj77ic4b9zq9xr\":\"Afformance Ltd.\",\"amahgyn9n4twaapg3jyxb6y4jic\":\"ar6t1ttcumgfuqugg5o4g4mzrza\",\"aro91wme9kfaie5ceu9qasmtcnw\":\"apjnaggwixchfxwiatfh7ey7uno\",\"auhf91pm85f73swwidi4wid8jqe\":\"{\\\"from\\\":1667476800000}\"}}',1684139117609,1684139117609,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('cpx6a1cf3u7b73gsdmmehw7gx7c','2023-05-15 08:25:29.419546','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Epic','{\"contentOrder\":[\"apcmmc1nr47dbfjsue7g8rzjk1h\"],\"icon\":\"?\",\"isTemplate\":true,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"424ea5e3-9aa1-4075-8c5c-01b44b66e634\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"aft5bzo7h9aspqgrx3jpy5tzrer\",\"a1g6i613dpe9oryeo71ex3c86hy\":\"https://mattermost.com/boards/\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"3\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"c62172ea-5da7-4dec-8186-37267d8ee9a7\"}}',1684139129412,1684139129412,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('cqbt1rer5kjy57rycqdqac7a6qy','2023-05-15 08:25:28.181706','bd65qbzuqupfztpg31dgwgwm5ga',1,'card','Start a daily journal','{\"contentOrder\":[],\"icon\":\"✍️\",\"isTemplate\":false,\"properties\":{\"af6fcbb8-ca56-4b73-83eb-37437b9a667d\":\"bf52bfe6-ac4c-4948-821f-83eaa1c7b04a\",\"d6b1249b-bc18-45fc-889e-bec48fce80ef\":\"0a82977f-52bf-457b-841b-e2b7f76fb525\",\"d9725d14-d5a8-48e5-8de1-6f8c004a9680\":\"3245a32d-f688-463b-87f4-8e7142c1b397\"}}',1684139128175,1684139128175,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('cqfonaty9ifrg9mxbr5xk5fyowo','2023-05-15 08:25:23.701408','bc41mwxg9ybb69pn9j5zna6d36c',1,'card','Define project scope','{\"contentOrder\":[\"axzei9dbwufg8dgkn4is7xhtu7r\",\"ad4napirz73dpzp944nognud99o\",\"ak16ghrgwzpfcibwxfaensud9ch\",\"aah9qr9gabiykuxy85dfmojep4r\",\"akja3h5qikjrzxmutooteo9196a\",\"aip3g6feocp8i9fbxf8mtnsomny\",\"aif8a8d7kjfrg5k8ni856wp454r\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a8daz81s4xjgke1ww6cwik5w7ye\":\"32\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ar6b8m3jxr3asyxhr8iucdbo6yc\",\"d3d682bf-e074-49d9-8df5-7320921c2d23\":\"87f59784-b859-4c24-8ebe-17c766e081dd\"}}',1684139123699,1684139123699,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('cqmgjgha55p8ktp9wo46nksj5qo','2023-05-15 08:25:43.927603','buixxjic3xjfkieees4iafdrznc',1,'card','Add new properties','{\"contentOrder\":[\"a3rbis1zhofnefmroitqsp1bcce\",\"ayhk11qsuz789fk8bqae4oz8mro\",\"7gc3z8cf8rirgfyutwoke9nn6jy\",\"76cinqnb6k3dzmfbm9fnc8eofny\",\"ite7n89kgf3ymzfirut1aqzuaoa\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/work-with-cards.html#add-and-manage-properties\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"af3p8ztcyxgn8wd9z4az7o9tjeh\",\"acypkejeb5yfujhj9te57p9kaxw\":\"ascd7nm9r491ayot8i86g1gmgqw\"}}',1684139143218,1684139143218,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('cqpnj7sc9tjrypjrg5ogfco1mho','2023-05-15 08:25:40.642886','bsjd59qtpbf888mqez3ge77domw',1,'card','Positive user feedback','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"adjckpdotpgkz7c6wixzw9ipb1e\":\"aq1dwbf661yx337hjcd5q3sbxwa\"}}',1684139140636,1684139140636,0,NULL,'system','','system','b7n3rwgpsspbg9drkn8ztit7yxw'),('cqxa89unw63yguyhmqeeqpred7e','2023-05-15 08:25:25.710198','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Increase customer retention','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"a8nukezwwmknqwjsygg7eaxs9te\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"apqfjst8massbjjhpcsjs3y1yqa\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"a8zg3rjtf4swh7smsjxpsn743rh\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"66%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"90% customer retention rate\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"acb6dqqs6yson7bbzx6jk9bghjh\",\"azqnyswk6s1boiwuthscm78qwuo\":\"60%\",\"azzbawji5bksj69sekcs4srm1ky\":\"afkxpcjqjypu7hhar7banxau91h\"}}',1684139125703,1684139125703,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('cr47yscucgffhdn5ujwd8j9bdxy','2023-05-15 08:25:25.696370','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Generate more Marketing Qualified Leads (MQLs)','{\"contentOrder\":[],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"a8nukezwwmknqwjsygg7eaxs9te\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"auw3afh3kfhrfgmjr8muiz137jy\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"as555ipyzopjjpfb5rjtssecw5e\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"65%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"100\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"ahfbn1jsmhydym33ygxwg5jt3kh\",\"azqnyswk6s1boiwuthscm78qwuo\":\"65\",\"azzbawji5bksj69sekcs4srm1ky\":\"aehoa17cz18rqnrf75g7dwhphpr\"}}',1684139125690,1684139125690,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('cs8yd11z8eirpjdf6eu8h1uhpjc','2023-05-15 08:25:36.394196','bkqk6hpfx7pbsucue7jan5n1o1o',1,'card','Helx Industries','{\"contentOrder\":[\"a1u4upynm4jfp5k7q5y9easu5ty\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a1semdhszu1rq17d7et5ydrqqio\":\"abt79uxg5edqojsrrefcnr4eruo\",\"a6cwaq79b1pdpb97wkanmeyy4er\":\"650\",\"ahzspe59iux8wigra8bg6cg18nc\":\"helxindustries.com\",\"aiefo7nh9jwisn8b4cgakowithy\":\"$50,000,000\",\"an1eerzscfxn6awdfajbg41uz3h\":\"2009\",\"aozntq4go4nkab688j1s7stqtfc\":\"New York, NY\"}}',1684139136381,1684139136381,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('ctqcabnjrgpbr3pw5nf6q1cugzr','2023-05-15 08:25:43.159513','buixxjic3xjfkieees4iafdrznc',1,'card','Share a board','{\"contentOrder\":[\"a3hdpmeq3zbfrtfgoqafmey7eia\",\"anjsttbf3tpbntpgmy63kegm3yc\",\"7r7asyew8d7fyunf4sow8e5iyoc\",\"ad8j3n8tp77bppee3ipjt6odgpe\",\"7w935usqt6pby8qz9x5pxaj7iow\",\"7ogbs8h6q4j8z7ngy1m7eag63nw\",\"7z1jau5qy3jfcxdp5cgq3duk6ne\",\"ibzdeqmg6rpr6zbuepq3dyys9mw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/sharing-boards.html\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ajurey3xkocs1nwx8di5zx6oe7o\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aq6ukoiciyfctgwyhwzpfss8ghe\"}}',1684139143153,1684139143153,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('cu8oe6owyziy5b81m5n4uofi7xc','2023-05-15 08:25:25.737414','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Hit company global sales target','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"a6robxx81diugpjq5jkezz3j1fo\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"auw3afh3kfhrfgmjr8muiz137jy\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"a8zg3rjtf4swh7smsjxpsn743rh\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"15%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"50MM\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"awfu37js3fomfkkczm1zppac57a\",\"azqnyswk6s1boiwuthscm78qwuo\":\"7.5MM\",\"azzbawji5bksj69sekcs4srm1ky\":\"agrfeaoj7d8p5ianw5iaf3191ae\"}}',1684139125723,1684139125723,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('cu91c9dt6otycpm7pnep9rgn8ky','2023-05-15 08:25:34.422417','bh4pkixqsjift58e1qy6htrgeay',1,'card','Richard Parsons','{\"contentOrder\":[\"aa6w5auxnw3d83dioa7ztm54i7o\"],\"icon\":\"?‍?\",\"isTemplate\":false,\"properties\":{\"aaebj5fyx493eezx6ukxiwydgty\":\"a7yq89whddzob1futao4rxk3yzc\",\"acjq4t5ymytu8x1f68wkggm7ypc\":\"richard.parsons@email.com\",\"aify3r761b9w43bqjtskrzi68tr\":\"Password123\",\"akrxgi7p7w14fym3gbynb98t9fh\":\"{\\\"from\\\":1671019200000}\",\"aqafzdeekpyncwz7m7i54q3iqqy\":\"https://user-images.githubusercontent.com/46905241/121941290-ee355280-cd03-11eb-9b9f-f6f524e4103e.gif\",\"atg9qu6oe4bjm8jczzsn71ff5me\":\"a1sxagjgaadym5yrjak6tcup1oa\"}}',1684139134419,1684139134419,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('cuadbgz3yhpbwxcdaco3xhhzqic','2023-05-15 08:25:29.354636','bgi1yqiis8t8xdqxgnet8ebutky',1,'card','Move cards across boards','{\"contentOrder\":[\"aecekjo6toigp9k9izqesci8uuw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":\"a5yxq8rbubrpnoommfwqmty138h\",\"50117d52-bcc7-4750-82aa-831a351c44a0\":\"abrfos7e7eczk9rqw6y5abadm1y\",\"60985f46-3e41-486e-8213-2b987440ea1c\":\"ed4a5340-460d-461b-8838-2c56e8ee59fe\",\"a1g6i613dpe9oryeo71ex3c86hy\":\"https://mattermost.com/boards/\",\"ai7ajsdk14w7x5s8up3dwir77te\":\"2\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":\"e6a7f297-4440-4783-8ab3-3af5ba62ca11\"}}',1684139129347,1684139129347,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('cupeqsesj6tgaurskg967mtctge','2023-05-15 08:25:21.539701','bbn1888mprfrm5fjw9f1je9x3xo',1,'card','Gardening','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a9zf59u8x1rf4ywctpcqama7tio\":\"afpy8s7i45frggprmfsqngsocqh\"}}',1684139121520,1684139121520,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('cuwu5yqx6xigbjei8gt1foqciic','2023-05-15 08:25:28.239547','bd65qbzuqupfztpg31dgwgwm5ga',1,'card','Open retirement account','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"af6fcbb8-ca56-4b73-83eb-37437b9a667d\":\"bf52bfe6-ac4c-4948-821f-83eaa1c7b04a\",\"d6b1249b-bc18-45fc-889e-bec48fce80ef\":\"0a82977f-52bf-457b-841b-e2b7f76fb525\",\"d9725d14-d5a8-48e5-8de1-6f8c004a9680\":\"80be816c-fc7a-4928-8489-8b02180f4954\"}}',1684139128233,1684139128233,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('cwchj4bcga7b558k6waqjian4ey','2023-05-15 08:25:43.115534','buixxjic3xjfkieees4iafdrznc',1,'card','Drag cards','{\"contentOrder\":[\"apktbgtee5jb8xrnqy3ibiujxew\",\"a87rgrpj9hj8i8egtxphp9qt7rr\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/working-with-boards.html#dragging-cards\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ajurey3xkocs1nwx8di5zx6oe7o\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aq6ukoiciyfctgwyhwzpfss8ghe\"}}',1684139143108,1684139143108,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('cwjh3qjukx38gipog474tobdb3w','2023-05-15 08:25:23.705527','bc41mwxg9ybb69pn9j5zna6d36c',1,'card','Requirements sign-off','{\"contentOrder\":[\"a96ku8fdcoirf3gcnhs84ro7wce\",\"aumref76zp7n9jjk6yzzthif6rh\",\"a5g5byxhrgpdrbn3k8z3xor3btr\",\"araqcr581mirqjbmhi8x4xd1wza\",\"an1cauynf7i87md78gocifotujo\",\"auc36b1696pnfbgakcmht4jxsph\",\"ayqepp51fh3d8prg75ockmnfz3e\"],\"icon\":\"?️\",\"isTemplate\":false,\"properties\":{\"a8daz81s4xjgke1ww6cwik5w7ye\":\"8\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ayz81h9f3dwp7rzzbdebesc7ute\",\"d3d682bf-e074-49d9-8df5-7320921c2d23\":\"d3bfb50f-f569-4bad-8a3a-dd15c3f60101\"}}',1684139123703,1684139123703,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('cwzr9jf3kbpnobqdx18edtbxyze','2023-05-15 08:25:23.714352','bc41mwxg9ybb69pn9j5zna6d36c',1,'card','Conduct market analysis','{\"contentOrder\":[\"akgbx1ddui38sirbij6aan5sbur\",\"adddhxyhoyp8tfme6amns76ssth\",\"aeyxha9paaf8etxhfbkyqcmd9qa\",\"at7h4mzxqw3nx8ctsecufy6zuhe\",\"awgaxdy4rctnnmptqi1a35dzrzw\",\"ae8cp3nwpc3g3m8ujo9rcsd7p4c\",\"aqq3gzop1j3r6zry618epesj6da\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a8daz81s4xjgke1ww6cwik5w7ye\":\"40\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ar6b8m3jxr3asyxhr8iucdbo6yc\",\"d3d682bf-e074-49d9-8df5-7320921c2d23\":\"87f59784-b859-4c24-8ebe-17c766e081dd\"}}',1684139123711,1684139123711,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('cyumdhwtngffq3cgtynr1rgs4ca','2023-05-15 08:25:40.629774','bsjd59qtpbf888mqez3ge77domw',1,'card','Schedule more time for testing','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"adjckpdotpgkz7c6wixzw9ipb1e\":\"akj3fkmxq7idma55mdt8sqpumyw\"}}',1684139140623,1684139140623,0,NULL,'system','','system','b7n3rwgpsspbg9drkn8ztit7yxw'),('cyw3bxrbfepf3tq4m8yfag5h3wo','2023-05-15 08:25:43.971820','buixxjic3xjfkieees4iafdrznc',1,'card','@mention teammates','{\"contentOrder\":[\"agdze3c4gu78m5bke4qwwpigika\",\"afbrk7aqnsigijbmueau4r1mhzy\",\"7mbw9t71hjbrydgzgkqqaoh8usr\",\"i4kqj6jw98in5tyfhoy761ehfhw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/work-with-cards.html#mention-people\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"ajurey3xkocs1nwx8di5zx6oe7o\",\"acypkejeb5yfujhj9te57p9kaxw\":\"aq6ukoiciyfctgwyhwzpfss8ghe\"}}',1684139143941,1684139143941,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('cywrn8u5uqjba9d7dmzk6xrowoe','2023-05-15 08:25:15.710514','b7wnw9awd4pnefryhq51apbzb4c',1,'card','Video production','{\"contentOrder\":[\"am6o87kzyk7gymeyhkq4p48zd1c\",\"asu9m4usdcb8y3ka1hegjs3merh\",\"aeoe3d6d8zbnwjfwcpmbzgmicir\",\"aszwzw4fw8tnzpxmswm3xz19ybh\",\"a3du3x3wpsfdtidw5xsdt1714ze\",\"awjcijjpwhbfgjpz6jmfye5gbcw\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"4cf1568d-530f-4028-8ffd-bdc65249187e\":\"b1abafbf-a038-4a19-8b68-56e0fd2319f7\",\"d777ba3b-8728-40d1-87a6-59406bbbbfb0\":\"34eb9c25-d5bf-49d9-859e-f74f4e0030e7\"}}',1684139115701,1684139115701,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('czbrswa1e77n1zyzhit93g8j1ca','2023-05-15 08:25:25.799425','bcm39o11e4ib8tye8mt6iyuec9o',1,'card','Launch 3 key features','{\"contentOrder\":[],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a17ryhi1jfsboxkwkztwawhmsxe\":\"apnt1f7na9rzgk1rt49keg7xbiy\",\"a6amddgmrzakw66cidqzgk6p4ge\":\"ao9b5pxyt7tkgdohzh9oaustdhr\",\"adp5ft3kgz7r5iqq3tnwg551der\":\"a8zg3rjtf4swh7smsjxpsn743rh\",\"ahz3fmjnaguec8hce7xq3h5cjdr\":\"33%\",\"ajwxp866f9obs1kutfwaa5ru7fe\":\"3\",\"aqxyzkdrs4egqf7yk866ixkaojc\":\"anruuoyez51r3yjxuoc8zoqnwaw\",\"azqnyswk6s1boiwuthscm78qwuo\":\"1\",\"azzbawji5bksj69sekcs4srm1ky\":\"aw5i7hmpadn6mbwbz955ubarhme\"}}',1684139125789,1684139125789,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('czphuqnioo7fydrsb8pu7qrosgw','2023-05-15 08:25:43.211861','buixxjic3xjfkieees4iafdrznc',1,'card','Create a new view','{\"contentOrder\":[\"aozbezukpgif3jpbsq7tahmmp5e\",\"apj4n919rn3n5tn44dzozi43b9a\",\"7owai1ux3h3gtf8byynfk6hyx1c\",\"7n8jq1dizyfgotby3o91arf1hxh\",\"77y4wffj1ctg7xmm9bx45qn6q6o\",\"i9rjjmsuns7g7pphdppgp1wn6ie\"],\"icon\":\"?\",\"isTemplate\":false,\"properties\":{\"a4nfnb5xr3txr5xq7y9ho7kyz6c\":\"https://docs.mattermost.com/boards/working-with-boards.html#adding-new-views\",\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":\"af3p8ztcyxgn8wd9z4az7o9tjeh\",\"acypkejeb5yfujhj9te57p9kaxw\":\"ascd7nm9r491ayot8i86g1gmgqw\"}}',1684139143205,1684139143205,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('i4kqj6jw98in5tyfhoy761ehfhw','2023-05-15 08:25:44.800475','cyw3bxrbfepf3tq4m8yfag5h3wo',1,'image','','{\"fileId\":\"74nt9eqzea3ydjjpgjtsxcjgrxc.gif\"}',1684139144794,1684139144794,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('i6etc7e7omjymxbztaoqp3cpyta','2023-05-15 08:25:41.738022','cbm9y3gmqqjd6uewottgm8mocwh',1,'image','','{\"fileId\":\"7pbp4qg415pbstc6enzeicnu3qh.png\"}',1684139141731,1684139141731,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('i6kfk1wdofpfxjxmwtq8mpg1ohy','2023-05-15 08:25:32.104813','cec73iz548tyzfeagiummkqyh6c',1,'image','','{\"fileId\":\"7tmfu5iqju3n1mdfwi5gru89qmw.png\"}',1684139132098,1684139132098,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('i9rjjmsuns7g7pphdppgp1wn6ie','2023-05-15 08:25:44.723290','czphuqnioo7fydrsb8pu7qrosgw',1,'image','','{\"fileId\":\"78jws5m1myf8pufewzkaa6i11sc.gif\"}',1684139144716,1684139144716,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ibzdeqmg6rpr6zbuepq3dyys9mw','2023-05-15 08:25:44.532387','ctqcabnjrgpbr3pw5nf6q1cugzr',1,'image','','{\"fileId\":\"7knxbyuiedtdafcgmropgkrtybr.gif\"}',1684139144525,1684139144525,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ici1jaxg8j7r68g4bzc6757b7da','2023-05-15 08:25:41.548998','cjztn4z4c53dem8kdnkkq6tc8fa',1,'image','','{\"fileId\":\"77pe9r4ckbin438ph3f18bpatua.png\"}',1684139141542,1684139141542,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('id7bu3de1qpf77yr764ts4rnaoe','2023-05-15 08:25:38.935670','ck1c13wxrg3fnpxem5d8cu76s4o',1,'image','','{\"fileId\":\"7y5kr8x8ybpnwdykjfuz57rggrh.png\"}',1684139138917,1684139138917,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('iezeao1oxcjb4jxfb7hs9xhrhur','2023-05-15 08:25:31.125106','cipuiirpksj84xjb69fzyjorysr',1,'image','','{\"fileId\":\"7b9xk9boj3fbqfm3umeaaizp8qr.png\"}',1684139131118,1684139131118,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ifh3g5uriziy1ic5ute8a7pc3bh','2023-05-15 08:25:41.620285','cfefgwjke6bbxpjpig618g9bpte',1,'image','','{\"fileId\":\"7pbp4qg415pbstc6enzeicnu3qh.png\"}',1684139141613,1684139141612,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('iiw3hpjncf38ftr5coh8b9gfrna','2023-05-15 08:25:44.639595','ckjptgsceu3fq5fmjmn9d7ugpiw',1,'image','','{\"fileId\":\"7ek6wbpp19jfoujs1goh6kttbby.gif\"}',1684139144632,1684139144632,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('iiz5ur5j5gt8c3ygq7z5kasubwa','2023-05-15 08:25:44.493042','c8x3s1st6ijfzuxhrf5aaei76my',1,'image','','{\"fileId\":\"74uia99m9btr8peydw7oexn37tw.gif\"}',1684139144486,1684139144486,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('irib7x5bb9t8ztxmy68up9dfjaa','2023-05-15 08:25:44.571024','cbokq5iftypbs3gspcn15kp1u4r',1,'image','','{\"fileId\":\"7iw4rxx7jj7bypmdotd9z469cyh.png\"}',1684139144565,1684139144565,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('ispx6nw5owbd5xpafh3mhngwqho','2023-05-15 08:25:31.077411','cot7fjjb68pgn9xdgr4yy3pwfur',1,'image','','{\"fileId\":\"7tmfu5iqju3n1mdfwi5gru89qmw.png\"}',1684139131068,1684139131068,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('ite7n89kgf3ymzfirut1aqzuaoa','2023-05-15 08:25:44.772422','cqmgjgha55p8ktp9wo46nksj5qo',1,'image','','{\"fileId\":\"7d6hrtig3zt8f9cnbo1um5oxx3y.gif\"}',1684139144755,1684139144755,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('iupwtx8hqgfn19dxkfj56h48rwo','2023-05-15 08:25:44.694547','c8xeju51trbg38x6xq6spazwsnc',1,'image','','{\"fileId\":\"7dybb6t8fj3nrdft7nerhuf784y.png\"}',1684139144687,1684139144687,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('iye416ctq8irqmb8oqww6fw96bo','2023-05-15 08:25:22.079132','c48fsy6msutb6i8pcnd7axut6kr',1,'image','','{\"fileId\":\"76fwrj36hptg6dywka4k5mt3sph.png\"}',1684139121690,1684139121690,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('v1qqyh58bgtnm9brdh9k3cm8sqy','2023-05-15 08:25:36.344157','',1,'view','Competitor List','{\"cardOrder\":[\"c4htpxn8wxpd6pffpjo4u8xxxxc\",\"cs8yd11z8eirpjdf6eu8h1uhpjc\",\"cj4fk3wp3rtn1dyeci9basq1w5o\",\"c98nnstjzhbgmpj6g88rgpgnheh\",\"cne7na65esjff3bhwjdrd1pea4h\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":210,\"a1semdhszu1rq17d7et5ydrqqio\":121,\"aapogff3xoa8ym7xf56s87kysda\":194,\"ahzspe59iux8wigra8bg6cg18nc\":156,\"aiefo7nh9jwisn8b4cgakowithy\":155,\"aozntq4go4nkab688j1s7stqtfc\":151,\"az3jkw3ynd3mqmart7edypey15e\":145},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"ahzspe59iux8wigra8bg6cg18nc\",\"aozntq4go4nkab688j1s7stqtfc\",\"aiefo7nh9jwisn8b4cgakowithy\",\"a6cwaq79b1pdpb97wkanmeyy4er\",\"an1eerzscfxn6awdfajbg41uz3h\",\"a1semdhszu1rq17d7et5ydrqqio\",\"aapogff3xoa8ym7xf56s87kysda\",\"az3jkw3ynd3mqmart7edypey15e\"]}',1684139136334,1684139136334,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('v3cxngzd1tinibq35wzmm1semfh','2023-05-15 08:25:38.834803','brs9cdimfw7fodyi7erqt747rhc',1,'view','Publication Calendar','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"agqsoiipowmnu9rdwxm57zrehtr\",\"defaultTemplateId\":\"cff1jmrxfrirgbeebhr9qd7nida\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139138150,1684139138150,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('v6fcx5rfyftd9ikkuj9ez9mkgga','2023-05-15 08:25:21.555350','bbn1888mprfrm5fjw9f1je9x3xo',1,'view','List View','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":280},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"a9zf59u8x1rf4ywctpcqama7tio\",\"abthng7baedhhtrwsdodeuincqy\"]}',1684139121546,1684139121546,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('v6ygkz5qrb3dmfk1jdect4j1eyo','2023-05-15 08:25:17.701994','bzwb99zf498tsm7mjqbiy7g81ze',1,'view','Open Deals','{\"cardOrder\":[\"c8tf9wun9gtyc7bzize8f513eqc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[{\"condition\":\"includes\",\"propertyId\":\"a5hwxjsmkn6bak6r7uea5bx1kwc\",\"values\":[\"akj61wc9yxdwyw3t6m8igyf9d5o\",\"aic89a5xox4wbppi6mbyx6ujsda\",\"ah6ehh43rwj88jy4awensin8pcw\",\"aprhd96zwi34o9cs4xyr3o9sf3c\",\"axesd74yuxtbmw1sbk8ufax7z3a\"]}],\"operation\":\"and\"},\"groupById\":\"aro91wme9kfaie5ceu9qasmtcnw\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"apjnaggwixchfxwiatfh7ey7uno\",\"apiswzj7uiwbh87z8dw8c6mturw\",\"auu9bfzqeuruyjwzzqgz7q8apuw\",\"\"],\"visiblePropertyIds\":[]}',1684139117695,1684139117695,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('v7fiuehkgg3yw7dp1c4mcsmmcmc','2023-05-15 08:25:43.990415','buixxjic3xjfkieees4iafdrznc',1,'view','Preview: Table View','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":280,\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":100,\"acypkejeb5yfujhj9te57p9kaxw\":169},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\",\"aqh13jabwexjkzr3jqsz1i1syew\",\"acmg7mz1rr1eykfug4hcdpb1y1o\",\"acypkejeb5yfujhj9te57p9kaxw\"]}',1684139143982,1684139143982,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('v865p4fxmcjb5feezsjpdyh6x6w','2023-05-15 08:25:38.139619','brs9cdimfw7fodyi7erqt747rhc',1,'view','Due Date Calendar','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"a39x5cybshwrbjpc3juaakcyj6e\",\"defaultTemplateId\":\"cff1jmrxfrirgbeebhr9qd7nida\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139138115,1684139138115,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('v89itw6ai7bro8bwok7wgz4ax6c','2023-05-15 08:25:44.007499','buixxjic3xjfkieees4iafdrznc',1,'view','Preview: Calendar View','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"acmg7mz1rr1eykfug4hcdpb1y1o\",\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139144000,1684139144000,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('v89qkmtbnfino7jfxfjdmc33zjr','2023-05-15 08:25:44.038930','buixxjic3xjfkieees4iafdrznc',1,'view','Onboarding','{\"cardOrder\":[\"cbokq5iftypbs3gspcn15kp1u4r\",\"c1skdp9t1mtnjbxcmoshjj94x8a\",\"c8x3s1st6ijfzuxhrf5aaei76my\",\"ckjptgsceu3fq5fmjmn9d7ugpiw\",\"cqmgjgha55p8ktp9wo46nksj5qo\",\"czphuqnioo7fydrsb8pu7qrosgw\",\"cyw3bxrbfepf3tq4m8yfag5h3wo\",\"cwchj4bcga7b558k6waqjian4ey\",\"ctqcabnjrgpbr3pw5nf6q1cugzr\",\"c8xeju51trbg38x6xq6spazwsnc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"aqb5x3pt87dcc9stbk4ofodrpoy\",\"a1mtm777bkagq3iuu7xo9b13qfr\",\"auxbwzptiqzkii5r61uz3ndsy1r\",\"aj9386k1bx8qwmepeuxg3b7z4pw\"],\"visiblePropertyIds\":[]}',1684139144027,1684139144026,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('v8tdd9nrpktby5jmsdzkk9zq4oe','2023-05-15 08:25:28.265977','bd65qbzuqupfztpg31dgwgwm5ga',1,'view','Calendar View','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"ajy6xbebzopojaenbnmfpgtdwso\",\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139128259,1684139128259,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('v9ha9nupshtfgifzrunj7ioftze','2023-05-15 08:25:25.623211','',1,'view','By Quarter','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":452,\"a17ryhi1jfsboxkwkztwawhmsxe\":148,\"a6amddgmrzakw66cidqzgk6p4ge\":230,\"azzbawji5bksj69sekcs4srm1ky\":142},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"aqxyzkdrs4egqf7yk866ixkaojc\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"a6amddgmrzakw66cidqzgk6p4ge\",\"a17ryhi1jfsboxkwkztwawhmsxe\",\"azzbawji5bksj69sekcs4srm1ky\",\"adp5ft3kgz7r5iqq3tnwg551der\",\"aqxyzkdrs4egqf7yk866ixkaojc\",\"adu6mebzpibq6mgcswk69xxmnqe\",\"asope3bddhm4gpsng5cfu4hf6rh\",\"ajwxp866f9obs1kutfwaa5ru7fe\",\"azqnyswk6s1boiwuthscm78qwuo\",\"ahz3fmjnaguec8hce7xq3h5cjdr\",\"a17bfcgnzmkwhziwa4tr38kiw5r\"]}',1684139125611,1684139125611,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('va89mmhx8ab8k9mh9wqj1qhg7bo','2023-05-15 08:25:29.462247','bgi1yqiis8t8xdqxgnet8ebutky',1,'view','By Status','{\"cardOrder\":[\"c8kkpb6wh7igg7nw88x8nfnwf4c\",\"cot7fjjb68pgn9xdgr4yy3pwfur\",\"cuadbgz3yhpbwxcdaco3xhhzqic\",\"cipuiirpksj84xjb69fzyjorysr\",\"c8z9b6w6757nojkqi5k4kc1eggy\",\"c9iwbjcg8w38ip8m9xizycdmesc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"cidz4imnqhir48brz6e8hxhfrhy\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"50117d52-bcc7-4750-82aa-831a351c44a0\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\",\"reversed\":false}],\"viewType\":\"board\",\"visibleOptionIds\":[\"aft5bzo7h9aspqgrx3jpy5tzrer\",\"abrfos7e7eczk9rqw6y5abadm1y\",\"ax8wzbka5ahs3zziji3pp4qp9mc\",\"atabdfbdmjh83136d5e5oysxybw\",\"ace1bzypd586kkyhcht5qqd9eca\",\"aay656c9m1hzwxc9ch5ftymh3nw\",\"a6ghze4iy441qhsh3eijnc8hwze\"],\"visiblePropertyIds\":[\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"60985f46-3e41-486e-8213-2b987440ea1c\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\"]}',1684139129454,1684139129454,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('vb8p8npznajgu7jzuoi8omjwwfy','2023-05-15 08:25:23.730418','bc41mwxg9ybb69pn9j5zna6d36c',1,'view','Task Overview','{\"cardOrder\":[\"cqfonaty9ifrg9mxbr5xk5fyowo\",\"cwzr9jf3kbpnobqdx18edtbxyze\",\"cgf85qmqr7fnyxcfqqw8nf8mn4h\",\"c3e1n8jh85iy8pgqzz8xcdpejoc\",\"cwjh3qjukx38gipog474tobdb3w\",\"cz8p8gofakfby8kzz83j97db8ph\",\"ce1jm5q5i54enhuu4h3kkay1hcc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{\"a8daz81s4xjgke1ww6cwik5w7ye\":\"sum\"},\"columnWidths\":{\"2a5da320-735c-4093-8787-f56e15cdfeed\":196,\"__title\":280,\"a8daz81s4xjgke1ww6cwik5w7ye\":139,\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\":141,\"d3d682bf-e074-49d9-8df5-7320921c2d23\":110},\"defaultTemplateId\":\"czw9es1e89fdpjr7cqptr1xq7qh\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\",\"d3d682bf-e074-49d9-8df5-7320921c2d23\",\"2a5da320-735c-4093-8787-f56e15cdfeed\",\"a3zsw7xs8sxy7atj8b6totp3mby\",\"axkhqa4jxr3jcqe4k87g8bhmary\",\"a7gdnz8ff8iyuqmzddjgmgo9ery\",\"a8daz81s4xjgke1ww6cwik5w7ye\"]}',1684139123728,1684139123728,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('vc6qq7pxpptfzxrx3pgqhz6t3bo','2023-05-15 08:25:34.458332','bixohg18tt11in4qbtinimk974y',1,'view','By Status','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"af6hjb3ysuaxbwnfqpby4wwnkdr\",\"aotxum1p5bw3xuzqz3ctjw66yww\",\"a7yq89whddzob1futao4rxk3yzc\",\"aseqq9hrsua56r3s6nbuirj9eec\",\"ap93ysuzy1xa7z818r6myrn4h4y\"],\"visiblePropertyIds\":[]}',1684139134449,1684139134449,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('vdm7hc76sq3rf78sbwte58a4uah','2023-05-15 08:25:41.535616','bui5izho7dtn77xg3thkiqprc9r',1,'view','List: Bugs ?','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"50117d52-bcc7-4750-82aa-831a351c44a0\":145,\"__title\":280},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[{\"condition\":\"includes\",\"propertyId\":\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"values\":[\"1fdbb515-edd2-4af5-80fc-437ed2211a49\"]}],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\",\"reversed\":false}],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"50117d52-bcc7-4750-82aa-831a351c44a0\",\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"60985f46-3e41-486e-8213-2b987440ea1c\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\"]}',1684139141529,1684139141528,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('vdtafoycmw3gadf86gumendx8fw','2023-05-15 08:25:23.725406','bc41mwxg9ybb69pn9j5zna6d36c',1,'view','Progress Tracker','{\"cardOrder\":[\"c3e1n8jh85iy8pgqzz8xcdpejoc\",\"cwjh3qjukx38gipog474tobdb3w\",\"cgf85qmqr7fnyxcfqqw8nf8mn4h\",\"cwzr9jf3kbpnobqdx18edtbxyze\",\"cqfonaty9ifrg9mxbr5xk5fyowo\",\"coxnjt3ro1in19dd1e3awdt338r\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{\"\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"adeo5xuwne3qjue83fcozekz8ko\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"afi4o5nhnqc3smtzs1hs3ij34dh\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"ahpyxfnnrzynsw3im1psxpkgtpe\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"ar6b8m3jxr3asyxhr8iucdbo6yc\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"ayz81h9f3dwp7rzzbdebesc7ute\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"}},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"ayz81h9f3dwp7rzzbdebesc7ute\",\"ar6b8m3jxr3asyxhr8iucdbo6yc\",\"afi4o5nhnqc3smtzs1hs3ij34dh\",\"adeo5xuwne3qjue83fcozekz8ko\",\"ahpyxfnnrzynsw3im1psxpkgtpe\",\"\"],\"visiblePropertyIds\":[\"d3d682bf-e074-49d9-8df5-7320921c2d23\",\"a8daz81s4xjgke1ww6cwik5w7ye\"]}',1684139123722,1684139123722,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('veo99rnraz7gx7frqum54qdyo3h','2023-05-15 08:25:28.252604','bd65qbzuqupfztpg31dgwgwm5ga',1,'view','By Status','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"af6fcbb8-ca56-4b73-83eb-37437b9a667d\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"bf52bfe6-ac4c-4948-821f-83eaa1c7b04a\",\"77c539af-309c-4db1-8329-d20ef7e9eacd\",\"98bdea27-0cce-4cde-8dc6-212add36e63a\",\"\"],\"visiblePropertyIds\":[\"d9725d14-d5a8-48e5-8de1-6f8c004a9680\",\"d6b1249b-bc18-45fc-889e-bec48fce80ef\"]}',1684139128246,1684139128246,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('vgjqjigmp93yt9k1frx7kqgqgqh','2023-05-15 08:25:44.020575','buixxjic3xjfkieees4iafdrznc',1,'view','Preview: Gallery View','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"gallery\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139144014,1684139144014,0,NULL,'system','','system','b8mrrx4qbjbfh78rh39s55bosec'),('vgnezwn91c38e3e8zq9uz6ki3zr','2023-05-15 08:25:38.869330','brs9cdimfw7fodyi7erqt747rhc',1,'view','Content List','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":322,\"ab6mbock6styfe6htf815ph1mhw\":229,\"aysx3atqexotgwp5kx6h5i5ancw\":208},\"defaultTemplateId\":\"cff1jmrxfrirgbeebhr9qd7nida\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"a39x5cybshwrbjpc3juaakcyj6e\",\"reversed\":false}],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"ae9ar615xoknd8hw8py7mbyr7zo\",\"aysx3atqexotgwp5kx6h5i5ancw\",\"ab6mbock6styfe6htf815ph1mhw\",\"ao44fz8nf6z6tuj1x31t9yyehcc\",\"a39x5cybshwrbjpc3juaakcyj6e\",\"agqsoiipowmnu9rdwxm57zrehtr\",\"ap4e7kdg7eip7j3c3oyiz39eaoc\"]}',1684139138847,1684139138847,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('vhkudrzy1fjnyxc7qp5xrxf6m3c','2023-05-15 08:25:29.290650','',1,'view','By Sprint','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{\"ai7ajsdk14w7x5s8up3dwir77te\":\"count\"},\"columnWidths\":{\"20717ad3-5741-4416-83f1-6f133fff3d11\":128,\"50117d52-bcc7-4750-82aa-831a351c44a0\":126,\"__title\":280,\"a1g6i613dpe9oryeo71ex3c86hy\":159,\"aeomttrbhhsi8bph31jn84sto6h\":141,\"ax9f8so418s6s65hi5ympd93i6a\":183,\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\":100},\"defaultTemplateId\":\"c1axsmo6e5i8tf8xun3qyk57ytr\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"60985f46-3e41-486e-8213-2b987440ea1c\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"50117d52-bcc7-4750-82aa-831a351c44a0\",\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"60985f46-3e41-486e-8213-2b987440ea1c\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\",\"aphg37f7zbpuc3bhwhp19s1ribh\",\"a4378omyhmgj3bex13sj4wbpfiy\",\"ai7ajsdk14w7x5s8up3dwir77te\",\"a1g6i613dpe9oryeo71ex3c86hy\",\"aeomttrbhhsi8bph31jn84sto6h\",\"ax9f8so418s6s65hi5ympd93i6a\"]}',1684139129281,1684139129281,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('vk9swnjd6bbbhxppuanupxkgx8a','2023-05-15 08:25:38.107562','brs9cdimfw7fodyi7erqt747rhc',1,'view','By Status','{\"cardOrder\":[null,\"cdbfkd15d6iy18rgx1tskmfsr6c\",\"cn8yofg9rtkgmzgmb5xdi56p3ic\",\"csgsnnywpuqzs5jgq87snk9x17e\",\"cqwaytore5y487wdu8zffppqnea\",null],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"cff1jmrxfrirgbeebhr9qd7nida\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"awna1nuarjca99m9s4uiy9kwj5h\",\"a9ana1e9w673o5cp8md4xjjwfto\",\"apy9dcd7zmand615p3h53zjqxjh\",\"acri4cm3bmay55f7ksztphmtnga\",\"amsowcd9a8e1kid317r7ttw6uzh\",\"\"],\"visiblePropertyIds\":[\"ab6mbock6styfe6htf815ph1mhw\"]}',1684139138099,1684139138099,0,NULL,'system','','system','b6ur1qsgeop88fb3dhedjrktcbw'),('vm38m6nzr9igxbb1igwucpsng6o','2023-05-15 08:25:28.279767','bd65qbzuqupfztpg31dgwgwm5ga',1,'view','By Date','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"d6b1249b-bc18-45fc-889e-bec48fce80ef\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"9a090e33-b110-4268-8909-132c5002c90e\",\"0a82977f-52bf-457b-841b-e2b7f76fb525\",\"6e7139e4-5358-46bb-8c01-7b029a57b80a\",\"d5371c63-66bf-4468-8738-c4dc4bea4843\",\"\"],\"visiblePropertyIds\":[\"d9725d14-d5a8-48e5-8de1-6f8c004a9680\"]}',1684139128273,1684139128273,0,NULL,'system','','system','biq6ryjojzfrs5ehpj6wjrg6ear'),('vnmhimtfhetgutrqj9eeqd46arh','2023-05-15 08:25:34.446335','bh4pkixqsjift58e1qy6htrgeay',1,'view','By Date','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"akrxgi7p7w14fym3gbynb98t9fh\",\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139134443,1684139134443,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc'),('vq5xhbkz5abyadkqiwg7feafgrr','2023-05-15 08:25:15.758483','b7wnw9awd4pnefryhq51apbzb4c',1,'view','Discussion Items','{\"cardOrder\":[\"cjpkiya33qsagr4f9hrdwhgiajc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"d777ba3b-8728-40d1-87a6-59406bbbbfb0\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"4cf1568d-530f-4028-8ffd-bdc65249187e\",\"reversed\":false}],\"viewType\":\"board\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"4cf1568d-530f-4028-8ffd-bdc65249187e\"]}',1684139115752,1684139115752,0,NULL,'system','','system','bz8r98156ppgxdctqjuxytu5cgc'),('vqignh3q8ej8tzxajzxb844me1y','2023-05-15 08:25:17.573515','',1,'view','All Contacts','{\"cardOrder\":[\"cizmdp6qkrjf9uqixnsu6ea4o8o\",\"c8tf9wun9gtyc7bzize8f513eqc\",\"cow8jauqkabgb8etq9ckdo8nhrh\",\"c5jaxbc9m6jn3dxcfhro94u1hpr\",\"cdykszx7gffnibcgf4p9gzdit9a\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":240,\"a1438fbbhjeffkexmcfhnx99o1h\":151,\"a5hwxjsmkn6bak6r7uea5bx1kwc\":132,\"abru6tz8uebdxy4skheqidh7zxy\":247,\"adtf1151chornmihz4xbgbk9exa\":125,\"aejo5tcmq54bauuueem9wc4fw4y\":127,\"ahf43e44h3y8ftanqgzno9z7q7w\":129,\"ainpw47babwkpyj77ic4b9zq9xr\":157,\"amahgyn9n4twaapg3jyxb6y4jic\":224,\"amba7ot98fh7hwsx8jdcfst5g7h\":171,\"aoheuj1f3mu6eehygr45fxa144y\":130,\"auhf91pm85f73swwidi4wid8jqe\":157},\"defaultTemplateId\":\"c7ho5n7y4t7fyimowcpjxuumtea\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"a5hwxjsmkn6bak6r7uea5bx1kwc\",\"aoheuj1f3mu6eehygr45fxa144y\",\"aro91wme9kfaie5ceu9qasmtcnw\",\"ainpw47babwkpyj77ic4b9zq9xr\",\"ahf43e44h3y8ftanqgzno9z7q7w\",\"amahgyn9n4twaapg3jyxb6y4jic\",\"abru6tz8uebdxy4skheqidh7zxy\",\"a1438fbbhjeffkexmcfhnx99o1h\",\"auhf91pm85f73swwidi4wid8jqe\",\"adtf1151chornmihz4xbgbk9exa\",\"aejo5tcmq54bauuueem9wc4fw4y\",\"amba7ot98fh7hwsx8jdcfst5g7h\"]}',1684139117562,1684139117562,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('vqsbfiew86inqxyxxjddcburbpc','2023-05-15 08:25:41.522105','bui5izho7dtn77xg3thkiqprc9r',1,'view','Board: Status','{\"cardOrder\":[\"cjztn4z4c53dem8kdnkkq6tc8fa\",\"cm4w7cc3aac6s9jdcujbs4j8f4r\",\"c6egh6cpnj137ixdoitsoxq17oo\",\"cct9u78utsdyotmejbmwwg66ihr\",\"cmft87it1q7yebbd51ij9k65xbw\",\"c9fe77j9qcruxf4itzib7ag6f1c\",\"coup7afjknqnzbdwghiwbsq541w\",\"c5ex1hndz8qyc8gx6ofbfeksftc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"cidz4imnqhir48brz6e8hxhfrhy\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"50117d52-bcc7-4750-82aa-831a351c44a0\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\",\"reversed\":false}],\"viewType\":\"board\",\"visibleOptionIds\":[\"8c557f69-b0ed-46ec-83a3-8efab9d47ef5\",\"ec6d2bc5-df2b-4f77-8479-e59ceb039946\",\"849766ba-56a5-48d1-886f-21672f415395\",\"\"],\"visiblePropertyIds\":[\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"60985f46-3e41-486e-8213-2b987440ea1c\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\"]}',1684139141514,1684139141514,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('vr77dgw7znidhbcery4hid5spfy','2023-05-15 08:25:21.566817','bbn1888mprfrm5fjw9f1je9x3xo',1,'view','Board View','{\"cardOrder\":[\"cncphrte4e7b8zke1wcjoia415w\",\"ci6nx4shmpffitmrx951e4oiptw\",\"c48fsy6msutb6i8pcnd7axut6kr\",\"cjsgbbn88fbd8pjcue85wa8xzor\",\"czowhma7rnpgb3eczbqo3t7fijo\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"a9zf59u8x1rf4ywctpcqama7tio\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"an51dnkenmoog9cetapbc4uyt3y\",\"afpy8s7i45frggprmfsqngsocqh\",\"aj4jyekqqssatjcq7r7chmy19ey\",\"\"],\"visiblePropertyIds\":[\"a9zf59u8x1rf4ywctpcqama7tio\"]}',1684139121561,1684139121561,0,NULL,'system','','system','bbddcn4qrgbrbmrhy45qqk8rr5o'),('vsueronrkbpndijpe65rgud18go','2023-05-15 08:25:23.734907','bc41mwxg9ybb69pn9j5zna6d36c',1,'view','Task Calendar','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"a3zsw7xs8sxy7atj8b6totp3mby\",\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139123732,1684139123732,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('vt67wb991m7nk8xg3qa77d7q58c','2023-05-15 08:25:36.359668','',1,'view','Market Position','{\"cardOrder\":[\"cip8b4jcomfr7by9gtizebikfke\",\"cacs91js1hb887ds41r6dwnd88c\",\"ca3u8edwrof89i8obxffnz4xw3a\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"arfjpz9by5car71tz3behba8yih\",\"abajmr34b8g1916w495xjb35iko\",\"abt79uxg5edqojsrrefcnr4eruo\",\"aipf3qfgjtkheiayjuxrxbpk9wa\"],\"visiblePropertyIds\":[]}',1684139136352,1684139136352,0,NULL,'system','','system','bhn75zdik6bng5muchaoh6k7guh'),('vtffntayuetdspgiy86gu6za77y','2023-05-15 08:25:31.031166','bgi1yqiis8t8xdqxgnet8ebutky',1,'view','By Type','{\"cardOrder\":[\"cipuiirpksj84xjb69fzyjorysr\",\"cuadbgz3yhpbwxcdaco3xhhzqic\",\"c8z9b6w6757nojkqi5k4kc1eggy\",\"cot7fjjb68pgn9xdgr4yy3pwfur\",\"c8kkpb6wh7igg7nw88x8nfnwf4c\",\"c9iwbjcg8w38ip8m9xizycdmesc\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"cidz4imnqhir48brz6e8hxhfrhy\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\",\"reversed\":false}],\"viewType\":\"board\",\"visibleOptionIds\":[\"424ea5e3-9aa1-4075-8c5c-01b44b66e634\",\"a5yxq8rbubrpnoommfwqmty138h\",\"apht1nt5ryukdmxkh6fkfn6rgoy\",\"aiycbuo3dr5k4xxbfr7coem8ono\",\"aomnawq4551cbbzha9gxnmb3z5w\"],\"visiblePropertyIds\":[\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\"]}',1684139129469,1684139129469,0,NULL,'system','','system','bjxj5yzhuupdfpysci4zbwksn8a'),('vtmbz6e1kabdf7nn73ncnbtk35r','2023-05-15 08:25:40.570878','bjbhs6bos3m8zjouf78xceg9nqw',1,'view','Board view','{\"cardOrder\":[\"cniwb8xwcqtbstbcm3sdfrr854h\",\"cs4qwpzr65fgttd7364dicskanh\",\"c9s78pzbdg3g4jkcdjqahtnfejc\",\"c8utmazns878jtfgtf7exyi9pee\",\"cnobejmb6bf8e3c1w7em5z4pwyh\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"aok6pgecm85qe9k5kcphzoe63ma\",\"aq1dwbf661yx337hjcd5q3sbxwa\",\"ar87yh5xmsswqkxmjq1ipfftfpc\",\"akj3fkmxq7idma55mdt8sqpumyw\"],\"visiblePropertyIds\":[\"aspaay76a5wrnuhtqgm97tt3rer\"]}',1684139140563,1684139140563,0,NULL,'system','','system','b7n3rwgpsspbg9drkn8ztit7yxw'),('vwa8btb3if3rfppqgektkkksyww','2023-05-15 08:25:23.720074','bc41mwxg9ybb69pn9j5zna6d36c',1,'view','Project Priorities','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"d3d682bf-e074-49d9-8df5-7320921c2d23\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{\"\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"87f59784-b859-4c24-8ebe-17c766e081dd\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"98a57627-0f76-471d-850d-91f3ed9fd213\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"},\"d3bfb50f-f569-4bad-8a3a-dd15c3f60101\":{\"calculation\":\"sum\",\"propertyId\":\"a8daz81s4xjgke1ww6cwik5w7ye\"}},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"d3bfb50f-f569-4bad-8a3a-dd15c3f60101\",\"87f59784-b859-4c24-8ebe-17c766e081dd\",\"98a57627-0f76-471d-850d-91f3ed9fd213\",\"\"],\"visiblePropertyIds\":[\"a972dc7a-5f4c-45d2-8044-8c28c69717f1\",\"a8daz81s4xjgke1ww6cwik5w7ye\"]}',1684139123717,1684139123717,0,NULL,'system','','system','b5mngenjjgtbrzrqi1dyk4m3ekr'),('vx7c7zr5oxjrh7fsfpbep1mhuzo','2023-05-15 08:25:25.649945','',1,'view','By Objectives','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":387,\"a17ryhi1jfsboxkwkztwawhmsxe\":134,\"a6amddgmrzakw66cidqzgk6p4ge\":183,\"aqxyzkdrs4egqf7yk866ixkaojc\":100},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"a6amddgmrzakw66cidqzgk6p4ge\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"a6amddgmrzakw66cidqzgk6p4ge\",\"a17ryhi1jfsboxkwkztwawhmsxe\",\"azzbawji5bksj69sekcs4srm1ky\",\"adp5ft3kgz7r5iqq3tnwg551der\",\"aqxyzkdrs4egqf7yk866ixkaojc\",\"adu6mebzpibq6mgcswk69xxmnqe\",\"asope3bddhm4gpsng5cfu4hf6rh\",\"ajwxp866f9obs1kutfwaa5ru7fe\",\"azqnyswk6s1boiwuthscm78qwuo\",\"ahz3fmjnaguec8hce7xq3h5cjdr\",\"a17bfcgnzmkwhziwa4tr38kiw5r\"]}',1684139125630,1684139125630,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('vx9f7sjs7tiniirhsse5d7iwptc','2023-05-15 08:25:17.587304','',1,'view','Pipeline Tracker','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"akj61wc9yxdwyw3t6m8igyf9d5o\",\"aic89a5xox4wbppi6mbyx6ujsda\",\"ah6ehh43rwj88jy4awensin8pcw\",\"aprhd96zwi34o9cs4xyr3o9sf3c\",\"axesd74yuxtbmw1sbk8ufax7z3a\",\"a5txuiubumsmrs8gsd5jz5gc1oa\",\"acm9q494bcthyoqzmfogxxy5czy\"],\"visiblePropertyIds\":[\"aro91wme9kfaie5ceu9qasmtcnw\",\"amahgyn9n4twaapg3jyxb6y4jic\"]}',1684139117580,1684139117580,0,NULL,'system','','system','bsq4isof5rtduf8g6kdye1uk3jw'),('vxesg73gh878fmbbf378cedsgze','2023-05-15 08:25:25.839683','bm4ubx56krp4zwyfcqh7nxiigbr',1,'view','Departments','{\"cardOrder\":[\"cpa534b5natgmunis8u1ixb55pw\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"azzbawji5bksj69sekcs4srm1ky\",\"hiddenOptionIds\":[\"\"],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"board\",\"visibleOptionIds\":[\"aw5i7hmpadn6mbwbz955ubarhme\",\"afkxpcjqjypu7hhar7banxau91h\",\"aehoa17cz18rqnrf75g7dwhphpr\",\"agrfeaoj7d8p5ianw5iaf3191ae\",\"agm9p6gcq15ueuzqq3wd4be39wy\",\"aucop7kw6xwodcix6zzojhxih6r\",\"afust91f3g8ht368mkn5x9tgf1o\",\"acocxxwjurud1jixhp7nowdig7y\"],\"visiblePropertyIds\":[]}',1684139125829,1684139125829,0,NULL,'system','','system','bdprp7sm54jg49p8quqy34gj41a'),('vy6pu7kjg7bgrxfp1h89d3krh1e','2023-05-15 08:25:41.504501','bui5izho7dtn77xg3thkiqprc9r',1,'view','List: Tasks ?','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"50117d52-bcc7-4750-82aa-831a351c44a0\":139,\"__title\":280},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[{\"condition\":\"includes\",\"propertyId\":\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"values\":[\"6eea96c9-4c61-4968-8554-4b7537e8f748\"]}],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"50117d52-bcc7-4750-82aa-831a351c44a0\",\"reversed\":true}],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"50117d52-bcc7-4750-82aa-831a351c44a0\",\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"60985f46-3e41-486e-8213-2b987440ea1c\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\"]}',1684139141494,1684139141494,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('vyekfi9htpfr8pnc7ea8i6zizsc','2023-05-15 08:25:41.485163','bui5izho7dtn77xg3thkiqprc9r',1,'view','Board: Sprints','{\"cardOrder\":[\"cjztn4z4c53dem8kdnkkq6tc8fa\",\"cffwedhcphjnxdnx7gi5ef487mc\",\"c6sc3f5fjmf8cbcqchzku19mg9a\",\"cbm9y3gmqqjd6uewottgm8mocwh\",\"c4qc8gzhjipf6mmbat9du8ye9kr\",\"c3zpru7o6ibfxup6ej47xu8mc4a\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"groupById\":\"60985f46-3e41-486e-8213-2b987440ea1c\",\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\",\"reversed\":false}],\"viewType\":\"board\",\"visibleOptionIds\":[\"c01676ca-babf-4534-8be5-cce2287daa6c\",\"ed4a5340-460d-461b-8838-2c56e8ee59fe\",\"14892380-1a32-42dd-8034-a0cea32bc7e6\",\"\"],\"visiblePropertyIds\":[\"20717ad3-5741-4416-83f1-6f133fff3d11\",\"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\"]}',1684139141459,1684139141459,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('vyifygeiis7yefnyg5gu379thdr','2023-05-15 08:25:41.449633','bui5izho7dtn77xg3thkiqprc9r',1,'view','Calendar View','{\"cardOrder\":[],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{},\"dateDisplayPropertyId\":\"a4378omyhmgj3bex13sj4wbpfiy\",\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[],\"viewType\":\"calendar\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"__title\"]}',1684139141438,1684139141438,0,NULL,'system','','system','bsey5p6ygqfff9eqbcfarbzscdw'),('vyu5phyeg47ncuffagi333r6ofo','2023-05-15 08:25:33.258463','',1,'view','All Users','{\"cardOrder\":[\"ccfkf8w5ntpfx7d7afp8upt6jca\"],\"collapsedOptionIds\":[],\"columnCalculations\":{},\"columnWidths\":{\"__title\":280,\"aaebj5fyx493eezx6ukxiwydgty\":146,\"acjq4t5ymytu8x1f68wkggm7ypc\":222,\"akrxgi7p7w14fym3gbynb98t9fh\":131,\"atg9qu6oe4bjm8jczzsn71ff5me\":131},\"defaultTemplateId\":\"\",\"filter\":{\"filters\":[],\"operation\":\"and\"},\"hiddenOptionIds\":[],\"kanbanCalculations\":{},\"sortOptions\":[{\"propertyId\":\"akrxgi7p7w14fym3gbynb98t9fh\",\"reversed\":false}],\"viewType\":\"table\",\"visibleOptionIds\":[],\"visiblePropertyIds\":[\"aaebj5fyx493eezx6ukxiwydgty\",\"akrxgi7p7w14fym3gbynb98t9fh\",\"atg9qu6oe4bjm8jczzsn71ff5me\",\"acjq4t5ymytu8x1f68wkggm7ypc\",\"aphio1s5gkmpdbwoxynim7acw3e\",\"aqafzdeekpyncwz7m7i54q3iqqy\",\"aify3r761b9w43bqjtskrzi68tr\"]}',1684139133247,1684139133247,0,NULL,'system','','system','bz7o1isbn7if4jkbt3bc6nb4kqc');
/*!40000 ALTER TABLE `focalboard_blocks_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_board_members`
--

DROP TABLE IF EXISTS `focalboard_board_members`;
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

--
-- Dumping data for table `focalboard_board_members`
--

LOCK TABLES `focalboard_board_members` WRITE;
/*!40000 ALTER TABLE `focalboard_board_members` DISABLE KEYS */;
INSERT INTO `focalboard_board_members` VALUES ('b5mngenjjgtbrzrqi1dyk4m3ekr','system','',1,0,0,0),('b6ur1qsgeop88fb3dhedjrktcbw','system','',1,0,0,0),('b7n3rwgpsspbg9drkn8ztit7yxw','system','',1,0,0,0),('b8mrrx4qbjbfh78rh39s55bosec','system','',1,0,0,0),('bbddcn4qrgbrbmrhy45qqk8rr5o','system','',1,0,0,0),('bdprp7sm54jg49p8quqy34gj41a','system','',1,0,0,0),('bhn75zdik6bng5muchaoh6k7guh','system','',1,0,0,0),('biq6ryjojzfrs5ehpj6wjrg6ear','system','',1,0,0,0),('bjxj5yzhuupdfpysci4zbwksn8a','system','',1,0,0,0),('bsey5p6ygqfff9eqbcfarbzscdw','system','',1,0,0,0),('bsq4isof5rtduf8g6kdye1uk3jw','system','',1,0,0,0),('bz7o1isbn7if4jkbt3bc6nb4kqc','system','',1,0,0,0),('bz8r98156ppgxdctqjuxytu5cgc','system','',1,0,0,0);
/*!40000 ALTER TABLE `focalboard_board_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_board_members_history`
--

DROP TABLE IF EXISTS `focalboard_board_members_history`;
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

--
-- Dumping data for table `focalboard_board_members_history`
--

LOCK TABLES `focalboard_board_members_history` WRITE;
/*!40000 ALTER TABLE `focalboard_board_members_history` DISABLE KEYS */;
INSERT INTO `focalboard_board_members_history` VALUES ('b5mngenjjgtbrzrqi1dyk4m3ekr','system','created','2023-05-15 08:25:25.542885'),('b6ur1qsgeop88fb3dhedjrktcbw','system','created','2023-05-15 08:25:40.438947'),('b7n3rwgpsspbg9drkn8ztit7yxw','system','created','2023-05-15 08:25:41.264148'),('b8mrrx4qbjbfh78rh39s55bosec','system','created','2023-05-15 08:25:46.628182'),('bbddcn4qrgbrbmrhy45qqk8rr5o','system','created','2023-05-15 08:25:23.445472'),('bdprp7sm54jg49p8quqy34gj41a','system','created','2023-05-15 08:25:28.120177'),('bhn75zdik6bng5muchaoh6k7guh','system','created','2023-05-15 08:25:37.952260'),('biq6ryjojzfrs5ehpj6wjrg6ear','system','created','2023-05-15 08:25:29.211516'),('bjxj5yzhuupdfpysci4zbwksn8a','system','created','2023-05-15 08:25:33.197957'),('bsey5p6ygqfff9eqbcfarbzscdw','system','created','2023-05-15 08:25:42.961106'),('bsq4isof5rtduf8g6kdye1uk3jw','system','created','2023-05-15 08:25:21.319654'),('bz7o1isbn7if4jkbt3bc6nb4kqc','system','created','2023-05-15 08:25:36.281629'),('bz8r98156ppgxdctqjuxytu5cgc','system','created','2023-05-15 08:25:17.066349');
/*!40000 ALTER TABLE `focalboard_board_members_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_boards`
--

DROP TABLE IF EXISTS `focalboard_boards`;
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

--
-- Dumping data for table `focalboard_boards`
--

LOCK TABLES `focalboard_boards` WRITE;
/*!40000 ALTER TABLE `focalboard_boards` DISABLE KEYS */;
INSERT INTO `focalboard_boards` VALUES ('b5mngenjjgtbrzrqi1dyk4m3ekr','2023-05-15 08:25:23.691168','0','','system','system','O','Project Tasks ','Use this template to stay on top of your project tasks and progress.','?',1,1,6,'{\"trackingTemplateId\": \"a4ec399ab4f2088b1051c3cdf1dde4c3\"}','[{\"id\": \"a972dc7a-5f4c-45d2-8044-8c28c69717f1\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"ayz81h9f3dwp7rzzbdebesc7ute\", \"color\": \"propColorBlue\", \"value\": \"Not Started\"}, {\"id\": \"ar6b8m3jxr3asyxhr8iucdbo6yc\", \"color\": \"propColorYellow\", \"value\": \"In Progress\"}, {\"id\": \"afi4o5nhnqc3smtzs1hs3ij34dh\", \"color\": \"propColorRed\", \"value\": \"Blocked\"}, {\"id\": \"adeo5xuwne3qjue83fcozekz8ko\", \"color\": \"propColorGreen\", \"value\": \"Completed ?\"}, {\"id\": \"ahpyxfnnrzynsw3im1psxpkgtpe\", \"color\": \"propColorBrown\", \"value\": \"Archived\"}]}, {\"id\": \"d3d682bf-e074-49d9-8df5-7320921c2d23\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"d3bfb50f-f569-4bad-8a3a-dd15c3f60101\", \"color\": \"propColorRed\", \"value\": \"1. High ?\"}, {\"id\": \"87f59784-b859-4c24-8ebe-17c766e081dd\", \"color\": \"propColorYellow\", \"value\": \"2. Medium\"}, {\"id\": \"98a57627-0f76-471d-850d-91f3ed9fd213\", \"color\": \"propColorGray\", \"value\": \"3. Low\"}]}, {\"id\": \"axkhqa4jxr3jcqe4k87g8bhmary\", \"name\": \"Assignee\", \"type\": \"person\", \"options\": []}, {\"id\": \"a8daz81s4xjgke1ww6cwik5w7ye\", \"name\": \"Estimated Hours\", \"type\": \"number\", \"options\": []}, {\"id\": \"a3zsw7xs8sxy7atj8b6totp3mby\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"a7gdnz8ff8iyuqmzddjgmgo9ery\", \"name\": \"Created By\", \"type\": \"createdBy\", \"options\": []}, {\"id\": \"2a5da320-735c-4093-8787-f56e15cdfeed\", \"name\": \"Date Created\", \"type\": \"createdTime\", \"options\": []}]',1684139123690,1684139123690,0,''),('b6ur1qsgeop88fb3dhedjrktcbw','2023-05-15 08:25:37.983912','0','','system','system','O','Content Calendar ','Use this template to plan and organize your editorial content.','?',1,1,6,'{\"trackingTemplateId\": \"c75fbd659d2258b5183af2236d176ab4\"}','[{\"id\": \"ae9ar615xoknd8hw8py7mbyr7zo\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"awna1nuarjca99m9s4uiy9kwj5h\", \"color\": \"propColorGray\", \"value\": \"Idea ?\"}, {\"id\": \"a9ana1e9w673o5cp8md4xjjwfto\", \"color\": \"propColorOrange\", \"value\": \"Draft\"}, {\"id\": \"apy9dcd7zmand615p3h53zjqxjh\", \"color\": \"propColorPurple\", \"value\": \"In Review\"}, {\"id\": \"acri4cm3bmay55f7ksztphmtnga\", \"color\": \"propColorBlue\", \"value\": \"Ready to Publish\"}, {\"id\": \"amsowcd9a8e1kid317r7ttw6uzh\", \"color\": \"propColorGreen\", \"value\": \"Published ?\"}]}, {\"id\": \"aysx3atqexotgwp5kx6h5i5ancw\", \"name\": \"Type\", \"type\": \"select\", \"options\": [{\"id\": \"aywiofmmtd3ofgzj95ysky4pjga\", \"color\": \"propColorOrange\", \"value\": \"Press Release\"}, {\"id\": \"apqdgjrmsmx8ngmp7zst51647de\", \"color\": \"propColorGreen\", \"value\": \"Sponsored Post\"}, {\"id\": \"a3woynbjnb7j16e74uw3pubrytw\", \"color\": \"propColorPurple\", \"value\": \"Customer Story\"}, {\"id\": \"aq36k5pkpfcypqb3idw36xdi1fh\", \"color\": \"propColorRed\", \"value\": \"Product Release\"}, {\"id\": \"azn66pmk34adygnizjqhgiac4ia\", \"color\": \"propColorGray\", \"value\": \"Partnership\"}, {\"id\": \"aj8y675weso8kpb6eceqbpj4ruw\", \"color\": \"propColorBlue\", \"value\": \"Feature Announcement\"}, {\"id\": \"a3xky7ygn14osr1mokerbfah5cy\", \"color\": \"propColorYellow\", \"value\": \"Article\"}]}, {\"id\": \"ab6mbock6styfe6htf815ph1mhw\", \"name\": \"Channel\", \"type\": \"multiSelect\", \"options\": [{\"id\": \"a8xceonxiu4n3c43szhskqizicr\", \"color\": \"propColorBrown\", \"value\": \"Website\"}, {\"id\": \"a3pdzi53kpbd4okzdkz6khi87zo\", \"color\": \"propColorGreen\", \"value\": \"Blog\"}, {\"id\": \"a3d9ux4fmi3anyd11kyipfbhwde\", \"color\": \"propColorOrange\", \"value\": \"Email\"}, {\"id\": \"a8cbbfdwocx73zn3787cx6gacsh\", \"color\": \"propColorRed\", \"value\": \"Podcast\"}, {\"id\": \"aigjtpcaxdp7d6kmctrwo1ztaia\", \"color\": \"propColorPink\", \"value\": \"Print\"}, {\"id\": \"af1wsn13muho59e7ghwaogxy5ey\", \"color\": \"propColorBlue\", \"value\": \"Facebook\"}, {\"id\": \"a47zajfxwhsg6q8m7ppbiqs7jge\", \"color\": \"propColorGray\", \"value\": \"LinkedIn\"}, {\"id\": \"az8o8pfe9hq6s7xaehoqyc3wpyc\", \"color\": \"propColorYellow\", \"value\": \"Twitter\"}]}, {\"id\": \"ao44fz8nf6z6tuj1x31t9yyehcc\", \"name\": \"Assignee\", \"type\": \"person\", \"options\": []}, {\"id\": \"a39x5cybshwrbjpc3juaakcyj6e\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"agqsoiipowmnu9rdwxm57zrehtr\", \"name\": \"Publication Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"ap4e7kdg7eip7j3c3oyiz39eaoc\", \"name\": \"Link\", \"type\": \"url\", \"options\": []}]',1684139137980,1684139137980,0,''),('b7n3rwgpsspbg9drkn8ztit7yxw','2023-05-15 08:25:40.550460','0','','system','system','O','Team Retrospective','Use this template at the end of your project or sprint to identify what worked well and what can be improved for the future.','?',1,1,6,'{\"trackingTemplateId\": \"e4f03181c4ced8edd4d53d33d569a086\"}','[{\"id\": \"adjckpdotpgkz7c6wixzw9ipb1e\", \"name\": \"Category\", \"type\": \"select\", \"options\": [{\"id\": \"aok6pgecm85qe9k5kcphzoe63ma\", \"color\": \"propColorGray\", \"value\": \"To Discuss ?\"}, {\"id\": \"aq1dwbf661yx337hjcd5q3sbxwa\", \"color\": \"propColorGreen\", \"value\": \"Went Well ?\"}, {\"id\": \"ar87yh5xmsswqkxmjq1ipfftfpc\", \"color\": \"propColorRed\", \"value\": \"Didn\'t Go Well ?\"}, {\"id\": \"akj3fkmxq7idma55mdt8sqpumyw\", \"color\": \"propColorBlue\", \"value\": \"Action Items ✅\"}]}, {\"id\": \"aspaay76a5wrnuhtqgm97tt3rer\", \"name\": \"Details\", \"type\": \"text\", \"options\": []}, {\"id\": \"arzsm76s376y7suuhao3tu6efoc\", \"name\": \"Created By\", \"type\": \"createdBy\", \"options\": []}, {\"id\": \"a8anbe5fpa668sryatcdsuuyh8a\", \"name\": \"Created Time\", \"type\": \"createdTime\", \"options\": []}]',1684139140547,1684139140547,0,''),('b8mrrx4qbjbfh78rh39s55bosec','2023-05-15 08:25:43.094717','0','','system','system','O','Welcome to Boards!','Mattermost Boards is an open source project management tool that helps you organize, track, and manage work across teams. Select a card to learn more.','?',1,1,6,'{\"trackingTemplateId\": \"65aba997282f3ac457cd66736fb86915\"}','[{\"id\": \"a972dc7a-5f4c-45d2-8044-8c28c69717f1\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"amm6wfhnbuxojwssyftgs9dipqe\", \"color\": \"propColorRed\", \"value\": \"To do ?\"}, {\"id\": \"af3p8ztcyxgn8wd9z4az7o9tjeh\", \"color\": \"propColorYellow\", \"value\": \"Next up\"}, {\"id\": \"ajurey3xkocs1nwx8di5zx6oe7o\", \"color\": \"propColorPurple\", \"value\": \"Later\"}, {\"id\": \"agkinkjy5983wsk6kppsujajxqw\", \"color\": \"propColorGreen\", \"value\": \"Completed ?\"}]}, {\"id\": \"acypkejeb5yfujhj9te57p9kaxw\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"aanaehcw3m13jytujsjk5hpf6ry\", \"color\": \"propColorOrange\", \"value\": \"1. High\"}, {\"id\": \"ascd7nm9r491ayot8i86g1gmgqw\", \"color\": \"propColorBrown\", \"value\": \"2. Medium\"}, {\"id\": \"aq6ukoiciyfctgwyhwzpfss8ghe\", \"color\": \"propColorGray\", \"value\": \"3. Low\"}]}, {\"id\": \"aqh13jabwexjkzr3jqsz1i1syew\", \"name\": \"Assignee\", \"type\": \"person\", \"options\": []}, {\"id\": \"acmg7mz1rr1eykfug4hcdpb1y1o\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"amewjwfjrtpu8ha73xsrdmxazxr\", \"name\": \"Reviewed\", \"type\": \"checkbox\", \"options\": []}, {\"id\": \"attzzboqaz6m1sdti5xa7gjnk1e\", \"name\": \"Last updated time\", \"type\": \"updatedTime\", \"options\": []}, {\"id\": \"a4nfnb5xr3txr5xq7y9ho7kyz6c\", \"name\": \"Reference\", \"type\": \"url\", \"options\": []}, {\"id\": \"a9gzwi3dt5n55nddej6zcbhxaeh\", \"name\": \"Created by\", \"type\": \"createdBy\", \"options\": []}]',1684139143091,1684139143091,0,''),('bbddcn4qrgbrbmrhy45qqk8rr5o','2023-05-15 08:25:21.422912','0','','system','system','O','Personal Tasks ','Use this template to organize your life and track your personal tasks.','✔️',1,1,6,'{\"trackingTemplateId\": \"dfb70c146a4584b8a21837477c7b5431\"}','[{\"id\": \"a9zf59u8x1rf4ywctpcqama7tio\", \"name\": \"Occurrence\", \"type\": \"select\", \"options\": [{\"id\": \"an51dnkenmoog9cetapbc4uyt3y\", \"color\": \"propColorBlue\", \"value\": \"Daily\"}, {\"id\": \"afpy8s7i45frggprmfsqngsocqh\", \"color\": \"propColorOrange\", \"value\": \"Weekly\"}, {\"id\": \"aj4jyekqqssatjcq7r7chmy19ey\", \"color\": \"propColorPurple\", \"value\": \"Monthly\"}]}, {\"id\": \"abthng7baedhhtrwsdodeuincqy\", \"name\": \"Completed\", \"type\": \"checkbox\", \"options\": []}]',1684139121420,1684139121420,0,''),('bdprp7sm54jg49p8quqy34gj41a','2023-05-15 08:25:25.595090','0','','system','system','O','Company Goals & OKRs','Use this template to plan your company goals and OKRs more efficiently.','⛳',1,1,6,'{\"trackingTemplateId\": \"7ba22ccfdfac391d63dea5c4b8cde0de\"}','[{\"id\": \"a6amddgmrzakw66cidqzgk6p4ge\", \"name\": \"Objective\", \"type\": \"select\", \"options\": [{\"id\": \"auw3afh3kfhrfgmjr8muiz137jy\", \"color\": \"propColorGreen\", \"value\": \"Grow Revenue\"}, {\"id\": \"apqfjst8massbjjhpcsjs3y1yqa\", \"color\": \"propColorOrange\", \"value\": \"Delight Customers\"}, {\"id\": \"ao9b5pxyt7tkgdohzh9oaustdhr\", \"color\": \"propColorPurple\", \"value\": \"Drive Product Adoption\"}]}, {\"id\": \"a17ryhi1jfsboxkwkztwawhmsxe\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"a6robxx81diugpjq5jkezz3j1fo\", \"color\": \"propColorGray\", \"value\": \"Not Started\"}, {\"id\": \"a8nukezwwmknqwjsygg7eaxs9te\", \"color\": \"propColorBlue\", \"value\": \"In Progress\"}, {\"id\": \"apnt1f7na9rzgk1rt49keg7xbiy\", \"color\": \"propColorYellow\", \"value\": \"At Risk\"}, {\"id\": \"axbz3m1amss335wzwf9s7pqjzxr\", \"color\": \"propColorRed\", \"value\": \"Missed\"}, {\"id\": \"abzfwnn6rmtfzyq5hg8uqmpsncy\", \"color\": \"propColorGreen\", \"value\": \"Complete ?\"}]}, {\"id\": \"azzbawji5bksj69sekcs4srm1ky\", \"name\": \"Department\", \"type\": \"select\", \"options\": [{\"id\": \"aw5i7hmpadn6mbwbz955ubarhme\", \"color\": \"propColorBrown\", \"value\": \"Engineering\"}, {\"id\": \"afkxpcjqjypu7hhar7banxau91h\", \"color\": \"propColorBlue\", \"value\": \"Product\"}, {\"id\": \"aehoa17cz18rqnrf75g7dwhphpr\", \"color\": \"propColorOrange\", \"value\": \"Marketing\"}, {\"id\": \"agrfeaoj7d8p5ianw5iaf3191ae\", \"color\": \"propColorGreen\", \"value\": \"Sales\"}, {\"id\": \"agm9p6gcq15ueuzqq3wd4be39wy\", \"color\": \"propColorYellow\", \"value\": \"Support\"}, {\"id\": \"aucop7kw6xwodcix6zzojhxih6r\", \"color\": \"propColorPink\", \"value\": \"Design\"}, {\"id\": \"afust91f3g8ht368mkn5x9tgf1o\", \"color\": \"propColorPurple\", \"value\": \"Finance\"}, {\"id\": \"acocxxwjurud1jixhp7nowdig7y\", \"color\": \"propColorGray\", \"value\": \"Human Resources\"}]}, {\"id\": \"adp5ft3kgz7r5iqq3tnwg551der\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"a8zg3rjtf4swh7smsjxpsn743rh\", \"color\": \"propColorRed\", \"value\": \"P1 ?\"}, {\"id\": \"as555ipyzopjjpfb5rjtssecw5e\", \"color\": \"propColorYellow\", \"value\": \"P2\"}, {\"id\": \"a1ts3ftyr8nocsicui98c89uxjy\", \"color\": \"propColorGray\", \"value\": \"P3\"}]}, {\"id\": \"aqxyzkdrs4egqf7yk866ixkaojc\", \"name\": \"Quarter\", \"type\": \"select\", \"options\": [{\"id\": \"ahfbn1jsmhydym33ygxwg5jt3kh\", \"color\": \"propColorBlue\", \"value\": \"Q1\"}, {\"id\": \"awfu37js3fomfkkczm1zppac57a\", \"color\": \"propColorBrown\", \"value\": \"Q2\"}, {\"id\": \"anruuoyez51r3yjxuoc8zoqnwaw\", \"color\": \"propColorGreen\", \"value\": \"Q3\"}, {\"id\": \"acb6dqqs6yson7bbzx6jk9bghjh\", \"color\": \"propColorPurple\", \"value\": \"Q4\"}]}, {\"id\": \"adu6mebzpibq6mgcswk69xxmnqe\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"asope3bddhm4gpsng5cfu4hf6rh\", \"name\": \"Assignee\", \"type\": \"multiPerson\", \"options\": []}, {\"id\": \"ajwxp866f9obs1kutfwaa5ru7fe\", \"name\": \"Target\", \"type\": \"number\", \"options\": []}, {\"id\": \"azqnyswk6s1boiwuthscm78qwuo\", \"name\": \"Actual\", \"type\": \"number\", \"options\": []}, {\"id\": \"ahz3fmjnaguec8hce7xq3h5cjdr\", \"name\": \"Completion (%)\", \"type\": \"text\", \"options\": []}, {\"id\": \"a17bfcgnzmkwhziwa4tr38kiw5r\", \"name\": \"Note\", \"type\": \"text\", \"options\": []}]',1684139125590,1684139125590,0,''),('bhn75zdik6bng5muchaoh6k7guh','2023-05-15 08:25:36.311096','0','','system','system','O','Competitive Analysis','Use this template to track and stay ahead of the competition.','?️',1,1,6,'{\"trackingTemplateId\": \"06f4bff367a7c2126fab2380c9dec23c\"}','[{\"id\": \"ahzspe59iux8wigra8bg6cg18nc\", \"name\": \"Website\", \"type\": \"url\", \"options\": []}, {\"id\": \"aozntq4go4nkab688j1s7stqtfc\", \"name\": \"Location\", \"type\": \"text\", \"options\": []}, {\"id\": \"aiefo7nh9jwisn8b4cgakowithy\", \"name\": \"Revenue\", \"type\": \"text\", \"options\": []}, {\"id\": \"a6cwaq79b1pdpb97wkanmeyy4er\", \"name\": \"Employees\", \"type\": \"number\", \"options\": []}, {\"id\": \"an1eerzscfxn6awdfajbg41uz3h\", \"name\": \"Founded\", \"type\": \"text\", \"options\": []}, {\"id\": \"a1semdhszu1rq17d7et5ydrqqio\", \"name\": \"Market Position\", \"type\": \"select\", \"options\": [{\"id\": \"arfjpz9by5car71tz3behba8yih\", \"color\": \"propColorYellow\", \"value\": \"Leader\"}, {\"id\": \"abajmr34b8g1916w495xjb35iko\", \"color\": \"propColorRed\", \"value\": \"Challenger\"}, {\"id\": \"abt79uxg5edqojsrrefcnr4eruo\", \"color\": \"propColorBlue\", \"value\": \"Follower\"}, {\"id\": \"aipf3qfgjtkheiayjuxrxbpk9wa\", \"color\": \"propColorBrown\", \"value\": \"Nicher\"}]}, {\"id\": \"aapogff3xoa8ym7xf56s87kysda\", \"name\": \"Last updated time\", \"type\": \"updatedTime\", \"options\": []}, {\"id\": \"az3jkw3ynd3mqmart7edypey15e\", \"name\": \"Last updated by\", \"type\": \"updatedBy\", \"options\": []}]',1684139136308,1684139136308,0,''),('biq6ryjojzfrs5ehpj6wjrg6ear','2023-05-15 08:25:28.161070','0','','system','system','O','Personal Goals ','Use this template to set and accomplish new personal goals.','⛰️',1,1,6,'{\"trackingTemplateId\": \"7f32dc8d2ae008cfe56554e9363505cc\"}','[{\"id\": \"af6fcbb8-ca56-4b73-83eb-37437b9a667d\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"bf52bfe6-ac4c-4948-821f-83eaa1c7b04a\", \"color\": \"propColorRed\", \"value\": \"To Do\"}, {\"id\": \"77c539af-309c-4db1-8329-d20ef7e9eacd\", \"color\": \"propColorYellow\", \"value\": \"Doing\"}, {\"id\": \"98bdea27-0cce-4cde-8dc6-212add36e63a\", \"color\": \"propColorGreen\", \"value\": \"Done ?\"}]}, {\"id\": \"d9725d14-d5a8-48e5-8de1-6f8c004a9680\", \"name\": \"Category\", \"type\": \"select\", \"options\": [{\"id\": \"3245a32d-f688-463b-87f4-8e7142c1b397\", \"color\": \"propColorPurple\", \"value\": \"Life Skills\"}, {\"id\": \"80be816c-fc7a-4928-8489-8b02180f4954\", \"color\": \"propColorGreen\", \"value\": \"Finance\"}, {\"id\": \"ffb3f951-b47f-413b-8f1d-238666728008\", \"color\": \"propColorOrange\", \"value\": \"Health\"}]}, {\"id\": \"d6b1249b-bc18-45fc-889e-bec48fce80ef\", \"name\": \"Target\", \"type\": \"select\", \"options\": [{\"id\": \"9a090e33-b110-4268-8909-132c5002c90e\", \"color\": \"propColorBlue\", \"value\": \"Q1\"}, {\"id\": \"0a82977f-52bf-457b-841b-e2b7f76fb525\", \"color\": \"propColorBrown\", \"value\": \"Q2\"}, {\"id\": \"6e7139e4-5358-46bb-8c01-7b029a57b80a\", \"color\": \"propColorGreen\", \"value\": \"Q3\"}, {\"id\": \"d5371c63-66bf-4468-8738-c4dc4bea4843\", \"color\": \"propColorPurple\", \"value\": \"Q4\"}]}, {\"id\": \"ajy6xbebzopojaenbnmfpgtdwso\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}]',1684139128153,1684139128153,0,''),('bjxj5yzhuupdfpysci4zbwksn8a','2023-05-15 08:25:29.266460','0','','system','system','O','Sprint Planner ','Use this template to plan your sprints and manage your releases more efficiently.','?️',1,1,6,'{\"trackingTemplateId\": \"99b74e26d2f5d0a9b346d43c0a7bfb09\"}','[{\"id\": \"50117d52-bcc7-4750-82aa-831a351c44a0\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"aft5bzo7h9aspqgrx3jpy5tzrer\", \"color\": \"propColorGray\", \"value\": \"Not Started\"}, {\"id\": \"abrfos7e7eczk9rqw6y5abadm1y\", \"color\": \"propColorOrange\", \"value\": \"Next Up\"}, {\"id\": \"ax8wzbka5ahs3zziji3pp4qp9mc\", \"color\": \"propColorBlue\", \"value\": \"In Progress\"}, {\"id\": \"atabdfbdmjh83136d5e5oysxybw\", \"color\": \"propColorYellow\", \"value\": \"In Review\"}, {\"id\": \"ace1bzypd586kkyhcht5qqd9eca\", \"color\": \"propColorPink\", \"value\": \"Approved\"}, {\"id\": \"aay656c9m1hzwxc9ch5ftymh3nw\", \"color\": \"propColorRed\", \"value\": \"Blocked\"}, {\"id\": \"a6ghze4iy441qhsh3eijnc8hwze\", \"color\": \"propColorGreen\", \"value\": \"Complete ?\"}]}, {\"id\": \"20717ad3-5741-4416-83f1-6f133fff3d11\", \"name\": \"Type\", \"type\": \"select\", \"options\": [{\"id\": \"424ea5e3-9aa1-4075-8c5c-01b44b66e634\", \"color\": \"propColorYellow\", \"value\": \"Epic ⛰\"}, {\"id\": \"a5yxq8rbubrpnoommfwqmty138h\", \"color\": \"propColorGray\", \"value\": \"Feature ?\"}, {\"id\": \"apht1nt5ryukdmxkh6fkfn6rgoy\", \"color\": \"propColorOrange\", \"value\": \"User Story ?\"}, {\"id\": \"aiycbuo3dr5k4xxbfr7coem8ono\", \"color\": \"propColorGreen\", \"value\": \"Task ⛏\"}, {\"id\": \"aomnawq4551cbbzha9gxnmb3z5w\", \"color\": \"propColorRed\", \"value\": \"Bug ?\"}]}, {\"id\": \"60985f46-3e41-486e-8213-2b987440ea1c\", \"name\": \"Sprint\", \"type\": \"select\", \"options\": [{\"id\": \"c01676ca-babf-4534-8be5-cce2287daa6c\", \"color\": \"propColorBrown\", \"value\": \"Sprint 1\"}, {\"id\": \"ed4a5340-460d-461b-8838-2c56e8ee59fe\", \"color\": \"propColorPurple\", \"value\": \"Sprint 2\"}, {\"id\": \"14892380-1a32-42dd-8034-a0cea32bc7e6\", \"color\": \"propColorBlue\", \"value\": \"Sprint 3\"}]}, {\"id\": \"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"cb8ecdac-38be-4d36-8712-c4d58cc8a8e9\", \"color\": \"propColorRed\", \"value\": \"P1 ?\"}, {\"id\": \"e6a7f297-4440-4783-8ab3-3af5ba62ca11\", \"color\": \"propColorYellow\", \"value\": \"P2\"}, {\"id\": \"c62172ea-5da7-4dec-8186-37267d8ee9a7\", \"color\": \"propColorGray\", \"value\": \"P3\"}]}, {\"id\": \"aphg37f7zbpuc3bhwhp19s1ribh\", \"name\": \"Assignee\", \"type\": \"multiPerson\", \"options\": []}, {\"id\": \"a4378omyhmgj3bex13sj4wbpfiy\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"ai7ajsdk14w7x5s8up3dwir77te\", \"name\": \"Story Points\", \"type\": \"number\", \"options\": []}, {\"id\": \"a1g6i613dpe9oryeo71ex3c86hy\", \"name\": \"Design Link\", \"type\": \"url\", \"options\": []}, {\"id\": \"aeomttrbhhsi8bph31jn84sto6h\", \"name\": \"Created Time\", \"type\": \"createdTime\", \"options\": []}, {\"id\": \"ax9f8so418s6s65hi5ympd93i6a\", \"name\": \"Created By\", \"type\": \"createdBy\", \"options\": []}]',1684139129263,1684139129263,0,''),('bsey5p6ygqfff9eqbcfarbzscdw','2023-05-15 08:25:41.302674','0','','system','system','O','Roadmap ','Use this template to plan your roadmap and manage your releases more efficiently.','?️',1,1,6,'{\"trackingTemplateId\": \"b728c6ca730e2cfc229741c5a4712b65\"}','[{\"id\": \"50117d52-bcc7-4750-82aa-831a351c44a0\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"8c557f69-b0ed-46ec-83a3-8efab9d47ef5\", \"color\": \"propColorGray\", \"value\": \"Not Started\"}, {\"id\": \"ec6d2bc5-df2b-4f77-8479-e59ceb039946\", \"color\": \"propColorYellow\", \"value\": \"In Progress\"}, {\"id\": \"849766ba-56a5-48d1-886f-21672f415395\", \"color\": \"propColorGreen\", \"value\": \"Complete ?\"}]}, {\"id\": \"20717ad3-5741-4416-83f1-6f133fff3d11\", \"name\": \"Type\", \"type\": \"select\", \"options\": [{\"id\": \"424ea5e3-9aa1-4075-8c5c-01b44b66e634\", \"color\": \"propColorYellow\", \"value\": \"Epic ⛰\"}, {\"id\": \"6eea96c9-4c61-4968-8554-4b7537e8f748\", \"color\": \"propColorGreen\", \"value\": \"Task ?\"}, {\"id\": \"1fdbb515-edd2-4af5-80fc-437ed2211a49\", \"color\": \"propColorRed\", \"value\": \"Bug ?\"}]}, {\"id\": \"60985f46-3e41-486e-8213-2b987440ea1c\", \"name\": \"Sprint\", \"type\": \"select\", \"options\": [{\"id\": \"c01676ca-babf-4534-8be5-cce2287daa6c\", \"color\": \"propColorBrown\", \"value\": \"Sprint 1\"}, {\"id\": \"ed4a5340-460d-461b-8838-2c56e8ee59fe\", \"color\": \"propColorPurple\", \"value\": \"Sprint 2\"}, {\"id\": \"14892380-1a32-42dd-8034-a0cea32bc7e6\", \"color\": \"propColorBlue\", \"value\": \"Sprint 3\"}]}, {\"id\": \"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"cb8ecdac-38be-4d36-8712-c4d58cc8a8e9\", \"color\": \"propColorRed\", \"value\": \"P1 ?\"}, {\"id\": \"e6a7f297-4440-4783-8ab3-3af5ba62ca11\", \"color\": \"propColorYellow\", \"value\": \"P2\"}, {\"id\": \"c62172ea-5da7-4dec-8186-37267d8ee9a7\", \"color\": \"propColorGray\", \"value\": \"P3\"}]}, {\"id\": \"aphg37f7zbpuc3bhwhp19s1ribh\", \"name\": \"Assignee\", \"type\": \"person\", \"options\": []}, {\"id\": \"a4378omyhmgj3bex13sj4wbpfiy\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"a36o9q1yik6nmar6ri4q4uca7ey\", \"name\": \"Created Date\", \"type\": \"createdTime\", \"options\": []}, {\"id\": \"ai7ajsdk14w7x5s8up3dwir77te\", \"name\": \"Design Link\", \"type\": \"url\", \"options\": []}]',1684139141298,1684139141298,0,''),('bsq4isof5rtduf8g6kdye1uk3jw','2023-05-15 08:25:17.545861','0','','system','system','O','Sales Pipeline CRM','Use this template to grow and keep track of your sales opportunities.','?',1,1,6,'{\"trackingTemplateId\": \"ecc250bb7dff0fe02247f1110f097544\"}','[{\"id\": \"a5hwxjsmkn6bak6r7uea5bx1kwc\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"akj61wc9yxdwyw3t6m8igyf9d5o\", \"color\": \"propColorGray\", \"value\": \"Lead\"}, {\"id\": \"aic89a5xox4wbppi6mbyx6ujsda\", \"color\": \"propColorYellow\", \"value\": \"Qualified\"}, {\"id\": \"ah6ehh43rwj88jy4awensin8pcw\", \"color\": \"propColorBrown\", \"value\": \"Meeting\"}, {\"id\": \"aprhd96zwi34o9cs4xyr3o9sf3c\", \"color\": \"propColorPurple\", \"value\": \"Proposal\"}, {\"id\": \"axesd74yuxtbmw1sbk8ufax7z3a\", \"color\": \"propColorOrange\", \"value\": \"Negotiation\"}, {\"id\": \"a5txuiubumsmrs8gsd5jz5gc1oa\", \"color\": \"propColorRed\", \"value\": \"Lost\"}, {\"id\": \"acm9q494bcthyoqzmfogxxy5czy\", \"color\": \"propColorGreen\", \"value\": \"Closed ?\"}]}, {\"id\": \"aoheuj1f3mu6eehygr45fxa144y\", \"name\": \"Account Owner\", \"type\": \"multiPerson\", \"options\": []}, {\"id\": \"aro91wme9kfaie5ceu9qasmtcnw\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"apjnaggwixchfxwiatfh7ey7uno\", \"color\": \"propColorRed\", \"value\": \"High ?\"}, {\"id\": \"apiswzj7uiwbh87z8dw8c6mturw\", \"color\": \"propColorYellow\", \"value\": \"Medium\"}, {\"id\": \"auu9bfzqeuruyjwzzqgz7q8apuw\", \"color\": \"propColorBrown\", \"value\": \"Low\"}]}, {\"id\": \"ainpw47babwkpyj77ic4b9zq9xr\", \"name\": \"Company\", \"type\": \"text\", \"options\": []}, {\"id\": \"ahf43e44h3y8ftanqgzno9z7q7w\", \"name\": \"Estimated Value\", \"type\": \"number\", \"options\": []}, {\"id\": \"amahgyn9n4twaapg3jyxb6y4jic\", \"name\": \"Territory\", \"type\": \"select\", \"options\": [{\"id\": \"ar6t1ttcumgfuqugg5o4g4mzrza\", \"color\": \"propColorBrown\", \"value\": \"Western US\"}, {\"id\": \"asbwojkm7zb4ohrtij97jkdfgwe\", \"color\": \"propColorGreen\", \"value\": \"Mountain West / Central US\"}, {\"id\": \"aw8ppwtcrm8iwopdadje3ni196w\", \"color\": \"propColorGray\", \"value\": \"Mid-Atlantic / Southeast\"}, {\"id\": \"aafwyza5iwdcwcyfyj6bp7emufw\", \"color\": \"propColorBlue\", \"value\": \"Northeast US / Canada\"}, {\"id\": \"agw8rcb9uxyt3c7g6tq3r65fgqe\", \"color\": \"propColorPink\", \"value\": \"Eastern Europe\"}, {\"id\": \"as5bk6afoaaa7caewe1zc391sce\", \"color\": \"propColorPurple\", \"value\": \"Central Europe / Africa\"}, {\"id\": \"a8fj94bka8z9t6p95qd3hn6t5re\", \"color\": \"propColorYellow\", \"value\": \"Middle East\"}, {\"id\": \"arpxa3faaou9trt4zx5sh435gne\", \"color\": \"propColorOrange\", \"value\": \"UK\"}, {\"id\": \"azdidd5wze4kcxf8neefj3ctkyr\", \"color\": \"propColorRed\", \"value\": \"Asia\"}, {\"id\": \"a4jn5mhqs3thknqf5opykntgsnc\", \"color\": \"propColorGray\", \"value\": \"Australia\"}, {\"id\": \"afjbgrecb7hp5owj7xh8u4w33tr\", \"color\": \"propColorBrown\", \"value\": \"Latin America\"}]}, {\"id\": \"abru6tz8uebdxy4skheqidh7zxy\", \"name\": \"Email\", \"type\": \"email\", \"options\": []}, {\"id\": \"a1438fbbhjeffkexmcfhnx99o1h\", \"name\": \"Phone\", \"type\": \"phone\", \"options\": []}, {\"id\": \"auhf91pm85f73swwidi4wid8jqe\", \"name\": \"Last Contact Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"adtf1151chornmihz4xbgbk9exa\", \"name\": \"Expected Close\", \"type\": \"date\", \"options\": []}, {\"id\": \"aejo5tcmq54bauuueem9wc4fw4y\", \"name\": \"Close Probability\", \"type\": \"text\", \"options\": []}, {\"id\": \"amba7ot98fh7hwsx8jdcfst5g7h\", \"name\": \"Created Date\", \"type\": \"createdTime\", \"options\": []}]',1684139117542,1684139117542,0,''),('bz7o1isbn7if4jkbt3bc6nb4kqc','2023-05-15 08:25:33.227867','0','','system','system','O','User Research Sessions','Use this template to manage and keep track of all your user research sessions.','?',1,1,6,'{\"trackingTemplateId\": \"6c345c7f50f6833f78b7d0f08ce450a3\"}','[{\"id\": \"aaebj5fyx493eezx6ukxiwydgty\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"af6hjb3ysuaxbwnfqpby4wwnkdr\", \"color\": \"propColorGray\", \"value\": \"Backlog ?\"}, {\"id\": \"aotxum1p5bw3xuzqz3ctjw66yww\", \"color\": \"propColorYellow\", \"value\": \"Contacted ?\"}, {\"id\": \"a7yq89whddzob1futao4rxk3yzc\", \"color\": \"propColorBlue\", \"value\": \"Scheduled ?\"}, {\"id\": \"aseqq9hrsua56r3s6nbuirj9eec\", \"color\": \"propColorRed\", \"value\": \"Cancelled ?\"}, {\"id\": \"ap93ysuzy1xa7z818r6myrn4h4y\", \"color\": \"propColorGreen\", \"value\": \"Completed ✔️\"}]}, {\"id\": \"akrxgi7p7w14fym3gbynb98t9fh\", \"name\": \"Interview Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"atg9qu6oe4bjm8jczzsn71ff5me\", \"name\": \"Product Area\", \"type\": \"select\", \"options\": [{\"id\": \"ahn89mqg9u4igk6pdm7333t8i5h\", \"color\": \"propColorGreen\", \"value\": \"Desktop App\"}, {\"id\": \"aehc83ffays3gh8myz16a8j7k4e\", \"color\": \"propColorPurple\", \"value\": \"Web App\"}, {\"id\": \"a1sxagjgaadym5yrjak6tcup1oa\", \"color\": \"propColorBlue\", \"value\": \"Mobile App\"}]}, {\"id\": \"acjq4t5ymytu8x1f68wkggm7ypc\", \"name\": \"Email\", \"type\": \"email\", \"options\": []}, {\"id\": \"aphio1s5gkmpdbwoxynim7acw3e\", \"name\": \"Interviewer\", \"type\": \"multiPerson\", \"options\": []}, {\"id\": \"aqafzdeekpyncwz7m7i54q3iqqy\", \"name\": \"Recording URL\", \"type\": \"url\", \"options\": []}, {\"id\": \"aify3r761b9w43bqjtskrzi68tr\", \"name\": \"Passcode\", \"type\": \"text\", \"options\": []}]',1684139133218,1684139133218,0,''),('bz8r98156ppgxdctqjuxytu5cgc','2023-05-15 08:25:14.992537','0','','system','system','O','Meeting Agenda ','Use this template for recurring meeting agendas, like team meetings and 1:1\'s. To use this board:\n* Participants queue new items to discuss under \"To Discuss\"\n* Go through items during the meeting\n* Move items to Done or Revisit Later as needed','?',1,1,6,'{\"trackingTemplateId\": \"54fcf9c610f0ac5e4c522c0657c90602\"}','[{\"id\": \"d777ba3b-8728-40d1-87a6-59406bbbbfb0\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"34eb9c25-d5bf-49d9-859e-f74f4e0030e7\", \"color\": \"propColorPink\", \"value\": \"To Discuss ?\"}, {\"id\": \"d37a61f4-f332-4db9-8b2d-5e0a91aa20ed\", \"color\": \"propColorYellow\", \"value\": \"Revisit Later ⏳\"}, {\"id\": \"dabadd9b-adf1-4d9f-8702-805ac6cef602\", \"color\": \"propColorGreen\", \"value\": \"Done / Archived ?\"}]}, {\"id\": \"4cf1568d-530f-4028-8ffd-bdc65249187e\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"8b05c83e-a44a-4d04-831e-97f01d8e2003\", \"color\": \"propColorRed\", \"value\": \"1. High\"}, {\"id\": \"b1abafbf-a038-4a19-8b68-56e0fd2319f7\", \"color\": \"propColorYellow\", \"value\": \"2. Medium\"}, {\"id\": \"2491ffaa-eb55-417b-8aff-4bd7d4136613\", \"color\": \"propColorGray\", \"value\": \"3. Low\"}]}, {\"id\": \"aw4w63xhet79y9gueqzzeiifdoe\", \"name\": \"Created by\", \"type\": \"createdBy\", \"options\": []}, {\"id\": \"a6ux19353xcwfqg9k1inqg5sg4w\", \"name\": \"Created time\", \"type\": \"createdTime\", \"options\": []}]',1684139114979,1684139114979,0,'');
/*!40000 ALTER TABLE `focalboard_boards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_boards_history`
--

DROP TABLE IF EXISTS `focalboard_boards_history`;
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

--
-- Dumping data for table `focalboard_boards_history`
--

LOCK TABLES `focalboard_boards_history` WRITE;
/*!40000 ALTER TABLE `focalboard_boards_history` DISABLE KEYS */;
INSERT INTO `focalboard_boards_history` VALUES ('b5mngenjjgtbrzrqi1dyk4m3ekr','2023-05-15 08:25:23.692577','0','','system','system','O','Project Tasks ','Use this template to stay on top of your project tasks and progress.','?',1,1,6,'{\"trackingTemplateId\": \"a4ec399ab4f2088b1051c3cdf1dde4c3\"}','[{\"id\": \"a972dc7a-5f4c-45d2-8044-8c28c69717f1\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"ayz81h9f3dwp7rzzbdebesc7ute\", \"color\": \"propColorBlue\", \"value\": \"Not Started\"}, {\"id\": \"ar6b8m3jxr3asyxhr8iucdbo6yc\", \"color\": \"propColorYellow\", \"value\": \"In Progress\"}, {\"id\": \"afi4o5nhnqc3smtzs1hs3ij34dh\", \"color\": \"propColorRed\", \"value\": \"Blocked\"}, {\"id\": \"adeo5xuwne3qjue83fcozekz8ko\", \"color\": \"propColorGreen\", \"value\": \"Completed ?\"}, {\"id\": \"ahpyxfnnrzynsw3im1psxpkgtpe\", \"color\": \"propColorBrown\", \"value\": \"Archived\"}]}, {\"id\": \"d3d682bf-e074-49d9-8df5-7320921c2d23\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"d3bfb50f-f569-4bad-8a3a-dd15c3f60101\", \"color\": \"propColorRed\", \"value\": \"1. High ?\"}, {\"id\": \"87f59784-b859-4c24-8ebe-17c766e081dd\", \"color\": \"propColorYellow\", \"value\": \"2. Medium\"}, {\"id\": \"98a57627-0f76-471d-850d-91f3ed9fd213\", \"color\": \"propColorGray\", \"value\": \"3. Low\"}]}, {\"id\": \"axkhqa4jxr3jcqe4k87g8bhmary\", \"name\": \"Assignee\", \"type\": \"person\", \"options\": []}, {\"id\": \"a8daz81s4xjgke1ww6cwik5w7ye\", \"name\": \"Estimated Hours\", \"type\": \"number\", \"options\": []}, {\"id\": \"a3zsw7xs8sxy7atj8b6totp3mby\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"a7gdnz8ff8iyuqmzddjgmgo9ery\", \"name\": \"Created By\", \"type\": \"createdBy\", \"options\": []}, {\"id\": \"2a5da320-735c-4093-8787-f56e15cdfeed\", \"name\": \"Date Created\", \"type\": \"createdTime\", \"options\": []}]',1684139123690,1684139123690,0,''),('b6ur1qsgeop88fb3dhedjrktcbw','2023-05-15 08:25:37.995634','0','','system','system','O','Content Calendar ','Use this template to plan and organize your editorial content.','?',1,1,6,'{\"trackingTemplateId\": \"c75fbd659d2258b5183af2236d176ab4\"}','[{\"id\": \"ae9ar615xoknd8hw8py7mbyr7zo\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"awna1nuarjca99m9s4uiy9kwj5h\", \"color\": \"propColorGray\", \"value\": \"Idea ?\"}, {\"id\": \"a9ana1e9w673o5cp8md4xjjwfto\", \"color\": \"propColorOrange\", \"value\": \"Draft\"}, {\"id\": \"apy9dcd7zmand615p3h53zjqxjh\", \"color\": \"propColorPurple\", \"value\": \"In Review\"}, {\"id\": \"acri4cm3bmay55f7ksztphmtnga\", \"color\": \"propColorBlue\", \"value\": \"Ready to Publish\"}, {\"id\": \"amsowcd9a8e1kid317r7ttw6uzh\", \"color\": \"propColorGreen\", \"value\": \"Published ?\"}]}, {\"id\": \"aysx3atqexotgwp5kx6h5i5ancw\", \"name\": \"Type\", \"type\": \"select\", \"options\": [{\"id\": \"aywiofmmtd3ofgzj95ysky4pjga\", \"color\": \"propColorOrange\", \"value\": \"Press Release\"}, {\"id\": \"apqdgjrmsmx8ngmp7zst51647de\", \"color\": \"propColorGreen\", \"value\": \"Sponsored Post\"}, {\"id\": \"a3woynbjnb7j16e74uw3pubrytw\", \"color\": \"propColorPurple\", \"value\": \"Customer Story\"}, {\"id\": \"aq36k5pkpfcypqb3idw36xdi1fh\", \"color\": \"propColorRed\", \"value\": \"Product Release\"}, {\"id\": \"azn66pmk34adygnizjqhgiac4ia\", \"color\": \"propColorGray\", \"value\": \"Partnership\"}, {\"id\": \"aj8y675weso8kpb6eceqbpj4ruw\", \"color\": \"propColorBlue\", \"value\": \"Feature Announcement\"}, {\"id\": \"a3xky7ygn14osr1mokerbfah5cy\", \"color\": \"propColorYellow\", \"value\": \"Article\"}]}, {\"id\": \"ab6mbock6styfe6htf815ph1mhw\", \"name\": \"Channel\", \"type\": \"multiSelect\", \"options\": [{\"id\": \"a8xceonxiu4n3c43szhskqizicr\", \"color\": \"propColorBrown\", \"value\": \"Website\"}, {\"id\": \"a3pdzi53kpbd4okzdkz6khi87zo\", \"color\": \"propColorGreen\", \"value\": \"Blog\"}, {\"id\": \"a3d9ux4fmi3anyd11kyipfbhwde\", \"color\": \"propColorOrange\", \"value\": \"Email\"}, {\"id\": \"a8cbbfdwocx73zn3787cx6gacsh\", \"color\": \"propColorRed\", \"value\": \"Podcast\"}, {\"id\": \"aigjtpcaxdp7d6kmctrwo1ztaia\", \"color\": \"propColorPink\", \"value\": \"Print\"}, {\"id\": \"af1wsn13muho59e7ghwaogxy5ey\", \"color\": \"propColorBlue\", \"value\": \"Facebook\"}, {\"id\": \"a47zajfxwhsg6q8m7ppbiqs7jge\", \"color\": \"propColorGray\", \"value\": \"LinkedIn\"}, {\"id\": \"az8o8pfe9hq6s7xaehoqyc3wpyc\", \"color\": \"propColorYellow\", \"value\": \"Twitter\"}]}, {\"id\": \"ao44fz8nf6z6tuj1x31t9yyehcc\", \"name\": \"Assignee\", \"type\": \"person\", \"options\": []}, {\"id\": \"a39x5cybshwrbjpc3juaakcyj6e\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"agqsoiipowmnu9rdwxm57zrehtr\", \"name\": \"Publication Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"ap4e7kdg7eip7j3c3oyiz39eaoc\", \"name\": \"Link\", \"type\": \"url\", \"options\": []}]',1684139137980,1684139137980,0,''),('b7n3rwgpsspbg9drkn8ztit7yxw','2023-05-15 08:25:40.555664','0','','system','system','O','Team Retrospective','Use this template at the end of your project or sprint to identify what worked well and what can be improved for the future.','?',1,1,6,'{\"trackingTemplateId\": \"e4f03181c4ced8edd4d53d33d569a086\"}','[{\"id\": \"adjckpdotpgkz7c6wixzw9ipb1e\", \"name\": \"Category\", \"type\": \"select\", \"options\": [{\"id\": \"aok6pgecm85qe9k5kcphzoe63ma\", \"color\": \"propColorGray\", \"value\": \"To Discuss ?\"}, {\"id\": \"aq1dwbf661yx337hjcd5q3sbxwa\", \"color\": \"propColorGreen\", \"value\": \"Went Well ?\"}, {\"id\": \"ar87yh5xmsswqkxmjq1ipfftfpc\", \"color\": \"propColorRed\", \"value\": \"Didn\'t Go Well ?\"}, {\"id\": \"akj3fkmxq7idma55mdt8sqpumyw\", \"color\": \"propColorBlue\", \"value\": \"Action Items ✅\"}]}, {\"id\": \"aspaay76a5wrnuhtqgm97tt3rer\", \"name\": \"Details\", \"type\": \"text\", \"options\": []}, {\"id\": \"arzsm76s376y7suuhao3tu6efoc\", \"name\": \"Created By\", \"type\": \"createdBy\", \"options\": []}, {\"id\": \"a8anbe5fpa668sryatcdsuuyh8a\", \"name\": \"Created Time\", \"type\": \"createdTime\", \"options\": []}]',1684139140547,1684139140547,0,''),('b8mrrx4qbjbfh78rh39s55bosec','2023-05-15 08:25:43.099677','0','','system','system','O','Welcome to Boards!','Mattermost Boards is an open source project management tool that helps you organize, track, and manage work across teams. Select a card to learn more.','?',1,1,6,'{\"trackingTemplateId\": \"65aba997282f3ac457cd66736fb86915\"}','[{\"id\": \"a972dc7a-5f4c-45d2-8044-8c28c69717f1\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"amm6wfhnbuxojwssyftgs9dipqe\", \"color\": \"propColorRed\", \"value\": \"To do ?\"}, {\"id\": \"af3p8ztcyxgn8wd9z4az7o9tjeh\", \"color\": \"propColorYellow\", \"value\": \"Next up\"}, {\"id\": \"ajurey3xkocs1nwx8di5zx6oe7o\", \"color\": \"propColorPurple\", \"value\": \"Later\"}, {\"id\": \"agkinkjy5983wsk6kppsujajxqw\", \"color\": \"propColorGreen\", \"value\": \"Completed ?\"}]}, {\"id\": \"acypkejeb5yfujhj9te57p9kaxw\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"aanaehcw3m13jytujsjk5hpf6ry\", \"color\": \"propColorOrange\", \"value\": \"1. High\"}, {\"id\": \"ascd7nm9r491ayot8i86g1gmgqw\", \"color\": \"propColorBrown\", \"value\": \"2. Medium\"}, {\"id\": \"aq6ukoiciyfctgwyhwzpfss8ghe\", \"color\": \"propColorGray\", \"value\": \"3. Low\"}]}, {\"id\": \"aqh13jabwexjkzr3jqsz1i1syew\", \"name\": \"Assignee\", \"type\": \"person\", \"options\": []}, {\"id\": \"acmg7mz1rr1eykfug4hcdpb1y1o\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"amewjwfjrtpu8ha73xsrdmxazxr\", \"name\": \"Reviewed\", \"type\": \"checkbox\", \"options\": []}, {\"id\": \"attzzboqaz6m1sdti5xa7gjnk1e\", \"name\": \"Last updated time\", \"type\": \"updatedTime\", \"options\": []}, {\"id\": \"a4nfnb5xr3txr5xq7y9ho7kyz6c\", \"name\": \"Reference\", \"type\": \"url\", \"options\": []}, {\"id\": \"a9gzwi3dt5n55nddej6zcbhxaeh\", \"name\": \"Created by\", \"type\": \"createdBy\", \"options\": []}]',1684139143091,1684139143091,0,''),('bbddcn4qrgbrbmrhy45qqk8rr5o','2023-05-15 08:25:21.445146','0','','system','system','O','Personal Tasks ','Use this template to organize your life and track your personal tasks.','✔️',1,1,6,'{\"trackingTemplateId\": \"dfb70c146a4584b8a21837477c7b5431\"}','[{\"id\": \"a9zf59u8x1rf4ywctpcqama7tio\", \"name\": \"Occurrence\", \"type\": \"select\", \"options\": [{\"id\": \"an51dnkenmoog9cetapbc4uyt3y\", \"color\": \"propColorBlue\", \"value\": \"Daily\"}, {\"id\": \"afpy8s7i45frggprmfsqngsocqh\", \"color\": \"propColorOrange\", \"value\": \"Weekly\"}, {\"id\": \"aj4jyekqqssatjcq7r7chmy19ey\", \"color\": \"propColorPurple\", \"value\": \"Monthly\"}]}, {\"id\": \"abthng7baedhhtrwsdodeuincqy\", \"name\": \"Completed\", \"type\": \"checkbox\", \"options\": []}]',1684139121420,1684139121420,0,''),('bdprp7sm54jg49p8quqy34gj41a','2023-05-15 08:25:25.601134','0','','system','system','O','Company Goals & OKRs','Use this template to plan your company goals and OKRs more efficiently.','⛳',1,1,6,'{\"trackingTemplateId\": \"7ba22ccfdfac391d63dea5c4b8cde0de\"}','[{\"id\": \"a6amddgmrzakw66cidqzgk6p4ge\", \"name\": \"Objective\", \"type\": \"select\", \"options\": [{\"id\": \"auw3afh3kfhrfgmjr8muiz137jy\", \"color\": \"propColorGreen\", \"value\": \"Grow Revenue\"}, {\"id\": \"apqfjst8massbjjhpcsjs3y1yqa\", \"color\": \"propColorOrange\", \"value\": \"Delight Customers\"}, {\"id\": \"ao9b5pxyt7tkgdohzh9oaustdhr\", \"color\": \"propColorPurple\", \"value\": \"Drive Product Adoption\"}]}, {\"id\": \"a17ryhi1jfsboxkwkztwawhmsxe\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"a6robxx81diugpjq5jkezz3j1fo\", \"color\": \"propColorGray\", \"value\": \"Not Started\"}, {\"id\": \"a8nukezwwmknqwjsygg7eaxs9te\", \"color\": \"propColorBlue\", \"value\": \"In Progress\"}, {\"id\": \"apnt1f7na9rzgk1rt49keg7xbiy\", \"color\": \"propColorYellow\", \"value\": \"At Risk\"}, {\"id\": \"axbz3m1amss335wzwf9s7pqjzxr\", \"color\": \"propColorRed\", \"value\": \"Missed\"}, {\"id\": \"abzfwnn6rmtfzyq5hg8uqmpsncy\", \"color\": \"propColorGreen\", \"value\": \"Complete ?\"}]}, {\"id\": \"azzbawji5bksj69sekcs4srm1ky\", \"name\": \"Department\", \"type\": \"select\", \"options\": [{\"id\": \"aw5i7hmpadn6mbwbz955ubarhme\", \"color\": \"propColorBrown\", \"value\": \"Engineering\"}, {\"id\": \"afkxpcjqjypu7hhar7banxau91h\", \"color\": \"propColorBlue\", \"value\": \"Product\"}, {\"id\": \"aehoa17cz18rqnrf75g7dwhphpr\", \"color\": \"propColorOrange\", \"value\": \"Marketing\"}, {\"id\": \"agrfeaoj7d8p5ianw5iaf3191ae\", \"color\": \"propColorGreen\", \"value\": \"Sales\"}, {\"id\": \"agm9p6gcq15ueuzqq3wd4be39wy\", \"color\": \"propColorYellow\", \"value\": \"Support\"}, {\"id\": \"aucop7kw6xwodcix6zzojhxih6r\", \"color\": \"propColorPink\", \"value\": \"Design\"}, {\"id\": \"afust91f3g8ht368mkn5x9tgf1o\", \"color\": \"propColorPurple\", \"value\": \"Finance\"}, {\"id\": \"acocxxwjurud1jixhp7nowdig7y\", \"color\": \"propColorGray\", \"value\": \"Human Resources\"}]}, {\"id\": \"adp5ft3kgz7r5iqq3tnwg551der\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"a8zg3rjtf4swh7smsjxpsn743rh\", \"color\": \"propColorRed\", \"value\": \"P1 ?\"}, {\"id\": \"as555ipyzopjjpfb5rjtssecw5e\", \"color\": \"propColorYellow\", \"value\": \"P2\"}, {\"id\": \"a1ts3ftyr8nocsicui98c89uxjy\", \"color\": \"propColorGray\", \"value\": \"P3\"}]}, {\"id\": \"aqxyzkdrs4egqf7yk866ixkaojc\", \"name\": \"Quarter\", \"type\": \"select\", \"options\": [{\"id\": \"ahfbn1jsmhydym33ygxwg5jt3kh\", \"color\": \"propColorBlue\", \"value\": \"Q1\"}, {\"id\": \"awfu37js3fomfkkczm1zppac57a\", \"color\": \"propColorBrown\", \"value\": \"Q2\"}, {\"id\": \"anruuoyez51r3yjxuoc8zoqnwaw\", \"color\": \"propColorGreen\", \"value\": \"Q3\"}, {\"id\": \"acb6dqqs6yson7bbzx6jk9bghjh\", \"color\": \"propColorPurple\", \"value\": \"Q4\"}]}, {\"id\": \"adu6mebzpibq6mgcswk69xxmnqe\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"asope3bddhm4gpsng5cfu4hf6rh\", \"name\": \"Assignee\", \"type\": \"multiPerson\", \"options\": []}, {\"id\": \"ajwxp866f9obs1kutfwaa5ru7fe\", \"name\": \"Target\", \"type\": \"number\", \"options\": []}, {\"id\": \"azqnyswk6s1boiwuthscm78qwuo\", \"name\": \"Actual\", \"type\": \"number\", \"options\": []}, {\"id\": \"ahz3fmjnaguec8hce7xq3h5cjdr\", \"name\": \"Completion (%)\", \"type\": \"text\", \"options\": []}, {\"id\": \"a17bfcgnzmkwhziwa4tr38kiw5r\", \"name\": \"Note\", \"type\": \"text\", \"options\": []}]',1684139125590,1684139125590,0,''),('bhn75zdik6bng5muchaoh6k7guh','2023-05-15 08:25:36.317040','0','','system','system','O','Competitive Analysis','Use this template to track and stay ahead of the competition.','?️',1,1,6,'{\"trackingTemplateId\": \"06f4bff367a7c2126fab2380c9dec23c\"}','[{\"id\": \"ahzspe59iux8wigra8bg6cg18nc\", \"name\": \"Website\", \"type\": \"url\", \"options\": []}, {\"id\": \"aozntq4go4nkab688j1s7stqtfc\", \"name\": \"Location\", \"type\": \"text\", \"options\": []}, {\"id\": \"aiefo7nh9jwisn8b4cgakowithy\", \"name\": \"Revenue\", \"type\": \"text\", \"options\": []}, {\"id\": \"a6cwaq79b1pdpb97wkanmeyy4er\", \"name\": \"Employees\", \"type\": \"number\", \"options\": []}, {\"id\": \"an1eerzscfxn6awdfajbg41uz3h\", \"name\": \"Founded\", \"type\": \"text\", \"options\": []}, {\"id\": \"a1semdhszu1rq17d7et5ydrqqio\", \"name\": \"Market Position\", \"type\": \"select\", \"options\": [{\"id\": \"arfjpz9by5car71tz3behba8yih\", \"color\": \"propColorYellow\", \"value\": \"Leader\"}, {\"id\": \"abajmr34b8g1916w495xjb35iko\", \"color\": \"propColorRed\", \"value\": \"Challenger\"}, {\"id\": \"abt79uxg5edqojsrrefcnr4eruo\", \"color\": \"propColorBlue\", \"value\": \"Follower\"}, {\"id\": \"aipf3qfgjtkheiayjuxrxbpk9wa\", \"color\": \"propColorBrown\", \"value\": \"Nicher\"}]}, {\"id\": \"aapogff3xoa8ym7xf56s87kysda\", \"name\": \"Last updated time\", \"type\": \"updatedTime\", \"options\": []}, {\"id\": \"az3jkw3ynd3mqmart7edypey15e\", \"name\": \"Last updated by\", \"type\": \"updatedBy\", \"options\": []}]',1684139136308,1684139136308,0,''),('biq6ryjojzfrs5ehpj6wjrg6ear','2023-05-15 08:25:28.166705','0','','system','system','O','Personal Goals ','Use this template to set and accomplish new personal goals.','⛰️',1,1,6,'{\"trackingTemplateId\": \"7f32dc8d2ae008cfe56554e9363505cc\"}','[{\"id\": \"af6fcbb8-ca56-4b73-83eb-37437b9a667d\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"bf52bfe6-ac4c-4948-821f-83eaa1c7b04a\", \"color\": \"propColorRed\", \"value\": \"To Do\"}, {\"id\": \"77c539af-309c-4db1-8329-d20ef7e9eacd\", \"color\": \"propColorYellow\", \"value\": \"Doing\"}, {\"id\": \"98bdea27-0cce-4cde-8dc6-212add36e63a\", \"color\": \"propColorGreen\", \"value\": \"Done ?\"}]}, {\"id\": \"d9725d14-d5a8-48e5-8de1-6f8c004a9680\", \"name\": \"Category\", \"type\": \"select\", \"options\": [{\"id\": \"3245a32d-f688-463b-87f4-8e7142c1b397\", \"color\": \"propColorPurple\", \"value\": \"Life Skills\"}, {\"id\": \"80be816c-fc7a-4928-8489-8b02180f4954\", \"color\": \"propColorGreen\", \"value\": \"Finance\"}, {\"id\": \"ffb3f951-b47f-413b-8f1d-238666728008\", \"color\": \"propColorOrange\", \"value\": \"Health\"}]}, {\"id\": \"d6b1249b-bc18-45fc-889e-bec48fce80ef\", \"name\": \"Target\", \"type\": \"select\", \"options\": [{\"id\": \"9a090e33-b110-4268-8909-132c5002c90e\", \"color\": \"propColorBlue\", \"value\": \"Q1\"}, {\"id\": \"0a82977f-52bf-457b-841b-e2b7f76fb525\", \"color\": \"propColorBrown\", \"value\": \"Q2\"}, {\"id\": \"6e7139e4-5358-46bb-8c01-7b029a57b80a\", \"color\": \"propColorGreen\", \"value\": \"Q3\"}, {\"id\": \"d5371c63-66bf-4468-8738-c4dc4bea4843\", \"color\": \"propColorPurple\", \"value\": \"Q4\"}]}, {\"id\": \"ajy6xbebzopojaenbnmfpgtdwso\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}]',1684139128153,1684139128153,0,''),('bjxj5yzhuupdfpysci4zbwksn8a','2023-05-15 08:25:29.271335','0','','system','system','O','Sprint Planner ','Use this template to plan your sprints and manage your releases more efficiently.','?️',1,1,6,'{\"trackingTemplateId\": \"99b74e26d2f5d0a9b346d43c0a7bfb09\"}','[{\"id\": \"50117d52-bcc7-4750-82aa-831a351c44a0\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"aft5bzo7h9aspqgrx3jpy5tzrer\", \"color\": \"propColorGray\", \"value\": \"Not Started\"}, {\"id\": \"abrfos7e7eczk9rqw6y5abadm1y\", \"color\": \"propColorOrange\", \"value\": \"Next Up\"}, {\"id\": \"ax8wzbka5ahs3zziji3pp4qp9mc\", \"color\": \"propColorBlue\", \"value\": \"In Progress\"}, {\"id\": \"atabdfbdmjh83136d5e5oysxybw\", \"color\": \"propColorYellow\", \"value\": \"In Review\"}, {\"id\": \"ace1bzypd586kkyhcht5qqd9eca\", \"color\": \"propColorPink\", \"value\": \"Approved\"}, {\"id\": \"aay656c9m1hzwxc9ch5ftymh3nw\", \"color\": \"propColorRed\", \"value\": \"Blocked\"}, {\"id\": \"a6ghze4iy441qhsh3eijnc8hwze\", \"color\": \"propColorGreen\", \"value\": \"Complete ?\"}]}, {\"id\": \"20717ad3-5741-4416-83f1-6f133fff3d11\", \"name\": \"Type\", \"type\": \"select\", \"options\": [{\"id\": \"424ea5e3-9aa1-4075-8c5c-01b44b66e634\", \"color\": \"propColorYellow\", \"value\": \"Epic ⛰\"}, {\"id\": \"a5yxq8rbubrpnoommfwqmty138h\", \"color\": \"propColorGray\", \"value\": \"Feature ?\"}, {\"id\": \"apht1nt5ryukdmxkh6fkfn6rgoy\", \"color\": \"propColorOrange\", \"value\": \"User Story ?\"}, {\"id\": \"aiycbuo3dr5k4xxbfr7coem8ono\", \"color\": \"propColorGreen\", \"value\": \"Task ⛏\"}, {\"id\": \"aomnawq4551cbbzha9gxnmb3z5w\", \"color\": \"propColorRed\", \"value\": \"Bug ?\"}]}, {\"id\": \"60985f46-3e41-486e-8213-2b987440ea1c\", \"name\": \"Sprint\", \"type\": \"select\", \"options\": [{\"id\": \"c01676ca-babf-4534-8be5-cce2287daa6c\", \"color\": \"propColorBrown\", \"value\": \"Sprint 1\"}, {\"id\": \"ed4a5340-460d-461b-8838-2c56e8ee59fe\", \"color\": \"propColorPurple\", \"value\": \"Sprint 2\"}, {\"id\": \"14892380-1a32-42dd-8034-a0cea32bc7e6\", \"color\": \"propColorBlue\", \"value\": \"Sprint 3\"}]}, {\"id\": \"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"cb8ecdac-38be-4d36-8712-c4d58cc8a8e9\", \"color\": \"propColorRed\", \"value\": \"P1 ?\"}, {\"id\": \"e6a7f297-4440-4783-8ab3-3af5ba62ca11\", \"color\": \"propColorYellow\", \"value\": \"P2\"}, {\"id\": \"c62172ea-5da7-4dec-8186-37267d8ee9a7\", \"color\": \"propColorGray\", \"value\": \"P3\"}]}, {\"id\": \"aphg37f7zbpuc3bhwhp19s1ribh\", \"name\": \"Assignee\", \"type\": \"multiPerson\", \"options\": []}, {\"id\": \"a4378omyhmgj3bex13sj4wbpfiy\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"ai7ajsdk14w7x5s8up3dwir77te\", \"name\": \"Story Points\", \"type\": \"number\", \"options\": []}, {\"id\": \"a1g6i613dpe9oryeo71ex3c86hy\", \"name\": \"Design Link\", \"type\": \"url\", \"options\": []}, {\"id\": \"aeomttrbhhsi8bph31jn84sto6h\", \"name\": \"Created Time\", \"type\": \"createdTime\", \"options\": []}, {\"id\": \"ax9f8so418s6s65hi5ympd93i6a\", \"name\": \"Created By\", \"type\": \"createdBy\", \"options\": []}]',1684139129263,1684139129263,0,''),('bsey5p6ygqfff9eqbcfarbzscdw','2023-05-15 08:25:41.307225','0','','system','system','O','Roadmap ','Use this template to plan your roadmap and manage your releases more efficiently.','?️',1,1,6,'{\"trackingTemplateId\": \"b728c6ca730e2cfc229741c5a4712b65\"}','[{\"id\": \"50117d52-bcc7-4750-82aa-831a351c44a0\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"8c557f69-b0ed-46ec-83a3-8efab9d47ef5\", \"color\": \"propColorGray\", \"value\": \"Not Started\"}, {\"id\": \"ec6d2bc5-df2b-4f77-8479-e59ceb039946\", \"color\": \"propColorYellow\", \"value\": \"In Progress\"}, {\"id\": \"849766ba-56a5-48d1-886f-21672f415395\", \"color\": \"propColorGreen\", \"value\": \"Complete ?\"}]}, {\"id\": \"20717ad3-5741-4416-83f1-6f133fff3d11\", \"name\": \"Type\", \"type\": \"select\", \"options\": [{\"id\": \"424ea5e3-9aa1-4075-8c5c-01b44b66e634\", \"color\": \"propColorYellow\", \"value\": \"Epic ⛰\"}, {\"id\": \"6eea96c9-4c61-4968-8554-4b7537e8f748\", \"color\": \"propColorGreen\", \"value\": \"Task ?\"}, {\"id\": \"1fdbb515-edd2-4af5-80fc-437ed2211a49\", \"color\": \"propColorRed\", \"value\": \"Bug ?\"}]}, {\"id\": \"60985f46-3e41-486e-8213-2b987440ea1c\", \"name\": \"Sprint\", \"type\": \"select\", \"options\": [{\"id\": \"c01676ca-babf-4534-8be5-cce2287daa6c\", \"color\": \"propColorBrown\", \"value\": \"Sprint 1\"}, {\"id\": \"ed4a5340-460d-461b-8838-2c56e8ee59fe\", \"color\": \"propColorPurple\", \"value\": \"Sprint 2\"}, {\"id\": \"14892380-1a32-42dd-8034-a0cea32bc7e6\", \"color\": \"propColorBlue\", \"value\": \"Sprint 3\"}]}, {\"id\": \"f7f3ad42-b31a-4ac2-81f0-28ea80c5b34e\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"cb8ecdac-38be-4d36-8712-c4d58cc8a8e9\", \"color\": \"propColorRed\", \"value\": \"P1 ?\"}, {\"id\": \"e6a7f297-4440-4783-8ab3-3af5ba62ca11\", \"color\": \"propColorYellow\", \"value\": \"P2\"}, {\"id\": \"c62172ea-5da7-4dec-8186-37267d8ee9a7\", \"color\": \"propColorGray\", \"value\": \"P3\"}]}, {\"id\": \"aphg37f7zbpuc3bhwhp19s1ribh\", \"name\": \"Assignee\", \"type\": \"person\", \"options\": []}, {\"id\": \"a4378omyhmgj3bex13sj4wbpfiy\", \"name\": \"Due Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"a36o9q1yik6nmar6ri4q4uca7ey\", \"name\": \"Created Date\", \"type\": \"createdTime\", \"options\": []}, {\"id\": \"ai7ajsdk14w7x5s8up3dwir77te\", \"name\": \"Design Link\", \"type\": \"url\", \"options\": []}]',1684139141298,1684139141298,0,''),('bsq4isof5rtduf8g6kdye1uk3jw','2023-05-15 08:25:17.551513','0','','system','system','O','Sales Pipeline CRM','Use this template to grow and keep track of your sales opportunities.','?',1,1,6,'{\"trackingTemplateId\": \"ecc250bb7dff0fe02247f1110f097544\"}','[{\"id\": \"a5hwxjsmkn6bak6r7uea5bx1kwc\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"akj61wc9yxdwyw3t6m8igyf9d5o\", \"color\": \"propColorGray\", \"value\": \"Lead\"}, {\"id\": \"aic89a5xox4wbppi6mbyx6ujsda\", \"color\": \"propColorYellow\", \"value\": \"Qualified\"}, {\"id\": \"ah6ehh43rwj88jy4awensin8pcw\", \"color\": \"propColorBrown\", \"value\": \"Meeting\"}, {\"id\": \"aprhd96zwi34o9cs4xyr3o9sf3c\", \"color\": \"propColorPurple\", \"value\": \"Proposal\"}, {\"id\": \"axesd74yuxtbmw1sbk8ufax7z3a\", \"color\": \"propColorOrange\", \"value\": \"Negotiation\"}, {\"id\": \"a5txuiubumsmrs8gsd5jz5gc1oa\", \"color\": \"propColorRed\", \"value\": \"Lost\"}, {\"id\": \"acm9q494bcthyoqzmfogxxy5czy\", \"color\": \"propColorGreen\", \"value\": \"Closed ?\"}]}, {\"id\": \"aoheuj1f3mu6eehygr45fxa144y\", \"name\": \"Account Owner\", \"type\": \"multiPerson\", \"options\": []}, {\"id\": \"aro91wme9kfaie5ceu9qasmtcnw\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"apjnaggwixchfxwiatfh7ey7uno\", \"color\": \"propColorRed\", \"value\": \"High ?\"}, {\"id\": \"apiswzj7uiwbh87z8dw8c6mturw\", \"color\": \"propColorYellow\", \"value\": \"Medium\"}, {\"id\": \"auu9bfzqeuruyjwzzqgz7q8apuw\", \"color\": \"propColorBrown\", \"value\": \"Low\"}]}, {\"id\": \"ainpw47babwkpyj77ic4b9zq9xr\", \"name\": \"Company\", \"type\": \"text\", \"options\": []}, {\"id\": \"ahf43e44h3y8ftanqgzno9z7q7w\", \"name\": \"Estimated Value\", \"type\": \"number\", \"options\": []}, {\"id\": \"amahgyn9n4twaapg3jyxb6y4jic\", \"name\": \"Territory\", \"type\": \"select\", \"options\": [{\"id\": \"ar6t1ttcumgfuqugg5o4g4mzrza\", \"color\": \"propColorBrown\", \"value\": \"Western US\"}, {\"id\": \"asbwojkm7zb4ohrtij97jkdfgwe\", \"color\": \"propColorGreen\", \"value\": \"Mountain West / Central US\"}, {\"id\": \"aw8ppwtcrm8iwopdadje3ni196w\", \"color\": \"propColorGray\", \"value\": \"Mid-Atlantic / Southeast\"}, {\"id\": \"aafwyza5iwdcwcyfyj6bp7emufw\", \"color\": \"propColorBlue\", \"value\": \"Northeast US / Canada\"}, {\"id\": \"agw8rcb9uxyt3c7g6tq3r65fgqe\", \"color\": \"propColorPink\", \"value\": \"Eastern Europe\"}, {\"id\": \"as5bk6afoaaa7caewe1zc391sce\", \"color\": \"propColorPurple\", \"value\": \"Central Europe / Africa\"}, {\"id\": \"a8fj94bka8z9t6p95qd3hn6t5re\", \"color\": \"propColorYellow\", \"value\": \"Middle East\"}, {\"id\": \"arpxa3faaou9trt4zx5sh435gne\", \"color\": \"propColorOrange\", \"value\": \"UK\"}, {\"id\": \"azdidd5wze4kcxf8neefj3ctkyr\", \"color\": \"propColorRed\", \"value\": \"Asia\"}, {\"id\": \"a4jn5mhqs3thknqf5opykntgsnc\", \"color\": \"propColorGray\", \"value\": \"Australia\"}, {\"id\": \"afjbgrecb7hp5owj7xh8u4w33tr\", \"color\": \"propColorBrown\", \"value\": \"Latin America\"}]}, {\"id\": \"abru6tz8uebdxy4skheqidh7zxy\", \"name\": \"Email\", \"type\": \"email\", \"options\": []}, {\"id\": \"a1438fbbhjeffkexmcfhnx99o1h\", \"name\": \"Phone\", \"type\": \"phone\", \"options\": []}, {\"id\": \"auhf91pm85f73swwidi4wid8jqe\", \"name\": \"Last Contact Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"adtf1151chornmihz4xbgbk9exa\", \"name\": \"Expected Close\", \"type\": \"date\", \"options\": []}, {\"id\": \"aejo5tcmq54bauuueem9wc4fw4y\", \"name\": \"Close Probability\", \"type\": \"text\", \"options\": []}, {\"id\": \"amba7ot98fh7hwsx8jdcfst5g7h\", \"name\": \"Created Date\", \"type\": \"createdTime\", \"options\": []}]',1684139117542,1684139117542,0,''),('bz7o1isbn7if4jkbt3bc6nb4kqc','2023-05-15 08:25:33.233320','0','','system','system','O','User Research Sessions','Use this template to manage and keep track of all your user research sessions.','?',1,1,6,'{\"trackingTemplateId\": \"6c345c7f50f6833f78b7d0f08ce450a3\"}','[{\"id\": \"aaebj5fyx493eezx6ukxiwydgty\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"af6hjb3ysuaxbwnfqpby4wwnkdr\", \"color\": \"propColorGray\", \"value\": \"Backlog ?\"}, {\"id\": \"aotxum1p5bw3xuzqz3ctjw66yww\", \"color\": \"propColorYellow\", \"value\": \"Contacted ?\"}, {\"id\": \"a7yq89whddzob1futao4rxk3yzc\", \"color\": \"propColorBlue\", \"value\": \"Scheduled ?\"}, {\"id\": \"aseqq9hrsua56r3s6nbuirj9eec\", \"color\": \"propColorRed\", \"value\": \"Cancelled ?\"}, {\"id\": \"ap93ysuzy1xa7z818r6myrn4h4y\", \"color\": \"propColorGreen\", \"value\": \"Completed ✔️\"}]}, {\"id\": \"akrxgi7p7w14fym3gbynb98t9fh\", \"name\": \"Interview Date\", \"type\": \"date\", \"options\": []}, {\"id\": \"atg9qu6oe4bjm8jczzsn71ff5me\", \"name\": \"Product Area\", \"type\": \"select\", \"options\": [{\"id\": \"ahn89mqg9u4igk6pdm7333t8i5h\", \"color\": \"propColorGreen\", \"value\": \"Desktop App\"}, {\"id\": \"aehc83ffays3gh8myz16a8j7k4e\", \"color\": \"propColorPurple\", \"value\": \"Web App\"}, {\"id\": \"a1sxagjgaadym5yrjak6tcup1oa\", \"color\": \"propColorBlue\", \"value\": \"Mobile App\"}]}, {\"id\": \"acjq4t5ymytu8x1f68wkggm7ypc\", \"name\": \"Email\", \"type\": \"email\", \"options\": []}, {\"id\": \"aphio1s5gkmpdbwoxynim7acw3e\", \"name\": \"Interviewer\", \"type\": \"multiPerson\", \"options\": []}, {\"id\": \"aqafzdeekpyncwz7m7i54q3iqqy\", \"name\": \"Recording URL\", \"type\": \"url\", \"options\": []}, {\"id\": \"aify3r761b9w43bqjtskrzi68tr\", \"name\": \"Passcode\", \"type\": \"text\", \"options\": []}]',1684139133218,1684139133218,0,''),('bz8r98156ppgxdctqjuxytu5cgc','2023-05-15 08:25:15.654281','0','','system','system','O','Meeting Agenda ','Use this template for recurring meeting agendas, like team meetings and 1:1\'s. To use this board:\n* Participants queue new items to discuss under \"To Discuss\"\n* Go through items during the meeting\n* Move items to Done or Revisit Later as needed','?',1,1,6,'{\"trackingTemplateId\": \"54fcf9c610f0ac5e4c522c0657c90602\"}','[{\"id\": \"d777ba3b-8728-40d1-87a6-59406bbbbfb0\", \"name\": \"Status\", \"type\": \"select\", \"options\": [{\"id\": \"34eb9c25-d5bf-49d9-859e-f74f4e0030e7\", \"color\": \"propColorPink\", \"value\": \"To Discuss ?\"}, {\"id\": \"d37a61f4-f332-4db9-8b2d-5e0a91aa20ed\", \"color\": \"propColorYellow\", \"value\": \"Revisit Later ⏳\"}, {\"id\": \"dabadd9b-adf1-4d9f-8702-805ac6cef602\", \"color\": \"propColorGreen\", \"value\": \"Done / Archived ?\"}]}, {\"id\": \"4cf1568d-530f-4028-8ffd-bdc65249187e\", \"name\": \"Priority\", \"type\": \"select\", \"options\": [{\"id\": \"8b05c83e-a44a-4d04-831e-97f01d8e2003\", \"color\": \"propColorRed\", \"value\": \"1. High\"}, {\"id\": \"b1abafbf-a038-4a19-8b68-56e0fd2319f7\", \"color\": \"propColorYellow\", \"value\": \"2. Medium\"}, {\"id\": \"2491ffaa-eb55-417b-8aff-4bd7d4136613\", \"color\": \"propColorGray\", \"value\": \"3. Low\"}]}, {\"id\": \"aw4w63xhet79y9gueqzzeiifdoe\", \"name\": \"Created by\", \"type\": \"createdBy\", \"options\": []}, {\"id\": \"a6ux19353xcwfqg9k1inqg5sg4w\", \"name\": \"Created time\", \"type\": \"createdTime\", \"options\": []}]',1684139114979,1684139114979,0,'');
/*!40000 ALTER TABLE `focalboard_boards_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_categories`
--

DROP TABLE IF EXISTS `focalboard_categories`;
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

--
-- Dumping data for table `focalboard_categories`
--

LOCK TABLES `focalboard_categories` WRITE;
/*!40000 ALTER TABLE `focalboard_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `focalboard_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_category_boards`
--

DROP TABLE IF EXISTS `focalboard_category_boards`;
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

--
-- Dumping data for table `focalboard_category_boards`
--

LOCK TABLES `focalboard_category_boards` WRITE;
/*!40000 ALTER TABLE `focalboard_category_boards` DISABLE KEYS */;
/*!40000 ALTER TABLE `focalboard_category_boards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_file_info`
--

DROP TABLE IF EXISTS `focalboard_file_info`;
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

--
-- Dumping data for table `focalboard_file_info`
--

LOCK TABLES `focalboard_file_info` WRITE;
/*!40000 ALTER TABLE `focalboard_file_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `focalboard_file_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_notification_hints`
--

DROP TABLE IF EXISTS `focalboard_notification_hints`;
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

--
-- Dumping data for table `focalboard_notification_hints`
--

LOCK TABLES `focalboard_notification_hints` WRITE;
/*!40000 ALTER TABLE `focalboard_notification_hints` DISABLE KEYS */;
/*!40000 ALTER TABLE `focalboard_notification_hints` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_preferences`
--

DROP TABLE IF EXISTS `focalboard_preferences`;
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

--
-- Dumping data for table `focalboard_preferences`
--

LOCK TABLES `focalboard_preferences` WRITE;
/*!40000 ALTER TABLE `focalboard_preferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `focalboard_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_schema_migrations`
--

DROP TABLE IF EXISTS `focalboard_schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_schema_migrations` (
  `Version` bigint(20) NOT NULL,
  `Name` varchar(64) NOT NULL,
  PRIMARY KEY (`Version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `focalboard_schema_migrations`
--

LOCK TABLES `focalboard_schema_migrations` WRITE;
/*!40000 ALTER TABLE `focalboard_schema_migrations` DISABLE KEYS */;
INSERT INTO `focalboard_schema_migrations` VALUES (1,'init'),(2,'system_settings_table'),(3,'blocks_rootid'),(4,'auth_table'),(5,'blocks_modifiedby'),(6,'sharing_table'),(7,'workspaces_table'),(8,'teams'),(9,'blocks_history'),(10,'blocks_created_by'),(11,'match_collation'),(12,'match_column_collation'),(13,'millisecond_timestamps'),(14,'add_not_null_constraint'),(15,'blocks_history_no_nulls'),(16,'subscriptions_table'),(17,'add_file_info'),(18,'add_teams_and_boards'),(19,'populate_categories'),(20,'populate_category_blocks'),(21,'create_boards_members_history'),(22,'create_default_board_role'),(23,'persist_category_collapsed_state'),(24,'mark_existsing_categories_collapsed'),(25,'indexes_update'),(26,'create_preferences_table'),(27,'migrate_user_props_to_preferences'),(28,'remove_template_channel_link'),(29,'add_category_type_field'),(30,'add_category_sort_order'),(31,'add_category_boards_sort_order'),(32,'move_boards_category_to_end'),(33,'remove_deleted_category_boards'),(34,'category_boards_remove_unused_delete_at_column'),(35,'add_hidden_board_column'),(36,'category_board_add_unique_constraint'),(37,'hidden_boards_from_preferences'),(38,'delete_hiddenBoardIDs_from_preferences'),(39,'add_path_to_file_info');
/*!40000 ALTER TABLE `focalboard_schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_sessions`
--

DROP TABLE IF EXISTS `focalboard_sessions`;
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

--
-- Dumping data for table `focalboard_sessions`
--

LOCK TABLES `focalboard_sessions` WRITE;
/*!40000 ALTER TABLE `focalboard_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `focalboard_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_sharing`
--

DROP TABLE IF EXISTS `focalboard_sharing`;
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

--
-- Dumping data for table `focalboard_sharing`
--

LOCK TABLES `focalboard_sharing` WRITE;
/*!40000 ALTER TABLE `focalboard_sharing` DISABLE KEYS */;
/*!40000 ALTER TABLE `focalboard_sharing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_subscriptions`
--

DROP TABLE IF EXISTS `focalboard_subscriptions`;
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

--
-- Dumping data for table `focalboard_subscriptions`
--

LOCK TABLES `focalboard_subscriptions` WRITE;
/*!40000 ALTER TABLE `focalboard_subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `focalboard_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_system_settings`
--

DROP TABLE IF EXISTS `focalboard_system_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `focalboard_system_settings` (
  `id` varchar(100) NOT NULL,
  `value` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `focalboard_system_settings`
--

LOCK TABLES `focalboard_system_settings` WRITE;
/*!40000 ALTER TABLE `focalboard_system_settings` DISABLE KEYS */;
INSERT INTO `focalboard_system_settings` VALUES ('CategoryUuidIdMigrationComplete','true'),('DeDuplicateCategoryBoardTableComplete','true'),('DeletedMembershipBoardsMigrationComplete','true'),('TeamLessBoardsMigrationComplete','true'),('TelemetryID','7kd8onqsos38tfy1z9jj3nsqfdc'),('UniqueIDsMigrationComplete','true');
/*!40000 ALTER TABLE `focalboard_system_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_teams`
--

DROP TABLE IF EXISTS `focalboard_teams`;
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

--
-- Dumping data for table `focalboard_teams`
--

LOCK TABLES `focalboard_teams` WRITE;
/*!40000 ALTER TABLE `focalboard_teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `focalboard_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `focalboard_users`
--

DROP TABLE IF EXISTS `focalboard_users`;
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

--
-- Dumping data for table `focalboard_users`
--

LOCK TABLES `focalboard_users` WRITE;
/*!40000 ALTER TABLE `focalboard_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `focalboard_users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-05-15 12:26:31

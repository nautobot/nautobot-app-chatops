--
-- PostgreSQL database dump
--

-- Dumped from database version 12.16 (Debian 12.16-1.pgdg120+1)
-- Dumped by pg_dump version 12.16 (Debian 12.16-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: channel_type; Type: TYPE; Schema: public; Owner: mmuser
--

CREATE TYPE public.channel_type AS ENUM (
    'P',
    'G',
    'O',
    'D'
);


ALTER TYPE public.channel_type OWNER TO mmuser;

--
-- Name: team_type; Type: TYPE; Schema: public; Owner: mmuser
--

CREATE TYPE public.team_type AS ENUM (
    'I',
    'O'
);


ALTER TYPE public.team_type OWNER TO mmuser;

--
-- Name: upload_session_type; Type: TYPE; Schema: public; Owner: mmuser
--

CREATE TYPE public.upload_session_type AS ENUM (
    'attachment',
    'import'
);


ALTER TYPE public.upload_session_type OWNER TO mmuser;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audits; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.audits (
    id character varying(26) NOT NULL,
    createat bigint,
    userid character varying(26),
    action character varying(512),
    extrainfo character varying(1024),
    ipaddress character varying(64),
    sessionid character varying(26)
);


ALTER TABLE public.audits OWNER TO mmuser;

--
-- Name: bots; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.bots (
    userid character varying(26) NOT NULL,
    description character varying(1024),
    ownerid character varying(190),
    createat bigint,
    updateat bigint,
    deleteat bigint,
    lasticonupdate bigint
);


ALTER TABLE public.bots OWNER TO mmuser;

--
-- Name: channelmemberhistory; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.channelmemberhistory (
    channelid character varying(26) NOT NULL,
    userid character varying(26) NOT NULL,
    jointime bigint NOT NULL,
    leavetime bigint
);


ALTER TABLE public.channelmemberhistory OWNER TO mmuser;

--
-- Name: channelmembers; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.channelmembers (
    channelid character varying(26) NOT NULL,
    userid character varying(26) NOT NULL,
    roles character varying(256),
    lastviewedat bigint,
    msgcount bigint,
    mentioncount bigint,
    notifyprops jsonb,
    lastupdateat bigint,
    schemeuser boolean,
    schemeadmin boolean,
    schemeguest boolean,
    mentioncountroot bigint,
    msgcountroot bigint,
    urgentmentioncount bigint
);


ALTER TABLE public.channelmembers OWNER TO mmuser;

--
-- Name: channels; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.channels (
    id character varying(26) NOT NULL,
    createat bigint,
    updateat bigint,
    deleteat bigint,
    teamid character varying(26),
    type public.channel_type,
    displayname character varying(64),
    name character varying(64),
    header character varying(1024),
    purpose character varying(250),
    lastpostat bigint,
    totalmsgcount bigint,
    extraupdateat bigint,
    creatorid character varying(26),
    schemeid character varying(26),
    groupconstrained boolean,
    shared boolean,
    totalmsgcountroot bigint,
    lastrootpostat bigint DEFAULT '0'::bigint
);


ALTER TABLE public.channels OWNER TO mmuser;

--
-- Name: clusterdiscovery; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.clusterdiscovery (
    id character varying(26) NOT NULL,
    type character varying(64),
    clustername character varying(64),
    hostname character varying(512),
    gossipport integer,
    port integer,
    createat bigint,
    lastpingat bigint
);


ALTER TABLE public.clusterdiscovery OWNER TO mmuser;

--
-- Name: commands; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.commands (
    id character varying(26) NOT NULL,
    token character varying(26),
    createat bigint,
    updateat bigint,
    deleteat bigint,
    creatorid character varying(26),
    teamid character varying(26),
    trigger character varying(128),
    method character varying(1),
    username character varying(64),
    iconurl character varying(1024),
    autocomplete boolean,
    autocompletedesc character varying(1024),
    autocompletehint character varying(1024),
    displayname character varying(64),
    description character varying(128),
    url character varying(1024),
    pluginid character varying(190)
);


ALTER TABLE public.commands OWNER TO mmuser;

--
-- Name: commandwebhooks; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.commandwebhooks (
    id character varying(26) NOT NULL,
    createat bigint,
    commandid character varying(26),
    userid character varying(26),
    channelid character varying(26),
    rootid character varying(26),
    usecount integer
);


ALTER TABLE public.commandwebhooks OWNER TO mmuser;

--
-- Name: compliances; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.compliances (
    id character varying(26) NOT NULL,
    createat bigint,
    userid character varying(26),
    status character varying(64),
    count integer,
    "desc" character varying(512),
    type character varying(64),
    startat bigint,
    endat bigint,
    keywords character varying(512),
    emails character varying(1024)
);


ALTER TABLE public.compliances OWNER TO mmuser;

--
-- Name: db_lock; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.db_lock (
    id character varying(64) NOT NULL,
    expireat bigint
);


ALTER TABLE public.db_lock OWNER TO mmuser;

--
-- Name: db_migrations; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.db_migrations (
    version bigint NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.db_migrations OWNER TO mmuser;

--
-- Name: drafts; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.drafts (
    createat bigint,
    updateat bigint,
    deleteat bigint,
    userid character varying(26) NOT NULL,
    channelid character varying(26) NOT NULL,
    rootid character varying(26) DEFAULT ''::character varying NOT NULL,
    message character varying(65535),
    props character varying(8000),
    fileids character varying(300),
    priority text
);


ALTER TABLE public.drafts OWNER TO mmuser;

--
-- Name: emoji; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.emoji (
    id character varying(26) NOT NULL,
    createat bigint,
    updateat bigint,
    deleteat bigint,
    creatorid character varying(26),
    name character varying(64)
);


ALTER TABLE public.emoji OWNER TO mmuser;

--
-- Name: fileinfo; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.fileinfo (
    id character varying(26) NOT NULL,
    creatorid character varying(26),
    postid character varying(26),
    createat bigint,
    updateat bigint,
    deleteat bigint,
    path character varying(512),
    thumbnailpath character varying(512),
    previewpath character varying(512),
    name character varying(256),
    extension character varying(64),
    size bigint,
    mimetype character varying(256),
    width integer,
    height integer,
    haspreviewimage boolean,
    minipreview bytea,
    content text,
    remoteid character varying(26),
    archived boolean DEFAULT false NOT NULL,
    channelid character varying(26)
)
WITH (autovacuum_vacuum_scale_factor='0.1', autovacuum_analyze_scale_factor='0.05');


ALTER TABLE public.fileinfo OWNER TO mmuser;

--
-- Name: groupchannels; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.groupchannels (
    groupid character varying(26) NOT NULL,
    autoadd boolean,
    schemeadmin boolean,
    createat bigint,
    deleteat bigint,
    updateat bigint,
    channelid character varying(26) NOT NULL
);


ALTER TABLE public.groupchannels OWNER TO mmuser;

--
-- Name: groupmembers; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.groupmembers (
    groupid character varying(26) NOT NULL,
    userid character varying(26) NOT NULL,
    createat bigint,
    deleteat bigint
);


ALTER TABLE public.groupmembers OWNER TO mmuser;

--
-- Name: groupteams; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.groupteams (
    groupid character varying(26) NOT NULL,
    autoadd boolean,
    schemeadmin boolean,
    createat bigint,
    deleteat bigint,
    updateat bigint,
    teamid character varying(26) NOT NULL
);


ALTER TABLE public.groupteams OWNER TO mmuser;

--
-- Name: incomingwebhooks; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.incomingwebhooks (
    id character varying(26) NOT NULL,
    createat bigint,
    updateat bigint,
    deleteat bigint,
    userid character varying(26),
    channelid character varying(26),
    teamid character varying(26),
    displayname character varying(64),
    description character varying(500),
    username character varying(255),
    iconurl character varying(1024),
    channellocked boolean
);


ALTER TABLE public.incomingwebhooks OWNER TO mmuser;

--
-- Name: ir_category; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_category (
    id character varying(26) NOT NULL,
    name character varying(512) NOT NULL,
    teamid character varying(26) NOT NULL,
    userid character varying(26) NOT NULL,
    collapsed boolean DEFAULT false,
    createat bigint NOT NULL,
    updateat bigint DEFAULT 0 NOT NULL,
    deleteat bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.ir_category OWNER TO mmuser;

--
-- Name: ir_category_item; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_category_item (
    type character varying(1) NOT NULL,
    categoryid character varying(26) NOT NULL,
    itemid character varying(26) NOT NULL
);


ALTER TABLE public.ir_category_item OWNER TO mmuser;

--
-- Name: ir_channelaction; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_channelaction (
    id character varying(26) NOT NULL,
    channelid character varying(26),
    enabled boolean DEFAULT false,
    deleteat bigint DEFAULT 0 NOT NULL,
    actiontype character varying(65535) NOT NULL,
    triggertype character varying(65535) NOT NULL,
    payload json NOT NULL
);


ALTER TABLE public.ir_channelaction OWNER TO mmuser;

--
-- Name: ir_incident; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_incident (
    id character varying(26) NOT NULL,
    name character varying(1024) NOT NULL,
    description character varying(4096) NOT NULL,
    isactive boolean NOT NULL,
    commanderuserid character varying(26) NOT NULL,
    teamid character varying(26) NOT NULL,
    channelid character varying(26) NOT NULL,
    createat bigint NOT NULL,
    endat bigint DEFAULT 0 NOT NULL,
    deleteat bigint DEFAULT 0 NOT NULL,
    activestage bigint NOT NULL,
    postid character varying(26) DEFAULT ''::text NOT NULL,
    playbookid character varying(26) DEFAULT ''::text NOT NULL,
    checklistsjson json NOT NULL,
    activestagetitle character varying(1024) DEFAULT ''::text,
    reminderpostid character varying(26),
    broadcastchannelid character varying(26) DEFAULT ''::text,
    previousreminder bigint DEFAULT 0 NOT NULL,
    remindermessagetemplate character varying(65535) DEFAULT ''::text,
    currentstatus character varying(1024) DEFAULT 'Active'::text NOT NULL,
    reporteruserid character varying(26) DEFAULT ''::text NOT NULL,
    concatenatedinviteduserids character varying(65535) DEFAULT ''::text,
    defaultcommanderid character varying(26) DEFAULT ''::text,
    announcementchannelid character varying(26) DEFAULT ''::text,
    concatenatedwebhookoncreationurls character varying(65535) DEFAULT ''::text,
    concatenatedinvitedgroupids character varying(65535) DEFAULT ''::text,
    retrospective character varying(65535) DEFAULT ''::text,
    messageonjoin character varying(65535) DEFAULT ''::text,
    retrospectivepublishedat bigint DEFAULT 0 NOT NULL,
    retrospectivereminderintervalseconds bigint DEFAULT 0 NOT NULL,
    retrospectivewascanceled boolean DEFAULT false,
    concatenatedwebhookonstatusupdateurls character varying(65535) DEFAULT ''::text,
    laststatusupdateat bigint DEFAULT 0,
    exportchannelonfinishedenabled boolean DEFAULT false NOT NULL,
    categorizechannelenabled boolean DEFAULT false,
    categoryname character varying(65535) DEFAULT ''::text,
    concatenatedbroadcastchannelids character varying(65535),
    channelidtorootid character varying(65535) DEFAULT ''::text,
    remindertimerdefaultseconds bigint DEFAULT 0 NOT NULL,
    statusupdateenabled boolean DEFAULT true,
    retrospectiveenabled boolean DEFAULT true,
    statusupdatebroadcastchannelsenabled boolean DEFAULT false,
    statusupdatebroadcastwebhooksenabled boolean DEFAULT false,
    summarymodifiedat bigint DEFAULT 0 NOT NULL,
    createchannelmemberonnewparticipant boolean DEFAULT true,
    removechannelmemberonremovedparticipant boolean DEFAULT true,
    runtype character varying(32) DEFAULT 'playbook'::character varying
);


ALTER TABLE public.ir_incident OWNER TO mmuser;

--
-- Name: ir_metric; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_metric (
    incidentid character varying(26) NOT NULL,
    metricconfigid character varying(26) NOT NULL,
    value bigint,
    published boolean NOT NULL
);


ALTER TABLE public.ir_metric OWNER TO mmuser;

--
-- Name: ir_metricconfig; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_metricconfig (
    id character varying(26) NOT NULL,
    playbookid character varying(26) NOT NULL,
    title character varying(512) NOT NULL,
    description character varying(4096) NOT NULL,
    type character varying(32) NOT NULL,
    target bigint,
    ordering smallint DEFAULT 0 NOT NULL,
    deleteat bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.ir_metricconfig OWNER TO mmuser;

--
-- Name: ir_playbook; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_playbook (
    id character varying(26) NOT NULL,
    title character varying(1024) NOT NULL,
    description character varying(4096) NOT NULL,
    teamid character varying(26) NOT NULL,
    createpublicincident boolean NOT NULL,
    createat bigint NOT NULL,
    deleteat bigint DEFAULT 0 NOT NULL,
    checklistsjson json NOT NULL,
    numstages bigint DEFAULT 0 NOT NULL,
    numsteps bigint DEFAULT 0 NOT NULL,
    broadcastchannelid character varying(26) DEFAULT ''::text,
    remindermessagetemplate character varying(65535) DEFAULT ''::text,
    remindertimerdefaultseconds bigint DEFAULT 0 NOT NULL,
    concatenatedinviteduserids character varying(65535) DEFAULT ''::text,
    inviteusersenabled boolean DEFAULT false,
    defaultcommanderid character varying(26) DEFAULT ''::text,
    defaultcommanderenabled boolean DEFAULT false,
    announcementchannelid character varying(26) DEFAULT ''::text,
    announcementchannelenabled boolean DEFAULT false,
    concatenatedwebhookoncreationurls character varying(65535) DEFAULT ''::text,
    webhookoncreationenabled boolean DEFAULT false,
    concatenatedinvitedgroupids character varying(65535) DEFAULT ''::text,
    messageonjoin character varying(65535) DEFAULT ''::text,
    messageonjoinenabled boolean DEFAULT false,
    retrospectivereminderintervalseconds bigint DEFAULT 0 NOT NULL,
    retrospectivetemplate character varying(65535),
    concatenatedwebhookonstatusupdateurls character varying(65535) DEFAULT ''::text,
    webhookonstatusupdateenabled boolean DEFAULT false,
    concatenatedsignalanykeywords character varying(65535) DEFAULT ''::text,
    signalanykeywordsenabled boolean DEFAULT false,
    updateat bigint DEFAULT 0 NOT NULL,
    exportchannelonfinishedenabled boolean DEFAULT false NOT NULL,
    categorizechannelenabled boolean DEFAULT false,
    categoryname character varying(65535) DEFAULT ''::text,
    concatenatedbroadcastchannelids character varying(65535),
    broadcastenabled boolean DEFAULT false,
    runsummarytemplate character varying(65535) DEFAULT ''::text,
    channelnametemplate character varying(65535) DEFAULT ''::text,
    statusupdateenabled boolean DEFAULT true,
    retrospectiveenabled boolean DEFAULT true,
    public boolean DEFAULT false,
    runsummarytemplateenabled boolean DEFAULT true,
    createchannelmemberonnewparticipant boolean DEFAULT true,
    removechannelmemberonremovedparticipant boolean DEFAULT true,
    channelid character varying(26) DEFAULT ''::character varying,
    channelmode character varying(32) DEFAULT 'create_new_channel'::character varying
);


ALTER TABLE public.ir_playbook OWNER TO mmuser;

--
-- Name: ir_playbookautofollow; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_playbookautofollow (
    playbookid character varying(26) NOT NULL,
    userid character varying(26) NOT NULL
);


ALTER TABLE public.ir_playbookautofollow OWNER TO mmuser;

--
-- Name: ir_playbookmember; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_playbookmember (
    playbookid character varying(26) NOT NULL,
    memberid character varying(26) NOT NULL,
    roles character varying(65535)
);


ALTER TABLE public.ir_playbookmember OWNER TO mmuser;

--
-- Name: ir_run_participants; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_run_participants (
    userid character varying(26) NOT NULL,
    incidentid character varying(26) NOT NULL,
    isfollower boolean DEFAULT false NOT NULL,
    isparticipant boolean DEFAULT false
);


ALTER TABLE public.ir_run_participants OWNER TO mmuser;

--
-- Name: ir_statusposts; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_statusposts (
    incidentid character varying(26) NOT NULL,
    postid character varying(26) NOT NULL
);


ALTER TABLE public.ir_statusposts OWNER TO mmuser;

--
-- Name: ir_system; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_system (
    skey character varying(64) NOT NULL,
    svalue character varying(1024)
);


ALTER TABLE public.ir_system OWNER TO mmuser;

--
-- Name: ir_timelineevent; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_timelineevent (
    id character varying(26) NOT NULL,
    incidentid character varying(26) NOT NULL,
    createat bigint NOT NULL,
    deleteat bigint DEFAULT 0 NOT NULL,
    eventat bigint NOT NULL,
    eventtype character varying(32) DEFAULT ''::text NOT NULL,
    summary character varying(256) DEFAULT ''::text NOT NULL,
    details character varying(4096) DEFAULT ''::text NOT NULL,
    postid character varying(26) DEFAULT ''::text NOT NULL,
    subjectuserid character varying(26) DEFAULT ''::text NOT NULL,
    creatoruserid character varying(26) DEFAULT ''::text NOT NULL
);


ALTER TABLE public.ir_timelineevent OWNER TO mmuser;

--
-- Name: ir_userinfo; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_userinfo (
    id character varying(26) NOT NULL,
    lastdailytododmat bigint,
    digestnotificationsettingsjson json
);


ALTER TABLE public.ir_userinfo OWNER TO mmuser;

--
-- Name: ir_viewedchannel; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.ir_viewedchannel (
    channelid character varying(26) NOT NULL,
    userid character varying(26) NOT NULL
);


ALTER TABLE public.ir_viewedchannel OWNER TO mmuser;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.jobs (
    id character varying(26) NOT NULL,
    type character varying(32),
    priority bigint,
    createat bigint,
    startat bigint,
    lastactivityat bigint,
    status character varying(32),
    progress bigint,
    data jsonb
);


ALTER TABLE public.jobs OWNER TO mmuser;

--
-- Name: licenses; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.licenses (
    id character varying(26) NOT NULL,
    createat bigint,
    bytes character varying(10000)
);


ALTER TABLE public.licenses OWNER TO mmuser;

--
-- Name: linkmetadata; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.linkmetadata (
    hash bigint NOT NULL,
    url character varying(2048),
    "timestamp" bigint,
    type character varying(16),
    data jsonb
);


ALTER TABLE public.linkmetadata OWNER TO mmuser;

--
-- Name: notifyadmin; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.notifyadmin (
    userid character varying(26) NOT NULL,
    createat bigint,
    requiredplan character varying(100) NOT NULL,
    requiredfeature character varying(255) NOT NULL,
    trial boolean NOT NULL,
    sentat bigint
);


ALTER TABLE public.notifyadmin OWNER TO mmuser;

--
-- Name: oauthaccessdata; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.oauthaccessdata (
    token character varying(26) NOT NULL,
    refreshtoken character varying(26),
    redirecturi character varying(256),
    clientid character varying(26),
    userid character varying(26),
    expiresat bigint,
    scope character varying(128)
);


ALTER TABLE public.oauthaccessdata OWNER TO mmuser;

--
-- Name: oauthapps; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.oauthapps (
    id character varying(26) NOT NULL,
    creatorid character varying(26),
    createat bigint,
    updateat bigint,
    clientsecret character varying(128),
    name character varying(64),
    description character varying(512),
    callbackurls character varying(1024),
    homepage character varying(256),
    istrusted boolean,
    iconurl character varying(512),
    mattermostappid character varying(32) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.oauthapps OWNER TO mmuser;

--
-- Name: oauthauthdata; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.oauthauthdata (
    clientid character varying(26),
    userid character varying(26),
    code character varying(128) NOT NULL,
    expiresin integer,
    createat bigint,
    redirecturi character varying(256),
    state character varying(1024),
    scope character varying(128)
);


ALTER TABLE public.oauthauthdata OWNER TO mmuser;

--
-- Name: outgoingwebhooks; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.outgoingwebhooks (
    id character varying(26) NOT NULL,
    token character varying(26),
    createat bigint,
    updateat bigint,
    deleteat bigint,
    creatorid character varying(26),
    channelid character varying(26),
    teamid character varying(26),
    triggerwords character varying(1024),
    callbackurls character varying(1024),
    displayname character varying(64),
    contenttype character varying(128),
    triggerwhen integer,
    username character varying(64),
    iconurl character varying(1024),
    description character varying(500)
);


ALTER TABLE public.outgoingwebhooks OWNER TO mmuser;

--
-- Name: persistentnotifications; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.persistentnotifications (
    postid character varying(26) NOT NULL,
    createat bigint,
    lastsentat bigint,
    deleteat bigint,
    sentcount smallint
);


ALTER TABLE public.persistentnotifications OWNER TO mmuser;

--
-- Name: pluginkeyvaluestore; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.pluginkeyvaluestore (
    pluginid character varying(190) NOT NULL,
    pkey character varying(150) NOT NULL,
    pvalue bytea,
    expireat bigint
);


ALTER TABLE public.pluginkeyvaluestore OWNER TO mmuser;

--
-- Name: postacknowledgements; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.postacknowledgements (
    postid character varying(26) NOT NULL,
    userid character varying(26) NOT NULL,
    acknowledgedat bigint
);


ALTER TABLE public.postacknowledgements OWNER TO mmuser;

--
-- Name: postreminders; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.postreminders (
    postid character varying(26) NOT NULL,
    userid character varying(26) NOT NULL,
    targettime bigint
);


ALTER TABLE public.postreminders OWNER TO mmuser;

--
-- Name: posts; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.posts (
    id character varying(26) NOT NULL,
    createat bigint,
    updateat bigint,
    deleteat bigint,
    userid character varying(26),
    channelid character varying(26),
    rootid character varying(26),
    originalid character varying(26),
    message character varying(65535),
    type character varying(26),
    props jsonb,
    hashtags character varying(1000),
    filenames character varying(4000),
    fileids character varying(300),
    hasreactions boolean,
    editat bigint,
    ispinned boolean,
    remoteid character varying(26)
)
WITH (autovacuum_vacuum_scale_factor='0.1', autovacuum_analyze_scale_factor='0.05');


ALTER TABLE public.posts OWNER TO mmuser;

--
-- Name: postspriority; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.postspriority (
    postid character varying(26) NOT NULL,
    channelid character varying(26) NOT NULL,
    priority character varying(32) NOT NULL,
    requestedack boolean,
    persistentnotifications boolean
);


ALTER TABLE public.postspriority OWNER TO mmuser;

--
-- Name: preferences; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.preferences (
    userid character varying(26) NOT NULL,
    category character varying(32) NOT NULL,
    name character varying(32) NOT NULL,
    value character varying(2000)
)
WITH (autovacuum_vacuum_scale_factor='0.1', autovacuum_analyze_scale_factor='0.05');


ALTER TABLE public.preferences OWNER TO mmuser;

--
-- Name: productnoticeviewstate; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.productnoticeviewstate (
    userid character varying(26) NOT NULL,
    noticeid character varying(26) NOT NULL,
    viewed integer,
    "timestamp" bigint
);


ALTER TABLE public.productnoticeviewstate OWNER TO mmuser;

--
-- Name: publicchannels; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.publicchannels (
    id character varying(26) NOT NULL,
    deleteat bigint,
    teamid character varying(26),
    displayname character varying(64),
    name character varying(64),
    header character varying(1024),
    purpose character varying(250)
);


ALTER TABLE public.publicchannels OWNER TO mmuser;

--
-- Name: reactions; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.reactions (
    userid character varying(26) NOT NULL,
    postid character varying(26) NOT NULL,
    emojiname character varying(64) NOT NULL,
    createat bigint,
    updateat bigint,
    deleteat bigint,
    remoteid character varying(26),
    channelid character varying(26) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.reactions OWNER TO mmuser;

--
-- Name: recentsearches; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.recentsearches (
    userid character(26) NOT NULL,
    searchpointer integer NOT NULL,
    query jsonb,
    createat bigint NOT NULL
);


ALTER TABLE public.recentsearches OWNER TO mmuser;

--
-- Name: remoteclusters; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.remoteclusters (
    remoteid character varying(26) NOT NULL,
    remoteteamid character varying(26),
    name character varying(64) NOT NULL,
    displayname character varying(64),
    siteurl character varying(512),
    createat bigint,
    lastpingat bigint,
    token character varying(26),
    remotetoken character varying(26),
    topics character varying(512),
    creatorid character varying(26)
);


ALTER TABLE public.remoteclusters OWNER TO mmuser;

--
-- Name: retentionpolicies; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.retentionpolicies (
    id character varying(26) NOT NULL,
    displayname character varying(64),
    postduration bigint
);


ALTER TABLE public.retentionpolicies OWNER TO mmuser;

--
-- Name: retentionpolicieschannels; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.retentionpolicieschannels (
    policyid character varying(26),
    channelid character varying(26) NOT NULL
);


ALTER TABLE public.retentionpolicieschannels OWNER TO mmuser;

--
-- Name: retentionpoliciesteams; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.retentionpoliciesteams (
    policyid character varying(26),
    teamid character varying(26) NOT NULL
);


ALTER TABLE public.retentionpoliciesteams OWNER TO mmuser;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.roles (
    id character varying(26) NOT NULL,
    name character varying(64),
    displayname character varying(128),
    description character varying(1024),
    createat bigint,
    updateat bigint,
    deleteat bigint,
    permissions text,
    schememanaged boolean,
    builtin boolean
);


ALTER TABLE public.roles OWNER TO mmuser;

--
-- Name: schemes; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.schemes (
    id character varying(26) NOT NULL,
    name character varying(64),
    displayname character varying(128),
    description character varying(1024),
    createat bigint,
    updateat bigint,
    deleteat bigint,
    scope character varying(32),
    defaultteamadminrole character varying(64),
    defaultteamuserrole character varying(64),
    defaultchanneladminrole character varying(64),
    defaultchanneluserrole character varying(64),
    defaultteamguestrole character varying(64),
    defaultchannelguestrole character varying(64),
    defaultplaybookadminrole character varying(64) DEFAULT ''::character varying,
    defaultplaybookmemberrole character varying(64) DEFAULT ''::character varying,
    defaultrunadminrole character varying(64) DEFAULT ''::character varying,
    defaultrunmemberrole character varying(64) DEFAULT ''::character varying
);


ALTER TABLE public.schemes OWNER TO mmuser;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.sessions (
    id character varying(26) NOT NULL,
    token character varying(26),
    createat bigint,
    expiresat bigint,
    lastactivityat bigint,
    userid character varying(26),
    deviceid character varying(512),
    roles character varying(256),
    isoauth boolean,
    props jsonb,
    expirednotify boolean
);


ALTER TABLE public.sessions OWNER TO mmuser;

--
-- Name: sharedchannelattachments; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.sharedchannelattachments (
    id character varying(26) NOT NULL,
    fileid character varying(26),
    remoteid character varying(26),
    createat bigint,
    lastsyncat bigint
);


ALTER TABLE public.sharedchannelattachments OWNER TO mmuser;

--
-- Name: sharedchannelremotes; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.sharedchannelremotes (
    id character varying(26) NOT NULL,
    channelid character varying(26) NOT NULL,
    creatorid character varying(26),
    createat bigint,
    updateat bigint,
    isinviteaccepted boolean,
    isinviteconfirmed boolean,
    remoteid character varying(26),
    lastpostupdateat bigint,
    lastpostid character varying(26)
);


ALTER TABLE public.sharedchannelremotes OWNER TO mmuser;

--
-- Name: sharedchannels; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.sharedchannels (
    channelid character varying(26) NOT NULL,
    teamid character varying(26),
    home boolean,
    readonly boolean,
    sharename character varying(64),
    sharedisplayname character varying(64),
    sharepurpose character varying(250),
    shareheader character varying(1024),
    creatorid character varying(26),
    createat bigint,
    updateat bigint,
    remoteid character varying(26)
);


ALTER TABLE public.sharedchannels OWNER TO mmuser;

--
-- Name: sharedchannelusers; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.sharedchannelusers (
    id character varying(26) NOT NULL,
    userid character varying(26),
    remoteid character varying(26),
    createat bigint,
    lastsyncat bigint,
    channelid character varying(26)
);


ALTER TABLE public.sharedchannelusers OWNER TO mmuser;

--
-- Name: sidebarcategories; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.sidebarcategories (
    id character varying(128) NOT NULL,
    userid character varying(26),
    teamid character varying(26),
    sortorder bigint,
    sorting character varying(64),
    type character varying(64),
    displayname character varying(64),
    muted boolean,
    collapsed boolean
);


ALTER TABLE public.sidebarcategories OWNER TO mmuser;

--
-- Name: sidebarchannels; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.sidebarchannels (
    channelid character varying(26) NOT NULL,
    userid character varying(26) NOT NULL,
    categoryid character varying(128) NOT NULL,
    sortorder bigint
);


ALTER TABLE public.sidebarchannels OWNER TO mmuser;

--
-- Name: status; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.status (
    userid character varying(26) NOT NULL,
    status character varying(32),
    manual boolean,
    lastactivityat bigint,
    dndendtime bigint,
    prevstatus character varying(32)
);


ALTER TABLE public.status OWNER TO mmuser;

--
-- Name: systems; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.systems (
    name character varying(64) NOT NULL,
    value character varying(1024)
);


ALTER TABLE public.systems OWNER TO mmuser;

--
-- Name: teammembers; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.teammembers (
    teamid character varying(26) NOT NULL,
    userid character varying(26) NOT NULL,
    roles character varying(256),
    deleteat bigint,
    schemeuser boolean,
    schemeadmin boolean,
    schemeguest boolean,
    createat bigint DEFAULT 0
);


ALTER TABLE public.teammembers OWNER TO mmuser;

--
-- Name: teams; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.teams (
    id character varying(26) NOT NULL,
    createat bigint,
    updateat bigint,
    deleteat bigint,
    displayname character varying(64),
    name character varying(64),
    description character varying(255),
    email character varying(128),
    type public.team_type,
    companyname character varying(64),
    alloweddomains character varying(1000),
    inviteid character varying(32),
    schemeid character varying(26),
    allowopeninvite boolean,
    lastteamiconupdate bigint,
    groupconstrained boolean,
    cloudlimitsarchived boolean DEFAULT false NOT NULL
);


ALTER TABLE public.teams OWNER TO mmuser;

--
-- Name: termsofservice; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.termsofservice (
    id character varying(26) NOT NULL,
    createat bigint,
    userid character varying(26),
    text character varying(65535)
);


ALTER TABLE public.termsofservice OWNER TO mmuser;

--
-- Name: threadmemberships; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.threadmemberships (
    postid character varying(26) NOT NULL,
    userid character varying(26) NOT NULL,
    following boolean,
    lastviewed bigint,
    lastupdated bigint,
    unreadmentions bigint
)
WITH (autovacuum_vacuum_scale_factor='0.1', autovacuum_analyze_scale_factor='0.05');


ALTER TABLE public.threadmemberships OWNER TO mmuser;

--
-- Name: threads; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.threads (
    postid character varying(26) NOT NULL,
    replycount bigint,
    lastreplyat bigint,
    participants jsonb,
    channelid character varying(26),
    threaddeleteat bigint,
    threadteamid character varying(26)
);


ALTER TABLE public.threads OWNER TO mmuser;

--
-- Name: tokens; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.tokens (
    token character varying(64) NOT NULL,
    createat bigint,
    type character varying(64),
    extra character varying(2048)
);


ALTER TABLE public.tokens OWNER TO mmuser;

--
-- Name: trueupreviewhistory; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.trueupreviewhistory (
    duedate bigint NOT NULL,
    completed boolean
);


ALTER TABLE public.trueupreviewhistory OWNER TO mmuser;

--
-- Name: uploadsessions; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.uploadsessions (
    id character varying(26) NOT NULL,
    type public.upload_session_type,
    createat bigint,
    userid character varying(26),
    channelid character varying(26),
    filename character varying(256),
    path character varying(512),
    filesize bigint,
    fileoffset bigint,
    remoteid character varying(26),
    reqfileid character varying(26)
);


ALTER TABLE public.uploadsessions OWNER TO mmuser;

--
-- Name: useraccesstokens; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.useraccesstokens (
    id character varying(26) NOT NULL,
    token character varying(26),
    userid character varying(26),
    description character varying(512),
    isactive boolean
);


ALTER TABLE public.useraccesstokens OWNER TO mmuser;

--
-- Name: usergroups; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.usergroups (
    id character varying(26) NOT NULL,
    name character varying(64),
    displayname character varying(128),
    description character varying(1024),
    source character varying(64),
    remoteid character varying(48),
    createat bigint,
    updateat bigint,
    deleteat bigint,
    allowreference boolean
);


ALTER TABLE public.usergroups OWNER TO mmuser;

--
-- Name: users; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.users (
    id character varying(26) NOT NULL,
    createat bigint,
    updateat bigint,
    deleteat bigint,
    username character varying(64),
    password character varying(128),
    authdata character varying(128),
    authservice character varying(32),
    email character varying(128),
    emailverified boolean,
    nickname character varying(64),
    firstname character varying(64),
    lastname character varying(64),
    roles character varying(256),
    allowmarketing boolean,
    props jsonb,
    notifyprops jsonb,
    lastpasswordupdate bigint,
    lastpictureupdate bigint,
    failedattempts integer,
    locale character varying(5),
    mfaactive boolean,
    mfasecret character varying(128),
    "position" character varying(128),
    timezone jsonb,
    remoteid character varying(26)
);


ALTER TABLE public.users OWNER TO mmuser;

--
-- Name: usertermsofservice; Type: TABLE; Schema: public; Owner: mmuser
--

CREATE TABLE public.usertermsofservice (
    userid character varying(26) NOT NULL,
    termsofserviceid character varying(26),
    createat bigint
);


ALTER TABLE public.usertermsofservice OWNER TO mmuser;

--
-- Data for Name: audits; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.audits VALUES ('dkj3tzm46inzubfgf8tcdp7pgw', 1698320750982, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/users/login', 'attempt - login_id=', '10.166.35.2', '');
INSERT INTO public.audits VALUES ('xtxom8758j8mxxdhrtcycp1tyo', 1698320751056, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/users/login', 'authenticated', '10.166.35.2', '');
INSERT INTO public.audits VALUES ('1u86rwj3ybbpfxmyxunew5iiyo', 1698320751070, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/users/login', 'success session_user=5md7bsji6pbijpxitu8bwezaqy', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('epra3qoyoifddyceqttxptsq4c', 1698320751647, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/system/onboarding/complete', 'attempt', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('ipozu9wift8fbms4rb9ix7kenw', 1698320870617, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/config', 'updateConfig', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('8fp9etosrfdfxy6z178qwzw4wy', 1698321187446, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/config', 'updateConfig', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('yb5cthepg7gd7xe6y1es4q3i8o', 1698321288420, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/users/w7uyhzuo7fnfueen6og9cxmn9h/image', '', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('jbu85hiszig9xxmz6r3omg4nwy', 1698321288523, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/users/w7uyhzuo7fnfueen6og9cxmn9h/tokens', '', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('pyhkh6us4tf8ic1qrcfm3n894a', 1698321288537, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/users/w7uyhzuo7fnfueen6og9cxmn9h/tokens', 'success - token_id=7xnejgyhj7nxtmq6t95iah7n7c', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('cu16juhnu7b4fn8owx5nxfhfsy', 1698321288591, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/users/w7uyhzuo7fnfueen6og9cxmn9h/roles', 'user=w7uyhzuo7fnfueen6og9cxmn9h roles=system_user system_admin', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('ox8eh5qg3b8didjy49qxt3e4zw', 1698321530586, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'attempt', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('e8mxhfjtnjyh3eksti7mmujsmo', 1698321530615, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'success', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('zekyg5c5bfgqbx4kzfdh8syrba', 1698322016025, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'attempt', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('ku9ztthjwtdw8fh1apbd8m7bwc', 1698322016048, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'success', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('xujye8uua78q9rzccctgu8hpsa', 1698322240876, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'attempt', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('5beieks3zbf83xehax7g5jqfuh', 1698322240899, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'success', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('j1pfzdoo5tffmfwey58nfoijuy', 1698322317970, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'attempt', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('jp4ubo31ebydjbx6rq9scoh5br', 1698322317993, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'success', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('fugumx1egbdz5psurrtzwd4pdr', 1698322371244, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'attempt', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('k9w475y7qjdkpksbp8yqjbuirc', 1698322371257, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'success', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('hoq9u8pfotfg3mm9kwmm7j85hr', 1698322417402, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'attempt', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('jzd5mhtq8briiqgy98mr11k6xe', 1698322417424, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'success', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('xwd9hbd5hby88fic55cgwkx3mo', 1698322479254, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'attempt', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('kjjukwgn4pffufedkzd5toeacw', 1698322479277, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'success', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('r9kxec153td49bpghdq3nme61h', 1698322532935, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'attempt', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('7zx6716r4fnutmhfqt49jehmoc', 1698322532958, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'success', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('n9iyafdkfpbhmxmmif9zfafjmh', 1698322585562, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'attempt', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');
INSERT INTO public.audits VALUES ('88uom3gn4bbgigihxcyzxt1wch', 1698322585586, '5md7bsji6pbijpxitu8bwezaqy', '/api/v4/commands', 'success', '10.166.35.2', 'xprkr99nfirmb8j4pdfzqhhtar');


--
-- Data for Name: bots; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.bots VALUES ('jmcgoiar5brr9nx8s7g3394c8e', 'Feedbackbot collects user feedback to improve Mattermost. [Learn more](https://mattermost.com/pl/default-nps).', 'com.mattermost.nps', 1698320582722, 1698320582722, 0, 0);
INSERT INTO public.bots VALUES ('mt3fq81mrbbydrefss1h9zfxhw', 'Playbooks bot.', 'playbooks', 1698320583270, 1698320583270, 0, 0);
INSERT INTO public.bots VALUES ('qicfanjtzbgsf8qh8zkosdq96e', 'Calls Bot', 'com.mattermost.calls', 1698320583530, 1698320583530, 0, 0);
INSERT INTO public.bots VALUES ('dnyqmp4u5tgetr9or6in55xobr', '', '5md7bsji6pbijpxitu8bwezaqy', 1698321000016, 1698321000016, 0, 0);
INSERT INTO public.bots VALUES ('w7uyhzuo7fnfueen6og9cxmn9h', 'Nautobot Mattermost Bot', '5md7bsji6pbijpxitu8bwezaqy', 1698321288290, 1698321288290, 0, 0);


--
-- Data for Name: channelmemberhistory; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.channelmemberhistory VALUES ('wjcp9j9mjfbe3f8t3mp5544y1w', '5md7bsji6pbijpxitu8bwezaqy', 1698320784767, NULL);
INSERT INTO public.channelmemberhistory VALUES ('g44m7cnnkjn6tbqsica1ste4jw', '5md7bsji6pbijpxitu8bwezaqy', 1698320784798, NULL);
INSERT INTO public.channelmemberhistory VALUES ('686m6w41q3bidjcxrsuymudgba', 'w7uyhzuo7fnfueen6og9cxmn9h', 1698321288312, NULL);
INSERT INTO public.channelmemberhistory VALUES ('686m6w41q3bidjcxrsuymudgba', '5md7bsji6pbijpxitu8bwezaqy', 1698321288318, NULL);
INSERT INTO public.channelmemberhistory VALUES ('wjcp9j9mjfbe3f8t3mp5544y1w', 'w7uyhzuo7fnfueen6og9cxmn9h', 1698321691905, NULL);
INSERT INTO public.channelmemberhistory VALUES ('g44m7cnnkjn6tbqsica1ste4jw', 'w7uyhzuo7fnfueen6og9cxmn9h', 1698321691933, NULL);


--
-- Data for Name: channelmembers; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.channelmembers VALUES ('g44m7cnnkjn6tbqsica1ste4jw', '5md7bsji6pbijpxitu8bwezaqy', '', 0, 0, 0, '{"push": "default", "email": "default", "desktop": "default", "mark_unread": "all", "ignore_channel_mentions": "default", "channel_auto_follow_threads": "off"}', 1698320784790, true, true, false, 0, 0, 0);
INSERT INTO public.channelmembers VALUES ('686m6w41q3bidjcxrsuymudgba', 'w7uyhzuo7fnfueen6og9cxmn9h', '', 0, 0, 0, '{"push": "default", "email": "default", "desktop": "default", "mark_unread": "all", "ignore_channel_mentions": "default", "channel_auto_follow_threads": "off"}', 1698321288298, true, false, false, 0, 0, 0);
INSERT INTO public.channelmembers VALUES ('686m6w41q3bidjcxrsuymudgba', '5md7bsji6pbijpxitu8bwezaqy', '', 1698321288325, 1, 0, '{"push": "default", "email": "default", "desktop": "default", "mark_unread": "all", "ignore_channel_mentions": "default", "channel_auto_follow_threads": "off"}', 1698321288325, true, false, false, 0, 1, 0);
INSERT INTO public.channelmembers VALUES ('wjcp9j9mjfbe3f8t3mp5544y1w', 'w7uyhzuo7fnfueen6og9cxmn9h', '', 0, 0, 0, '{"push": "default", "email": "default", "desktop": "default", "mark_unread": "all", "ignore_channel_mentions": "default", "channel_auto_follow_threads": "off"}', 1698321691897, true, false, false, 0, 0, 0);
INSERT INTO public.channelmembers VALUES ('g44m7cnnkjn6tbqsica1ste4jw', 'w7uyhzuo7fnfueen6og9cxmn9h', '', 0, 0, 1, '{"push": "default", "email": "default", "desktop": "default", "mark_unread": "all", "ignore_channel_mentions": "default", "channel_auto_follow_threads": "off"}', 1698321691953, true, false, false, 1, 0, 0);
INSERT INTO public.channelmembers VALUES ('wjcp9j9mjfbe3f8t3mp5544y1w', '5md7bsji6pbijpxitu8bwezaqy', '', 1698322063240, 1, 0, '{"push": "default", "email": "default", "desktop": "default", "mark_unread": "all", "ignore_channel_mentions": "default", "channel_auto_follow_threads": "off"}', 1698322063240, true, true, false, 0, 1, 0);


--
-- Data for Name: channels; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.channels VALUES ('686m6w41q3bidjcxrsuymudgba', 1698321288297, 1698321288297, 0, '', 'D', '', '5md7bsji6pbijpxitu8bwezaqy__w7uyhzuo7fnfueen6og9cxmn9h', '', '', 1698321288325, 1, 0, 'w7uyhzuo7fnfueen6og9cxmn9h', NULL, NULL, false, 1, 1698321288325);
INSERT INTO public.channels VALUES ('g44m7cnnkjn6tbqsica1ste4jw', 1698320784731, 1698320784731, 0, 'rkpuunm3rp8fffhzkjxw63usyc', 'O', 'Off-Topic', 'off-topic', '', '', 1698321691939, 0, 0, '', NULL, NULL, NULL, 0, 1698321691939);
INSERT INTO public.channels VALUES ('wjcp9j9mjfbe3f8t3mp5544y1w', 1698320784722, 1698320784722, 0, 'rkpuunm3rp8fffhzkjxw63usyc', 'O', 'Town Square', 'town-square', '', '', 1698322063240, 1, 0, '', NULL, NULL, NULL, 1, 1698322063240);


--
-- Data for Name: clusterdiscovery; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: commands; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.commands VALUES ('pkksc6zkt7g65q7jtwadpgs9rr', 'u7p1an973bd1jqg75i3y7pxj7y', 1698321530602, 1698321530602, 0, '5md7bsji6pbijpxitu8bwezaqy', 'rkpuunm3rp8fffhzkjxw63usyc', 'clear', 'P', '', '', false, '', '', 'Clear', 'Clear Slash Command', 'http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/', '');
INSERT INTO public.commands VALUES ('z3egwchjfb85zkstcdupcge8pc', 'ncygprhkt3rrxr4rkytcaa7c9c', 1698322016041, 1698322016041, 0, '5md7bsji6pbijpxitu8bwezaqy', 'rkpuunm3rp8fffhzkjxw63usyc', 'nautobot', 'P', '', '', false, '', '', 'Nautobot', 'Nautobot Slash Command', 'http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/', '');
INSERT INTO public.commands VALUES ('qfd8w7rpq7neuphzmo3miaw1jr', 'b9wrs7paz7fi5ragz9uurwd9fa', 1698322240892, 1698322240892, 0, '5md7bsji6pbijpxitu8bwezaqy', 'rkpuunm3rp8fffhzkjxw63usyc', 'aci', 'P', '', '', false, '', '', 'Cisco ACI', 'Cisco ACI Slash Command', 'http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/', '');
INSERT INTO public.commands VALUES ('ifttckqrjpyrxr7ks1w5qjm81c', '4hz941bgtpde9g75sesdp7tp1h', 1698322317986, 1698322317986, 0, '5md7bsji6pbijpxitu8bwezaqy', 'rkpuunm3rp8fffhzkjxw63usyc', 'ansible', 'P', '', '', false, '', '', 'Ansible', 'Ansible Slash Command', 'http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/', '');
INSERT INTO public.commands VALUES ('a4u4gwfa6tggtc6kziyryxsk3a', '71o3ku7jwjyxup6biu1way1h5y', 1698322371251, 1698322371251, 0, '5md7bsji6pbijpxitu8bwezaqy', 'rkpuunm3rp8fffhzkjxw63usyc', 'arista', 'P', '', '', false, '', '', 'Arista CloudVision', 'Arista CloudVision Slash Command', 'http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/', '');
INSERT INTO public.commands VALUES ('urmj87oqbbynir8nzc33by1f4c', '3wxwh3m8mjrzxr11psersqkwue', 1698322417418, 1698322417418, 0, '5md7bsji6pbijpxitu8bwezaqy', 'rkpuunm3rp8fffhzkjxw63usyc', 'grafana', 'P', '', '', false, '', '', 'Grafana', 'Grafana Slash Command', 'http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/', '');
INSERT INTO public.commands VALUES ('mw51fho6ojd3fxqmrgfkt9xykw', 'ppm316za33ritm3xgpobcmmgre', 1698322479271, 1698322479271, 0, '5md7bsji6pbijpxitu8bwezaqy', 'rkpuunm3rp8fffhzkjxw63usyc', 'ipfabric', 'P', '', '', false, '', '', 'IP Fabric', 'IP Fabric Slash Command', 'http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/', '');
INSERT INTO public.commands VALUES ('11cwjihduffn3ceybits6n5zty', '11ix54hycjr4dmxcgw4d77qc4w', 1698322532951, 1698322532951, 0, '5md7bsji6pbijpxitu8bwezaqy', 'rkpuunm3rp8fffhzkjxw63usyc', 'meraki', 'P', '', '', false, '', '', 'Cisco Meraki', 'Cisco Meraki Slash Command', 'http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/', '');
INSERT INTO public.commands VALUES ('p43ko8rim3r89d78yexbg3fiww', 'fh1kbk45xtgm8r48jzr39ru1ww', 1698322585580, 1698322585580, 0, '5md7bsji6pbijpxitu8bwezaqy', 'rkpuunm3rp8fffhzkjxw63usyc', 'panorama', 'P', '', '', false, '', '', 'Panorama', 'Panorama Slash Command', 'http://nautobot:8080/api/plugins/chatops/mattermost/slash_command/', '');


--
-- Data for Name: commandwebhooks; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: compliances; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: db_lock; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: db_migrations; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.db_migrations VALUES (1, 'create_teams');
INSERT INTO public.db_migrations VALUES (2, 'create_team_members');
INSERT INTO public.db_migrations VALUES (3, 'create_cluster_discovery');
INSERT INTO public.db_migrations VALUES (4, 'create_command_webhooks');
INSERT INTO public.db_migrations VALUES (5, 'create_compliances');
INSERT INTO public.db_migrations VALUES (6, 'create_emojis');
INSERT INTO public.db_migrations VALUES (7, 'create_user_groups');
INSERT INTO public.db_migrations VALUES (8, 'create_group_members');
INSERT INTO public.db_migrations VALUES (9, 'create_group_teams');
INSERT INTO public.db_migrations VALUES (10, 'create_group_channels');
INSERT INTO public.db_migrations VALUES (11, 'create_link_metadata');
INSERT INTO public.db_migrations VALUES (12, 'create_commands');
INSERT INTO public.db_migrations VALUES (13, 'create_incoming_webhooks');
INSERT INTO public.db_migrations VALUES (14, 'create_outgoing_webhooks');
INSERT INTO public.db_migrations VALUES (15, 'create_systems');
INSERT INTO public.db_migrations VALUES (16, 'create_reactions');
INSERT INTO public.db_migrations VALUES (17, 'create_roles');
INSERT INTO public.db_migrations VALUES (18, 'create_schemes');
INSERT INTO public.db_migrations VALUES (19, 'create_licenses');
INSERT INTO public.db_migrations VALUES (20, 'create_posts');
INSERT INTO public.db_migrations VALUES (21, 'create_product_notice_view_state');
INSERT INTO public.db_migrations VALUES (22, 'create_sessions');
INSERT INTO public.db_migrations VALUES (23, 'create_terms_of_service');
INSERT INTO public.db_migrations VALUES (24, 'create_audits');
INSERT INTO public.db_migrations VALUES (25, 'create_oauth_access_data');
INSERT INTO public.db_migrations VALUES (26, 'create_preferences');
INSERT INTO public.db_migrations VALUES (27, 'create_status');
INSERT INTO public.db_migrations VALUES (28, 'create_tokens');
INSERT INTO public.db_migrations VALUES (29, 'create_bots');
INSERT INTO public.db_migrations VALUES (30, 'create_user_access_tokens');
INSERT INTO public.db_migrations VALUES (31, 'create_remote_clusters');
INSERT INTO public.db_migrations VALUES (32, 'create_sharedchannels');
INSERT INTO public.db_migrations VALUES (33, 'create_sidebar_channels');
INSERT INTO public.db_migrations VALUES (34, 'create_oauthauthdata');
INSERT INTO public.db_migrations VALUES (35, 'create_sharedchannelattachments');
INSERT INTO public.db_migrations VALUES (36, 'create_sharedchannelusers');
INSERT INTO public.db_migrations VALUES (37, 'create_sharedchannelremotes');
INSERT INTO public.db_migrations VALUES (38, 'create_jobs');
INSERT INTO public.db_migrations VALUES (39, 'create_channel_member_history');
INSERT INTO public.db_migrations VALUES (40, 'create_sidebar_categories');
INSERT INTO public.db_migrations VALUES (41, 'create_upload_sessions');
INSERT INTO public.db_migrations VALUES (42, 'create_threads');
INSERT INTO public.db_migrations VALUES (43, 'thread_memberships');
INSERT INTO public.db_migrations VALUES (44, 'create_user_terms_of_service');
INSERT INTO public.db_migrations VALUES (45, 'create_plugin_key_value_store');
INSERT INTO public.db_migrations VALUES (46, 'create_users');
INSERT INTO public.db_migrations VALUES (47, 'create_file_info');
INSERT INTO public.db_migrations VALUES (48, 'create_oauth_apps');
INSERT INTO public.db_migrations VALUES (49, 'create_channels');
INSERT INTO public.db_migrations VALUES (50, 'create_channelmembers');
INSERT INTO public.db_migrations VALUES (51, 'create_msg_root_count');
INSERT INTO public.db_migrations VALUES (52, 'create_public_channels');
INSERT INTO public.db_migrations VALUES (53, 'create_retention_policies');
INSERT INTO public.db_migrations VALUES (54, 'create_crt_channelmembership_count');
INSERT INTO public.db_migrations VALUES (55, 'create_crt_thread_count_and_unreads');
INSERT INTO public.db_migrations VALUES (56, 'upgrade_channels_v6.0');
INSERT INTO public.db_migrations VALUES (57, 'upgrade_command_webhooks_v6.0');
INSERT INTO public.db_migrations VALUES (58, 'upgrade_channelmembers_v6.0');
INSERT INTO public.db_migrations VALUES (59, 'upgrade_users_v6.0');
INSERT INTO public.db_migrations VALUES (60, 'upgrade_jobs_v6.0');
INSERT INTO public.db_migrations VALUES (61, 'upgrade_link_metadata_v6.0');
INSERT INTO public.db_migrations VALUES (62, 'upgrade_sessions_v6.0');
INSERT INTO public.db_migrations VALUES (63, 'upgrade_threads_v6.0');
INSERT INTO public.db_migrations VALUES (64, 'upgrade_status_v6.0');
INSERT INTO public.db_migrations VALUES (65, 'upgrade_groupchannels_v6.0');
INSERT INTO public.db_migrations VALUES (66, 'upgrade_posts_v6.0');
INSERT INTO public.db_migrations VALUES (67, 'upgrade_channelmembers_v6.1');
INSERT INTO public.db_migrations VALUES (68, 'upgrade_teammembers_v6.1');
INSERT INTO public.db_migrations VALUES (69, 'upgrade_jobs_v6.1');
INSERT INTO public.db_migrations VALUES (70, 'upgrade_cte_v6.1');
INSERT INTO public.db_migrations VALUES (71, 'upgrade_sessions_v6.1');
INSERT INTO public.db_migrations VALUES (72, 'upgrade_schemes_v6.3');
INSERT INTO public.db_migrations VALUES (73, 'upgrade_plugin_key_value_store_v6.3');
INSERT INTO public.db_migrations VALUES (74, 'upgrade_users_v6.3');
INSERT INTO public.db_migrations VALUES (75, 'alter_upload_sessions_index');
INSERT INTO public.db_migrations VALUES (76, 'upgrade_lastrootpostat');
INSERT INTO public.db_migrations VALUES (77, 'upgrade_users_v6.5');
INSERT INTO public.db_migrations VALUES (78, 'create_oauth_mattermost_app_id');
INSERT INTO public.db_migrations VALUES (79, 'usergroups_displayname_index');
INSERT INTO public.db_migrations VALUES (80, 'posts_createat_id');
INSERT INTO public.db_migrations VALUES (81, 'threads_deleteat');
INSERT INTO public.db_migrations VALUES (82, 'upgrade_oauth_mattermost_app_id');
INSERT INTO public.db_migrations VALUES (83, 'threads_threaddeleteat');
INSERT INTO public.db_migrations VALUES (84, 'recent_searches');
INSERT INTO public.db_migrations VALUES (85, 'fileinfo_add_archived_column');
INSERT INTO public.db_migrations VALUES (86, 'add_cloud_limits_archived');
INSERT INTO public.db_migrations VALUES (87, 'sidebar_categories_index');
INSERT INTO public.db_migrations VALUES (88, 'remaining_migrations');
INSERT INTO public.db_migrations VALUES (89, 'add-channelid-to-reaction');
INSERT INTO public.db_migrations VALUES (90, 'create_enums');
INSERT INTO public.db_migrations VALUES (91, 'create_post_reminder');
INSERT INTO public.db_migrations VALUES (92, 'add_createat_to_teamembers');
INSERT INTO public.db_migrations VALUES (93, 'notify_admin');
INSERT INTO public.db_migrations VALUES (94, 'threads_teamid');
INSERT INTO public.db_migrations VALUES (95, 'remove_posts_parentid');
INSERT INTO public.db_migrations VALUES (96, 'threads_threadteamid');
INSERT INTO public.db_migrations VALUES (97, 'create_posts_priority');
INSERT INTO public.db_migrations VALUES (98, 'create_post_acknowledgements');
INSERT INTO public.db_migrations VALUES (99, 'create_drafts');
INSERT INTO public.db_migrations VALUES (100, 'add_draft_priority_column');
INSERT INTO public.db_migrations VALUES (101, 'create_true_up_review_history');
INSERT INTO public.db_migrations VALUES (102, 'posts_originalid_index');
INSERT INTO public.db_migrations VALUES (103, 'add_sentat_to_notifyadmin');
INSERT INTO public.db_migrations VALUES (104, 'upgrade_notifyadmin');
INSERT INTO public.db_migrations VALUES (105, 'remove_tokens');
INSERT INTO public.db_migrations VALUES (106, 'fileinfo_channelid');
INSERT INTO public.db_migrations VALUES (107, 'threadmemberships_cleanup');
INSERT INTO public.db_migrations VALUES (108, 'remove_orphaned_oauth_preferences');
INSERT INTO public.db_migrations VALUES (109, 'create_persistent_notifications');
INSERT INTO public.db_migrations VALUES (111, 'update_vacuuming');


--
-- Data for Name: drafts; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: emoji; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: fileinfo; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: groupchannels; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: groupmembers; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: groupteams; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: incomingwebhooks; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: ir_category; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: ir_category_item; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: ir_channelaction; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: ir_incident; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: ir_metric; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: ir_metricconfig; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: ir_playbook; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: ir_playbookautofollow; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: ir_playbookmember; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: ir_run_participants; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: ir_statusposts; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: ir_system; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.ir_system VALUES ('DatabaseVersion', '0.63.0');


--
-- Data for Name: ir_timelineevent; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: ir_userinfo; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.ir_userinfo VALUES ('5md7bsji6pbijpxitu8bwezaqy', 1698320802132, '{"disable_daily_digest":false,"disable_weekly_digest":false}');


--
-- Data for Name: ir_viewedchannel; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.jobs VALUES ('sq83iy4bgidn3gdf4745rkzcco', 'migrations', 0, 1698320643330, 1698320652909, 1698320653134, 'success', 0, '{"last_done": "{\"current_table\":\"ChannelMembers\",\"last_team_id\":\"00000000000000000000000000\",\"last_channel_id\":\"00000000000000000000000000\",\"last_user\":\"00000000000000000000000000\"}", "migration_key": "migration_advanced_permissions_phase_2"}');


--
-- Data for Name: licenses; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: linkmetadata; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: notifyadmin; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: oauthaccessdata; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: oauthapps; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: oauthauthdata; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: outgoingwebhooks; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: persistentnotifications; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: pluginkeyvaluestore; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.pluginkeyvaluestore VALUES ('com.mattermost.nps', 'ServerUpgrade-9.0.0', '\x7b227365727665725f76657273696f6e223a22392e302e30222c22757067726164655f6174223a22323032332d31302d32365431313a34333a30322e3735323732333133315a227d', 0);
INSERT INTO public.pluginkeyvaluestore VALUES ('com.mattermost.nps', 'WelcomeFeedbackMigration', '\x7b224372656174654174223a22323032332d31302d32365431313a34333a30322e3735323732333133315a227d', 0);
INSERT INTO public.pluginkeyvaluestore VALUES ('com.mattermost.nps', 'Survey-9.0.0', '\x7b227365727665725f76657273696f6e223a22392e302e30222c226372656174655f6174223a22323032332d31302d32365431313a34333a30322e3735323732333133315a222c2273746172745f6174223a22323032332d31322d31305431313a34333a30322e3735323732333133315a227d', 0);
INSERT INTO public.pluginkeyvaluestore VALUES ('com.mattermost.nps', 'LastAdminNotice', '\x22323032332d31302d32365431313a34333a30322e3735323732333133315a22', 0);
INSERT INTO public.pluginkeyvaluestore VALUES ('playbooks', 'mmi_botid', '\x6d7433667138316d726262796472656673733168397a66786877', 0);
INSERT INTO public.pluginkeyvaluestore VALUES ('com.mattermost.calls', 'mmi_botid', '\x71696366616e6a747a62677366387168387a6b6f736471393665', 0);


--
-- Data for Name: postacknowledgements; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: postreminders; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.posts VALUES ('tncer1pq7brn5gx3cp9pmoaqtw', 1698320784773, 1698320784773, 0, '5md7bsji6pbijpxitu8bwezaqy', 'wjcp9j9mjfbe3f8t3mp5544y1w', '', '', 'admin joined the team.', 'system_join_team', '{"username": "admin"}', '', '[]', '[]', false, 0, false, NULL);
INSERT INTO public.posts VALUES ('apr119z86fg1tbuub5x6u6pune', 1698320784805, 1698320784805, 0, '5md7bsji6pbijpxitu8bwezaqy', 'g44m7cnnkjn6tbqsica1ste4jw', '', '', 'admin joined the channel.', 'system_join_channel', '{"username": "admin"}', '', '[]', '[]', false, 0, false, NULL);
INSERT INTO public.posts VALUES ('33p1sunyyb8cmxbqwrxotgyuqe', 1698321288325, 1698321288325, 0, 'w7uyhzuo7fnfueen6og9cxmn9h', '686m6w41q3bidjcxrsuymudgba', '', '', 'Please add me to teams and channels you want me to interact in. To do this, use the browser or Mattermost Desktop App.', 'add_bot_teams_channels', '{"from_bot": "true"}', '', '[]', '[]', false, 0, false, NULL);
INSERT INTO public.posts VALUES ('okcnrhyu638furtk9x7s6z9dnc', 1698321691911, 1698321691911, 0, '5md7bsji6pbijpxitu8bwezaqy', 'wjcp9j9mjfbe3f8t3mp5544y1w', '', '', 'nautobot added to the team by admin.', 'system_add_to_team', '{"userId": "5md7bsji6pbijpxitu8bwezaqy", "username": "admin", "addedUserId": "w7uyhzuo7fnfueen6og9cxmn9h", "addedUsername": "nautobot"}', '', '[]', '[]', false, 0, false, NULL);
INSERT INTO public.posts VALUES ('tn88sqa4cbbnig5wu1hgj6rb7w', 1698321691939, 1698321691939, 0, '5md7bsji6pbijpxitu8bwezaqy', 'g44m7cnnkjn6tbqsica1ste4jw', '', '', 'nautobot added to the channel by admin.', 'system_add_to_channel', '{"userId": "5md7bsji6pbijpxitu8bwezaqy", "username": "admin", "addedUserId": "w7uyhzuo7fnfueen6og9cxmn9h", "addedUsername": "nautobot"}', '', '[]', '[]', false, 0, false, NULL);
INSERT INTO public.posts VALUES ('3e3uz4acwt8h3cxu4xs83zcyzc', 1698322063240, 1698322063240, 0, 'w7uyhzuo7fnfueen6og9cxmn9h', 'wjcp9j9mjfbe3f8t3mp5544y1w', '', '', '', '', '{"from_bot": "true", "attachments": [{"id": 0, "ts": null, "text": "More Chat commands can be found at [Nautobot Apps](https://www.networktocode.com/nautobot/apps/)", "color": "", "title": "", "fields": null, "footer": "", "pretext": "", "fallback": "", "image_url": "", "thumb_url": "", "title_link": "", "author_icon": "", "author_link": "", "author_name": "", "footer_icon": ""}]}', '', '[]', '[]', false, 0, false, NULL);


--
-- Data for Name: postspriority; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: preferences; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.preferences VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'tutorial_step', '5md7bsji6pbijpxitu8bwezaqy', '0');
INSERT INTO public.preferences VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'recommended_next_steps', 'hide', 'true');
INSERT INTO public.preferences VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'onboarding_task_list', 'onboarding_task_list_show', 'false');
INSERT INTO public.preferences VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'onboarding_task_list', 'onboarding_task_list_open', 'false');
INSERT INTO public.preferences VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'touched', 'add_channels_cta', 'true');
INSERT INTO public.preferences VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'channel_approximate_view_time', 'wjcp9j9mjfbe3f8t3mp5544y1w', '1698321177534');
INSERT INTO public.preferences VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'direct_channel_show', 'w7uyhzuo7fnfueen6og9cxmn9h', 'true');
INSERT INTO public.preferences VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'channel_open_time', '686m6w41q3bidjcxrsuymudgba', '1698321657708');
INSERT INTO public.preferences VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'drafts', 'drafts_tour_tip_showed', '{"drafts_tour_tip_showed":true}');


--
-- Data for Name: productnoticeviewstate; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.productnoticeviewstate VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'gfycat_deprecation_7.8', 1, 1698320750);
INSERT INTO public.productnoticeviewstate VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'gif_deprecation_7.9_7.10', 1, 1698320750);
INSERT INTO public.productnoticeviewstate VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'gfycat_deprecation_8.0', 1, 1698320750);
INSERT INTO public.productnoticeviewstate VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'gfycat_deprecation_8.1', 1, 1698320750);
INSERT INTO public.productnoticeviewstate VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'boards_deprecations', 1, 1698320750);
INSERT INTO public.productnoticeviewstate VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'boards_deprecations_user_2', 1, 1698320750);
INSERT INTO public.productnoticeviewstate VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'desktop_upgrade_v5.5', 1, 1698320750);
INSERT INTO public.productnoticeviewstate VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'server_upgrade_v9.1', 1, 1698320750);
INSERT INTO public.productnoticeviewstate VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'crt-admin-disabled', 1, 1698320750);
INSERT INTO public.productnoticeviewstate VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'crt-admin-default_off', 1, 1698320750);
INSERT INTO public.productnoticeviewstate VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'crt-user-default-on', 1, 1698320750);
INSERT INTO public.productnoticeviewstate VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'crt-user-always-on', 1, 1698320750);
INSERT INTO public.productnoticeviewstate VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'unsupported-server-v5.37', 1, 1698320750);


--
-- Data for Name: publicchannels; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.publicchannels VALUES ('wjcp9j9mjfbe3f8t3mp5544y1w', 0, 'rkpuunm3rp8fffhzkjxw63usyc', 'Town Square', 'town-square', '', '');
INSERT INTO public.publicchannels VALUES ('g44m7cnnkjn6tbqsica1ste4jw', 0, 'rkpuunm3rp8fffhzkjxw63usyc', 'Off-Topic', 'off-topic', '', '');


--
-- Data for Name: reactions; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: recentsearches; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: remoteclusters; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: retentionpolicies; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: retentionpolicieschannels; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: retentionpoliciesteams; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.roles VALUES ('9pr4dapegp8p5rrwf8xwyuwudw', 'team_admin', 'authentication.roles.team_admin.name', 'authentication.roles.team_admin.description', 1698320577304, 1698320582267, 0, ' convert_public_channel_to_private use_group_mentions delete_others_posts manage_slash_commands manage_private_channel_members manage_others_outgoing_webhooks use_channel_mentions create_post manage_team_roles manage_incoming_webhooks playbook_public_manage_roles add_reaction manage_public_channel_members remove_reaction playbook_private_manage_roles manage_others_slash_commands import_team delete_post remove_user_from_team convert_private_channel_to_public read_private_channel_groups manage_channel_roles manage_outgoing_webhooks read_public_channel_groups manage_others_incoming_webhooks manage_team', true, true);
INSERT INTO public.roles VALUES ('w6wassz9nfd6jfkfou79njg5kr', 'system_post_all_public', 'authentication.roles.system_post_all_public.name', 'authentication.roles.system_post_all_public.description', 1698320577261, 1698320582223, 0, ' create_post_public use_channel_mentions use_group_mentions', false, true);
INSERT INTO public.roles VALUES ('4tg91kitxbr45k11ia1rfp9dsw', 'system_user_access_token', 'authentication.roles.system_user_access_token.name', 'authentication.roles.system_user_access_token.description', 1698320577267, 1698320582229, 0, ' revoke_user_access_token create_user_access_token read_user_access_token', false, true);
INSERT INTO public.roles VALUES ('bqrqkffoqpgt3yru89wr8p3ihh', 'channel_user', 'authentication.roles.channel_user.name', 'authentication.roles.channel_user.description', 1698320577285, 1698320582248, 0, ' edit_post read_public_channel_groups delete_public_channel add_reaction read_private_channel_groups manage_public_channel_properties read_channel_content use_group_mentions delete_post upload_file use_channel_mentions manage_public_channel_members manage_private_channel_members read_channel remove_reaction create_post manage_private_channel_properties get_public_link delete_private_channel', true, true);
INSERT INTO public.roles VALUES ('eg9aoait5pgy5yd5upto6fr5bh', 'custom_group_user', 'authentication.roles.custom_group_user.name', 'authentication.roles.custom_group_user.description', 1698320577310, 1698320582273, 0, '', false, false);
INSERT INTO public.roles VALUES ('zorc97yr9igdp8dgifag5u64tw', 'team_user', 'authentication.roles.team_user.name', 'authentication.roles.team_user.description', 1698320577291, 1698320582254, 0, ' invite_user list_team_channels create_private_channel playbook_private_create playbook_public_create join_public_channels create_public_channel view_team read_public_channel add_user_to_team', true, true);
INSERT INTO public.roles VALUES ('mjokx7qp3jdd7eidqhsx4td6ec', 'playbook_member', 'authentication.roles.playbook_member.name', 'authentication.roles.playbook_member.description', 1698320577316, 1698320582279, 0, ' playbook_public_view playbook_public_manage_members playbook_public_manage_properties playbook_private_view playbook_private_manage_members playbook_private_manage_properties run_create', true, true);
INSERT INTO public.roles VALUES ('p8mkk11gqbfquxr45q4cknakya', 'channel_admin', 'authentication.roles.channel_admin.name', 'authentication.roles.channel_admin.description', 1698320577338, 1698320582291, 0, ' use_channel_mentions add_reaction use_group_mentions manage_channel_roles manage_private_channel_members create_post read_public_channel_groups remove_reaction manage_public_channel_members read_private_channel_groups', true, true);
INSERT INTO public.roles VALUES ('qe1epqnnwinz9m15dhdowkbaqh', 'team_guest', 'authentication.roles.team_guest.name', 'authentication.roles.team_guest.description', 1698320577344, 1698320582298, 0, ' view_team', true, true);
INSERT INTO public.roles VALUES ('dbtf1b6357n7db1h9raanwjzse', 'run_member', 'authentication.roles.run_member.name', 'authentication.roles.run_member.description', 1698320577350, 1698320582304, 0, ' run_view', true, true);
INSERT INTO public.roles VALUES ('oe6ongueziywtgmqo4d9c4igjo', 'team_post_all', 'authentication.roles.team_post_all.name', 'authentication.roles.team_post_all.description', 1698320577297, 1698320582261, 0, ' use_channel_mentions use_group_mentions create_post', false, true);
INSERT INTO public.roles VALUES ('aomdi3k85fr1bdnmmt5hcgzj7a', 'playbook_admin', 'authentication.roles.playbook_admin.name', 'authentication.roles.playbook_admin.description', 1698320577332, 1698320582285, 0, ' playbook_private_manage_members playbook_private_manage_roles playbook_private_manage_properties playbook_public_make_private playbook_public_manage_members playbook_public_manage_roles playbook_public_manage_properties', true, true);
INSERT INTO public.roles VALUES ('9t14j3hzmbndfbkpsoh9arngbr', 'system_guest', 'authentication.roles.global_guest.name', 'authentication.roles.global_guest.description', 1698320577356, 1698320582310, 0, ' create_direct_channel create_group_channel', true, true);
INSERT INTO public.roles VALUES ('9h3q73uhopdfmgu1yi88gc99do', 'system_post_all', 'authentication.roles.system_post_all.name', 'authentication.roles.system_post_all.description', 1698320577369, 1698320582316, 0, ' use_channel_mentions create_post use_group_mentions', false, true);
INSERT INTO public.roles VALUES ('6kfpmc99fjgotg88k6qkr853dr', 'system_admin', 'authentication.roles.global_admin.name', 'authentication.roles.global_admin.description', 1698320577322, 1698320582322, 0, ' manage_team sysconsole_read_environment_rate_limiting use_slash_commands sysconsole_read_site_notices remove_others_reactions test_s3 sysconsole_read_site_file_sharing_and_downloads sysconsole_write_site_posts create_group_channel manage_others_slash_commands sysconsole_read_user_management_permissions sysconsole_read_authentication_saml manage_team_roles promote_guest add_saml_public_cert create_post sysconsole_read_authentication_signup sysconsole_write_authentication_email create_post_bleve_indexes_job create_user_access_token playbook_public_manage_roles sysconsole_write_reporting_server_logs manage_system_wide_oauth sysconsole_read_user_management_users read_audits sysconsole_write_environment_push_notification_server manage_jobs list_public_teams get_saml_cert_status test_elasticsearch sysconsole_read_user_management_teams add_saml_idp_cert reload_config manage_roles sysconsole_write_experimental_features manage_shared_channels create_post_public sysconsole_write_site_announcement_banner sysconsole_read_site_announcement_banner sysconsole_write_compliance_data_retention_policy convert_public_channel_to_private list_private_teams playbook_private_manage_properties sysconsole_read_environment_image_proxy create_direct_channel create_elasticsearch_post_aggregation_job sysconsole_read_environment_session_lengths sysconsole_read_compliance_data_retention_policy test_ldap view_members recycle_database_connections edit_post sysconsole_write_user_management_teams playbook_private_manage_members create_private_channel sysconsole_read_site_emoji playbook_private_manage_roles manage_private_channel_properties read_jobs import_team read_other_users_teams sysconsole_write_integrations_integration_management read_private_channel_groups manage_public_channel_members sysconsole_read_integrations_gif sysconsole_write_user_management_system_roles remove_ldap_private_cert sysconsole_read_integrations_integration_management sysconsole_read_authentication_mfa use_group_mentions assign_system_admin_role sysconsole_write_authentication_saml sysconsole_read_environment_elasticsearch add_ldap_private_cert sysconsole_read_products_boards sysconsole_read_user_management_groups sysconsole_write_site_users_and_teams delete_post delete_custom_group remove_user_from_team read_bots sysconsole_write_environment_database playbook_private_make_public sysconsole_read_authentication_ldap join_public_teams playbook_public_manage_properties read_elasticsearch_post_aggregation_job read_others_bots edit_others_posts sysconsole_write_site_customization sysconsole_read_billing revoke_user_access_token playbook_private_view sysconsole_write_environment_developer sysconsole_write_compliance_compliance_export sysconsole_read_compliance_custom_terms_of_service manage_others_incoming_webhooks sysconsole_read_integrations_bot_accounts get_public_link sysconsole_write_site_public_links edit_other_users create_bot sysconsole_write_environment_image_proxy read_public_channel_groups sysconsole_read_environment_database sysconsole_read_reporting_site_statistics join_public_channels manage_bots create_post_ephemeral sysconsole_write_integrations_gif invalidate_email_invite sysconsole_read_authentication_openid delete_private_channel sysconsole_write_experimental_feature_flags add_ldap_public_cert run_manage_members sysconsole_read_experimental_feature_flags sysconsole_write_billing sysconsole_write_environment_high_availability sysconsole_write_environment_rate_limiting sysconsole_read_site_users_and_teams sysconsole_write_reporting_team_statistics manage_private_channel_members read_elasticsearch_post_indexing_job read_data_retention_job sysconsole_read_environment_developer invalidate_caches get_analytics create_compliance_export_job create_team invite_guest remove_saml_idp_cert manage_incoming_webhooks sysconsole_read_site_customization playbook_public_make_private run_view sysconsole_read_compliance_compliance_monitoring sysconsole_read_environment_push_notification_server manage_channel_roles assign_bot delete_emojis sysconsole_read_about_edition_and_license read_channel delete_public_channel sysconsole_read_site_public_links read_user_access_token playbook_public_view view_team sysconsole_write_environment_performance_monitoring add_saml_private_cert manage_outgoing_webhooks sysconsole_write_authentication_mfa sysconsole_read_environment_performance_monitoring run_create manage_slash_commands sysconsole_write_authentication_ldap create_emojis delete_others_posts manage_others_outgoing_webhooks upload_file sysconsole_write_site_emoji sysconsole_write_authentication_password playbook_private_create run_manage_properties sysconsole_read_experimental_features get_saml_metadata_from_idp sysconsole_write_environment_file_storage sysconsole_read_reporting_server_logs sysconsole_write_site_notifications sysconsole_read_experimental_bleve sysconsole_write_user_management_groups read_channel_content join_private_teams sysconsole_read_user_management_system_roles sysconsole_write_integrations_cors playbook_public_create sysconsole_read_site_notifications add_reaction sysconsole_write_integrations_bot_accounts sysconsole_write_about_edition_and_license sysconsole_read_site_localization remove_saml_private_cert read_deleted_posts sysconsole_read_user_management_channels manage_license_information playbook_public_manage_members sysconsole_write_site_file_sharing_and_downloads read_ldap_sync_job sysconsole_write_authentication_openid manage_custom_group_members sysconsole_read_environment_web_server add_user_to_team delete_others_emojis remove_reaction restore_custom_group edit_brand sysconsole_write_environment_logging manage_public_channel_properties sysconsole_read_compliance_compliance_export sysconsole_read_plugins invite_user sysconsole_read_environment_high_availability remove_ldap_public_cert sysconsole_write_authentication_signup sysconsole_read_environment_logging list_team_channels manage_others_bots sysconsole_write_user_management_channels create_ldap_sync_job read_compliance_export_job sysconsole_read_reporting_team_statistics list_users_without_team sysconsole_write_compliance_custom_terms_of_service read_public_channel sysconsole_read_environment_smtp sysconsole_write_environment_web_server manage_system sysconsole_read_authentication_guest_access sysconsole_read_site_posts sysconsole_write_user_management_users sysconsole_write_plugins test_email create_elasticsearch_post_indexing_job create_data_retention_job manage_oauth remove_saml_public_cert sysconsole_write_reporting_site_statistics sysconsole_write_environment_smtp demote_to_guest sysconsole_write_environment_session_lengths create_public_channel sysconsole_write_products_boards download_compliance_export_result sysconsole_write_site_notices manage_secure_connections read_license_information sysconsole_write_user_management_permissions sysconsole_read_integrations_cors use_channel_mentions purge_bleve_indexes sysconsole_write_environment_elasticsearch sysconsole_write_authentication_guest_access test_site_url sysconsole_read_authentication_password sysconsole_write_compliance_compliance_monitoring sysconsole_read_environment_file_storage edit_custom_group create_custom_group sysconsole_write_site_localization get_logs purge_elasticsearch_indexes convert_private_channel_to_public sysconsole_read_authentication_email sysconsole_write_experimental_bleve', true, true);
INSERT INTO public.roles VALUES ('rmjt5xak738gmcx5afckhkr47r', 'team_post_all_public', 'authentication.roles.team_post_all_public.name', 'authentication.roles.team_post_all_public.description', 1698320577243, 1698320582211, 0, ' use_channel_mentions create_post_public use_group_mentions', false, true);
INSERT INTO public.roles VALUES ('b9ef3k1qefgkmxhkpi4rsp9q8h', 'run_admin', 'authentication.roles.run_admin.name', 'authentication.roles.run_admin.description', 1698320577249, 1698320582217, 0, ' run_manage_members run_manage_properties', true, true);
INSERT INTO public.roles VALUES ('afhpw8yxipymzn7694us6pj43o', 'system_read_only_admin', 'authentication.roles.system_read_only_admin.name', 'authentication.roles.system_read_only_admin.description', 1698320577273, 1698320582236, 0, ' sysconsole_read_environment_logging list_private_teams sysconsole_read_about_edition_and_license sysconsole_read_authentication_password read_private_channel_groups sysconsole_read_environment_web_server sysconsole_read_environment_session_lengths sysconsole_read_environment_push_notification_server read_elasticsearch_post_aggregation_job sysconsole_read_environment_performance_monitoring sysconsole_read_compliance_data_retention_policy sysconsole_read_integrations_gif read_data_retention_job sysconsole_read_reporting_site_statistics sysconsole_read_environment_high_availability sysconsole_read_site_emoji sysconsole_read_experimental_feature_flags sysconsole_read_site_localization view_team download_compliance_export_result sysconsole_read_reporting_team_statistics test_ldap read_elasticsearch_post_indexing_job sysconsole_read_user_management_users sysconsole_read_authentication_ldap read_public_channel sysconsole_read_plugins read_compliance_export_job sysconsole_read_environment_smtp read_license_information sysconsole_read_site_file_sharing_and_downloads sysconsole_read_integrations_integration_management list_public_teams sysconsole_read_reporting_server_logs sysconsole_read_site_public_links sysconsole_read_user_management_channels sysconsole_read_site_announcement_banner sysconsole_read_authentication_mfa read_other_users_teams sysconsole_read_user_management_permissions sysconsole_read_authentication_guest_access sysconsole_read_integrations_cors sysconsole_read_site_users_and_teams sysconsole_read_user_management_groups sysconsole_read_site_posts sysconsole_read_user_management_teams sysconsole_read_compliance_compliance_export sysconsole_read_site_notices sysconsole_read_authentication_signup sysconsole_read_authentication_email read_ldap_sync_job sysconsole_read_environment_file_storage get_analytics sysconsole_read_environment_elasticsearch sysconsole_read_experimental_bleve sysconsole_read_environment_database sysconsole_read_products_boards sysconsole_read_environment_image_proxy sysconsole_read_site_notifications sysconsole_read_site_customization read_public_channel_groups sysconsole_read_compliance_custom_terms_of_service read_channel sysconsole_read_experimental_features sysconsole_read_environment_developer sysconsole_read_authentication_saml sysconsole_read_integrations_bot_accounts read_audits sysconsole_read_authentication_openid get_logs sysconsole_read_compliance_compliance_monitoring sysconsole_read_environment_rate_limiting', false, true);
INSERT INTO public.roles VALUES ('rdgehgkxwidixmkboktwgd5m5e', 'channel_guest', 'authentication.roles.channel_guest.name', 'authentication.roles.channel_guest.description', 1698320577381, 1698320582335, 0, ' add_reaction remove_reaction upload_file edit_post create_post use_channel_mentions read_channel read_channel_content', true, true);
INSERT INTO public.roles VALUES ('k6f5zc76mjbuucmb1t3bedkano', 'system_custom_group_admin', 'authentication.roles.system_custom_group_admin.name', 'authentication.roles.system_custom_group_admin.description', 1698320577387, 1698320582341, 0, ' delete_custom_group restore_custom_group manage_custom_group_members create_custom_group edit_custom_group', false, true);
INSERT INTO public.roles VALUES ('hfzk9bc7gf8wp8af8b3gtncb6c', 'system_user', 'authentication.roles.global_user.name', 'authentication.roles.global_user.description', 1698320577363, 1698320582347, 0, ' delete_emojis create_team restore_custom_group create_custom_group create_emojis delete_custom_group create_direct_channel view_members list_public_teams edit_custom_group join_public_teams manage_custom_group_members create_group_channel', true, true);
INSERT INTO public.roles VALUES ('fe3n8qmbrb8hupsnsayok1x5by', 'system_manager', 'authentication.roles.system_manager.name', 'authentication.roles.system_manager.description', 1698320577279, 1698320582242, 0, ' sysconsole_write_site_emoji sysconsole_write_environment_session_lengths read_license_information sysconsole_write_site_file_sharing_and_downloads sysconsole_read_plugins sysconsole_write_user_management_permissions read_public_channel_groups sysconsole_write_integrations_cors sysconsole_read_environment_file_storage test_elasticsearch create_elasticsearch_post_indexing_job test_site_url read_public_channel read_elasticsearch_post_aggregation_job sysconsole_read_authentication_mfa sysconsole_read_environment_smtp sysconsole_read_site_announcement_banner sysconsole_write_user_management_teams read_ldap_sync_job sysconsole_read_user_management_teams sysconsole_read_environment_high_availability sysconsole_write_environment_high_availability sysconsole_write_products_boards sysconsole_read_authentication_openid sysconsole_write_environment_web_server reload_config sysconsole_write_site_public_links sysconsole_read_site_customization remove_user_from_team add_user_to_team sysconsole_write_integrations_gif sysconsole_read_environment_developer sysconsole_write_site_localization get_logs sysconsole_read_integrations_integration_management sysconsole_read_environment_web_server sysconsole_read_authentication_ldap sysconsole_read_user_management_permissions sysconsole_read_environment_push_notification_server recycle_database_connections test_s3 purge_elasticsearch_indexes manage_team_roles edit_brand delete_public_channel join_public_teams sysconsole_read_authentication_password manage_private_channel_members sysconsole_read_environment_database list_public_teams manage_public_channel_properties sysconsole_write_site_notices sysconsole_read_site_notices sysconsole_read_site_posts sysconsole_write_environment_push_notification_server sysconsole_read_environment_session_lengths sysconsole_read_site_localization sysconsole_write_site_announcement_banner sysconsole_read_products_boards sysconsole_write_site_customization sysconsole_write_site_users_and_teams sysconsole_write_user_management_channels read_elasticsearch_post_indexing_job sysconsole_read_environment_elasticsearch invalidate_caches sysconsole_read_integrations_gif sysconsole_write_user_management_groups get_analytics sysconsole_write_site_posts read_channel sysconsole_read_site_notifications sysconsole_read_site_file_sharing_and_downloads sysconsole_read_reporting_site_statistics sysconsole_write_environment_file_storage manage_private_channel_properties sysconsole_read_environment_image_proxy sysconsole_write_environment_logging join_private_teams sysconsole_read_site_users_and_teams sysconsole_read_authentication_signup sysconsole_write_environment_image_proxy sysconsole_write_environment_database delete_private_channel sysconsole_write_environment_performance_monitoring read_private_channel_groups sysconsole_read_authentication_saml sysconsole_read_user_management_groups sysconsole_read_site_public_links sysconsole_read_reporting_team_statistics sysconsole_read_integrations_bot_accounts sysconsole_write_environment_elasticsearch sysconsole_read_authentication_guest_access list_private_teams sysconsole_write_environment_rate_limiting sysconsole_read_user_management_channels sysconsole_read_environment_rate_limiting create_elasticsearch_post_aggregation_job view_team sysconsole_read_integrations_cors sysconsole_write_environment_developer convert_public_channel_to_private manage_team manage_channel_roles sysconsole_read_reporting_server_logs sysconsole_write_site_notifications test_ldap sysconsole_read_about_edition_and_license sysconsole_read_authentication_email sysconsole_write_integrations_bot_accounts convert_private_channel_to_public sysconsole_read_site_emoji manage_public_channel_members sysconsole_write_integrations_integration_management sysconsole_read_environment_performance_monitoring sysconsole_write_environment_smtp sysconsole_read_environment_logging test_email', false, true);
INSERT INTO public.roles VALUES ('fr37w1fkii87bnt9f8j1y1wdzw', 'system_user_manager', 'authentication.roles.system_user_manager.name', 'authentication.roles.system_user_manager.description', 1698320577375, 1698320582328, 0, ' manage_public_channel_properties test_ldap manage_team_roles read_public_channel manage_private_channel_properties sysconsole_read_authentication_guest_access sysconsole_read_authentication_email list_private_teams join_private_teams add_user_to_team sysconsole_write_user_management_teams read_ldap_sync_job sysconsole_read_authentication_signup sysconsole_read_authentication_ldap sysconsole_read_user_management_permissions join_public_teams convert_private_channel_to_public sysconsole_write_user_management_channels sysconsole_write_user_management_groups read_private_channel_groups sysconsole_read_user_management_teams sysconsole_read_authentication_saml list_public_teams read_channel sysconsole_read_authentication_openid sysconsole_read_user_management_channels manage_team delete_private_channel view_team manage_private_channel_members sysconsole_read_user_management_groups remove_user_from_team manage_public_channel_members read_public_channel_groups convert_public_channel_to_private sysconsole_read_authentication_password delete_public_channel manage_channel_roles sysconsole_read_authentication_mfa', false, true);


--
-- Data for Name: schemes; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.sessions VALUES ('ugcm3rkgaig7tntdiwka6bp79r', 'ji7mf5m9dfnyjmu4gcnwt31xne', 1698320583554, 0, 1698320583554, 'qicfanjtzbgsf8qh8zkosdq96e', '', '', false, '{}', false);
INSERT INTO public.sessions VALUES ('tccpu59ortge9bdfunua675bcy', 'nsutx44ibbd69r5hjjmd3hx4sw', 1698321933089, 4851921933089, 1698321933089, 'w7uyhzuo7fnfueen6og9cxmn9h', '', 'system_user system_admin', false, '{"type": "UserAccessToken", "is_bot": "true", "is_guest": "false", "user_access_token_id": "7xnejgyhj7nxtmq6t95iah7n7c"}', false);
INSERT INTO public.sessions VALUES ('xprkr99nfirmb8j4pdfzqhhtar', 'gocaadsyk3bo5qwqf9tks47wko', 1698320751063, 1700912751063, 1698322855604, '5md7bsji6pbijpxitu8bwezaqy', '', 'system_admin system_user', false, '{"os": "Linux", "csrf": "wzkjmmqeaifz3qaa6dz57m614w", "isSaml": "false", "browser": "Chrome/118.0", "isMobile": "false", "is_guest": "false", "platform": "Linux", "isOAuthUser": "false"}', false);
INSERT INTO public.sessions VALUES ('bbs5ngiidbrticjza5sfs679ac', 'gsxpu5po9fnxmncgcbgkgcfo7a', 1698324524225, 0, 1698324524225, 'qicfanjtzbgsf8qh8zkosdq96e', '', '', false, '{}', false);


--
-- Data for Name: sharedchannelattachments; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: sharedchannelremotes; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: sharedchannels; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: sharedchannelusers; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: sidebarcategories; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.sidebarcategories VALUES ('favorites_5md7bsji6pbijpxitu8bwezaqy_rkpuunm3rp8fffhzkjxw63usyc', '5md7bsji6pbijpxitu8bwezaqy', 'rkpuunm3rp8fffhzkjxw63usyc', 0, '', 'favorites', 'Favorites', false, false);
INSERT INTO public.sidebarcategories VALUES ('channels_5md7bsji6pbijpxitu8bwezaqy_rkpuunm3rp8fffhzkjxw63usyc', '5md7bsji6pbijpxitu8bwezaqy', 'rkpuunm3rp8fffhzkjxw63usyc', 10, '', 'channels', 'Channels', false, false);
INSERT INTO public.sidebarcategories VALUES ('direct_messages_5md7bsji6pbijpxitu8bwezaqy_rkpuunm3rp8fffhzkjxw63usyc', '5md7bsji6pbijpxitu8bwezaqy', 'rkpuunm3rp8fffhzkjxw63usyc', 20, 'recent', 'direct_messages', 'Direct Messages', false, false);
INSERT INTO public.sidebarcategories VALUES ('favorites_w7uyhzuo7fnfueen6og9cxmn9h_rkpuunm3rp8fffhzkjxw63usyc', 'w7uyhzuo7fnfueen6og9cxmn9h', 'rkpuunm3rp8fffhzkjxw63usyc', 0, '', 'favorites', 'Favorites', false, false);
INSERT INTO public.sidebarcategories VALUES ('channels_w7uyhzuo7fnfueen6og9cxmn9h_rkpuunm3rp8fffhzkjxw63usyc', 'w7uyhzuo7fnfueen6og9cxmn9h', 'rkpuunm3rp8fffhzkjxw63usyc', 10, '', 'channels', 'Channels', false, false);
INSERT INTO public.sidebarcategories VALUES ('direct_messages_w7uyhzuo7fnfueen6og9cxmn9h_rkpuunm3rp8fffhzkjxw63usyc', 'w7uyhzuo7fnfueen6og9cxmn9h', 'rkpuunm3rp8fffhzkjxw63usyc', 20, 'recent', 'direct_messages', 'Direct Messages', false, false);


--
-- Data for Name: sidebarchannels; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.status VALUES ('w7uyhzuo7fnfueen6og9cxmn9h', 'offline', false, 1698322063254, 0, '');
INSERT INTO public.status VALUES ('5md7bsji6pbijpxitu8bwezaqy', 'offline', false, 1698323059687, 0, '');


--
-- Data for Name: systems; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.systems VALUES ('CRTChannelMembershipCountsMigrationComplete', 'true');
INSERT INTO public.systems VALUES ('CRTThreadCountsAndUnreadsMigrationComplete', 'true');
INSERT INTO public.systems VALUES ('AsymmetricSigningKey', '{"ecdsa_key":{"curve":"P-256","x":93265069825403552412139318495871668021796740157055378512852007170438861396546,"y":59624988667333768029494324774170511219568387297490421502531189241744540499512,"d":109950753027899581247934453758674695621655017250419947179614439678360020797909}}');
INSERT INTO public.systems VALUES ('DiagnosticId', 'x5xrikiotffufxawscso75zwue');
INSERT INTO public.systems VALUES ('LastSecurityTime', '1698320577245');
INSERT INTO public.systems VALUES ('FirstServerRunTimestamp', '1698320577245');
INSERT INTO public.systems VALUES ('AdvancedPermissionsMigrationComplete', 'true');
INSERT INTO public.systems VALUES ('EmojisPermissionsMigrationComplete', 'true');
INSERT INTO public.systems VALUES ('GuestRolesCreationMigrationComplete', 'true');
INSERT INTO public.systems VALUES ('SystemConsoleRolesCreationMigrationComplete', 'true');
INSERT INTO public.systems VALUES ('CustomGroupAdminRoleCreationMigrationComplete', 'true');
INSERT INTO public.systems VALUES ('emoji_permissions_split', 'true');
INSERT INTO public.systems VALUES ('webhook_permissions_split', 'true');
INSERT INTO public.systems VALUES ('list_join_public_private_teams', 'true');
INSERT INTO public.systems VALUES ('remove_permanent_delete_user', 'true');
INSERT INTO public.systems VALUES ('add_bot_permissions', 'true');
INSERT INTO public.systems VALUES ('apply_channel_manage_delete_to_channel_user', 'true');
INSERT INTO public.systems VALUES ('remove_channel_manage_delete_from_team_user', 'true');
INSERT INTO public.systems VALUES ('view_members_new_permission', 'true');
INSERT INTO public.systems VALUES ('add_manage_guests_permissions', 'true');
INSERT INTO public.systems VALUES ('channel_moderations_permissions', 'true');
INSERT INTO public.systems VALUES ('add_use_group_mentions_permission', 'true');
INSERT INTO public.systems VALUES ('add_system_console_permissions', 'true');
INSERT INTO public.systems VALUES ('add_convert_channel_permissions', 'true');
INSERT INTO public.systems VALUES ('manage_shared_channel_permissions', 'true');
INSERT INTO public.systems VALUES ('manage_secure_connections_permissions', 'true');
INSERT INTO public.systems VALUES ('add_system_roles_permissions', 'true');
INSERT INTO public.systems VALUES ('add_billing_permissions', 'true');
INSERT INTO public.systems VALUES ('download_compliance_export_results', 'true');
INSERT INTO public.systems VALUES ('experimental_subsection_permissions', 'true');
INSERT INTO public.systems VALUES ('authentication_subsection_permissions', 'true');
INSERT INTO public.systems VALUES ('integrations_subsection_permissions', 'true');
INSERT INTO public.systems VALUES ('site_subsection_permissions', 'true');
INSERT INTO public.systems VALUES ('compliance_subsection_permissions', 'true');
INSERT INTO public.systems VALUES ('environment_subsection_permissions', 'true');
INSERT INTO public.systems VALUES ('about_subsection_permissions', 'true');
INSERT INTO public.systems VALUES ('reporting_subsection_permissions', 'true');
INSERT INTO public.systems VALUES ('test_email_ancillary_permission', 'true');
INSERT INTO public.systems VALUES ('playbooks_permissions', 'true');
INSERT INTO public.systems VALUES ('custom_groups_permissions', 'true');
INSERT INTO public.systems VALUES ('playbooks_manage_roles', 'true');
INSERT INTO public.systems VALUES ('products_boards', 'true');
INSERT INTO public.systems VALUES ('custom_groups_permission_restore', 'true');
INSERT INTO public.systems VALUES ('read_channel_content_permissions', 'true');
INSERT INTO public.systems VALUES ('ContentExtractionConfigDefaultTrueMigrationComplete', 'true');
INSERT INTO public.systems VALUES ('PlaybookRolesCreationMigrationComplete', 'true');
INSERT INTO public.systems VALUES ('RemainingSchemaMigrations', 'true');
INSERT INTO public.systems VALUES ('PostPriorityConfigDefaultTrueMigrationComplete', 'true');
INSERT INTO public.systems VALUES ('PostActionCookieSecret', '{"key":"ixkFbhBo6vjg/slqcncUU4xI8QjzAUk62i5NrW5mShQ="}');
INSERT INTO public.systems VALUES ('InstallationDate', '1698320582714');
INSERT INTO public.systems VALUES ('migration_advanced_permissions_phase_2', 'true');
INSERT INTO public.systems VALUES ('OrganizationName', 'Network To Code LLC');
INSERT INTO public.systems VALUES ('FirstAdminSetupComplete', 'true');


--
-- Data for Name: teammembers; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.teammembers VALUES ('rkpuunm3rp8fffhzkjxw63usyc', '5md7bsji6pbijpxitu8bwezaqy', '', 0, true, true, false, 1698320784737);
INSERT INTO public.teammembers VALUES ('rkpuunm3rp8fffhzkjxw63usyc', 'w7uyhzuo7fnfueen6og9cxmn9h', '', 0, true, false, false, 1698321691864);


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.teams VALUES ('rkpuunm3rp8fffhzkjxw63usyc', 1698320784707, 1698320784707, 0, 'Network To Code LLC', 'network-to-code-llc', '', 'admin@example.com', 'O', '', '', '68tc1nu46i8yif7w13qmndumih', '', false, 0, false, false);


--
-- Data for Name: termsofservice; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: threadmemberships; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: threads; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: trueupreviewhistory; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: uploadsessions; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: useraccesstokens; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.useraccesstokens VALUES ('7xnejgyhj7nxtmq6t95iah7n7c', 'nsutx44ibbd69r5hjjmd3hx4sw', 'w7uyhzuo7fnfueen6og9cxmn9h', 'Default Token', true);


--
-- Data for Name: usergroups; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: mmuser
--

INSERT INTO public.users VALUES ('jmcgoiar5brr9nx8s7g3394c8e', 1698320582714, 1698320582739, 0, 'feedbackbot', '', NULL, '', 'feedbackbot@localhost', false, '', 'Feedbackbot', '', 'system_user', false, '{}', '{"push": "mention", "email": "true", "channel": "true", "desktop": "mention", "comments": "never", "first_name": "false", "push_status": "away", "mention_keys": "", "push_threads": "all", "desktop_sound": "true", "email_threads": "all", "desktop_threads": "all"}', 1698320582714, 1698320582739, 0, 'en', false, '', '', '{"manualTimezone": "", "automaticTimezone": "", "useAutomaticTimezone": "true"}', NULL);
INSERT INTO public.users VALUES ('qicfanjtzbgsf8qh8zkosdq96e', 1698320583519, 1698320583519, 0, 'calls', '', NULL, '', 'calls@localhost', false, '', 'Calls', '', 'system_user', false, '{}', '{"push": "mention", "email": "true", "channel": "true", "desktop": "mention", "comments": "never", "first_name": "false", "push_status": "away", "mention_keys": "", "push_threads": "all", "desktop_sound": "true", "email_threads": "all", "desktop_threads": "all"}', 1698320583519, 0, 0, 'en', false, '', '', '{"manualTimezone": "", "automaticTimezone": "", "useAutomaticTimezone": "true"}', NULL);
INSERT INTO public.users VALUES ('5md7bsji6pbijpxitu8bwezaqy', 1698320750878, 1698320784745, 0, 'admin', '$2a$10$fXSIHTK.8qvMjMZV0dNbH.0ialIcCVDywEog0BpF.NgXIrO4muYIS', NULL, '', 'admin@example.com', false, '', '', '', 'system_admin system_user', false, '{}', '{"push": "mention", "email": "true", "channel": "true", "desktop": "mention", "comments": "never", "first_name": "false", "push_status": "away", "mention_keys": "", "push_threads": "all", "desktop_sound": "true", "email_threads": "all", "desktop_threads": "all"}', 1698320750878, 0, 0, 'en', false, '', '', '{"manualTimezone": "", "automaticTimezone": "", "useAutomaticTimezone": "true"}', NULL);
INSERT INTO public.users VALUES ('dnyqmp4u5tgetr9or6in55xobr', 1698321000002, 1698321000002, 0, 'system-bot', '', NULL, '', 'system-bot@localhost', false, '', 'System', '', 'system_user', false, '{}', '{"push": "mention", "email": "true", "channel": "true", "desktop": "mention", "comments": "never", "first_name": "false", "push_status": "away", "mention_keys": "", "push_threads": "all", "desktop_sound": "true", "email_threads": "all", "desktop_threads": "all"}', 1698321000002, 0, 0, 'en', false, '', '', '{"manualTimezone": "", "automaticTimezone": "", "useAutomaticTimezone": "true"}', NULL);
INSERT INTO public.users VALUES ('w7uyhzuo7fnfueen6og9cxmn9h', 1698321288273, 1698321691881, 0, 'nautobot', '', NULL, '', 'nautobot@localhost', false, '', 'Nautobot', '', 'system_user system_admin', false, '{}', '{"push": "mention", "email": "true", "channel": "true", "desktop": "mention", "comments": "never", "first_name": "false", "push_status": "away", "mention_keys": "", "push_threads": "all", "desktop_sound": "true", "email_threads": "all", "desktop_threads": "all"}', 1698321288273, -1698321288413, 0, 'en', false, '', '', '{"manualTimezone": "", "automaticTimezone": "", "useAutomaticTimezone": "true"}', NULL);
INSERT INTO public.users VALUES ('mt3fq81mrbbydrefss1h9zfxhw', 1698320583260, 1698324524015, 0, 'playbooks', '', NULL, '', 'playbooks@localhost', false, '', 'Playbooks', '', 'system_user', false, '{}', '{"push": "mention", "email": "true", "channel": "true", "desktop": "mention", "comments": "never", "first_name": "false", "push_status": "away", "mention_keys": "", "push_threads": "all", "desktop_sound": "true", "email_threads": "all", "desktop_threads": "all"}', 1698320583260, 1698324524015, 0, 'en', false, '', '', '{"manualTimezone": "", "automaticTimezone": "", "useAutomaticTimezone": "true"}', NULL);


--
-- Data for Name: usertermsofservice; Type: TABLE DATA; Schema: public; Owner: mmuser
--



--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- Name: bots bots_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.bots
    ADD CONSTRAINT bots_pkey PRIMARY KEY (userid);


--
-- Name: channelmemberhistory channelmemberhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.channelmemberhistory
    ADD CONSTRAINT channelmemberhistory_pkey PRIMARY KEY (channelid, userid, jointime);


--
-- Name: channelmembers channelmembers_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.channelmembers
    ADD CONSTRAINT channelmembers_pkey PRIMARY KEY (channelid, userid);


--
-- Name: channels channels_name_teamid_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT channels_name_teamid_key UNIQUE (name, teamid);


--
-- Name: channels channels_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);


--
-- Name: clusterdiscovery clusterdiscovery_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.clusterdiscovery
    ADD CONSTRAINT clusterdiscovery_pkey PRIMARY KEY (id);


--
-- Name: commands commands_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.commands
    ADD CONSTRAINT commands_pkey PRIMARY KEY (id);


--
-- Name: commandwebhooks commandwebhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.commandwebhooks
    ADD CONSTRAINT commandwebhooks_pkey PRIMARY KEY (id);


--
-- Name: compliances compliances_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.compliances
    ADD CONSTRAINT compliances_pkey PRIMARY KEY (id);


--
-- Name: db_lock db_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.db_lock
    ADD CONSTRAINT db_lock_pkey PRIMARY KEY (id);


--
-- Name: db_migrations db_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.db_migrations
    ADD CONSTRAINT db_migrations_pkey PRIMARY KEY (version);


--
-- Name: drafts drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.drafts
    ADD CONSTRAINT drafts_pkey PRIMARY KEY (userid, channelid, rootid);


--
-- Name: emoji emoji_name_deleteat_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.emoji
    ADD CONSTRAINT emoji_name_deleteat_key UNIQUE (name, deleteat);


--
-- Name: emoji emoji_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.emoji
    ADD CONSTRAINT emoji_pkey PRIMARY KEY (id);


--
-- Name: fileinfo fileinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.fileinfo
    ADD CONSTRAINT fileinfo_pkey PRIMARY KEY (id);


--
-- Name: groupchannels groupchannels_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.groupchannels
    ADD CONSTRAINT groupchannels_pkey PRIMARY KEY (groupid, channelid);


--
-- Name: groupmembers groupmembers_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.groupmembers
    ADD CONSTRAINT groupmembers_pkey PRIMARY KEY (groupid, userid);


--
-- Name: groupteams groupteams_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.groupteams
    ADD CONSTRAINT groupteams_pkey PRIMARY KEY (groupid, teamid);


--
-- Name: incomingwebhooks incomingwebhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.incomingwebhooks
    ADD CONSTRAINT incomingwebhooks_pkey PRIMARY KEY (id);


--
-- Name: ir_category_item ir_category_item_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_category_item
    ADD CONSTRAINT ir_category_item_pkey PRIMARY KEY (categoryid, itemid, type);


--
-- Name: ir_category ir_category_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_category
    ADD CONSTRAINT ir_category_pkey PRIMARY KEY (id);


--
-- Name: ir_channelaction ir_channelaction_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_channelaction
    ADD CONSTRAINT ir_channelaction_pkey PRIMARY KEY (id);


--
-- Name: ir_incident ir_incident_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_incident
    ADD CONSTRAINT ir_incident_pkey PRIMARY KEY (id);


--
-- Name: ir_metric ir_metric_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_metric
    ADD CONSTRAINT ir_metric_pkey PRIMARY KEY (incidentid, metricconfigid);


--
-- Name: ir_metricconfig ir_metricconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_metricconfig
    ADD CONSTRAINT ir_metricconfig_pkey PRIMARY KEY (id);


--
-- Name: ir_playbook ir_playbook_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_playbook
    ADD CONSTRAINT ir_playbook_pkey PRIMARY KEY (id);


--
-- Name: ir_playbookautofollow ir_playbookautofollow_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_playbookautofollow
    ADD CONSTRAINT ir_playbookautofollow_pkey PRIMARY KEY (playbookid, userid);


--
-- Name: ir_playbookmember ir_playbookmember_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_playbookmember
    ADD CONSTRAINT ir_playbookmember_pkey PRIMARY KEY (memberid, playbookid);


--
-- Name: ir_playbookmember ir_playbookmember_playbookid_memberid_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_playbookmember
    ADD CONSTRAINT ir_playbookmember_playbookid_memberid_key UNIQUE (playbookid, memberid);


--
-- Name: ir_run_participants ir_run_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_run_participants
    ADD CONSTRAINT ir_run_participants_pkey PRIMARY KEY (incidentid, userid);


--
-- Name: ir_statusposts ir_statusposts_incidentid_postid_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_statusposts
    ADD CONSTRAINT ir_statusposts_incidentid_postid_key UNIQUE (incidentid, postid);


--
-- Name: ir_statusposts ir_statusposts_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_statusposts
    ADD CONSTRAINT ir_statusposts_pkey PRIMARY KEY (incidentid, postid);


--
-- Name: ir_system ir_system_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_system
    ADD CONSTRAINT ir_system_pkey PRIMARY KEY (skey);


--
-- Name: ir_timelineevent ir_timelineevent_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_timelineevent
    ADD CONSTRAINT ir_timelineevent_pkey PRIMARY KEY (id);


--
-- Name: ir_userinfo ir_userinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_userinfo
    ADD CONSTRAINT ir_userinfo_pkey PRIMARY KEY (id);


--
-- Name: ir_viewedchannel ir_viewedchannel_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_viewedchannel
    ADD CONSTRAINT ir_viewedchannel_pkey PRIMARY KEY (channelid, userid);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: licenses licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.licenses
    ADD CONSTRAINT licenses_pkey PRIMARY KEY (id);


--
-- Name: linkmetadata linkmetadata_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.linkmetadata
    ADD CONSTRAINT linkmetadata_pkey PRIMARY KEY (hash);


--
-- Name: notifyadmin notifyadmin_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.notifyadmin
    ADD CONSTRAINT notifyadmin_pkey PRIMARY KEY (userid, requiredfeature, requiredplan);


--
-- Name: oauthaccessdata oauthaccessdata_clientid_userid_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.oauthaccessdata
    ADD CONSTRAINT oauthaccessdata_clientid_userid_key UNIQUE (clientid, userid);


--
-- Name: oauthaccessdata oauthaccessdata_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.oauthaccessdata
    ADD CONSTRAINT oauthaccessdata_pkey PRIMARY KEY (token);


--
-- Name: oauthapps oauthapps_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.oauthapps
    ADD CONSTRAINT oauthapps_pkey PRIMARY KEY (id);


--
-- Name: oauthauthdata oauthauthdata_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.oauthauthdata
    ADD CONSTRAINT oauthauthdata_pkey PRIMARY KEY (code);


--
-- Name: outgoingwebhooks outgoingwebhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.outgoingwebhooks
    ADD CONSTRAINT outgoingwebhooks_pkey PRIMARY KEY (id);


--
-- Name: persistentnotifications persistentnotifications_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.persistentnotifications
    ADD CONSTRAINT persistentnotifications_pkey PRIMARY KEY (postid);


--
-- Name: pluginkeyvaluestore pluginkeyvaluestore_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.pluginkeyvaluestore
    ADD CONSTRAINT pluginkeyvaluestore_pkey PRIMARY KEY (pluginid, pkey);


--
-- Name: postacknowledgements postacknowledgements_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.postacknowledgements
    ADD CONSTRAINT postacknowledgements_pkey PRIMARY KEY (postid, userid);


--
-- Name: postreminders postreminders_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.postreminders
    ADD CONSTRAINT postreminders_pkey PRIMARY KEY (postid, userid);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: postspriority postspriority_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.postspriority
    ADD CONSTRAINT postspriority_pkey PRIMARY KEY (postid);


--
-- Name: preferences preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.preferences
    ADD CONSTRAINT preferences_pkey PRIMARY KEY (userid, category, name);


--
-- Name: productnoticeviewstate productnoticeviewstate_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.productnoticeviewstate
    ADD CONSTRAINT productnoticeviewstate_pkey PRIMARY KEY (userid, noticeid);


--
-- Name: publicchannels publicchannels_name_teamid_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.publicchannels
    ADD CONSTRAINT publicchannels_name_teamid_key UNIQUE (name, teamid);


--
-- Name: publicchannels publicchannels_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.publicchannels
    ADD CONSTRAINT publicchannels_pkey PRIMARY KEY (id);


--
-- Name: reactions reactions_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.reactions
    ADD CONSTRAINT reactions_pkey PRIMARY KEY (postid, userid, emojiname);


--
-- Name: recentsearches recentsearches_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.recentsearches
    ADD CONSTRAINT recentsearches_pkey PRIMARY KEY (userid, searchpointer);


--
-- Name: remoteclusters remoteclusters_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.remoteclusters
    ADD CONSTRAINT remoteclusters_pkey PRIMARY KEY (remoteid, name);


--
-- Name: retentionpolicies retentionpolicies_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.retentionpolicies
    ADD CONSTRAINT retentionpolicies_pkey PRIMARY KEY (id);


--
-- Name: retentionpolicieschannels retentionpolicieschannels_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.retentionpolicieschannels
    ADD CONSTRAINT retentionpolicieschannels_pkey PRIMARY KEY (channelid);


--
-- Name: retentionpoliciesteams retentionpoliciesteams_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.retentionpoliciesteams
    ADD CONSTRAINT retentionpoliciesteams_pkey PRIMARY KEY (teamid);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schemes schemes_name_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.schemes
    ADD CONSTRAINT schemes_name_key UNIQUE (name);


--
-- Name: schemes schemes_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.schemes
    ADD CONSTRAINT schemes_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sharedchannelattachments sharedchannelattachments_fileid_remoteid_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.sharedchannelattachments
    ADD CONSTRAINT sharedchannelattachments_fileid_remoteid_key UNIQUE (fileid, remoteid);


--
-- Name: sharedchannelattachments sharedchannelattachments_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.sharedchannelattachments
    ADD CONSTRAINT sharedchannelattachments_pkey PRIMARY KEY (id);


--
-- Name: sharedchannelremotes sharedchannelremotes_channelid_remoteid_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.sharedchannelremotes
    ADD CONSTRAINT sharedchannelremotes_channelid_remoteid_key UNIQUE (channelid, remoteid);


--
-- Name: sharedchannelremotes sharedchannelremotes_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.sharedchannelremotes
    ADD CONSTRAINT sharedchannelremotes_pkey PRIMARY KEY (id, channelid);


--
-- Name: sharedchannels sharedchannels_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.sharedchannels
    ADD CONSTRAINT sharedchannels_pkey PRIMARY KEY (channelid);


--
-- Name: sharedchannels sharedchannels_sharename_teamid_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.sharedchannels
    ADD CONSTRAINT sharedchannels_sharename_teamid_key UNIQUE (sharename, teamid);


--
-- Name: sharedchannelusers sharedchannelusers_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.sharedchannelusers
    ADD CONSTRAINT sharedchannelusers_pkey PRIMARY KEY (id);


--
-- Name: sharedchannelusers sharedchannelusers_userid_channelid_remoteid_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.sharedchannelusers
    ADD CONSTRAINT sharedchannelusers_userid_channelid_remoteid_key UNIQUE (userid, channelid, remoteid);


--
-- Name: sidebarcategories sidebarcategories_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.sidebarcategories
    ADD CONSTRAINT sidebarcategories_pkey PRIMARY KEY (id);


--
-- Name: sidebarchannels sidebarchannels_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.sidebarchannels
    ADD CONSTRAINT sidebarchannels_pkey PRIMARY KEY (channelid, userid, categoryid);


--
-- Name: status status_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (userid);


--
-- Name: systems systems_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.systems
    ADD CONSTRAINT systems_pkey PRIMARY KEY (name);


--
-- Name: teammembers teammembers_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.teammembers
    ADD CONSTRAINT teammembers_pkey PRIMARY KEY (teamid, userid);


--
-- Name: teams teams_name_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_name_key UNIQUE (name);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: termsofservice termsofservice_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.termsofservice
    ADD CONSTRAINT termsofservice_pkey PRIMARY KEY (id);


--
-- Name: threadmemberships threadmemberships_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.threadmemberships
    ADD CONSTRAINT threadmemberships_pkey PRIMARY KEY (postid, userid);


--
-- Name: threads threads_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.threads
    ADD CONSTRAINT threads_pkey PRIMARY KEY (postid);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (token);


--
-- Name: trueupreviewhistory trueupreviewhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.trueupreviewhistory
    ADD CONSTRAINT trueupreviewhistory_pkey PRIMARY KEY (duedate);


--
-- Name: uploadsessions uploadsessions_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.uploadsessions
    ADD CONSTRAINT uploadsessions_pkey PRIMARY KEY (id);


--
-- Name: useraccesstokens useraccesstokens_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.useraccesstokens
    ADD CONSTRAINT useraccesstokens_pkey PRIMARY KEY (id);


--
-- Name: useraccesstokens useraccesstokens_token_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.useraccesstokens
    ADD CONSTRAINT useraccesstokens_token_key UNIQUE (token);


--
-- Name: usergroups usergroups_name_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_name_key UNIQUE (name);


--
-- Name: usergroups usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_pkey PRIMARY KEY (id);


--
-- Name: usergroups usergroups_source_remoteid_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_source_remoteid_key UNIQUE (source, remoteid);


--
-- Name: users users_authdata_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_authdata_key UNIQUE (authdata);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: usertermsofservice usertermsofservice_pkey; Type: CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.usertermsofservice
    ADD CONSTRAINT usertermsofservice_pkey PRIMARY KEY (userid);


--
-- Name: idx_audits_user_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_audits_user_id ON public.audits USING btree (userid);


--
-- Name: idx_channel_search_txt; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_channel_search_txt ON public.channels USING gin (to_tsvector('english'::regconfig, (((((name)::text || ' '::text) || (displayname)::text) || ' '::text) || (purpose)::text)));


--
-- Name: idx_channelmembers_channel_id_scheme_guest_user_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_channelmembers_channel_id_scheme_guest_user_id ON public.channelmembers USING btree (channelid, schemeguest, userid);


--
-- Name: idx_channelmembers_user_id_channel_id_last_viewed_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_channelmembers_user_id_channel_id_last_viewed_at ON public.channelmembers USING btree (userid, channelid, lastviewedat);


--
-- Name: idx_channels_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_channels_create_at ON public.channels USING btree (createat);


--
-- Name: idx_channels_delete_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_channels_delete_at ON public.channels USING btree (deleteat);


--
-- Name: idx_channels_displayname_lower; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_channels_displayname_lower ON public.channels USING btree (lower((displayname)::text));


--
-- Name: idx_channels_name_lower; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_channels_name_lower ON public.channels USING btree (lower((name)::text));


--
-- Name: idx_channels_scheme_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_channels_scheme_id ON public.channels USING btree (schemeid);


--
-- Name: idx_channels_team_id_display_name; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_channels_team_id_display_name ON public.channels USING btree (teamid, displayname);


--
-- Name: idx_channels_team_id_type; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_channels_team_id_type ON public.channels USING btree (teamid, type);


--
-- Name: idx_channels_update_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_channels_update_at ON public.channels USING btree (updateat);


--
-- Name: idx_command_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_command_create_at ON public.commands USING btree (createat);


--
-- Name: idx_command_delete_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_command_delete_at ON public.commands USING btree (deleteat);


--
-- Name: idx_command_team_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_command_team_id ON public.commands USING btree (teamid);


--
-- Name: idx_command_update_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_command_update_at ON public.commands USING btree (updateat);


--
-- Name: idx_command_webhook_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_command_webhook_create_at ON public.commandwebhooks USING btree (createat);


--
-- Name: idx_emoji_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_emoji_create_at ON public.emoji USING btree (createat);


--
-- Name: idx_emoji_delete_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_emoji_delete_at ON public.emoji USING btree (deleteat);


--
-- Name: idx_emoji_update_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_emoji_update_at ON public.emoji USING btree (updateat);


--
-- Name: idx_fileinfo_channel_id_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_fileinfo_channel_id_create_at ON public.fileinfo USING btree (channelid, createat);


--
-- Name: idx_fileinfo_content_txt; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_fileinfo_content_txt ON public.fileinfo USING gin (to_tsvector('english'::regconfig, content));


--
-- Name: idx_fileinfo_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_fileinfo_create_at ON public.fileinfo USING btree (createat);


--
-- Name: idx_fileinfo_delete_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_fileinfo_delete_at ON public.fileinfo USING btree (deleteat);


--
-- Name: idx_fileinfo_extension_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_fileinfo_extension_at ON public.fileinfo USING btree (extension);


--
-- Name: idx_fileinfo_name_splitted; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_fileinfo_name_splitted ON public.fileinfo USING gin (to_tsvector('english'::regconfig, translate((name)::text, '.,-'::text, '   '::text)));


--
-- Name: idx_fileinfo_name_txt; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_fileinfo_name_txt ON public.fileinfo USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: idx_fileinfo_postid_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_fileinfo_postid_at ON public.fileinfo USING btree (postid);


--
-- Name: idx_fileinfo_update_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_fileinfo_update_at ON public.fileinfo USING btree (updateat);


--
-- Name: idx_groupchannels_channelid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_groupchannels_channelid ON public.groupchannels USING btree (channelid);


--
-- Name: idx_groupchannels_schemeadmin; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_groupchannels_schemeadmin ON public.groupchannels USING btree (schemeadmin);


--
-- Name: idx_groupmembers_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_groupmembers_create_at ON public.groupmembers USING btree (createat);


--
-- Name: idx_groupteams_schemeadmin; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_groupteams_schemeadmin ON public.groupteams USING btree (schemeadmin);


--
-- Name: idx_groupteams_teamid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_groupteams_teamid ON public.groupteams USING btree (teamid);


--
-- Name: idx_incoming_webhook_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_incoming_webhook_create_at ON public.incomingwebhooks USING btree (createat);


--
-- Name: idx_incoming_webhook_delete_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_incoming_webhook_delete_at ON public.incomingwebhooks USING btree (deleteat);


--
-- Name: idx_incoming_webhook_team_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_incoming_webhook_team_id ON public.incomingwebhooks USING btree (teamid);


--
-- Name: idx_incoming_webhook_update_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_incoming_webhook_update_at ON public.incomingwebhooks USING btree (updateat);


--
-- Name: idx_incoming_webhook_user_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_incoming_webhook_user_id ON public.incomingwebhooks USING btree (userid);


--
-- Name: idx_jobs_status_type; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_jobs_status_type ON public.jobs USING btree (status, type);


--
-- Name: idx_jobs_type; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_jobs_type ON public.jobs USING btree (type);


--
-- Name: idx_link_metadata_url_timestamp; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_link_metadata_url_timestamp ON public.linkmetadata USING btree (url, "timestamp");


--
-- Name: idx_notice_views_notice_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_notice_views_notice_id ON public.productnoticeviewstate USING btree (noticeid);


--
-- Name: idx_notice_views_timestamp; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_notice_views_timestamp ON public.productnoticeviewstate USING btree ("timestamp");


--
-- Name: idx_oauthaccessdata_refresh_token; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_oauthaccessdata_refresh_token ON public.oauthaccessdata USING btree (refreshtoken);


--
-- Name: idx_oauthaccessdata_user_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_oauthaccessdata_user_id ON public.oauthaccessdata USING btree (userid);


--
-- Name: idx_oauthapps_creator_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_oauthapps_creator_id ON public.oauthapps USING btree (creatorid);


--
-- Name: idx_outgoing_webhook_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_outgoing_webhook_create_at ON public.outgoingwebhooks USING btree (createat);


--
-- Name: idx_outgoing_webhook_delete_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_outgoing_webhook_delete_at ON public.outgoingwebhooks USING btree (deleteat);


--
-- Name: idx_outgoing_webhook_team_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_outgoing_webhook_team_id ON public.outgoingwebhooks USING btree (teamid);


--
-- Name: idx_outgoing_webhook_update_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_outgoing_webhook_update_at ON public.outgoingwebhooks USING btree (updateat);


--
-- Name: idx_postreminders_targettime; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_postreminders_targettime ON public.postreminders USING btree (targettime);


--
-- Name: idx_posts_channel_id_delete_at_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_posts_channel_id_delete_at_create_at ON public.posts USING btree (channelid, deleteat, createat);


--
-- Name: idx_posts_channel_id_update_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_posts_channel_id_update_at ON public.posts USING btree (channelid, updateat);


--
-- Name: idx_posts_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_posts_create_at ON public.posts USING btree (createat);


--
-- Name: idx_posts_create_at_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_posts_create_at_id ON public.posts USING btree (createat, id);


--
-- Name: idx_posts_delete_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_posts_delete_at ON public.posts USING btree (deleteat);


--
-- Name: idx_posts_hashtags_txt; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_posts_hashtags_txt ON public.posts USING gin (to_tsvector('english'::regconfig, (hashtags)::text));


--
-- Name: idx_posts_is_pinned; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_posts_is_pinned ON public.posts USING btree (ispinned);


--
-- Name: idx_posts_message_txt; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_posts_message_txt ON public.posts USING gin (to_tsvector('english'::regconfig, (message)::text));


--
-- Name: idx_posts_original_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_posts_original_id ON public.posts USING btree (originalid);


--
-- Name: idx_posts_root_id_delete_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_posts_root_id_delete_at ON public.posts USING btree (rootid, deleteat);


--
-- Name: idx_posts_update_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_posts_update_at ON public.posts USING btree (updateat);


--
-- Name: idx_posts_user_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_posts_user_id ON public.posts USING btree (userid);


--
-- Name: idx_preferences_category; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_preferences_category ON public.preferences USING btree (category);


--
-- Name: idx_preferences_name; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_preferences_name ON public.preferences USING btree (name);


--
-- Name: idx_publicchannels_delete_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_publicchannels_delete_at ON public.publicchannels USING btree (deleteat);


--
-- Name: idx_publicchannels_displayname_lower; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_publicchannels_displayname_lower ON public.publicchannels USING btree (lower((displayname)::text));


--
-- Name: idx_publicchannels_name_lower; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_publicchannels_name_lower ON public.publicchannels USING btree (lower((name)::text));


--
-- Name: idx_publicchannels_search_txt; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_publicchannels_search_txt ON public.publicchannels USING gin (to_tsvector('english'::regconfig, (((((name)::text || ' '::text) || (displayname)::text) || ' '::text) || (purpose)::text)));


--
-- Name: idx_publicchannels_team_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_publicchannels_team_id ON public.publicchannels USING btree (teamid);


--
-- Name: idx_reactions_channel_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_reactions_channel_id ON public.reactions USING btree (channelid);


--
-- Name: idx_retentionpolicies_displayname; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_retentionpolicies_displayname ON public.retentionpolicies USING btree (displayname);


--
-- Name: idx_retentionpolicieschannels_policyid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_retentionpolicieschannels_policyid ON public.retentionpolicieschannels USING btree (policyid);


--
-- Name: idx_retentionpoliciesteams_policyid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_retentionpoliciesteams_policyid ON public.retentionpoliciesteams USING btree (policyid);


--
-- Name: idx_schemes_channel_admin_role; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_schemes_channel_admin_role ON public.schemes USING btree (defaultchanneladminrole);


--
-- Name: idx_schemes_channel_guest_role; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_schemes_channel_guest_role ON public.schemes USING btree (defaultchannelguestrole);


--
-- Name: idx_schemes_channel_user_role; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_schemes_channel_user_role ON public.schemes USING btree (defaultchanneluserrole);


--
-- Name: idx_sessions_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_sessions_create_at ON public.sessions USING btree (createat);


--
-- Name: idx_sessions_expires_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_sessions_expires_at ON public.sessions USING btree (expiresat);


--
-- Name: idx_sessions_last_activity_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_sessions_last_activity_at ON public.sessions USING btree (lastactivityat);


--
-- Name: idx_sessions_token; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_sessions_token ON public.sessions USING btree (token);


--
-- Name: idx_sessions_user_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_sessions_user_id ON public.sessions USING btree (userid);


--
-- Name: idx_sharedchannelusers_remote_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_sharedchannelusers_remote_id ON public.sharedchannelusers USING btree (remoteid);


--
-- Name: idx_sidebarcategories_userid_teamid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_sidebarcategories_userid_teamid ON public.sidebarcategories USING btree (userid, teamid);


--
-- Name: idx_status_status_dndendtime; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_status_status_dndendtime ON public.status USING btree (status, dndendtime);


--
-- Name: idx_teammembers_createat; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_teammembers_createat ON public.teammembers USING btree (createat);


--
-- Name: idx_teammembers_delete_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_teammembers_delete_at ON public.teammembers USING btree (deleteat);


--
-- Name: idx_teammembers_user_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_teammembers_user_id ON public.teammembers USING btree (userid);


--
-- Name: idx_teams_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_teams_create_at ON public.teams USING btree (createat);


--
-- Name: idx_teams_delete_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_teams_delete_at ON public.teams USING btree (deleteat);


--
-- Name: idx_teams_invite_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_teams_invite_id ON public.teams USING btree (inviteid);


--
-- Name: idx_teams_scheme_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_teams_scheme_id ON public.teams USING btree (schemeid);


--
-- Name: idx_teams_update_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_teams_update_at ON public.teams USING btree (updateat);


--
-- Name: idx_thread_memberships_last_update_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_thread_memberships_last_update_at ON public.threadmemberships USING btree (lastupdated);


--
-- Name: idx_thread_memberships_last_view_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_thread_memberships_last_view_at ON public.threadmemberships USING btree (lastviewed);


--
-- Name: idx_thread_memberships_user_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_thread_memberships_user_id ON public.threadmemberships USING btree (userid);


--
-- Name: idx_threads_channel_id_last_reply_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_threads_channel_id_last_reply_at ON public.threads USING btree (channelid, lastreplyat);


--
-- Name: idx_uploadsessions_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_uploadsessions_create_at ON public.uploadsessions USING btree (createat);


--
-- Name: idx_uploadsessions_type; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_uploadsessions_type ON public.uploadsessions USING btree (type);


--
-- Name: idx_uploadsessions_user_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_uploadsessions_user_id ON public.uploadsessions USING btree (userid);


--
-- Name: idx_user_access_tokens_user_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_user_access_tokens_user_id ON public.useraccesstokens USING btree (userid);


--
-- Name: idx_usergroups_delete_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_usergroups_delete_at ON public.usergroups USING btree (deleteat);


--
-- Name: idx_usergroups_displayname; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_usergroups_displayname ON public.usergroups USING btree (displayname);


--
-- Name: idx_usergroups_remote_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_usergroups_remote_id ON public.usergroups USING btree (remoteid);


--
-- Name: idx_users_all_no_full_name_txt; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_users_all_no_full_name_txt ON public.users USING gin (to_tsvector('english'::regconfig, (((((username)::text || ' '::text) || (nickname)::text) || ' '::text) || (email)::text)));


--
-- Name: idx_users_all_txt; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_users_all_txt ON public.users USING gin (to_tsvector('english'::regconfig, (((((((((username)::text || ' '::text) || (firstname)::text) || ' '::text) || (lastname)::text) || ' '::text) || (nickname)::text) || ' '::text) || (email)::text)));


--
-- Name: idx_users_create_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_users_create_at ON public.users USING btree (createat);


--
-- Name: idx_users_delete_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_users_delete_at ON public.users USING btree (deleteat);


--
-- Name: idx_users_email_lower_textpattern; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_users_email_lower_textpattern ON public.users USING btree (lower((email)::text) text_pattern_ops);


--
-- Name: idx_users_firstname_lower_textpattern; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_users_firstname_lower_textpattern ON public.users USING btree (lower((firstname)::text) text_pattern_ops);


--
-- Name: idx_users_lastname_lower_textpattern; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_users_lastname_lower_textpattern ON public.users USING btree (lower((lastname)::text) text_pattern_ops);


--
-- Name: idx_users_names_no_full_name_txt; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_users_names_no_full_name_txt ON public.users USING gin (to_tsvector('english'::regconfig, (((username)::text || ' '::text) || (nickname)::text)));


--
-- Name: idx_users_names_txt; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_users_names_txt ON public.users USING gin (to_tsvector('english'::regconfig, (((((((username)::text || ' '::text) || (firstname)::text) || ' '::text) || (lastname)::text) || ' '::text) || (nickname)::text)));


--
-- Name: idx_users_nickname_lower_textpattern; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_users_nickname_lower_textpattern ON public.users USING btree (lower((nickname)::text) text_pattern_ops);


--
-- Name: idx_users_update_at; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_users_update_at ON public.users USING btree (updateat);


--
-- Name: idx_users_username_lower_textpattern; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX idx_users_username_lower_textpattern ON public.users USING btree (lower((username)::text) text_pattern_ops);


--
-- Name: ir_category_item_categoryid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_category_item_categoryid ON public.ir_category_item USING btree (categoryid);


--
-- Name: ir_category_teamid_userid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_category_teamid_userid ON public.ir_category USING btree (teamid, userid);


--
-- Name: ir_channelaction_channelid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_channelaction_channelid ON public.ir_channelaction USING btree (channelid);


--
-- Name: ir_incident_channelid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_incident_channelid ON public.ir_incident USING btree (channelid);


--
-- Name: ir_incident_teamid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_incident_teamid ON public.ir_incident USING btree (teamid);


--
-- Name: ir_incident_teamid_commanderuserid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_incident_teamid_commanderuserid ON public.ir_incident USING btree (teamid, commanderuserid);


--
-- Name: ir_metric_incidentid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_metric_incidentid ON public.ir_metric USING btree (incidentid);


--
-- Name: ir_metric_metricconfigid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_metric_metricconfigid ON public.ir_metric USING btree (metricconfigid);


--
-- Name: ir_metricconfig_playbookid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_metricconfig_playbookid ON public.ir_metricconfig USING btree (playbookid);


--
-- Name: ir_playbook_teamid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_playbook_teamid ON public.ir_playbook USING btree (teamid);


--
-- Name: ir_playbook_updateat; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_playbook_updateat ON public.ir_playbook USING btree (updateat);


--
-- Name: ir_playbookmember_memberid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_playbookmember_memberid ON public.ir_playbookmember USING btree (memberid);


--
-- Name: ir_playbookmember_playbookid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_playbookmember_playbookid ON public.ir_playbookmember USING btree (playbookid);


--
-- Name: ir_run_participants_incidentid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_run_participants_incidentid ON public.ir_run_participants USING btree (incidentid);


--
-- Name: ir_run_participants_userid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_run_participants_userid ON public.ir_run_participants USING btree (userid);


--
-- Name: ir_statusposts_incidentid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_statusposts_incidentid ON public.ir_statusposts USING btree (incidentid);


--
-- Name: ir_statusposts_postid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_statusposts_postid ON public.ir_statusposts USING btree (postid);


--
-- Name: ir_timelineevent_id; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_timelineevent_id ON public.ir_timelineevent USING btree (id);


--
-- Name: ir_timelineevent_incidentid; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE INDEX ir_timelineevent_incidentid ON public.ir_timelineevent USING btree (incidentid);


--
-- Name: remote_clusters_site_url_unique; Type: INDEX; Schema: public; Owner: mmuser
--

CREATE UNIQUE INDEX remote_clusters_site_url_unique ON public.remoteclusters USING btree (siteurl, remoteteamid);


--
-- Name: retentionpolicieschannels fk_retentionpolicieschannels_retentionpolicies; Type: FK CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.retentionpolicieschannels
    ADD CONSTRAINT fk_retentionpolicieschannels_retentionpolicies FOREIGN KEY (policyid) REFERENCES public.retentionpolicies(id) ON DELETE CASCADE;


--
-- Name: retentionpoliciesteams fk_retentionpoliciesteams_retentionpolicies; Type: FK CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.retentionpoliciesteams
    ADD CONSTRAINT fk_retentionpoliciesteams_retentionpolicies FOREIGN KEY (policyid) REFERENCES public.retentionpolicies(id) ON DELETE CASCADE;


--
-- Name: ir_category_item ir_category_item_categoryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_category_item
    ADD CONSTRAINT ir_category_item_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.ir_category(id);


--
-- Name: ir_metric ir_metric_incidentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_metric
    ADD CONSTRAINT ir_metric_incidentid_fkey FOREIGN KEY (incidentid) REFERENCES public.ir_incident(id);


--
-- Name: ir_metric ir_metric_metricconfigid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_metric
    ADD CONSTRAINT ir_metric_metricconfigid_fkey FOREIGN KEY (metricconfigid) REFERENCES public.ir_metricconfig(id);


--
-- Name: ir_metricconfig ir_metricconfig_playbookid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_metricconfig
    ADD CONSTRAINT ir_metricconfig_playbookid_fkey FOREIGN KEY (playbookid) REFERENCES public.ir_playbook(id);


--
-- Name: ir_playbookautofollow ir_playbookautofollow_playbookid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_playbookautofollow
    ADD CONSTRAINT ir_playbookautofollow_playbookid_fkey FOREIGN KEY (playbookid) REFERENCES public.ir_playbook(id);


--
-- Name: ir_playbookmember ir_playbookmember_playbookid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_playbookmember
    ADD CONSTRAINT ir_playbookmember_playbookid_fkey FOREIGN KEY (playbookid) REFERENCES public.ir_playbook(id);


--
-- Name: ir_run_participants ir_run_participants_incidentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_run_participants
    ADD CONSTRAINT ir_run_participants_incidentid_fkey FOREIGN KEY (incidentid) REFERENCES public.ir_incident(id);


--
-- Name: ir_statusposts ir_statusposts_incidentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_statusposts
    ADD CONSTRAINT ir_statusposts_incidentid_fkey FOREIGN KEY (incidentid) REFERENCES public.ir_incident(id);


--
-- Name: ir_timelineevent ir_timelineevent_incidentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mmuser
--

ALTER TABLE ONLY public.ir_timelineevent
    ADD CONSTRAINT ir_timelineevent_incidentid_fkey FOREIGN KEY (incidentid) REFERENCES public.ir_incident(id);


--
-- PostgreSQL database dump complete
--


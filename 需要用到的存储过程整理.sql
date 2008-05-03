drop TABLE [dbo].[t_administrators]
drop TABLE [dbo].[t_topinfo] 
drop TABLE [dbo].[t_toplist] 
drop TABLE [dbo].[t_line] 
drop TABLE [dbo].[t_tflog] 
drop TABLE [dbo].[tflog] 
drop TABLE [dbo].[t_aimenu] 
drop TABLE [dbo].[XltVosLog] 
drop TABLE [dbo].[t_sms_queue]
drop PROCEDURE [dbo].mnu_getType
drop PROCEDURE [dbo].mnu_getString
drop PROCEDURE [dbo].mnu_getKeyList
drop PROCEDURE [dbo].xlt_init  
drop PROCEDURE [dbo].[TranTflog] 
drop PROCEDURE [dbo].tf_log   
drop PROCEDURE [dbo].[VosLog]  
drop PROCEDURE [dbo].ln_use  
drop PROCEDURE [dbo].ln_on  
drop PROCEDURE [dbo].ln_timeout_check
drop PROCEDURE [dbo].ln_off  
drop PROCEDURE [dbo].ln_off_all  
drop PROCEDURE [dbo].ln_init  
drop PROCEDURE [dbo].ln_getfree  
drop PROCEDURE [dbo].[ActCreateTflog] 
drop PROCEDURE [dbo].[getTopInfo]
drop PROCEDURE [dbo].[getTopInfoVoc]
drop PROCEDURE [dbo].[getTopList]
drop PROCEDURE [dbo].addSmsSendRequest

CREATE TABLE [dbo].[t_sms_queue] (
	[idx] [int] IDENTITY (1, 1) NOT NULL ,
	[caller] [char] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[top_id] [int] NOT NULL ,
	[top_name] [char] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[sp_id] [int] NULL ,
	[sp_name] [char] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[sp_pid] [int] NULL ,
	[sp_pname] [char] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[state] [int] NOT NULL CONSTRAINT [DF__t_sms_que__state__25DB9BFC] DEFAULT (0),
	[ctime] [datetime] NULL CONSTRAINT [DF_t_sms_queue_ctime] DEFAULT (getdate()),
	[result] [int] NULL CONSTRAINT [DF_t_sms_queue_result] DEFAULT (0),
	[cnt] [int] NULL CONSTRAINT [DF_t_sms_queue_cnt] DEFAULT (0),
	[stime] [datetime] NULL ,
	CONSTRAINT [PK_t_sms_queue] PRIMARY KEY  CLUSTERED 
	(
		[idx]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO




CREATE TABLE [dbo].[t_topinfo] (
	[top_id] [int] NOT NULL ,
	[top_name] [char] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[area_code] [char] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[menu_key] [char] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[voc_preplay] [varchar] (127) COLLATE Chinese_PRC_CI_AS NULL ,
	[voc_tts_template] [varchar] (127) COLLATE Chinese_PRC_CI_AS NULL ,
	[voc_sms_sendover] [varchar] (127) COLLATE Chinese_PRC_CI_AS NULL ,
	CONSTRAINT [IX_t_topinfo] UNIQUE  NONCLUSTERED 
	(
		[top_id]
	)  ON [PRIMARY] ,
	CONSTRAINT [IX_t_topinfo_1] UNIQUE  NONCLUSTERED 
	(
		[menu_key],
		[area_code]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO



CREATE TABLE [dbo].[t_toplist] (
	[top_id] [int] NOT NULL ,
	[top_no] [int] NOT NULL ,
	[sp_id] [int] NULL ,
	[sp_name] [char] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[sp_pid] [int] NULL ,
	[sp_pname] [char] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[sp_demo_voc] [varchar] (127) COLLATE Chinese_PRC_CI_AS NULL ,
	CONSTRAINT [IX_t_toplist] UNIQUE  NONCLUSTERED 
	(
		[top_id]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[t_administrators] (
	[caller] [char] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[lvl] [int] NULL CONSTRAINT [DF_t_administrators_lvl] DEFAULT (1),
	[pwd] [char] (10) COLLATE Chinese_PRC_CI_AS NULL 
) ON [PRIMARY]
GO


CREATE TABLE [t_line] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ln] [int] NOT NULL ,
	[enable] [int] NOT NULL CONSTRAINT [DF_t_line_enable] DEFAULT (1),
	[stat] [int] NOT NULL CONSTRAINT [DF_t_line_stat] DEFAULT (0),
	[ctype] [int] NOT NULL CONSTRAINT [DF_t_line_ctype] DEFAULT (0),
	[mno] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL CONSTRAINT [DF_t_line_mno] DEFAULT (''),
	[cle] [varchar] (20) COLLATE Chinese_PRC_CI_AS NOT NULL CONSTRAINT [DF_t_line_cle] DEFAULT (''),
	[st] [datetime] NOT NULL CONSTRAINT [DF_t_line_st] DEFAULT (getdate()),
	[desc] [varchar] (50) COLLATE Chinese_PRC_CI_AS NOT NULL CONSTRAINT [DF__t_line__desc__7B663F43] DEFAULT (''),
	CONSTRAINT [PK_t_line] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[t_tflog] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[ln] [int] NOT NULL ,
	[calltype] [int] NULL ,
	[caller] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[callee] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[st] [datetime] NULL ,
	[et] [datetime] NULL ,
	[logstr] [varchar] (127) COLLATE Chinese_PRC_CI_AS NULL ,
	CONSTRAINT [PK_t_tflog] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[tflog] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[calltype] [int] NULL ,
	[caller] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[callee] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL ,
	[st] [datetime] NULL ,
	[et] [datetime] NULL ,
	[logstr] [varchar] (127) COLLATE Chinese_PRC_CI_AS NULL ,
	CONSTRAINT [PK_tflog] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[t_aimenu] (
	[idx] [int] IDENTITY (1, 1) NOT NULL ,
	[menu_key] [char] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[menu_type] [char] (32) COLLATE Chinese_PRC_CI_AS NOT NULL ,
	[strVOC] [varchar] (127) COLLATE Chinese_PRC_CI_AS NULL ,
	[strTTS] [varchar] (127) COLLATE Chinese_PRC_CI_AS NULL ,
	[strVX] [varchar] (127) COLLATE Chinese_PRC_CI_AS NULL 
	CONSTRAINT [PK_t_aimenu] PRIMARY KEY  CLUSTERED 
	(
		[idx]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[XltVosLog] (
	[ID] [bigint] IDENTITY (1, 1) NOT NULL ,
	[LineID] [int] NULL ,
	[Caller] [varchar] (32) COLLATE Chinese_PRC_CI_AS NULL ,
	[Callee] [varchar] (32) COLLATE Chinese_PRC_CI_AS NULL ,
	[Logstr] [varchar] (127) COLLATE Chinese_PRC_CI_AS NULL ,
	[dt] [datetime] NULL CONSTRAINT [DF_XltVoiceLog_dt] DEFAULT (getdate())
) ON [PRIMARY]
GO

CREATE  PROCEDURE [dbo].addSmsSendRequest
@caller char(32),
@top_id int,
@top_name char(32),
@sp_id int,
@sp_name char(32),
@sp_pid int,
@sp_pname char(32)
AS
insert into t_sms_queue(caller,top_id,top_name,sp_id,sp_name,sp_pid,sp_pname) values(@caller,@top_id,@top_name,@sp_id,@sp_name,@sp_pid,@sp_pname)
select '1'
GO


CREATE PROCEDURE [dbo].[getTopInfo]
@mnuKey char (32),
@areaCode char (32)
 AS  
select top_id,top_name from t_topinfo where @mnuKey=menu_key and @areaCode=area_code
if @@rowcount=0
    select '' as errorno
GO

CREATE PROCEDURE [dbo].[getTopInfoVoc]
@top_id int,
@f int
 AS  
if @f = 1
    select voc_preplay from t_topinfo where @top_id=top_id
if @f = 2
    select voc_tts_template from t_topinfo where  @top_id=top_id
if @f = 3
    select voc_sms_sendover from t_topinfo where  @top_id=top_id
if @@rowcount=0
    select '' as errorno
GO

CREATE PROCEDURE [dbo].[getTopList]
@top_id int,
@top_no int,
@f int
 AS  
if @f = 1
    select sp_id from t_toplist where @top_id=top_id and @top_no=top_no
if @f = 2
    select sp_name from t_toplist where  @top_id=top_id and @top_no=top_no
if @f = 3
    select sp_pid from t_toplist where @top_id=top_id and @top_no=top_no
if @f = 4
    select sp_pname from t_toplist where  @top_id=top_id and @top_no=top_no
if @f = 5
    select sp_demo_voc from t_toplist where  @top_id=top_id and @top_no=top_no
if @@rowcount=0
    select '' as errorno
GO

CREATE  PROCEDURE [dbo].mnu_getType
@mnuKey varchar(127)
AS
    select isnull((select upper(menu_type) from t_aimenu where menu_key=@mnuKey),'')
GO

CREATE  PROCEDURE [dbo].mnu_getString
@mnuKey varchar(127),
@mnuType varchar(127)
AS
    if upper(@mnuType) = 'VOC'
        select isnull((select strVOC from t_aimenu where menu_key=@mnuKey),'')
    if upper(@mnuType) = 'TTS'
        select isnull((select strTTS from t_aimenu where menu_key=@mnuKey),'')
    if upper(@mnuType) = 'VX'
        select isnull((select strVX from t_aimenu where menu_key=@mnuKey),'')
GO

CREATE  PROCEDURE [dbo].mnu_getKeyList
@mnuKey varchar(127)
AS
declare @nLen int
declare @ret varchar(127)
declare @key char(1)
set @nLen=len(@mnuKey)
set @ret=''
declare mycur cursor for select distinct(substring(menu_key,@nLen+1,1)) from t_aimenu where menu_key!=@mnuKey and left(menu_key,@nLen)=@mnuKey
open mycur
FETCH NEXT FROM mycur INTO @key
WHILE @@FETCH_STATUS = 0
BEGIN
   set @ret=@ret+@key
   -- This is executed as long as the previous fetch succeeds.
   FETCH NEXT FROM mycur INTO @key
END

CLOSE mycur
DEALLOCATE mycur

select @ret
GO


CREATE  PROCEDURE [dbo].xlt_init  
AS 
    truncate table t_line
GO


  
CREATE PROCEDURE [dbo].[TranTflog] AS      
declare @sql nvarchar(300)      
declare @st datetime      
declare @dt datetime      
declare @t varchar(30)      
declare @Time varchar(30)      
set @st=convert(varchar(10),dateadd(d,-1,getdate()),120)      
set @dt=convert(varchar(10),dateadd(d,-1,@st),120)      
--set @dt=@st      
      
set @t='tflog'+convert(varchar(6),@dt,112)     
SET @Time=convert(varchar(8),dateadd(m,1,@dt),120)+'01'      
select @t,@dt,@st      
select @Time      
begin tran      
set @sql='insert into '+@t+' select a.* from tflog a where st<'''+@time+''' and st<'''+convert(varchar(10),@st,120)+''''      
--select @sql      
exec sp_executesql @sql      
if @@error!=0    
begin    
 rollback tran    
 return    
end    
delete tflog where st<@Time and st<convert(varchar(10),@st,120)      
commit tran  
  
GO  

  
CREATE  PROCEDURE [dbo].tf_log   
@calltype int,  
@caller varchar(20),  
@callee varchar(20),  
@st datetime,  
@et datetime,  
@logstr varchar(127)   
AS  
insert into [tflog] (calltype,caller,callee,st,et,logstr) values(@calltype,@caller,@callee,@st,@et,@logstr)  
select 1  
--select count(*) from tflog where caller=@caller and callee=@callee and st=@st
GO

CREATE PROCEDURE [dbo].[VosLog]  
@LineID int,  
@Caller varchar(32),  
@Callee varchar(32),  
@Logstr varchar(127)  
AS  
insert into XltVosLog (LineID,Caller,Callee,Logstr) values (@LineID,@Caller,@Callee,@Logstr)  
select 1 as errno  
GO

CREATE  PROCEDURE [dbo].ln_use  
@ln int  
AS  
--标记线路被占用  
update t_line set stat=3 where stat=0 and ln=@ln  
if @@rowcount =0  
    begin   
        select ''  
        return   
    end  
select '1'  
GO  

CREATE  PROCEDURE [dbo].ln_on  
@ln int,  
@stat int,  
@ctype int,  
@mno varchar(20),  
@cle varchar(20),  
@desc varchar(50)  
AS
--在某条线路上摘机  
update t_line set stat=@stat,ctype=@ctype,mno=@mno,cle=@cle,st=getdate(),[desc]=@desc  where ln=@ln  
select 1  
GO

CREATE  PROCEDURE [dbo].ln_timeout_check
@ln int
AS
--检查某条线路是否超时，语音程序可以在检测到超时后挂断用户
select isnull((select top 1 1 from t_line where ln=@ln and dateadd(mi,-30,getdate()) > st),0)
GO

CREATE  PROCEDURE [dbo].ln_off  
@ln int  
AS  
--挂断某条线路，进行日志
declare @stat int  
declare @ctype int  
declare @mno varchar(20)  
declare @cle varchar(20)  
declare @desc varchar(50)  
declare @st datetime  
  
select @stat=stat,@ctype=ctype,@mno=mno,@cle=cle,@st=st,@desc=[desc] from t_line where ln=@ln  
if(@stat >0)  
    begin  
        insert into [t_tflog] (ln,calltype,caller,callee,st,et,logstr) values(@ln,@ctype,@mno,@cle,@st,getdate(),@desc)  
        select 1  
        return   
    end  
select ''  
GO


CREATE  PROCEDURE [dbo].ln_off_all  
@lnum int  
AS  
--重新启动的时候，要在新的呼叫日志表里增加全部记录数据  
declare @stat int  
declare @ctype int  
declare @mno varchar(20)  
declare @cle varchar(20)  
declare @desc varchar(50)  
declare @st datetime  
  
declare @ln int  
declare @cnt int  
set @cnt=0  
set @ln=1  
begin tran  
while(@ln < @lnum)  
    begin  
        select @stat=stat,@ctype=ctype,@mno=mno,@cle=cle,@st=st,@desc=[desc] from t_line where ln=@ln  
        if(@stat >0)  
            begin  
                insert into [t_tflog] (ln,calltype,caller,callee,st,et,logstr) values(@ln,@ctype,@mno,@cle,@st,getdate(),@desc+'REBOOT')  
                set @cnt=@cnt+1  
            end  
        set @ln=@ln+1  
    end  
select @cnt  
commit tran  
GO

CREATE  PROCEDURE [dbo].ln_init  
@ln int  
AS  
--线路重新启动的时候，需要初始化线路数据  
update t_line set stat=0,ctype=0,mno='',cle='',st=getdate(),[desc]='' where ln=@ln  
select 1  
GO

CREATE  PROCEDURE [dbo].ln_getfree  
AS  
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ  
--获取空闲线路  
declare @ln int  
begin tran  
select top 1 @ln=ln from t_line with (rowlock,xlock) where stat=0 and enable=1 order by newid()  
if @@rowcount =0  
    begin   
        set @ln=''  
    end  
else  
    begin  
        update t_line set stat=3 where @ln=ln  
    end  
select @ln  
commit tran  
GO

CREATE PROCEDURE [dbo].[ActCreateTflog] AS  
declare @tflog nvarchar(1000)  
declare @tflog2 nvarchar(1000)  
declare @st datetime  
declare @dt datetime  
declare @t varchar(30)  
declare @t2 varchar(30)  
set @st=getdate()  
if datepart(d,@st)<=27  
begin  
 set @dt=dateadd(m,1,@st)  
end  
else  
begin  
 return  
end  
set @t='tflog'+convert(varchar(6),@dt,112)  
set @t2='t_tflog'+convert(varchar(6),@dt,112)  
set @tflog='CREATE TABLE [dbo].['+@t+'] ([id] [int] NOT NULL,[calltype] [int] NULL,[caller] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL,[callee] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL,[st] [datetime] NULL,[et] [datetime] NULL,[logstr] [varchar] (
127) COLLATE Chinese_PRC_CI_AS NULL)  
 CREATE   INDEX [IX_'+@t+'] ON [dbo].['+@t+']([st]) ON [PRIMARY]  
 CREATE  INDEX [IX_'+@t+'caller] ON [dbo].['+@t+']([caller]) ON [PRIMARY]  
 CREATE  INDEX [IX_'+@t+'logstr] ON [dbo].['+@t+']([logstr]) ON [PRIMARY]'  
set @tflog2='CREATE TABLE [dbo].['+@t2+'] ( [id] [int] IDENTITY (1, 1) NOT NULL , [ln] [int] NOT NULL , [calltype] [int] NULL , [caller] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL , [callee] [varchar] (20) COLLATE Chinese_PRC_CI_AS NULL , [st] [datetim
e] NULL , [et] [datetime] NULL , [logstr] [varchar] (127) COLLATE Chinese_PRC_CI_AS NULL ) ON [PRIMARY]  
 CREATE   INDEX [IX_'+@t2+'] ON [dbo].['+@t2+']([st]) ON [PRIMARY]  
 CREATE  INDEX [IX_'+@t2+'caller] ON [dbo].['+@t2+']([caller]) ON [PRIMARY]  
 CREATE  INDEX [IX_'+@t2+'logstr] ON [dbo].['+@t2+']([logstr]) ON [PRIMARY]'  
exec sp_executesql @tflog  
exec sp_executesql @tflog2  
  
set @tflog='GRANT select ON ['+@t+'] TO commonuser'  
exec sp_executesql @tflog  
set @tflog2='GRANT select ON ['+@t2+'] TO commonuser'  
exec sp_executesql @tflog2  
GO

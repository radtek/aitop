
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (1,'热门产品','VOX1-1.VOC','$top_name排行榜第$top_no名是$sp_name的$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (2,'新品推荐','VOX1-2.VOC','$top_name排行榜第$top_no名是$sp_name的$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (3,'音乐点歌','VOX1-3.VOC','$top_name排行榜第$top_no名是$sp_name的$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (4,'交友聊天','VOX1-4.VOC','$top_name排行榜第$top_no名是$sp_name的$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (5,'财经时事','VOX1-5.VOC','$top_name排行榜第$top_no名是$sp_name的$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (6,'情感哲理','VOX1-6.VOC','$top_name排行榜第$top_no名是$sp_name的$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (7,'娱乐笑话','VOX1-7.VOC','$top_name排行榜第$top_no名是$sp_name的$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (8,'生活百科','VOX1-8.VOC','$top_name排行榜第$top_no名是$sp_name的$sp_pname','VOX2.VOC')


insert into t_vocinfo (vockey,vocinfo) values ('vox0-1','欢迎拨打101760110，进入中国联通10176活力排行榜。本业务免信息费，基本通话费不高于每分钟0.4元')
insert into t_vocinfo (vockey,vocinfo) values ('vox0-2','热门产品请按1，新品推荐请按2，音乐点歌请按3，交友聊天请按4，财经时事请按5，情感哲理请按6，娱乐笑话请按7，生活百科请按8')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-1','以下是本期热门产品排行榜，播放过程中按1收听下一条，按2重新收听，按3收听上一条，按*返回主菜单，按#接收免费短信了解产品具体信息')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-2','以下是本期新品推荐排行榜，播放过程中按1收听下一条，按2重新收听，按3收听上一条，按*返回主菜单，按#接收免费短信了解产品具体信息')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-3','以下是本期音乐点歌排行榜，播放过程中按1收听下一条，按2重新收听，按3收听上一条，按*返回主菜单，按#接收免费短信了解产品具体信息')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-4','以下是本期交友聊天排行榜，播放过程中按1收听下一条，按2重新收听，按3收听上一条，按*返回主菜单，按#接收免费短信了解产品具体信息')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-5','以下是本期财经时事排行榜，播放过程中按1收听下一条，按2重新收听，按3收听上一条，按*返回主菜单，按#接收免费短信了解产品具体信息')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-6','以下是本期情感哲理排行榜，播放过程中按1收听下一条，按2重新收听，按3收听上一条，按*返回主菜单，按#接收免费短信了解产品具体信息')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-7','以下是本期娱乐笑话排行榜，播放过程中按1收听下一条，按2重新收听，按3收听上一条，按*返回主菜单，按#接收免费短信了解产品具体信息')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-8','以下是本期生活百科排行榜，播放过程中按1收听下一条，按2重新收听，按3收听上一条，按*返回主菜单，按#接收免费短信了解产品具体信息')
insert into t_vocinfo (vockey,vocinfo) values ('vox2'	,'短信已经发送，按1继续收听，按*返回主菜单')
insert into t_vocinfo (vockey,vocinfo) values ('vox3'	,'请休息一会儿，再见')


insert into t_topinfo (top_id,top_type,area_code,menu_key) values (1	,1	,'安徽',	'A1')
insert into t_topinfo (top_id,top_type,area_code,menu_key) values (2	,2	,'安徽',	'A2')
insert into t_topinfo (top_id,top_type,area_code,menu_key) values (3	,3	,'安徽',	'A3')
insert into t_topinfo (top_id,top_type,area_code,menu_key) values (4	,4	,'安徽',	'A4')
insert into t_topinfo (top_id,top_type,area_code,menu_key) values (5	,5	,'安徽',	'A5')
insert into t_topinfo (top_id,top_type,area_code,menu_key) values (6	,6	,'安徽',	'A6')

insert into t_toplist (top_id,top_no,sp_id,sp_name,sp_pid,sp_pname,sp_demo_voc) values (1	,1	,98,'排行榜test',109801,'排行榜业务test','这是SP的示范语音')
insert into t_toplist (top_id,top_no,sp_id,sp_name,sp_pid,sp_pname,sp_demo_voc) values (1	,2	,98,'排行榜test',109802,'排行榜业务test','这是SP的示范语音')
insert into t_toplist (top_id,top_no,sp_id,sp_name,sp_pid,sp_pname,sp_demo_voc) values (1	,3	,98,'排行榜test',109803,'排行榜业务test','这是SP的示范语音')
insert into t_toplist (top_id,top_no,sp_id,sp_name,sp_pid,sp_pname,sp_demo_voc) values (10	,1	,98,'排行榜test',109801,'排行榜业务test','这是SP的示范语音')
insert into t_toplist (top_id,top_no,sp_id,sp_name,sp_pid,sp_pname,sp_demo_voc) values (10	,2	,98,'排行榜test',109802,'排行榜业务test','这是SP的示范语音')
insert into t_toplist (top_id,top_no,sp_id,sp_name,sp_pid,sp_pname,sp_demo_voc) values (10	,3	,98,'排行榜test',109803,'排行榜业务test','这是SP的示范语音')


//从t_topdata表里将数据分散到各个表里
truncate table t_topinfo
insert into t_topinfo 
select a.top_bid,b.top_type,a.province,'A'+cast(b.top_type as varchar(10)),a.top_name from t_topdata a ,t_toptype b where a.top_name=b.top_name
group by top_bid,top_type,a.province,a.top_name 
order by 3,4

truncate table t_toplist
insert into t_toplist 
select top_bid,top_no,spid,spname,service_id,service_name,'' from t_topdata 
group by top_bid,top_no,spid,spname,service_id,service_name
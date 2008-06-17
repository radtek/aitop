
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (1,'���Ų�Ʒ','VOX1-1.VOC','$top_name���а��$top_no����$sp_name��$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (2,'��Ʒ�Ƽ�','VOX1-2.VOC','$top_name���а��$top_no����$sp_name��$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (3,'���ֵ��','VOX1-3.VOC','$top_name���а��$top_no����$sp_name��$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (4,'��������','VOX1-4.VOC','$top_name���а��$top_no����$sp_name��$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (5,'�ƾ�ʱ��','VOX1-5.VOC','$top_name���а��$top_no����$sp_name��$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (6,'�������','VOX1-6.VOC','$top_name���а��$top_no����$sp_name��$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (7,'����Ц��','VOX1-7.VOC','$top_name���а��$top_no����$sp_name��$sp_pname','VOX2.VOC')
insert into t_toptype (top_type,top_name,voc_preplay,voc_tts_template,voc_sms_sendover) values (8,'����ٿ�','VOX1-8.VOC','$top_name���а��$top_no����$sp_name��$sp_pname','VOX2.VOC')


insert into t_vocinfo (vockey,vocinfo) values ('vox0-1','��ӭ����101760110�������й���ͨ10176�������а񡣱�ҵ������Ϣ�ѣ�����ͨ���Ѳ�����ÿ����0.4Ԫ')
insert into t_vocinfo (vockey,vocinfo) values ('vox0-2','���Ų�Ʒ�밴1����Ʒ�Ƽ��밴2�����ֵ���밴3�����������밴4���ƾ�ʱ���밴5����������밴6������Ц���밴7������ٿ��밴8')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-1','�����Ǳ������Ų�Ʒ���а񣬲��Ź����а�1������һ������2������������3������һ������*�������˵�����#������Ѷ����˽��Ʒ������Ϣ')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-2','�����Ǳ�����Ʒ�Ƽ����а񣬲��Ź����а�1������һ������2������������3������һ������*�������˵�����#������Ѷ����˽��Ʒ������Ϣ')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-3','�����Ǳ������ֵ�����а񣬲��Ź����а�1������һ������2������������3������һ������*�������˵�����#������Ѷ����˽��Ʒ������Ϣ')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-4','�����Ǳ��ڽ����������а񣬲��Ź����а�1������һ������2������������3������һ������*�������˵�����#������Ѷ����˽��Ʒ������Ϣ')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-5','�����Ǳ��ڲƾ�ʱ�����а񣬲��Ź����а�1������һ������2������������3������һ������*�������˵�����#������Ѷ����˽��Ʒ������Ϣ')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-6','�����Ǳ�������������а񣬲��Ź����а�1������һ������2������������3������һ������*�������˵�����#������Ѷ����˽��Ʒ������Ϣ')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-7','�����Ǳ�������Ц�����а񣬲��Ź����а�1������һ������2������������3������һ������*�������˵�����#������Ѷ����˽��Ʒ������Ϣ')
insert into t_vocinfo (vockey,vocinfo) values ('vox1-8','�����Ǳ�������ٿ����а񣬲��Ź����а�1������һ������2������������3������һ������*�������˵�����#������Ѷ����˽��Ʒ������Ϣ')
insert into t_vocinfo (vockey,vocinfo) values ('vox2'	,'�����Ѿ����ͣ���1������������*�������˵�')
insert into t_vocinfo (vockey,vocinfo) values ('vox3'	,'����Ϣһ������ټ�')


insert into t_topinfo (top_id,top_type,area_code,menu_key) values (1	,1	,'����',	'A1')
insert into t_topinfo (top_id,top_type,area_code,menu_key) values (2	,2	,'����',	'A2')
insert into t_topinfo (top_id,top_type,area_code,menu_key) values (3	,3	,'����',	'A3')
insert into t_topinfo (top_id,top_type,area_code,menu_key) values (4	,4	,'����',	'A4')
insert into t_topinfo (top_id,top_type,area_code,menu_key) values (5	,5	,'����',	'A5')
insert into t_topinfo (top_id,top_type,area_code,menu_key) values (6	,6	,'����',	'A6')

insert into t_toplist (top_id,top_no,sp_id,sp_name,sp_pid,sp_pname,sp_demo_voc) values (1	,1	,98,'���а�test',109801,'���а�ҵ��test','����SP��ʾ������')
insert into t_toplist (top_id,top_no,sp_id,sp_name,sp_pid,sp_pname,sp_demo_voc) values (1	,2	,98,'���а�test',109802,'���а�ҵ��test','����SP��ʾ������')
insert into t_toplist (top_id,top_no,sp_id,sp_name,sp_pid,sp_pname,sp_demo_voc) values (1	,3	,98,'���а�test',109803,'���а�ҵ��test','����SP��ʾ������')
insert into t_toplist (top_id,top_no,sp_id,sp_name,sp_pid,sp_pname,sp_demo_voc) values (10	,1	,98,'���а�test',109801,'���а�ҵ��test','����SP��ʾ������')
insert into t_toplist (top_id,top_no,sp_id,sp_name,sp_pid,sp_pname,sp_demo_voc) values (10	,2	,98,'���а�test',109802,'���а�ҵ��test','����SP��ʾ������')
insert into t_toplist (top_id,top_no,sp_id,sp_name,sp_pid,sp_pname,sp_demo_voc) values (10	,3	,98,'���а�test',109803,'���а�ҵ��test','����SP��ʾ������')


//��t_topdata���ｫ���ݷ�ɢ����������
truncate table t_topinfo
insert into t_topinfo 
select a.top_bid,b.top_type,a.province,'A'+cast(b.top_type as varchar(10)),a.top_name from t_topdata a ,t_toptype b where a.top_name=b.top_name
group by top_bid,top_type,a.province,a.top_name 
order by 3,4

truncate table t_toplist
insert into t_toplist 
select top_bid,top_no,spid,spname,service_id,service_name,'' from t_topdata 
group by top_bid,top_no,spid,spname,service_id,service_name
-- ����1:
use testdb1;
set session transaction isolation level read uncommitted;
start transaction;
-- ��1�β�ѯ����'MU2455'����Ʊ
select tickets from ticket where flight_no="MU2455" for share;
set @n = sleep(5);
-- ��2�β�ѯ����'MU2455'����Ʊ
select tickets from ticket where flight_no="MU2455" for share;
commit;
-- ��3�β�ѯ���к������Ʊ������������2�ύ��
set @n = sleep(1);
select * from ticket;


-- ����2:
use testdb1;
set session transaction isolation level read uncommitted;
start transaction;
set @n = sleep(1);
-- ������1�ĵ�1��2�β�ѯ֮�䣬��ͼ��Ʊ1��(����MU2455)��
update ticket 
set tickets=tickets-1
where flight_no="MU2455"; 
commit;

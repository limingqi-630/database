-- ����1������Ĭ�ϵ�������뼶��- repeatable read��:
use testdb1;
select @@transaction_isolation;
start transaction;
-- ��1�β�ѯ��Ʊ����300�ŵĺ�����Ϣ
select * from ticket where tickets>300;
set @n=sleep(5);
-- �޸ĺ���MU5111��ִ�ɻ���ΪA330-300��
update ticket set aircraft = 'A330-300' where flight_no = 'MU5111'; 
-- ��2�β�ѯ��Ʊ����300�ŵĺ�����Ϣ
select * from ticket where tickets > 300;
commit;


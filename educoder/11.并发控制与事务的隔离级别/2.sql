-- ����1:
use testdb1;
-- �������ʵ���������뼶��
set session transaction isolation level read uncommitted;
start transaction;
-- ʱ��2 - ����1��������Ʊ,����������2�޸�֮��
-- ��ӵȴ����룬ȷ������
set @n = sleep(5);
select tickets from ticket where flight_no = 'CA8213';
commit;

-- ����2
use testdb1;
-- �������ʵ���������뼶��
set session transaction isolation level read uncommitted;
start transaction;
-- ʱ��1 - ����2�޸ĺ�����Ʊ
update ticket set tickets = tickets - 1 where flight_no = 'CA8213';
-- ʱ��3 - ����2 ȡ�������޸�
-- ����Ӵ��룬ʹ����1������2����ǰ����;
set @n = sleep(10);
rollback;




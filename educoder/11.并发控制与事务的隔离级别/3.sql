-- ����1:
set session transaction isolation level read uncommitted;
-- ��������
start transaction;
-- ʱ��1 - ����1��������Ʊ:
insert into result select now(),1 t, tickets from ticket where flight_no = 'CZ5525';
set @n=sleep(2); -- 2s
-- ʱ��3 - ����1�޸���Ʊ����������ȡ:
update ticket set tickets = tickets - 1 where flight_no = 'CZ5525';
insert into result select now(),1 t, tickets from ticket where flight_no = 'CZ5525';
set @n=sleep(10); -- 4s
commit;
-- ʱ��6 - ����1��t2Ҳ�ύ���ȡ��Ʊ
set @n=sleep(3);
insert into result select now(), 1 t, tickets from ticket where flight_no = 'CZ5525';

-- ����2
set session transaction isolation level read uncommitted;
start transaction;
-- ʱ��2 - ����2������1��ȡ��Ʊ֮��Ҳ��ȡ��Ʊ
set @n=sleep(1); -- 1s
insert into result select now(),2 t, tickets from ticket where flight_no = 'CZ5525';
-- ʱ��4 - ����2������1�޸���Ʊ��δ�ύǰ�ٴζ�ȡ��Ʊ������2�����ζ�ȡ���Ӧ�ò�ͬ
set @n=sleep(5); -- 3s
insert into result select now(), 2 t, tickets from ticket where flight_no = 'CZ5525';
update ticket set tickets = tickets - 1 where flight_no = 'CZ5525';
-- ʱ��5 - ����2 ��ȡ��Ʊ���Լ��޸ĵ�δ���Ľ����:
insert into result select now(), 2 t, tickets from ticket where flight_no = 'CZ5525';
commit;

-- (1) ������ɫclient_manager��fund_manager��
create role client_manager;
create role fund_manager;
-- (2) ����client_manager��client��ӵ��select,insert,update��Ȩ�ޣ�
grant select,insert,update
on table client
to client_manager;
-- (3) ����client_manager��bank_card��ӵ�в�ѯ�����п�������selectȨ�ޣ�
grant select(b_number,b_type,b_c_id)
on table bank_card
to client_manager;
-- (4) ����fund_manager��fund���select,insert,updateȨ�ޣ�
grant select,insert,update
on table fund
to fund_manager;
-- (5) ��client_manager��Ȩ�������û�tom��jerry��
grant client_manager
to tom,jerry;
-- (6) ��fund_managerȨ�������û�Cindy.
grant fund_manager
to Cindy;
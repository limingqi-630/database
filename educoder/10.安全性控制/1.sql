--(1) �����û�tom��jerry����ʼ�����Ϊ'123456'��
create user tom identified by "123456";
create user jerry identified by "123456";
--(2) �����û�tom��ѯ�ͻ�������������͵绰��Ȩ��,��tom��ת��Ȩ�ޣ�
grant select(c_name,c_mail,c_phone)
on table client
to tom
with grant option;
--(3) �����û�jerry�޸����п�����Ȩ�ޣ�
grant update(b_balance)
on table bank_card
to jerry;
--(4) �ջ��û�Cindy��ѯ���п���Ϣ��Ȩ�ޡ�
revoke select 
on table bank_card
from Cindy;


-- �벻Ҫ�ڱ������ļ�����ӿ��У����� 
use testdb1;
# ��������ĸ��뼶��Ϊ read uncommitted
set session transaction isolation level read uncommitted;
-- ��������
start transaction;
insert into dept(name) values('��ά��');
# �ع�����
rollback;
/* ���� */
-- �����ݿ�residents����������,�������ļ�residents_bak.sql:
mysqldump -h 127.0.0.1 -u root --databases residents > residents_bak.sql
-- ���ñ����ļ�residents_bak.sql��ԭ���ݿ�:
mysqladmin -h 127.0.0.1 -u root create residents 
mysql -h 127.0.0.1 -u root residents < residents_bak.sql


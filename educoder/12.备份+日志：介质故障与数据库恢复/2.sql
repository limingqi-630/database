-- �߼�����
mysqldump -h 127.0.0.1 -u root --databases train > train_bak.sql
-- �¿���־
mysqladmin -h 127.0.0.1 -u root flush-logs
-- �����߼����ݺ���־�ָ����ݿ�����
mysqladmin -h 127.0.0.1 -u root create train 
mysql -h 127.0.0.1 -u root train < train_bak.sql
mysqlbinlog --no-defaults "log/binlog.000018" | mysql -h 127.0.0.1 -u root



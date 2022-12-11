-- 对数据库residents作海量备份,备份至文件residents_bak.sql:
mysqldump -h 127.0.0.1 -u root --databases residents > residents_bak.sql
-- 利用备份文件residents_bak.sql还原数据库:
mysqladmin -h 127.0.0.1 -u root create residents 
mysql -h 127.0.0.1 -u root residents < residents_bak.sql


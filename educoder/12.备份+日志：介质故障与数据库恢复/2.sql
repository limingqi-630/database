-- 逻辑备份
mysqldump -h 127.0.0.1 -u root --databases train > train_bak.sql
-- 新开日志
mysqladmin -h 127.0.0.1 -u root flush-logs
-- 利用逻辑备份和日志恢复数据库的命令：
mysqladmin -h 127.0.0.1 -u root create train 
mysql -h 127.0.0.1 -u root train < train_bak.sql
mysqlbinlog --no-defaults "log/binlog.000018" | mysql -h 127.0.0.1 -u root



-- create database if not exists fib;
use fib;
-- drop table if exists fibonacci;
-- create table fibonacci(
--     n int primary key,
--     fibn bigint 
-- );
drop procedure if exists sp_fibonacci;
delimiter $$
create procedure sp_fibonacci(in m int)
begin
######## 请补充代码完成存储过程体 ########
declare i int default 0;
declare insert_now int default 0;
declare insert_pre int default 0;
declare tmp int;
while i<m do
    if i=0 then
        insert ignore into fibonacci values(i,0);
    elseif i=1 then
        set insert_now=1;
        set insert_pre=1;
        insert ignore into fibonacci values(i,1);
    else insert ignore into fibonacci values(i,insert_now);
        set tmp=insert_now;
        set insert_now=insert_now+insert_pre;
        set insert_pre=tmp;
    end if;
    set i=i+1;
end while;
end $$
delimiter ;

 

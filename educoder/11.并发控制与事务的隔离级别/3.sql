-- 事务1:
set session transaction isolation level read uncommitted;
-- 开启事务
start transaction;
-- 时刻1 - 事务1读航班余票:
insert into result select now(),1 t, tickets from ticket where flight_no = 'CZ5525';
set @n=sleep(2); -- 2s
-- 时刻3 - 事务1修改余票，并立即读取:
update ticket set tickets = tickets - 1 where flight_no = 'CZ5525';
insert into result select now(),1 t, tickets from ticket where flight_no = 'CZ5525';
set @n=sleep(10); -- 4s
commit;
-- 时刻6 - 事务1在t2也提交后读取余票
set @n=sleep(3);
insert into result select now(), 1 t, tickets from ticket where flight_no = 'CZ5525';

-- 事务2
set session transaction isolation level read uncommitted;
start transaction;
-- 时刻2 - 事务2在事务1读取余票之后也读取余票
set @n=sleep(1); -- 1s
insert into result select now(),2 t, tickets from ticket where flight_no = 'CZ5525';
-- 时刻4 - 事务2在事务1修改余票但未提交前再次读取余票，事务2的两次读取结果应该不同
set @n=sleep(5); -- 3s
insert into result select now(), 2 t, tickets from ticket where flight_no = 'CZ5525';
update ticket set tickets = tickets - 1 where flight_no = 'CZ5525';
-- 时刻5 - 事务2 读取余票（自己修改但未交的结果）:
insert into result select now(), 2 t, tickets from ticket where flight_no = 'CZ5525';
commit;

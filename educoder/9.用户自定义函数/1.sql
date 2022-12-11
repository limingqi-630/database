use finance1;
set global log_bin_trust_function_creators=1;
drop function IF EXISTS get_deposit;
delimiter $$
create function get_deposit(client_id int)
returns numeric(10,2) 
begin
	return (select total_deposit
            from (
                select b_c_id,sum(b_balance) as total_deposit
                from bank_card 
                where b_type="储蓄卡"
                group by b_c_id
                order by b_c_id
                ) as tmp
            where b_c_id=client_id);

end$$
delimiter ;

/*  应用该函数查询存款总额在100万以上的客户身份证号，姓名和存储总额(total_deposit)，
    结果依存款总额从高到代排序  */
select c_id_card,c_name,get_deposit(c_id) as total_deposit
from client
where get_deposit(c_id)>=1000000
order by get_deposit(c_id) desc;


/*  代码文件结束     */

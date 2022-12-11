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
                where b_type="���"
                group by b_c_id
                order by b_c_id
                ) as tmp
            where b_c_id=client_id);

end$$
delimiter ;

/*  Ӧ�øú�����ѯ����ܶ���100�����ϵĿͻ����֤�ţ������ʹ洢�ܶ�(total_deposit)��
    ���������ܶ�Ӹߵ�������  */
select c_id_card,c_name,get_deposit(c_id) as total_deposit
from client
where get_deposit(c_id)>=1000000
order by get_deposit(c_id) desc;


/*  �����ļ�����     */

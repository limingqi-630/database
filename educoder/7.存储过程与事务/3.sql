use finance1;
delimiter $$
create procedure sp_transfer(
	                 IN applicant_id int,      
                     IN source_card_id char(30),
					 IN receiver_id int, 
                     IN dest_card_id char(30),
					 IN	amount numeric(10,2),
					 OUT return_code int)
BEGIN
    declare real_applicant_id int;
    declare real_receiver_id int;
    declare source_card_type char(20);
    declare dest_card_type char(20);
    declare source_card_amount decimal(10,2);

    start transaction;  					/*开启事务*/
    set autocommit=off;         			/*关闭自动事务模式*/
    set real_applicant_id=(select b_c_id from bank_card where b_number=source_card_id);
    set real_receiver_id=(select b_c_id from bank_card where b_number=dest_card_id);
    set source_card_type=(select b_type from bank_card where b_number=source_card_id);
    set dest_card_type=(select b_type from bank_card where b_number=dest_card_id);
    set source_card_amount=(select b_balance from bank_card where b_number=source_card_id);
    if real_applicant_id=applicant_id and real_receiver_id=receiver_id and !(source_card_type="信用卡") and source_card_amount>=amount then
        if dest_card_type="储蓄卡" then     /*储蓄卡转储蓄卡*/
            update bank_card set b_balance=b_balance-amount where b_number=source_card_id;
            update bank_card set b_balance=b_balance+amount where b_number=dest_card_id;
        else                                /*储蓄卡转信用卡*/
            update bank_card set b_balance=b_balance-amount where b_number=source_card_id;
            update bank_card set b_balance=b_balance-amount where b_number=dest_card_id;
        end if;
        set return_code=1;
    else set return_code=0;
    end if;

    commit;                                  /*提交*/
END$$
delimiter ;






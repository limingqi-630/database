use finance1;

-- 在金融应用场景数据库中，编程实现一个转账操作的存储过程sp_transfer_balance，实现从一个帐户向另一个帐户转账。
-- 请补充代码完成该过程：
/*
仅当转款人是转出卡的持有人时，才可转出；
仅当收款人是收款卡的持有人时，才可转入；
储蓄卡之间可以相互转账；
允许储蓄卡向信用卡转账，称为信用卡还款(允许替它人还款)，还款可以超过信用卡余额，此时，信用卡余额为负数；
信用卡不能向储蓄卡转账；
转账金额不能超过储蓄卡余额；
*/
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

    
    start transaction;          --开启事务
    set autocommit=off;         --关闭自动事务模式
    set real_applicant_id=(select b_c_id from bank_card where b_number=source_card_id);
    set real_receiver_id=(select b_c_id from bank_card where b_number=dest_card_id);
    set source_card_type=(select b_type from bank_card where b_number=source_card_id);
    set dest_card_type=(select b_type from bank_card where b_number=dest_card_id);
    set source_card_amount=(select b_balance from bank_card where b_number=source_card_id);
    

    if real_applicant_id=applicant_id and real_receiver_id=receiver_id and !(source_card_type="信用卡") and source_card_amount>=amount



    commit;                     --提交
END$$
delimiter ;






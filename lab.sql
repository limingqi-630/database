use finance1;

-- �ڽ���Ӧ�ó������ݿ��У����ʵ��һ��ת�˲����Ĵ洢����sp_transfer_balance��ʵ�ִ�һ���ʻ�����һ���ʻ�ת�ˡ�
-- �벹�������ɸù��̣�
/*
����ת������ת�����ĳ�����ʱ���ſ�ת����
�����տ������տ�ĳ�����ʱ���ſ�ת�룻
���֮������໥ת�ˣ�
����������ÿ�ת�ˣ���Ϊ���ÿ�����(���������˻���)��������Գ������ÿ�����ʱ�����ÿ����Ϊ������
���ÿ��������ת�ˣ�
ת�˽��ܳ��������
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

    
    start transaction;          --��������
    set autocommit=off;         --�ر��Զ�����ģʽ
    set real_applicant_id=(select b_c_id from bank_card where b_number=source_card_id);
    set real_receiver_id=(select b_c_id from bank_card where b_number=dest_card_id);
    set source_card_type=(select b_type from bank_card where b_number=source_card_id);
    set dest_card_type=(select b_type from bank_card where b_number=dest_card_id);
    set source_card_amount=(select b_balance from bank_card where b_number=source_card_id);
    

    if real_applicant_id=applicant_id and real_receiver_id=receiver_id and !(source_card_type="���ÿ�") and source_card_amount>=amount



    commit;                     --�ύ
END$$
delimiter ;






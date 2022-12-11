use finance1;
drop trigger if exists before_property_inserted;
delimiter $$
create trigger before_property_inserted 
before insert on property 
for each row 
begin
    declare msg varchar(128);
    -- �жϵ�pro_type = 1ʱ,��pro_pif_id����finances_product���е�ĳ������ֵ
    if new.pro_type=1 then
        if new.pro_pif_id not in (select p_id from finances_product) then
            set msg=concat('finances product #',new.pro_pif_id,' not found!');
        end if;
    -- �жϵ�pro_type = 2,��pro_pif_id����insurance���е�ĳ������ֵ
    elseif new.pro_type=2 then
        if new.pro_pif_id not in (select i_id from insurance) then
            set msg=concat('insurance #',new.pro_pif_id,' not found!');
        end if;
    -- �жϵ�pro_type = 3,��pro_pif_id����fund���е�ĳ������ֵ
    elseif new.pro_type=3 then
        if new.pro_pif_id not in (select f_id from fund) then 
            set msg=concat('fund #',new.pro_pif_id,' not found!');
        end if;
    -- pro_type���ݲ��Ϸ�ʱ
    else 
        set msg=concat('type ',new.pro_type,' is illegal!');
    end if;   
    -- ���msg�ǿ� ������쳣
    if msg is not null then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    end if;
end$$
delimiter ;



















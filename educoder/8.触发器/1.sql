use finance1;
drop trigger if exists before_property_inserted;
delimiter $$
create trigger before_property_inserted 
before insert on property 
for each row 
begin
    declare msg varchar(128);
    -- 判断当pro_type = 1时,但pro_pif_id不是finances_product表中的某个主码值
    if new.pro_type=1 then
        if new.pro_pif_id not in (select p_id from finances_product) then
            set msg=concat('finances product #',new.pro_pif_id,' not found!');
        end if;
    -- 判断当pro_type = 2,但pro_pif_id不是insurance表中的某个主码值
    elseif new.pro_type=2 then
        if new.pro_pif_id not in (select i_id from insurance) then
            set msg=concat('insurance #',new.pro_pif_id,' not found!');
        end if;
    -- 判断当pro_type = 3,但pro_pif_id不是fund表中的某个主码值
    elseif new.pro_type=3 then
        if new.pro_pif_id not in (select f_id from fund) then 
            set msg=concat('fund #',new.pro_pif_id,' not found!');
        end if;
    -- pro_type数据不合法时
    else 
        set msg=concat('type ',new.pro_type,' is illegal!');
    end if;   
    -- 如果msg非空 则产生异常
    if msg is not null then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    end if;
end$$
delimiter ;



















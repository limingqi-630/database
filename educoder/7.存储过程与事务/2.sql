delimiter $$
create procedure sp_night_shift_arrange(in start_date date, in end_date date)
begin
    declare done int default false;                                     /*结束标志*/
    declare date_now date default start_date;                           /*此时时间*/
    declare date_end date default '2022-05-31';                         /*结束时间*/
    declare boss_wait int default false;                                    /*主任等待标志*/
    /*declare boss_name char(30) default "赵杏林";*/                         /*主任的名字*/
    declare boss_name char(30) default (select e_name from employee where e_type=1);
    declare doctor_name char(30);                                       /*被选中的医生的名字*/
    declare nurse_name1 char(30);                                       /*被选中的护士1的名字*/
    declare nurse_name2 char(30);                                       /*被选中的护士2的名字*/  
    declare doctor_cursor cursor for                                    /*选取医生的游标*/
        select e_name from employee where e_type=1 or e_type=2;
    declare nurse_cursor cursor for                                     /*选取护士的游标*/
        select e_name from employee where e_type=3;
    declare continue handler for not found set done=true;

    open doctor_cursor;
    open nurse_cursor;

    while date_now<=end_date do
        /*取护士*/
        fetch nurse_cursor into nurse_name1;                     
        if done then
            close nurse_cursor;
            open nurse_cursor;
            set done=false;
            fetch nurse_cursor into nurse_name1;  
        end if;
        fetch nurse_cursor into nurse_name2;                     
        if done then
            close nurse_cursor;
            open nurse_cursor;
            set done=false;
            fetch nurse_cursor into nurse_name2; 
        end if;

        /*取医生*/
        /*是周一且有主任等着被暗盘*/
        if dayofweek(date_now)=2 and boss_wait then                   
            insert into night_shift_schedule values(date_now,boss_name,nurse_name1,nurse_name2);
            set boss_wait=false;

        /*不是周一*/
        else 
            fetch doctor_cursor into doctor_name;                           /*取医生*/
            if done then
                close doctor_cursor;
                open doctor_cursor;
                set done=false;
                fetch doctor_cursor into doctor_name;
            end if;

            if (dayofweek(date_now)=1 or dayofweek(date_now)=7) and doctor_name=boss_name then        /*是周末且选中了主任*/
                set boss_wait=true;
                fetch doctor_cursor into doctor_name;
                if done then
                    close doctor_cursor;
                    open doctor_cursor;
                    set done=false;
                    fetch doctor_cursor into doctor_name;
                end if;
                insert into night_shift_schedule values(date_now,doctor_name,nurse_name1,nurse_name2);
            else                                                                                       /*不是周末*/
                insert into night_shift_schedule values(date_now,doctor_name,nurse_name1,nurse_name2);
            end if;
        end if;
        set date_now=(select date_add(date_now,interval 1 day));
    end while;

end$$

delimiter ;
with tmp2 as
(
    select (week(pro_purchase_time)-5) as week_of_trading,/*周数*/
            (dayofweek(pro_purchase_time)-1) as week_day,/*周几*/
            total_amount
    from
    (
        select pro_purchase_time,to_days(pro_purchase_time) as date_index,sum(f_amount*pro_quantity) as total_amount
        from 
        (
            select pro_purchase_time,f_amount,pro_quantity 
            from property,fund
            where pro_type=3 and pro_pif_id=f_id
        ) as tmp0
        group by pro_purchase_time
        having to_days(pro_purchase_time)>=to_days('2022-02-01') and to_days(pro_purchase_time)<=to_days('2022-02-28')
        order by pro_purchase_time
    ) as tmp1
)
select week_of_trading,
sum(if(week_day=1,total_amount,NULL)) as Monday,
sum(if(week_day=2,total_amount,NULL)) as Tuesday,
sum(if(week_day=3,total_amount,NULL)) as Wednesday,
sum(if(week_day=4,total_amount,NULL)) as Thursday,
sum(if(week_day=5,total_amount,NULL)) as Friday
from tmp2
group by week_of_trading;

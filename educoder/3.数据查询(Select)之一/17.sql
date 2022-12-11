select pro_purchase_time1 as pro_purchase_time,total_amount1 as total_amount
from(
select pro_purchase_time1,total_amount1
FROM(
with tmp as
(
    select pro_purchase_time,to_days(pro_purchase_time) as date_index,sum(f_amount*pro_quantity) as total_amount
    from 
    (
        select pro_purchase_time,f_amount,pro_quantity 
        from property,fund
        where pro_type=3 and pro_pif_id=f_id
    ) as tmp0
    group by pro_purchase_time
    having to_days(pro_purchase_time)>=to_days('2022-02-07')
    order by pro_purchase_time
)
select tmp1.pro_purchase_time as pro_purchase_time1,tmp1.total_amount as total_amount1,tmp2.pro_purchase_time as pro_purchase_time2,tmp2.total_amount as total_amount2,tmp3.pro_purchase_time as pro_purchase_time3,tmp3.total_amount as total_amount3
from tmp as tmp1  
left outer join tmp as tmp2 
on tmp2.date_index=(case dayofweek(tmp1.pro_purchase_time)
                                when 6 then (tmp1.date_index+3)
                                else (tmp1.date_index+1)
                    end)

left outer join tmp as tmp3
on (tmp3.date_index=case dayofweek(tmp1.pro_purchase_time)
                                when 5 then (tmp1.date_index+4)
                                when 6 then (tmp1.date_index+4) 
                                else (tmp1.date_index+2)
                    end)

where tmp1.total_amount>1000000 and tmp2.total_amount>1000000 and tmp3.total_amount>1000000
) as temp1

UNION

select pro_purchase_time2,total_amount2
FROM(
with tmp as
(
    select pro_purchase_time,to_days(pro_purchase_time) as date_index,sum(f_amount*pro_quantity) as total_amount
    from 
    (
        select pro_purchase_time,f_amount,pro_quantity 
        from property,fund
        where pro_type=3 and pro_pif_id=f_id
    ) as tmp0
    group by pro_purchase_time
    having to_days(pro_purchase_time)>=to_days('2022-02-07')
    order by pro_purchase_time
)
select tmp1.pro_purchase_time as pro_purchase_time1,tmp1.total_amount as total_amount1,tmp2.pro_purchase_time as pro_purchase_time2,tmp2.total_amount as total_amount2,tmp3.pro_purchase_time as pro_purchase_time3,tmp3.total_amount as total_amount3
from tmp as tmp1  
left outer join tmp as tmp2 
on tmp2.date_index=(case dayofweek(tmp1.pro_purchase_time)
                                when 6 then (tmp1.date_index+3)
                                else (tmp1.date_index+1)
                    end)

left outer join tmp as tmp3
on (tmp3.date_index=case dayofweek(tmp1.pro_purchase_time)
                                when 5 then (tmp1.date_index+4)
                                when 6 then (tmp1.date_index+4) 
                                else (tmp1.date_index+2)
                    end)

where tmp1.total_amount>1000000 and tmp2.total_amount>1000000 and tmp3.total_amount>1000000
) as temp2

union

select pro_purchase_time3,total_amount3
FROM(
with tmp as
(
    select pro_purchase_time,to_days(pro_purchase_time) as date_index,sum(f_amount*pro_quantity) as total_amount
    from 
    (
        select pro_purchase_time,f_amount,pro_quantity 
        from property,fund
        where pro_type=3 and pro_pif_id=f_id
    ) as tmp0
    group by pro_purchase_time
    having to_days(pro_purchase_time)>=to_days('2022-02-07')
    order by pro_purchase_time
)
select tmp1.pro_purchase_time as pro_purchase_time1,tmp1.total_amount as total_amount1,tmp2.pro_purchase_time as pro_purchase_time2,tmp2.total_amount as total_amount2,tmp3.pro_purchase_time as pro_purchase_time3,tmp3.total_amount as total_amount3
from tmp as tmp1  
left outer join tmp as tmp2 
on tmp2.date_index=(case dayofweek(tmp1.pro_purchase_time)
                                when 6 then (tmp1.date_index+3)
                                else (tmp1.date_index+1)
                    end)

left outer join tmp as tmp3
on (tmp3.date_index=case dayofweek(tmp1.pro_purchase_time)
                                when 5 then (tmp1.date_index+4)
                                when 6 then (tmp1.date_index+4) 
                                else (tmp1.date_index+2)
                    end)

where tmp1.total_amount>1000000 and tmp2.total_amount>1000000 and tmp3.total_amount>1000000
) as temp3
) as temp;

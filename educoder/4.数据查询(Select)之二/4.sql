with tmp0 as /*持有14号理财产品数量最多的客户*/
(
select pro_c_id,pro_quantity,dense_rank() over(order by pro_quantity desc) as rank0 
from property
where pro_pif_id=14 and pro_type=1
order by pro_quantity desc
),
tmp1 as /*前3名客户持有的所有产品 不包含14号*/
(
    select distinct property.pro_pif_id
    from property,(select * from tmp0 where rank0<=3) as tmp2
    where property.pro_c_id=tmp2.pro_c_id and property.pro_pif_id!=14 and property.pro_type=1
)
select pro_pif_id,count(*) as cc,dense_rank() over(order by count(*) desc) as prank 
from property
where pro_type=1 and pro_pif_id in (select * from tmp1)
group by pro_pif_id
order by cc desc,pro_pif_id;


/*  end  of  your code  */
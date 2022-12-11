-- 5) 查询任意两个客户的相同理财产品数
--   请用一条SQL语句实现该查询：


with tmp0 as
(
    select pro_c_id,pro_pif_id
    from property
    where pro_type=1
    order by pro_c_id,pro_pif_id
),
tmp1 as (select * from tmp0),
tmp2 as (select * from tmp0),
tmp3 as
(
    select tmp1.pro_c_id as tmp1_pro_c_id,tmp2.pro_c_id as tmp2_pro_c_id
    from (tmp1 inner join tmp2 on tmp1.pro_pif_id=tmp2.pro_pif_id and tmp1.pro_c_id != tmp2.pro_c_id)
)

select tmp1_pro_c_id as pro_c_id,tmp2_pro_c_id as pro_c_id,count(*) as total_count
from tmp3
group by tmp1_pro_c_id,tmp2_pro_c_id
having count(*)>=2 
order by tmp1_pro_c_id;



-- select *
-- from tmp3
-- group by tmp1_pro_c_id,tmp2_pro_c_id
-- having count(*)>=2;
/*  end  of  your code  */
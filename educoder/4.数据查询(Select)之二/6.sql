 -- 6) 查找相似的理财客户
--   请用一条SQL语句实现该查询：


with tmp0 as
(
    select pro_c_id,pro_pif_id
    from property 
    where pro_type=1
    order by pro_c_id,pro_pif_id
),
tmp3 as 
(
    select tmp1.pro_c_id as pac,tmp1.pro_pif_id as paf,tmp2.pro_c_id as pbc,tmp2.pro_pif_id as pbf
    from (select * from tmp0) as tmp1 inner join (select * from tmp0) as tmp2 on tmp1.pro_c_id!=tmp2.pro_c_id and tmp1.pro_pif_id=tmp2.pro_pif_id
),
tmp4 as
(
select pac,pbc,count(*) as common,rank() over(partition by pac order by pbc) as crank
from tmp3
group by pac,pbc
order by pac
)
select *
from tmp4
where crank<=2
order by pac,pbc





/*  end  of  your code  */
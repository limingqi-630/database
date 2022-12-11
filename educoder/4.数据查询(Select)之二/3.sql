   -- 3) 查询购买了所有畅销理财产品的客户
--   请用一条SQL语句实现该查询：

with tmp0 as /*畅销理财产品*/
(
   select pro_pif_id
   from property 
   where pro_type=1
   group by pro_pif_id
   having count(*)>2
),
tmp1 as  /*购买了理财产品的用户集合*/
(
   select pro_c_id,pro_pif_id
   from property 
   where pro_type=1
   order by pro_c_id,pro_pif_id
),
tmp2 as
(
   select tmp0.pro_pif_id as tmp0_pro_pif_id,tmp1.pro_pif_id as tmp1_pro_pif_id,tmp1.pro_c_id
   from tmp0 left join tmp1 on tmp0.pro_pif_id=tmp1.pro_pif_id
)
select pro_c_id
from tmp2
group by pro_c_id
having count(*)=(select count(*) from tmp0);

/*  end  of  your code  */
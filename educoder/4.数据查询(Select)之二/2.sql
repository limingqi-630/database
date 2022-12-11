  -- 2) 投资积极且偏好理财类产品的客户
--   请用一条SQL语句实现该查询：

/*
购买了3种（同一编号的理财产品记为一种）以上理财产品的客户被认为投资积极的客户
该客户持有基金产品种类数（同一基金编号记为相同的基金产品种类）小于其持有的理财产品种类数*/
with tmp_finances_product as
(
select pro_c_id,count(*) as kind_of_finances_product
from property
where pro_type=1
group by pro_c_id
order by pro_c_id
),
tmp_fund as
(
select pro_c_id,count(*) as kind_of_fund
from property
where pro_type=3
group by pro_c_id
order by pro_c_id
)
select tmp_finances_product.pro_c_id as pro_c_id
from tmp_finances_product,tmp_fund
where tmp_finances_product.pro_c_id=tmp_fund.pro_c_id and kind_of_finances_product>3 and kind_of_finances_product>kind_of_fund
order by pro_c_id



/*  end  of  your code  */
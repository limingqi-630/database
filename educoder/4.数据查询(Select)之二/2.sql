  -- 2) Ͷ�ʻ�����ƫ��������Ʒ�Ŀͻ�
--   ����һ��SQL���ʵ�ָò�ѯ��

/*
������3�֣�ͬһ��ŵ���Ʋ�Ʒ��Ϊһ�֣�������Ʋ�Ʒ�Ŀͻ�����ΪͶ�ʻ����Ŀͻ�
�ÿͻ����л����Ʒ��������ͬһ�����ż�Ϊ��ͬ�Ļ����Ʒ���ࣩС������е���Ʋ�Ʒ������*/
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
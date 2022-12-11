 -- 1) ��ѯ�����ܶ�ǰ������Ʋ�Ʒ
--   ����һ��SQL���ʵ�ָò�ѯ��


with tmp as
(
select year(pro_purchase_time) as pyear,p_id,pro_quantity*p_amount as sumamount,
    rank() over(partition by year(pro_purchase_time) order by pro_quantity*p_amount desc) as rk
from finances_product,property
where pro_type=1 and (year(pro_purchase_time)=2010 or year(pro_purchase_time)=2011) and pro_pif_id=p_id
)
select pyear,rk,p_id,sumamount
from tmp
where rk<=3




/*  end  of  your code  */

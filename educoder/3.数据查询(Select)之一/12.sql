 -- 12) �ۺϿͻ���(client)���ʲ���(property)����Ʋ�Ʒ��(finances_product)�����ձ�(insurance)��
 --     �����(fund)���г��ͻ������ơ����֤���Լ�Ͷ���ܽ���Ͷ�ʱ���
 --     ÿ��Ͷ�ʽ��=��Ʒ����*�ò�Ʒÿ�ݽ��)��ע��Ͷ�ʽ�������Ҫ��ѯ��ͬ�ı�
 --     Ͷ���ܽ���ǿͻ�����ĸ����ʲ�(���,����,����)Ͷ�ʽ����ܺͣ��ܽ������Ϊtotal_amount��
 --     ��ѯ������ܽ�������
 -- ����һ��SQL���ʵ�ָò�ѯ��


with tmp1 as
(
    select pro_id,pro_c_id,pro_pif_id,pro_quantity,p_amount as price,pro_type
    from property,finances_product
    where pro_type=1 and pro_pif_id=p_id
),
tmp2 as
(
    select pro_id,pro_c_id,pro_pif_id,pro_quantity ,i_amount as price,pro_type
    from property,insurance
    where pro_type=2 and pro_pif_id=i_id
),
tmp3 as
(
    select pro_id,pro_c_id,pro_pif_id,pro_quantity ,f_amount,pro_type
    from property,fund
    where pro_type=3 and pro_pif_id=f_id 
),
tmp4 as 
(
    select * 
    from ((select * from tmp1) union (select * from tmp2) union (select * from tmp3)) as tmp4
),
tmp5 as
(
    select pro_c_id,sum(price*pro_quantity) as total_amount
    from tmp4
    group by pro_c_id
)

select c_name,c_id_card,ifnull(total_amount,0) as total_amount
from client left outer join tmp5 on c_id=pro_c_id
order by total_amount desc



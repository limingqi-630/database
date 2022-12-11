with tmp1 as(
    select pro_id,pro_c_id,pro_pif_id,pro_quantity,p_amount as price,pro_type
    from property,finances_product
    where pro_type=1 and pro_pif_id=p_id),/*��Ʋ�ƷͶ���ܶ�*/
tmp2 as(
    select pro_id,pro_c_id,pro_pif_id,pro_quantity ,i_amount as price,pro_type
    from property,insurance
    where pro_type=2 and pro_pif_id=i_id),/*����Ͷ���ܶ�*/
tmp3 as(
    select pro_id,pro_c_id,pro_pif_id,pro_quantity ,f_amount,pro_type
    from property,fund
    where pro_type=3 and pro_pif_id=f_id ),/*����Ͷ���ܶ�*/
tmp4 as (
    select * 
    from ((select * from tmp1) union (select * from tmp2) union (select * from tmp3)) as tmp4),
tmp5 as(
    select pro_c_id,sum(price*pro_quantity) as total_amount_5
    from tmp4
    group by pro_c_id), /*Ͷ���ܶ�*/
tmp6 as(
    select pro_c_id,sum(pro_income) as total_amount_6
    from property
    group by pro_c_id),/*Ͷ������*/
tmp7 as(
    select b_c_id,sum(b_balance) as total_amount_7
    from bank_card
    where b_type="���"
    group by b_c_id),/*������*/
tmp8 as(
    select b_c_id,sum(b_balance) as total_amount_8
    from bank_card
    where b_type="���ÿ�"
    group by b_c_id)/*���ÿ�͸֧���*/
select c_id,c_name,
(ifnull(total_amount_5,0)+ifnull(total_amount_6,0)+ifnull(total_amount_7,0)-ifnull(total_amount_8,0)) as total_property
from client 
    left outer join tmp5 on c_id=tmp5.pro_c_id 
    left outer join tmp6 on c_id=tmp6.pro_c_id 
    left outer join tmp7 on c_id=tmp7.b_c_id 
    left outer join tmp8 on c_id=tmp8.b_c_id
order by c_id


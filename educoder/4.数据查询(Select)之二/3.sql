   -- 3) ��ѯ���������г�����Ʋ�Ʒ�Ŀͻ�
--   ����һ��SQL���ʵ�ָò�ѯ��

with tmp0 as /*������Ʋ�Ʒ*/
(
   select pro_pif_id
   from property 
   where pro_type=1
   group by pro_pif_id
   having count(*)>2
),
tmp1 as  /*��������Ʋ�Ʒ���û�����*/
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
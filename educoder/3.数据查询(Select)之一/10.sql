select c_name,c_id_card,sum(pro_income) as total_income
from client,property
where c_id=pro_c_id and pro_status!="¶³½á"
group by pro_c_id
order by total_income desc
limit 3;


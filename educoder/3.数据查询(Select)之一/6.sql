select pro_income,count(pro_income) as presence
from property 
group by pro_income 
having count(pro_income)>=ALL(select count(pro_income) from property group by pro_income)
order by count(pro_income) DESC;

select c_id,c_name,count(b_type) as number_of_cards
from client  left outer join bank_card on client.c_id=bank_card.b_c_id
where c_name like "»Æ%"
group by c_name,c_id
order by number_of_cards desc,c_id;

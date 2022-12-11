select client.c_name,client.c_phone,bank_card.b_number 
from client,bank_card 
where (client.c_id=bank_card.b_c_id) && b_type='´¢Ðî¿¨' 
order by client.c_id ;
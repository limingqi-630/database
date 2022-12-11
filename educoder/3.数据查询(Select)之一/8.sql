
select c_name,c_id_card,c_phone
from client
where c_id in
(
    select c_id
    from client,bank_card
    where c_id=b_c_id and b_type="ĞÅÓÃ¿¨"
    group by c_id
    having count(*)>1
)
order by c_id;
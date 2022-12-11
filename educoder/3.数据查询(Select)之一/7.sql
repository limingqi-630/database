select c_name,c_phone,c_mail
from client
where c_id_card like '4201%'
    and not exists
        (
            select * 
            from property
            where  client.c_id=property.pro_c_id and pro_type=1
        )
order by c_id
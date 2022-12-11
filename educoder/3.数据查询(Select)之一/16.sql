select property1.pro_c_id as c_id1,property2.pro_c_id as c_id2 
from (select * from property where pro_type=3) as property1 
    inner join (select * from property where pro_type=3) as  property2 
    on (property1.pro_pif_id=property2.pro_pif_id and property1.pro_c_id < property2.pro_c_id) 
group by property1.pro_c_id,property2.pro_c_id
having count(*) = (select count(*) from property where pro_c_id=property1.pro_c_id and pro_type=3)
and count(*) = (select count(*) from property where pro_c_id=property2.pro_c_id and pro_type=3);


/*  end  of  your code  */
select insurance.i_id,insurance.i_amount
from insurance,(
                    select distinct i_amount 
                    from insurance 
                    order by i_amount desc 
                    limit 3,1
                ) as temp
where insurance.i_amount=temp.i_amount
order by i_id;
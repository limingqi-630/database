with tmp1 as
(
    select distinct b_c_id
    from bank_card
    where b_type='信用卡' and b_balance>5000
),
tmp2 as
(
    select b_c_id,sum(b_balance) as credit_card_amount
    from bank_card
    where b_type='信用卡'
    group by b_c_id
)
select tmp2.b_c_id,tmp2.credit_card_amount 
from tmp2,tmp1
where tmp2.b_c_id=tmp1.b_c_id
order by tmp2.b_c_id;
/*  end  of  your code  */


 
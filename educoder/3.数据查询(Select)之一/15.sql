-- (1) 基金总收益排名(名次不连续)
select pro_c_id,total_revenue,rank0 as `rank`
from(
    select pro_c_id,total_revenue,
        @cur_rank:=if(total_revenue=@pre_total_revenue,@cur_rank,@nxt_rank) as rank0,
        @nxt_rank:=@nxt_rank+1,
        @pre_total_revenue:=total_revenue
    from (select pro_c_id,sum(pro_income) as total_revenue
        from property
        where pro_type=3
        group by pro_c_id
        order by total_revenue desc,pro_c_id) as temp,
        (select @cur_rank:=1,@pre_total_revenue:=null,@nxt_rank:=1) as id
) as temp1;

-- (2) 基金总收益排名(名次连续)
select pro_c_id,total_revenue,
    case
        when total_revenue=@pre_total_revenue then @cur_rank
        when @pre_total_revenue:=total_revenue then @cur_rank:=@cur_rank+1
    end as `rank`
from (select pro_c_id,sum(pro_income) as total_revenue
    from property
    where pro_type=3
    group by pro_c_id
    order by total_revenue desc,pro_c_id) as temp,
    (select @cur_rank:=0,@pre_total_revenue:=null) as id;







/*  end  of  your code  */
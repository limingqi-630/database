use finance1;
update property
set pro_status="¶³½á"
where pro_c_id=(
    select c_id from client where c_phone="13686431238"
);


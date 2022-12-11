use finance1;
update property
set pro_id_card=(
    select c_id_card from client where c_id=pro_c_id
);

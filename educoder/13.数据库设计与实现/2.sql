 �����ERͼ�ļ���ŵ�URL:
 https://gitee.com/limingqihust/database/blob/master/ersolution.jpg
 ���¸�����ϵģʽ��

 
movie(movie_ID,title,type,runtime,release_date,director,starring),primary key:movie_ID
customer(c_ID,name,phone),primary key:c_ID
hall(hall_ID,mode,capacity,location),primary key:hall_ID
schedule(schedule_ID,date,time,price,number,schedule_hall_ID,schedule_movie_ID),primary key:(schedule_ID);foreign key:(schedule_hall_ID,schedule_movie_ID)
ticket(ticket_ID,seat_num,ticket_schedule_ID,ticket_c_ID),primary key:(ticket_ID);foreign key:(ticket_schedule_ID,ticket_c_ID)


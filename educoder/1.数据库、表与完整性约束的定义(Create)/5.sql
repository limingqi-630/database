# �������¿հ״���д����������䣬�հ��п�ͨ���س�������ӡ�
# ��Ҳ�����������д���������񣬲������������м������䲻�ᱻ���档

drop database MyDb;
create database MyDb;
use MyDb;

create table hr(
    id char(10) primary key,
    name varchar(32) NOT NULL,
    mz char(16) default ('����')
);


# ���� 
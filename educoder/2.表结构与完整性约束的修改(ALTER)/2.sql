use MyDb;

#请在以下空白处添加适当的SQL代码，实现编程要求
alter table orderDetail drop orderDate;
alter table orderDetail add unitPrice numeric(10,2);


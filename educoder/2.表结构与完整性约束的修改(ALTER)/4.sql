use MyDb;
alter table Staff add primary key(StaffNo);
alter table Dept add constraint FK_Dept_mgrStaffNo foreign key (mgrStaffNo) references Staff(staffNo);
alter table Staff add constraint FK_Staff_dept foreign key (dept) references Dept(deptNo);
alter table Staff add constraint CK_Staff_gender check(gender in ('F','M'));
alter table Dept add constraint UN_Dept_deptName unique(deptName);


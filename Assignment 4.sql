--Assignment Day4 –SQL:  Comprehensive practice
--Answer following questions
--1.	What is View? What are the benefits of using views?
--View is virtual table that contains from one or more tables. We can control security of accessing of the data. Also, it doesn’t hold any data and exist physically in the database, so we can save storage. 

--2.	Can data be modified through views?
--I can’t directly modify data in views 

--3.	What is stored procedure and what are the benefits of using it?
--Stored procedure is collection of sql statmenet and sql command logic that is compiled and stored on database. The main purpose is to minimize data traffic and improve performance of data operations such as select, update, delete data

--4.	What is the difference between view and stored procedure?
--View is simple showing data stored in the database tables whereas a Stored procedure is a group of statements that can be executed. 

--5.	What is the difference between stored procedure and functions?
--Functions must return a value whereas it is optional in Stored procedure. Also, Functions can have only input parameters for it whereas Procedures can have input or output parameters. 
--Procedure can be called Functions, but Functions cannot be called Procedures.

--6.	Can stored procedure return multiple result sets?
--Yes, most stored procedures return multiple result sets like including one or more select statements.

--7.	Can stored procedure be executed as part of SELECT Statement? Why?
--Stored procedures are typically executed with an EXEC statement, but we can execute a stored procedures implicitly from within a select statement, provided that the stored procedure returns a result set.

--8.	What is Trigger? What types of Triggers are there?
--Trigger is a set of actions that are performed in response to an insert, update, or delete operation on specified table. When sql operation is executed, the trigger is activated. It is optional and are defined using  CREATE trigger statement.

--9.	What is the difference between Trigger and Stored Procedure?
--A stored procedure is a user defined piece of code written in the local version of SQL, which may return a value as of function that is invoked by calling it explicitly. A trigger is a stored procedure that runs automatically when various events happen (eg update, insert, delete)

--Write queries for following scenarios
--Use Northwind database. All questions are based on assumptions described by the Database Diagram sent to you yesterday. When inserting, make up info if necessary. Write query for each step. Do not use IDE. BE CAREFUL WHEN DELETING DATA OR DROPPING TABLE.
--1.	Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
create view view_product_order_kim
as select p.productid, p.productname, sum(od.Quantity) quantitycount 
from products p inner join [order details] od on od.productid = p.productid
group by p.productid, p.productname

--2.	Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.
create proc sp_product_order_quantity_kim
(@product_id int,
@total_quantity float output)as
begin
select @product_id = p.productid
from products p
join [order details] od
on p.productid = od.productid
where sum(od.quantity) = @total_quantity
group by p.productid
end
--3.	Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
ALTER PROC sp_Product_Order_City_Kim
@ProductName NVARCHAR(50)
AS
BEGIN
SELECT TOP 5 ShipCity,SUM(Quantity) FROM [Order Details] OD JOIN Products P ON P.ProductID = OD.ProductID JOIN Orders O ON O.OrderID = OD.OrderID
WHERE ProductName=@ProductName
GROUP BY ProductName,ShipCity
ORDER BY SUM(Quantity) DESC
END
--4.	Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.

create table people_kim (id int, name char(20), cityid int)
create table city_kim (cityid int, city char(20))
insert into people_kim(id, name, cityid) values(1, 'Aaron Rodgers', 2)
insert into people_kim(id, name, cityid) values(2, 'Russell Wilson', 1)
insert into people_kim(id, name, cityid) values(3, 'Jody Nelson', 2)
insert into  city_kim(cityid, city) values(1, 'Settle')
insert into city_kim(cityid, city) values(2, 'Green Bay')

create view Packers_kim as
select * 
from people_kim k join city_kim c on k.cityid=c.cityid
where c.city = 'Green bay'

begin tran
rollback
drop table people_kim
drop table city_kim
drop view Packers_kim

--5.	 Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
ALTER PROC sp_birthday_employee_kim
AS
BEGIN
SELECT * INTO #EmployeeTemp
FROM Employees WHERE DATEPART(MM,BirthDate) = 02
SELECT * FROM #EmployeeTemp
END



--6.	How do you make sure two tables have the same data?
--I can store the total data with union and check, if the number of data for two tables is not same data, then it’s not same data.

--7.
--First Name	Last Name	Middle Name
--John	Green	
--Mike	White	M
--Output should be
--Full Name
--John Green
--Mike White M.
--Note: There is a dot after M when you output.
declare @fullname varchar(20)
select @fullname = firstname + lastname + middlename +'.' 
from people
print @fullname

--8.
--Student	Marks	Sex
--Ci	70	F
--Bob	80	M
--Li	90	F
--Mi	95	M
--Find the top marks of Female students.
--If there are to students have the max score, only output one.
declare @student varchar(20)
declare @marks int
set @student
set @marks = (select max(marks)from student where 
sex = 'F') 
print @student

--9.
--Student	Marks	Sex
--Li	90	F
--Ci	70	F
--Mi	95	M
--Bob	80	M
--How do you out put this?
declare @student varchar(20)
declare @marks int
set @student
set @marks = (select max(marks)from student where 
sex = 'F') 
print @student



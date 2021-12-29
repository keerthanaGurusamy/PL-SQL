set serveroutput on
create or replace package sales as
---Add product
procedure add_product(
pro_name products.product_name%type,
pro_desc products.description%type,
stan_cost products.standard_cost%type,
l_price products.list_price%type,
cat_id products.category_id%type,p_status out varchar2,p_error out varchar2);
---Remove product
procedure remove_prod(pro_id products.product_id%type,p_status out varchar2,p_error out varchar2);
---Add Employees
 PROCEDURE add_employees(
   emp_fname employees.first_name%type,
   emp_lname employees.last_name%type,
   emp_mail employees.email%type,
   emp_ph employees.phone%type,
   emp_hire employees.hire_date%type,
   emp_mid employees.manager_id%type,
   emp_job employees.job_title%type,emp_status out varchar2,emp_error out varchar2);
   --remove employees
   PROCEDURE remove_employees(emp_id employees.employee_id%type,emp_status out varchar2,emp_error out varchar2);
    --add customer
   PROCEDURE add_customer(
   cus_name customers.name%type,
   cus_ad customers.address%type,
   cus_website customers.website%type,
   cus_limit customers.credit_limit%type,cus_status out varchar2,cus_error out varchar2);
  --remove customer
  PROCEDURE remove_customer(cus_id customers.customer_id%type,cus_status out varchar2,cus_error out varchar2);
   --Add orders
  PROCEDURE add_orders(
  cus_id in number,odr_status in varchar2,s_id in number,
  odr_date in date,status out varchar2,or_error out varchar2);
 --Cancel orders
  PROCEDURE cancel_order(odr_id in number,status out varchar2,or_error out varchar2);
--Add order_items
 PROCEDURE add_order_items(odr_id in number,i_id in number ,p_id in number,quan in number,u_price in number,status out varchar2,or_error out varchar2);
--Delete order_items
 PROCEDURE remove_order_items(odr_id in number,status out varchar2,or_error out varchar2);
---Add category
PROCEDURE add_category(ca_id in number,ca_name in varchar2,c_status out varchar2,c_error out varchar2);
---Remove category
PROCEDURE remove_category(ca_id in number,c_status out varchar2,c_error out varchar2);
end sales;


create or replace package body sales as
procedure add_product(
pro_name products.product_name%type,
pro_desc products.description%type,
stan_cost products.standard_cost%type,
l_price products.list_price%type,
cat_id products.category_id%type,
p_status out varchar2,p_error out varchar2)
is
BEGIN
insert into products(product_name,description,standard_cost,list_price,category_id)
values(pro_name,pro_desc,stan_cost,l_price,cat_id);
if sql%rowcount>0
then p_status:='Product inserted';
end if;
commit;
EXCEPTION
when others then
p_status:='product not inserted';
p_error:=sqlcode||sqlerrm;
END add_product;

PROCEDURE remove_prod(pro_id  products.product_id%type,p_status out varchar2,p_error out varchar2) IS 
   BEGIN 
      delete from products
      where product_id = pro_id;
      if sql%rowcount>0
      then p_status:='product'||pro_id||'Deleted';
      end if;
      if sql%rowcount=0
      then p_status:='product'||pro_id||'not deleted';
      end if;
      commit;
       EXCEPTION
       when others then
       p_status:='no data found';
       p_error:=sqlcode||sqlerrm;
 end remove_prod;
 
 ---ADD EMPLOYEES

PROCEDURE add_employees(
   emp_fname employees.first_name%type,
   emp_lname employees.last_name%type,
   emp_mail employees.email%type,
   emp_ph employees.phone%type,
   emp_hire employees.hire_date%type,
   emp_mid employees.manager_id%type,
   emp_job employees.job_title%type,emp_status out varchar2,emp_error out varchar2)
IS
BEGIN
     INSERT INTO employees(first_name,last_name,email,phone,hire_date,manager_id,job_title)
     VALUES(emp_fname,emp_lname,emp_mail,emp_ph,emp_hire,emp_mid,emp_job);
     if sql%rowcount>0
         then emp_status:='employee inserted';
         end if;
         commit;
         EXCEPTION
         when others then
         emp_status:='employee not inserted';
         emp_error:=sqlcode||sqlerrm;
END add_employees;
PROCEDURE remove_employees(emp_id employees.employee_id%type,emp_status out varchar2,emp_error out varchar2)IS
  BEGIN
      DELETE FROM employees WHERE employee_id=emp_id;
      if sql%rowcount>0
         then emp_status:='Employee'||emp_id||'delteded';
         end if;
        if sql%rowcount=0
        then emp_status:='Employee id'||emp_id||'not found';
        end if;
         commit;
         EXCEPTION
         when no_data_found then
         DBMS_OUTPUT.PUT_LINE('employee id does not found');
         when others then
         emp_status:='not deleted';
         emp_error:=sqlcode||sqlerrm;
  END remove_employees;
---Add Customer
 PROCEDURE add_customer(
   cus_name customers.name%type,
   cus_ad customers.address%type,
   cus_website customers.website%type,
   cus_limit customers.credit_limit%type,cus_status out varchar2,cus_error out varchar2)IS
   BEGIN
   INSERT INTO customers(name,address,website,credit_limit )
   VALUES(cus_name,cus_ad,cus_website,cus_limit);
   if sql%rowcount>0
         then cus_status:='customer is inserted';
         end if;
         commit;
         EXCEPTION
         when others then
         cus_status:='customer is not inserted';
         cus_error:=sqlcode||sqlerrm;
   END add_customer;
   
   PROCEDURE remove_customer(cus_id customers.customer_id%type,cus_status out varchar2,cus_error out varchar2)IS
   BEGIN
   DELETE FROM customers WHERE customer_id=cus_id;
   if sql%rowcount>0
         then cus_status:='customer'||cus_id||'is deleted';
         end if;
          if sql%rowcount=0
        then cus_status:='customer'||cus_id||'is not found';
        end if;
         commit;
         EXCEPTION
         when others then
         cus_status:='not found';
         cus_error:=sqlcode||sqlerrm;
   END remove_customer;
---Add orders
 PROCEDURE add_orders(
 cus_id in number,odr_status in varchar2,s_id in number,
 odr_date in date,status out varchar2,or_error out varchar2)
 IS
 BEGIN
 INSERT INTO orders(customer_id ,status ,salesman_id ,order_date)
 VALUES(cus_id,odr_status,s_id,odr_date);
 if sql%rowcount>0
         then status:='order inserted';
         end if;
         commit;
         EXCEPTION
         when others then
         status:='order not inserted';
         or_error:=sqlcode||sqlerrm;
 END add_orders;
 
 PROCEDURE cancel_order(odr_id in number,status out varchar2,or_error out varchar2) IS
 BEGIN
 UPDATE orders SET status='cancelled' where order_id=odr_id;
 if sql%rowcount>0
         then status:='Order'||odr_id||'cancelled';
         end if;
         if sql%rowcount=0
        then status:='Order'||odr_id||'not found';
        end if;
        commit;
         EXCEPTION
         when others then
         status:='not cancelled';
         or_error:=sqlcode||sqlerrm;
 END cancel_order;
--Add Order Items
 PROCEDURE add_order_items(odr_id in number,i_id in number ,p_id in number,quan in number,u_price in number,status out varchar2,or_error out varchar2)
IS
BEGIN
 INSERT INTO order_items(order_id ,item_id ,product_id ,quantity ,unit_price)
 values(odr_id,i_id,p_id,quan,u_price);
 if sql%rowcount>0
         then status:='Order item'||odr_id||'inserted';
         end if;
         commit;
         EXCEPTION
         when others then
         status:='Order item'||odr_id||'not inserted';
         or_error:=sqlcode||sqlerrm;
 END add_order_items;
---Remove Order Items
PROCEDURE remove_order_items(odr_id in number,status out varchar2,or_error out varchar2)IS
  BEGIN
   DELETE FROM order_items WHERE order_id=odr_id;
   if sql%rowcount>0
         then status:='Order item'||odr_id||'deleted';
         end if;
          if sql%rowcount=0
        then status:='Order item'||odr_id||'not found';
        end if;
         commit;
         EXCEPTION
         when others then
         status:='not deleted';
         or_error:=sqlcode||sqlerrm;
   END remove_order_items;
---Add category
PROCEDURE add_category(ca_id in number,ca_name in varchar2,c_status out varchar2,c_error out varchar2)
IS
BEGIN
INSERT INTO category(category_id,category_name)values(ca_id,ca_name);
if sql%rowcount>0
  then c_status:='Category '||ca_id||'Inserted';
  end if;
  commit;
  EXCEPTION
  when others then
  c_status:='Category '||ca_id||'not inserted';
  c_error:=sqlcode||sqlerrm;
END add_category;

---Remove category
PROCEDURE remove_category(ca_id in number,c_status out varchar2,c_error out varchar2)
IS
BEGIN
DELETE from category where category_id=ca_id;
if sql%rowcount>0
  then c_status:='Category id '|| ca_id || 'deleted' ;
  end if;
if sql%rowcount=0
  then c_status:='Category id '|| ca_id || ' not found';
  end if;
  commit;
EXCEPTION
when others then
c_status:='not deleted';
c_error:=sqlcode||sqlerrm;
END remove_category;
end sales;

--Add product
DECLARE
p_status varchar2 (100);
p_error varchar2(500);
BEGIN
sales.add_product('boat SmartWatch','watch',2500,3000,20,p_status,p_error);
dbms_output.put_line(p_status||''||p_error);
end add_product;

--Delete product
DECLARE 
 pro_id products.product_id%type:=&enter_id;
 p_status varchar2(200);
 p_error varchar2(500);
 BEGIN
sales.remove_prod(pro_id,p_status,p_error);
 dbms_output.put_line(p_status||''||p_error);
 end remove_prod;

--Add employee
DECLARE
emp_status varchar2 (100);
emp_error varchar2(500);
BEGIN
sales.add_employees('karhtick','gurusamy','karthi.guru@gmail.com','9042927438','01-10-2011','M11','sales',emp_status,emp_error);
dbms_output.put_line(emp_status||''||emp_error);
end add_employees;

---Delete employee
DECLARE 
 emp_id employees.employee_id%type:=&enter_id;
 emp_status varchar2(200);
 emp_error varchar2(500);
 BEGIN
sales.remove_employees(emp_id,emp_status,emp_error);
 dbms_output.put_line(emp_status||''||emp_error);
 end remove_employees;

---Add customer
DECLARE
cus_status varchar2 (100);
cus_error varchar2(500);
BEGIN
sales.add_customer('pavithra','12,Arupukottai','www.amazon.in',5000,cus_status,cus_error);
dbms_output.put_line(cus_status||''||cus_error);
end add_customer;

---Delete Customer
DECLARE 
 cus_id customers.customer_id%type:=&enter_id;
 cus_status varchar2(200);
 cus_error varchar2(500);
 BEGIN
sales.remove_customer(cus_id,cus_status,cus_error);
 dbms_output.put_line(cus_status||''||cus_error);
 end remove_customer;

--ADD orders
DECLARE
    status varchar2(30);
    or_error varchar2(300);
BEGIN
    sales.add_orders(203, 'delevered',220,'28-12-2021',status,or_error);
    dbms_output.put_line(status||' '||or_error);
end add_orders;
--cancel orders
DECLARE
    odr_id integer:=&Enter_odr_id;
    status varchar2(200);
    or_error varchar2(500);
BEGIN
    sales.cancel_order(odr_id,status,or_error);
    dbms_output.put_line(status||' '||or_error);
end cancel_order;
---Add Order Items
DECLARE
    status varchar2(200);
    or_error varchar2(300);
BEGIN
    sales.add_order_items(30,10, 100, 2, 3000,status,or_error);
     dbms_output.put_line(status||' '||or_error);
end add_order_items;
---Remove Order Items
DECLARE
    odr_id integer:=&Enterodr_id;
    status varchar2(200);
    or_error varchar2(300);
BEGIN
    sales.remove_order_items(odr_id,status,or_error);
          dbms_output.put_line(status||' '||or_error);
end remove_order_items;

---Add category
DECLARE
  c_status varchar2(200);
  c_error varchar2(300);
BEGIN
  sales.add_category(30,'electronics',c_status,c_error);
  dbms_output.put_line(c_status||' '||c_error);
end add_category;

---Remove category
DECLARE
  ca_id number:=&enter_ca_id;
  c_status varchar2(200);
  c_error varchar2(300);
BEGIN
  sales.remove_category(ca_id,c_status,c_error);
  dbms_output.put_line(c_status||' '||c_error);
end remove_category;


-------------------------------
select * from products;
select * from employees;
select * from customers;
select * from orders;
select * from order_items;
select * from category;

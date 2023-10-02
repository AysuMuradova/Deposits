ALTER SESSION SET "_oracle_script"=TRUE;

CREATE USER aysu_muradova1 IDENTIFIED BY aysu; --Creating user

GRANT CREATE SESSION TO aysu_muradova1;
GRANT CREATE TABLE TO aysu_muradova1;
GRANT UNLIMITED TABLESPACE TO aysu_muradova1;        --Grant of privileges
GRANT CREATE PROCEDURE TO aysu_muradova1;
GRANT CREATE TRIGGER TO aysu_muradova1;
GRANT CREATE job TO aysu_muradova1;
GRANT ALL PRIVILEGES TO aysu_muradova1;


-----------------------------------------------------------


                                               SAVINGS
-- Creating customer table                                                
CREATE TABLE customers_d(CUSTOMER_NO NUMBER PRIMARY KEY,  -- primary key 
                         CUSTOMER_TYPE VARCHAR2(1),
                         FULL_NAME VARCHAR2(300),             
                         ADDRESS_LINE VARCHAR2(300),--First,Second,Third Normal Form
                         COUNTRY VARCHAR2(300),     
                         LANGUAGE VARCHAR2(300));
                         
--Creating branches table
CREATE TABLE branches_d (BRANCH_ID NUMBER PRIMARY KEY, --primary key
                         BRANCH_DESCR VARCHAR2(300));                        
                         
--Creating currency table
CREATE TABLE currency_d (curr_id VARCHAR2(3),
                         curr_code NUMBER PRIMARY KEY); --primary key                        
 
--Creating products table
CREATE TABLE products ( product_id NUMBER PRIMARY KEY, --primary key
                        product_name VARCHAR2(200),
                        min_amount NUMBER,
                        max_amount NUMBER,
                        min_term NUMBER,
                        max_term NUMBER,
                        curr_code NUMBER REFERENCES currency_d(curr_code) ,
                        interest_rate NUMBER); 
                                                
-- Creating deposits table
CREATE TABLE deposits (deposit_id NUMBER PRIMARY KEY, -- primary key
                       cif NUMBER REFERENCES customers_d(CUSTOMER_NO),
                       product_id NUMBER REFERENCES products(product_id) ,
                       contract_date DATE,
                       deadline DATE, 
                       amount NUMBER,
                       curr_code NUMBER REFERENCES currency_d(curr_code),
                       BRANCH_ID NUMBER  REFERENCES branches_d(BRANCH_ID));
                       
                         
                                                             
-- Creating İndex 

CREATE INDEX dep_date ON deposits(contract_date);
CREATE INDEX dep_deadli ON deposits(deadline);
------------------------------------------------------
                                           
                         
/*1.Ümumi bir package yaradın. 
Bu package-də qeyd edilən cədvəllərin hər birinə insert edən prosedurlar yazın və 
insertlərinizi bu prosedurlar vasitəsilə icra edin.*/

--Creating specifications
CREATE OR REPLACE PACKAGE insert_data IS   
PROCEDURE insert_customer(
    p_customer_no NUMBER,
    p_customer_type VARCHAR2,
    p_full_name VARCHAR2,
    p_address_line VARCHAR2,
    p_country VARCHAR2,
    p_language VARCHAR2);
    
PROCEDURE insert_branch(
    p_branch_id NUMBER,
    p_branch_descr VARCHAR2
); 
PROCEDURE insert_currency(
    p_curr_id VARCHAR2,
    p_curr_code NUMBER
);  
PROCEDURE insert_product(
    p_product_id NUMBER,
    p_product_name VARCHAR2,
    p_min_amount NUMBER,
    p_max_amount NUMBER,
    p_min_term NUMBER,
    p_max_term NUMBER,
    p_curr_code NUMBER,
    p_interest_rate NUMBER
);

 
PROCEDURE insert_deposit(
    p_deposit_id NUMBER,
    p_cif NUMBER,
    p_product_id NUMBER,
    p_contract_date DATE,
    p_deadline DATE,
    p_amount NUMBER,
    p_curr_code NUMBER,
    p_BRANCH_ID NUMBER
);
END;

--Creating PACKAGE body
CREATE OR REPLACE PACKAGE BODY insert_data IS
PROCEDURE Insert_Customer (
    p_CUSTOMER_NO NUMBER,
    p_CUSTOMER_TYPE VARCHAR2,
    p_FULL_NAME VARCHAR2,
    p_ADDRESS_LINE VARCHAR2,
    p_COUNTRY VARCHAR2,
    p_LANGUAGE VARCHAR2)
AS
BEGIN
    INSERT INTO customers_d (
        CUSTOMER_NO,
        CUSTOMER_TYPE,
        FULL_NAME,
        ADDRESS_LINE,
        COUNTRY,
        LANGUAGE )
    VALUES (
        p_CUSTOMER_NO,
        p_CUSTOMER_TYPE,
        p_FULL_NAME,
        p_ADDRESS_LINE,
        p_COUNTRY,
        p_LANGUAGE);
    
    COMMIT; 
END;
PROCEDURE insert_branch(
    p_branch_id NUMBER,
    p_branch_descr VARCHAR2
)
AS
BEGIN
    INSERT INTO branches_d (BRANCH_ID, BRANCH_DESCR)
    VALUES (p_branch_id, p_branch_descr);
    
    COMMIT; 
END;
PROCEDURE insert_currency(
    p_curr_id VARCHAR2,
    p_curr_code NUMBER
)
AS
BEGIN
    INSERT INTO currency_d (curr_id, curr_code)
    VALUES (p_curr_id, p_curr_code);
    
    COMMIT; 
END;
PROCEDURE insert_product(
    p_product_id NUMBER,
    p_product_name VARCHAR2,
    p_min_amount NUMBER,
    p_max_amount NUMBER,
    p_min_term NUMBER,
    p_max_term NUMBER,
    p_curr_code NUMBER,
    p_interest_rate NUMBER
)
AS
BEGIN
    INSERT INTO products (
        product_id,
        product_name,
        min_amount,
        max_amount,
        min_term,
        max_term,
        curr_code,
        interest_rate
    ) VALUES (
        p_product_id,
        p_product_name,
        p_min_amount,
        p_max_amount,
        p_min_term,
        p_max_term,
        p_curr_code,
        p_interest_rate
    );
    
    COMMIT; 
END;


PROCEDURE insert_deposit(
    p_deposit_id NUMBER,
    p_cif NUMBER,
    p_product_id NUMBER,
    p_contract_date DATE,
    p_deadline DATE,
    p_amount NUMBER,
    p_curr_code NUMBER,
    p_BRANCH_ID NUMBER
)
AS
BEGIN 
    INSERT INTO deposits (
        deposit_id,
        cif,
        product_id,
        contract_date,
        deadline,
        amount,
        curr_code,
        BRANCH_ID
    ) VALUES (
        p_deposit_id,
        p_cif,
        p_product_id,
        p_contract_date,
        p_deadline,
        p_amount,
        p_curr_code,
        p_BRANCH_ID
    );
    
    COMMIT;
END;
END;   

--Package calling
BEGIN
insert_data.insert_customer(p_customer_no   => 5973066,
                            p_customer_type =>'F' ,
                            p_full_name     =>'Residov Vuqar' ,
                            p_address_line =>'BAKI SHAHARI SURAXANI RAYONU' ,
                            p_country       =>NULL ,
                            p_language      =>'TYR' );
                          
insert_data.insert_branch(p_branch_id => 4, p_branch_descr => 'Mingecevir Filiali');                   
insert_data.insert_currency(p_curr_id => 'RUB', p_curr_code =>643 );
                        
insert_data.insert_product(p_product_id    =>205,
                           p_product_name  =>n'Qənaət' ,
                           p_min_amount    => 1200,
                           p_max_amount    => 1800,
                           p_min_term      => 13,
                           p_max_term      => 36 ,
                           p_curr_code      =>944,
                           p_interest_rate => 6);                          
 
insert_data.insert_deposit(p_deposit_id    =>105 ,
                           p_cif           =>5973066 ,
                           p_product_id    => 205,
                           p_contract_date => to_date('23.01.2020','dd.mm.yyyy'),
                           p_deadline      => to_date('23.01.2013','dd.mm.yyyy'),
                           p_amount        => 1300,
                           p_curr_code     => 944,
                           p_BRANCH_ID     => 4) ;
                         
END;

SELECT * FROM customers_d ;
SELECT * FROM products FOR UPDATE;
SELECT * FROM deposits;
SELECT * FROM branches_d;
SELECT * FROM currency_d;



/*2.Müştərinin qoyduğu məbləğə və term-ə əsasən ona faiz təyin edən
və bu faizi ekrana çıxaran prosedur qurun. 
Həmin faizləri yaratdığınız məhsul cədvəlinə əsasən təyin edin. 
Yəni məhsul cədvəlində müddət valuta və məbləğ aralığına görə faizlər saxlanılsın.*/


--Creating Function



CREATE OR REPLACE TYPE InterestList AS TABLE OF NUMBER;

CREATE OR REPLACE FUNCTION get_all_interest(
    p_amount NUMBER,
    p_term NUMBER,
    p_currency VARCHAR2
)
RETURN InterestList
AS
    v_interests InterestList := InterestList();
BEGIN
    SELECT interest_rate BULK COLLECT INTO v_interests
    FROM products p
    WHERE p.curr_code = (SELECT d.curr_code FROM currency_d d WHERE d.curr_id = p_currency)
      AND p_amount BETWEEN p.min_amount AND p.max_amount
      AND p_term BETWEEN p.min_term AND p.max_term;
      
    RETURN v_interests;
END;

DECLARE
    v_interests InterestList;
BEGIN
    v_interests := get_all_interest(p_amount => 1400, p_term => 14, p_currency => 'AZN');
    
    FOR i IN 1..v_interests.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Interest ' || i || ': ' || v_interests(i));
    END LOOP;
END;



/*3. 2 eyniadlı prosedur yaradın  OVERLOADING-dən istifade edin.Prosedurlardan birinə əgər müqavilə 
id-si ötürülürsə onda ekrana müştərinin sonda alacağı faiz məbləği ekrana çıxsın. 
Digər prosedurda isə parameter ötürülməsin və avtomatik olaraq cari gün üzrə müqavilə 
açan müştərilərin alacağı faiz məbləği cədvəldə saxlanılsın*/


ALTER TABLE deposits ADD interest_amount NUMBER; -- cedvelde saxlanilma ucun sutun

CREATE OR REPLACE PACKAGE interest_amount IS
PROCEDURE interest_amount(deposit_no NUMBER,
                          int_amo OUT NUMBER);
PROCEDURE interest_amount;
END;

CREATE OR REPLACE PACKAGE BODY interest_amount IS
PROCEDURE interest_amount(deposit_no NUMBER,
                          int_amo OUT NUMBER) IS
BEGIN 
SELECT TRUNC((d.amount/100)*((SELECT p.interest_rate 
FROM products p WHERE p.product_id=d.product_id))/12 * MONTHS_between(d.deadline,d.contract_date))
INTO int_amo
FROM deposits d WHERE deposit_no=d.deposit_id ;
DBMS_OUTPUT.PUT_LINE('Interest amount: ' ||int_amo );
END;                                      
PROCEDURE interest_amount IS
BEGIN
  UPDATE deposits dp
  SET dp.interest_amount = (
    SELECT (dp.amount / 100) * (p.interest_rate / 12)
           * MONTHS_BETWEEN(dp.deadline, dp.contract_date)
    FROM products p
    WHERE p.product_id = dp.product_id
  )
  WHERE dp.contract_date = TRUNC(SYSDATE);

  DBMS_OUTPUT.PUT_LINE('Interest amounts have been updated.');
END;
END;


SELECT * FROM deposits;
SELECT * FROM products;


DECLARE
result_ NUMBER;
BEGIN
    interest_amount.interest_amount(deposit_no => 101, int_amo => result_);
END;

BEGIN
 interest_amount.interest_amount;
END; 

/*4.Bir funksiya yaradın və funksiya ekrana müştəri gəlib pulunu götürmək
istədikdə ona nə qədər pul ödənəcək onu hesablasın. Əgər müştəri müqavilənin 
vaxtı bitdikdən sonra gəlibsə o zaman öz pulunu və alacağı bütün faiz məbləği ekrana çıxmalıdır.
Əgər vaxtı bitməmiş gəlibsə o zaman öz pulunu və faizlə alacağı məbləğin 1 faizi ekrana çıxmalıdır. 
Bazada funksiyaya ötürülən argumentə uyğun data yoxdursa 
ekrana error qaytarın və həmin datanı exception_data cədvəlinə insert edin.*/



CREATE TABLE dep_cus_date (dep_id NUMBER REFERENCES deposits(deposit_id),
                           cif NUMBER REFERENCES customers_d(customer_no),
                           date_of_take_amount DATE); -- Entity

--burada musterinin gelib pulu goturme tarixi update ile yenilenir

CREATE TABLE exception_data (err_id NUMBER,
                             err_msg VARCHAR2(400));

SELECT * FROM exception_data FOR UPDATE;
-- Creating Function
                            
CREATE OR REPLACE FUNCTION calculate_payment (
    v_dep_id NUMBER,
    v_date_of_take_amount DATE
)
RETURN NUMBER
IS
    v_payment_amount NUMBER;
    v_deadline DATE; 
    except_code VARCHAR2(200);
    except_msg VARCHAR2(2000);
BEGIN
    SELECT d.deadline
    INTO v_deadline
    FROM deposits d
    WHERE d.deposit_id = v_dep_id;

    IF v_date_of_take_amount > v_deadline THEN
        SELECT (d.amount/100)*((SELECT p.interest_rate
                                FROM products p
                                WHERE p.product_id = d.product_id))/12
               * MONTHS_between(d.deadline,d.contract_date) + d.amount
        INTO v_payment_amount
        FROM deposits d
        WHERE d.deposit_id = v_dep_id;

        DBMS_OUTPUT.PUT_LINE('Customer should receive: ' || v_payment_amount);
    ELSE
        SELECT ((d.amount / 100) *
                ((SELECT p.interest_rate
                    FROM products p
                    WHERE p.product_id = d.product_id)) / 12 *
                MONTHS_between(d.deadline, d.contract_date))/100*1 +d.amount INTO v_payment_amount
        FROM deposits d
        WHERE d.deposit_id = v_dep_id;

        DBMS_OUTPUT.PUT_LINE('Customer should receive: ' || v_payment_amount);
    END IF;

    RETURN v_payment_amount;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error1.');
        except_code:=SQLCODE;
        except_msg:=SQLERRM;
        INSERT INTO exception_data(err_id, err_msg) VALUES (except_code,except_msg);
        COMMIT;
END;                            
         


                    
SELECT calculate_payment(v_dep_id => 101, v_date_of_take_amount =>to_date('30.09.2019','dd.mm.yyyy') ) 
FROM dual;

BEGIN
  dbms_output.put_line( calculate_payment(v_dep_id => 12, v_date_of_take_amount =>to_date('30.09.2019','dd.mm.yyyy')));
  END;


/*5.Depozitlərin prolongasiyasını yəni uzadılmasını təyin edən prosedur qurun və bu proseduru 
job vasitəsilə hər gün axşam saat 10-da işə salın. Prolongasiya prosesinin işləmə məntiqi belədir-
Müştəri əgər müqavilənin bitmə günündə müştəri gəlib məbləği götürmürsə o zaman müştərinin əsas 
məbləği alacağı faizlə cəmlənərək və müqavilənin başlama və bitmə vaxtı  update edilsin. 
Məsələn-1000 azn məbləğ qoymuşdur müştəri və bu müqavilənin başlama vaxtı 24.01.2023-dür və 
bitmə vaxtı 24.06.2023-dür. Və müqavilənin faizi 5 faizdir.
Müştəri 25.06.2023 tarixində məbləği götürmürsə o zaman depozit prolongasiya olacaq
yəni başlama tarixi 24.06.2023 və bitmə vaxtı 24.01.2024 olacaq. 
Məbləğ isə 1000 deyil də 1000+1000*5/100=1050 olacaq.*/

SELECT * FROM deposits FOR UPDATE

CREATE TABLE dep_cus_date (dep_id NUMBER REFERENCES deposits(deposit_id),
                           cif NUMBER REFERENCES customers_d(customer_no),
                           date_of_take_amount DATE);

CREATE OR REPLACE PROCEDURE Prolongation(dep_no NUMBER) IS
p_deadline DATE;                                         
BEGIN
  SELECT d. deadline INTO p_deadline  FROM deposits d WHERE d.deposit_id=dep_no;
    IF  SYSDATE =p_deadline+1  THEN
        UPDATE deposits a 
        SET a.amount = a.amount + (a.amount * 
                                   (SELECT p.interest_rate 
                                    FROM products p 
                                    WHERE p.product_id = a.product_id) / 100),           
               a.deadline = ADD_MONTHS(a.deadline, MONTHS_between(a.deadline,a.contract_date))
,a.contract_date = a.deadline 
        WHERE a.deposit_id = dep_no;
        
        DBMS_OUTPUT.PUT_LINE('Prolongation occurred.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Prolongation did not occur!');
    END IF;
END; 

BEGIN
Prolongation(dep_no => 105); 
  END;
  
  
-- Creating job

BEGIN 
  dbms_scheduler.create_job(job_name            => 'update_data',
                            job_type            => 'plsql_block',
                            job_action          => 'BEGIN Prolongation; end; ',
                            repeat_interval     => 'freq=daily; BYHOUR=20',
                            enabled             =>  TRUE ,
                            auto_drop           =>  FALSE) ;
END;


/*Cədvəldə update olan zaman trigger işə düşsün və köhnə məlumatları arxiv cədvəlində loglasın.*/
-- creating trigger

CREATE TABLE archive_table(user_name VARCHAR2(200),
                           change_date DATE,
                           old_amount NUMBER,
                           new_amount NUMBER,
                           old_deadline DATE,
                           new_deadline DATE,
                           old_contract_date DATE,
                           new_contract_date DATE);


CREATE OR REPLACE TRIGGER archiving
BEFORE UPDATE OR DELETE
ON deposits FOR EACH ROW
BEGIN
  INSERT INTO archive_table VALUES(USER,SYSDATE,:old.amount,:new.amount,:OLD.deadline,
  :NEW.deadline,:OLD.contract_date,:NEW.contract_date);
END;

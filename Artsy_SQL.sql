DROP DATABASE artsy;
CREATE DATABASE IF NOT EXISTS artsy;
USE artsy;

CREATE TABLE IF NOT EXISTS customer (
CUST_ID INT AUTO_INCREMENT PRIMARY KEY,
FIRST_NAME VARCHAR(25) NOT NULL,
LAST_NAME VARCHAR(50) NOT NULL,
AGE TINYINT NOT NULL,
EMAIL VARCHAR(75),
PHONE_NUMBER INT(13),
AREA_ID int,
LOCATION_ID INT);

CREATE TABLE IF NOT EXISTS location (
LOCATION_ID INT auto_increment primary key NOT NULL,
STREET_ADDRESS VARCHAR(50) NOT NULL,
CITY varchar(40) NOT NULL,
AREA_ID INT,
STATE_PROVINCE varchar(40) NOT NULL,
ZIP_CODE INT(12) NOT NULL,
COUNTRY_NAME varchar(40),
COUNTRY_ID varchar(3) DEFAULT 'NaN' NOT NULL);

CREATE TABLE IF NOT EXISTS product (
PRODUCT_ID INT auto_increment NOT NULL primary key,
PRODUCT_NAME varchar(50) NOT NULL,
INVOICE_ID INT,
PRODUCT_PRICE DECIMAL (10,2) NOT NULL,
ARTSY_FEE DECIMAL (5,2) DEFAULT 005.00,
PRODUCT_DESC varchar(150) default NULL);

CREATE TABLE IF NOT EXISTS seller (
SELLER_ID INT auto_increment primary key NOT NULL,
ARTSY_FEE DECIMAL (5,2) DEFAULT 005.00,
FIRST_NAME VARCHAR(25) NOT NULL,
LAST_NAME VARCHAR(50) NOT NULL,
AGE TINYINT,
EMAIL VARCHAR(75) NOT NULL,
PHONE_NUMBER bigint UNSIGNED,
LOCATION_ID INT);


CREATE TABLE IF NOT EXISTS subscription (
SUB_ID INT auto_increment NOT NULL primary key,
CUST_ID INT NOT NULL,
SELLER_ID INT NOT NULL,
INVOICE_ID INT NOT NULL,
ARTSY_FEE DECIMAL (5,2) DEFAULT 005.00,
SUB_FEE DECIMAL (6,2) DEFAULT 0001.00,
KEY (SELLER_ID)
);

CREATE TABLE IF NOT EXISTS seller_rating (
RATING_ID INT auto_increment NOT NULL,
CUST_ID INT NOT NULL,
SELLER_ID INT NOT NULL,
PRODUCT_ID INT NOT NULL,
RATING_TS DATETIME DEFAULT NOW(),
P_RATING TINYINT(5) DEFAULT NULL,
COMMENTS varchar(150) DEFAULT NULL,
PRIMARY KEY (RATING_ID, SELLER_ID));

CREATE TABLE IF NOT EXISTS sub_rating (
S_RATING_ID INT auto_increment NOT NULL,
CUST_ID INT NOT NULL,
SELLER_ID INT NOT NULL,
SUB_ID INT NOT NULL,
S_RATING TINYINT(5) DEFAULT NULL,
COMMENTS varchar(150) DEFAULT NULL,
S_RATING_TS DATETIME DEFAULT NOW(),
PRIMARY KEY (S_RATING_ID, SELLER_ID));

CREATE TABLE notification (
  notification_id tinyint(10) unsigned NOT NULL AUTO_INCREMENT primary key,
  sent tinyint(1) unsigned NOT NULL);

CREATE TABLE IF NOT EXISTS country (
COUNTRY_ID VARCHAR(3) NOT NULL primary key DEFAULT 'NaN',
COUNTRY_NAME VARCHAR(50) NOT NULL,
STATE_PROVINCE varchar(40),
AREA_ID INT NOT NULL);

CREATE TABLE IF NOT EXISTS area (
AREA_ID INT auto_increment NOT NULL primary key,
AREA_NAME varchar(25));

CREATE TABLE IF NOT EXISTS stock ( #if it applies
PRODUCT_ID INT NOT NULL,
QUANTITY TINYINT NOT NULL,
SELLER_ID INT NOT NULL,
primary key (PRODUCT_ID, SELLER_ID));

CREATE TABLE IF NOT EXISTS promo (
PROMO_ID INT auto_increment NOT NULL primary key,
SELLER_ID INT NOT NULL,
PROMO_DESC varchar(100) DEFAULT NULL,
DATE_START DATETIME DEFAULT NULL,
DATE_END DATETIME DEFAULT NULL,
PROMO_VALUE DECIMAL (5,2) DEFAULT 000.00);

CREATE TABLE IF NOT EXISTS invoice (
INVOICE_ID INT auto_increment NOT NULL primary key,
ISSUE_DATE DATETIME DEFAULT NOW(),
TOTAL_AMOUNT DECIMAL (10,2) DEFAULT 00.00,
TAX DECIMAL (5,2) DEFAULT 0.20,
CUST_ID INT NOT NULL,
SUB_ID INT,
ORDER_ID INT NOT NULL,
PROMO_ID INT DEFAULT NULL,
SELLER_ID INT NOT NULL);

CREATE TABLE IF NOT EXISTS product_order (
ORDER_ID INT auto_increment NOT NULL primary key,
PRODUCT_ID INT NOT NULL,
CUST_ID INT NOT NULL,
QUANTITY TINYINT NOT NULL,
SELLER_ID INT,
SUB_ID INT,
INVOICE_ID INT,
PURCHASE_DATE DATETIME DEFAULT NOW(),
KEY (PRODUCT_ID));

alter table location
add constraint fk_loc_2
foreign key (area_id)
references area (area_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE country
ADD CONSTRAINT fk_country
FOREIGN KEY (AREA_ID)
REFERENCES area (AREA_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE country
ADD INDEX c_name_index (country_name);

ALTER TABLE location
ADD CONSTRAINT fk_loc
FOREIGN KEY (country_name)
REFERENCES country (country_name)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE seller
ADD CONSTRAINT fk_seller
FOREIGN KEY (LOCATION_ID)
REFERENCES location (LOCATION_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE subscription
ADD CONSTRAINT fk_sub_2
FOREIGN KEY (INVOICE_ID)
REFERENCES invoice (INVOICE_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
ADD CONSTRAINT fk_sub_3
FOREIGN KEY (SELLER_ID)
REFERENCES seller (SELLER_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE stock
ADD CONSTRAINT fk_stock
FOREIGN KEY (SELLER_ID)
REFERENCES seller (SELLER_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
ADD CONSTRAINT fk_stock_2
FOREIGN KEY (PRODUCT_ID)
REFERENCES product (PRODUCT_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE location
ADD CONSTRAINT fk_loc_cid
foreign key (country_id)
references country (country_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE seller_rating
ADD CONSTRAINT fk_rating
FOREIGN KEY (CUST_ID)
REFERENCES customer (CUST_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
ADD CONSTRAINT fk_rating_2
FOREIGN KEY (PRODUCT_ID)
REFERENCES product (PRODUCT_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
ADD CONSTRAINT fk_rating_3
FOREIGN KEY (SELLER_ID)
references seller (SELLER_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE sub_rating
ADD CONSTRAINT fk_rating_sub
FOREIGN KEY (CUST_ID)
REFERENCES customer (CUST_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
ADD CONSTRAINT fk_rating_sub_2
FOREIGN KEY (SUB_ID)
REFERENCES subscription (SUB_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
ADD CONSTRAINT fk_rating_sub_3
FOREIGN KEY (SELLER_ID)
references seller (SELLER_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

ALTER TABLE product_order
ADD CONSTRAINT fk_order
FOREIGN KEY (PRODUCT_ID)
REFERENCES product (PRODUCT_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
ADD CONSTRAINT fk_order_2
FOREIGN KEY (INVOICE_ID)
REFERENCES invoice (INVOICE_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
ADD CONSTRAINT fk_order_3
FOREIGN KEY (SELLER_ID)
REFERENCES seller (SELLER_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
ADD CONSTRAINT fk_sub
FOREIGN KEY (SUB_ID)
REFERENCES subscription (SUB_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE;

#inserting data

INSERT INTO customer (FIRST_NAME, LAST_NAME, AGE, LOCATION_ID) VALUES
("Hilary", "Hood",30,1),
("Charlotte", "Berg",75,2),
("Garrett", "Frost",21,3),
("Evelyn", "Mercer",30,4),
("Ignatius", "Harrison",66,5),
("Fay", "Maxwell",75,6),
("Aaron", "Lamb",63,7),
("Adam", "Alvarado",70,8),
("Ruby", "Strickland",47,9),
("Amena", "Gilliam",23,10),
("Renee", "Montgomery",27,11),
("Rosalyn", "Smith",40,12),
("Leah", "Carlson",58,13),
("Mona", "Washington",71,14),
("Teagan", "English",27,15),
("Conan", "Head",44,16),
("Maggy", "Justice",42,17),
("Noelani", "Ewing",20,18),
("Mufutau", "Kirk",66,19),
("Hall", "Meyers",48,20),
("Tiger", "Dunn",63,21),
("Jaquelyn", "Simpson",29,22),
("Ria", "Emerson",45,23),
("Leila", "Hansen",35,24),
("Brock", "Rocha",34,25);

INSERT INTO area (AREA_ID, AREA_NAME) values
(1, 'North America'),
(2, 'South America'),
(3, 'Europe'),
(4, 'Africa and Middle East'),
(5, 'Asia'),
(6, 'Oceania');

INSERT INTO country (COUNTRY_ID, COUNTRY_NAME, AREA_ID) values
('AU', 'Austrailia', 6),
('BR', 'Brazil', 2),
('CA', 'Canada', 1),
('PL', 'Poland', 3),
('PT', 'Portugal', 3),
('PR', 'Puerto Rico', 1),
('QA', 'Qatar', 4),
('SA', 'Saudi Arabia', 4),
('SN', 'Senegal', 4),
('RS', 'Serbia', 3),
('SG', 'Singapore', 5),
('SK', 'Slovakia', 3),
('SI', 'Slovenia', 3),
('SO', 'Somalia', 4),
('ZA', 'South Africa', 4),
('ES', 'Spain', 3),
('SE', 'Sweden', 3),
('CH','Switzerland', 3),
('TH', 'Thailand', 5),
('TR', 'Turkey', 3),
('TM', 'Turkmenistan', 5),
('UA', 'Ukraine', 3),
('AE', 'United Arab Emirates', 4),
('UK','United Kingdom', 3),
('US', 'United States', 1),
('UY', 'Uruguay', 2);

INSERT INTO location (LOCATION_ID, STREET_ADDRESS, ZIP_CODE, CITY, STATE_PROVINCE, COUNTRY_NAME, COUNTRY_ID) VALUES
(1, "866-5317 Luctus St.","032900","Cork","Alberta","Canada", 'CA'),
(2, "Ap #681-1655 Eros. Ave","238318","Camari","Missouri", 'United States', 'US'),
(3, "5069 Nibh. Street","24311","San Martino","Wales","United Kingdom", 'UK'),
(4, "252-8094 Sed, St.","59474","Jayapura","Midi","Brazil", 'BR'),
(5, "P.O. Box 929, 1054 Magnis Rd.","009990","Belfast","Zuid Holland","Poland", 'PL'),
(6, "357-951 Convallis St.","3887","Burgos","Manitoba","Sweden", 'SE'),
(7, "Ap #793-8632 Enim St.","83626","Roio del Sangro","Nebraska","Canada", 'CA'),
(8, "577-495 Risus St.","26944","Tianjin","West Sumatra","Sweden", 'SE'),
(9, "113-5213 Donec Ave","30714","Duncan","Overijssel","United States", 'US'),
(10, "432 Pretium Avenue","128189","Henderson","Magallanes","Canada", 'CA'),
(11, "Ap #280-4832 Ligula. St.","518275","Gävle","São Paulo","Turkey", 'TR'),
(12, "Ap #908-9300 Nullam St.","46335","Puntarenas","Washington","United Kingdom", 'UK'),
(13, "Ap #553-5763 Magna. St.","469864","Kirov","Xīběi","United Kingdom", 'UK'),
(14, "3815 Lobortis. Av.","205354","Guirsch","Vienna","United Kingdom", 'UK'),
(15, "607-4406 Sem Avenue","17129","Delitzsch","Cantabria","Turkey", 'TR'),
(16, "955-8016 Rhoncus. Avenue","7847","Zirl","Goiás","Canada", 'CA'),
(17, "124-337 Tempus, St.","62158","Kharmang","Marche","United States", 'US'),
(18, "Ap #526-7079 Dictum Street","341443","Delhi","FATA","Poland", 'PL'),
(19, "7255 Ipsum St.","757915","Ikot Ekpene","Sutherland","United Kingdom", 'UK'),
(20, "P.O. Box 659, 8894 Sed Rd.","26122","Motala","Zeeland","Turkey", 'TR'),
(21, "P.O. Box 105, 2458 Pharetra Rd.","3530","Skardu","Irkutsk Oblast","Turkey", 'TR'),
(22, "P.O. Box 550, 6411 Commodo Rd.","786329","Buôn Ma Thuột","Alberta","Canada", 'CA'),
(23, "457-3107 Ante. Street","87733","Nieuwegein","Kostroma Oblast","Poland", 'PL'),
(24, "P.O. Box 833, 1759 Nascetur Av.","64222","Heredia","Drenthe","United States", 'US'),
(25, "Ap #805-4922 Ut Avenue","8345","Bremen","Waals-Brabant","Turkey", 'TR');

INSERT INTO seller (SELLER_ID, FIRST_NAME, LAST_NAME, AGE, EMAIL, PHONE_NUMBER) VALUES
(1,"Tanner","Marshall",54,"t_marshall@aol.couk",6773719739),
(2,"Odysseus","Good",37,"g-odysseus@google.edu",18937616125),
(3,"Hayes","Russell",25,"r-hayes@yahoo.com",6053303725),
(4,"Howard","Velasquez",28,"velasquezhoward@aol.net",16682207518),
(5,"Cullen","Baxter",30,"baxter-cullen@yahoo.ca",2443617681),
(6,"Nash","Acevedo",43,"nash_acevedo@protonmail.org",4612351301),
(7,"Vaughan","Reyes",24,"rvaughan@outlook.net",779345746),
(8,"Acton","Pruitt",55,"pruitt_acton@aol.net",8637842620),
(9,"Octavius","Sanford",30,"osanford@hotmail.couk",6705377560),
(10,"Colt","Hendricks",23,"c_hendricks5848@protonmail.net",17418404038),
(11,"Jelani","Thompson",52,"jelanithompson2806@outlook.ca",9187817262),
(12,"Keane","Pena",63,"k.pena@google.com",15243553017),
(13,"Clinton","Randolph",33,"randolph-clinton@icloud.net",16411463586),
(14,"Cade","Simon",38,"csimon@hotmail.org",6812439366),
(15,"Gregory","Dawson",59,"dawson.gregory@icloud.net",17593816282),
(16,"Patrick","Buchanan",35,"patrick_buchanan@protonmail.org",5833437339),
(17,"Noah","Case",28,"cnoah@protonmail.ca",11526859375),
(18,"Bert","Landry",36,"l-bert@hotmail.ca",15537255460),
(19,"Nicholas","Snyder",58,"s_nicholas@yahoo.net",17878424146),
(20,"Patrick","Carroll",47,"carroll_patrick3082@hotmail.edu",5387535395),
(21,"Troy","Cole",65,"t.cole7445@protonmail.net",12322685621),
(22,"Chaney","Schultz",42,"schultzchaney@icloud.ca",13855655346),
(23,"Gary","Rivas",36,"r.gary4945@outlook.org",8546379752),
(24,"Rigel","Rodriquez",65,"rodriquez_rigel@protonmail.couk",4615256277),
(25,"Xenos","Merrill",29,"m-xenos8668@google.com",11924584347),
(26,"Lyle","Maddox",50,"m.lyle1158@aol.org",6684341615),
(27,"Herman","Kelley",47,"kelley-herman@icloud.edu",3305515116),
(28,"Aquila","Eaton",61,"eatonaquila@yahoo.net",16042750028),
(29,"Kuame","Rose",44,"rosekuame9168@outlook.couk",12368321706),
(30,"Hilel","Juarez",45,"juarez.hilel104@icloud.ca",16305235745);

INSERT INTO product (PRODUCT_ID, PRODUCT_NAME, PRODUCT_PRICE) VALUES
(1,'Cup', 10.00),
(2,'Small Painting', 50.00),
(3,'Sculpture', 100.00),
(4,'Drawing', 25.00),
(5,'Digital Art', 45.00),
(6,'Sketch', 25.00),
(7,'Poster', 15.00),
(8,'Large Painting', 100.00),
(9,'Digital Animation', 150.00),
(10,'Home Decor', 35.00);

INSERT INTO seller_rating (CUST_ID, PRODUCT_ID, P_RATING, SELLER_ID) VALUES
(1,1,3, 1 ),
  (2,2,3, 2),
  (3,5,4, 3),
  (4,3,4, 4),
  (5,6,4, 5),
  (6,7,1, 6),
  (7,8,2, 7),
  (8,6,2, 8),
  (9,10,1, 9),
  (10,5,5, 10),
  (11,10,4, 11),
  (12,10,2, 12),
  (13,9,3, 13),
  (14,4,5, 14),
  (15,2,1, 15),
  (16,3,4, 16),
  (17,1,2, 17),
  (18,1,2, 18),
  (19,6,3, 19),
  (20,5,4, 20),
  (21,4,5, 21),
  (22,8,2, 22),
  (23,7,1, 23),
  (24,9,2, 24),
  (25,10,4, 25);
  
INSERT INTO product_order (CUST_ID, PRODUCT_ID, SELLER_ID, QUANTITY, PURCHASE_DATE) VALUES
(1,1,1,8,"2022-06-16 15:50:25"),
  (2,2,22,6,"2022-11-21 20:31:27"),
  (3,3,4,4,"2021-02-23 02:06:49"),
  (4,4,6,10,"2022-02-10 03:56:45"),
  (5,5,10,3,"2021-08-01 01:52:12"),
  (6,6,23,4,"2021-09-09 10:34:40"),
  (7,7,7,8,"2021-03-06 08:35:39"),
  (8,8,4,4,"2022-09-06 04:51:25"),
  (9,9,25,6,"2021-01-12 13:42:23"),
  (10,10,25,6,"2021-10-25 13:59:11"),
  (11,5,5,8,"2021-11-10 18:37:20"),
  (12,8,14,6,"2022-02-22 15:38:01"),
  (13,9,22,5,"2021-12-30 19:30:28"),
  (14,7,4,9,"2021-11-25 07:36:38"),
  (15,7,6,8,"2022-11-13 03:21:11"),
  (16,9,7,5,"2021-04-10 08:17:28"),
  (17,5,6,8,"2022-11-15 07:14:21"),
  (18,9,23,2,"2021-08-19 13:22:21"),
  (19,6,8,4,"2022-06-04 11:34:06"),
  (20,4,18,4,"2022-09-15 08:34:46"),
  (21,8,9,1,"2022-11-01 15:31:49"),
  (22,9,25,1,"2021-04-26 01:17:37"),
  (23,6,14,6,"2022-10-12 22:18:52"),
  (24,7,9,2,"2021-11-12 12:29:56"),
  (25,8,19,8,"2022-04-13 18:33:29");

#Triggers

#notification queued table, database server would read notification table where sent is 0, sends and sets to 1. Purpose is for sending
#an email to the seller
DELIMITER $$
CREATE TRIGGER t_notification_insert 
AFTER INSERT ON product_order
FOR EACH ROW 
BEGIN 
    INSERT INTO notification_queue (sent) VALUES (0);
END$$
DELIMITER ;


CREATE TABLE IF NOT EXISTS log (
LOG_ID INT auto_increment PRIMARY KEY,
TIMES DATETIME DEFAULT NOW(),
P_DESC varchar(30),
TS datetime,
OLD_PRICE DECIMAL(10,2),
NEW_PRICE DECIMAL(10,2),
PROD_ID smallint);

delimiter $$
CREATE TRIGGER price_update
AFTER UPDATE
ON PRODUCT
FOR EACH ROW
BEGIN
	INSERT INTO log(TIMES, P_DESC, PROD_ID, OLD_PRICE, NEW_PRICE) VALUES
    (now(), USER(), NEW.PRODUCT_ID, OLD.PRODUCT_PRICE, NEW.PRODUCT_PRICE);
END $$
delimiter ;

 


#Retrieving information

select * from product_order where PURCHASE_DATE between '2020-10-10' and curdate();

select * from product_order where PURCHASE_DATE between '2021-12-20' and '2022-02-22';

SELECT product_name, quantity, cust_id, product_price*quantity AS total
FROM artsy.product p
LEFT JOIN artsy.product_order o ON o.product_id = p.product_id
ORDER BY total DESC;
#here we see our 3 highest spending customers are customer ids 9,25,13,16

SELECT AVG(quantity*product_price)/MONTH(purchase_date) AS 'Money per month',
AVG(quantity*product_price)/YEAR(purchase_date) AS 'Money per year', purchase_date
FROM artsy.product p
LEFT JOIN artsy.product_order o ON o.product_id = p.product_id
GROUP BY YEAR(purchase_date), MONTH(purchase_date);



create view heading as 
select i.INVOICE_ID as "Invoice Number", i.ISSUE_DATE as "Issue Date", 
concat(c.FIRST_NAME, " ", c.LAST_NAME) as "Client Name", l.STREET_ADDRESS as "Street Adress", 
concat(l.CITY, ", ", l.STATE_PROVINCE, ", ", cy.COUNTRY_NAME) as "City, State, Country", l.ZIP_CODE, 
"Brooklyn Avenue 99, New York City, New York, United States, 13489, 
415-900-9999, artsy_invoices@artsy.com, www.artsy.com", TOTAL.Subtotal,
SUM((i.TAX* TOTAL.Subtotal,i.TAX*TOTAL.Subtotal)) as "Invoice Amount Total"
from invoice as i
join (select i.INVOICE_ID, SUM((o.QUANTITY)*(p.PRODUCT_PRICE)) as 'Subtotal'
from artsy.product as p
join artsy.invoice i on o.INVOICE_ID=i.INVOICE_ID
join artsy.product_order o on o.PRODUCT_ID=p.PRODUCT_ID
group by i.INVOICE_ID ) AS TOTAL
join artsy.location l on l.LOCATION_ID=c.LOCATION_ID 
join artsy.customer c on c.CUST_ID=i.CUST_ID 
join artsy.country cy on cy.COUNTRY_ID=l.COUNTRY_ID
on TOTAL.INVOICE_ID=i.INVOICE_ID
where i.INVOICE_ID=5;

create view details as 
select p.PRODUCT_NAME as "Product Name", p.PRODUCT_PRICE as 'Product Prices', 
SUM(o.QUANTITY) as "Total Quantity", SUM(o.QUANTITY)*p.PRODUCT_PRICE as 'Amounts'
from product as p
left join invoice i on p.INVOICE_ID=i.INVOICE_ID
left join product_order o on p.PRODUCT_ID=o.PRODUCT_ID
where i.INVOICE_ID=5
group by p.PRODUCT_ID;


ALTER TABLE customer
ADD constraint fk_customer
FOREIGN KEY (LOCATION_ID)
references location (LOCATION_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE;


SHOW CREATE VIEW details;
SHOW CREATE VIEW heading;

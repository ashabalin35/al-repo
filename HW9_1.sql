/* 9_1.	�������� ������� logs ���� Archive.
 * ����� ��� ������ �������� ������ � �������� users, catalogs � products � ������� logs
 * ���������� ����� � ���� �������� ������, �������� �������,
 * ������������� ���������� ����� � ���������� ���� name.
*/


drop database if exists HomeWork;
create database HomeWork;
use HomeWork;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  -- ���� � ����� ������
	tbl_name VARCHAR(255), -- �������� �������
  	source_id INT unsigned, -- ��� �������������� ���������� �����
  	source_name VARCHAR(255) -- ���������� ���� name
) COMMENT = 'LOG �������' ENGINE=ARCHIVE;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '�������� �������',
  UNIQUE unique_name(name(10))
) COMMENT = '������� ��������-��������' ENGINE=InnoDB;


DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '����������';

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��������',
  description TEXT COMMENT '��������',
  price DECIMAL (11,2) COMMENT '����',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = '�������� �������';


-- ������� �������� �� ���������� logs ������� ��� ���������� users, catalogs � products
DELIMITER //
DROP TRIGGER IF EXISTS prod_to_logs//
CREATE TRIGGER prod_to_logs AFTER INSERT ON products
FOR EACH ROW
BEGIN
   	insert into logs (created_at, tbl_name, source_id, source_name) values
   	(now(),
   	'products',
   	new.id,
   	new.name
   	);
END//

DROP TRIGGER IF EXISTS user_to_logs//
CREATE TRIGGER user_to_logs AFTER INSERT ON users
FOR EACH ROW
BEGIN
   	insert into logs (created_at, tbl_name, source_id, source_name) values
   	(now(),
   	'users',
   	new.id,
   	new.name
   	);
END//

DROP TRIGGER IF EXISTS cat_to_logs//
CREATE TRIGGER cat_to_logs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
   	insert into logs (created_at, tbl_name, source_id, source_name) values
   	(now(),
   	'catalogs',
   	new.id,
   	new.name
   	);
END//
DELIMITER ;

-- ��������� ������� � ������� �������� logs

INSERT INTO users (name, birthday_at) VALUES
  ('��������', '1990-10-05'),
  ('�������', '1984-11-12'),
  ('���������', '1985-05-20'),
  ('������', '1988-02-14'),
  ('����', '1998-01-12'),
  ('�����', '1992-08-29');

INSERT INTO catalogs VALUES
  (NULL, '����������'),
  (NULL, '����������� �����'),
  (NULL, '����������'),
  (NULL, '������� �����'),
  (NULL, '����������� ������');

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 7890.00, 1),
  ('Intel Core i5-7400', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 12700.00, 1),
  ('AMD FX-8320E', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.', 4780.00, 1),
  ('AMD FX-8320', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', '����������� ����� ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', '����������� ����� Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', '����������� ����� MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

select * from logs;
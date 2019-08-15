/* 8_2.	� ������� products ���� ��� ��������� ����: name � ��������� ������ � description � ��� ���������.
 * ��������� ����������� ����� ����� ��� ���� �� ���. ��������, ����� ��� ���� ��������� �������������� �������� NULL �����������.
 * ��������� ��������, ��������� ����, ����� ���� �� ���� ����� ��� ��� ���� ���� ���������.
 * ��� ������� ��������� ����� NULL-�������� ���������� �������� ��������.
*/


drop database if exists HomeWork;
create database HomeWork;
use HomeWork;



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


DELIMITER //
DROP TRIGGER IF EXISTS check_products//
CREATE TRIGGER check_products BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	if new.name is null and new.description is null then SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NAME and DESCRIPTION is NULL';
 	end if;
END//
DELIMITER ;


INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 7890.00, 1),
  ('Intel Core i5-7400', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� Intel.', 12700.00, 1),
--  (NULL, NULL, 4780.00, 1), -- ���� ��� ���� NULL - ��� �������� ������� ��������� ����� ������ ������ 45000 � ��������.
  ('AMD FX-8320', '��������� ��� ���������� ������������ �����������, ���������� �� ��������� AMD.', 7120.00, 1),
  (NULL, '����������� ����� ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', '����������� ����� Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', NULL, 5060.00, 2);
 
 select name, description from products;

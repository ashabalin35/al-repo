/*
������� 3_3
3. � ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����:
0, ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������.
���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ���������� �������� value.
������, ������� ������ ������ ���������� � �����, ����� ���� �������.
*/

drop database if exists HomeWork;
create database HomeWork;
use HomeWork;

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��������',
  price DECIMAL (11,2) COMMENT '����',
  value INT UNSIGNED
 ) COMMENT = '�������� �������';

INSERT INTO storehouses_products
  (name, price, value)
VALUES
  ('Intel Core i3-8100', 7890.00, 10),
  ('Intel Core i5-7400', 12700.00, 15),
  ('AMD FX-8320E', 4780.00, 0),
  ('AMD FX-8320', 7120.00, 2),
  ('ASUS ROG MAXIMUS X HERO', 19310.00, 24),
  ('Gigabyte H310M S2H', 4790.00, 0),
  ('MSI B250M GAMING PRO', 5060.00, 27);

-- ��������� �������� �������
select * from storehouses_products order by case when value='0' then 1 else 0 end ,value;
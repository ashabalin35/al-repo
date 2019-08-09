/* ������� 6.1 � ���� ������ shop � sample ������������ ���� � �� �� �������
 * ������� ���� ������. ����������� ������ id = 1 �� ������� shop.users
 * � ������� sample.users. ����������� ����������..
*/
drop database if exists shop_tr;
create database shop_tr;
use shop_tr;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '����������';

INSERT INTO users (name, birthday_at) VALUES
  ('��������', '1990-10-05'),
  ('�������', '1984-11-12'),
  ('���������', '1985-05-20'),
  ('������', '1988-02-14'),
  ('����', '1998-01-12'),
  ('�����', '1992-08-29');
  
drop database if exists sample_tr;
create database sample_tr;
use sample_tr;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '����������';

-- ��������� ������������ � id=1 �� ����� ���� � ������, ��������� ����������
start transaction;
insert into sample_tr.users select * from shop_tr.users where id=1;
delete from shop_tr.users where id=1;
commit;
 -- ��������� ������� ������ � id 1
select * from shop_tr.users;
select * from sample_tr.users;
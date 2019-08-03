/*
������� 4.
2.����������� ���������� ���� ��������, ������� ���������� �� ������ �� ���� ������.
  ������� ������, ��� ���������� ��� ������ �������� ����, � �� ���� ��������.
 */
drop database if exists HomeWork;
create database HomeWork;
use HomeWork;

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
 
-- �������2. ����������� ���������� ���� ��������, ������� ���������� �� ������ �� ���� ������
select count(name) as '���-��',dayname(concat(date_format(now(),'%Y'),'-',date_format(birthday_at,'%m-%d'))) as day_name from users group by day_name;

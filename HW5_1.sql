/* ������� 5.1 ��������� ������ ������������� users,
 * ������� ����������� ���� �� ���� ����� orders � �������� ��������.
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


DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id BIGINT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = '������';

insert into orders (user_id) 
values (1),(1),(1),(3),(5),(5); -- ��������� ������ �������������

-- ������� ����� ���, ��� ����� ������ � �� ����������
select n.name as '���', count(i.user_id) as '���-�� �������'
from users as n
join orders as i where n.id=i.user_id
group by i.user_id;

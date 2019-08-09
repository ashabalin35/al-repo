/* Задание 6.1 В базе данных shop и sample присутствуют одни и те же таблицы
 * учебной базы данных. Переместите запись id = 1 из таблицы shop.users
 * в таблицу sample.users. Используйте транзакции..
*/
drop database if exists shop_tr;
create database shop_tr;
use shop_tr;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');
  
drop database if exists sample_tr;
create database sample_tr;
use sample_tr;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

-- переносим пользователя с id=1 из одной базы в другую, используя транзакции
start transaction;
insert into sample_tr.users select * from shop_tr.users where id=1;
delete from shop_tr.users where id=1;
commit;
 -- проверяем перенос записи с id 1
select * from shop_tr.users;
select * from sample_tr.users;
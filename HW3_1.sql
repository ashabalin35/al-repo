/*
Задание 3_1
Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
*/

drop database if exists HomeWork;
create database HomeWork;
use HomeWork;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME, -- оказались незаполненными
  updated_at DATETIME
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

-- заполняем поля текущей датой
 update users set created_at = NOW() where created_at is null or created_at=false;
 update users set updated_at = NOW() where updated_at is null or created_at=false;
select * from users;
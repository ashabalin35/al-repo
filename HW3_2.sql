/*
Задание 3_2
Таблица users была неудачно спроектирована.
Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения
в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.
*/
drop database if exists HomeWork;
create database HomeWork;
use HomeWork;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(50),
  updated_at VARCHAR(50) -- неудачно спроектированы
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
  ('Геннадий', '1990-10-05','20.11.2017 8:10', '20.11.2017 8:10' ),
  ('Наталья', '1984-11-12','10.12.2018 2:10', '10.10.2019 12:10'),
  ('Александр', '1985-05-20', '20.08.2016 5:15', '20.08.2017 18:10'),
  ('Сергей', '1988-02-14','25.12.2017 16:10', '20.11.2018 4:10'),
  ('Иван', '1998-01-12','20.07.2017 12:11', '20.07.2017 12:20'),
  ('Мария', '1992-08-29','20.10.2017 8:10', '20.10.2017 8:10');
 
-- преобразуем дату в правильный формат
 update users set created_at=STR_TO_DATE(created_at, '%d.%m.%Y %k:%i');
 update users set updated_at=STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

-- меняем тип столбца 
alter table users change created_at created_at DATETIME;
 alter table users change updated_at updated_at DATETIME;

select * from users;
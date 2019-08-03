/*
Задание 4.
2.Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
  Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 */
drop database if exists HomeWork;
create database HomeWork;
use HomeWork;

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
 
-- Задание2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели
select count(name) as 'Кол-во',dayname(concat(date_format(now(),'%Y'),'-',date_format(birthday_at,'%m-%d'))) as day_name from users group by day_name;

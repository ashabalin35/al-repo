/* 8_1.	Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
 * в зависимости от текущего времени суток.
 * С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
 * с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
 * с 18:00 до 00:00 — "Добрый вечер",
 * с 00:00 до 6:00 — "Доброй ночи".
*/

drop database if exists HomeWork;
create database HomeWork;
use HomeWork;

DELIMITER //

DROP function IF EXISTS hello//
CREATE function hello ()
RETURNS VARCHAR(255) DETERMINISTIC
	BEGIN
		DECLARE text VARCHAR(255) DEFAULT 'Приветствую!';
		if hour(NOW())>=6 and (hour(NOW())<=11 and minute(NOW())<=59) then set text ='Доброе утро';
		elseif hour(NOW())>=12 and (hour(NOW())<=17 and minute(NOW())<=59) then set text ='Добрый день';	
		elseif hour(NOW())>=18 and (hour(NOW())<=23 and minute(NOW())<=59) then set text ='Добрый вечер';
		elseif hour(NOW())>=0 and (hour(NOW())<=05 and minute(NOW())<=59) then set text ='Доброй ночи';
		end if; 	
		return text;
	END//

select hello() as Hello//
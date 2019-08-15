/* 8_1.	�������� �������� ������� hello(), ������� ����� ���������� �����������, 
 * � ����������� �� �������� ������� �����.
 * � 6:00 �� 12:00 ������� ������ ���������� ����� "������ ����",
 * � 12:00 �� 18:00 ������� ������ ���������� ����� "������ ����",
 * � 18:00 �� 00:00 � "������ �����",
 * � 00:00 �� 6:00 � "������ ����".
*/

drop database if exists HomeWork;
create database HomeWork;
use HomeWork;

DELIMITER //

DROP function IF EXISTS hello//
CREATE function hello ()
RETURNS VARCHAR(255) DETERMINISTIC
	BEGIN
		DECLARE text VARCHAR(255) DEFAULT '�����������!';
		if hour(NOW())>=6 and (hour(NOW())<=11 and minute(NOW())<=59) then set text ='������ ����';
		elseif hour(NOW())>=12 and (hour(NOW())<=17 and minute(NOW())<=59) then set text ='������ ����';	
		elseif hour(NOW())>=18 and (hour(NOW())<=23 and minute(NOW())<=59) then set text ='������ �����';
		elseif hour(NOW())>=0 and (hour(NOW())<=05 and minute(NOW())<=59) then set text ='������ ����';
		end if; 	
		return text;
	END//

select hello() as Hello//
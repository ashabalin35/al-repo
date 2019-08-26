/* ���� ������ �����������. � ���� 10 ������, ������� ������� logs
 * �������� �������� ����� ���� ������ �����.
 * � ������ �������� ����� ���� ��������� �����������.
 * ���������� ����� ������ ��� � ����� ����� ��������.
 * ������������ ����� ���������� ����-����� ���������
 */

DROP DATABASE IF EXISTS media_archive;
CREATE DATABASE media_archive;
USE media_archive;

DROP TABLE IF EXISTS logs; -- Log-������� ��� ������� ������� ��������
CREATE TABLE logs (
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
	user_id BIGINT UNSIGNED NOT NULL, 
	tbl_name VARCHAR(255), 
	source_name VARCHAR(255), 
  	`action` VARCHAR(255) 
) COMMENT = 'LOG �������' ENGINE=ARCHIVE;

DROP TABLE IF EXISTS users_type; -- ������� ��� ����������� ���� ������������ -> �������������, ��������, ������������ � �.�.
CREATE TABLE users_type (
	id SERIAL PRIMARY KEY, 
	name VARCHAR(25)
	);

DROP TABLE IF EXISTS users; -- ������� �������������
CREATE TABLE users (
	id SERIAL PRIMARY KEY, 
	users_type_id BIGINT UNSIGNED NOT null,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(120),
    created_at DATETIME DEFAULT NOW(),
    INDEX users_firstname_lastname_idx(firstname, lastname),
    foreign key (users_type_id) references users_type(id)
   );

DROP TABLE IF EXISTS messages; -- ������� ��������� ����� ��������������
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    `text` TEXT,
    created_at DATETIME DEFAULT NOW(),
    INDEX messages_from_user_id (from_user_id),
    INDEX messages_to_user_id (to_user_id),
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);    

DROP TABLE IF EXISTS notes_type; -- ������� ��� ����������� ���� �������� ��������
CREATE TABLE notes_type (
	id SERIAL PRIMARY KEY, 
	name VARCHAR(25)
   );

DROP TABLE IF EXISTS notes; -- ������� ��� �������� �������� �� �������
CREATE TABLE notes(
	id SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    notes_type_id BIGINT UNSIGNED NOT NULL,
	name VARCHAR(50),
	discription VARCHAR(255),
	date_of DATETIME DEFAULT NULL,
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	index (name),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (notes_type_id) REFERENCES notes_type(id)
);

-- ������� ������� ��� ������� log-������� ��� ���������� NOTES
DELIMITER //
DROP TRIGGER IF EXISTS notes_to_logs//
CREATE TRIGGER notes_to_logs AFTER INSERT ON notes
FOR EACH ROW
BEGIN
   	insert into logs (created_at, user_id, tbl_name, source_name, `action`) values
   	(now(), new.user_id,'notes',new.name,'INSERT');
END//
DELIMITER ;

DROP TABLE IF EXISTS media_type; -- ������� ��� ����������� ����� ����� ������
CREATE TABLE media_type (
	id SERIAL PRIMARY KEY, 
	name VARCHAR(25)
   );

DROP TABLE IF EXISTS segments; -- ������� ��� ����������� ���� ��������
CREATE TABLE segments (
	id SERIAL PRIMARY KEY, 
	name VARCHAR(25)
	);

DROP TABLE IF EXISTS media; -- ������� ��� �������� ������ ����������
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	notes_id BIGINT UNSIGNED NOT NULL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    segments_id BIGINT UNSIGNED DEFAULT NULL,
	segments_number INT unsigned DEFAULT NULL,
    links VARCHAR(255),
    duration BIGINT unsigned DEFAULT NULL, -- ����������� � ��������
	`size` BIGINT DEFAULT NULL,  -- ����������� � ����������
	metadata JSON default NULL,
    point_of_rec JSON DEFAULT NULL, 
	created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (media_type_id) REFERENCES media_type(id),
	FOREIGN KEY (segments_id) REFERENCES segments(id),
    FOREIGN KEY (notes_id) REFERENCES notes(id) on delete cascade on update cascade
);

DELIMITER //
DROP TRIGGER IF EXISTS media_to_logs//
CREATE TRIGGER media_to_logs AFTER INSERT ON media
FOR EACH ROW
BEGIN
   	insert into logs (created_at, user_id, tbl_name, source_name, `action`) values
   	(now(), new.user_id,'media',new.links,'INSERT');
END//
DELIMITER ;

DROP TABLE IF EXISTS rights; -- ������� ��� ������� ���� �� �������
CREATE TABLE rights (
	id SERIAL PRIMARY KEY,
	media_id BIGINT UNSIGNED NOT NULL,
	types JSON DEFAULT NULL,
    whose VARCHAR(255) NOT NULL,
    docs VARCHAR(255) NOT null,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX whose_idx(whose),
    INDEX docs_idx(docs),
    FOREIGN KEY (media_id) REFERENCES media(id)
);    


-- ��������� ���� �������������
INSERT INTO `users_type` (`id`, `name`) VALUES ('1','�������������');
INSERT INTO `users_type` (`id`, `name`) VALUES ('2','��������');
INSERT INTO `users_type` (`id`, `name`) VALUES ('3','������������');

-- ���� ��������
INSERT INTO `notes_type` (`id`, `name`) VALUES ('1','�������');
INSERT INTO `notes_type` (`id`, `name`) VALUES ('2','��������');
INSERT INTO `notes_type` (`id`, `name`) VALUES ('3','�����');
INSERT INTO `notes_type` (`id`, `name`) VALUES ('4','�����');
INSERT INTO `notes_type` (`id`, `name`) VALUES ('5','���������');
INSERT INTO `notes_type` (`id`, `name`) VALUES ('6','������');
INSERT INTO `notes_type` (`id`, `name`) VALUES ('7','�����');

-- ��������� ��������
INSERT INTO `media_type` (`id`, `name`) VALUES ('1','������� ������');
INSERT INTO `media_type` (`id`, `name`) VALUES ('2','��������');

-- ���� ��������
INSERT INTO `segments` (`id`, `name`) VALUES ('1','�����');
INSERT INTO `segments` (`id`, `name`) VALUES ('2','�����');
INSERT INTO `segments` (`id`, `name`) VALUES ('3','������');

-- ������� �������������
INSERT INTO `users` (`id`,`users_type_id`,`firstname`, `lastname`, `email`) VALUES ('1','1','���������', '��������', 'lebed@mail.ru');
INSERT INTO `users` (`id`,`users_type_id`,`firstname`, `lastname`, `email`) VALUES ('2','2','���������', '������', 'kate@mail.ru');
INSERT INTO `users` (`id`,`users_type_id`,`firstname`, `lastname`, `email`) VALUES ('3','3','������', '�����', 'serge@mail.ru');
INSERT INTO `users` (`id`,`users_type_id`,`firstname`, `lastname`, `email`) VALUES ('4','2','�����', '�����', 'fedor@mail.ru');
INSERT INTO `users` (`id`,`users_type_id`,`firstname`, `lastname`, `email`) VALUES ('5','3','��������', '������', 'gelya@mail.ru');

-- ������� ��������� �������������
INSERT INTO messages (`from_user_id`, `to_user_id`, `text`) VALUES ('1','2','����, ������ �������� �� ����� ������ ��������� Eurohit top-40!!!');
INSERT INTO messages (`from_user_id`, `to_user_id`, `text`) VALUES ('2','1','����, �������, ������ ��� �������');
INSERT INTO messages (`from_user_id`, `to_user_id`, `text`) VALUES ('3','1','����, � �������� �������� ��������, ������ ��������� ����. ��������?');
INSERT INTO messages (`from_user_id`, `to_user_id`, `text`) VALUES ('4','3','������, ���� ��������� ������ ���� � ������. ������ � ���� ��������.');

-- 1 ��������
INSERT INTO notes (`id`,`user_id`,`notes_type_id`,`name`,`discription`,`date_of`)
	VALUES (
	'1','2','1','HOTNEWS','�������������� ���������'
	,'2019-06-07 10:15'
	);

INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('2','1','1','3','1','\\\\hpserv\\video\\masters\\hotnews201.mp4','240','302011',
'{"tags":"���������, �����, JLO, �������", "editor":"�������� ������","operator":"������ �����"}',
null);

INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('1','1','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','�����������','�����������');


-- 2 ��������
INSERT INTO notes (`id`,`user_id`,`notes_type_id`,`name`,`discription`,`date_of`)
	VALUES (
	'2','1','3','Eurohit top-40','������� ���� Europa Plus TV' 
	,'2019-08-01 14:11'
	);

INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('1','2','1','3','15','\\\\hpserv\\video\\masters\\euro00015.mp4','3175','6102011',
'{"tags":"eurohit, top40, chart, eurodance", "director":"������� �����","operator":"������ �����"}',
'{"1":"00:21:10", "2":"00:43:25"}');

INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('2','2','1','3','16','\\\\hpserv\\video\\masters\\euro00016.mp4','3182','6102011',
'{"tags":"eurohit, top40, chart, eurodance", "director":"������� �����","operator":"������ �����"}',
'{"1":"00:21:10", "2":"00:43:25"}');

INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('1','2','1','3','17','\\\\hpserv\\video\\masters\\euro00017.mp4','3180','12102011',
'{"tags":"eurohit, top40, chart, eurodance", "director":"������� �����","operator":"������ �����"}',
'{"1":"00:21:10", "2":"00:43:25"}');


INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('2','2','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','�����������','�����������');

INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('3','3','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','�����������','�����������');

INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('4','4','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','�����������','�����������');


-- 3 ��������
INSERT INTO notes (`id`,`user_id`,`notes_type_id`,`name`,`discription`,`date_of`)
	VALUES (
	'3','2','2','��������� HIT NON STOP � ����-2017','������� ������ �� ������� ����������� ��������� ��������� ���� 2017 ����' 
	,'2017-05-05 19:00'
	);

INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('2','3','1',null, null,'\\\\hpserv\\video\\masters\\con00011.mp4','6590','10102458',
'{"tags":"hit, hitnonstop, concert, ���� ������", "director":"������� �����","operator":"������ �����"}',
'{"1":"00:21:10", "2":"00:43:25"}');

INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('5','5','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','�����������','�����������');


-- 4 ��������
INSERT INTO notes (`id`,`user_id`,`notes_type_id`,`name`,`discription`,`date_of`)
	VALUES (
	'4','4','5','HOT&TOP','���������-�������� � ��������� ���-�������' 
	,'2018-10-20 16:00'
	);

INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('4','4','1',null, null,'\\\\hpserv\\video\\masters\\hot00010.mp4','1500','9122045',
'{"tags":"���� ����������, hot&top, ��������, ����� ����", "director":"������� �����","operator":"������ �����"}',
'{"1":"00:21:10", "2":"00:43:25"}');

INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('6','6','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','�����������','�����������');


-- 5 ��������
INSERT INTO notes (`id`,`user_id`,`notes_type_id`,`name`,`discription`,`date_of`)
	VALUES (
	'5','4','4','SHANGUY � TOUKASSE','����' 
	,'2018-10-20 16:00'
	);

INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('4','5','1',null, null,'\\\\hpserv\\video\\masters\\CLP0019.mp4','210','1104051',
'{"tags":"SHANGUY, TOUKASSE, ����", "director":"PMI","operator":"PMI"}',
NULL);

INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('7','7','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','��� "������"','���-005 �� 10.11.2016');


-- 6 ��������
INSERT INTO notes (`id`,`user_id`,`notes_type_id`,`name`,`discription`,`date_of`)
	VALUES (
	'6','2','4','���� ���� � ������','����' 
	,'2018-12-10 11:00'
	);

INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('2','6','1',null, null,'\\\\hpserv\\video\\masters\\CLP0009.mp4','220','2102011',
'{"tags":"���� ����, ������, ����", "director":"WORNER MUSIC","operator":"WORNER MUSIC"}',
NULL);

INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('8','8','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','��� "������"','���-002 �� 11.05.2018');

-- 7 ��������
INSERT INTO notes (`id`,`user_id`,`notes_type_id`,`name`,`discription`,`date_of`)
	VALUES (
	'7','1','7','�������','������ ���� ������� ��� �����������' 
	,'2015-05-10 13:00'
	);

INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('1','7','2',null, null,'\\\\hpserv\\video\\masters\\ALL0010.mp4','1500','9160258',
'{"tags":"����, ������, ����, �������, �����", "director":"������� �������","operator":"����� �������"}',
NULL);

INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('9','9','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','�����������','�����������');

-- 8 ��������
INSERT INTO notes (`id`,`user_id`,`notes_type_id`,`name`,`discription`,`date_of`)
	VALUES (
	'8','1','7','������� �� ��������','����������� �������� � �����' 
	,'2015-05-16 13:00'
	);

INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('4','8','2',null, null,'\\\\hpserv\\video\\masters\\ALL0011.mp4','1920','1192011',
'{"tags":"������� �����, ����, ����� �����, �������, �������� ���������", "director":"������� �������","operator":"����� �������"}',
NULL);

INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('10','10','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','�����������','�����������');


-- ��������� ��� ���� ��������� � �������� 2
INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('4','2','1','3','18','\\\\hpserv\\video\\masters\\euro00018.mp4','3189','12102011',
'{"tags":"eurohit, top40, chart, eurodance", "director":"������� �����","operator":"������ �����"}',
'{"1":"00:20:10", "2":"00:41:25"}');

INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('11','11','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','�����������','�����������');

-- -- ��������� ��� ���������� � �������� 1
INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('2','1','1','3','2','\\\\hpserv\\video\\masters\\hotnews205.mp4','310','422011',
'{"tags":"������, ���� ������, ���������, �������", "editor":"�������� ������","operator":"������ �����"}',
null);

INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('12','12','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','�����������','�����������');

INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('2','1','1','3','3','\\\\hpserv\\video\\masters\\hotnews202.mp4','421','581011',
'{"tags":"����, ���������, �����, ������� ������", "editor":"�������� ������","operator":"������ �����"}',
null);

INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('13','13','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','�����������','�����������');


-- ��������� ��������� � 4 ��������
INSERT INTO media (`user_id`, `notes_id`,`media_type_id` , `segments_id`,`segments_number`,`links`,`duration`,`size`,`metadata`,`point_of_rec`)
VALUES ('2','4','1',1, 2,'\\\\hpserv\\video\\masters\\hot00011.mp4','1820','9582045',
'{"tags":"���� ����, hot&top, ��������, ����� ����", "director":"������� �����","operator":"������ �����"}',
'{"1":"00:21:10", "2":"00:43:25"}');

INSERT INTO rights (`id`, `media_id`, `types`, `whose`,`docs`)
VALUES ('14','14','{"internet":"OTT, IPTV, VOD, TIMESHIFT", "satelite":1,"cable":1}','�����������','�����������');

-- ������� log-������
select created_at as `date`,
	(select firstname from users where logs.user_id=users.id) as name,
	tbl_name as '�������',
	source_name as '��������',
	action as '��������'
from logs;

-- ������� ��������� �������������, ������������� ��������� �� ID ���������, �.�. �� ������� ��������� ������.
select
	(select concat(lastname,' ',firstname)  from users where id=messages.from_user_id) as `from`,
	(select concat(lastname,' ',firstname) from users where id=messages.to_user_id) as `to`,
	`text` as '���������'
from messages
	order by id;

-- ������� ������������ � ��� ����
select
	concat (firstname,' ', lastname) as name, r.name as `type` from users
	join users_type as r
	where r.id = users.users_type_id
;

-- ������� ��������� ��� ������ �������� ������� ������������
delimiter //
drop procedure if exists view_notes//
create procedure view_notes (in for_user_id INT)
begin
	select
		concat (u1.firstname, ' ', u1.lastname) name,
		n1.name, n1.discription , sec_to_time(m1.duration) duration, m1.links 
		from users u1
		left join notes n1 on u1.id=n1.user_id
		left join media m1 on n1.id=m1.notes_id 
	
		where u1.id=for_user_id
		;
end//
delimiter ;

call view_notes(1); -- �������� ���������


-- ������� ������������� ��� ������ �������� � ������������ ������� � ��������� �� media id
create or replace view right_media as 
	select
		m2.id , n1.name,
		concat(
		(select name from segments where id=m2.segments_id),' ', m2.segments_number) as seqment
		, m2.links
		, r1.whose '�����'
		from notes n1
		left join media m2 on n1.id=m2.notes_id
		left join rights r1 on r1.media_id=m2.id
		where r1.whose = '�����������'
		order by m2.id
		;

select * from right_media; -- ������� ������������� #1


-- ������� ��� �������� � ���������� ������ � ������.
select
	n1.name, count(*) '���-��'
	from notes n1
	join media m1 on n1.id=m1.notes_id
	group by n1.name;

-- �������� ����� ����������� ������ ������
select count(*) '���-��', '����� �����������', sec_to_time(sum(duration)) `time` from media;


-- ������� ��� �������� ������ ������������ ���� ����������� ��� ���������� �������� ������
delimiter //
drop function if exists get_duration //
CREATE FUNCTION get_duration (to_id BIGINT)
RETURNS BIGINT deterministic
BEGIN
  RETURN (select sum(duration) from media where notes_id=to_id);
END//
delimiter ;

select sec_to_time(get_duration(2)) duration; -- ��������� ID ������������ ��������
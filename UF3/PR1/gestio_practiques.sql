DROP DATABASE gestio_practiques;

CREATE DATABASE gestio_practiques;

USE gestio_practiques;


CREATE TABLE IF NOT EXISTS tutor_empresa (
id_tutorempresa INT NOT NULL,
nom_tutorempresa VARCHAR(30) NOT NULL,
PRIMARY KEY (id_tutorempresa) 
);


CREATE TABLE IF NOT EXISTS tutor_alumne (
id_tutoralumne INT NOT NULL,
nom_tutoralumne VARCHAR(30) NOT NULL,
PRIMARY KEY (id_tutoralumne)
);


CREATE TABLE IF NOT EXISTS cicle (
id_cicle INT NOT NULL,
nom_cicle VARCHAR(50) NOT NULL,
PRIMARY KEY (id_cicle)
);


CREATE TABLE IF NOT EXISTS homologacio (
id_homologacio INT NOT NULL,
tipus_homologacio VARCHAR(10) NOT NULL,
id_cicle INT NOT NULL,
FOREIGN KEY (id_cicle) REFERENCES cicle (id_cicle),
PRIMARY KEY (id_homologacio)
);


CREATE TABLE IF NOT EXISTS empresa (
id_empresa INT NOT NULL,
nom_empresa VARCHAR(30) NOT NULL,
adreça VARCHAR(80) NOT NULL,
telefon INT NOT NULL,
email VARCHAR(40) NOT NULL,
id_tutorempresa INT NOT NULL,
id_homologacio INT NOT NULL,
FOREIGN KEY (id_tutorempresa) REFERENCES tutor_empresa (id_tutorempresa),
FOREIGN KEY (id_homologacio) REFERENCES homologacio (id_homologacio),
PRIMARY KEY (id_empresa)
);


CREATE TABLE IF NOT EXISTS practica (
id_practica INT NOT NULL,
tipus_practica VARCHAR(30) NOT NULL,
data_inici DATE NOT NULL,
data_final DATE NOT NULL,
hores INT NOT NULL,
exempcio ENUM('No','25%','50%','100%') NOT NULL,
id_empresa INT NOT NULL,
FOREIGN KEY (id_empresa) REFERENCES empresa (id_empresa),
PRIMARY KEY (id_practica)
);


CREATE TABLE IF NOT EXISTS alumne (
id_alumne INT NOT NULL,
nom_alumne VARCHAR(20) NOT NULL,
cognom VARCHAR(20) NOT NULL,
data_naixement DATE NOT NULL,
email VARCHAR(50) NOT NULL,
telefon INT(9) DEFAULT NULL,
qualificacio DECIMAL NOT NULL,
id_tutoralumne INT NOT NULL,
id_practica INT NOT NULL,
id_cicle INT NOT NULL,
FOREIGN KEY (id_tutoralumne) REFERENCES tutor_alumne (id_tutoralumne),
FOREIGN KEY (id_practica) REFERENCES practica (id_practica),	
FOREIGN KEY (id_cicle) REFERENCES cicle (id_cicle),
PRIMARY KEY (id_alumne)
);


INSERT INTO tutor_empresa (id_tutorempresa, nom_tutorempresa) 
VALUES	(1, 'Manuel Lopez'),
	(2, 'Benito Elme'),
	(3, 'Mario Garcia')
;

INSERT INTO tutor_alumne (id_tutoralumne, nom_tutoralumne)
VALUES	(10, 'Diego Nistal'),
	(11, 'Lisa Marlec'),
	(12, 'Joel Garcia')
;

INSERT INTO cicle (id_cicle, nom_cicle)
VALUES	(20, 'SMIX'),
	(21, 'DAW'),
	(22, 'ASIX')
;

INSERT INTO homologacio (id_homologacio, tipus_homologacio, id_cicle)
VALUES 	(30, 'DUAL', 20),
	(31, 'DUAL', 21),
	(32, 'DUAL', 22),
	(33, 'FCT', 20),
	(34, 'FCT', 21),
	(35, 'FCT', 22)
;

INSERT INTO empresa (id_empresa, nom_empresa, adreça, telefon, email, id_tutorempresa, id_homologacio)
VALUES 	(41, 'Dopico company', 'Avenida general, Barcelona', 623219323, 'adopico@gmail.com', 3, 31),
	(42, 'LenGent', 'Carrer Pere IV, Barcelona', 688123201, 'lengent@gmail.com', 1, 34),
	(43, 'MrArreglos', 'Carrer Mare de Deu, Barcelona', 600321232, 'mrarreglos@gmail.com', 3, 32)
;

INSERT INTO practica (id_practica, tipus_practica, data_inici, data_final, hores, exempcio, id_empresa)
VALUES 	(50, 'DUAL', '2022-06-01', '2023-04-23', 1000, '25%', 41),
	(51, 'DUAL', '2021-06-12', '2023-04-30', 1000, '50%', 43),
	(52, 'FCT', '2022-09-28', '2023-02-12', 387, '100%', 42)
;

INSERT INTO alumne (id_alumne, nom_alumne, cognom, data_naixement, email, telefon, qualificacio, id_practica, id_tutoralumne, id_cicle)
VALUES 	(60, 'Marko', 'Pareja', '2004-02-12', 'mpareja@gmail.com', 643123212, 7.4, 51, 10, 22),
	(61, 'Joel', 'Casar', '2002-05-21', 'jcasar@gmail.com', 688231232, 6.1, 52, 12, 21),
	(62, 'Ivan', 'Saez', '2004-11-21', 'isaez@gmail.com', 691002123, 7.2, 50, 10, 21)
;

delimiter // 

CREATE TRIGGER comp_datainici_bi BEFORE INSERT ON practica
FOR EACH ROW
BEGIN
	IF (NEW.data_inici <= NOW())
	THEN
	SIGNAL SQLSTATE'45000' SET MESSAGE_TEXT= 'No es poden inserir practiques amb data de inici anteriors a la data actual';
	END IF;
END//
delimiter ;
	 
delimiter //

CREATE TRIGGER comp_datafi_bu BEFORE UPDATE ON practica
FOR EACH ROW
BEGIN
	IF (NEW.data_final < NEW.data_inici)
	THEN
	SIGNAL SQLSTATE'45000' SET MESSAGE_TEXT= 'No e poden actualitzar practiques amb data de finalitzacio anteriors a la data de inici';
	END IF;
END//
delimiter ;

UPDATE practica SET data_inici='2023-03-12' WHERE id_practica=52;


UPDATE practica SET data_inici='2022-10-03' WHERE id_practica=51;





CREATE DATABASE /*!32312 IF NOT EXISTS*/`library` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `library`;

CREATE TABLE IF NOT EXISTS `books` (
  `book_id` int(11) NOT NULL  AUTO_INCREMENT,
  `title` varchar(1000) NOT NULL,
  `author` varchar(1000) NOT NULL,
  `price` float(10,2) NOT NULL,
  `genre` varchar(50) NOT NULL,
  `available` varchar(3) NOT NULL,
  `published_date` date NOT NULL,
  PRIMARY KEY (`book_id`)  
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `member` (
  `member_id` int(11) NOT NULL AUTO_INCREMENT,
  `address` TINYTEXT NOT NULL,
  `phone_num` BIGINT(10) NOT NULL,  
  `email` varchar(512) NOT NULL,
  `first_name` varchar(512) NOT NULL,
  `last_name` varchar(512) NOT NULL,
  `exp_date` date NOT NULL,
  `books_issued` int(1) NOT NULL DEFAULT '0',  
   PRIMARY KEY (`member_id`) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE IF NOT EXISTS `borrowed` (
  `book_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `issue_date` date NOT NULL,
  `return_date` date NOT NULL,
  PRIMARY KEY (`book_id`),
  KEY `member_id` (`member_id`),
  CONSTRAINT `borrowed_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`),
  CONSTRAINT `borrowed_ibfk_2` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO `books` (`title`, `author`, `price`, `genre`, `available`, `published_date`) VALUES ('World War Z', 'Max Brooks', 14.99, 'Fantasy', 'Yes', '2006-09-12'),
('World War Z', 'Max Brooks', 14.99, 'Fantasy', 'No', '2006-09-12'),
('Harry Potter and the Philosophers Stone', 'J. K. Rowling', 18.95, 'Fantasy', 'Yes', '1997-06-26'),
('Windhall', 'Ava Barry', 20.36, 'Mystery', 'No', '2021-03-02'),
('My Summer In Seoul', 'Rachel Van Dyken', 18.99, 'Romance', 'No', '2021-12-13'),
('Bad Blood', 'John Carreyrou', 14.21, 'True Crime', 'Yes', '2018-05-21'),
('Harry Potter and the Chamber of Secrets', 'J. K. Rowling', 25.58, 'Fantasy', 'Yes', '1999-07-21'),
('Harry Potter and the Prisoner of Azkaban', 'J. K. Rowling', 20.44, 'Fantasy', 'Yes', '1999-09-08'),
('Harry Potter and the Goblet of Fire', 'J. K. Rowling', 19.00, 'Fantasy', 'Yes', '2000-06-08'),
('Harry Potter and the Order of the Phoenix', 'J. K. Rowling', 19.00, 'Fantasy', 'No', '2003-06-21');


INSERT INTO `member` ( `address`, `phone_num`, `email`, `first_name`, `last_name`, `exp_date`, `books_issued`) VALUES ( '123 Pennsylvania Avenue, Jacksonville Florida, 12345', '7862552491', 'pperez@gmail.com', 'Pepito', 'Perez', '2025-01-02', '0'), 
( '123 Atlantic Avenue, Norfolk Virginia, 54321', '7572552934', 'jdoe@gmail.com', 'John', 'Doe', '2026-11-20', '0') ,
( '435 Baltic Avenue, Trenton New Jersey, 56891', '6092556956', 'jdetal@gmail.com', 'Julanito', 'Detal', '2030-08-19', '1'), 
( '456 Pacific Avenue, San Francisco California, 98765', '4152551505', 'janed@gmail.com', 'Jane', 'Doe', '2024-04-20', '2') ,
( '1100 Ocean Drive, Miami Florida, 33166', '3052558952', 'maxmustermann@gmail.com', 'Max', 'Mustermann ', '2027-05-18', '0'), 
( '852 Palmetto Park, Orlando  Florida, 85624', '4072552934', 'evanova@hotmail.com', 'Eva ', 'Novakova', '2026-03-15', '1') ;

INSERT INTO `borrowed` (`book_id`, `member_id`, `issue_date`, `return_date`) VALUES ('5', '3', '2022-03-19', '2022-03-29'), 
('2', '4', '2022-03-18', '2022-03-28'),
('4', '4', '2022-03-20', '2022-03-30'),
('10', '6', '2022-03-08', '2022-03-18');


/* CHECK OUT BOOK FUNCTION*/
DELIMITER $$
CREATE FUNCTION `checkout`(`memberid` INT(11), `bookid` INT(11), `iss` DATE, `ret` DATE) RETURNS varchar(30)
BEGIN

DECLARE output varchar(30);
SET output = 'check out complete';

UPDATE `member` SET `books_issued` = `books_issued` + 1
WHERE `member`.`member_id` = memberid; 


INSERT INTO `borrowed` (`book_id`, `member_id`, `issue_date`, `return_date`) VALUES (bookid, memberid, iss, ret);
  
UPDATE `books` SET `available` = 'No' WHERE `books`.`book_id` = bookid;

RETURN output ;
END$$
DELIMITER ;

/* RETURN BOOK FUNCTION*/
DELIMITER $$
CREATE FUNCTION `returnbook`(`memberid` INT(11), `bookid` INT(11)) RETURNS varchar(30)
BEGIN

DECLARE output varchar(30);
SET output = 'return complete';

UPDATE `member` SET `books_issued` = `books_issued` - 1
WHERE `member`.`member_id` = memberid; 

DELETE FROM `borrowed` WHERE `borrowed`.`book_id` = bookid;
  
UPDATE `books` SET `available` = 'Yes' WHERE `books`.`book_id` = bookid;

RETURN output ;
END$$
DELIMITER ;



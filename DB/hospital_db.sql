-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: hospital_db
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `declarations`
--

DROP TABLE IF EXISTS `declarations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `declarations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `signed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_patient_doctor` (`patient_id`,`doctor_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `declarations_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `declarations_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `declarations`
--

LOCK TABLES `declarations` WRITE;
/*!40000 ALTER TABLE `declarations` DISABLE KEYS */;
INSERT INTO `declarations` VALUES (1,1,20,'2020-01-15 08:00:00',1),(2,2,20,'2021-03-20 09:30:00',1),(3,3,20,'2019-11-05 07:15:00',1),(4,4,20,'2022-06-12 11:00:00',1),(5,5,20,'2023-01-20 14:45:00',1),(6,6,20,'2020-09-09 07:20:00',1),(7,7,20,'2021-12-30 10:00:00',1),(8,8,21,'2020-02-10 07:00:00',1),(9,9,21,'2021-05-15 10:30:00',1),(10,10,21,'2019-08-22 12:15:00',1),(11,11,21,'2022-07-01 08:00:00',1),(12,12,21,'2023-03-14 08:45:00',1),(13,13,21,'2020-10-10 11:20:00',1),(14,14,21,'2021-01-18 14:00:00',1),(15,15,22,'2020-03-05 06:30:00',1),(16,16,22,'2021-04-25 09:45:00',1),(17,17,22,'2019-12-12 08:15:00',1),(18,18,22,'2022-08-08 12:00:00',1),(19,19,22,'2023-02-28 07:45:00',1),(20,20,22,'2020-11-20 11:20:00',1),(21,21,22,'2021-09-01 08:30:00',1),(22,22,23,'2020-04-18 11:00:00',1),(23,23,23,'2021-06-10 07:30:00',1),(24,24,23,'2019-10-05 13:15:00',1),(25,25,23,'2022-09-19 08:00:00',1),(26,26,23,'2023-04-12 12:45:00',1),(27,27,23,'2020-05-25 06:20:00',1),(28,28,23,'2021-11-11 10:00:00',1),(29,29,23,'2023-05-05 10:00:00',1),(30,30,23,'2023-06-01 11:30:00',1);
/*!40000 ALTER TABLE `declarations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diagnoses`
--

DROP TABLE IF EXISTS `diagnoses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diagnoses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `visit_id` int NOT NULL,
  `patient_id` int NOT NULL,
  `description` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `primary_diag` tinyint(1) DEFAULT '0',
  `recorded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `visit_id` (`visit_id`),
  KEY `patient_id` (`patient_id`),
  CONSTRAINT `diagnoses_ibfk_1` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`id`) ON DELETE CASCADE,
  CONSTRAINT `diagnoses_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diagnoses`
--

LOCK TABLES `diagnoses` WRITE;
/*!40000 ALTER TABLE `diagnoses` DISABLE KEYS */;
INSERT INTO `diagnoses` VALUES (1,1,1,'Гіпертонічна хвороба II ступеня',1,'2025-12-02 22:06:52'),(2,2,1,'Гіпертензивне серце без застійної серцевої недостатності',0,'2025-12-02 22:06:52'),(3,6,2,'Гонартроз (артроз колінного суглоба)',1,'2025-12-02 22:06:52'),(4,9,3,'Гострий бронхіт неуточнений',1,'2025-12-02 22:06:52'),(5,10,3,'Ішемічна хвороба серця',1,'2025-12-02 22:06:52'),(6,14,6,'Міопія слабкого ступеня обох очей',1,'2025-12-02 22:06:52'),(7,15,7,'Попереково-крижовий радикуліт',1,'2025-12-02 22:06:52'),(8,16,8,'Гостра респіраторна вірусна інфекція (ГРВІ)',1,'2025-12-02 22:06:52'),(9,19,9,'Сезонний алергічний риніт',1,'2025-12-02 22:06:52'),(10,21,10,'Вагітність 10 тижнів',1,'2025-12-02 22:06:52'),(11,23,11,'Гострий обструктивний бронхіт',1,'2025-12-02 22:06:52'),(12,28,15,'Забій м’яких тканин гомілки',1,'2025-12-02 22:06:52'),(13,33,19,'Миготлива аритмія',1,'2025-12-02 22:06:52'),(14,36,20,'Вугрова хвороба (Акне)',1,'2025-12-02 22:06:52'),(15,37,21,'Грип, вірус не ідентифікований',1,'2025-12-02 22:06:52'),(16,38,22,'Мігрень без аури',1,'2025-12-02 22:06:52'),(17,41,24,'Сечокам’яна хвороба',1,'2025-12-02 22:06:52'),(18,44,27,'Порушення серцевого ритму неуточнене',1,'2025-12-02 22:06:52'),(19,46,28,'Гострий цистит',1,'2025-12-02 22:06:52'),(20,48,30,'Залізодефіцитна анемія',1,'2025-12-02 22:06:52');
/*!40000 ALTER TABLE `diagnoses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `middle_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `sex` enum('M','F','O') COLLATE utf8mb4_unicode_ci DEFAULT 'O',
  `phone` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_patients_name` (`last_name`,`first_name`,`middle_name`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `patients`
--

LOCK TABLES `patients` WRITE;
/*!40000 ALTER TABLE `patients` DISABLE KEYS */;
INSERT INTO `patients` VALUES (1,'Стефанія','Ковальчук','Михайлівна','1942-03-14','F','+380501112233','stefania.kov@gmail.com','Львів, вул. Личаківська 112',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(2,'Йосип','Гаврилюк','Петрович','1950-11-05','M','+380671234567','yosyp.havryliuk@gmail.com','Львів, вул. Городоцька 220',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(3,'Варвара','Тимченко','Степанівна','1939-08-19','F','+380631112233','varvara.tym@gmail.com','Львів, вул. Зелена 45',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(4,'Григорій','Мельник','Васильович','1948-02-01','M','+380501223300','hryhoriy.melnyk@gmail.com','Львів, вул. Пасічна 90',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(5,'Любов','Савчин','Іванівна','1955-06-30','F','+380501223301','liuba.savchyn@gmail.com','Львів, вул. Володимира Великого 34',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(6,'Мирослава','Бойко','Олексіївна','1961-04-12','F','+380501223302','myroslava.boyko@gmail.com','Львів, вул. Стрийська 78',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(7,'Володимир','Лисенко','Богданович','1953-12-10','M','+380501223303','lysenko.v@gmail.com','Львів, вул. Наукова 15',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(8,'Ярослава','Гнатів','Юріївна','1945-09-25','F','+380501223304','yaroslava.hnativ@gmail.com','Львів, вул. Коперника 40',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(9,'Богдан','Шевченко','Миколайович','1959-01-15','M','+380501223305','bohdan.shev@gmail.com','Львів, вул. Шевченка 100',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(10,'Вікторія','Возняк','Сергіївна','1992-06-25','F','+380501223306','vozniak.v@gmail.com','Львів, вул. Сихівська 14',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(11,'Анатолій','Дрозд','Володимирович','1965-10-10','M','+380501223307','drozd.toly@gmail.com','Львів, вул. Любінська 9',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(12,'Ольга','Павлюк','Іванівна','1974-03-05','F','+380501223308','pavliuk.olha@gmail.com','Львів, вул. Мазепи 15',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(13,'Остап','Гавриш','Петрович','2004-11-22','M','+380501223309','havrysh.ostap@gmail.com','Львів, пр. Свободи 5',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(14,'Галина','Мельничук','Яківна','1952-05-18','F','+380501223310','halyna.mel@gmail.com','Львів, вул. Чупринки 60',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(15,'Данило','Захарчук','Андрійович','2002-09-09','M','+380501223311','zakharchuk.d@gmail.com','Львів, вул. Коновальця 33',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(16,'Надія','Білас','Григорівна','1949-02-14','F','+380501223312','nadiia.bilas@gmail.com','Львів, вул. Виговського 11',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(17,'Петро','Степаненко','Миколайович','1972-07-07','M','+380501223313','stepanenko.p@gmail.com','Львів, вул. Степана Бандери 33',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(18,'Марія','Крук','Богданівна','1991-12-01','F','+380501223314','kruk.m@gmail.com','Львів, вул. Вітовського 9',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(19,'Михайло','Рудий','Данилович','1938-04-29','M','+380501223315','rudyi.mykhailo@gmail.com','Львів, вул. Героїв УПА 73',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(20,'Соломія','Гірняк','Олегівна','2005-01-11','F','+380501223316','hirnyak.s@gmail.com','Львів, вул. Антоновича 55',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(21,'Андрій','Костюк','Володимирович','1980-10-20','M','+380501223317','kostiuk.a@gmail.com','Львів, вул. Сахарова 42',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(22,'Марія','Прокопів','Степанівна','1957-08-15','F','+380501223318','prokopiv.maria@gmail.com','Львів, вул. Дорошенка 15',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(23,'Тарас','Винник','Романович','2001-06-03','M','+380501223319','vynnyk.taras@gmail.com','Львів, вул. Варшавська 67',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(24,'Катерина','Шумелда','Павлівна','1963-11-28','F','+380501223320','shumelda.k@gmail.com','Львів, вул. Замарстинівська 12',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(25,'Ігор','Мазурок','Степанович','1986-09-24','M','+380501223321','mazurok.i@gmail.com','Львів, вул. Підвальна 3',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(26,'Анна','Кузьма','Валентинівна','2003-03-30','F','+380501223322','kuzma.anna@gmail.com','Львів, вул. Валова 11',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(27,'Василь','Ільків','Орестович','1947-12-19','M','+380501223323','ilkiv.vasyl@gmail.com','Львів, вул. Івана Франка 108',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(28,'Дарина','Смаль','Андріївна','1994-07-02','F','+380501223324','smal.daryna@gmail.com','Львів, вул. Гвардійська 16',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(29,'Сергій','Цимбалюк','Анатолійович','1981-05-10','M','+380501223325','tsymbaliuk.s@gmail.com','Львів, вул. Коновальця 88',1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(30,'Софія','Репета','Володимирівна','1941-10-14','F','+380501223326','repeta.sofia@gmail.com','Львів, вул. Левицького 24',1,'2025-12-02 22:06:52','2025-12-02 22:06:52');
/*!40000 ALTER TABLE `patients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `specialties`
--

DROP TABLE IF EXISTS `specialties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `specialties` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `specialties`
--

LOCK TABLES `specialties` WRITE;
/*!40000 ALTER TABLE `specialties` DISABLE KEYS */;
INSERT INTO `specialties` VALUES (10,'Анестезіолог'),(7,'Гінеколог'),(15,'Дерматолог'),(4,'Ендокринолог'),(1,'Кардіолог'),(11,'Мамолог'),(13,'Невролог'),(6,'Окулист'),(12,'Педіатр'),(14,'Психіатр'),(16,'Сімейний лікар'),(5,'Стоматолог'),(17,'Терапевт'),(2,'Травматолог'),(9,'УЗД-спеціаліст'),(8,'Уролог'),(3,'Хірург');
/*!40000 ALTER TABLE `specialties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `middle_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `sex` enum('M','F','O') COLLATE utf8mb4_unicode_ci DEFAULT 'O',
  `phone` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `specialty_id` int NOT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `specialty_id` (`specialty_id`),
  KEY `idx_staff_name` (`last_name`,`first_name`,`middle_name`),
  CONSTRAINT `staff_ibfk_1` FOREIGN KEY (`specialty_id`) REFERENCES `specialties` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,'Олексій','Сидоренко','Петрович','1975-02-02','M','+380501223344','sydorenko.o@gmail.com','Львів, вул. Лесі Українки 3',1,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(2,'Тетяна','Заболотна','Петрівна','1986-12-12','F','+380680756454','zabolotna.t@gmail.com','Львів, вул. Гребінки 8',2,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(3,'Олег','Шевченко','Васильович','1979-01-03','M','+380680361547','shevchenko.o@gmail.com','Львів, вул. Городоцька 32',3,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(4,'Олена','Коваленко','Василівна','1990-08-24','F','+380957462849','kovalenko.o@gmail.com','Львів, вул. Зелена 51',4,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(5,'Михайло','Бондаренко','Олегович','1983-09-12','M','+380864861956','bondarenko.m@gmail.com','Львів, вул. Личаківська 1',5,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(6,'Катерина','Ткаченко','Микитівна','1996-10-25','F','+380487560480','tkachenko.k@gmail.com','Львів, вул. Степана Бандери 6',6,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(7,'Даніель','Ковальчук','Олександрович','1992-04-16','M','+380417830505','kovalchuk.d@gmail.com','Львів, вул. Шевченка 11',7,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(8,'Анастасія','Олійник','Володимирівна','1989-11-03','F','+380994733367','oliinyk.a@gmail.com','Львів, вул. Коперника 51',7,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(9,'Катерина','Бойко','Андріївна','1983-01-15','F','+380338466754','boiko.k@gmail.com','Львів, вул. Пасічна 8',8,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(10,'Андрій','Савченко','Андрійович','1979-02-19','M','+380957452626','savchenko.a@gmail.com','Львів, вул. Тарнавського 109',9,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(11,'Олександра','Мороз','Василівна','1987-03-25','F','+380984076978','moroz.o@gmail.com','Львів, вул. Драгоманова 54',10,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(12,'Артем','Гриценко','Романович','1990-04-28','M','+380814374957','hrytsenko.a@gmail.com','Львів, вул. Виговського 76',11,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(13,'Юлія','Мельник','Остапівна','1994-05-06','F','+380004873625','melnyk.y@gmail.com','Львів, вул. Наукова 39',12,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(14,'Роман','Петренко','Олександрович','1986-06-10','M','+380546359593','petrenko.r@gmail.com','Львів, вул. Дорошенка 10',12,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(15,'Ярослав','Яковенко','Якович','1984-07-14','M','+38092566835','yakovenko.y@gmail.com','Львів, вул. Куліша 9',13,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(16,'Ангеліна','Гаврилюк','Михайлівна','1984-08-18','F','+380243425393','havryliuk.a@gmail.com','Львів, вул. Богдана Хмельницього 4',14,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(17,'Карина','Кушнір','Василівна','1977-09-30','F','+380565678501','kushnir.k@gmail.com','Львів, вул. Пекарська 7',14,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(18,'Андрій','Лисенко','Іванович','1989-10-11','M','+380831019107','lysenko.a@gmail.com','Львів, вул. Івана Франка 9',15,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(19,'Богдана','Литвин','Владиславівна','1988-11-16','F','+380646453892','lytvyn.b@gmail.com','Львів, вул. Зелена 8',17,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(20,'Михайло','Поліщук','Ярославович','1976-12-01','M','+380737789364','polishchuk.m@gmail.com','Львів, вул. Личаківська 9',16,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(21,'Адріана','Мазур','Олегівна','1990-01-06','F','+380648201045','mazur.a@gmail.com','Львів, вул. Коперника 12',16,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(22,'Владислав','Марченко','Богданович','1982-02-20','M','+3807352708020','marchenko.v@gmail.com','Львів, вул. Пасічна 22',16,1,'2025-12-02 22:06:52','2025-12-02 22:06:52'),(23,'Владислава','Шевчук','Володимирівна','1979-03-10','F','+380756493647','shevchuk.v@gmail.com','Львів, вул. Виговського 11',16,1,'2025-12-02 22:06:52','2025-12-02 22:06:52');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `login` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('chief','registrar','doctor') COLLATE utf8mb4_unicode_ci NOT NULL,
  `staff_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login` (`login`),
  KEY `staff_id` (`staff_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'registrator','registrator','registrar',NULL),(2,'chief','chief','chief',NULL),(3,'sydorenko_oleksii','sydorenko','doctor',1),(4,'zabolotna_tetiana','zabolotna','doctor',2),(5,'shevchenko_oleg','shevchenko','doctor',3),(6,'kovalenko_olena','kovalenko','doctor',4),(7,'bondarenko_mykhailo','bondarenko','doctor',5),(8,'tkachenko_kateryna','tkachenko','doctor',6),(9,'kovalchuk_daniel','kovalchuk','doctor',7),(10,'oliinyk_anastasiia','oliinyk','doctor',8),(11,'boiko_kateryna','boiko','doctor',9),(12,'savchenko_andrii','savchenko','doctor',10),(13,'moroz_oleksandra','moroz','doctor',11),(14,'hrytsenko_artem','hrytsenko','doctor',12),(15,'melnyk_yuliia','melnyk','doctor',13),(16,'petrenko_roman','petrenko','doctor',14),(17,'yakovenko_yaroslav','yakovenko','doctor',15),(18,'havryliuk_anhelina','havryliuk','doctor',16),(19,'kushnir_karyna','kushnir','doctor',17),(20,'lysenko_andrii','lysenko','doctor',18),(21,'lytvyn_bohdana','lytvyn','doctor',19),(22,'polishchuk_mykhailo','polishchuk','doctor',20),(23,'mazur_adriana','mazur','doctor',21),(24,'marchenko_vladyslav','marchenko','doctor',22),(25,'shevchuk_vladyslava','shevchuk','doctor',23);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visits`
--

DROP TABLE IF EXISTS `visits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visits` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `doctor_id` int NOT NULL,
  `scheduled_start` datetime NOT NULL,
  `scheduled_end` datetime DEFAULT NULL,
  `status` enum('scheduled','cancelled','done','no-show','pending_closure') COLLATE utf8mb4_unicode_ci DEFAULT 'scheduled',
  `reason` varchar(512) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_visits_patient_date` (`patient_id`,`scheduled_start`),
  KEY `idx_visits_doctor_date` (`doctor_id`,`scheduled_start`),
  CONSTRAINT `visits_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE CASCADE,
  CONSTRAINT `visits_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visits`
--

LOCK TABLES `visits` WRITE;
/*!40000 ALTER TABLE `visits` DISABLE KEYS */;
INSERT INTO `visits` VALUES (1,1,20,'2023-05-10 09:00:00','2023-05-10 09:20:00','done','Контроль тиску','Тиск стабілізовано','2025-12-02 22:06:52','2025-12-02 22:06:52'),(2,1,20,'2024-02-15 09:00:00','2024-02-15 09:20:00','no-show','Плановий огляд','Пацієнтка забула про візит','2025-12-02 22:06:52','2025-12-02 22:06:52'),(3,1,20,'2024-02-20 10:00:00','2024-02-20 10:20:00','done','Плановий огляд (перенесений)','Скарги на серцебиття, направлення до кардіолога','2025-12-02 22:06:52','2025-12-02 22:06:52'),(4,1,1,'2024-02-22 14:00:00','2024-02-22 14:30:00','done','Консультація кардіолога','Коригування дози ліків','2025-12-02 22:06:52','2025-12-02 22:06:52'),(5,1,20,'2025-12-15 09:00:00','2025-12-15 09:20:00','scheduled','Щорічний чекап','Здача аналізів','2025-12-02 22:06:52','2025-12-02 22:06:52'),(6,2,20,'2023-11-12 11:00:00','2023-11-12 11:20:00','done','Біль у коліні','Направлення до травматолога','2025-12-02 22:06:52','2025-12-02 22:06:52'),(7,2,2,'2023-11-14 15:00:00','2023-11-14 15:30:00','cancelled','Консультація травматолога','Лікар захворів, візит скасовано клінікою','2025-12-02 22:06:52','2025-12-02 22:06:52'),(8,2,2,'2023-11-20 10:00:00','2023-11-20 10:30:00','done','Консультація травматолога','Призначено фізіотерапію','2025-12-02 22:06:52','2025-12-02 22:06:52'),(9,2,20,'2025-11-28 11:00:00','2025-11-28 11:20:00','scheduled','Повторний рецепт','Знеболюючі','2025-12-02 22:06:52','2025-12-02 22:06:52'),(10,3,20,'2024-08-01 14:00:00','2024-08-01 14:20:00','done','Задишка','Підозра на бронхіт','2025-12-02 22:06:52','2025-12-02 22:06:52'),(11,3,20,'2024-08-05 14:00:00','2024-08-05 14:20:00','no-show','Контроль лікування','Не з`явилась','2025-12-02 22:06:52','2025-12-02 22:06:52'),(12,4,20,'2025-01-10 09:30:00','2025-01-10 09:50:00','scheduled','Профілактика','Вакцинація','2025-12-02 22:06:52','2025-12-02 22:06:52'),(13,5,20,'2024-04-10 12:00:00','2024-04-10 12:20:00','cancelled','Головний біль','Скасовано пацієнтом (покращення стану)','2025-12-02 22:06:52','2025-12-02 22:06:52'),(14,6,20,'2024-09-15 16:00:00','2024-09-15 16:20:00','done','Погіршення зору','Направлення до окуліста','2025-12-02 22:06:52','2025-12-02 22:06:52'),(15,6,6,'2024-09-20 11:00:00','2024-09-20 11:30:00','done','Підбір окулярів','Міопія слабкого ступеня','2025-12-02 22:06:52','2025-12-02 22:06:52'),(16,7,20,'2023-12-05 10:00:00','2023-12-05 10:20:00','done','Біль у спині','Радикуліт','2025-12-02 22:06:52','2025-12-02 22:06:52'),(17,8,21,'2024-01-20 09:00:00','2024-01-20 09:20:00','done','ГРВІ','Відкрито лікарняний','2025-12-02 22:06:52','2025-12-02 22:06:52'),(18,8,21,'2024-01-25 09:00:00','2024-01-25 09:20:00','done','Закриття лікарняного','Одужання','2025-12-02 22:06:52','2025-12-02 22:06:52'),(19,9,21,'2024-05-15 13:30:00','2024-05-15 13:50:00','no-show','Алергія','Забув прийти','2025-12-02 22:06:52','2025-12-02 22:06:52'),(20,9,21,'2024-05-16 13:30:00','2024-05-16 13:50:00','done','Алергія','Призначено антигістамінні','2025-12-02 22:06:52','2025-12-02 22:06:52'),(21,10,21,'2023-06-10 15:00:00','2023-06-10 15:20:00','done','Підтвердження вагітності','Направлення до гінеколога','2025-12-02 22:06:52','2025-12-02 22:06:52'),(22,10,7,'2023-06-12 10:00:00','2023-06-12 10:30:00','done','Постановка на облік','10 тижнів','2025-12-02 22:06:52','2025-12-02 22:06:52'),(23,10,21,'2025-12-01 10:00:00','2025-12-01 10:20:00','scheduled','Огляд після пологів','Загальний стан','2025-12-02 22:06:52','2025-12-02 22:06:52'),(24,11,21,'2024-10-12 11:00:00','2024-10-12 11:20:00','cancelled','Кашель','Лікар у відпустці','2025-12-02 22:06:52','2025-12-02 22:06:52'),(25,12,21,'2025-02-14 10:45:00','2025-02-14 11:00:00','scheduled','Довідка для водіння','Огляд','2025-12-02 22:06:52','2025-12-02 22:06:52'),(26,13,21,'2024-09-01 14:00:00','2024-09-01 14:20:00','done','Довідка для університету','Видано форму 086','2025-12-02 22:06:52','2025-12-02 22:06:52'),(27,14,21,'2024-03-08 09:00:00','2024-03-08 09:20:00','no-show','Святковий день','Помилковий запис','2025-12-02 22:06:52','2025-12-02 22:06:52'),(28,15,22,'2024-07-20 08:30:00','2024-07-20 08:50:00','done','Забій ноги','Направлення на рентген','2025-12-02 22:06:52','2025-12-02 22:06:52'),(29,15,2,'2024-07-20 11:00:00','2024-07-20 11:30:00','done','Рентген','Перелому немає','2025-12-02 22:06:52','2025-12-02 22:06:52'),(30,16,22,'2023-11-15 12:00:00','2023-11-15 12:20:00','done','Безсоння','Рекомендовано режим дня','2025-12-02 22:06:52','2025-12-02 22:06:52'),(31,17,22,'2025-01-20 10:15:00','2025-01-20 10:35:00','scheduled','Біль у шлунку','Консультація','2025-12-02 22:06:52','2025-12-02 22:06:52'),(32,18,22,'2024-12-10 15:00:00','2024-12-10 15:20:00','scheduled','Плановий огляд','Скарг немає','2025-12-02 22:06:52','2025-12-02 22:06:52'),(33,19,22,'2023-05-25 09:45:00','2023-05-25 10:05:00','done','Задишка','Направлення до кардіолога','2025-12-02 22:06:52','2025-12-02 22:06:52'),(34,19,1,'2023-05-27 10:00:00','2023-05-27 10:30:00','done','ЕКГ','Аритмія','2025-12-02 22:06:52','2025-12-02 22:06:52'),(35,19,1,'2024-06-01 10:00:00','2024-06-01 10:30:00','cancelled','Повторний огляд','Скасовано пацієнтом','2025-12-02 22:06:52','2025-12-02 22:06:52'),(36,20,22,'2024-04-05 13:20:00','2024-04-05 13:40:00','done','Висип на обличчі','Направлення до дерматолога','2025-12-02 22:06:52','2025-12-02 22:06:52'),(37,20,15,'2024-04-10 14:00:00','2024-04-10 14:30:00','done','Акне','Призначено лікування','2025-12-02 22:06:52','2025-12-02 22:06:52'),(38,21,22,'2024-02-14 11:30:00','2024-02-14 11:50:00','done','Грип','Лікарняний','2025-12-02 22:06:52','2025-12-02 22:06:52'),(39,22,23,'2024-11-10 14:00:00','2024-11-10 14:20:00','done','Мігрень','Консультація','2025-12-02 22:06:52','2025-12-02 22:06:52'),(40,23,23,'2025-11-28 10:30:00','2025-11-28 10:50:00','scheduled','Біль у горлі','Огляд','2025-12-02 22:06:52','2025-12-02 22:06:52'),(41,24,23,'2023-09-15 16:15:00','2023-09-15 16:35:00','done','Біль у попереку','Направлення на УЗД','2025-12-02 22:06:52','2025-12-02 22:06:52'),(42,24,10,'2023-09-16 09:00:00','2023-09-16 09:30:00','done','УЗД нирок','Пісок у нирках','2025-12-02 22:06:52','2025-12-02 22:06:52'),(43,25,23,'2024-01-20 11:00:00','2024-01-20 11:20:00','no-show','Травма пальця','Не прийшов','2025-12-02 22:06:52','2025-12-02 22:06:52'),(44,26,23,'2025-12-05 15:45:00','2025-12-05 16:00:00','scheduled','Щеплення','Гепатит Б (3-тя доза)','2025-12-02 22:06:52','2025-12-02 22:06:52'),(45,27,23,'2024-08-10 09:20:00','2024-08-10 09:40:00','done','Аритмія','Направлення до кардіолога','2025-12-02 22:06:52','2025-12-02 22:06:52'),(46,27,1,'2024-08-15 11:00:00','2024-08-15 11:30:00','cancelled','Консультація кардіолога','Лікар на операції','2025-12-02 22:06:52','2025-12-02 22:06:52'),(47,28,23,'2024-05-05 12:00:00','2024-05-05 12:20:00','done','Цистит','Гострий біль','2025-12-02 22:06:52','2025-12-02 22:06:52'),(48,29,23,'2024-11-25 13:00:00','2024-11-25 13:20:00','done','Профілактика','Здоровий','2025-12-02 22:06:52','2025-12-02 22:06:52'),(49,30,23,'2024-05-14 14:30:00','2024-05-14 14:50:00','done','Слабкість','Низький гемоглобін','2025-12-02 22:06:52','2025-12-02 22:06:52'),(50,30,23,'2024-12-20 14:30:00','2024-12-20 14:50:00','scheduled','Контроль аналізів','Після курсу заліза','2025-12-02 22:06:52','2025-12-02 22:06:52');
/*!40000 ALTER TABLE `visits` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  0:07:27

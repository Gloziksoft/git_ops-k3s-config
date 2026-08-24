-- MySQL dump 10.13  Distrib 9.3.0, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: insurance_app
-- ------------------------------------------------------
-- Server version	11.8.2-MariaDB-ubu2404

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `event_entity`
--

DROP TABLE IF EXISTS `event_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_entity` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(500) NOT NULL,
  `event_date` datetime NOT NULL,
  `insurance_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK3m7tggjp1idedead27qfgm7x3` (`insurance_id`),
  CONSTRAINT `FK3m7tggjp1idedead27qfgm7x3` FOREIGN KEY (`insurance_id`) REFERENCES `insurance_entity` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_entity`
--

LOCK TABLES `event_entity` WRITE;
/*!40000 ALTER TABLE `event_entity` DISABLE KEYS */;
INSERT INTO `event_entity` VALUES (1,'Vytvorenie poistenia pre Peter Horváth','2025-04-29 10:05:36',1),(2,'Vytvorenie poistenia pre Kristína  Urbanová','2025-04-29 10:14:06',2),(3,'Vytvorenie poistenia pre Martin Novák','2025-04-29 10:14:45',3),(4,'Vytvorenie poistenia pre Martin Blažek','2025-04-29 10:16:15',4),(5,'Vytvorenie poistenia pre Lucia Kováčová','2025-04-29 10:17:22',5),(6,'Vytvorenie poistenia pre Lucia Kováčová','2025-04-29 10:19:43',6),(7,'Vytvorenie poistenia pre Ján Hronček','2025-04-29 11:44:29',7),(8,'Vytvorenie poistenia pre Gajdos Jan','2025-07-16 23:17:48',8);
/*!40000 ALTER TABLE `event_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insurance_entity`
--

DROP TABLE IF EXISTS `insurance_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insurance_entity` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `end_date` date DEFAULT NULL,
  `insurance_type` varchar(255) DEFAULT NULL,
  `insured_amount` double DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `insured_person_id` bigint(20) DEFAULT NULL,
  `policy_holder_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKnaytb8gynrnxanwpdsgxbjucm` (`insured_person_id`),
  KEY `FKe05enplpsvdu63sb2nferidss` (`policy_holder_id`),
  CONSTRAINT `FKe05enplpsvdu63sb2nferidss` FOREIGN KEY (`policy_holder_id`) REFERENCES `insured_person_entity` (`id`),
  CONSTRAINT `FKnaytb8gynrnxanwpdsgxbjucm` FOREIGN KEY (`insured_person_id`) REFERENCES `insured_person_entity` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insurance_entity`
--

LOCK TABLES `insurance_entity` WRITE;
/*!40000 ALTER TABLE `insurance_entity` DISABLE KEYS */;
INSERT INTO `insurance_entity` VALUES (1,'2030-11-29','APARTMENT',15800,'2025-04-29',3,7),(2,'2040-04-29','HOUSE',25900,'2025-04-29',8,9),(3,'2045-04-29','PROPERTY',100987,'2025-04-29',1,5),(4,'2042-04-29','LIFE',150999,'2025-04-29',4,11),(5,'2026-04-29','TRAVEL',3789,'2025-04-29',2,6),(6,'2030-04-29','ACCIDENT',4500,'2025-04-29',2,10),(7,'2027-04-29','CAR',3890,'2025-04-29',12,8),(8,'2030-01-16','CAR',1000,'2025-07-16',13,13);
/*!40000 ALTER TABLE `insurance_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `insured_person_entity`
--

DROP TABLE IF EXISTS `insured_person_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `insured_person_entity` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `age` int(11) NOT NULL,
  `city` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `postal_code` varchar(255) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_borul041hwdwbaq2r70iwkt86` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `insured_person_entity`
--

LOCK TABLES `insured_person_entity` WRITE;
/*!40000 ALTER TABLE `insured_person_entity` DISABLE KEYS */;
INSERT INTO `insured_person_entity` VALUES (1,45,'Bratislava','martinnovak@test.com','Martin','Novák','+421 911 234 567','821 01','Hlavná 12'),(2,52,'Košice','luciakovacova@test.com','Lucia','Kováčová','+421 902 345 678','040 01','Jarná 45'),(3,32,'Žilina','peterhorvath@test.com','Peter','Horváth','+421 903 456 789',' 010 01','kolská 7/5'),(4,45,'Prešov','martinblazek@test.com','Martin','Blažek','2546 568 568','911 05','Brezová 227/45'),(5,65,'Trenčín','jangregor@test.com','Ján','Gregor','+421 915 012 345','012 35','Poľná 358/4'),(6,32,'Trenčín','ivanacerna@test.com','Ivana','Černá','+421 915 012 345','911 05','Poľná 345/47'),(7,25,'Banská Bystrica','barbarakralova@test.com','Barbara','Kráľová','+421 904 123 456','974 01','Družstevná 6896/12'),(8,23,'Nitra','kristinaurbanova@test.com','Kristína ','Urbanová','+421 917 789 012','911 01','Brezová 2258/45'),(9,28,'Košice','dominikvarga@test.com','Dominik','Varga','+421 944 333 444','040 15','Kvetná 5897/75'),(10,36,'Zvolen','michalsvec@test.com','Michal','Švec','0907 777 888','960 01','Námestie SNP 1587/36'),(11,22,'Trnava','patrikdanis@test.com','Patrik','Daniš','0910 555 666','917 07','Tichá 725/8'),(12,38,'Sereď','janhroncek@test.com','Ján','Hronček','2542 568 924','568 23','Parková 4587/14'),(13,22,'Jarabová','jangajdos@test.com','Jan','Gajdos','+421 903 456 789','96205','Školská');
/*!40000 ALTER TABLE `insured_person_entity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_entity`
--

DROP TABLE IF EXISTS `user_entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_entity` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `admin` bit(1) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UK_4xad1enskw4j1t2866f7sodrx` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_entity`
--

LOCK TABLES `user_entity` WRITE;
/*!40000 ALTER TABLE `user_entity` DISABLE KEYS */;
INSERT INTO `user_entity` VALUES (1,_binary '','admin@test.com','$2a$10$wRc3S1GlJRP1LoLY665eoO9E83G4VTKbfPwKt052wdBdy154VzeQi','admin','admin'),(2,_binary '\0','user@test.com','$2a$10$ZlanUJQA/8mLIzufZUUXYOIzo92NuWjhXywB7zyJ1tINbJu4EdK/S','user','user'),(3,_binary '\0','martinnovak@test.com','$2a$10$QppP0DXHmbdQi3gwTtaH4usnWn2D5ou6EPKBK8xXxYRbX40XAIxnG','',''),(4,_binary '\0','luciakovacova@test.com','$2a$10$qlBDvBekKtm.aRzktupqNujxBWS0G7qmjoyt7L6bmaGNeQBKm8WZ6','',''),(5,_binary '\0','jangajdos@test.com','$2a$10$yM32HiJMfUi1eqtOa/MER.X6vda7RcstYGROLiznri/QcBapl8fI6','Jan','Gajdos');
/*!40000 ALTER TABLE `user_entity` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-16 22:08:01

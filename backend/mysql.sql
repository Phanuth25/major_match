CREATE DATABASE  IF NOT EXISTS `majormatch` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `majormatch`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: majormatch
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `majors`
--

DROP TABLE IF EXISTS `majors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `majors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `image` varchar(255) DEFAULT NULL,
  `career` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `majors`
--

LOCK TABLES `majors` WRITE;
/*!40000 ALTER TABLE `majors` DISABLE KEYS */;
INSERT INTO `majors` VALUES (1,'Computer Science','Study of software development and algorithms.','cs.jpg','Software Engineer, AI Engineer'),(2,'Information Technology','Study of computer systems and networking.','it.jpg','System Administrator, Network Engineer'),(3,'Graphic Design','Visual communication and digital design.','gd.jpg','Graphic Designer, UI Designer'),(4,'Accounting','Financial management and bookkeeping.','acc.jpg','Accountant, Auditor'),(5,'Business Administration','Business management and entrepreneurship.','business.jpg','Business Manager, Entrepreneur'),(6,'Civil Engineering','Design and construction of infrastructure and buildings.','ce.jpg','Civil Engineer, Structural Engineer'),(7,'Mechanical Engineering','Study of machinery, mechanics, and manufacturing systems.','me.jpg','Mechanical Engineer, Automotive Engineer'),(8,'Marketing','Promotion and branding of products and services.','mkt.jpg','Marketing Manager, Brand Strategist'),(9,'Nursing','Patient care and clinical health practices.','nurs.jpg','Registered Nurse, Nurse Practitioner'),(10,'Architecture','Design of buildings and urban spaces.','arch.jpg','Architect, Urban Planner');
/*!40000 ALTER TABLE `majors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question` text NOT NULL,
  `major_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_question_major` (`major_id`),
  CONSTRAINT `fk_question_major` FOREIGN KEY (`major_id`) REFERENCES `majors` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (1,'I enjoy solving programming problems.',1),(2,'I like repairing computer hardware.',2),(3,'I enjoy creating logos and posters.',3),(4,'I like working with numbers and budgets.',4),(5,'I enjoy leading a team and making business decisions.',5),(16,'I enjoy designing infrastructure like roads, bridges, and buildings.',6),(17,'I enjoy figuring out how machines and mechanical systems work.',7),(18,'I enjoy coming up with ideas to promote and sell a product.',8),(19,'I feel a sense of purpose helping people who are sick or in pain.',9),(20,'I like sketching and designing buildings or spaces.',10),(21,'I like learning new programming languages and frameworks.',1),(22,'I enjoy debugging and fixing errors in code.',1),(23,'I\'m interested in how software systems are built from scratch.',1),(24,'I like working on personal coding projects in my free time.',1),(25,'I enjoy setting up and configuring computer networks.',2),(26,'I like troubleshooting technical problems for others.',2),(27,'I\'m interested in keeping systems secure from cyber threats.',2),(28,'I enjoy maintaining servers and IT infrastructure.',2),(29,'I like experimenting with colors, fonts, and layouts.',3),(30,'I enjoy using design software like Photoshop or Illustrator.',3),(31,'I like turning ideas into visual concepts.',3),(32,'I enjoy giving feedback on the visual style of a project.',3),(33,'I enjoy organizing and tracking financial records.',4),(34,'I\'m comfortable working with spreadsheets and formulas.',4),(35,'I like ensuring accuracy in financial reports.',4),(36,'I enjoy analyzing where money is being spent and saved.',4),(37,'I like planning strategies to grow a business.',5),(38,'I enjoy managing projects and coordinating with different teams.',5),(39,'I\'m interested in how companies are structured and run.',5),(40,'I like negotiating and making deals.',5),(41,'I like solving structural and construction problems.',6),(42,'I\'m interested in how buildings withstand natural forces.',6),(43,'I enjoy working with blueprints and technical drawings.',6),(44,'I like visiting construction sites to see projects come to life.',6),(45,'I like taking things apart to see how they work.',7),(46,'I enjoy designing and building mechanical parts.',7),(47,'I\'m interested in robotics and automation.',7),(48,'I like solving problems related to motion and energy.',7),(49,'I like understanding what makes people want to buy things.',8),(50,'I enjoy creating content for social media or advertising.',8),(51,'I\'m interested in analyzing trends and consumer behavior.',8),(52,'I like coming up with catchy slogans and campaigns.',8),(53,'I stay calm when dealing with emergencies.',9),(54,'I\'m comfortable working closely with patients and their families.',9),(55,'I enjoy learning about the human body and medicine.',9),(56,'I like providing comfort and care to people in need.',9),(57,'I enjoy imagining how spaces can be used effectively.',10),(58,'I like combining creativity with technical planning.',10),(59,'I\'m interested in how buildings affect the environment around them.',10),(60,'I enjoy studying different architectural styles.',10);
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_attempt`
--

DROP TABLE IF EXISTS `quiz_attempt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_attempt` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `started_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `duration_second` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_attempt_user` (`user_id`),
  CONSTRAINT `fk_attempt_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_attempt`
--

LOCK TABLES `quiz_attempt` WRITE;
/*!40000 ALTER TABLE `quiz_attempt` DISABLE KEYS */;
INSERT INTO `quiz_attempt` VALUES (1,1,'2026-08-06 09:00:00',520),(2,2,'2026-08-06 09:20:00',480),(3,3,'2026-08-06 10:00:00',610),(4,4,'2026-08-06 10:30:00',430),(5,5,'2026-08-06 11:00:00',560),(6,1,'2026-08-06 09:00:00',250),(7,8,'2026-08-25 15:09:44',10),(8,8,'2026-08-25 15:22:30',11),(9,8,'2026-08-25 15:22:46',11),(10,8,'2026-08-25 16:42:15',14),(11,8,'2026-08-25 16:43:07',14),(12,8,'2026-08-25 16:49:17',9);
/*!40000 ALTER TABLE `quiz_attempt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_attempt_detail`
--

DROP TABLE IF EXISTS `quiz_attempt_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_attempt_detail` (
  `attempt_id` bigint NOT NULL,
  `question_id` int NOT NULL,
  `answer` tinyint NOT NULL,
  PRIMARY KEY (`attempt_id`,`question_id`),
  KEY `fk_detail_question` (`question_id`),
  CONSTRAINT `fk_detail_attempt` FOREIGN KEY (`attempt_id`) REFERENCES `quiz_attempt` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_detail_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_attempt_detail`
--

LOCK TABLES `quiz_attempt_detail` WRITE;
/*!40000 ALTER TABLE `quiz_attempt_detail` DISABLE KEYS */;
INSERT INTO `quiz_attempt_detail` VALUES (1,1,5),(1,2,4),(1,3,2),(1,4,2),(1,5,3),(2,1,2),(2,2,5),(2,3,3),(2,4,2),(2,5,2),(3,1,2),(3,2,2),(3,3,5),(3,4,3),(3,5,2),(4,1,1),(4,2,2),(4,3,2),(4,4,5),(4,5,4),(5,1,3),(5,2,3),(5,3,3),(5,4,4),(5,5,5);
/*!40000 ALTER TABLE `quiz_attempt_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_final_result`
--

DROP TABLE IF EXISTS `quiz_final_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_final_result` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quiz_attempt_id` bigint NOT NULL,
  `major_id` int NOT NULL,
  `score` decimal(5,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rec_attempt` (`quiz_attempt_id`),
  KEY `fk_rec_major` (`major_id`),
  CONSTRAINT `fk_rec_attempt` FOREIGN KEY (`quiz_attempt_id`) REFERENCES `quiz_attempt` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rec_major` FOREIGN KEY (`major_id`) REFERENCES `majors` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_final_result`
--

LOCK TABLES `quiz_final_result` WRITE;
/*!40000 ALTER TABLE `quiz_final_result` DISABLE KEYS */;
INSERT INTO `quiz_final_result` VALUES (1,1,1,92.50),(2,2,2,90.20),(3,3,3,95.00),(4,4,4,91.80),(5,5,5,93.40);
/*!40000 ALTER TABLE `quiz_final_result` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Alice Johnson','alice@example.com','password123','alice.jpg'),(2,'Bob Smith','bob@example.com','password123','bob.jpg'),(3,'Charlie Brown','charlie@example.com','password123','charlie.jpg'),(4,'David Lee','david@example.com','password123','david.jpg'),(5,'Emma Wilson','emma@example.com','password123','emma.jpg'),(6,'Nuth','Phanuth@gmail.com','123','nuth.jpg'),(7,'Pha nuth','213@gmail.com','Aa123456&',NULL),(8,'Oliver Kahn','123@gmail.com','Az123456&','https://res.cloudinary.com/dregfwrgo/image/upload/v1786586831/v6anv44orlxfx8er8dog.jpg');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'majormatch'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-26 15:08:44

-- MySQL dump 10.15  Distrib 10.0.15-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: constructionmanager
-- ------------------------------------------------------
-- Server version	10.0.15-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `display_name` varchar(100) DEFAULT NULL,
  `login_name` varchar(10) DEFAULT NULL,
  `last_schema_update` varchar(19) DEFAULT NULL,
  `connection_string` blob,
  `sage_integration_url` varchar(255) DEFAULT NULL,
  `sage_integration_password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
INSERT INTO `companies` VALUES (1,'JNC Solutions Ltd.','jnc','2014.05.27.11.51.07','êÔaËx÷ôGy®óaËAƒ·±}–Î˚vYëjb⁄ºAg3Ê+ñƒÄØ ®∂‚PKdÀj©\'Ù\Z?Ømy∏Ô∂úTÁè´ƒ%:Æ7˜S}Jã?o±7π%∏ó*Ôß´l','','derp'),(2,'Herp','Derp',NULL,'yÅZ‡\ry˚.AO#î<∞ŸæÛ‘¥{ƒ>à1‘ΩMæ’∑§Í∞XRT9∫π\n™à◊S™Dófx’∫≠ß=øyzi∞·{_*% `«{\\2≥oR{#!2hç´íMœ','',''),(4,'foobar',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_sessions`
--

DROP TABLE IF EXISTS `company_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `xid_company` int(11) DEFAULT NULL,
  `xid_user` int(11) DEFAULT NULL,
  `session_status` varchar(50) DEFAULT NULL,
  `time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=85 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_sessions`
--

LOCK TABLES `company_sessions` WRITE;
/*!40000 ALTER TABLE `company_sessions` DISABLE KEYS */;
INSERT INTO `company_sessions` VALUES (84,1,1,'active','2014-06-04 11:28:45');
/*!40000 ALTER TABLE `company_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `contact_name` varchar(50) DEFAULT NULL,
  `vat_reg_no` varchar(20) DEFAULT NULL,
  `notes` varchar(2000) DEFAULT NULL,
  `address_1` varchar(50) DEFAULT NULL,
  `address_2` varchar(50) DEFAULT NULL,
  `town` varchar(50) DEFAULT NULL,
  `region` varchar(50) DEFAULT NULL,
  `postcode` varchar(50) DEFAULT NULL,
  `country_code` varchar(3) DEFAULT NULL,
  `tel` varchar(50) DEFAULT NULL,
  `tel_2` varchar(50) DEFAULT NULL,
  `fax` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `www` varchar(50) DEFAULT NULL,
  `xid_tax_rate` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'Doohickeys International','Bertha White','737107610088','Pays their invoice on time.','164 Queen Avenue','','Wakefield','County','PH88 4BV','GB','82618 552674','11471 182338','','bertha@doohickeysinternational.com','http://www.doohickeysinternational.com',1),(2,'Doodads Corp.','Bertha Thompson','5415306150','Bad customer! Never wants to pay their bills.','63 Station Avenue','','Bristol','Berkshire','OV43 9HW','GB','38536 235936','68414 888166','','bertha@doodadscorp.com','http://www.doodadscorp.com',1),(3,'Building International','Barry Walker','0483759076','Pays their invoice on time.','497 Richmond Avenue','','Birmingham','Buckinghamshire','QU81 1MK','GB','65869 847521','39833 651417','','barry@buildinginternational.com','http://www.buildinginternational.com',1),(4,'Building Corp.','Alice Evans','69996011810','They had a new garage roof put up.','344 Richmond Avenue','','Birmingham','Gloucestershire','IH39 5UN','GB','26118 577177','89188 732221','','alice@buildingcorp.com','http://www.buildingcorp.com',1),(5,'Widgets Corp.','Bertha Davies','3610106322410','Pays their invoice on time.','522 School Road','','Cheshire','Gloucestershire','UE23 5OH','GB','88923 465835','21496 197946','','bertha@widgetscorp.com','http://www.widgetscorp.com',1),(6,'Doohickeys International','Chris Wilson','3299332340','Bad customer! Never wants to pay their bills.','724 Manchester Lane','','Liverpool','Cleveland','UC66 3FE','GB','72949 291873','52153 247887','','chris@doohickeysinternational.com','http://www.doohickeysinternational.com',1),(7,'Construction Ltd.','Alice Thompson','1744770974','Pays their invoice on time.','37 Victoria Lane','','Coventry','Avon','OE72 0VY','GB','75442 527441','73839 797446','','alice@constructionltd.com','http://www.constructionltd.com',1),(8,'Construction Ltd.','Chris Hall','5480373735','Pays their invoice on time.','709 Albert Close','','Cornwall','Bedfordshire','XG53 0IS','GB','42492 554478','42139 142626','','chris@constructionltd.com','http://www.constructionltd.com',1),(9,'Doodads Corp.','Daria Johnson','3983368130','Bad customer! Never wants to pay their bills.','280 Windsor Lane','','Ealing','Cleveland','QI17 2MC','GB','67416 997736','39653 219757','','daria@doodadscorp.com','http://www.doodadscorp.com',1),(10,'Doodads Corp.','Darren Taylor','2225310910310','Bad customer! Never wants to pay their bills.','736 West Way','','Leicester','County','PF03 2VN','GB','32979 458187','25568 133273','','darren@doodadscorp.com','http://www.doodadscorp.com',1);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invites`
--

DROP TABLE IF EXISTS `invites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `invite_code` text,
  `recipient` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invites`
--

LOCK TABLES `invites` WRITE;
/*!40000 ALTER TABLE `invites` DISABLE KEYS */;
/*!40000 ALTER TABLE `invites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_requests`
--

DROP TABLE IF EXISTS `password_reset_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_reset_requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` text,
  `token` text,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_requests`
--

LOCK TABLES `password_reset_requests` WRITE;
/*!40000 ALTER TABLE `password_reset_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `id_company` int(11) NOT NULL,
  `contracts` int(11) DEFAULT NULL,
  `maintenance` int(11) DEFAULT NULL,
  `visitlist` int(11) DEFAULT NULL,
  `purchaseorders` int(11) DEFAULT NULL,
  `purchaseinvoices` int(11) DEFAULT NULL,
  `quotes` int(11) DEFAULT NULL,
  `customers` int(11) DEFAULT NULL,
  `planner` int(11) DEFAULT NULL,
  `products` int(11) DEFAULT NULL,
  `reports` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_company`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,1,1,1,1,1,1,1,1,1,1),(2,1,1,1,1,1,1,1,1,1,1),(4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quote_items`
--

DROP TABLE IF EXISTS `quote_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quote_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `xid_quote` int(11) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `description` text,
  `quantity` int(11) DEFAULT NULL,
  `unit_price` decimal(30,2) DEFAULT NULL,
  `discount_percentage` decimal(30,2) DEFAULT NULL,
  `net` decimal(30,2) DEFAULT NULL,
  `vat_rate` decimal(30,2) DEFAULT NULL,
  `vat` decimal(30,2) DEFAULT NULL,
  `total` decimal(30,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quote_items`
--

LOCK TABLES `quote_items` WRITE;
/*!40000 ALTER TABLE `quote_items` DISABLE KEYS */;
INSERT INTO `quote_items` VALUES (1,2,'JNC3229','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(2,8,'JNC1402','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(3,2,'JNC528','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(4,2,'JNC7129','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(5,9,'JNC6166','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(6,4,'JNC8539','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(7,6,'JNC8582','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(8,6,'JNC1570','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(9,9,'JNC1213','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(10,1,'JNC7159','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(11,2,'JNC2496','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(12,9,'JNC1245','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(13,10,'JNC5868','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(14,4,'JNC4764','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(15,7,'JNC9769','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(16,8,'JNC3655','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(17,9,'JNC7634','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(18,3,'JNC8854','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(19,9,'JNC7901','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(20,10,'JNC6299','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(21,4,'JNC4008','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(22,4,'JNC6927','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(23,5,'JNC4393','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(24,4,'JNC6677','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(25,1,'JNC2492','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(26,5,'JNC6485','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(27,3,'JNC6744','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(28,7,'JNC2290','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(29,9,'JNC585','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(30,4,'JNC5028','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(31,1,'JNC2454','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(32,5,'JNC637','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(33,5,'JNC5788','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(34,7,'JNC55','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(35,5,'JNC9024','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(36,8,'JNC9219','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(37,7,'JNC5600','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(38,3,'JNC9066','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(39,3,'JNC3953','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00),(40,1,'JNC5535','JNC Widget Doobry',1,1.00,1.00,1.00,1.00,1.00,1.00);
/*!40000 ALTER TABLE `quote_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quote_statuses`
--

DROP TABLE IF EXISTS `quote_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quote_statuses` (
  `id` int(11) DEFAULT NULL,
  `status_name` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quote_statuses`
--

LOCK TABLES `quote_statuses` WRITE;
/*!40000 ALTER TABLE `quote_statuses` DISABLE KEYS */;
/*!40000 ALTER TABLE `quote_statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quotes`
--

DROP TABLE IF EXISTS `quotes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quotes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `xid_customer` int(11) DEFAULT NULL,
  `xid_status` int(11) DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `details` text,
  `net` decimal(30,2) DEFAULT NULL,
  `vat` decimal(30,2) DEFAULT NULL,
  `invoiced` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quotes`
--

LOCK TABLES `quotes` WRITE;
/*!40000 ALTER TABLE `quotes` DISABLE KEYS */;
INSERT INTO `quotes` VALUES (1,7,NULL,'2014-01-20 13:09:09','2012-02-15 00:00:00','New boiler parts for science department.',100.00,20.00,NULL),(2,2,NULL,'2014-01-20 13:09:09','2011-02-05 00:00:00','New boiler parts for science department.',100.00,20.00,NULL),(3,3,NULL,'2014-01-20 13:09:09','2010-07-12 00:00:00','New boiler parts for science department.',100.00,20.00,NULL),(4,4,NULL,'2014-01-20 13:09:09','2013-07-27 00:00:00','Assemble IKEA furniture.',100.00,20.00,NULL),(5,1,NULL,'2014-01-20 13:09:09','2012-12-09 00:00:00','Replace broken roof tiles.',100.00,20.00,NULL),(6,5,NULL,'2014-01-20 13:09:09','2012-08-27 00:00:00','New boiler parts for science department.',100.00,20.00,NULL),(7,9,NULL,'2014-01-20 13:09:09','2013-10-15 00:00:00','New boiler parts for science department.',100.00,20.00,NULL),(8,9,NULL,'2014-01-20 13:09:09','2012-07-14 00:00:00','Assemble IKEA furniture.',100.00,20.00,NULL),(9,4,NULL,'2014-01-20 13:09:09','2010-07-12 00:00:00','Replace broken roof tiles.',100.00,20.00,NULL),(10,1,NULL,'2014-01-20 13:09:09','2013-08-19 00:00:00','Replace broken roof tiles.',100.00,20.00,NULL);
/*!40000 ALTER TABLE `quotes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20140707105041'),('20140708132319'),('20140717131941'),('20140910094631');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_items`
--

DROP TABLE IF EXISTS `stock_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stock_items` (
  `code` varchar(50) NOT NULL,
  `short_description` varchar(64) DEFAULT NULL,
  `long_description` varchar(500) DEFAULT NULL,
  `unit_cost` decimal(30,2) DEFAULT NULL,
  `unit_type` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_items`
--

LOCK TABLES `stock_items` WRITE;
/*!40000 ALTER TABLE `stock_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_access_rights`
--

DROP TABLE IF EXISTS `user_access_rights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_access_rights` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `constructionmanageradministration` int(11) DEFAULT NULL,
  `databackup` int(11) DEFAULT NULL,
  `customers_add` int(11) DEFAULT NULL,
  `customers_edit` int(11) DEFAULT NULL,
  `customers_delete` int(11) DEFAULT NULL,
  `customers_applications_add` int(11) DEFAULT NULL,
  `customers_applications_edit` int(11) DEFAULT NULL,
  `customers_applications_delete` int(11) DEFAULT NULL,
  `customers_applications_certify_post` int(11) DEFAULT NULL,
  `customers_applications_salesinvoices` int(11) DEFAULT NULL,
  `customers_certificates_post` int(11) DEFAULT NULL,
  `customers_certificates_delete` int(11) DEFAULT NULL,
  `customers_receipts_new` int(11) DEFAULT NULL,
  `customers_receipts_delete` int(11) DEFAULT NULL,
  `customers_invoices_newinvoice` int(11) DEFAULT NULL,
  `customers_invoices_newcredit` int(11) DEFAULT NULL,
  `customers_invoices_edit` int(11) DEFAULT NULL,
  `customers_invoices_delete` int(11) DEFAULT NULL,
  `customers_invoices_invoicing` int(11) DEFAULT NULL,
  `customers_invoices_post` int(11) DEFAULT NULL,
  `suppliers_new` int(11) DEFAULT NULL,
  `suppliers_edit` int(11) DEFAULT NULL,
  `suppliers_delete` int(11) DEFAULT NULL,
  `suppliers_invoice_newinvoice` int(11) DEFAULT NULL,
  `suppliers_invoice_newcredit` int(11) DEFAULT NULL,
  `suppliers_invoice_edit` int(11) DEFAULT NULL,
  `suppliers_invoice_delete` int(11) DEFAULT NULL,
  `suppliers_invoice_post` int(11) DEFAULT NULL,
  `suppliers_products_in` int(11) DEFAULT NULL,
  `suppliers_products_out` int(11) DEFAULT NULL,
  `suppliers_products_edit` int(11) DEFAULT NULL,
  `suppliers_products_delete` int(11) DEFAULT NULL,
  `suppliers_purchaseorders_new` int(11) DEFAULT NULL,
  `suppliers_purchaseorders_edit` int(11) DEFAULT NULL,
  `suppliers_purchaseorders_delete` int(11) DEFAULT NULL,
  `suppliers_purchaseorders_order` int(11) DEFAULT NULL,
  `suppliers_purchaseorders_goodsreceived` int(11) DEFAULT NULL,
  `suppliers_purchaseorders_update` int(11) DEFAULT NULL,
  `suppliers_purchaseorders_orderactivity` int(11) DEFAULT NULL,
  `suppliers_purchaseorders_post` int(11) DEFAULT NULL,
  `suppliers_purchaseorders_approval` int(11) DEFAULT NULL,
  `subcontractors_applications_new` int(11) DEFAULT NULL,
  `subcontractors_applications_edit` int(11) DEFAULT NULL,
  `subcontractors_applications_delete` int(11) DEFAULT NULL,
  `subcontractors_applications_certify_post` int(11) DEFAULT NULL,
  `subcontractors_certificates_new` int(11) DEFAULT NULL,
  `subcontractors_certificates_batch` int(11) DEFAULT NULL,
  `subcontractors_certificates_edit` int(11) DEFAULT NULL,
  `subcontractors_certificates_delete` int(11) DEFAULT NULL,
  `subcontractors_certificates_post` int(11) DEFAULT NULL,
  `subcontractors_worksheets_new` int(11) DEFAULT NULL,
  `subcontractors_worksheets_edit` int(11) DEFAULT NULL,
  `subcontractors_worksheets_certify_post` int(11) DEFAULT NULL,
  `subcontractors_worksheets_delete` int(11) DEFAULT NULL,
  `subcontractors_payments_new` int(11) DEFAULT NULL,
  `subcontractors_payments_edit` int(11) DEFAULT NULL,
  `subcontractors_payments_delete` int(11) DEFAULT NULL,
  `subcontractors_payments_post` int(11) DEFAULT NULL,
  `subcontractors_returns_new` int(11) DEFAULT NULL,
  `subcontractors_returns_edit` int(11) DEFAULT NULL,
  `subcontractors_returns_delete` int(11) DEFAULT NULL,
  `subcontractors_returns_esubmissions` int(11) DEFAULT NULL,
  `subcontractors_pop_new` int(11) DEFAULT NULL,
  `subcontractors_pop_edit` int(11) DEFAULT NULL,
  `subcontractors_pop_delete` int(11) DEFAULT NULL,
  `subcontractors_pop_application` int(11) DEFAULT NULL,
  `subcontractors_pop_certify` int(11) DEFAULT NULL,
  `subcontractors_pop_approval_post` int(11) DEFAULT NULL,
  `contracts_new` int(11) DEFAULT NULL,
  `contracts_edit` int(11) DEFAULT NULL,
  `contracts_delete` int(11) DEFAULT NULL,
  `contracts_editnotes` int(11) DEFAULT NULL,
  `contracts_changestatus` int(11) DEFAULT NULL,
  `contracts_jobmanagement_activity` int(11) DEFAULT NULL,
  `contracts_jobmanagement_wip` int(11) DEFAULT NULL,
  `contracts_jobmanagement_adjustments` int(11) DEFAULT NULL,
  `contracts_jobmanagement_valuation` int(11) DEFAULT NULL,
  `labour_labourratesvisible` int(11) DEFAULT NULL,
  `labour_delete` int(11) DEFAULT NULL,
  `labour_edit` int(11) DEFAULT NULL,
  `labour_timesheets_new` int(11) DEFAULT NULL,
  `labour_timesheets_edit` int(11) DEFAULT NULL,
  `labour_timesheets_delete` int(11) DEFAULT NULL,
  `labour_timesheets_post` int(11) DEFAULT NULL,
  `labour_employees_new` int(11) DEFAULT NULL,
  `labour_employees_edit` int(11) DEFAULT NULL,
  `labour_employees_delete` int(11) DEFAULT NULL,
  `labour_payrates_new` int(11) DEFAULT NULL,
  `labour_payrates_edit` int(11) DEFAULT NULL,
  `labour_payrates_delete` int(11) DEFAULT NULL,
  `labour_paygroups` int(11) DEFAULT NULL,
  `maintenance_add` int(11) DEFAULT NULL,
  `maintenance_edit` int(11) DEFAULT NULL,
  `maintenance_delete` int(11) DEFAULT NULL,
  `maintenance_jobprogress` int(11) DEFAULT NULL,
  `maintenance_invoice` int(11) DEFAULT NULL,
  `maintenance_repetitions` int(11) DEFAULT NULL,
  `maintenance_scheduleofrates` int(11) DEFAULT NULL,
  `calendar_add` int(11) DEFAULT NULL,
  `calendar_edit` int(11) DEFAULT NULL,
  `calendar_delete` int(11) DEFAULT NULL,
  `plant_add` int(11) DEFAULT NULL,
  `plant_edit` int(11) DEFAULT NULL,
  `plant_delete` int(11) DEFAULT NULL,
  `plant_pop` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_access_rights`
--

LOCK TABLES `user_access_rights` WRITE;
/*!40000 ALTER TABLE `user_access_rights` DISABLE KEYS */;
INSERT INTO `user_access_rights` VALUES (6,1,1,1,0,0,0,0,0,0,1,0,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),(7,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,11,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9,14,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,15,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `user_access_rights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) DEFAULT NULL,
  `xid_company` int(11) DEFAULT NULL,
  `password_salt` varchar(10) DEFAULT NULL,
  `password_hash` varchar(60) DEFAULT NULL,
  `connection_string` blob,
  `hash_new` varchar(255) DEFAULT NULL,
  `salt_new` varchar(255) DEFAULT NULL,
  `priv_level` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'demo@constructionmanager.net',1,'7f4712230e','$2a$12$.meeejHJscSxFxoXgxAdA.pPGqxD1EH2VCxJJPndi9vpuwz96L.b2','1#◊[Á•l·¸àºÁ˘°∞H—±B2∏öıV4Ê©»uŒf™ŸuÆPŒ›´ZE∫Èwb<Åb¶„YÃøUÿ–‰∏e\nß˘Ö[˝<6ÈB=AôBÀÈX*V+|zﬂÜ7|Â©','$2a$10$x2SIoVqBPe2amZT8tn.9EupOkt42uJ09phNEJ5IvI76sPWGcYlh9u','$2a$10$x2SIoVqBPe2amZT8tn.9Eu',3),(10,'gdfgdfg',2,NULL,NULL,NULL,'$2a$10$hANAOWvNQAbiZPS/eTK3dOg9ENRRIOInoDALTFIe/tcaSYecuhvN.','$2a$10$hANAOWvNQAbiZPS/eTK3dO',3),(11,'test@test.com',2,NULL,NULL,NULL,'$2a$10$9XCwGa7ZA.V02l95sx2WFOccAROJAufBG1tu52C6.myWfHkWcKwCG','$2a$10$9XCwGa7ZA.V02l95sx2WFO',3),(12,'james.srn@gmail.com',1,NULL,NULL,NULL,'$2a$10$vvsP4N8Wk/DQaWHKkYWsLeII56b9eug4SRBsvw2Cbjz/yVXIaIT3m','$2a$10$vvsP4N8Wk/DQaWHKkYWsLe',1),(13,'james.srn+t2@gmail.com',1,NULL,NULL,NULL,'$2a$10$JZjuLVwC9wezYOoWrNnUAeoQZJc4NVaf/H3HbX/uM1tf4lWmWOsbm','$2a$10$JZjuLVwC9wezYOoWrNnUAe',1),(14,'james.srn+pls@gmail.com',2,NULL,NULL,NULL,'$2a$10$CuCwT2TSlR02p3ex7vqES.Ddd8MVssInWQI5bfBGnoXySPrRINVTi','$2a$10$CuCwT2TSlR02p3ex7vqES.',1),(15,'a@a.com',4,NULL,NULL,NULL,'$2a$10$dpQbmx9/vNDmRgyeTDmyneLx3GlpY3BvXMUmR57b6GjGPq/T4HeBm','$2a$10$dpQbmx9/vNDmRgyeTDmyne',3);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-01-23 15:36:23

-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               5.6.41-log - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             9.5.0.5286
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table avl_worklist.instrument
CREATE TABLE IF NOT EXISTS `instrument` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `driver` varchar(50) NOT NULL,
  `Inst_conn_type` char(1) NOT NULL DEFAULT 'S' COMMENT 'Type of instrument connection S=Serial N=Network',
  `port_com` int(11) NOT NULL,
  `con_net_type` char(1) NOT NULL DEFAULT 'C' COMMENT 'Instrument network type, S=Server C=Client',
  `con_net_ip` varchar(30) NOT NULL COMMENT 'Instrument Network IP Address',
  `con_net_port` int(11) NOT NULL COMMENT 'Instrument Network Port Num',
  `host_ip` varchar(30) NOT NULL COMMENT 'Infinity ICA Server  IP Address',
  `host_port` int(11) NOT NULL COMMENT 'Infinity ICA Server POT',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=166 DEFAULT CHARSET=latin1;

-- Dumping data for table avl_worklist.instrument: ~1 rows (approximately)
/*!40000 ALTER TABLE `instrument` DISABLE KEYS */;
INSERT INTO `instrument` (`id`, `name`, `driver`, `Inst_conn_type`, `port_com`, `con_net_type`, `con_net_ip`, `con_net_port`, `host_ip`, `host_port`) VALUES
	(165, 'AVL9180-1', 'avl9180', 'S', 16, 'C', '', 0, '127.0.0.1', 5001);
/*!40000 ALTER TABLE `instrument` ENABLE KEYS */;

-- Dumping structure for table avl_worklist.instrument_result
CREATE TABLE IF NOT EXISTS `instrument_result` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `instrument_id` int(11) DEFAULT '0',
  `sample_id` varchar(15) DEFAULT NULL,
  `host_sample_id` varchar(50) DEFAULT NULL,
  `analyt_code` varchar(20) NOT NULL,
  `result_value` varchar(20) NOT NULL,
  `audit_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_Instrument_ID` (`instrument_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Dumping data for table avl_worklist.instrument_result: ~3 rows (approximately)
/*!40000 ALTER TABLE `instrument_result` DISABLE KEYS */;
INSERT INTO `instrument_result` (`id`, `status`, `instrument_id`, `sample_id`, `host_sample_id`, `analyt_code`, `result_value`, `audit_date`) VALUES
	(2, 1, 0, '2103', '111111111-1', 'Cl', '  124 ', '2021-06-25 15:10:26'),
	(3, 1, 0, '2103', '111111111-1', 'K', '  ', '2021-06-25 15:10:26'),
	(4, 1, 0, '2103', '111111111-1', 'Na', '   94 ', '2021-06-25 15:10:26'),
	(5, 0, 0, NULL, '247  \r', 'Na', '  128 ', '2021-06-26 01:00:52'),
	(6, 0, 0, NULL, '247  \r', 'K', '  4.3  ', '2021-06-26 01:00:52'),
	(7, 0, 0, NULL, '247  \r', 'Cl', '   97  ', '2021-06-26 01:00:52'),
	(8, 0, 0, NULL, '248  \r', 'Na', '118.9  ', '2021-06-26 05:27:18'),
	(9, 0, 0, NULL, '248  \r', 'K', ' 3.01  ', '2021-06-26 05:27:18'),
	(10, 0, 0, NULL, '248  \r', 'Cl', ' 72.4  ', '2021-06-26 05:27:18'),
	(11, 0, 0, NULL, '249  \r', 'Na', '140.9  ', '2021-06-26 05:28:56'),
	(12, 0, 0, NULL, '249  \r', 'K', ' 4.50  ', '2021-06-26 05:28:56'),
	(13, 0, 0, NULL, '249  \r', 'Cl', ' 99.1  ', '2021-06-26 05:28:56'),
	(14, 0, 0, NULL, '250  \r', 'Na', '159.5  ', '2021-06-26 05:30:32'),
	(15, 0, 0, NULL, '250  \r', 'K', ' 5.86  ', '2021-06-26 05:30:32'),
	(16, 0, 0, NULL, '250  \r', 'Cl', '119.2  ', '2021-06-26 05:30:32'),
	(20, 0, 0, '211770003-1', '251  \r', 'Na', '  132 ', '2021-06-26 07:54:48'),
	(21, 0, 0, '211770003-1', '251  \r', 'K', '  4.5  ', '2021-06-26 07:54:48'),
	(22, 0, 0, '211770003-1', '251  \r', 'Cl', '  101  ', '2021-06-26 07:54:48'),
	(23, 0, 0, NULL, '252  \r', 'Na', '  135 ', '2021-06-26 08:35:12'),
	(24, 0, 0, NULL, '252  \r', 'K', '  3.6  ', '2021-06-26 08:35:12'),
	(25, 0, 0, NULL, '252  \r', 'Cl', '  100  ', '2021-06-26 08:35:12'),
	(26, 0, 0, NULL, '253  \r', 'Na', '  132 ', '2021-06-26 08:37:37'),
	(27, 0, 0, NULL, '253  \r', 'K', '  4.2  ', '2021-06-26 08:37:37'),
	(28, 0, 0, NULL, '253  \r', 'Cl', '   98  ', '2021-06-26 08:37:37');
/*!40000 ALTER TABLE `instrument_result` ENABLE KEYS */;

-- Dumping structure for table avl_worklist.result_send
CREATE TABLE IF NOT EXISTS `result_send` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sample_id` varchar(50) NOT NULL,
  `host_sample_id` varchar(50) NOT NULL,
  `status` int(11) NOT NULL,
  `auditdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table avl_worklist.result_send: ~0 rows (approximately)
/*!40000 ALTER TABLE `result_send` DISABLE KEYS */;
/*!40000 ALTER TABLE `result_send` ENABLE KEYS */;

-- Dumping structure for table avl_worklist.worklist
CREATE TABLE IF NOT EXISTS `worklist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sampleid` varchar(15) NOT NULL,
  `audit_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

-- Dumping data for table avl_worklist.worklist: ~3 rows (approximately)
/*!40000 ALTER TABLE `worklist` DISABLE KEYS */;
INSERT INTO `worklist` (`id`, `sampleid`, `audit_date`) VALUES
	(13, '211760156-2', '2021-06-25 13:02:03'),
	(14, '211760139-2', '2021-06-25 13:03:08'),
	(15, '211750107-8', '2021-06-25 13:19:48');
/*!40000 ALTER TABLE `worklist` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

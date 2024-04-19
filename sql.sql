
CREATE TABLE IF NOT EXISTS `propcreator` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `propname` varchar(255) NOT NULL,
  `x` double NOT NULL,
  `y` double NOT NULL,
  `z` double NOT NULL,
  `rotationx` double DEFAULT NULL,
  `rotationy` double DEFAULT NULL,
  `rotationz` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;



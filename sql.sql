CREATE TABLE `williamhitmen` (
  `name` varchar(50) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `sclients` INT NOT NULL DEFAULT 0,
  `uclients` INT NOT NULL DEFAULT 0,
  `clients` INT NOT NULL DEFAULT 0,
  `discription` varchar(50) NOT NULL,
  `weapons` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `users` ADD IF NOT EXISTS `cryptocurrency` float DEFAULT 0;
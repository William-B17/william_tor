CREATE TABLE `wgdarkmails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `addressto` varchar(50) NOT NULL,
  `addressfrom` varchar(50) NOT NULL,
  `message` text DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `wgtransfers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `addressto` varchar(50) NOT NULL,
  `addressfrom` varchar(50) NOT NULL,
  `amount` varchar(50) NOT NULL,
  `message` text DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


ALTER TABLE `users` ADD IF NOT EXISTS `cryptocurrency` float DEFAULT 0;

ALTER TABLE `users` ADD IF NOT EXISTS `darkaddress`  varchar(50) DEFAULT NULL;

INSERT INTO `jobs`(`name`, `label`, `whitelisted`) VALUES
('hitman','Hitman',1),
('armsdealer','Våbenhandler',1);

INSERT INTO `job_grades`(`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('hitman',0,'hitman0','Hitman Lvl 0',0,'{}','{}'),
('armsdealer',0,'armsdealer0','Våbenhandler Lvl 0',0,'{}','{}');

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('hackerDevice', 'Hacker Device', 0.2, 0, 1),
('lockpick', 'Lockpick', 0.1, 0, 1),
('advancedlockpick', 'Advanced Lockpick', 0.1, 0, 1),
('bank_c4', 'C4', 1, 0, 1),
('blowpipe', 'Blow Torch', 0.2, 0, 1);
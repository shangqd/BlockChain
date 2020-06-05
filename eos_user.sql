/*
Navicat MySQL Data Transfer

Source Server         : 192.168.16.80
Source Server Version : 50723
Source Host           : 192.168.16.80:3306
Source Database       : block

Target Server Type    : MYSQL
Target Server Version : 50723
File Encoding         : 65001

Date: 2018-09-17 15:06:10
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `eos_user`
-- ----------------------------
DROP TABLE IF EXISTS `eos_user`;
CREATE TABLE `eos_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pk1` varchar(100) DEFAULT NULL,
  `pk2` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `state` int(10) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `email` (`email`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- ----------------------------
-- Records of eos_user
-- ----------------------------

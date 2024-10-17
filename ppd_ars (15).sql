-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 17, 2024 at 04:24 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ppd_ars`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_logs`
--

CREATE TABLE `admin_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `action` varchar(50) NOT NULL,
  `previous_value` varchar(100) DEFAULT NULL,
  `new_value` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin_logs`
--

INSERT INTO `admin_logs` (`id`, `user_id`, `action`, `previous_value`, `new_value`, `created_at`, `updated_at`) VALUES
(1, 1, 'create_program', NULL, 'Centenarian', '2024-09-18 13:36:47', '2024-09-18 13:36:47'),
(2, 1, 'create_program', NULL, 'Disaster Response and Management Program (DRMP)', '2024-09-18 13:37:06', '2024-09-18 13:37:06'),
(3, 1, 'create_program', NULL, 'Kalahi CIDSS (KC-NCDDP)', '2024-09-18 13:37:22', '2024-09-18 13:37:22'),
(4, 1, 'create_program', NULL, 'Pantawid Pamilyang Pilipino Program (4P\'s)', '2024-09-18 13:37:39', '2024-09-18 13:37:39'),
(5, 1, 'create_program', NULL, 'Supplementary Feeding Program (SFP)', '2024-09-18 13:40:08', '2024-09-18 13:40:08'),
(6, 1, 'create_program', NULL, 'Sustainable Livelihood Program (SLP)', '2024-09-18 13:40:25', '2024-09-18 13:40:25'),
(7, 1, 'update_program_status', 'Assistance to Individuals in Crisis Situation (AICS) status changed from Unrestricted', 'Restricted', '2024-09-18 13:41:16', '2024-09-18 13:41:16'),
(8, 1, 'update_program_status', 'Social Pension (SocPen) for Indigent Senior Citizen Program status changed from Restricted', 'Unrestricted', '2024-09-18 13:41:50', '2024-09-18 13:41:50'),
(9, 1, 'update_program', 'Sustainable Livelihood Program (SLP)', 'Sustainable Livelihood Program (SLP)s', '2024-09-18 13:41:59', '2024-09-18 13:41:59'),
(10, 1, 'update_program', 'Sustainable Livelihood Program (SLP)s', 'Sustainable Livelihood Program (SLP)', '2024-09-18 13:42:05', '2024-09-18 13:42:05'),
(11, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-09-18 14:24:30', '2024-09-18 14:24:30'),
(12, 1, 'activate', 'User Mel lor was inactive', 'active', '2024-09-18 14:24:31', '2024-09-18 14:24:31'),
(13, 2, 'update_program_status', 'Social Pension (SocPen) for Indigent Senior Citizen Program status changed from Unrestricted', 'Restricted', '2024-09-18 16:49:57', '2024-09-18 16:49:57'),
(14, 2, 'update_program_status', 'Supplementary Feeding Program (SFP) status changed from Restricted', 'Unrestricted', '2024-09-18 18:26:11', '2024-09-18 18:26:11'),
(15, 2, 'update_program_status', 'Supplementary Feeding Program (SFP) status changed from Unrestricted', 'Restricted', '2024-09-18 18:26:47', '2024-09-18 18:26:47'),
(16, 2, 'update_program_status', 'Supplementary Feeding Program (SFP) status changed from Restricted', 'Unrestricted', '2024-09-18 18:55:29', '2024-09-18 18:55:29'),
(17, 2, 'update_program_status', 'Supplementary Feeding Program (SFP) status changed from Unrestricted', 'Restricted', '2024-09-18 18:55:50', '2024-09-18 18:55:50'),
(18, 1, 'update_program', 'Assistance to Individuals in Crisis Situation (AICS)', 'Assistance to Individuals in Crisis Situation (AICS)', '2024-09-25 18:40:03', '2024-09-25 18:40:03'),
(19, 1, 'update_program', 'Centenarian', 'Centenarian', '2024-09-25 18:40:27', '2024-09-25 18:40:27'),
(20, 1, 'update_program', 'Disaster Response and Management Program (DRMP)', 'Disaster Response and Management Program (DRMP)', '2024-09-25 18:41:02', '2024-09-25 18:41:02'),
(21, 1, 'update_program', 'Kalahi CIDSS (KC-NCDDP)', 'Kalahi CIDSS (KC-NCDDP)', '2024-09-25 18:41:23', '2024-09-25 18:41:23'),
(22, 1, 'update_program', 'Pantawid Pamilyang Pilipino Program (4P\'s)', 'Pantawid Pamilyang Pilipino Program (4P\'s)', '2024-09-25 18:41:36', '2024-09-25 18:41:36'),
(23, 1, 'update_program', 'Social Pension (SocPen) for Indigent Senior Citizen Program', 'Social Pension (SocPen) for Indigent Senior Citizen Program', '2024-09-25 18:41:52', '2024-09-25 18:41:52'),
(24, 1, 'update_program', 'Supplementary Feeding Program (SFP)', 'Supplementary Feeding Program (SFP)', '2024-09-25 18:42:06', '2024-09-25 18:42:06'),
(25, 1, 'update_program', 'Sustainable Livelihood Program (SLP)', 'Sustainable Livelihood Program (SLP)', '2024-09-25 18:42:14', '2024-09-25 18:42:14'),
(26, 2, 'update_program_status', 'Social Pension (SocPen) for Indigent Senior Citizen Program status changed from Unrestricted', 'Restricted', '2024-09-26 01:28:31', '2024-09-26 01:28:31'),
(27, 2, 'update_program_status', 'Social Pension (SocPen) for Indigent Senior Citizen Program status changed from Restricted', 'Unrestricted', '2024-09-26 01:36:58', '2024-09-26 01:36:58'),
(28, 2, 'program_change', 'User Mel lor was in program Social Pension (SocPen) for Indigent Senior Citizen Program', 'User Mel lor is now in program Sustainable Livelihood Program (SLP)', '2024-09-26 06:28:17', '2024-09-26 06:28:17'),
(29, 2, 'deactivate', 'User Meliza Facun was active', 'inactive', '2024-09-27 16:59:38', '2024-09-27 16:59:38'),
(30, 2, 'activate', 'User Meliza Facun was inactive', 'active', '2024-09-27 16:59:47', '2024-09-27 16:59:47'),
(31, 1, 'approved', 'User Meliza Facun was pending approval', 'approved', '2024-10-02 08:31:28', '2024-10-02 08:31:28'),
(32, 1, 'activate', 'User Meliza Facun was inactive', 'active', '2024-10-02 08:32:43', '2024-10-02 08:32:43'),
(33, 1, 'role_change', 'User Meliza Facun had role admin', '1', '2024-10-02 08:46:15', '2024-10-02 08:46:15'),
(34, 1, 'role_change', 'User Mel lor had role user', '0', '2024-10-02 08:46:19', '2024-10-02 08:46:19'),
(35, 1, 'role_change', 'User Meliza Facun had role user', '0', '2024-10-02 08:46:22', '2024-10-02 08:46:22'),
(36, 1, 'role_change', 'User p p had role user', '0', '2024-10-02 08:46:25', '2024-10-02 08:46:25'),
(37, 1, 'role_change', 'User d d had role admin', '0', '2024-10-02 08:46:29', '2024-10-02 08:46:29'),
(38, 1, 'role_change', 'User q q had role admin', '0', '2024-10-02 08:49:03', '2024-10-02 08:49:03'),
(39, 1, 'role_change', 'User e e had role user', '1', '2024-10-02 08:49:06', '2024-10-02 08:49:06'),
(40, 1, 'approved', 'User p p was pending approval', 'approved', '2024-10-02 09:06:34', '2024-10-02 09:06:34'),
(41, 1, 'activate', 'User p p was inactive', 'active', '2024-10-02 09:06:35', '2024-10-02 09:06:35'),
(42, 1, 'approved', 'User d d was pending approval', 'approved', '2024-10-02 09:06:36', '2024-10-02 09:06:36'),
(43, 1, 'activate', 'User d d was inactive', 'active', '2024-10-02 09:06:37', '2024-10-02 09:06:37'),
(44, 1, 'approved', 'User q q was pending approval', 'approved', '2024-10-02 09:06:43', '2024-10-02 09:06:43'),
(45, 1, 'approved', 'User e e was pending approval', 'approved', '2024-10-02 09:06:45', '2024-10-02 09:06:45'),
(46, 1, 'activate', 'User q q was inactive', 'active', '2024-10-02 09:06:45', '2024-10-02 09:06:45'),
(47, 1, 'deactivate', 'User q q was active', 'inactive', '2024-10-02 09:06:46', '2024-10-02 09:06:46'),
(48, 1, 'activate', 'User e e was inactive', 'active', '2024-10-02 09:06:47', '2024-10-02 09:06:47'),
(49, 1, 'update_program_status', 'Disaster Response and Management Program (DRMP) status changed from Unrestricted', 'Restricted', '2024-10-03 07:01:22', '2024-10-03 07:01:22'),
(50, 1, 'role_change', 'User Meliza Facun had role 1', '1', '2024-10-03 07:06:41', '2024-10-03 07:06:41'),
(51, 1, 'deactivate', 'User Meliza Facun was active', 'inactive', '2024-10-03 07:07:51', '2024-10-03 07:07:51'),
(52, 1, 'deactivate', 'User p p was active', 'inactive', '2024-10-03 07:07:52', '2024-10-03 07:07:52'),
(53, 1, 'deactivate', 'User d d was active', 'inactive', '2024-10-03 07:07:53', '2024-10-03 07:07:53'),
(54, 1, 'activate', 'User q q was inactive', 'active', '2024-10-03 07:07:54', '2024-10-03 07:07:54'),
(55, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-10-04 17:34:29', '2024-10-04 17:34:29'),
(56, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-10-04 17:34:32', '2024-10-04 17:34:32'),
(57, 1, 'approved', 'User q q was pending approval', 'approved', '2024-10-04 17:37:38', '2024-10-04 17:37:38'),
(58, 1, 'approved', 'User s s was pending approval', 'approved', '2024-10-04 17:42:06', '2024-10-04 17:42:06'),
(59, 1, 'approved', 'User q q was pending approval', 'approved', '2024-10-04 17:42:08', '2024-10-04 17:42:08'),
(60, 1, 'approved', 'User d d was pending approval', 'approved', '2024-10-04 17:42:08', '2024-10-04 17:42:08'),
(61, 1, 'approved', 'User d d was pending approval', 'approved', '2024-10-04 17:49:20', '2024-10-04 17:49:20'),
(62, 1, 'activate', 'User d d was inactive', 'active', '2024-10-04 17:49:22', '2024-10-04 17:49:22'),
(63, 1, 'update_program', 'Assistance to Individuals in Crisis Situation (AICS)', 'Assistance to Individuals in Crisis Situation (AICS)', '2024-10-05 18:34:54', '2024-10-05 18:34:54'),
(64, 1, 'update_program', 'Centenarian', 'Centenarian', '2024-10-05 18:35:02', '2024-10-05 18:35:02'),
(65, 1, 'update_program', 'Disaster Response and Management Program (DRMP)', 'Disaster Response and Management Program (DRMP)', '2024-10-05 18:35:14', '2024-10-05 18:35:14'),
(66, 1, 'update_program', 'Kalahi CIDSS (KC-NCDDP)', 'Kalahi CIDSS (KC-NCDDP)', '2024-10-05 18:35:18', '2024-10-05 18:35:18'),
(67, 1, 'update_program', 'Kalahi CIDSS (KC-NCDDP)', 'Kalahi CIDSS (KC-NCDDP)', '2024-10-05 18:35:24', '2024-10-05 18:35:24'),
(68, 1, 'update_program', 'Pantawid Pamilyang Pilipino Program (4P\'s)', 'Pantawid Pamilyang Pilipino Program (4P\'s)', '2024-10-05 18:35:35', '2024-10-05 18:35:35'),
(69, 1, 'update_program', 'Social Pension (SocPen) for Indigent Senior Citizen Program', 'Social Pension (SocPen) for Indigent Senior Citizen Program', '2024-10-05 18:35:45', '2024-10-05 18:35:45'),
(70, 1, 'update_program', 'Supplementary Feeding Program (SFP)', 'Supplementary Feeding Program (SFP)', '2024-10-05 18:35:48', '2024-10-05 18:35:48'),
(71, 1, 'update_program', 'Supplementary Feeding Program (SFP)', 'Supplementary Feeding Program (SFP)', '2024-10-05 18:35:56', '2024-10-05 18:35:56'),
(72, 1, 'update_program', 'Sustainable Livelihood Program (SLP)', 'Sustainable Livelihood Program (SLP)', '2024-10-05 18:36:00', '2024-10-05 18:36:00'),
(73, 1, 'update_program', 'Sustainable Livelihood Program (SLP)', 'Sustainable Livelihood Program (SLP)', '2024-10-05 18:36:07', '2024-10-05 18:36:07'),
(74, 1, 'create_program', NULL, 'feggtthyyhythww', '2024-10-05 18:39:33', '2024-10-05 18:39:33'),
(75, 1, 'update_program', 'feggtthyyhythww', 'qwsaedrftgyhujikolmnbczsfrthyjukilol;p,uyrterffg', '2024-10-05 18:39:57', '2024-10-05 18:39:57'),
(76, 1, 'update_program', 'Assistance to Individuals in Crisis Situation (AIC', 'Assistance to Individuals in Crisis Situation (AICS)', '2024-10-05 18:41:47', '2024-10-05 18:41:47'),
(77, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-10-05 19:15:56', '2024-10-05 19:15:56'),
(78, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-10-05 19:16:01', '2024-10-05 19:16:01'),
(79, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-10-05 19:16:05', '2024-10-05 19:16:05'),
(80, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-10-05 19:16:09', '2024-10-05 19:16:09'),
(81, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-10-05 19:16:13', '2024-10-05 19:16:13'),
(82, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-10-05 19:16:17', '2024-10-05 19:16:17'),
(83, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-10-05 19:16:21', '2024-10-05 19:16:21'),
(84, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-10-05 19:16:25', '2024-10-05 19:16:25'),
(85, 1, 'approved', 'User p p was pending approval', 'approved', '2024-10-05 19:16:28', '2024-10-05 19:16:28'),
(86, 1, 'approved', 'User Meliza Facun was pending approval', 'approved', '2024-10-05 19:16:53', '2024-10-05 19:16:53'),
(87, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-10-05 19:17:45', '2024-10-05 19:17:45'),
(88, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-10-05 19:17:51', '2024-10-05 19:17:51'),
(89, 1, 'approved', 'User Mel lor was pending approval', 'approved', '2024-10-05 19:23:40', '2024-10-05 19:23:40'),
(90, 1, 'activate', 'User Mel lor was inactive', 'active', '2024-10-05 19:24:09', '2024-10-05 19:24:09'),
(91, 1, 'program_change', 'User p p was in program Centenarian', 'User p p is now in program Disaster Response and Management Program (DRMP)', '2024-10-05 19:31:24', '2024-10-05 19:31:24'),
(92, 1, 'program_change', 'User p p was in program Disaster Response and Management Program (DRMP)', 'User p p is now in program Sustainable Livelihood Program (SLP)', '2024-10-05 19:31:42', '2024-10-05 19:31:42'),
(93, 1, 'role_change', 'User p p had role 0', '1', '2024-10-05 19:31:47', '2024-10-05 19:31:47'),
(94, 1, 'role_change', 'User p p had role 1', '0', '2024-10-05 19:31:55', '2024-10-05 19:31:55'),
(95, 1, 'role_change', 'User p p had role 0', '1', '2024-10-05 19:32:00', '2024-10-05 19:32:00'),
(96, 1, 'role_change', 'User p p had role 1', '0', '2024-10-05 19:32:02', '2024-10-05 19:32:02'),
(97, 1, 'program_change', 'User p p was in program Sustainable Livelihood Program (SLP)', 'User p p is now in program Disaster Response and Management Program (DRMP)', '2024-10-05 19:37:06', '2024-10-05 19:37:06'),
(98, 1, 'program_change', 'User Meliza Facun was in program Social Pension (SocPen) for Indigent Senior Citize', 'User Meliza Facun is now in program Centenarian', '2024-10-05 19:37:10', '2024-10-05 19:37:10'),
(99, 1, 'role_change', 'User Meliza Facun had role 0', '1', '2024-10-05 19:39:57', '2024-10-05 19:39:57'),
(100, 1, 'role_change', 'User Meliza Facun had role 1', '0', '2024-10-05 19:43:11', '2024-10-05 19:43:11'),
(101, 1, 'program_change', 'User Meliza Facun was in program Centenarian', 'User Meliza Facun is now in program Assistance to Individuals in Crisis Situation (AICS)', '2024-10-05 19:43:26', '2024-10-05 19:43:26'),
(102, 1, 'approved', 'User Lorgil Lubiano was pending approval', 'approved', '2024-10-07 07:01:38', '2024-10-07 07:01:38'),
(103, 1, 'activate', 'User Lorgil Lubiano was inactive', 'active', '2024-10-07 07:01:59', '2024-10-07 07:01:59'),
(104, 1, 'update_program', 'Social Pension (SocPen) for Indigent Senior Citize', 'Social Pension (SocPen) for Indigent Senior Citizen', '2024-10-07 07:04:05', '2024-10-07 07:04:05'),
(105, 1, 'approved', 'User Jay Ar Marck Grandia was pending approval', 'approved', '2024-10-07 07:05:31', '2024-10-07 07:05:31'),
(106, 1, 'approved', 'User Jay Ar Marck Grandia was pending approval', 'approved', '2024-10-07 07:05:35', '2024-10-07 07:05:35'),
(107, 1, 'activate', 'User Jay Ar Marck Grandia was inactive', 'active', '2024-10-07 07:05:43', '2024-10-07 07:05:43'),
(108, 1, 'program_change', 'User Lorgil Lubiano was in program Social Pension (SocPen) for Indigent Senior Citizen', 'User Lorgil Lubiano is now in program Centenarian', '2024-10-07 07:07:24', '2024-10-07 07:07:24'),
(109, 1, 'program_change', 'User Jay Ar Marck Grandia was in program Social Pension (SocPen) for Indigent Senior Citizen', 'User Jay Ar Marck Grandia is now in program Assistance to Individuals in Crisis Situation (AICS)', '2024-10-07 08:02:48', '2024-10-07 08:02:48'),
(110, 1, 'program_change', 'User Jay Ar Marck Grandia was in program Assistance to Individuals in Crisis Situation (AICS)', 'User Jay Ar Marck Grandia is now in program Social Pension (SocPen) for Indigent Senior Citizen', '2024-10-07 08:13:36', '2024-10-07 08:13:36'),
(111, 1, 'program_change', 'User Jay Ar Marck Grandia was in program Social Pension (SocPen) for Indigent Senior Citizen', 'User Jay Ar Marck Grandia is now in program Supplementary Feeding Program (SFP)', '2024-10-07 08:38:07', '2024-10-07 08:38:07'),
(112, 1, 'program_change', 'User Lorgil Lubiano was in program Centenarian', 'User Lorgil Lubiano is now in program Social Pension (SocPen) for Indigent Senior Citizen', '2024-10-07 08:38:32', '2024-10-07 08:38:32'),
(113, 1, 'update_program_status', 'Supplementary Feeding Program (SFP) status changed from Unrestricted', 'Restricted', '2024-10-08 04:48:01', '2024-10-08 04:48:01'),
(114, 1, 'program_change', 'User Lorgil Lubiano was in program Social Pension (SocPen) for Indigent Senior Citizen', 'User Lorgil Lubiano is now in program Assistance to Individuals in Crisis Situation (AICS)', '2024-10-11 11:49:16', '2024-10-11 11:49:16'),
(115, 1, 'program_change', 'User Lorgil Lubiano was in program Assistance to Individuals in Crisis Situation (AICS)', 'User Lorgil Lubiano is now in program Social Pension (SocPen) for Indigent Senior Citizen', '2024-10-11 12:41:42', '2024-10-11 12:41:42'),
(116, 1, 'program_change', 'User Lorgil Lubiano was in program Social Pension (SocPen) for Indigent Senior Citizen', 'User Lorgil Lubiano is now in program Assistance to Individuals in Crisis Situation (AICS)', '2024-10-11 12:56:15', '2024-10-11 12:56:15'),
(117, 1, 'program_change', 'User Lorgil Lubiano was in program Assistance to Individuals in Crisis Situation (AICS)', 'User Lorgil Lubiano is now in program Social Pension (SocPen) for Indigent Senior Citizen', '2024-10-11 12:56:28', '2024-10-11 12:56:28'),
(118, 1, 'update_program_status', 'Social Pension (SocPen) for Indigent Senior Citizen status changed from Unrestricted', 'Restricted', '2024-10-11 18:47:36', '2024-10-11 18:47:36'),
(119, 1, 'update_program_status', 'Social Pension (SocPen) for Indigent Senior Citizen status changed from Restricted', 'Unrestricted', '2024-10-11 18:48:00', '2024-10-11 18:48:00'),
(120, 1, 'role_change', 'User Jay Ar Marck Grandia had role 0', '1', '2024-10-11 19:26:52', '2024-10-11 19:26:52'),
(121, 1, 'role_change', 'User Jay Ar Marck Grandia had role 1', '0', '2024-10-11 19:27:00', '2024-10-11 19:27:00'),
(122, 1, 'role_change', 'User Jay Ar Marck Grandia had role 0', '1', '2024-10-11 19:27:07', '2024-10-11 19:27:07'),
(123, 1, 'role_change', 'User Jay Ar Marck Grandia had role 1', '0', '2024-10-11 19:27:26', '2024-10-11 19:27:26'),
(124, 1, 'role_change', 'User p p had role 0', '1', '2024-10-16 22:06:40', '2024-10-16 22:06:40'),
(125, 1, 'role_change', 'User Mel lor had role 0', '1', '2024-10-16 22:35:51', '2024-10-16 22:35:51'),
(126, 1, 'update_program_status', 'Social Pension (SocPen) for Indigent Senior Citizen status changed from Unrestricted', 'Restricted', '2024-10-16 22:36:07', '2024-10-16 22:36:07'),
(127, 1, 'update_program_status', 'Social Pension (SocPen) for Indigent Senior Citizen status changed from Restricted', 'Unrestricted', '2024-10-16 22:37:15', '2024-10-16 22:37:15'),
(128, 1, 'program_change', 'User Lorgil Lubiano was in program Social Pension (SocPen) for Indigent Senior Citizen', 'User Lorgil Lubiano is now in program Assistance to Individuals in Crisis Situation (AICS)', '2024-10-17 00:24:28', '2024-10-17 00:24:28'),
(129, 1, 'program_change', 'User Lorgil Lubiano was in program Assistance to Individuals in Crisis Situation (AICS)', 'User Lorgil Lubiano is now in program Centenarian', '2024-10-17 00:28:01', '2024-10-17 00:28:01'),
(130, 1, 'program_change', 'User Lorgil Lubiano was in program Centenarian', 'User Lorgil Lubiano is now in program Disaster Response and Management Program (DRMP)', '2024-10-17 00:29:09', '2024-10-17 00:29:09'),
(131, 1, 'program_change', 'User Lorgil Lubiano was in program Disaster Response and Management Program (DRMP)', 'User Lorgil Lubiano is now in program Kalahi CIDSS (KC-NCDDP)', '2024-10-17 00:30:11', '2024-10-17 00:30:11'),
(132, 1, 'program_change', 'User Lorgil Lubiano was in program Kalahi CIDSS (KC-NCDDP)', 'User Lorgil Lubiano is now in program Pantawid Pamilyang Pilipino Program (4P\'s)', '2024-10-17 00:31:12', '2024-10-17 00:31:12'),
(133, 1, 'program_change', 'User Lorgil Lubiano was in program Pantawid Pamilyang Pilipino Program (4P\'s)', 'User Lorgil Lubiano is now in program Supplementary Feeding Program (SFP)', '2024-10-17 00:31:59', '2024-10-17 00:31:59'),
(134, 1, 'update_program_status', 'Supplementary Feeding Program (SFP) status changed from Restricted', 'Unrestricted', '2024-10-17 00:32:13', '2024-10-17 00:32:13'),
(135, 1, 'program_change', 'User Lorgil Lubiano was in program Supplementary Feeding Program (SFP)', 'User Lorgil Lubiano is now in program Sustainable Livelihood Program (SLP)', '2024-10-17 00:32:45', '2024-10-17 00:32:45'),
(136, 1, 'program_change', 'User Lorgil Lubiano was in program Sustainable Livelihood Program (SLP)', 'User Lorgil Lubiano is now in program Social Pension (SocPen) for Indigent Senior Citizen', '2024-10-17 00:37:35', '2024-10-17 00:37:35'),
(137, 1, 'approved', 'User Lilulu Nana was pending approval', 'approved', '2024-10-17 00:44:45', '2024-10-17 00:44:45'),
(138, 1, 'activate', 'User Lilulu Nana was inactive', 'active', '2024-10-17 00:44:52', '2024-10-17 00:44:52');

-- --------------------------------------------------------

--
-- Table structure for table `allocations`
--

CREATE TABLE `allocations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `province` varchar(10) NOT NULL,
  `city_municipality` varchar(10) NOT NULL,
  `program` bigint(20) UNSIGNED DEFAULT NULL,
  `target` int(11) NOT NULL,
  `fund_allocation` decimal(15,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `allocations`
--

INSERT INTO `allocations` (`id`, `province`, `city_municipality`, `program`, `target`, `fund_allocation`, `created_at`, `updated_at`) VALUES
(30, '112300000', '112303000', 6, 100, 5000.00, '2024-10-11 11:30:05', '2024-10-11 12:55:12'),
(31, '112300000', '112303000', 1, 100, 5000.00, '2024-10-11 11:50:55', '2024-10-11 11:50:55'),
(32, '112400000', '112404000', 6, 50, 500.00, '2024-10-11 12:42:00', '2024-10-11 12:42:00'),
(33, '112300000', '112303000', 6, 100, 10000.00, '2024-10-11 15:10:55', '2024-10-11 15:22:34'),
(34, '112400000', '112404000', 6, 1, 1.00, '2024-10-11 16:12:22', '2024-10-11 16:12:22'),
(35, '118200000', '118202000', 6, 100, 1000.00, '2024-10-11 16:29:35', '2024-10-11 19:17:09'),
(36, '112400000', '112406000', 6, 1, 1.00, '2024-10-11 17:58:25', '2024-10-11 17:58:25'),
(37, '118600000', '118604000', 6, 1, 10000.00, '2024-10-11 17:58:54', '2024-10-11 19:18:45'),
(38, '112402000', '1', 6, 1, 1.00, '2024-10-11 18:02:33', '2024-10-11 18:02:33'),
(39, '112300000', '112305000', 6, 1, 1.00, '2024-10-11 18:04:05', '2024-10-11 18:04:05'),
(40, '112400000', '112408000', 6, 1, 1.00, '2024-10-11 18:13:48', '2024-10-11 18:13:48'),
(41, '112500000', '112503000', 6, 1, 1.00, '2024-10-11 18:17:22', '2024-10-11 18:17:22'),
(42, '118600000', '118605000', 6, 1, 1.00, '2024-10-11 18:17:45', '2024-10-11 18:17:45'),
(43, '118200000', '118204000', 6, 1, 1.00, '2024-10-11 18:18:09', '2024-10-11 18:18:09'),
(44, '112300000', '112314000', 6, 1, 1.00, '2024-10-11 18:20:25', '2024-10-11 18:20:25'),
(45, '118600000', '118602000', 6, 1, 1.00, '2024-10-11 18:20:57', '2024-10-11 18:20:57'),
(46, '112400000', '112411000', 6, 1, 1.00, '2024-10-11 18:23:35', '2024-10-11 18:23:35'),
(47, '118200000', '118209000', 6, 1, 1.00, '2024-10-11 18:32:00', '2024-10-11 18:32:00'),
(48, '112300000', '112315000', 6, 1, 1.00, '2024-10-11 18:36:46', '2024-10-11 18:36:46'),
(49, '118200000', '118211000', 6, 1, 1.00, '2024-10-11 18:38:54', '2024-10-11 18:38:54'),
(50, '118200000', '118205000', 6, 1, 1.00, '2024-10-11 18:47:08', '2024-10-11 18:47:08'),
(51, '112300000', '112318000', 6, 1, 1.00, '2024-10-11 18:48:49', '2024-10-11 18:48:49'),
(52, '112400000', '112410000', 6, 1, 1.00, '2024-10-11 18:53:51', '2024-10-11 18:53:51'),
(53, '118200000', '118206000', 6, 1, 1.00, '2024-10-11 18:56:42', '2024-10-11 18:56:42'),
(54, '112300000', '112317000', 6, 1, 1.00, '2024-10-11 18:59:44', '2024-10-11 18:59:44'),
(55, '112402000', '3', 6, 11, 1.00, '2024-10-11 19:04:52', '2024-10-11 19:31:28'),
(56, '112500000', '112509000', 6, 300, 6000.00, '2024-10-16 22:11:30', '2024-10-16 22:11:30'),
(57, '112300000', '112323000', 6, 50, 100.00, '2024-10-16 22:18:55', '2024-10-16 22:18:55'),
(58, '112300000', '112319000', 6, 20, 500.00, '2024-10-16 22:29:48', '2024-10-16 22:29:48'),
(59, '118200000', '118207000', 6, 10, 20.00, '2024-10-16 22:31:55', '2024-10-16 22:31:55'),
(60, '118200000', '118210000', 6, 10, 22.00, '2024-10-16 22:34:26', '2024-10-16 22:34:55'),
(61, '118600000', '118605000', 1, 50, 500.00, '2024-10-17 00:24:48', '2024-10-17 00:24:48'),
(62, '112402000', '1', 1, 100, 500.00, '2024-10-17 00:25:52', '2024-10-17 00:25:52'),
(63, '112402000', '2', 1, 50, 5000.00, '2024-10-17 00:26:34', '2024-10-17 00:26:34'),
(64, '112400000', '112401000', 2, 500, 10000.00, '2024-10-17 00:28:31', '2024-10-17 00:28:31'),
(65, '118200000', '118203000', 3, 500, 10000.00, '2024-10-17 00:29:32', '2024-10-17 00:29:32'),
(66, '112500000', '112505000', 4, 300, 9000.00, '2024-10-17 00:30:37', '2024-10-17 00:30:37'),
(67, '112402000', '3', 5, 100, 5000.00, '2024-10-17 00:31:25', '2024-10-17 00:31:25'),
(68, '118200000', '118206000', 7, 100, 5000.00, '2024-10-17 00:32:27', '2024-10-17 00:32:27'),
(69, '112400000', '112404000', 8, 100, 5000.00, '2024-10-17 00:32:59', '2024-10-17 00:32:59'),
(70, '118600000', '118603000', 6, 1, 1.00, '2024-10-17 00:38:37', '2024-10-17 00:38:37'),
(71, '112400000', '112407000', 6, 1, 1.00, '2024-10-17 01:07:10', '2024-10-17 01:07:10');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(191) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(191) NOT NULL,
  `owner` varchar(191) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `client_logs`
--

CREATE TABLE `client_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `program` bigint(20) UNSIGNED DEFAULT NULL,
  `action` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `record_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `client_logs`
--

INSERT INTO `client_logs` (`id`, `user_id`, `program`, `action`, `type`, `record_id`, `created_at`, `updated_at`) VALUES
(1, 2, NULL, 'added', 'allocation', 2, '2024-09-18 16:50:06', '2024-09-18 16:50:06'),
(52, 12, 6, 'edited', 'allocation', 4, '2024-10-07 07:03:40', '2024-10-07 07:03:40'),
(53, 12, 6, 'added', 'allocation', 23, '2024-10-07 07:04:19', '2024-10-07 07:04:19'),
(54, 12, 6, 'added', 'utilization', 15, '2024-10-07 07:04:26', '2024-10-07 07:04:26'),
(55, 12, 6, 'edited', 'allocation', 5, '2024-10-07 07:04:42', '2024-10-07 07:04:42'),
(56, 13, 6, 'edited', 'allocation', 2, '2024-10-07 07:06:33', '2024-10-07 07:06:33'),
(57, 13, 6, 'edited', 'utilization', 2, '2024-10-07 07:07:13', '2024-10-07 07:07:13'),
(58, 13, 6, 'edited', 'allocation', 6, '2024-10-07 08:02:30', '2024-10-07 08:02:30'),
(59, 13, 1, 'edited', 'allocation', 14, '2024-10-07 08:03:00', '2024-10-07 08:03:00'),
(60, 12, 6, 'added', 'allocation', 25, '2024-10-08 05:41:49', '2024-10-08 05:41:49'),
(61, 12, 6, 'added', 'allocation', 26, '2024-10-08 06:10:28', '2024-10-08 06:10:28'),
(62, 12, 6, 'added', 'allocation', 27, '2024-10-08 07:06:33', '2024-10-08 07:06:33'),
(63, 12, 6, 'added', 'allocation', 28, '2024-10-10 02:01:39', '2024-10-10 02:01:39'),
(64, 12, 6, 'added', 'allocation', 29, '2024-10-10 06:58:20', '2024-10-10 06:58:20'),
(65, 12, 6, 'added', 'utilization', 16, '2024-10-11 11:22:57', '2024-10-11 11:22:57'),
(66, 12, 6, 'added', 'allocation', 30, '2024-10-11 11:30:05', '2024-10-11 11:30:05'),
(67, 12, 6, 'added', 'utilization', 17, '2024-10-11 11:30:39', '2024-10-11 11:30:39'),
(68, 12, 6, 'added', 'utilization', 18, '2024-10-11 11:31:11', '2024-10-11 11:31:11'),
(69, 12, 6, 'edited', 'utilization', 17, '2024-10-11 11:47:55', '2024-10-11 11:47:55'),
(70, 12, 1, 'added', 'allocation', 31, '2024-10-11 11:50:55', '2024-10-11 11:50:55'),
(71, 12, 1, 'added', 'utilization', 19, '2024-10-11 11:51:13', '2024-10-11 11:51:13'),
(72, 12, 1, 'edited', 'utilization', 19, '2024-10-11 11:51:40', '2024-10-11 11:51:40'),
(73, 12, 6, 'added', 'allocation', 32, '2024-10-11 12:42:00', '2024-10-11 12:42:00'),
(74, 12, 6, 'added', 'utilization', 20, '2024-10-11 12:42:19', '2024-10-11 12:42:19'),
(75, 12, 6, 'edited', 'allocation', 30, '2024-10-11 12:55:12', '2024-10-11 12:55:12'),
(76, 12, 6, 'added', 'allocation', 33, '2024-10-11 15:10:55', '2024-10-11 15:10:55'),
(77, 12, 6, 'added', 'utilization', 21, '2024-10-11 15:11:57', '2024-10-11 15:11:57'),
(78, 12, 6, 'edited', 'allocation', 33, '2024-10-11 15:22:34', '2024-10-11 15:22:34'),
(79, 12, 6, 'added', 'allocation', 34, '2024-10-11 16:12:22', '2024-10-11 16:12:22'),
(80, 12, 6, 'added', 'allocation', 35, '2024-10-11 16:29:35', '2024-10-11 16:29:35'),
(81, 12, 6, 'added', 'utilization', 22, '2024-10-11 18:14:10', '2024-10-11 18:14:10'),
(82, 12, 6, 'edited', 'utilization', 17, '2024-10-11 18:33:00', '2024-10-11 18:33:00'),
(83, 12, 6, 'edited', 'utilization', 17, '2024-10-11 18:36:25', '2024-10-11 18:36:25'),
(84, 12, 6, 'added', 'utilization', 23, '2024-10-11 18:59:14', '2024-10-11 18:59:14'),
(85, 12, 6, 'edited', 'allocation', 35, '2024-10-11 19:17:09', '2024-10-11 19:17:09'),
(86, 12, 6, 'edited', 'allocation', 37, '2024-10-11 19:18:45', '2024-10-11 19:18:45'),
(87, 12, 6, 'added', 'utilization', 24, '2024-10-11 19:19:34', '2024-10-11 19:19:34'),
(88, 12, 6, 'edited', 'allocation', 55, '2024-10-11 19:31:28', '2024-10-11 19:31:28'),
(89, 12, 6, 'added', 'utilization', 25, '2024-10-16 22:09:48', '2024-10-16 22:09:48'),
(90, 12, 6, 'added', 'utilization', 26, '2024-10-16 22:12:27', '2024-10-16 22:12:27'),
(91, 12, 6, 'added', 'allocation', 60, '2024-10-16 22:34:26', '2024-10-16 22:34:26'),
(92, 12, 6, 'edited', 'allocation', 60, '2024-10-16 22:34:55', '2024-10-16 22:34:55'),
(93, 12, 1, 'added', 'allocation', 61, '2024-10-17 00:24:48', '2024-10-17 00:24:48'),
(94, 12, 1, 'added', 'utilization', 27, '2024-10-17 00:25:08', '2024-10-17 00:25:08'),
(95, 12, 1, 'added', 'allocation', 62, '2024-10-17 00:25:52', '2024-10-17 00:25:52'),
(96, 12, 1, 'added', 'utilization', 28, '2024-10-17 00:26:11', '2024-10-17 00:26:11'),
(97, 12, 1, 'added', 'allocation', 63, '2024-10-17 00:26:34', '2024-10-17 00:26:34'),
(98, 12, 1, 'added', 'utilization', 29, '2024-10-17 00:26:48', '2024-10-17 00:26:48'),
(99, 12, 2, 'added', 'allocation', 64, '2024-10-17 00:28:31', '2024-10-17 00:28:31'),
(100, 12, 2, 'added', 'utilization', 30, '2024-10-17 00:28:43', '2024-10-17 00:28:43'),
(101, 12, 3, 'added', 'allocation', 65, '2024-10-17 00:29:32', '2024-10-17 00:29:32'),
(102, 12, 3, 'added', 'utilization', 31, '2024-10-17 00:29:47', '2024-10-17 00:29:47'),
(103, 12, 4, 'added', 'allocation', 66, '2024-10-17 00:30:37', '2024-10-17 00:30:37'),
(104, 12, 4, 'added', 'utilization', 32, '2024-10-17 00:30:52', '2024-10-17 00:30:52'),
(105, 12, 5, 'added', 'allocation', 67, '2024-10-17 00:31:25', '2024-10-17 00:31:25'),
(106, 12, 5, 'added', 'utilization', 33, '2024-10-17 00:31:39', '2024-10-17 00:31:39'),
(107, 12, 7, 'added', 'allocation', 68, '2024-10-17 00:32:27', '2024-10-17 00:32:27'),
(108, 12, 8, 'added', 'allocation', 69, '2024-10-17 00:32:59', '2024-10-17 00:32:59'),
(109, 12, 8, 'added', 'utilization', 34, '2024-10-17 00:33:23', '2024-10-17 00:33:23'),
(110, 12, 6, 'added', 'allocation', 70, '2024-10-17 00:38:37', '2024-10-17 00:38:37'),
(111, 12, 6, 'added', 'allocation', 71, '2024-10-17 01:07:10', '2024-10-17 01:07:10');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(191) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(191) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lib_roles`
--

CREATE TABLE `lib_roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `lib_role` varchar(191) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lib_roles`
--

INSERT INTO `lib_roles` (`id`, `lib_role`) VALUES
(1, 'user'),
(2, 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `lib_suffixes`
--

CREATE TABLE `lib_suffixes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `lib1_suffix` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lib_suffixes`
--

INSERT INTO `lib_suffixes` (`id`, `lib1_suffix`) VALUES
(1, 'Jr.'),
(2, 'Sr.'),
(3, 'I'),
(4, 'II'),
(5, 'III'),
(6, 'IV'),
(7, 'V'),
(8, 'VI'),
(9, 'VII'),
(10, 'VIII'),
(11, 'IX'),
(12, 'X');

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000001_create_cache_table', 1),
(2, '0001_01_01_000002_create_jobs_table', 1),
(3, '2024_08_01_133221_create_programs_table', 1),
(4, '2024_08_01_221202_create_tbl_province_table', 1),
(5, '2024_08_01_222319_create_tbl_citymuni_table', 1),
(6, '2024_08_02_164535_create_utilizations_table', 1),
(7, '2024_08_02_183025_create_allocations_table', 1),
(8, '2024_09_05_000000_create_users_table', 1),
(9, '2024_09_06_183557_create_logs_table', 1),
(10, '2024_09_11_181559_create_admin_logs_table', 1),
(11, '2024_09_11_210613_create_client_logs_table', 1),
(12, '2024_10_06_034703_create_lib_suffixes_table', 2),
(13, '2024_10_06_035943_create_lib_roles_table', 3),
(14, '2024_09_30_154942_add_program_to_client_logs_table', 4),
(15, '2024_09_30_164004_drop_program_column_from_client_logs_table', 4),
(16, '2024_10_02_153433_add_program_id_to_client_logs_table', 4),
(17, '2024_10_07_145532_add_program_to_client_logs_table', 4);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(191) NOT NULL,
  `token` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `programs`
--

CREATE TABLE `programs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(55) NOT NULL,
  `logo` varchar(50) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `programs`
--

INSERT INTO `programs` (`id`, `name`, `logo`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Assistance to Individuals in Crisis Situation (AICS)', 'ppd-images/aics.png', 0, '2024-09-18 13:36:21', '2024-10-05 18:41:47'),
(2, 'Centenarian', 'ppd-images/centenarian.png', 0, '2024-09-18 13:36:46', '2024-10-05 18:35:02'),
(3, 'Disaster Response and Management Program (DRMP)', 'ppd-images/disaster.png', 0, '2024-09-18 13:37:06', '2024-10-05 18:35:14'),
(4, 'Kalahi CIDSS (KC-NCDDP)', 'ppd-images/kalahi.png', 0, '2024-09-18 13:37:22', '2024-10-05 18:35:24'),
(5, 'Pantawid Pamilyang Pilipino Program (4P\'s)', 'ppd-images/4ps.png', 0, '2024-09-18 13:37:39', '2024-10-05 18:35:35'),
(6, 'Social Pension (SocPen) for Indigent Senior Citizen', 'ppd-images/socpen.png', 0, '2024-09-18 13:38:34', '2024-10-16 22:37:15'),
(7, 'Supplementary Feeding Program (SFP)', 'ppd-images/sfp.png', 0, '2024-09-18 13:40:08', '2024-10-17 00:32:13'),
(8, 'Sustainable Livelihood Program (SLP)', 'ppd-images/slp.png', 0, '2024-09-18 13:40:25', '2024-10-05 18:36:07');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(191) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('fiQdmrJvEh3ZXSsG5KLknuZRtC30X41v9aintKIL', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiRERHT0tIc3VYYTFjTWo3c2tzd1Y5cTk2UTYyN1VMd3dGVWRVODhpeSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo1MDoibG9naW5fd2ViXzU5YmEzNmFkZGMyYjJmOTQwMTU4MGYwMTRjN2Y1OGVhNGUzMDk4OWQiO2k6MTtzOjk6Il9wcmV2aW91cyI7YToxOntzOjM6InVybCI7czozNzoiaHR0cDovLzEyNy4wLjAuMTo4MDAwL2FkbWluLWRhc2hib2FyZCI7fX0=', 1729130815),
('g64hcy9jWdggKdS9R2e1U8OBcEu0rt9Xz7bEYGhp', 1, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiWlRKb0hUM0hTZG5DZzZPdGhYWHZ3Um9uN2VzaUdiN3RXc244bkxEcyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzA6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMC9wcm9ncmFtcyI7fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7fQ==', 1729130791);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_citymuni`
--

CREATE TABLE `tbl_citymuni` (
  `psgc` varchar(10) NOT NULL,
  `col_citymuni` varchar(45) NOT NULL,
  `district` int(11) NOT NULL,
  `province_psgc` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_citymuni`
--

INSERT INTO `tbl_citymuni` (`psgc`, `col_citymuni`, `district`, `province_psgc`) VALUES
('1', '1st Congressional District', 0, '112402000'),
('112301000', 'Asuncion', 1, '112300000'),
('112303000', 'Carmen', 2, '112300000'),
('112305000', 'Kapalong', 1, '112300000'),
('112314000', 'New Corella', 1, '112300000'),
('112315000', 'City of Panabo', 2, '112300000'),
('112317000', 'Island Garden City of Samal', 2, '112300000'),
('112318000', 'Santo Tomas', 2, '112300000'),
('112319000', 'Tagum City', 1, '112300000'),
('112322000', 'Talaingod', 1, '112300000'),
('112323000', 'Braulio Dujali', 2, '112300000'),
('112324000', 'San Isidro', 1, '112300000'),
('112401000', 'Bansalan', 0, '112400000'),
('112403000', 'City of Digos', 0, '112400000'),
('112404000', 'Hagonoy', 0, '112400000'),
('112406000', 'Kiblawan', 0, '112400000'),
('112407000', 'Magsaysay', 0, '112400000'),
('112408000', 'Malalag', 0, '112400000'),
('112410000', 'Matanao', 0, '112400000'),
('112411000', 'Padada', 0, '112400000'),
('112412000', 'Sta. Cruz', 0, '112400000'),
('112414000', 'Sulop', 0, '112400000'),
('112501000', 'Baganga', 1, '112500000'),
('112502000', 'Banaybanay', 2, '112500000'),
('112503000', 'Boston', 1, '112500000'),
('112504000', 'Caraga', 1, '112500000'),
('112505000', 'Cateel', 1, '112500000'),
('112506000', 'Governor Generoso', 2, '112500000'),
('112507000', 'Lupon', 2, '112500000'),
('112508000', 'Manay', 1, '112500000'),
('112509000', 'City of Mati', 2, '112500000'),
('112510000', 'San Isidro', 2, '112500000'),
('112511000', 'Tarragona', 1, '112500000'),
('118201000', 'Compostela', 1, '118200000'),
('118202000', 'Laak', 2, '118200000'),
('118203000', 'Mabini', 2, '118200000'),
('118204000', 'Maco', 2, '118200000'),
('118205000', 'Maragusan', 1, '118200000'),
('118206000', 'Mawab', 2, '118200000'),
('118207000', 'Monkayo', 1, '118200000'),
('118208000', 'Montevista', 1, '118200000'),
('118209000', 'Nabunturan', 2, '118200000'),
('118210000', 'New Bataan', 1, '118200000'),
('118211000', 'Pantukan', 2, '118200000'),
('118601000', 'Don Marcelino', 0, '118600000'),
('118602000', 'Jose Abad Santos', 0, '118600000'),
('118603000', 'Malita', 0, '118600000'),
('118604000', 'Sta. Maria', 0, '118600000'),
('118605000', 'Sarangani', 0, '118600000'),
('2', '2nd Congressional District', 0, '112402000'),
('3', '3rd Congressional District', 0, '112402000');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_province`
--

CREATE TABLE `tbl_province` (
  `psgc` varchar(10) NOT NULL,
  `col_province` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tbl_province`
--

INSERT INTO `tbl_province` (`psgc`, `col_province`) VALUES
('112300000', 'Davao del Norte'),
('112400000', 'Davao del Sur'),
('112402000', 'Davao City'),
('112500000', 'Davao Oriental'),
('118200000', 'Davao de Oro'),
('118600000', 'Davao Occidental');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(35) NOT NULL,
  `middle_name` varchar(15) DEFAULT NULL,
  `last_name` varchar(15) NOT NULL,
  `suffix` varchar(5) DEFAULT NULL,
  `role` int(11) NOT NULL,
  `email` varchar(35) NOT NULL,
  `employeeid` varchar(10) NOT NULL,
  `password` varchar(191) NOT NULL,
  `program` bigint(20) UNSIGNED DEFAULT NULL,
  `approved` tinyint(1) NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `otp` varchar(6) DEFAULT NULL,
  `otp_expires_at` timestamp NULL DEFAULT NULL,
  `otp_verified_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `first_name`, `middle_name`, `last_name`, `suffix`, `role`, `email`, `employeeid`, `password`, `program`, `approved`, `active`, `otp`, `otp_expires_at`, `otp_verified_at`, `created_at`, `updated_at`) VALUES
(1, 'Meliza', NULL, 'Facun', NULL, 1, 'facunmeliza26@gmail.com', '123', '$2y$12$twtcxSPzaJ2WK/On0j9ENuIoJ8jWM9tYFgmC/i7oCxv/yR7Dokfoy', NULL, 1, 1, '386673', '2024-10-17 02:10:58', '2024-10-17 02:06:21', '2024-09-18 12:57:41', '2024-10-17 02:06:21'),
(2, 'Mel', NULL, 'lor', NULL, 1, 'mlfacun03187@usep.edu.ph', '132', '$2y$12$/ppQWVdJNTk05joCnCGv..kbOvLiYfQoRxvUbSARz2eefMtACVrAS', 8, 1, 1, '481789', '2024-10-03 08:39:56', '2024-10-03 08:35:52', '2024-09-18 14:24:22', '2024-10-16 22:35:51'),
(3, 'Meliza', 'Lorenzo', 'Facun', NULL, 0, 'facunmeliza36@gmail.com', '4231', '$2y$12$/2fVJ/8eH41/8hB9A43q1OPuoBXtvOiExHxAarhsprFYnUO/1cF/K', 1, 1, 0, NULL, NULL, NULL, '2024-09-30 14:18:11', '2024-10-05 19:43:26'),
(4, 'p', NULL, 'p', NULL, 1, 'policyandplansdivision0@gmail.com', '2313', '$2y$12$jzK0yYfCgZNwl7hZ2JyWQeQsDUaS/OM54BSuCYzEm5Nfage.yk7J2', 3, 1, 0, NULL, NULL, NULL, '2024-09-30 14:49:14', '2024-10-16 22:06:40'),
(12, 'Lorgil', 'Busca', 'Lubiano', NULL, 0, 'lorgillubiano@gmail.com', '11-02216', '$2y$12$3kBlAru0xMW/87mGvWl77ev1kSo8BmFgXkrIUnpcCNPPRFEe/g726', 6, 1, 1, '400476', '2024-10-17 01:11:19', '2024-10-17 01:06:56', '2024-10-07 07:01:28', '2024-10-17 01:06:56'),
(13, 'Jay Ar Marck', 'Torres', 'Grandia', NULL, 0, 'jam@dswd.gov.ph', '11-18206', '$2y$12$9Y.YYJekqqjzNRYV0q4pduQlmjUCunMn5NdNvlg7RYPlxDfOXceT.', 7, 1, 1, '687190', '2024-10-07 07:10:55', '2024-10-07 07:06:17', '2024-10-07 07:05:17', '2024-10-11 19:27:26');

-- --------------------------------------------------------

--
-- Table structure for table `utilizations`
--

CREATE TABLE `utilizations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `province` varchar(10) NOT NULL,
  `city_municipality` varchar(10) NOT NULL,
  `program` bigint(20) UNSIGNED DEFAULT NULL,
  `physical` int(11) NOT NULL,
  `fund_utilized` decimal(15,2) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `utilizations`
--

INSERT INTO `utilizations` (`id`, `province`, `city_municipality`, `program`, `physical`, `fund_utilized`, `created_at`, `updated_at`) VALUES
(17, '112300000', '112303000', 6, 30, 270.00, '2024-10-11 11:30:39', '2024-10-11 18:36:25'),
(18, '112300000', '112303000', 6, 50, 40.00, '2024-10-11 11:31:11', '2024-10-11 11:31:11'),
(19, '112300000', '112303000', 1, 40, 700.00, '2024-10-11 11:51:13', '2024-10-11 11:51:40'),
(20, '112400000', '112404000', 6, 50, 80.00, '2024-10-11 12:42:19', '2024-10-11 12:42:19'),
(21, '112300000', '112303000', 6, 50, 1000.00, '2024-10-11 15:11:57', '2024-10-11 15:11:57'),
(22, '112402000', '1', 6, 1, 1.00, '2024-10-11 18:14:10', '2024-10-11 18:14:10'),
(23, '118200000', '118206000', 6, 1, 1.00, '2024-10-11 18:59:14', '2024-10-11 18:59:14'),
(24, '118600000', '118604000', 6, 123, 5000.00, '2024-10-11 19:19:34', '2024-10-11 19:19:34'),
(25, '112300000', '112303000', 6, 5, 90.00, '2024-10-16 22:09:48', '2024-10-16 22:09:48'),
(26, '112500000', '112509000', 6, 10, 69.00, '2024-10-16 22:12:27', '2024-10-16 22:12:27'),
(27, '118600000', '118605000', 1, 5, 50.00, '2024-10-17 00:25:08', '2024-10-17 00:25:08'),
(28, '112402000', '1', 1, 30, 300.00, '2024-10-17 00:26:11', '2024-10-17 00:26:11'),
(29, '112402000', '2', 1, 34, 3500.00, '2024-10-17 00:26:48', '2024-10-17 00:26:48'),
(30, '112400000', '112401000', 2, 32, 7000.00, '2024-10-17 00:28:43', '2024-10-17 00:28:43'),
(31, '118200000', '118203000', 3, 40, 4000.00, '2024-10-17 00:29:46', '2024-10-17 00:29:46'),
(32, '112500000', '112505000', 4, 35, 3000.00, '2024-10-17 00:30:52', '2024-10-17 00:30:52'),
(33, '112402000', '3', 5, 7, 390.00, '2024-10-17 00:31:39', '2024-10-17 00:31:39'),
(34, '112400000', '112404000', 8, 35, 2000.00, '2024-10-17 00:33:23', '2024-10-17 00:33:23');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_logs_user_id_foreign` (`user_id`);

--
-- Indexes for table `allocations`
--
ALTER TABLE `allocations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `allocations_province_foreign` (`province`),
  ADD KEY `allocations_city_municipality_foreign` (`city_municipality`),
  ADD KEY `allocations_program_foreign` (`program`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `client_logs`
--
ALTER TABLE `client_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_logs_user_id_foreign` (`user_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lib_roles`
--
ALTER TABLE `lib_roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lib_suffixes`
--
ALTER TABLE `lib_suffixes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `logs_user_id_foreign` (`user_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `programs`
--
ALTER TABLE `programs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `tbl_citymuni`
--
ALTER TABLE `tbl_citymuni`
  ADD PRIMARY KEY (`psgc`),
  ADD KEY `tbl_citymuni_province_psgc_foreign` (`province_psgc`);

--
-- Indexes for table `tbl_province`
--
ALTER TABLE `tbl_province`
  ADD PRIMARY KEY (`psgc`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_employeeid_unique` (`employeeid`),
  ADD KEY `users_program_foreign` (`program`);

--
-- Indexes for table `utilizations`
--
ALTER TABLE `utilizations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `utilizations_province_foreign` (`province`),
  ADD KEY `utilizations_city_municipality_foreign` (`city_municipality`),
  ADD KEY `utilizations_program_foreign` (`program`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_logs`
--
ALTER TABLE `admin_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=139;

--
-- AUTO_INCREMENT for table `allocations`
--
ALTER TABLE `allocations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `client_logs`
--
ALTER TABLE `client_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=112;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lib_roles`
--
ALTER TABLE `lib_roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `lib_suffixes`
--
ALTER TABLE `lib_suffixes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `programs`
--
ALTER TABLE `programs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `utilizations`
--
ALTER TABLE `utilizations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD CONSTRAINT `admin_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `allocations`
--
ALTER TABLE `allocations`
  ADD CONSTRAINT `allocations_city_municipality_foreign` FOREIGN KEY (`city_municipality`) REFERENCES `tbl_citymuni` (`psgc`) ON DELETE CASCADE,
  ADD CONSTRAINT `allocations_program_foreign` FOREIGN KEY (`program`) REFERENCES `programs` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `allocations_province_foreign` FOREIGN KEY (`province`) REFERENCES `tbl_province` (`psgc`) ON DELETE CASCADE;

--
-- Constraints for table `client_logs`
--
ALTER TABLE `client_logs`
  ADD CONSTRAINT `client_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tbl_citymuni`
--
ALTER TABLE `tbl_citymuni`
  ADD CONSTRAINT `tbl_citymuni_province_psgc_foreign` FOREIGN KEY (`province_psgc`) REFERENCES `tbl_province` (`psgc`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_program_foreign` FOREIGN KEY (`program`) REFERENCES `programs` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `utilizations`
--
ALTER TABLE `utilizations`
  ADD CONSTRAINT `utilizations_city_municipality_foreign` FOREIGN KEY (`city_municipality`) REFERENCES `tbl_citymuni` (`psgc`) ON DELETE CASCADE,
  ADD CONSTRAINT `utilizations_program_foreign` FOREIGN KEY (`program`) REFERENCES `programs` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `utilizations_province_foreign` FOREIGN KEY (`province`) REFERENCES `tbl_province` (`psgc`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

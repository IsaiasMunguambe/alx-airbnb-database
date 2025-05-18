CREATE TABLE `users` (
  `user_id` uuid UNIQUE PRIMARY KEY NOT NULL COMMENT 'Primary Key, Indexed',
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `email` varchar(255) UNIQUE NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `phone_number` varchar(255),
  `role` enum(guest,host,admin) NOT NULL,
  `created_at` timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `properties` (
  `property_id` uuid UNIQUE PRIMARY KEY NOT NULL COMMENT 'Primary Key, Indexed',
  `host_id` uuid NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `location` varchar(255) NOT NULL,
  `pricepernight` decimal NOT NULL,
  `created_at` timestamp DEFAULT (CURRENT_TIMESTAMP),
  `updated_at` timestamp COMMENT 'ON UPDATE CURRENT_TIMESTAMP'
);

CREATE TABLE `bookings` (
  `booking_id` uuid UNIQUE PRIMARY KEY NOT NULL COMMENT 'Primary Key, Indexed',
  `property_id` uuid NOT NULL COMMENT 'Indexed',
  `user_id` uuid NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `total_price` decimal NOT NULL,
  `status` enum(pending,confirmed,canceled) NOT NULL,
  `created_at` timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `payments` (
  `payment_id` uuid UNIQUE PRIMARY KEY NOT NULL COMMENT 'Primary Key, Indexed',
  `booking_id` uuid NOT NULL COMMENT 'Indexed',
  `amount` decimal NOT NULL,
  `payment_date` timestamp DEFAULT (CURRENT_TIMESTAMP),
  `payment_method` enum(credit_card,paypal,stripe) NOT NULL
);

CREATE TABLE `reviews` (
  `review_id` uuid UNIQUE PRIMARY KEY NOT NULL COMMENT 'Primary Key, Indexed',
  `property_id` uuid NOT NULL,
  `user_id` uuid NOT NULL,
  `rating` int NOT NULL COMMENT 'CHECK rating >= 1 AND rating <= 5',
  `comment` text NOT NULL,
  `created_at` timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE `messages` (
  `message_id` uuid UNIQUE PRIMARY KEY NOT NULL COMMENT 'Primary Key, Indexed',
  `sender_id` uuid NOT NULL,
  `recipient_id` uuid NOT NULL,
  `message_body` text NOT NULL,
  `sent_at` timestamp DEFAULT (CURRENT_TIMESTAMP)
);

ALTER TABLE `properties` ADD FOREIGN KEY (`host_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `bookings` ADD FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`);

ALTER TABLE `bookings` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `payments` ADD FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`);

ALTER TABLE `reviews` ADD FOREIGN KEY (`property_id`) REFERENCES `properties` (`property_id`);

ALTER TABLE `reviews` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `messages` ADD FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`);

ALTER TABLE `messages` ADD FOREIGN KEY (`recipient_id`) REFERENCES `users` (`user_id`);

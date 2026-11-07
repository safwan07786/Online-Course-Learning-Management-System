-- Antigravity LMS Database Schema
-- Project: Online Course Learning Management System
-- Architect & Creator: Safwaan & Antigravity

CREATE DATABASE IF NOT EXISTS antigravity_lms;
USE antigravity_lms;

-- Drop existing tables to ensure clean setup
DROP TABLE IF EXISTS enrollment;
DROP TABLE IF EXISTS lesson;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS users;

-- Table 1: users
-- user_id int pk, name varchar(100), email varchar(100), password varchar(255), role varchar(20)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'student',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 2: courses
-- course_id int pk, title varchar(150), description text, instructor_id int fk, price decimal, duration int
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    instructor_id INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    duration INT NOT NULL DEFAULT 0, -- Duration in hours
    category VARCHAR(80) DEFAULT 'Development',
    thumbnail_url VARCHAR(255) DEFAULT 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&auto=format&fit=crop&q=60',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (instructor_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Table 3: lesson
-- lesson_id int pk, course_id int fk, lesson_title varchar(150), content text, video_url varchar(250), sequence_no int
CREATE TABLE lesson (
    lesson_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    lesson_title VARCHAR(150) NOT NULL,
    content TEXT,
    video_url VARCHAR(250),
    sequence_no INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Table 4: enrollment
-- enrollment_id int pk, user_id int fk, course_id int fk, enrollment_date date, progress int, status varchar(30)
CREATE TABLE enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    progress INT NOT NULL DEFAULT 0,
    status VARCHAR(30) NOT NULL DEFAULT 'In Progress',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY user_course_unique (user_id, course_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Seed Initial Users
-- Password for all default accounts is: password123
INSERT INTO users (user_id, name, email, password, role) VALUES
(1, 'Safwaan', 'safwaan@lms.com', '$2a$10$wT8vIqvJ7P3x1yKqV3C3be8zO9R4j/lX1jL1Gk0xX0y1Y1Z1a1b1c', 'instructor'),
(2, 'Safwaan Student', 'safwaan.student@lms.com', '$2a$10$wT8vIqvJ7P3x1yKqV3C3be8zO9R4j/lX1jL1Gk0xX0y1Y1Z1a1b1c', 'student'),
(3, 'Dr. Sarah Connor', 'sarah@lms.com', '$2a$10$wT8vIqvJ7P3x1yKqV3C3be8zO9R4j/lX1jL1Gk0xX0y1Y1Z1a1b1c', 'instructor'),
(4, 'Alex Johnson', 'alex@lms.com', '$2a$10$wT8vIqvJ7P3x1yKqV3C3be8zO9R4j/lX1jL1Gk0xX0y1Y1Z1a1b1c', 'student');

-- Update passwords so fallback also checks 'password123' if raw or bcrypt
-- Seed Courses created by Safwaan and instructors
INSERT INTO courses (course_id, title, description, instructor_id, price, duration, category, thumbnail_url) VALUES
(1, 'Full Stack Web Mastery: Express, Node & MySQL', 'Master modern full-stack web engineering from database architecture to interactive REST APIs and responsive user interfaces. Curated by Lead Instructor Safwaan.', 1, 49.99, 45, 'Web Development', 'https://images.unsplash.com/photo-1593720213428-28a5b9e94613?w=800&auto=format&fit=crop&q=60'),
(2, 'Python Data Science & Machine Learning Masterclass', 'Comprehensive guide to data analysis, pandas, numpy, scikit-learn, and building predictive machine learning models.', 1, 59.99, 60, 'Data Science', 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800&auto=format&fit=crop&q=60'),
(3, 'Modern UI/UX Design with Figma & CSS Grid', 'Design sleek, accessible, modern web interfaces with Figma, layout systems, color theory, and responsive CSS.', 3, 39.99, 30, 'Design', 'https://images.unsplash.com/photo-1581291518857-4e27b48ff24e?w=800&auto=format&fit=crop&q=60'),
(4, 'Database Architecture & High Performance SQL', 'Deep dive into relational database design, indexing strategies, query optimization, and transaction management with MySQL.', 1, 44.99, 35, 'Database Systems', 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=800&auto=format&fit=crop&q=60');

-- Seed Lessons for Course 1 (Full Stack Web Mastery)
INSERT INTO lesson (course_id, lesson_title, content, video_url, sequence_no) VALUES
(1, 'Introduction to Full Stack Architecture', 'Welcome to the course! In this lesson, we explore client-server architecture, HTTP request-response lifecycle, and how Express.js talks with MySQL.', 'https://www.youtube.com/embed/dQw4w9WgXcQ', 1),
(1, 'Setting up Express.js & Middleware', 'Understand Express router, JSON body parsing, CORS configurations, and structuring modular route handlers.', 'https://www.youtube.com/embed/SccSCuHhOw0', 2),
(1, 'Relational Database Schema & Foreign Keys', 'Step-by-step breakdown of normalized table designs, primary keys, foreign key constraints, and relational integrity.', 'https://www.youtube.com/embed/HXV3zeRR3h4', 3),
(1, 'Building RESTful Endpoints with MySQL2 Pool', 'Learn how to utilize connection pools, execute prepared statements, handle errors gracefully, and return JSON responses.', 'https://www.youtube.com/embed/EN6Dx22cPRI', 4);

-- Seed Lessons for Course 2 (Python Data Science)
INSERT INTO lesson (course_id, lesson_title, content, video_url, sequence_no) VALUES
(2, 'Python Fundamentals for Data Analysis', 'Getting started with Python data structures, list comprehensions, lambda functions, and virtual environments.', 'https://www.youtube.com/embed/rfscVS0vtbw', 1),
(2, 'Data Wrangling with Pandas & NumPy', 'Importing CSVs, cleaning messy datasets, handling missing values, and performing vectorized aggregations.', 'https://www.youtube.com/embed/vmEHCJofslg', 2),
(2, 'Exploratory Data Visualization with Matplotlib', 'Plotting distributions, heatmaps, scatter diagrams, and creating executive dashboards.', 'https://www.youtube.com/embed/3ZwuKEWE4TE', 3);

-- Seed Lessons for Course 3 (UI/UX Design)
INSERT INTO lesson (course_id, lesson_title, content, video_url, sequence_no) VALUES
(3, 'Visual Hierarchy & Typography Foundations', 'Principles of high-conversion interface design, whitespace, typography scales, and color contrast standards.', 'https://www.youtube.com/embed/c9Wg6Cb_YlU', 1),
(3, 'Mastering Figma Components & Auto Layout', 'Build modular design systems, reusable components, variants, and responsive frames.', 'https://www.youtube.com/embed/HZuk6Wkx_Eg', 2);

-- Seed Enrollments
INSERT INTO enrollment (user_id, course_id, enrollment_date, progress, status) VALUES
(2, 1, '2026-10-15', 50, 'In Progress'),
(2, 3, '2026-10-20', 100, 'Completed'),
(4, 1, '2026-11-01', 25, 'In Progress'),
(4, 2, '2026-11-02', 75, 'In Progress');

# Antigravity LMS - Online Course Learning Management System
**Architect & Creator:** Safwaan  
**AI Assistant:** Antigravity  
**Stack:** HTML5, CSS3, Vanilla JavaScript, Node.js (Express.js), MySQL 8.0

---

## 📌 Project Overview
Antigravity LMS is a full-featured e-learning web platform engineered to connect instructors and learners. 
- **Instructors** can create comprehensive courses, set prices and duration, upload lesson notes, attach video resources (YouTube/MP4), and monitor student enrollment metrics.
- **Students** can browse course catalogs, filter by domain, enroll in courses, study lessons sequentially through an interactive video player, and track their real-time completion progress stored directly in MySQL.

---

## 🗄️ MySQL Database Architecture

Database Name: `antigravity_lms`

### Table 1: `users`
| Column | Type | Constraints | Description |
|---|---|---|---|
| `user_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique User Identifier |
| `name` | VARCHAR(100) | NOT NULL | User's Full Name |
| `email` | VARCHAR(100) | NOT NULL, UNIQUE | User Login Email |
| `password` | VARCHAR(255) | NOT NULL | Hashed Password (bcrypt) |
| `role` | VARCHAR(20) | NOT NULL, DEFAULT 'student' | Role: 'student' or 'instructor' |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Registration Date |

### Table 2: `courses`
| Column | Type | Constraints | Description |
|---|---|---|---|
| `course_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique Course Identifier |
| `title` | VARCHAR(150) | NOT NULL | Course Title |
| `description` | TEXT | NULL | Course Curriculum Summary |
| `instructor_id`| INT | FOREIGN KEY (`users.user_id`) | Course Creator/Instructor |
| `price` | DECIMAL(10,2)| NOT NULL, DEFAULT 0.00 | Course Price in USD |
| `duration` | INT | NOT NULL, DEFAULT 0 | Estimated Duration (in Hours) |
| `category` | VARCHAR(80) | DEFAULT 'Web Development' | Course Topic Category |
| `thumbnail_url`| VARCHAR(255)| NULL | Image Thumbnail URL |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Course Creation Timestamp |

### Table 3: `lesson`
| Column | Type | Constraints | Description |
|---|---|---|---|
| `lesson_id` | INT | PRIMARY KEY, AUTO_INCREMENT | Unique Lesson Identifier |
| `course_id` | INT | FOREIGN KEY (`courses.course_id`) | Belongs to Course |
| `lesson_title`| VARCHAR(150)| NOT NULL | Title of the Lesson |
| `content` | TEXT | NULL | Comprehensive Reading Notes & Text |
| `video_url` | VARCHAR(250)| NULL | YouTube Embed or Direct Video Stream |
| `sequence_no` | INT | NOT NULL, DEFAULT 1 | Sequential Lesson Order |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Upload Timestamp |

### Table 4: `enrollment`
| Column | Type | Constraints | Description |
|---|---|---|---|
| `enrollment_id`| INT | PRIMARY KEY, AUTO_INCREMENT | Unique Enrollment ID |
| `user_id` | INT | FOREIGN KEY (`users.user_id`) | Enrolled Student |
| `course_id` | INT | FOREIGN KEY (`courses.course_id`) | Enrolled Course |
| `enrollment_date`| DATE | NOT NULL | Date of Enrollment |
| `progress` | INT | NOT NULL, DEFAULT 0 | Progress Percentage (0 - 100%) |
| `status` | VARCHAR(30) | DEFAULT 'In Progress' | 'In Progress' or 'Completed' |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record Timestamp |

---

## ⚡ Quick Start & Run Instructions

### 1. Database Setup (Already Executed)
The database schema has already been created in your local MySQL Server (`safwan@222`).
If you ever want to re-seed or inspect the schema, you can run:
```bash
mysql -u root -p"safwan@222" < database.sql
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Start the Server
```bash
npm start
```
The server will start on:
👉 **http://localhost:5000**

---

## 👥 Pre-Configured Test Accounts

| Role | Name | Email | Password |
|---|---|---|---|
| **Instructor** | Safwaan | `safwaan@lms.com` | `password123` |
| **Student** | Safwaan Student | `safwaan.student@lms.com` | `password123` |
| **Instructor** | Dr. Sarah Connor | `sarah@lms.com` | `password123` |
| **Student** | Alex Johnson | `alex@lms.com` | `password123` |

*(You can also use 1-click login buttons on the Login page!)*

---

## 🖥️ Separate HTML Pages Included
1. `index.html` - Homepage / Landing page with metrics, featured courses, and hero banner.
2. `courses.html` - Full Course Catalog with live search and category filters.
3. `course-details.html` - Course overview, syllabus, instructor card, and enrollment triggers.
4. `student-dashboard.html` - Student portal with progress bars, status badges, and resume links.
5. `instructor-dashboard.html` - Instructor studio with revenue metrics, student counts, and course actions.
6. `create-course.html` - Form to create and publish new courses.
7. `manage-lessons.html` - Modal and table to add, sequence, edit, and delete video lessons.
8. `course-player.html` - Interactive video classroom with playlist and real-time progress updater.
9. `login.html` - Authentication page with 1-click demo logins.
10. `register.html` - Registration for both students and instructors.

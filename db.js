const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'safwan@222',
    database: process.env.DB_NAME || 'antigravity_lms',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Test connection
(async () => {
    try {
        const connection = await pool.getConnection();
        console.log(' Successfully connected to MySQL database: ' + (process.env.DB_NAME || 'antigravity_lms'));
        connection.release();
    } catch (err) {
        console.error(' MySQL Connection Error:', err.message);
    }
})();

module.exports = pool;

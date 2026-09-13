import dotenv from "dotenv";
import { createPool } from "mysql2";

dotenv.config();

const pool = createPool({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT) || 3306,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

pool.getConnection((err, connection) => {
  if (err) {
    console.error("Database connection error:", err.message, err.code);
  } else {
    if (connection) connection.release();
    console.log("Database connected successfully!!");
  }
});

export default pool;

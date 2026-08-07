import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, resolve } from 'path';
import { createConnection } from 'mysql2/promise';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
dotenv.config({ path: resolve(__dirname, './.env') });

async function createDb() {
  const { DB_HOST, DB_USER, DB_PASSWORD, DB_PORT, DB_NAME } = process.env;
  try {
    const conn = await createConnection({
      host: DB_HOST,
      user: DB_USER,
      password: DB_PASSWORD,
      port: Number(DB_PORT) || 3306,
    });
    await conn.query(`CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\``);
    console.log('Database ensured:', DB_NAME);
    await conn.end();
  } catch (err) {
    console.error('Failed to create database:', err.message);
    process.exitCode = 1;
  }
}

createDb();

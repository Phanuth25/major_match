import pool from "./config/db.js";

async function test() {
  try {
    const [rows] = await pool.promise().query("SELECT 1+1 AS result");
    console.log("DB OK, result:", rows[0]?.result);
  } catch (err) {
    console.error("DB test failed:", err.message);
    process.exitCode = 1;
  } finally {
    try {
      await pool.promise().end();
    } catch (e) {}
  }
}

test();

import pool from "../../config/db.js";

const AttemptModel = {
  attempt: (user_id, started_at, duration_second, callback) => {
    const sql =
      "Insert into quiz_attempt(user_id,started_at,duration_second) values(?,?,?)";
    pool.query(sql, [user_id, started_at, duration_second], callback);
  },
};

export default AttemptModel;

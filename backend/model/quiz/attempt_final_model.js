import pool from "../../config/db.js";

const AttemptFinalModel = {
  attemptFinal: (quiz_attempt_id, major_id, score, callback) => {
    const sql =
      "INSERT INTO quiz_final_result (quiz_attempt_id, major_id, score) VALUES (?, ?, ?)";
    pool.query(sql, [quiz_attempt_id, major_id, score], callback);
  },
};

export default AttemptFinalModel;

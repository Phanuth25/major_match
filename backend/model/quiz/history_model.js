import pool from "../../config/db.js";

const HistoryModel = {
  history: (user_id, callback) => {
    const sql =
      "SELECT * FROM history_view WHERE user_id = ? ORDER BY attempt_number DESC, score DESC";
    pool.query(sql, [user_id], callback);
  },
};

export default HistoryModel;

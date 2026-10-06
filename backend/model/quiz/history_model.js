import pool from "../../config/db.js";

const HistoryModel = {
  history: (user_id, callback) => {
    const sql = "SELECT * FROM history_view WHERE user_id = ?";
    pool.query(sql, [user_id], callback);
  },

  removeHistory: (user_id, id, callback) => {
    const sql = "DELETE FROM quiz_attempt WHERE user_id = ? AND id = ?";
    pool.query(sql, [user_id, id], callback);
  },
};

export default HistoryModel;

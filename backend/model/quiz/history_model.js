import pool from "../../config/db.js";

const HistoryModel = {
  history: (user_id, callback) => {
    const sql =
      "SELECT * FROM history_view where user_id = ? order by started_at desc";
    pool.query(sql, [user_id], callback);
  },
};

export default HistoryModel;

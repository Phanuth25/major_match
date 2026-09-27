import pool from "../../config/db.js";

const QuestionModel = {
  selectById: (id, type, callback) => {
    if (type === "km") {
      const sql = "SELECT * FROM questions_khmer WHERE major_id = ?";
      return pool.query(sql, [id], callback);
    }

    const sql = "SELECT * FROM questions WHERE major_id = ?";
    pool.query(sql, [id], callback);
  },
};

export default QuestionModel;
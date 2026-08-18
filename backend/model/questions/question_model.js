import pool from "../../config/db.js";

const QuestionModel = {
  selectById: (id, callback) => {
    const sql = "SELECT * FROM questions WHERE major_id = ?";
    pool.query(sql, [id], callback);
  },
};

export default QuestionModel;

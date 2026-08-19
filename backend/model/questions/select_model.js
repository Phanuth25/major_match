import pool from "../../config/db.js";

const SelectModel = {
  selectByIds: (ids, callback) => {
    const sql = "SELECT * FROM questions WHERE id IN (?)";
    pool.query(sql, [ids], callback);
  },
};

export default SelectModel;

import pool from "../../config/db.js";

const RegisterModel = {
  register: (name, email, password, profile_image, callback) => {
    const sql =
      "INSERT INTO users (name, email, password, profile_image) VALUES (?, ?, ?, ?)";
    pool.query(sql, [name, email, password, profile_image], callback);
  },
};

export default RegisterModel;

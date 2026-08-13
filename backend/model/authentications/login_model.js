import pool from "../../config/db.js";

const LoginModel = {
    login: (email, callback) => {
        const sql = "SELECT * FROM users WHERE email = ?";
        pool.query(sql, [email], callback);
    }
};

export default LoginModel;
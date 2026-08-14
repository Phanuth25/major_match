import pool from "../../config/db.js";

const SelectModel = {
    select: (callback) => {
        const sql = "SELECT * FROM majors";
        pool.query(sql, callback);
    }
};

export default SelectModel;
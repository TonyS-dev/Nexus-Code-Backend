import { query } from "../models/db_connection.js";

export const findAll = async() => {
    const res = await query(`SELECT * FROM vacation_types;`)
    return res.rows;
}

export const findById = async(id) => {
    const res = await query(`SELECT * FROM vacation_types WHERE id = $1;`, [id])
    return res.rows[0];
}


export const create = async(vacation_types_data) => {
    const { name_type } = vacation_types_data
    const res = await query(`INSERT INTO vacation_types (type_name) VALUES($1);`, [name_type] )
    return res.rows[0].id;
}

export const update = async(id, vacation_types_data) => {
    const res = await query("UPDATE vacation_types SET type_name = $1 WHERE id = '$2'", [id, vacation_types_data])
    return res.rows[0];
}
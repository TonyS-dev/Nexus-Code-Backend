import { query } from "../models/db_connection";

export const findAll = async() => {
    const res = await query(`SELECT * FROM leave_types ORDER BY name ASC;`)
    return res.rows;
}

export const findById = async(id) => {
    const res = await query(`SELECT * FROM leave_types WHERE id = $1;`, [id])
    return res.rows[0];
}


export const create = async(leave_types) => {
    const { name_type, requires_attachment } = leave_types
    const res = await query(`INSERT INTO leave_types (name, requires_attachment) VALUES($1, $2);`, [name_type, requires_attachment] )
    return res.rows[0].id;
}

export const update = async(id, leave_types) => {
    const { name, requires_attachment } = leave_types
    const res = await query(`UPDATE leave_types SET name = '$1', requires_attachment = $2 WHERE id = $3`, [name, requires_attachment, id])
    return res.rows[0];
}
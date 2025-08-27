import { query } from "../models/db_connection.js";

export const findAll = async() => {
    const res = await query(`SELECT * FROM identification_types;`)
    return res.rows;
}

export const findById = async(id) => {
    const res = await query(`SELECT name FROM identification_types WHERE id = $1`, [id])
    return res.rows[0];
}


export const create = async(type_identification_data) => {
    const { name_type } = type_identification_data
    const res = await query(`INSERT INTO identification_types(name) VALUES ($1);`, [name_type] )
    return res.rows[0].id;
}

export const update = async(id, identification_type_data) => {
    const res = await query(`UPDATE identification_types SET name = $1 WHERE id = $2`, [id, identification_type_data])
    return res.rows[0];
}
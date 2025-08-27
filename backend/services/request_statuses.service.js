import { query } from "../models/db_connection.js";

export const findAll = async() => {
    const res = await query(`SELECT * FROM request_statuses ORDER BY name ASC;`)
    return res.rows;
}

export const findById = async(id) => {
    const res = await query(`SELECT * FROM request_statuses WHERE id = $1;`, [id])
    return res.rows[0];
}


export const create = async(certificate_types) => {
    const { name } = certificate_types
    const res = await query(`INSERT INTO request_statuses (name) VALUES($1);`, [name] )
    return res.rows[0].id;
}

export const update = async(id, certificate_types) => {
    const { name } = certificate_types
    const res = await query(`UPDATE request_statuses SET name = $1 WHERE id = $2`, [name, id])
    return res.rows[0];
}
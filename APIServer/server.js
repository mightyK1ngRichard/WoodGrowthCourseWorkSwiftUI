const {postgresPort} = require('./config.js')
const {Pool} = require('pg')
const express = require('express');
const app = express();
// const host = 'localhost';
const port = 8010;

app.get('/database/:command', (req, res) => {
    const commandForSQL = req.params.command
    const pool = new Pool({
        user: postgresPort.user_pg,
        host: postgresPort.host_pg,
        database: postgresPort.db_name_pg,
        password: postgresPort.password_pg,
        port: postgresPort.port_pg,
    });
    pool.query(commandForSQL, (err, dbData) => {
        if (err) {
            res.send(err);
        } else {
            res.send(dbData);
        }
        pool.end();
    });
})

app.get('/database/update/:command', (req, res) => {
    const commandForSQL = decodeURIComponent(req.params.command)
    const pool = new Pool({
        user: postgresPort.user_pg,
        host: postgresPort.host_pg,
        database: postgresPort.db_name_pg,
        password: postgresPort.password_pg,
        port: postgresPort.port_pg,
    });
    pool.query(commandForSQL, (err, dbData) => {
        if (err) {
            res.send(err);
        } else {
            res.send(dbData);
        }
        pool.end();
    });
})


app.get('/typetrees', (req, res) => {
    const commandForSQL = `
    SELECT t.name_type, t.notes, t.type_id, f.name as fertilizer_name, p.name_plot as plot_name, t.photo, COUNT(tree_id) as count_trees
    FROM tree
    FULL JOIN type_tree t ON tree.type_tree_id = t.type_id
    LEFT JOIN fertilizer f ON t.type_id = f.type_tree_id
    LEFT JOIN plot p on t.type_id = p.type_tree_id
    GROUP BY t.name_type, t.notes, t.type_id, f.name, p.name_plot;
    `
    const pool = new Pool({
        user: postgresPort.user_pg,
        host: postgresPort.host_pg,
        database: postgresPort.db_name_pg,
        password: postgresPort.password_pg,
        port: postgresPort.port_pg,
    });
    pool.query(commandForSQL, (err, dbData) => {
        if (err) {
            res.send(err);
        } else {
            res.send(dbData);
        }
        pool.end();
    });
})

app.get('/', (req, res) => {
    res.send('Hello, World!');
  });

app.listen(port, () => {
    console.log(`Сервер запущен по адресу :${port}`);
});

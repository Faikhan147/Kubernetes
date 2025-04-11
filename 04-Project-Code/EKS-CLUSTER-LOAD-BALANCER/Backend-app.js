const express = require('express');
const mysql = require('mysql');
const { Client } = require('pg');
const oracledb = require('oracledb');

const app = express();

// MySQL Connection
const mysqlDb = mysql.createConnection({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USERNAME,
    password: process.env.MYSQL_PASSWORD,
    database: process.env.MYSQL_DATABASE || "faisal-mysql-db"
});

mysqlDb.connect(err => {
    if (err) {
        console.error('Error connecting to MySQL:', err.stack);
    } else {
        console.log('Connected to MySQL database');
    }
});

// PostgreSQL Connection
const postgresDb = new Client({
    host: process.env.POSTGRESQL_HOST,
    user: process.env.POSTGRESQL_USERNAME,
    password: process.env.POSTGRESQL_PASSWORD,
    database: process.env.POSTGRESQL_DATABASE || "faisal-postgresql-db",
    port: 5432
});

postgresDb.connect()
    .then(() => console.log('Connected to PostgreSQL database'))
    .catch(err => console.error('Error connecting to PostgreSQL:', err));

// Oracle Connection
async function connectOracleDB() {
    try {
        const connection = await oracledb.getConnection({
            user: process.env.ORACLE_USERNAME,
            password: process.env.ORACLE_PASSWORD,
            connectString: process.env.ORACLE_HOST
        });
        console.log('Connected to Oracle database');
        await connection.close();
    } catch (err) {
        console.error('Error connecting to Oracle:', err);
    }
}
connectOracleDB();

app.get('/', (req, res) => {
    res.send('Connected to MySQL, PostgreSQL, and Oracle databases!');
});

app.listen(3000, () => {
    console.log('App is running on http://localhost:3000');
});

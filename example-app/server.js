import express from "express";
import crypto from "crypto";
import path from "path";
import {fileURLToPath} from "url";
import {DynamoDBClient} from "@aws-sdk/client-dynamodb";
import {DynamoDBDocumentClient, GetCommand, PutCommand} from "@aws-sdk/lib-dynamodb";
import {GetSecretValueCommand, SecretsManagerClient} from "@aws-sdk/client-secrets-manager";
import mysql from "mysql2/promise";

const app = express();
const port = 3000;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const EC2_HOST = process.env.EC2_HOST || "localhost";

// --- DynamoDB config ---
const dynamo = DynamoDBDocumentClient.from(new DynamoDBClient({region: "eu-north-1"}));
const TABLE_NAME = "urls";

// --- MySQL (RDS) config ---
async function getDbConfig() {
    const smClient = new SecretsManagerClient({region: "eu-north-1"});
    const command = new GetSecretValueCommand({
        SecretId: "rds!db-c1147c30-c4ac-4cb3-a651-5f56f156f997"
    });
    const response = await smClient.send(command);
    return JSON.parse(response.SecretString);
}

let rdsPool;

async function initRds() {
    const secret = await getDbConfig();
    rdsPool = mysql.createPool({
        host: secret.host,
        user: secret.username,
        password: secret.password,
        database: secret.dbname,
        waitForConnections: true,
        connectionLimit: 5
    });
}

await initRds();

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));
app.use(async (req, res, next) => {
    try {
        await rdsPool.query(`
            CREATE TABLE IF NOT EXISTS visits
            (
                id
                INT
                AUTO_INCREMENT
                PRIMARY
                KEY,
                ts
                TIMESTAMP
                DEFAULT
                CURRENT_TIMESTAMP
            )
        `);

        await rdsPool.query("INSERT INTO visits () VALUES ()");
    } catch (err) {
        console.error("RDS error (middleware):", err);
    }
    next();
});

app.post("/visit", async (req, res) => {
    try {
        const [rows] = await rdsPool.query("SELECT COUNT(*) AS total FROM visits");
        res.json({total: rows[0].total});
    } catch (err) {
        console.error("RDS error:", err);
        res.status(500).json({error: "Błąd bazy danych"});
    }
});

// --- DynamoDB endpoint ---
app.post("/shorten", async (req, res) => {
    const {url} = req.body;
    if (!url) return res.status(400).json({error: "URL is required"});

    const id = crypto.randomBytes(2).toString("hex");

    try {
        await dynamo.send(new PutCommand({
            TableName: TABLE_NAME,
            Item: {short_id: id, url}
        }));
        res.json({shortUrl: `http://${EC2_HOST}/${id}`});
    } catch (err) {
        console.error("DynamoDB error:", err);
        res.status(500).json({error: "Failed to save URL"});
    }
});

app.get("/:id", async (req, res) => {
    try {
        const result = await dynamo.send(new GetCommand({
            TableName: TABLE_NAME,
            Key: {short_id: req.params.id}
        }));
        if (!result.Item) return res.status(404).send("Not found");
        res.redirect(result.Item.url);
    } catch (err) {
        console.error("DynamoDB error:", err);
        res.status(500).send("Internal Server Error");
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});

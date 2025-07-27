import express from "express";
import crypto from "crypto";
import path from "path";
import {fileURLToPath} from "url";
import {DynamoDBClient} from "@aws-sdk/client-dynamodb";
import {DynamoDBDocumentClient, GetCommand, PutCommand} from "@aws-sdk/lib-dynamodb";

const app = express();
const port = 3000;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const EC2_HOST = process.env.EC2_HOST || "localhost";

const dynamo = DynamoDBDocumentClient.from(new DynamoDBClient({region: "eu-north-1"}));
const TABLE_NAME = "urls";

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

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
    console.log(`URL shortener running on port ${port}`);
});

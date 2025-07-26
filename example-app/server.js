import express from "express";
import crypto from "crypto";
import path from "path";
import { fileURLToPath } from "url";

const app = express();
const port = 3000;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const urls = {};
const EC2_HOST = process.env.EC2_HOST || 'localhost';

app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

app.post("/shorten", (req, res) => {
  const { url } = req.body;
  if (!url) return res.status(400).json({ error: "URL is required" });

  const id = crypto.randomBytes(2).toString("hex");
  urls[id] = url;

  res.json({ shortUrl: `http://${EC2_HOST}/${id}` });
});

app.get("/:id", (req, res) => {
  const url = urls[req.params.id];
  if (!url) return res.status(404).send("Not found");
  res.redirect(url);
});

app.listen(port, () => {
  console.log(`URL shortener running on port ${port}`);
});

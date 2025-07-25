import express from "express";
import crypto from "crypto";

const app = express();
const port = 3000;

const urls = {};

app.use(express.json());

const EC2_HOST = process.env.EC2_HOST || 'localhost';

app.post("/shorten", (req, res) => {
  const { url } = req.body;
  if (!url) return res.status(400).json({ error: "URL is required" });

  const id = crypto.randomBytes(4).toString("hex");
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


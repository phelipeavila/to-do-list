require('dotenv').config();
const express = require("express");
const cors = require("cors");
const toDoRoutes = require("./routes");

const app = express();
const port = process.env.PORT || 3000; // Set a default value for the port

app.use(express.json());
app.use(cors());
app.use(toDoRoutes);

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err);
  return res.status(500).json({ error: "Server error" });
});

app.get("/status", (req, res) => {
  return res.json("OK");
});

app.listen(port, () => console.log("Server is running on port " + port));

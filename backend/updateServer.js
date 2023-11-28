const port = process.env.PORT || 4001;
const express = require("express");
const app = express();
const router = express.Router();
const schedule = require("node-schedule");
const https = require("http");

app.use("/", router);

app.listen(port, async () => {
  console.log(`Server is running on port ${port}`);
  //await scrapeData();
});

https.get("http://localhost:4000/api/updateData", (res) => {});

//schedule.scheduleJob("0 8 * * *", function () {
//  https.get("https://vse-menu-apii.onrender.com/api/updateData", (res) => {});
//});
//
//schedule.scheduleJob("00 22 * * *", function () {
//  https.get("https://vse-menu-apii.onrender.com/api/updateData", (res) => {});
//});

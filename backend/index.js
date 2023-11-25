const express = require("express");
const app = express();
const port = process.env.PORT || 4000;
const router = express.Router();
const schedule = require("node-schedule");

const { scrapeVolhaMenu } = require("./VolhaMenu.js");
const { scrapeVSEMenu } = require("./VSEMenu.js");

router.get("/", (req, res) => {
  res.send("Hello, World!");
});

let scrapedData;

const scrapeData = async () => {
  try {
    scrapedData = {
      volha: await scrapeVolhaMenu(),
      jizniMesto: await scrapeVSEMenu(
        "#avgastro-jm-week",
        "https://www.vse.cz/menza/stravovani-jizni-mesto/"
      ),
      zizkov: await scrapeVSEMenu(
        "#avgastro-zizkov-week",
        "https://www.vse.cz/menza/stravovani-zizkov/"
      ),
    };
  } catch (error) {
    console.error("Error scheduling daily task:", error);
  }
  return scrapedData;
};

schedule.scheduleJob("0 22 * * *", async function () {
  await scrapeData();
});

schedule.scheduleJob("0 9 * * *", async function () {
  await scrapeData();
});

router.get("/api/scrapedData", async (req, res) => {
  res.json(scrapedData);
});

app.use("/", router);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
  scrapeData();
});

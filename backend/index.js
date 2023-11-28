const express = require("express");
const app = express();
const port = process.env.PORT || 4000;
const router = express.Router();
const fs = require("fs");

const { scrapeVolhaMenu } = require("./VolhaMenu.js");
const { scrapeVSEMenu } = require("./VSEMenu.js");

const filePath = "data.json";

router.get("/", (req, res) => {});

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
    console.error("Error", error);
  }
  return scrapedData;
};

router.get("/api/updateData", async (req, res) => {
  await scrapeData();
  fs.writeFile(filePath, JSON.stringify(scrapedData), (err) => {
    if (err) throw err;
  });
});

router.get("/api/scrapedData", async (req, res) => {
  //let scrapedData = {
  //  volha: await scrapeVolhaMenu(),
  //  jizniMesto: await scrapeVSEMenu(
  //    "#avgastro-jm-week",
  //    "https://www.vse.cz/menza/stravovani-jizni-mesto/"
  //  ),
  //  zizkov: await scrapeVSEMenu(
  //    "#avgastro-zizkov-week",
  //    "https://www.vse.cz/menza/stravovani-zizkov/"
  //  ),
  //};
  const data = JSON.parse(fs.readFileSync(filePath, "utf-8"));

  res.json(data);
});

app.use("/", router);

app.listen(port, async () => {
  console.log(`Server is running on port ${port}`);
  //await scrapeData();
});

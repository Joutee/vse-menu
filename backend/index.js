const express = require("express");
const app = express();
const port = process.env.PORT || 4000;
const router = express.Router();

const { scrapeVolhaMenu } = require("./VolhaMenu.js");
const { scrapeVSEMenu } = require("./VSEMenu.js");

router.get("/", (req, res) => {
  res.send("Hello, World!");
});

router.get("/api/scrapedData", async (req, res) => {
  //console.log(scrapeVolhaMenu());
  let scrapedData = {
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
  res.json(scrapedData);
});

app.use("/", router);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

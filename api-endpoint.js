const express = require("express");
const app = express();
const port = 3050;
const router = express.Router();

const { scrapeVolhaMenu } = require("./VolhaMenu.js");
const { scrapeVSEMenu } = require("./VSEMenu.js");

router.get("/", (req, res) => {
  res.send("Hello, World!");
});

router.get("/api/scrapedData", async (req, res) => {
  //console.log(scrapeVolhaMenu());
  const scrapedData = await scrapeVolhaMenu();
  res.json(scrapedData);
});

app.use("/", router);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

const puppeteer = require("puppeteer");
require("dotenv").config();

const scrapeVolhaMenu = async () => {
  const browser = await puppeteer.launch({
    args: [
      "--disable-setuid-sandbox",
      "--no-sandbox",
      "--single-process",
      "--no-zygote",
    ],
    executablePath:
      process.env.NODE_ENV === "production"
        ? process.env.PUPPETEER_EXECUTABLE_PATH
        : puppeteer.executablePath(),
  });
  const volhaPage = await browser.newPage();

  // Navigate to the web page
  await volhaPage.goto(
    "https://www.vscht-suz.cz/stravovani/jidelni-listek-menzy-volha/"
  );

  const volhaMenu = await volhaPage.evaluate(() => {
    const sanitizeString = (str) => {
      return str.trim().replace(/\s+/g, " ");
    };
    const meals = document.querySelectorAll(
      "body > section > div > table > tbody > tr > td"
    );
    const days = document.querySelectorAll(
      "body > section > div > table > tbody > tr > th"
    );

    const daysArr = Array.from(days).map((element) =>
      sanitizeString(element.textContent)
    );

    const menuList = Array.from(meals).map((element, index) => {
      const delimiter = /[0-9A-Z]\./;
      const str = sanitizeString(element.textContent);
      const arr = str.split(delimiter);
      arr.shift();
      const obj = {
        day: daysArr[index],
        meals: arr,
      };
      return obj;
    });
    return menuList;
  });
  await browser.close();
  return volhaMenu;
};

module.exports = { scrapeVolhaMenu };

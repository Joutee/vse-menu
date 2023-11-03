const puppeteer = require("puppeteer");

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  // Navigate to the web page
  await page.goto(
    "https://www.vscht-suz.cz/stravovani/jidelni-listek-menzy-volha/"
  );

  // Extract text from elements by using selectors
  const elementText = await page.evaluate(() => {
    const elements = document.querySelectorAll(
      "body > section > div > table > tbody"
    );
    const textArray = Array.from(elements).map(
      (element) => element.textContent
    );
    return textArray;
  });

  console.log(typeof elementText[0]);

  function sanitizeString(str) {
    return str.trim().replace(/\s+/g, " ");
  }
  console.log(sanitizeString(elementText[1]));

  await browser.close();
})();

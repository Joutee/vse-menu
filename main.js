const puppeteer = require("puppeteer");

(async () => {
  const browser = await puppeteer.launch();
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

  // console.log(sanitizeString(menuList[0]));
  //console.log(volhaMenu);

  const JMPage = await browser.newPage();
  await JMPage.goto("https://www.vse.cz/menza/stravovani-jizni-mesto/");

  const JMMenu = await JMPage.evaluate(() => {
    const sanitizeString = (str) => {
      return str.trim().replace(/\s+/g, " ");
    };
    const meals = document.querySelectorAll(
      "#avgastro-jm-week > div > table > tbody"
    );
    const days = document.querySelectorAll(
      "    #avgastro-jm-week > div > table > thead > tr > th"
    );
    const daysArr = Array.from(days).map((element) => element.textContent);
    //const days = document.querySelectorAll(
    //  "body > section > div > table > tbody > tr > th"
    //);

    //const daysArr = Array.from(days).map((element) =>
    //  sanitizeString(element.textContent)
    //);
    function collectDivDescendants(element, divElements) {
      if (element.tagName === "DIV") {
        divElements.push(element);
      }

      const childElements = element.children;

      for (const childElement of childElements) {
        collectDivDescendants(childElement, divElements);
      }
    }
    const menuList = Array.from(meals).map((element, index) => {
      const mealList = [];
      collectDivDescendants(element, mealList);

      const arr = Array.from(mealList).map((element) => element.textContent);

      const obj = {
        day: daysArr[index],
        meals: arr,
      };

      return obj;
    });
    return menuList;
  });
  console.log(JMMenu);
  await browser.close();
})();

const puppeteer = require("puppeteer");

const scrapeVSEMenu = async (page, url) => {
  const browser = await puppeteer.launch();
  const VSEPage = await browser.newPage();
  await VSEPage.goto(url);

  const readVSEPage = (page) => {
    const meals = document.querySelectorAll(`${page} > div > table > tbody`);
    const days = document.querySelectorAll(
      `${page} > div > table > thead > tr > th`
    );
    const daysArr = Array.from(days).map((element) => element.textContent);

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
  };

  const VSEMenu = await VSEPage.evaluate(readVSEPage, page); //avgastro-jm-week     #avgastro-zizkov-week

  await browser.close();
  return VSEMenu;
};
module.exports = { scrapeVSEMenu };

import { writeFile } from "node:fs/promises";
import { pathToFileURL } from "node:url";
import { chromium } from "/Users/tutuge/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright/index.mjs";

const root = new URL("./", import.meta.url);
const chromeExecutable = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome";

const pages = [
  {
    html: "promo_poster.html",
    output: "promo_poster.png",
    viewport: { width: 1920, height: 1080 },
  },
  {
    html: "quick_start_01_create.html",
    output: "quick_start_01_create.png",
    viewport: { width: 1440, height: 900 },
  },
  {
    html: "quick_start_02_style.html",
    output: "quick_start_02_style.png",
    viewport: { width: 1440, height: 900 },
  },
  {
    html: "quick_start_03_selection.html",
    output: "quick_start_03_selection.png",
    viewport: { width: 1440, height: 900 },
  },
  {
    html: "quick_start_04_layout.html",
    output: "quick_start_04_layout.png",
    viewport: { width: 1440, height: 900 },
  },
  {
    html: "concepts_poster.html",
    output: "concepts_poster.png",
    viewport: { width: 1920, height: 1080 },
  },
];

const browser = await chromium.launch({
  headless: true,
  executablePath: chromeExecutable,
});
try {
  for (const item of pages) {
    const page = await browser.newPage({
      viewport: item.viewport,
      deviceScaleFactor: 2,
    });

    const htmlPath = new URL(item.html, root);
    await page.goto(pathToFileURL(htmlPath.pathname).toString(), { waitUntil: "load" });
    await page.evaluate(() => document.fonts.ready);

    const bodyBox = await page.locator("body").boundingBox();
    if (!bodyBox || bodyBox.width === 0 || bodyBox.height === 0) {
      throw new Error(`${item.html} rendered an empty body`);
    }

    const screenshot = await page.screenshot({
      fullPage: false,
      type: "png",
      animations: "disabled",
    });

    const outputPath = new URL(item.output, root);
    await writeFile(outputPath, screenshot);
    await page.close();
    console.log(`${item.output}: ${screenshot.length} bytes`);
  }
} finally {
  await browser.close();
}

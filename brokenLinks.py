from playwright.sync_api import sync_playwright
import requests
from concurrent.futures import ThreadPoolExecutor, as_completed
import time
import os
import sys


def get_links(page):
    return set(page.eval_on_selector_all(
        "a[href]",
        """elements => elements
            .map(el => el.href.trim())
            .filter(href => href.startsWith('http'))"""
    ))


def check_link(link):
    try:
        response = requests.get(link, timeout=15, allow_redirects=True)
        if response.status_code >= 400:
            return (link, response.status_code)
    except requests.RequestException as e:
        return (link, str(e))
    return None


def check_broken_links_concurrently(links, max_workers=os.cpu_count()):
    broken = []
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = [executor.submit(check_link, link) for link in links]
        for future in as_completed(futures):
            result = future.result()
            if result:
                broken.append(result)
    return broken


def main():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        url = sys.argv[1] if len(sys.argv) > 1 else f"https://www.amazon.com/"
        page.goto(str(url))

        print("Extracting unique HTTP links...")
        valid_links = get_links(page)
        print(f"Found {len(valid_links)} unique links.")

        print("Checking for broken links...")
        broken_links = check_broken_links_concurrently(valid_links)

        if broken_links:
            print("\nBroken Links Found:")
            for link, status in broken_links:
                print(f"{link} -> Status: {status}")
        else:
            print("\nAll links are valid")

        page.close()

        browser.close()

if __name__ == "__main__":
    stTime = time.time()
    main()
    endTime = time.time()
    print(f"Total execution time: {(endTime-stTime):.2f} seconds")
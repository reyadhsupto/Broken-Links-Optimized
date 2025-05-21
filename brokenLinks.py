from playwright.sync_api import sync_playwright
import requests
from concurrent.futures import ThreadPoolExecutor, as_completed
import time
import os
import sys
import pandas as pd


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
        return (link, 200)
    except requests.RequestException as e:
        return (link, str(e))


def check_links_concurrently(links, max_workers=os.cpu_count()):
    results = []
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = [executor.submit(check_link, link) for link in links]
        for future in as_completed(futures):
            results.append(future.result())
    return results


def main():
    url = sys.argv[1] if len(sys.argv) > 1 else "https://www.amazon.com/"
    all_results = []

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()
        page.goto(str(url))

        print("Extracting unique HTTP links...")
        links = get_links(page)
        print(f"Found {len(links)} unique links.")

        print("Checking links...")
        results = check_links_concurrently(links)

        broken_links = [r for r in results if r[1] != 200]
        valid_links = [r for r in results if r[1] == 200]

        if broken_links:
            print("\nBroken Links Found:")
            for link, status in broken_links:
                print(f"{link} -> Status: {status}")
        else:
            print("\nAll links are valid")

        for link, status in results:
            all_results.append({
                "Base URL": url,
                "URL": link,
                "Status Code": status,
                "Status": "Valid" if status == 200 else "Broken"
            })

        df = pd.DataFrame(all_results)
        df.to_csv("link_results.csv", index=False)
        print("\n Results saved to link_results.csv")

        page.close()
        browser.close()


if __name__ == "__main__":
    start_time = time.time()
    main()
    end_time = time.time()
    print(f"Total execution time: {end_time - start_time:.2f} seconds")
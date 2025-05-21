# 🔗 Playwright Broken Link Checker

A fast, concurrent, headless browser-based tool to extract and validate all HTTP/HTTPS links from a webpage using [Playwright](https://playwright.dev/) and Python.

---

## 🚀 Features

- Launches Chromium headlessly via Playwright
- Extracts all visible `http`/`https` links from the page
- Uses a `set()` to automatically remove duplicate links
- Checks links in parallel using `ThreadPoolExecutor`
- Identifies broken URLs with HTTP errors or connection issues
- Tracks total execution time

---

## 📦 Requirements

- Python 3.7+
- [Playwright for Python](https://playwright.dev/python/)
- `requests`

Install dependencies:

```bash
pip install -r requirements.txt
playwright install
```
---

## 🧪 How to Use

### 1. Clone the repository

```bash
git clone https://github.com/your-username/your-repo.git
cd your-repo
```
### 2. Create a virtual environment(Optional)
```bash
python3 -m venv venv
source venv/bin/activate  # For macOS/Linux
```
# OR, for Windows:
venv\Scripts\activate

### 3. Install dependencies
```bash
pip install -r requirements.txt
playwright install
```
### 4. Replace target URL (if needed)
`page.goto("https://example.com")`

### 5. Run the Script
```bash
python broken_links.py
```

---

## ⚙️ Configuration

### 1. To adjust concurrency level
 ```python
check_broken_links_concurrently(links, max_workers=50)
```
### 2. To use a different browser engine

```python
p.firefox.launch(...)
p.webkit.launch(...)
```

---

## 🧾 Sample Output
```
Found 137 unique links.
Broken Links Found:
https://example.com/broken -> Status: 404
https://badhost.org -> Status: HTTPSConnectionError
Execution time: 4.23 seconds
```

## 📁 Project Structure
```
.
├── broken_links.py          # Main script
├── requirements.txt
├── README.md
└── .gitignore
```

---

## 💡 Design Note

The tool uses a `set()` during link extraction to ensure all links are **unique** before being validated.  
This avoids duplicate HTTP requests, reduces runtime, and improves performance — especially on pages with repeated navigation elements or footers.

---

## 📋 To-Do

- [ ] Add CLI support via `argparse`
- [ ] Enable multi-page crawling through sitemap parsing
- [ ] Export broken link results to CSV/JSON
- [ ] Implement retry logic for intermittent connection failures
- [ ] Add unit tests for link-checking logic
- [ ] Dockerise the project for easier deployment

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

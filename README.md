# 🔗 Playwright Broken Link Checker

A fast, concurrent, headless browser-based tool to extract and validate all HTTP/HTTPS links from a webpage using [Playwright](https://playwright.dev/) and Python.

---

## 🚀 Features

- Headless browser-based link extraction (via Playwright)
- Extracts all visible `http`/`https` links from the page
- Uses a `set()` to automatically remove duplicate links
- Checks links in parallel using `ThreadPoolExecutor`
- Identifies broken URLs with HTTP errors or connection issues
- Tracks total execution time
- Dockerised for portability
- Makefile for clean automation

---

## 📦 Requirements

- Python 3.7+
- [Playwright for Python](https://playwright.dev/python/)
- Docker (for containerised use)

Install dependencies:

```bash
pip install -r requirements.txt
playwright install
```
---

## 🧪 How to Use

You can run the broken link checker either **locally** using a Python virtual environment or **inside a Docker container**.

---

### 🔹 Option 1: Local (using `venv`)

Set up and run locally:

```bash
make all
```

### This will:
- Pull the latest code from your current Git branch
- Create or reuse a Python virtual environment (venv)
- Install all dependencies from requirements.txt
- Install Playwright and its browser binaries
- Run the script locally

### To run the script again without rebuilding everything:

```bash
make local
```

### 🔹 To Explicitly specify URL

```bash
make all URL=<your url>
```

### 🔹 Option 2: Manually

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
├── brokenLinks.py
├── requirements.txt
├── Dockerfile
├── Makefile
└── venv/ (auto-created by Makefile)
```
---

## 💡 Design Note

The tool uses a `set()` during link extraction to ensure all links are **unique** before being validated.  
This avoids duplicate HTTP requests, reduces runtime, and improves performance — especially on pages with repeated navigation elements or footers.

---

## 📋 To-Do

- [ ] Enable multi-page crawling through sitemap parsing
- [ ] Export broken link results to CSV/JSON
- [ ] Implement retry logic for intermittent connection failures
- [ ] Add unit tests for link-checking logic

---

## 📄 License

This project is licensed under the **GNU General Public License v3.0**.  
See the [LICENSE](LICENSE) file for full license text.

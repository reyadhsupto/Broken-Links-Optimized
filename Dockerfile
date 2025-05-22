FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser


RUN apt-get update && apt-get install -y \
    wget gnupg curl unzip fonts-liberation libnss3 libatk1.0-0 \
    libatk-bridge2.0-0 libcups2 libdrm2 libxcomposite1 libxrandr2 \
    libgbm1 libgtk-3-0 libxdamage1 libxfixes3 libx11-xcb1 libxss1 \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt
RUN playwright install --with-deps

COPY . .
RUN chown -R appuser:appgroup /app

USER appuser

CMD ["python", "brokenLinks.py"]
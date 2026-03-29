# Use slim image to reduce attack surface
FROM python:3.11-slim

# Don't run as root
RUN useradd --create-home --shell /bin/bash appuser

WORKDIR /app

# Copy and install dependencies first (layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY main.py .

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8000

# Run the app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
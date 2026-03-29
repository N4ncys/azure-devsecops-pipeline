from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="DevSecOps Demo API",
    description="A demo API for security scanning in a CI/CD pipeline",
    version="1.0.0"
)

# Intentionally overly permissive CORS — ZAP will flag this
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.get("/")
def root():
    return {"message": "DevSecOps Demo API", "version": "1.0.0"}

@app.get("/items/{item_id}")
def get_item(item_id: int):
    if item_id <= 0:
        raise HTTPException(status_code=400, detail="Item ID must be positive")
    return {"item_id": item_id, "name": f"Item {item_id}"}
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.exceptions import RequestValidationError, HTTPException
from fastapi.responses import JSONResponse
from app.database.db import create_db_and_tables
# from fastapi.openapi.utils import get_openapi

from app.routes import estoque, user

origins = ['*']

app = FastAPI()

app.add_middleware(
  CORSMiddleware,
  allow_origins=origins,
  allow_credentials=True,
  allow_methods=['*'],
  allow_headers=['*'],
)


@app.on_event("startup")
def on_startup():
    create_db_and_tables()


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(
        request, exc):
    # return PlainTextResponse(str(exc), status_code=400)
    return JSONResponse(
        status_code=400,
        content={"message": str(exc)}
    )


@app.exception_handler(HTTPException)
async def http_exception_handler(request, exc: HTTPException):
    return JSONResponse(
        status_code=404,
        content={"message": str(exc.detail)}
    )


app.include_router(estoque.router)
app.include_router(user.router)


@app.get('/')
async def hello_world():
    return {"details": "Hello World"}

from sqlmodel import create_engine, Session, SQLModel
from sqlalchemy.engine import URL
from dotenv import dotenv_values

config = dotenv_values()

url = URL.create(
    drivername=config['DRIVER_NAME'],
    username=config['USER_NAME'],
    host=config['HOST_NAME'],
    password=config['USER_PASSWORD'],
    database=config['DATABASE_NAME']
)

engine = create_engine(url)

# sqlite_file_name = "estoque.sqlite3"
# sqlite_url = f"sqlite:///{sqlite_file_name}"

# connect_args = {"check_same_thread": False}

# engine = create_engine(sqlite_url, echo=True, connect_args=connect_args)


def get_session():
    with Session(engine) as session:
        yield session


def create_db_and_tables():

    from app.models import estoque, user  # noqa: F401

    SQLModel.metadata.create_all(engine)

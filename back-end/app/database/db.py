from sqlmodel import create_engine, Session


sqlite_file_name = "estoque.sqlite3"
sqlite_url = f"sqlite:///{sqlite_file_name}"

connect_args = {"check_same_thread": False}

engine = create_engine(sqlite_url, echo=True, connect_args=connect_args)


def get_session():
    with Session(engine) as session:
        yield session


# def create_db_and_tables():

#     from app.models import account, transaction  # noqa: F401

#     SQLModel.metadata.create_all(engine)

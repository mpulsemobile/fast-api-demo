from sqlalchemy import Boolean, Column, ForeignKey, Integer, String

from . import Base


class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=True, index=True)

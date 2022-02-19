from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


def test_success_create():
    response = client.post("/users", json={"name": "John"})
    assert response.status_code == 200
    assert response.json() == {"name": "John"}


def test_failed_create():
    response = client.post("/users", json={"name": "richie"})
    assert response.status_code == 422
    assert response.json() == {
        "detail": [
            {
                "loc": ["body", "name"],
                "msg": "Cannot be named Richie",
                "type": "value_error",
            }
        ]
    }

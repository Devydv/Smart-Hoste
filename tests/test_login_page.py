from app import app


def test_login_page_loads() -> None:
    client = app.test_client()
    response = client.get("/")

    assert response.status_code == 200
    assert b"SmartHostel" in response.data

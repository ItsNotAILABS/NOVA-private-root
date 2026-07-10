import json
import pathlib
import tempfile

from capsule.polyglot.session_server import compile_and_run, language_for_filename, load_registry


def test_language_registry_loads():
    registry = load_registry()
    ids = {lang["id"] for lang in registry["languages"]}
    assert {"python", "matlab", "java", "cpp", "c", "javascript", "typescript", "html", "rust", "go", "shell"}.issubset(ids)


def test_language_detection():
    assert language_for_filename("main.py")["id"] == "python"
    assert language_for_filename("index.html")["id"] == "html"
    assert language_for_filename("main.cpp")["id"] == "cpp"


def test_html_preview_receipt():
    with tempfile.TemporaryDirectory() as tmp:
        workspace = pathlib.Path(tmp)
        (workspace / "index.html").write_text("<h1>NOVA</h1>", encoding="utf-8")
        result = compile_and_run("index.html", str(workspace), timeout=5)
        assert result["ok"] is True
        assert result["action"] == "preview"
        assert result["preview_url"] == "/preview/index.html"
        receipts = list((workspace / ".nova" / "receipts").glob("*.json"))
        assert receipts
        packet = json.loads(receipts[0].read_text(encoding="utf-8"))
        assert packet["ok"] is True


def test_missing_file_denied_with_receipt():
    with tempfile.TemporaryDirectory() as tmp:
        result = compile_and_run("missing.py", tmp, timeout=5)
        assert result["ok"] is False
        assert result["message"] == "file not found"
        assert list((pathlib.Path(tmp) / ".nova" / "receipts").glob("*.json"))

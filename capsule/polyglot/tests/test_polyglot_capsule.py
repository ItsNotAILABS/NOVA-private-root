import json
import pathlib
import tempfile

from capsule.polyglot.scaler import build_deploy_packet, build_hash_manifest, create_session, init_project, list_sessions
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


def test_scaled_session_and_templates():
    with tempfile.TemporaryDirectory() as tmp:
        session = create_session("Client Playground", tmp)
        assert session["status"] == "active"
        assert "client-playground" in session["workspace"]
        assert list_sessions(tmp)[0]["session_id"] == session["session_id"]
        project = init_project(session["workspace"], "web")
        assert project["ok"] is True
        assert "index.html" in project["files"]
        assert pathlib.Path(session["workspace"], "index.html").exists()


def test_hash_manifest_and_deploy_packet():
    with tempfile.TemporaryDirectory() as tmp:
        workspace = pathlib.Path(tmp)
        (workspace / "hello.py").write_text("print('hi')\n", encoding="utf-8")
        manifest = build_hash_manifest(str(workspace))
        assert manifest["file_count"] >= 1
        assert manifest["files"][0]["sha256"]
        packet = build_deploy_packet(str(workspace), "github-handoff")
        assert packet["status"] == "ready-for-handoff"
        assert packet["target"] == "github-handoff"
        assert (workspace / ".nova" / "deploy-packet.json").exists()

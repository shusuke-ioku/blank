from __future__ import annotations

from blank_cli import texst


def test_resolve_uses_latest_release(monkeypatch) -> None:
    texst.resolve_latest_texst_version.cache_clear()
    monkeypatch.delenv("BLANK_TEXST_VERSION", raising=False)
    monkeypatch.setattr(texst, "_fetch_version_from_latest_release", lambda timeout: "1.2.3")
    monkeypatch.setattr(texst, "_fetch_version_from_tags", lambda timeout: "1.2.2")

    assert texst.resolve_latest_texst_version() == "1.2.3"


def test_resolve_respects_env_override(monkeypatch) -> None:
    texst.resolve_latest_texst_version.cache_clear()
    monkeypatch.setenv("BLANK_TEXST_VERSION", "9.8.7")
    monkeypatch.setattr(texst, "_fetch_version_from_latest_release", lambda timeout: "1.2.3")

    assert texst.resolve_latest_texst_version() == "9.8.7"


def test_resolve_falls_back_when_unavailable(monkeypatch) -> None:
    texst.resolve_latest_texst_version.cache_clear()
    monkeypatch.delenv("BLANK_TEXST_VERSION", raising=False)

    def _raise(timeout: float) -> str:
        raise OSError("offline")

    monkeypatch.setattr(texst, "_fetch_version_from_latest_release", _raise)
    monkeypatch.setattr(texst, "_fetch_version_from_tags", _raise)

    assert texst.resolve_latest_texst_version() == texst.DEFAULT_TEXST_VERSION

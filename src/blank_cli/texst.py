from __future__ import annotations

import json
import os
import re
from functools import lru_cache
from typing import Any, Optional, Tuple
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

DEFAULT_TEXST_VERSION = "0.1.0"
TEXST_LATEST_RELEASE_URL = "https://api.github.com/repos/shusuke-ioku/texst/releases/latest"
TEXST_TAGS_URL = "https://api.github.com/repos/shusuke-ioku/texst/tags?per_page=100"

_SEMVER_PATTERN = re.compile(r"^v?(\d+)\.(\d+)\.(\d+)$")
_GITHUB_HEADERS = {
    "Accept": "application/vnd.github+json",
    "User-Agent": "blank-agentic-cli",
}


def _normalize_semver(raw_version: Any) -> Optional[str]:
    if not isinstance(raw_version, str):
        return None
    match = _SEMVER_PATTERN.fullmatch(raw_version.strip())
    if match is None:
        return None
    major, minor, patch = (int(part) for part in match.groups())
    return f"{major}.{minor}.{patch}"


def _semver_key(version: str) -> Tuple[int, int, int]:
    major, minor, patch = version.split(".")
    return int(major), int(minor), int(patch)


def _fetch_json(url: str, timeout: float) -> Any:
    request = Request(url, headers=_GITHUB_HEADERS)
    with urlopen(request, timeout=timeout) as response:
        charset = response.headers.get_content_charset() or "utf-8"
        payload = response.read().decode(charset)
    return json.loads(payload)


def _fetch_version_from_latest_release(timeout: float) -> Optional[str]:
    payload = _fetch_json(TEXST_LATEST_RELEASE_URL, timeout=timeout)
    if not isinstance(payload, dict):
        return None
    return _normalize_semver(payload.get("tag_name"))


def _fetch_version_from_tags(timeout: float) -> Optional[str]:
    payload = _fetch_json(TEXST_TAGS_URL, timeout=timeout)
    if not isinstance(payload, list):
        return None

    versions = []
    for item in payload:
        if not isinstance(item, dict):
            continue
        version = _normalize_semver(item.get("name"))
        if version is not None:
            versions.append(version)

    if not versions:
        return None
    return max(versions, key=_semver_key)


@lru_cache(maxsize=1)
def resolve_latest_texst_version(timeout: float = 2.5) -> str:
    pinned = _normalize_semver(os.getenv("BLANK_TEXST_VERSION", ""))
    if pinned is not None:
        return pinned

    fetchers = (_fetch_version_from_latest_release, _fetch_version_from_tags)
    for fetch_version in fetchers:
        try:
            version = fetch_version(timeout=timeout)
        except (HTTPError, URLError, OSError, ValueError, json.JSONDecodeError):
            continue
        if version is not None:
            return version

    return DEFAULT_TEXST_VERSION

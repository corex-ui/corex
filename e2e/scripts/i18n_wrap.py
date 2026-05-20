#!/usr/bin/env python3
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / "lib"

GETTEXT_RE = re.compile(r'gettext\(\s*"((?:\\.|[^"\\])*)"\s*\)')
GETTEXT_RE_MULTILINE = re.compile(
    r'gettext\(\s*\n\s*"((?:\\.|[^"\\])*)"\s*\n\s*\)',
    re.MULTILINE,
)

TITLE_RE = re.compile(r'\b(title|subtitle|aria_label|aria-label|placeholder)=\s*"([^"]*)"')
LABEL_SLOT_RE = re.compile(r'<:label[^>]*>([^<{]+)</:label>')


def replace_gettext(content: str) -> str:
    content = GETTEXT_RE_MULTILINE.sub(r'~t"\1"', content)
    content = GETTEXT_RE.sub(r'~t"\1"', content)
    return content


def wrap_heex_attrs(content: str) -> str:
    def repl(m):
        attr, value = m.group(1), m.group(2)
        if value.startswith("{") or "~t" in value:
            return m.group(0)
        attr_name = "aria_label" if attr == "aria-label" else attr
        return f'{attr_name}={{~t"{value}"}}'

    return TITLE_RE.sub(repl, content)


def wrap_elixir_title_assigns(content: str) -> str:
    for field in ("title", "subtitle", "page_title", "label"):
        pattern = re.compile(
            rf'(\b{field}:\s*)"((?:\\.|[^"\\])*)"',
        )

        def repl(m, f=field):
            if m.group(2).startswith("{") or "~t" in m.group(2):
                return m.group(0)
            return f'{f}: ~t"{m.group(2)}"'

        content = pattern.sub(repl, content)
    return content


def process_file(path: Path) -> bool:
    original = path.read_text(encoding="utf-8")
    updated = original
    updated = replace_gettext(updated)
    if path.suffix == ".heex":
        updated = wrap_heex_attrs(updated)
    elif path.suffix == ".ex":
        updated = wrap_elixir_title_assigns(updated)
        if "/live/" in str(path) or "page_html" in str(path):
            updated = wrap_heex_attrs(updated)
    if updated != original:
        path.write_text(updated, encoding="utf-8")
        return True
    return False


def main():
    changed = 0
    for pattern in ("**/*.heex", "**/*.ex"):
        for path in LIB.glob(pattern):
            if "gettext.ex" in str(path):
                continue
            if process_file(path):
                changed += 1
                print(path.relative_to(ROOT))
    print(f"Updated {changed} files", file=sys.stderr)


if __name__ == "__main__":
    main()

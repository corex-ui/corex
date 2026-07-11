#!/usr/bin/env python3
import re
import sys
from pathlib import Path

ROLES = ("accent", "brand", "alert", "info", "success")
SIZES = ("sm", "md", "lg", "xl")


def migrate_classes(value: str) -> str:
    text = value
    for role in ROLES:
        text = re.sub(rf"\b[\w-]+--{role}\b", f"ui-{role}", text)
    text = re.sub(r"\b[\w-]+--variant-solid\b", "ui-solid", text)
    for variant in ("subtle", "ghost", "outline"):
        text = re.sub(rf"\s*[\w-]+--variant-{variant}\b", "", text)
    for size in SIZES:
        text = re.sub(rf"\b[\w-]+--{size}\b", f"ui-size-{size}", text)
    text = re.sub(r"\b[\w-]+--rounded-([\w-]+)\b", r"ui-rounded-\1", text)
    text = re.sub(r"\bbutton--square\b", "ui-trigger--square", text)
    text = re.sub(r"\bbutton--circle\b", "ui-trigger--circle", text)
    parts = [p for p in text.split() if p]
    seen = []
    for part in parts:
        if part not in seen:
            seen.append(part)
    return " ".join(seen)


def migrate_line(line: str) -> str:
    def repl_class(m: re.Match) -> str:
        return f'class="{migrate_classes(m.group(1))}"'

    line = re.sub(r'class="([^"]*)"', repl_class, line)
    line = re.sub(r"class='([^']*)'", lambda m: f"class='{migrate_classes(m.group(1))}'", line)
    line = re.sub(
        r'(class:\s*")([^"]*)(")',
        lambda m: f'{m.group(1)}{migrate_classes(m.group(2))}{m.group(3)}',
        line,
    )
    line = re.sub(
        r'(modifier:\s*")([^"]*)(")',
        lambda m: f'{m.group(1)}{migrate_classes(m.group(2))}{m.group(3)}',
        line,
    )

    def repl_backtick(m: re.Match) -> str:
        inner = m.group(1)
        if "--" in inner and any(
            x in inner
            for x in (
                "button",
                "accordion",
                "select",
                "checkbox",
                "toggle",
                "switch",
                "link",
                "dialog",
                "tabs",
                "collapsible",
                "native-input",
                "data-table",
                "floating-panel",
            )
        ):
            return f"`{migrate_classes(inner)}`"
        return m.group(0)

    line = re.sub(r"`([^`]+)`", repl_backtick, line)

    def repl_code_tag(m: re.Match) -> str:
        return f'<code class="text-sm">{migrate_classes(m.group(1))}</code>'

    line = re.sub(r'<code class="text-sm">([^<]+)</code>', repl_code_tag, line)
    return line


def migrate_file(path: Path) -> bool:
    original = path.read_text()
    updated = "\n".join(migrate_line(line) for line in original.splitlines())
    if original.endswith("\n") and not updated.endswith("\n"):
        updated += "\n"
    if updated != original:
        path.write_text(updated)
        return True
    return False


def main() -> int:
    roots = [Path(p) for p in sys.argv[1:]]
    exts = {".ex", ".exs", ".heex", ".md"}
    changed = 0
    for root in roots:
        for path in root.rglob("*"):
            if path.suffix in exts and path.is_file():
                if migrate_file(path):
                    changed += 1
    print(changed)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

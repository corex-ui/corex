#!/usr/bin/env python3
import re
import sys
from pathlib import Path

REPLACEMENTS = (
    ("ui-trigger--sm", "ui-size-sm"),
    ("ui-trigger--md", "ui-size-md"),
    ("ui-trigger--lg", "ui-size-lg"),
    ("ui-trigger--xl", "ui-size-xl"),
    ("ui-trigger--accent", "ui-accent"),
    ("ui-trigger--brand", "ui-brand"),
    ("ui-trigger--alert", "ui-alert"),
    ("ui-trigger--info", "ui-info"),
    ("ui-trigger--success", "ui-success"),
    ("ui-trigger--solid", "ui-solid"),
    ("ui-trigger--ghost", ""),
    ("ui-trigger--outline", ""),
)

BUTTON_CSS = """@import "../main.css";

@layer components {
  .button {
    @apply ui-trigger;

    width: fit-content;
    justify-content: center;
    text-align: center;
  }

  .button.ui-trigger--square {
    @apply ui-trigger--square;
  }

  .button.ui-trigger--circle {
    @apply ui-trigger--circle;
  }

  .button:not(.ui-solid) {
    background-color: var(--color-ui);
    color: var(--ctl-ink-text, var(--color-ink));
    border-color: var(--color-border);
  }

  .button:not(.ui-solid):hover {
    background-color: var(--color-ui-active);
  }

  .button:not(.ui-solid):active {
    background-color: var(--color-ui-active);
  }

  .button:not(.ui-solid):focus-visible {
    outline: none;
    box-shadow: inset 0 0 0 2px var(--ctl-ink-text, var(--color-ink));
  }

  .button:not(.ui-solid):disabled,
  .button:not(.ui-solid)[data-disabled],
  .button:not(.ui-solid)[disabled] {
    background-color: var(--color-ui-muted);
    color: var(--color-ink-muted);
    border-color: var(--color-ui-muted);
    cursor: not-allowed;
  }
}
"""


def replace_tokens(text: str) -> str:
    for old, new in REPLACEMENTS:
        text = text.replace(old, new)
    text = re.sub(r"@apply\s+", "@apply ", text)
    text = re.sub(r"@apply ui-trigger\s+;", "@apply ui-trigger;", text)
    text = re.sub(r"  +", " ", text)
    return text


def read_rule(lines: list[str], start: int) -> tuple[list[str], list[str], int]:
    header = [lines[start]]
    i = start + 1
    while "{" not in header[-1]:
        header.append(lines[i])
        i += 1
    body: list[str] = []
    depth = "".join(header).count("{") - "".join(header).count("}")
    while i < len(lines) and depth > 0:
        body.append(lines[i])
        depth += lines[i].count("{") - lines[i].count("}")
        i += 1
    return header, body, i


def selector_text(header: list[str]) -> str:
    text = "\n".join(header).strip()
    return text[:-1].strip() if text.endswith("{") else text


def split_selectors(text: str) -> list[str]:
    parts: list[str] = []
    buf: list[str] = []
    depth = 0
    for ch in text:
        if ch in "([{":
            depth += 1
        elif ch in ")]}":
            depth -= 1
        if ch == "," and depth == 0:
            part = "".join(buf).strip()
            if part:
                parts.append(part)
            buf = []
            continue
        buf.append(ch)
    tail = "".join(buf).strip()
    if tail:
        parts.append(tail)
    return parts


def split_comma_apply_blocks(text: str) -> str:
    lines = text.splitlines()
    out: list[str] = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if re.match(r"^\s*[\.#\[:]", line) and "&" not in line:
            header, body, nxt = read_rule(lines, i)
            sel = selector_text(header)
            body_text = "\n".join(body[:-1])
            if "," in sel and "@apply ui-trigger" in body_text:
                indent = re.match(r"^(\s*)", header[0]).group(1)
                inner = body[:-1]
                for selector in split_selectors(sel):
                    out.append(f"{indent}{selector} {{")
                    out.extend(inner)
                    out.append(body[-1] if body else f"{indent}}}")
                i = nxt
                continue
            out.extend(header)
            out.extend(body)
            i = nxt
            continue
        out.append(line)
        i += 1
    return "\n".join(out) + ("\n" if text.endswith("\n") else "")


def flatten_pseudo_in_comma_blocks(text: str) -> str:
    from flatten_comma_pseudos import transform

    return transform(text)


def main() -> int:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else "design/priv/css/components")
    (root / "button.css").write_text(BUTTON_CSS + "\n")
    changed = 1
    for path in sorted(root.glob("*.css")):
        if path.name == "button.css":
            continue
        original = path.read_text()
        updated = replace_tokens(original)
        updated = split_comma_apply_blocks(updated)
        if updated != original:
            path.write_text(updated)
            changed += 1
    print(changed)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
import re
import sys
from pathlib import Path

SKIP = {"keyframes.css", "scrollbar.css", "layout-heading.css", "icon.css", "typo.css"}

PALETTE_SUFFIXES = ("accent", "brand", "alert", "info", "success")
VARIANT_SUFFIXES = ("variant-solid", "variant-subtle", "variant-ghost", "variant-outline")
SELECTED_OVERRIDE_START = re.compile(
    r"\n\s*\[[^\]]+\]\[data-(?:selected|state=\"checked\")"
)


def extract_block(text: str, start: int) -> tuple[str, int] | None:
    brace = text.find("{", start)
    if brace == -1:
        return None
    depth = 0
    i = brace
    while i < len(text):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return text[start : i + 1], i + 1
        i += 1
    return None


def remove_utility_blocks(text: str, name_pattern: re.Pattern) -> str:
    out = []
    i = 0
    while i < len(text):
        m = re.search(r"@utility\s+", text[i:])
        if not m:
            out.append(text[i:])
            break
        start = i + m.start()
        out.append(text[i:start])
        name_m = re.match(r"@utility\s+([\w*-]+)\s*\{", text[start:])
        if not name_m:
            out.append(text[start])
            i = start + 1
            continue
        name = name_m.group(1)
        block = extract_block(text, start)
        if block is None:
            out.append(text[start])
            i = start + 1
            continue
        block_text, end = block
        if name_pattern.match(name):
            i = end
            continue
        out.append(block_text)
        i = end
    return "".join(out)


def strip_selected_overrides_in_wildcard(text: str) -> str:
    result = []
    i = 0
    while i < len(text):
        m = re.search(r"@utility\s+([\w-]+)--\*\s*\{", text[i:])
        if not m:
            result.append(text[i:])
            break
        start = i + m.start()
        result.append(text[i:start])
        block = extract_block(text, start)
        if block is None:
            result.append(text[start:])
            break
        block_text, end = block
        inner_start = block_text.find("{") + 1
        inner_end = block_text.rfind("}")
        inner = block_text[inner_start:inner_end]
        sel = SELECTED_OVERRIDE_START.search(inner)
        if sel:
            inner = inner[: sel.start()]
        block_text = block_text[:inner_start] + inner + block_text[inner_end:]
        result.append(block_text)
        i = end
    return "".join(result)


def replace_applies(text: str) -> str:
    text = text.replace("ui-palette-accent", "ui-accent")
    text = text.replace("ui-palette-brand", "ui-brand")
    text = text.replace("ui-palette-alert", "ui-alert")
    text = text.replace("ui-palette-info", "ui-info")
    text = text.replace("ui-palette-success", "ui-success")
    text = text.replace("ui-variant-solid", "ui-solid")
    text = re.sub(r"@apply\s+ui-variant-subtle;?\s*\n?", "", text)
    text = re.sub(r"@apply\s+ui-variant-ghost;?\s*\n?", "", text)
    text = re.sub(r"@apply\s+ui-variant-outline;?\s*\n?", "", text)
    return text


def strip_size_lines_from_wildcard(text: str) -> str:
    size_props = (
        "font-size:",
        "line-height:",
        "padding-inline:",
        "padding:",
        "gap:",
        "min-height:",
        "margin-bottom:",
    )

    result = []
    i = 0
    while i < len(text):
        m = re.search(r"@utility\s+([\w-]+)--\*\s*\{", text[i:])
        if not m:
            result.append(text[i:])
            break
        start = i + m.start()
        result.append(text[i:start])
        block = extract_block(text, start)
        if block is None:
            result.append(text[i:])
            break
        block_text, end = block
        inner_start = block_text.find("{") + 1
        inner_end = block_text.rfind("}")
        lines = block_text[inner_start:inner_end].split("\n")
        kept = []
        for line in lines:
            stripped = line.strip()
            if any(stripped.startswith(p) for p in size_props):
                continue
            if stripped == "{}" or stripped == "":
                continue
            kept.append(line)
        inner = "\n".join(kept)
        if not inner.strip():
            i = end
            continue
        block_text = block_text[:inner_start] + inner + block_text[inner_end:]
        result.append(block_text)
        i = end
    return "".join(result)


def process_file(path: Path) -> bool:
    if path.name in SKIP:
        return False
    original = path.read_text()
    text = original
    component = path.stem.replace("-", "")

    for suffix in PALETTE_SUFFIXES:
        text = remove_utility_blocks(text, re.compile(rf"^{re.escape(path.stem)}--{suffix}$"))
    for suffix in VARIANT_SUFFIXES:
        text = remove_utility_blocks(text, re.compile(rf"^{re.escape(path.stem)}--{suffix}$"))
    text = remove_utility_blocks(text, re.compile(rf"^{re.escape(path.stem)}--\*$"))
    text = remove_utility_blocks(text, re.compile(rf"^{re.escape(path.stem)}--rounded-\*$"))
    text = strip_selected_overrides_in_wildcard(text)
    text = strip_size_lines_from_wildcard(text)
    text = replace_applies(text)
    text = re.sub(r"\n{3,}", "\n\n", text).rstrip() + "\n"
    if text != original:
        path.write_text(text)
        return True
    return False


def main() -> int:
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("design/priv/css/components")
    changed = [p.name for p in sorted(root.glob("*.css")) if process_file(p)]
    print(f"Updated {len(changed)} files:")
    for name in changed:
        print(f"  {name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

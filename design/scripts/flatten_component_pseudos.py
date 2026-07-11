#!/usr/bin/env python3
import re
import sys
from pathlib import Path

PSEUDO_HEAD = re.compile(r"^(\s*)&:(hover|active|focus-visible|focus-within|focus|disabled)\s*,?\s*$")
PSEUDO_OPEN = re.compile(r"^(\s*)&:(hover|active|focus-visible|focus-within|focus|disabled)\s*\{\s*$")
ATTR_LINE = re.compile(r"^(\s*)&\[(data-disabled|disabled)\]\s*,?\s*$")


def split_selectors(header: str) -> list[str]:
    parts: list[str] = []
    buf: list[str] = []
    depth = 0
    for ch in header:
        if ch == "{":
            depth += 1
        if depth == 0 and ch == ",":
            parts.append("".join(buf).strip())
            buf = []
            continue
        buf.append(ch)
    tail = "".join(buf).strip()
    if tail.endswith("{"):
        tail = tail[:-1].strip()
    if tail:
        parts.append(tail)
    return parts


def join_selectors(selectors: list[str], suffix: str) -> str:
    return ",\n".join(f"{sel}{suffix}" for sel in selectors)


def read_block(lines: list[str], start: int) -> tuple[list[str], int]:
    block = [lines[start]]
    depth = lines[start].count("{") - lines[start].count("}")
    i = start + 1
    while i < len(lines) and depth > 0:
        block.append(lines[i])
        depth += lines[i].count("{") - lines[i].count("}")
        i += 1
    return block, i


def flatten_disabled_group(lines: list[str], start: int, selectors: list[str], indent: str) -> tuple[list[str], int]:
    block, end = read_block(lines, start)
    inner = block[1:-1]
    joined = join_selectors(
        selectors,
        ":disabled,\n" + join_selectors(selectors, "[data-disabled],\n") + join_selectors(selectors, "[disabled]"),
    )
    out = [f"{indent}{joined} {{"]
    out.extend(inner)
    out.append(f"{indent}}}")
    return out, end


def flatten_pseudo_block(lines: list[str], start: int, selectors: list[str], pseudo: str, indent: str) -> tuple[list[str], int]:
    block, end = read_block(lines, start)
    inner = block[1:-1]
    joined = join_selectors(selectors, f":{pseudo}")
    out = [f"{indent}{joined} {{"]
    out.extend(inner)
    out.append(f"{indent}}}")
    return out, end


def flatten_rule_body(body_lines: list[str], selectors: list[str], indent: str) -> list[str]:
    out: list[str] = []
    i = 0
    while i < len(body_lines):
        line = body_lines[i]
        m = PSEUDO_OPEN.match(line)
        if m:
            chunk, i = flatten_pseudo_block(body_lines, i, selectors, m.group(2), indent)
            out.extend(chunk)
            continue
        if PSEUDO_HEAD.match(line) and i + 1 < len(body_lines) and ATTR_LINE.match(body_lines[i + 1]):
            chunk, i = flatten_disabled_group(body_lines, i, selectors, indent)
            out.extend(chunk)
            continue
        if line.strip().startswith("&:") or line.strip().startswith("&["):
            chunk, i = read_block(body_lines, i)
            out.extend(chunk)
            continue
        out.append(line)
        i += 1
    return out


def flatten_css(text: str) -> str:
    lines = text.splitlines()
    out: list[str] = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.strip().startswith("@") or not line.strip():
            out.append(line)
            i += 1
            continue
        if "{" not in line:
            out.append(line)
            i += 1
            continue
        header_lines = [line]
        while "{" not in header_lines[-1]:
            i += 1
            header_lines.append(lines[i])
        header = "\n".join(header_lines)
        if "&:" not in header and "&[" not in header:
            selectors = split_selectors(header)
            body_start = i + 1
            body_lines: list[str] = []
            depth = header.count("{") - header.count("}")
            i = body_start
            while i < len(lines) and depth > 0:
                body_lines.append(lines[i])
                depth += lines[i].count("{") - lines[i].count("}")
                i += 1
            if any(re.search(r"^\s*&:(hover|active|focus|disabled)", b) for b in body_lines):
                indent = re.match(r"^(\s*)", header_lines[0]).group(1) + "  "
                flattened = flatten_rule_body(body_lines[:-1], selectors, indent)
                out.extend(header_lines)
                out.extend(flattened)
                if body_lines:
                    out.append(body_lines[-1])
                continue
        out.extend(header_lines)
        i += 1
        depth = header.count("{") - header.count("}")
        while i < len(lines) and depth > 0:
            out.append(lines[i])
            depth += lines[i].count("{") - lines[i].count("}")
            i += 1
    return "\n".join(out) + ("\n" if text.endswith("\n") else "")


def main() -> int:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else "design/priv/css/components")
    changed = 0
    for path in sorted(root.glob("*.css")):
        original = path.read_text()
        updated = flatten_css(original)
        if updated != original:
            path.write_text(updated)
            changed += 1
    print(changed)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

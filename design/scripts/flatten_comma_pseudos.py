#!/usr/bin/env python3
import re
import sys
from pathlib import Path

PSEUDO_BLOCK = re.compile(
    r"^(\s*)&:(hover|active|focus-visible|focus-within|focus)\s*\{",
    re.MULTILINE,
)


def read_rule(lines: list[str], start: int) -> tuple[list[str], list[str], int]:
    header = [lines[start]]
    i = start + 1
    while i < len(lines) and "{" not in lines[i - 1]:
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
    if text.endswith("{"):
        text = text[:-1].strip()
    return text


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


def flatten_disabled(body: list[str], start: int, selectors: list[str], indent: str) -> tuple[list[str], int]:
    depth = 0
    end = start
    while end < len(body):
        depth += body[end].count("{") - body[end].count("}")
        end += 1
        if depth <= 0:
            break
    inner = body[start + 1 : end - 1]
    lines = []
    for sel in selectors:
        lines.append(f"{indent}{sel}:disabled,")
    for sel in selectors:
        lines.append(f"{indent}{sel}[data-disabled],")
    last = selectors[-1]
    lines.append(f"{indent}{last}[disabled] {{")
    lines.extend(inner)
    lines.append(f"{indent}}}")
    return lines, end


def flatten_pseudo(body: list[str], start: int, selectors: list[str], pseudo: str, indent: str) -> tuple[list[str], int]:
    depth = 0
    end = start
    while end < len(body):
        depth += body[end].count("{") - body[end].count("}")
        end += 1
        if depth <= 0:
            break
    inner = body[start + 1 : end - 1]
    joined = ",\n".join(f"{indent}{sel}:{pseudo}" for sel in selectors)
    lines = [f"{joined} {{"]
    lines.extend(inner)
    lines.append(f"{indent}}}")
    return lines, end


def flatten_body(body: list[str], selectors: list[str], indent: str) -> list[str]:
    out: list[str] = []
    i = 0
    while i < len(body):
        line = body[i]
        m = PSEUDO_BLOCK.match(line)
        if m:
            chunk, i = flatten_pseudo(body, i, selectors, m.group(2), indent)
            out.extend(chunk)
            continue
        if (
            line.strip() == "&:disabled,"
            and i + 2 < len(body)
            and body[i + 1].strip() == "&[data-disabled],"
            and body[i + 2].strip() == "&[disabled] {"
        ):
            chunk, i = flatten_disabled(body, i, selectors, indent)
            out.extend(chunk)
            continue
        out.append(line)
        i += 1
    return out


def transform(text: str) -> str:
    lines = text.splitlines()
    out: list[str] = []
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.strip().startswith("@") or not line.strip() or line.strip().startswith("/*"):
            out.append(line)
            i += 1
            continue
        if re.match(r"^\s*[\.#\[:]", line) and "&" not in line:
            header, body, nxt = read_rule(lines, i)
            sel = selector_text(header)
            if "," in sel and any(
                re.match(r"^\s*&:(hover|active|focus|disabled)", b) for b in body[:-1]
            ):
                selectors = split_selectors(sel)
                indent = re.match(r"^(\s*)", header[0]).group(1) + "  "
                out.extend(header)
                out.extend(flatten_body(body[:-1], selectors, indent))
                if body:
                    out.append(body[-1])
                i = nxt
                continue
            out.extend(header)
            out.extend(body)
            i = nxt
            continue
        out.append(line)
        i += 1
    return "\n".join(out) + ("\n" if text.endswith("\n") else "")


def main() -> int:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else "design/priv/css/components")
    changed = 0
    for path in sorted(root.glob("*.css")):
        original = path.read_text()
        updated = transform(original)
        if updated != original:
            path.write_text(updated)
            changed += 1
    print(changed)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

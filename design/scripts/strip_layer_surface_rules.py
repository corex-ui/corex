#!/usr/bin/env python3
import re
from pathlib import Path

COMPONENTS_DIR = Path(__file__).resolve().parents[1] / "priv" / "css" / "components"


def should_remove_selector(selector: str, name: str) -> bool:
    cls = re.escape(name)
    if re.search(rf"\.{cls}\.{cls}--variant-", selector):
        return True
    if re.search(rf"\.{cls}:not\(\.{cls}--variant-", selector):
        return True
    if re.search(rf"pre\.{cls}:not\(\.{cls}--variant-", selector):
        return True
    if re.search(rf"code\.{cls}:not\(\.{cls}--variant-", selector):
        return True
    if re.search(r"\.icon,\s*$", selector) and "color: inherit" in selector:
        return True
    return False


def strip_layer_surface_rules(content: str, name: str) -> str:
    lines = content.split("\n")
    out = []
    i = 0
    in_layer = False
    layer_depth = 0

    while i < len(lines):
        line = lines[i]

        if re.match(r"@layer components\s*\{", line.strip()):
            in_layer = True
            layer_depth = line.count("{") - line.count("}")
            out.append(line)
            i += 1
            continue

        if not in_layer:
            out.append(line)
            i += 1
            continue

        depth_before = layer_depth
        layer_depth += line.count("{") - line.count("}")

        if layer_depth == 0:
            in_layer = False
            out.append(line)
            i += 1
            continue

        if depth_before == 1 and (
            line.startswith("  .") or line.startswith("  [data-scope") or line.startswith("  pre.") or line.startswith("  code.")
        ):
            sel_start = i
            sel_lines = []
            j = i
            while j < len(lines):
                sel_lines.append(lines[j])
                if "{" in lines[j]:
                    break
                j += 1

            selector = "\n".join(sel_lines)
            if should_remove_selector(selector, name):
                depth = 0
                k = j
                while k < len(lines):
                    depth += lines[k].count("{") - lines[k].count("}")
                    k += 1
                    if depth <= 0:
                        break
                i = k
                continue

        out.append(line)
        i += 1

    return "\n".join(out)


def fix_broken_wildcard(content: str, name: str) -> str:
    util = rf"@utility {re.escape(name)}--\*"
    match = re.search(util, content)
    if not match:
        return content

    start = match.start()
    rest = content[start:]
    depth = 0
    end = 0
    for idx, ch in enumerate(rest):
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                end = start + idx + 1
                break

    block = content[start:end]
    if "[data-state=" in block and "&[data-highlighted" in block and block.count("{") != block.count("}"):
        lines = block.split("\n")
        fixed = []
        skip = 0
        for line in lines:
            if skip > 0:
                skip += line.count("{") - line.count("}")
                continue
            if re.match(r"^\s+\[data-state=", line) or re.match(r"^\s+\)\s*\{", line):
                if "{" in line:
                    skip = line.count("{") - line.count("}")
                continue
            if re.match(r"^\s*&\[data-(toggle-grouped|highlighted|state)", line):
                if "{" in line:
                    skip = line.count("{") - line.count("}")
                continue
            fixed.append(line)
        block = "\n".join(fixed)
        content = content[:start] + block + content[end:]

    return content


def main():
    for path in sorted(COMPONENTS_DIR.glob("*.css")):
        name = path.stem
        original = path.read_text()
        content = strip_layer_surface_rules(original, name)
        content = fix_broken_wildcard(content, name)
        content = re.sub(r"\n{3,}", "\n\n", content)
        if content != original:
            path.write_text(content)
            print(f"stripped {path.name}")


if __name__ == "__main__":
    main()

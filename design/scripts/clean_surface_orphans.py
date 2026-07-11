#!/usr/bin/env python3
import re
from pathlib import Path

COMPONENTS_DIR = Path(__file__).resolve().parents[1] / "priv" / "css" / "components"


def clean_orphan_surface_blocks(content: str, name: str) -> str:
    lines = content.split("\n")
    out = []
    i = 0
    in_layer = False
    layer_depth = 0

    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        if "@layer components" in line:
            in_layer = True
            layer_depth = 0
            out.append(line)
            i += 1
            continue

        if in_layer:
            if stripped == "}" and layer_depth == 0:
                in_layer = False
                out.append(line)
                i += 1
                continue

            if re.match(r"^\s+\[data-scope=", line) and not re.match(rf"^\s+\.{re.escape(name)}", line):
                depth = line.count("{") - line.count("}")
                i += 1
                while i < len(lines) and depth > 0:
                    depth += lines[i].count("{") - lines[i].count("}")
                    i += 1
                continue

            if re.match(rf"^\s+\.{re.escape(name)}:not\(", line) or re.match(
                rf"^\s+\.{re.escape(name)}\.{re.escape(name)}--variant-", line
            ):
                depth = line.count("{") - line.count("}")
                i += 1
                while i < len(lines) and depth > 0:
                    depth += lines[i].count("{") - lines[i].count("}")
                    i += 1
                continue

            layer_depth += line.count("{") - line.count("}")

        out.append(line)
        i += 1

    return "\n".join(out)


def clean_wildcard_semantic_tokens(content: str, name: str) -> str:
    lines = content.split("\n")
    out = []
    in_wildcard = False
    skip_depth = 0

    for line in lines:
        if re.match(rf"@utility {re.escape(name)}--\*", line):
            in_wildcard = True
            out.append(line)
            continue

        if in_wildcard:
            if skip_depth == 0 and re.match(rf"^\s*--{re.escape(name)}-", line):
                if "{" in line:
                    skip_depth = line.count("{") - line.count("}")
                continue

            if skip_depth == 0 and re.match(r"^\s*&\[data-(selected|state|highlighted)", line):
                if "{" in line:
                    skip_depth = line.count("{") - line.count("}")
                continue

            if skip_depth > 0:
                skip_depth += line.count("{") - line.count("}")
                continue

            if line.strip() == "}" and not any(
                re.match(rf"@utility {re.escape(name)}--", l) for l in out[-3:]
            ):
                in_wildcard = False

        out.append(line)

    return "\n".join(out)


def main():
    for path in sorted(COMPONENTS_DIR.glob("*.css")):
        name = path.stem
        original = path.read_text()
        content = clean_orphan_surface_blocks(original, name)
        content = clean_wildcard_semantic_tokens(content, name)
        if content != original:
            path.write_text(content)
            print(f"cleaned {path.name}")


if __name__ == "__main__":
    main()

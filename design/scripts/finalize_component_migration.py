#!/usr/bin/env python3
import re
import sys
from pathlib import Path

COMPONENTS = Path(__file__).resolve().parents[1] / "priv/css/components"

SKIP = {"keyframes.css", "scrollbar.css", "layout-heading.css", "icon.css", "typo.css"}

SELECTED_REPLACEMENTS = (
    ("--color-selected-muted", "--color-ui-muted"),
    ("--color-selected-hover", "--color-ui-hover"),
    ("--color-selected-active", "--color-ui-active"),
    ("--color-selected-ink", "--color-ink"),
    ("--color-selected", "--color-ui-active"),
)

SWITCH_SURFACE = """
 .switch:not(.ui-solid) [data-scope="switch"][data-part="control"][data-state="unchecked"] {
 background-color: var(--color-ui);
 border-color: var(--color-border);

 & [data-scope="switch"][data-part="thumb"] {
 background-color: var(--ctl-fill, var(--color-ink));
 }
 }

 .switch:not(.ui-solid) [data-scope="switch"][data-part="control"][data-state="checked"] {
 background-color: var(--ctl-sel-bg, var(--color-ui-active));
 border-color: var(--ctl-sel-bg, var(--color-ui-active));

 & [data-scope="switch"][data-part="thumb"] {
 background-color: var(--ctl-sel-ink, var(--color-ink));
 }
 }

 .switch.ui-solid [data-scope="switch"][data-part="control"][data-state="checked"] {
 background-color: var(--ctl-fill, var(--color-ui-active));
 border-color: transparent;

 & [data-scope="switch"][data-part="thumb"] {
 background-color: var(--ctl-fill-ink, var(--color-ink));
 }
 }
"""


def find_block_end(content: str, start: int) -> int:
    depth = 0
    i = start
    while i < len(content):
        if content[i] == "{":
            depth += 1
        elif content[i] == "}":
            depth -= 1
            if depth == 0:
                return i + 1
        i += 1
    return len(content)


def should_drop_selector(selector: str, name: str) -> bool:
    cls = re.escape(name)
    if re.search(rf"--variant-(?:ghost|outline|subtle)", selector):
        return True
    if re.search(rf"\.{cls}\.{cls}--variant-", selector):
        return True
    if re.search(rf"\.{cls}:not\(\.{cls}--variant-", selector):
        return True
    if re.search(rf"pre\.{cls}:not\(\.{cls}--variant-", selector):
        return True
    if re.search(rf"code\.{cls}:not\(\.{cls}--variant-", selector):
        return True
    return False


def strip_variant_rules(content: str, name: str) -> str:
    lines = content.split("\n")
    out: list[str] = []
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

        if depth_before == 1 and re.match(
            r"^\s*(?:\.|[data-scope]|pre\.|code\.)", line
        ):
            sel_lines = []
            j = i
            while j < len(lines):
                sel_lines.append(lines[j])
                if "{" in lines[j]:
                    break
                j += 1

            selector = "\n".join(sel_lines)
            if should_drop_selector(selector, name):
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


def clean_orphan_blocks(content: str, name: str) -> str:
    lines = content.split("\n")
    out: list[str] = []
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

            layer_depth += line.count("{") - line.count("}")

        out.append(line)
        i += 1

    return "\n".join(out)


def replace_selected_tokens(content: str) -> str:
    for old, new in SELECTED_REPLACEMENTS:
        content = content.replace(old, new)
    return content


def patch_checkbox(content: str) -> str:
    old = """ .checkbox [data-scope="checkbox"][data-part="control"] {
 height: calc(var(--spacing-size) * 0.6);
 width: calc(var(--spacing-size) * 0.6);
 background: var(--color-ui);
 color: var(--color-ink);
 font-weight: var(--font-weight-normal);
 border-radius: var(--radius-md);
 border: 1px solid var(--color-border);
 display: flex;
 align-items: center;
 justify-content: center;
 cursor: pointer;
 padding: var(--spacing-space);"""
    new = """ .checkbox [data-scope="checkbox"][data-part="control"] {
 @apply ui-trigger ui-trigger--square;

 height: calc(var(--spacing-size) * 0.6);
 width: calc(var(--spacing-size) * 0.6);
 padding: var(--spacing-space);"""
    return content.replace(old, new)


def patch_radio(content: str) -> str:
    old = """ [data-scope="radio-group"][data-part="item-control"] {
 flex-shrink: 0;
 margin-inline-start: auto;
 height: calc(var(--spacing-size) * 0.6);
 width: calc(var(--spacing-size) * 0.6);
 background: var(--color-ui);
 color: var(--color-ink);
 font-weight: var(--font-weight-normal);
 border-radius: var(--radius-full);
 border: 1px solid var(--color-border);
 display: flex;
 align-items: center;
 justify-content: center;
 cursor: pointer;
 padding: calc(var(--spacing-space) * 0.25);"""
    new = """ [data-scope="radio-group"][data-part="item-control"] {
 @apply ui-trigger ui-trigger--circle;

 flex-shrink: 0;
 margin-inline-start: auto;
 height: calc(var(--spacing-size) * 0.6);
 width: calc(var(--spacing-size) * 0.6);
 padding: calc(var(--spacing-space) * 0.25);"""
    return content.replace(old, new)


def patch_switch(content: str) -> str:
    if " .switch:not(.ui-solid)" in content:
        return content
    marker = ' .switch--square [data-scope="switch"][data-part="control"]'
    if marker in content:
        return content.replace(marker, SWITCH_SURFACE + marker, 1)
    marker = ' .switch [data-scope="switch"][data-part="error"]'
    return content.replace(marker, SWITCH_SURFACE + marker, 1)


def process_file(path: Path) -> bool:
    if path.name in SKIP:
        return False
    name = path.stem
    original = path.read_text()
    content = strip_variant_rules(original, name)
    content = replace_selected_tokens(content)

    if name == "checkbox":
        content = patch_checkbox(content)
    elif name == "radio-group":
        content = patch_radio(content)
    elif name == "switch":
        content = patch_switch(content)

    content = re.sub(r"\n{3,}", "\n\n", content).rstrip() + "\n"
    if content != original:
        path.write_text(content)
        return True
    return False


def main() -> int:
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else COMPONENTS
    changed = [
        p.name
        for p in sorted(root.glob("*.css"))
        if p.name not in SKIP and process_file(p)
    ]
    print(f"Updated {len(changed)} files")
    for name in changed:
        print(f"  {name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

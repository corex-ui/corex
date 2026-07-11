#!/usr/bin/env python3
import re
from pathlib import Path

COMPONENTS_DIR = Path(__file__).resolve().parents[1] / "priv" / "css" / "components"
ROLES = ["accent", "brand", "alert", "info", "success"]
VARIANTS = ["solid", "subtle", "ghost", "outline"]

CONFIG = {
    "accordion": {
        "selectors": ['[data-scope="accordion"][data-part="item-trigger"]'],
        "ghost": True,
    },
    "angle-slider": {
        "selectors": [
            '[data-scope="angle-slider"][data-part="control"]',
            '[data-scope="angle-slider"][data-part="thumb"]::before',
        ],
        "solid_extra": [
            '[data-scope="angle-slider"][data-part="marker"][data-state="under-value"]',
            '[data-scope="angle-slider"][data-part="marker"][data-state="over-value"]',
        ],
        "ghost": True,
    },
    "avatar": {
        "selectors": ['[data-scope="avatar"][data-part="fallback"]'],
        "ghost": True,
    },
    "badge": {"host": True, "ghost": True},
    "carousel": {
        "selectors": [
            '[data-scope="carousel"][data-part="prev-trigger"]',
            '[data-scope="carousel"][data-part="next-trigger"]',
            '[data-scope="carousel"][data-part="autoplay-trigger"]',
        ],
        "ghost": False,
    },
    "checkbox": {
        "selectors": ['[data-scope="checkbox"][data-part="control"]'],
        "ghost": False,
    },
    "clipboard": {
        "selectors": ['[data-scope="clipboard"][data-part="trigger"]:not([data-copied])'],
        "ghost": True,
    },
    "code": {"host": True, "ghost": True},
    "collapsible": {
        "selectors": ['[data-scope="collapsible"][data-part="trigger"]'],
        "ghost": True,
    },
    "color-picker": {
        "selectors": [
            '[data-scope="color-picker"][data-part="trigger"]',
            '[data-scope="color-picker"][data-part="control"] [data-scope="color-picker"][data-part="channel-input"]',
        ],
        "ghost": True,
    },
    "combobox": {
        "selectors": [
            '[data-scope="combobox"][data-part="input"]',
            '[data-scope="combobox"][data-part="trigger"]',
            '[data-scope="combobox"][data-part="clear-trigger"]',
        ],
        "ghost": True,
    },
    "data-list": {
        "selectors": ['[data-scope="data-list"][data-part="item"]'],
        "ghost": True,
        "outline_extra": "box-shadow: inset 0 0 0 1px var(--ctl-fill, var(--color-border)); border-color: transparent;",
    },
    "data-table": {
        "selectors": ['[data-scope="data-table"][data-part="sort-trigger"]'],
        "ghost": True,
    },
    "date-picker": {
        "selectors": [
            '[data-scope="date-picker"][data-part="input"]',
            '[data-scope="date-picker"][data-part="trigger"]',
        ],
        "ghost": True,
    },
    "dialog": {
        "selectors": ['[data-scope="dialog"][data-part="trigger"]'],
        "ghost": True,
    },
    "editable": {
        "selectors": [
            '[data-scope="editable"][data-part="input"]',
            '[data-scope="editable"][data-part="preview"]',
        ],
        "ghost": True,
    },
    "file-upload": {
        "selectors": ['[data-scope="file-upload"][data-part="trigger"]'],
        "ghost": True,
    },
    "floating-panel": {
        "selectors": [
            '[data-scope="floating-panel"][data-part="trigger"]',
            '[data-scope="floating-panel"][data-part="drag-trigger"]',
        ],
        "ghost": True,
    },
    "link": {"host": True, "ghost": True},
    "listbox": {
        "selectors": ['[data-scope="listbox"][data-part="item"]'],
        "ghost": True,
    },
    "menu": {
        "selectors": ['[data-scope="menu"][data-part="trigger"]'],
        "ghost": True,
    },
    "native-input": {
        "selectors": [
            '[data-scope="native-input"][data-part="input"]:not([type="checkbox"]):not([type="radio"])'
        ],
        "ghost": True,
    },
    "number-input": {
        "selectors": [
            '[data-scope="number-input"][data-part="input"]',
            '[data-scope="number-input"][data-part="increment-trigger"]',
            '[data-scope="number-input"][data-part="decrement-trigger"]',
        ],
        "ghost": True,
    },
    "pagination": {
        "selectors": [
            '[data-scope="pagination"][data-part="prev-trigger"]',
            '[data-scope="pagination"][data-part="next-trigger"]',
            '[data-scope="pagination"][data-part="item"]',
        ],
        "ghost": True,
    },
    "password-input": {
        "selectors": ['[data-scope="password-input"][data-part="input"]'],
        "ghost": True,
    },
    "pin-input": {
        "selectors": ['[data-scope="pin-input"][data-part="input"]'],
        "ghost": True,
    },
    "radio-group": {
        "selectors": ['[data-scope="radio-group"][data-part="item-control"]'],
        "ghost": True,
    },
    "select": {
        "selectors": ['[data-scope="select"][data-part="trigger"]'],
        "ghost": True,
    },
    "signature-pad": {
        "selectors": ['[data-scope="signature-pad"][data-part="clear-trigger"]'],
        "ghost": True,
    },
    "switch": {
        "selectors": ['[data-scope="switch"][data-part="control"]'],
        "ghost": True,
    },
    "tabs": {
        "selectors": ['[data-scope="tabs"][data-part="trigger"]'],
        "ghost": True,
    },
    "tags-input": {
        "selectors": ['[data-scope="tags-input"][data-part="input"]'],
        "ghost": True,
    },
    "timer": {
        "selectors": ['[data-scope="timer"][data-part="action-trigger"]'],
        "ghost": True,
    },
    "toast": {
        "selectors": ['[data-scope="toast"][data-part="action-trigger"]'],
        "ghost": True,
    },
    "toggle": {
        "selectors": ['[data-scope="toggle"][data-part="root"]'],
        "ghost": True,
    },
    "toggle-group": {
        "selectors": ['[data-scope="toggle-group"][data-part="item"]'],
        "ghost": True,
    },
    "tooltip": {
        "selectors": [
            '[data-scope="tooltip"][data-part="content"]',
            '[data-scope="tooltip"][data-part="arrow"]',
        ],
        "ghost": True,
    },
    "tree-view": {
        "selectors": [
            '[data-scope="tree-view"][data-part="item"]',
            '[data-scope="tree-view"][data-part="branch-control"]',
        ],
        "ghost": True,
    },
}


def find_block_end(content: str, start: int) -> int:
    depth = 0
    i = start
    while i < len(content):
        ch = content[i]
        if ch == "{":
            depth += 1
        elif ch == "}":
            depth -= 1
            if depth == 0:
                return i + 1
        i += 1
    return len(content)


def remove_utility(content: str, name: str) -> str:
    pattern = rf"@utility {re.escape(name)}\s*\{{"
    while True:
        match = re.search(pattern, content)
        if not match:
            break
        end = find_block_end(content, match.end() - 1)
        content = content[: match.start()] + content[end:]
    return content


def should_remove_component_rule(selector: str, name: str) -> bool:
    cls = re.escape(name)
    patterns = [
        rf"\.{cls}:not\(\.{cls}--variant-",
        rf"\.{cls}\.{cls}--variant-",
        rf"\.{cls}:not\(\.{cls}--variant-solid\):not\(\.{cls}--variant-outline\)",
        r"color:\s*inherit",
    ]
    return any(re.search(p, selector) for p in patterns)


def remove_component_surface_rules(content: str, name: str) -> str:
    layer_match = re.search(r"@layer components\s*\{", content)
    if not layer_match:
        return content

    layer_start = layer_match.end() - 1
    layer_end = find_block_end(content, layer_start)
    layer_body = content[layer_start:layer_end]
    rest_before = content[:layer_start]
    rest_after = content[layer_end:]

    i = 0
    cleaned = []
    body = layer_body
    while i < len(body):
        if body[i] in " \t\n":
            cleaned.append(body[i])
            i += 1
            continue

        rule_start = i
        brace = body.find("{", i)
        if brace == -1:
            cleaned.append(body[i:])
            break

        selector = body[rule_start:brace].strip()
        block_end = find_block_end(body, brace)
        block = body[rule_start:block_end]

        if should_remove_component_rule(selector, name):
            i = block_end
            continue

        if "color: inherit" in block and selector.endswith(".icon"):
            i = block_end
            continue

        cleaned.append(block)
        i = block_end

    new_layer = rest_before + "".join(cleaned) + rest_after
    return new_layer


def clean_wildcard_utility(content: str, name: str) -> str:
    util_match = re.search(rf"@utility {re.escape(name)}--\*\s*\{{", content)
    if not util_match:
        return content

    start = util_match.end() - 1
    end = find_block_end(content, start)
    block = content[util_match.start() : end]

    lines = block.split("\n")
    out = []
    skip = 0
    for line in lines:
        if skip > 0:
            skip += line.count("{") - line.count("}")
            if skip <= 0:
                skip = 0
            continue
        if re.match(rf"^\s*--{re.escape(name)}-", line):
            if "{" in line:
                skip = line.count("{") - line.count("}")
            continue
        if re.match(r"^\s*&\[data-(selected|state|highlighted|checked|in-range|indeterminate)", line):
            if "{" in line:
                skip = line.count("{") - line.count("}")
            continue
        out.append(line)

    new_block = "\n".join(out)
    return content[: util_match.start()] + new_block + content[end:]


def gen_semantic(name: str) -> str:
    return "\n".join(
        f"@utility {name}--{role} {{\n  @apply ui-palette-{role};\n}}"
        for role in ROLES
    )


def gen_variant(name: str, variant: str, cfg: dict) -> str:
    lines = [f"@utility {name}--variant-{variant} {{"]
    if cfg.get("host"):
        lines.append(f"  @apply ui-variant-{variant};")
        if variant == "outline" and cfg.get("outline_extra"):
            lines.append(f"  {cfg['outline_extra']}")
    else:
        selectors = list(cfg.get("selectors", []))
        if variant == "solid" and cfg.get("solid_extra"):
            selectors.extend(cfg["solid_extra"])
        for sel in selectors:
            lines.append(f"  {sel} {{")
            lines.append(f"    @apply ui-variant-{variant};")
            if variant == "outline" and cfg.get("outline_extra"):
                lines.append(f"    {cfg['outline_extra']}")
            lines.append("  }")
    lines.append("}")
    return "\n".join(lines)


def gen_variants(name: str, cfg: dict) -> str:
    variants = VARIANTS if cfg.get("ghost", True) else [v for v in VARIANTS if v != "ghost"]
    return "\n\n".join(gen_variant(name, v, cfg) for v in variants)


def process(path: Path, name: str, cfg: dict) -> None:
    content = path.read_text()

    for role in ROLES:
        content = remove_utility(content, f"{name}--{role}")
    for variant in VARIANTS:
        content = remove_utility(content, f"{name}--variant-{variant}")

    content = remove_component_surface_rules(content, name)
    content = clean_wildcard_utility(content, name)

    content = re.sub(r"\n{3,}", "\n\n", content).rstrip() + "\n\n"
    content += gen_semantic(name) + "\n\n" + gen_variants(name, cfg) + "\n"
    path.write_text(content)
    print(f"ok {path.name}")


def main():
    for path in sorted(COMPONENTS_DIR.glob("*.css")):
        cfg = CONFIG.get(path.stem)
        if cfg:
            process(path, path.stem, cfg)


if __name__ == "__main__":
    main()

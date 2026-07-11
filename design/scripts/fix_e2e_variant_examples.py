#!/usr/bin/env python3
import re
import sys
from pathlib import Path

GHOST_OUTLINE_LINE = re.compile(
    r"^\s*.*(?:>Ghost<|>Outline<|:fallback>Ghost</|:fallback>Outline</|"
    r"Ghost</\.|Outline</\.|Subtle</\.action>|>Ghost</\.toggle).*\n?",
    re.MULTILINE,
)

GHOST_OUTLINE_BLOCK = re.compile(
    r"\n[ \t]*<\.\w+[^>]*style-variant-(?:ghost|outline)[^>]*>.*?\n[ \t]*</\.\w+>",
    re.DOTALL,
)

GHOST_OUTLINE_CAROUSEL = re.compile(
    r"\n[ \t]*<\.\w+[^>]*style-variant-(?:ghost|outline)[^>]*/>",
    re.MULTILINE,
)

DUPLICATE_ACCORDION_TAIL = re.compile(
    r"(<\.accordion class=\"accordion ui-solid\"[\s\S]*?</\.accordion>)\s*"
    r"(<\.accordion class=\"accordion\"[\s\S]*?</\.accordion>\s*){2}(?=\s*\"\"\"\s*$)",
    re.MULTILINE,
)


def fix_content(text: str) -> str:
    updated = GHOST_OUTLINE_BLOCK.sub("", text)
    updated = GHOST_OUTLINE_CAROUSEL.sub("", updated)
    updated = GHOST_OUTLINE_LINE.sub("", updated)
    updated = DUPLICATE_ACCORDION_TAIL.sub(r"\1\n", updated)
    updated = re.sub(
        r"\n[ \t]*<\.\w+[^>]*>Ghost</\.\w+>\n",
        "\n",
        updated,
    )
    updated = re.sub(
        r"\n[ \t]*<\.\w+[^>]*>\n[ \t]*Outline\n[ \t]*</\.\w+>\n",
        "\n",
        updated,
    )
    return updated


def main() -> int:
    roots = [Path(p) for p in sys.argv[1:]]
    changed = 0
    for root in roots:
        for path in root.rglob("*.ex"):
            if not path.is_file():
                continue
            original = path.read_text()
            updated = fix_content(original)
            if updated != original:
                path.write_text(updated)
                changed += 1
    print(changed)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

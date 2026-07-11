#!/usr/bin/env python3
import re
import sys
from pathlib import Path

VARIANT_PROSE = re.compile(
    r"Variant modifiers control .+? Default is subtle; use <code class=\"text-sm\">[\w-]+--variant-solid</code>, "
    r"<code class=\"text-sm\">[\w-]+--variant-ghost</code>, or\s*"
    r"<code class=\"text-sm\">[\w-]+--variant-outline</code>\s*to change it\.",
    re.DOTALL,
)

VARIANT_PROSE_REPL = (
    "Variant modifiers control surface treatment. Default is subtle; add "
    '<code class="text-sm">ui-solid</code> for a filled surface.'
)

MATRIX_PROSE = re.compile(
    r"Combine semantic palette and variant treatment on the same host, for example "
    r'<code class="text-sm">[\w-]+ [\w-]+--[\w-]+ [\w-]+--variant-solid</code>\.',
)

MATRIX_PROSE_REPL = (
    'Combine semantic palette and variant treatment on the same host, for example '
    '<code class="text-sm">{host} ui-accent ui-solid</code>.'
)


def fix_content(text: str) -> str:
    updated = VARIANT_PROSE.sub(VARIANT_PROSE_REPL, text)

    def repl_matrix(m: re.Match) -> str:
        host = m.group(0).split("<code")[1].split(">")[1].split()[0]
        return MATRIX_PROSE_REPL.format(host=host)

    updated = MATRIX_PROSE.sub(repl_matrix, updated)
    return updated


def main() -> int:
    roots = [Path(p) for p in sys.argv[1:]]
    changed = 0
    for root in roots:
        for path in root.rglob("*"):
            if path.suffix not in {".heex", ".ex"} or not path.is_file():
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

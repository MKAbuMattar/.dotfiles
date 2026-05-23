#!/usr/bin/env python3
"""Convert the dotfiles markdown man-pages under ``.docs/`` into roff (groff_man)
format under ``.man/man{1,7}/`` so that ``man <name>`` and ``apropos`` work.

Pure stdlib. Markdown subset covered: ATX headings, bold/italic/code, fenced
code blocks, GFM pipe tables, bullet lists, and inline links.

Usage:
    python3 .scripts/build-man-pages.py            # build all
    python3 .scripts/build-man-pages.py --clean    # wipe .man/ first
"""

from __future__ import annotations

import argparse
import datetime
import logging
import re
import shutil
import sys
from dataclasses import dataclass
from pathlib import Path

logger = logging.getLogger(__name__)

SCRIPT_DIR = Path(__file__).resolve().parent
DOTFILES_ROOT = SCRIPT_DIR.parent
DOCS_DIR = DOTFILES_ROOT / ".docs"
MAN_DIR = DOTFILES_ROOT / ".man"

MAN_DATE = datetime.date.today().strftime("%B %Y")
MAN_SOURCE = "Dotfiles"
MAN_MANUAL = "Dotfiles Reference Manual"


@dataclass(frozen=True)
class Job:
    """One markdown source mapped to its target man page."""

    md_path: Path
    section: int
    page_name: str

    @property
    def output_path(self) -> Path:
        return MAN_DIR / f"man{self.section}" / f"{self.page_name}.{self.section}"


def discover_jobs() -> list[Job]:
    """Walk ``.docs/`` and produce the build job list."""
    jobs: list[Job] = []

    # Python plugins → section 1 (executable commands)
    for md in sorted((DOCS_DIR / "plugins" / "python").glob("*.md")):
        jobs.append(Job(md, 1, md.stem))

    # setup script → section 1
    setup_md = DOTFILES_ROOT / "setup.md"
    if setup_md.exists():
        jobs.append(Job(setup_md, 1, "setup"))

    # Zsh aliases / utils / plugins / zsh-core → section 7 (conventions / config)
    for category, suffix in [
        ("aliases", "-aliases"),
        ("utils", "-utils"),
        ("plugins/zsh", "-plugin"),
        ("zsh-core", ""),
    ]:
        for md in sorted((DOCS_DIR / category).glob("*.md")):
            jobs.append(Job(md, 7, md.stem + suffix))

    return jobs


# ----------------------------------------------------------------------------
# Markdown → roff conversion
# ----------------------------------------------------------------------------

INLINE_CODE_RE = re.compile(r"`([^`]+?)`")
BOLD_RE = re.compile(r"\*\*([^*]+?)\*\*")
ITALIC_RE = re.compile(r"(?<!\*)\*([^*\s][^*]*?)\*(?!\*)")
LINK_RE = re.compile(r"\[([^\]]+)\]\(([^)]+)\)")
HEADING_RE = re.compile(r"^(#{1,6})\s+(.*)$")
LIST_RE = re.compile(r"^(\s*)[-*]\s+(.*)$")
TABLE_DIV_RE = re.compile(r"^\s*\|?[-:\s|]+\|[-:\s|]+\|?\s*$")


def escape_roff_text(text: str) -> str:
    """Replace Unicode characters that don't survive roff with safe sequences."""
    text = text.replace("—", r"\(em")   # em-dash
    text = text.replace("–", r"\(en")   # en-dash
    text = text.replace("→", r"\(rA")   # rightwards arrow
    text = text.replace("←", r"\(lA")   # leftwards arrow
    text = text.replace("↑", r"\(ua")   # up arrow
    text = text.replace("↓", r"\(da")   # down arrow
    text = text.replace("✓", r"\(OK")   # checkmark
    text = text.replace("…", "...")     # ellipsis
    text = text.replace("‘", r"\(oq")   # left single quote
    text = text.replace("’", r"\(cq")   # right single quote
    text = text.replace("“", r"\(lq")   # left double quote
    text = text.replace("”", r"\(rq")   # right double quote
    return text


def render_inline(text: str) -> str:
    """Apply inline markdown formatting; Unicode normalization runs first so we
    never re-escape our own roff backslashes.

    If the rendered output starts with ``.`` or ``'``, prepend ``\\&`` so roff
    does not interpret it as a macro invocation (this matters because our docs
    sometimes start a bullet line with ``.docs/...``).
    """
    text = escape_roff_text(text)
    text = LINK_RE.sub(r"\1", text)  # drop URLs, keep label
    text = BOLD_RE.sub(lambda m: r"\fB" + m.group(1) + r"\fR", text)
    text = ITALIC_RE.sub(lambda m: r"\fI" + m.group(1) + r"\fR", text)
    text = INLINE_CODE_RE.sub(lambda m: r"\fB" + m.group(1) + r"\fR", text)
    if text[:1] in (".", "'"):
        text = r"\&" + text
    return text


def parse_name_line(name_line: str) -> tuple[str, str]:
    """Parse the standard ``**name** — description`` line under ``## NAME``."""
    line = name_line.strip()
    m = re.match(r"^\*\*([^*]+)\*\*\s*[—\-:]\s*(.*)$", line)
    if m:
        return m.group(1).strip(), m.group(2).strip()
    for sep in ("—", " - ", "-"):
        if sep in line:
            head, _, tail = line.partition(sep)
            return head.strip(" *"), tail.strip()
    return line.strip(" *"), ""


def strip_md(cell: str) -> str:
    """Strip the most common inline markdown so table cells render cleanly."""
    cell = INLINE_CODE_RE.sub(r"\1", cell)
    cell = BOLD_RE.sub(r"\1", cell)
    cell = LINK_RE.sub(r"\1", cell)
    return cell


def md_to_roff(md: str, page_name: str, section: int) -> str:
    """Convert a single markdown man-page into roff output."""
    lines = md.splitlines()
    out: list[str] = []

    name_field = page_name
    desc_field = ""
    for i, line in enumerate(lines):
        if line.strip().upper() == "## NAME":
            for nxt in lines[i + 1 : i + 6]:
                if nxt.strip():
                    name_field, desc_field = parse_name_line(nxt)
                    break
            break

    out.append(
        f'.TH "{page_name.upper()}" "{section}" "{MAN_DATE}" "{MAN_SOURCE}" "{MAN_MANUAL}"'
    )

    in_code = False
    in_table = False
    table_rows: list[list[str]] = []
    name_written = False

    def flush_table() -> None:
        nonlocal in_table, table_rows
        if not in_table:
            return
        out.append(".PP")
        out.append(".RS 2")
        out.append(".nf")
        out.append(".ft CR")
        widths = [0] * max(len(r) for r in table_rows)
        for row in table_rows:
            for j, cell in enumerate(row):
                widths[j] = max(widths[j], len(strip_md(cell)))
        for row in table_rows:
            padded = [strip_md(cell).ljust(widths[j]) for j, cell in enumerate(row)]
            line_out = "  ".join(padded).rstrip()
            out.append(escape_roff_text(line_out))
        out.append(".ft")
        out.append(".fi")
        out.append(".RE")
        in_table = False
        table_rows = []

    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.rstrip()

        if stripped.startswith("```"):
            if in_code:
                out.append(".ft")
                out.append(".fi")
                out.append(".RE")
                in_code = False
            else:
                flush_table()
                out.append(".PP")
                out.append(".RS 2")
                out.append(".nf")
                out.append(".ft CR")
                in_code = True
            i += 1
            continue

        if in_code:
            out.append(escape_roff_text(line))
            i += 1
            continue

        m = HEADING_RE.match(stripped)
        if m:
            flush_table()
            level = len(m.group(1))
            title = m.group(2).strip(" #")
            if level == 1:
                pass
            elif level == 2:
                section_name = title.upper()
                out.append(f".SH {section_name}")
                if section_name == "NAME" and not name_written:
                    out.append(
                        f"{escape_roff_text(name_field)} \\- {escape_roff_text(desc_field)}"
                    )
                    name_written = True
                    j = i + 1
                    while j < len(lines) and not lines[j].strip():
                        j += 1
                    if j < len(lines):
                        i = j
                    i += 1
                    continue
            else:
                out.append(f".SS {render_inline(title)}")
            i += 1
            continue

        if "|" in stripped and stripped.lstrip().startswith("|"):
            if TABLE_DIV_RE.match(stripped):
                i += 1
                continue
            cells = [c.strip() for c in stripped.strip().strip("|").split("|")]
            if not in_table:
                flush_table()
                in_table = True
            table_rows.append(cells)
            i += 1
            continue

        if in_table:
            flush_table()

        if stripped.startswith(">"):
            out.append(".PP")
            out.append(f".RS 2\n{render_inline(stripped.lstrip('> '))}\n.RE")
            i += 1
            continue

        m = LIST_RE.match(line)
        if m:
            out.append(".IP \\(bu 2")
            out.append(render_inline(m.group(2)))
            i += 1
            continue

        m = re.match(r"^\s*(\d+)\.\s+(.*)$", line)
        if m:
            out.append(f".IP {m.group(1)}. 4")
            out.append(render_inline(m.group(2)))
            i += 1
            continue

        if not stripped:
            out.append(".PP")
            i += 1
            continue

        out.append(render_inline(stripped))
        i += 1

    flush_table()
    if in_code:
        out.append(".ft")
        out.append(".fi")
        out.append(".RE")

    collapsed: list[str] = []
    for ln in out:
        if ln == ".PP" and collapsed and collapsed[-1] == ".PP":
            continue
        collapsed.append(ln)

    return "\n".join(collapsed) + "\n"


def build_one(job: Job) -> None:
    """Convert one job and write its roff output."""
    md = job.md_path.read_text(encoding="utf-8")
    roff = md_to_roff(md, job.page_name, job.section)
    job.output_path.parent.mkdir(parents=True, exist_ok=True)
    job.output_path.write_text(roff, encoding="utf-8")


def parse_args() -> argparse.Namespace:
    """Parse CLI arguments."""
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--clean", action="store_true", help="Remove .man/ before building")
    p.add_argument("-v", "--verbose", action="store_true", help="Print each page built")
    return p.parse_args()


def main() -> int:
    """Build all man pages from ``.docs/`` markdown sources."""
    args = parse_args()
    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format="%(message)s",
    )

    if args.clean and MAN_DIR.exists():
        logger.info("Cleaning %s", MAN_DIR)
        shutil.rmtree(MAN_DIR)

    jobs = discover_jobs()
    if not jobs:
        logger.error("No markdown sources found under %s", DOCS_DIR)
        return 1

    for job in jobs:
        try:
            build_one(job)
            logger.debug("built %s", job.output_path.relative_to(DOTFILES_ROOT))
        except OSError as e:
            logger.error("failed %s: %s", job.md_path, e)
            return 1

    by_section: dict[int, int] = {}
    for job in jobs:
        by_section[job.section] = by_section.get(job.section, 0) + 1
    summary = ", ".join(f"section {s}: {n}" for s, n in sorted(by_section.items()))
    logger.info("Built %d pages (%s) → %s", len(jobs), summary, MAN_DIR)
    return 0


if __name__ == "__main__":
    sys.exit(main())

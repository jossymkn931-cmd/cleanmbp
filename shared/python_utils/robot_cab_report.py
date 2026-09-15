#!/usr/bin/env python3
"""Generate a concise CAB-friendly HTML/PDF report from Robot output.xml.

Use :func:`generate_report` when calling this module from a Robot Framework
listener, or run the module as a command-line script.
"""

from __future__ import annotations

import argparse
import html
import re
import sys
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from datetime import datetime, timedelta
from pathlib import Path
from typing import Iterable


STATUS_COLORS = {
    "PASS": "#00A878",
    "FAIL": "#E63946",
    "SKIP": "#D97706",
    "ERROR": "#E63946",
    "UNKNOWN": "#64748B",
}


@dataclass
class TestResult:
    name: str
    status: str
    elapsed: float
    started: datetime | None = None
    message: str = ""


@dataclass
class SuiteResult:
    name: str
    tests: list[TestResult] = field(default_factory=list)

    @property
    def total(self) -> int:
        return len(self.tests)

    def count(self, status: str) -> int:
        return sum(test.status == status for test in self.tests)

    @property
    def elapsed(self) -> float:
        starts = [test.started for test in self.tests if test.started]
        ends = [test.started + timedelta(seconds=test.elapsed) for test in self.tests if test.started]
        if starts and ends:
            return max(0.0, (max(ends) - min(starts)).total_seconds())
        return sum(test.elapsed for test in self.tests)

    @property
    def status(self) -> str:
        return "FAIL" if self.count("FAIL") or self.count("ERROR") else "PASS"


@dataclass
class RunResult:
    name: str
    generator: str
    generated: datetime | None
    suites: list[SuiteResult]
    parser_warning: str = ""

    @property
    def tests(self) -> list[TestResult]:
        return [test for suite in self.suites for test in suite.tests]

    @property
    def total(self) -> int:
        return len(self.tests)

    def count(self, status: str) -> int:
        return sum(test.status == status for test in self.tests)

    @property
    def status(self) -> str:
        return "FAIL" if self.count("FAIL") or self.count("ERROR") else "PASS"

    @property
    def started(self) -> datetime | None:
        starts = [test.started for test in self.tests if test.started]
        return min(starts) if starts else self.generated

    @property
    def elapsed(self) -> float:
        timed = [test for test in self.tests if test.started]
        if timed:
            start = min(test.started for test in timed if test.started)
            end = max(test.started + timedelta(seconds=test.elapsed) for test in timed if test.started)
            return max(0.0, (end - start).total_seconds())
        return sum(test.elapsed for test in self.tests)

@dataclass
class ReportMetadata:
    run_id: str
    monorepo_name: str
    project: str
    run_command: str
    tags: str


def parse_datetime(value: str | None) -> datetime | None:
    if not value:
        return None
    normalized = value.strip().replace("Z", "+00:00")
    for fmt in (None, "%Y%m%d %H:%M:%S.%f", "%Y%m%d %H:%M:%S"):
        try:
            return datetime.fromisoformat(normalized) if fmt is None else datetime.strptime(normalized, fmt)
        except ValueError:
            continue
    return None


def normalize_status(value: str | None) -> str:
    status = (value or "UNKNOWN").upper()
    if status in {"NOT RUN", "NOT_RUN"}:
        return "SKIP"
    return status if status in STATUS_COLORS else "UNKNOWN"


def status_from_element(element: ET.Element | None) -> tuple[str, float, datetime | None, str]:
    if element is None:
        return "UNKNOWN", 0.0, None, ""
    attributes = element.attrib
    elapsed = float(attributes.get("elapsed", 0) or 0)
    started = parse_datetime(attributes.get("start") or attributes.get("starttime"))
    message = clean_message("".join(element.itertext()))
    return normalize_status(attributes.get("status")), elapsed, started, message


def parse_standard_xml(path: Path) -> RunResult:
    root = ET.parse(path).getroot()
    root_suite = root.find("./suite")
    if root_suite is None:
        raise ValueError("No root suite was found in the Robot output file")

    suites: list[SuiteResult] = []

    def visit(suite_element: ET.Element) -> None:
        tests = []
        for test_element in suite_element.findall("./test"):
            status, elapsed, started, message = status_from_element(test_element.find("./status"))
            tests.append(TestResult(
                name=test_element.get("name", "Unnamed test"),
                status=status,
                elapsed=elapsed,
                started=started,
                message=message,
            ))
        if tests:
            suites.append(SuiteResult(suite_element.get("name", "Unnamed suite"), tests))
        for child in suite_element.findall("./suite"):
            visit(child)

    visit(root_suite)
    return RunResult(
        name=root_suite.get("name", "Robot Framework Tests"),
        generator=root.get("generator", "Robot Framework"),
        generated=parse_datetime(root.get("generated")),
        suites=suites,
    )


ATTRIBUTE_RE = re.compile(r"([:\w.-]+)\s*=\s*([\"'])(.*?)\2", re.DOTALL)
STRUCTURE_RE = re.compile(r"<\s*(/?)\s*(suite|test)\b([^>]*)>", re.IGNORECASE)
STATUS_RE = re.compile(
    r"<status\b([^>]*)\s*/>|<status\b([^>]*)>(.*?)</status\s*>",
    re.IGNORECASE | re.DOTALL,
    )


def parse_attributes(text: str) -> dict[str, str]:
    return {match.group(1): html.unescape(match.group(3)) for match in ATTRIBUTE_RE.finditer(text)}


def clean_message(text: str, limit: int = 500) -> str:
    without_markup = re.sub(r"<[^>]+>", " ", text)
    normalized = " ".join(html.unescape(without_markup).split())
    if len(normalized) <= limit:
        return normalized
    return normalized[: limit - 3].rstrip() + "..."


def tolerant_test_result(source: str, open_tag_end: int) -> TestResult:
    close_at = source.find("</test", open_tag_end)
    block = source[open_tag_end:close_at if close_at >= 0 else len(source)]
    statuses = list(STATUS_RE.finditer(block))
    if not statuses:
        return TestResult("Unnamed test", "UNKNOWN", 0.0)
    final_status = statuses[-1]
    attributes = parse_attributes(final_status.group(1) or final_status.group(2) or "")
    message = clean_message(final_status.group(3) or "")
    try:
        elapsed = float(attributes.get("elapsed", 0) or 0)
    except ValueError:
        elapsed = 0.0
    return TestResult(
        name="Unnamed test",
        status=normalize_status(attributes.get("status")),
        elapsed=elapsed,
        started=parse_datetime(attributes.get("start") or attributes.get("starttime")),
        message=message,
    )


def parse_tolerant_xml(path: Path, original_error: Exception) -> RunResult:
    source = path.read_text(encoding="utf-8", errors="replace")
    root_match = re.search(r"<robot\b([^>]*)>", source, re.IGNORECASE)
    root_attributes = parse_attributes(root_match.group(1)) if root_match else {}

    # Raw HTML log messages can contain structural-looking tags. Removing the
    # message bodies protects the suite/test scan and also keeps details private.
    structure_source = re.sub(
        r"(<msg\b[^>]*>).*?(</msg\s*>)",
        r"\1\2",
        source,
        flags=re.IGNORECASE | re.DOTALL,
    )

    suite_stack: list[SuiteResult] = []
    suites: list[SuiteResult] = []
    root_name = "Robot Framework Tests"

    for match in STRUCTURE_RE.finditer(structure_source):
        closing, kind, raw_attributes = match.groups()
        kind = kind.lower()
        if kind == "suite":
            if closing:
                if suite_stack:
                    suite_stack.pop()
                continue
            attributes = parse_attributes(raw_attributes)
            suite = SuiteResult(attributes.get("name", "Unnamed suite"))
            if not suite_stack:
                root_name = suite.name
            suite_stack.append(suite)
            continue

        if kind == "test" and not closing and suite_stack:
            attributes = parse_attributes(raw_attributes)
            result = tolerant_test_result(structure_source, match.end())
            result.name = attributes.get("name", "Unnamed test")
            suite = suite_stack[-1]
            if not suite.tests:
                suites.append(suite)
            suite.tests.append(result)

    return RunResult(
        name=root_name,
        generator=root_attributes.get("generator", "Robot Framework"),
        generated=parse_datetime(root_attributes.get("generated")),
        suites=suites,
        parser_warning=(
            "The source XML was malformed, so detailed log content was ignored "
            f"and results were recovered using the tolerant parser ({original_error})."
        ),
    )


def parse_robot_output(path: Path) -> RunResult:
    try:
        return parse_standard_xml(path)
    except ET.ParseError as error:
        return parse_tolerant_xml(path, error)


def format_duration(seconds: float, precise: bool = False) -> str:
    if seconds < 60:
        return f"{seconds:.1f}s" if precise else f"{round(seconds):d}s"
    whole = int(seconds)
    hours, remainder = divmod(whole, 3600)
    minutes, secs = divmod(remainder, 60)
    parts = []
    if hours:
        parts.append(f"{hours}h")
    if minutes:
        parts.append(f"{minutes}m")
    if secs or not parts:
        parts.append(f"{secs}s")
    return " ".join(parts)


def format_datetime(value: datetime | None) -> str:
    if value is None:
        return "Not available"
    timezone = value.strftime(" %z") if value.tzinfo else ""
    return value.strftime("%d-%b-%Y %H:%M:%S") + timezone


def displayed_tests(suite: SuiteResult, detail: str) -> Iterable[TestResult]:
    if detail == "none":
        return []
    if detail == "failed":
        return [test for test in suite.tests if test.status in {"FAIL", "ERROR"}]
    return suite.tests


def html_report(run: RunResult, metadata: ReportMetadata, detail: str) -> str:
    def esc(value: object) -> str:
        return html.escape(str(value), quote=True)

    status_color = STATUS_COLORS[run.status]
    stat_items = [
        ("Total", run.total, "#334155"),
        ("Passed", run.count("PASS"), STATUS_COLORS["PASS"]),
        ("Failed", run.count("FAIL") + run.count("ERROR"), STATUS_COLORS["FAIL"]),
        ("Skipped", run.count("SKIP"), STATUS_COLORS["SKIP"]),
    ]
    stats = "".join(
        f'<div class="stat"><div class="stat-value" style="color:{color}">{value}</div>'
        f'<div class="stat-label">{label}</div></div>'
        for label, value, color in stat_items
    )
    suite_rows = "".join(
        "<tr>"
        f'<td><span class="status-dot" style="background:{STATUS_COLORS[suite.status]}"></span>{suite.status}</td>'
        f"<td>{esc(suite.name)}</td><td>{suite.total}</td>"
        f"<td class=passed>{suite.count('PASS')}</td>"
        f"<td class=failed>{suite.count('FAIL') + suite.count('ERROR')}</td>"
        f"<td class=skipped>{suite.count('SKIP')}</td>"
        f"<td>{format_duration(suite.elapsed)}</td></tr>"
        for suite in run.suites
    )

    details = []
    if detail != "none":
        for suite in run.suites:
            tests = list(displayed_tests(suite, detail))
            if not tests:
                continue
            test_rows = []
            for test in tests:
                failure = ""
                if test.status in {"FAIL", "ERROR"} and test.message:
                    failure = f'<div class="failure-message">{esc(test.message)}</div>'
                test_rows.append(
                    "<tr>"
                    f'<td><span class="status-dot" style="background:{STATUS_COLORS[test.status]}"></span>{test.status}</td>'
                    f"<td>{esc(test.name)}{failure}</td>"
                    f"<td>{format_duration(test.elapsed, precise=test.elapsed < 10)}</td></tr>"
                )
            details.append(
                f'<section class="suite-detail"><h2>Test Suite: {esc(suite.name)}</h2>'
                '<table><thead><tr><th>Status</th><th>Test case</th><th>Duration</th></tr></thead>'
                f"<tbody>{''.join(test_rows)}</tbody></table></section>"
            )

    return f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Test Automation Report - {esc(metadata.project)}</title>
<style>
@page {{ size: A4; margin: 16mm 14mm 18mm; @bottom-center {{ content: "Page " counter(page) " of " counter(pages); font: 9px Arial; color: #64748b; }} }}
* {{ box-sizing: border-box; }} body {{ margin:0; color:#263238; font-family:Arial,Helvetica,sans-serif; font-size:12px; line-height:1.35; }}
.page {{ max-width:900px; margin:0 auto; padding:28px; }} header {{ border-bottom:2px solid #1e3a5f; padding-bottom:12px; margin-bottom:22px; display:flex; justify-content:space-between; align-items:end; }}
.eyebrow {{ color:#2563eb; font-size:11px; font-weight:bold; letter-spacing:.08em; text-transform:uppercase; }} h1 {{ font-size:24px; margin:3px 0 0; color:#172033; }} h2 {{ font-size:15px; margin:27px 0 10px; color:#263238; }}
.run-status {{ color:{status_color}; font-size:15px; font-weight:bold; border:1px solid {status_color}; border-radius:18px; padding:6px 12px; }}
.metadata {{ display:grid; grid-template-columns:150px 1fr 150px 1fr; gap:7px 14px; margin-bottom:20px; }} .metadata .label {{ color:#64748b; }} .metadata .value {{ font-weight:600; overflow-wrap:anywhere; }}
.stats {{ display:grid; grid-template-columns:repeat(4,1fr); gap:10px; margin:18px 0 24px; }} .stat {{ border:1px solid #e2e8f0; border-radius:6px; padding:13px 15px; background:#f8fafc; }} .stat-value {{ font-size:23px; font-weight:bold; }} .stat-label {{ color:#64748b; margin-top:2px; }}
table {{ width:100%; border-collapse:collapse; table-layout:fixed; }} thead {{ display:table-header-group; }} th {{ background:#eef2f6; color:#475569; text-align:left; font-weight:bold; padding:7px 8px; border-bottom:1px solid #cbd5e1; }} td {{ padding:7px 8px; border-bottom:1px solid #e5e7eb; vertical-align:top; overflow-wrap:anywhere; }}
th:first-child,td:first-child {{ width:88px; }} th:last-child,td:last-child {{ width:78px; text-align:right; }} .status-dot {{ width:8px; height:8px; border-radius:50%; display:inline-block; margin-right:7px; }} .passed {{ color:#00875a; }} .failed {{ color:#d92d20; }} .skipped {{ color:#b45309; }}
.suite-detail {{ break-before:auto; }} .failure-message {{ color:#b42318; background:#fff1f0; border-left:3px solid #e63946; padding:5px 7px; margin-top:5px; font-size:10px; }}
.footer-note {{ margin-top:24px; padding-top:10px; border-top:1px solid #e2e8f0; color:#64748b; font-size:10px; }}
@media print {{ .page {{ padding:0; max-width:none; }} }}
</style></head><body><main class="page">
<header><div><div class="eyebrow">{esc(metadata.monorepo_name)}</div><h1>Test Automation Report</h1></div><div class="run-status">{run.status} — RUN {esc(metadata.run_id)}</div></header>
<section class="metadata">
<div class="label">Project</div><div class="value">{esc(metadata.project)}</div><div class="label">Run command</div><div class="value">{esc(metadata.run_command)}</div>
<div class="label">Tags</div><div class="value">{esc(metadata.tags)}</div><div class="label">Framework</div><div class="value">{esc(run.generator)}</div>
<div class="label">Started</div><div class="value">{esc(format_datetime(run.started))}</div><div class="label">Duration</div><div class="value">{format_duration(run.elapsed, precise=True)}</div>
</section>
<section class="stats">{stats}</section>
<section><h2>Test Suite Summary</h2><table><thead><tr><th>Status</th><th>Suite</th><th>Total</th><th>Passed</th><th>Failed</th><th>Skipped</th><th>Duration</th></tr></thead><tbody>{suite_rows}</tbody></table></section>
{''.join(details)}
<div class="footer-note">Generated from Robot Framework output.xml. Detailed keyword logs, requests, responses and stack traces are intentionally excluded from this CAB summary.</div>
</main></body></html>"""



def pdf_report(run: RunResult, metadata: ReportMetadata, detail: str, output_path: Path) -> None:
    try:
        from reportlab.lib import colors
        from reportlab.lib.enums import TA_RIGHT
        from reportlab.lib.pagesizes import A4
        from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
        from reportlab.lib.units import mm
        from reportlab.platypus import (
            BaseDocTemplate, Frame, PageTemplate, Paragraph, Spacer, Table, TableStyle,
        )
    except ImportError as error:
        raise RuntimeError("PDF output requires reportlab: pip install reportlab") from error

    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle(name="ReportTitle", parent=styles["Title"], fontName="Helvetica-Bold", fontSize=20, leading=23, textColor=colors.HexColor("#172033"), spaceAfter=2))
    styles.add(ParagraphStyle(name="Eyebrow", parent=styles["Normal"], fontName="Helvetica-Bold", fontSize=8, leading=10, textColor=colors.HexColor("#2563EB"), spaceAfter=2))
    styles.add(ParagraphStyle(name="Section", parent=styles["Heading2"], fontName="Helvetica-Bold", fontSize=12, leading=15, textColor=colors.HexColor("#263238"), spaceBefore=13, spaceAfter=7, keepWithNext=True))
    styles.add(ParagraphStyle(name="Cell", parent=styles["Normal"], fontName="Helvetica", fontSize=8.2, leading=10.2, textColor=colors.HexColor("#263238")))
    styles.add(ParagraphStyle(name="CellRight", parent=styles["Cell"], alignment=TA_RIGHT))
    styles.add(ParagraphStyle(name="Small", parent=styles["Normal"], fontName="Helvetica", fontSize=7.2, leading=9, textColor=colors.HexColor("#64748B")))
    styles.add(ParagraphStyle(name="Failure", parent=styles["Small"], textColor=colors.HexColor("#B42318"), backColor=colors.HexColor("#FFF1F0"), borderColor=colors.HexColor("#E63946"), borderWidth=0, borderPadding=(3, 4, 3, 5), spaceBefore=3))

    output_path.parent.mkdir(parents=True, exist_ok=True)
    doc = BaseDocTemplate(str(output_path), pagesize=A4, rightMargin=14*mm, leftMargin=14*mm, topMargin=19*mm, bottomMargin=16*mm, title=f"Test Automation Report - {metadata.project}", author="Robot Framework")
    frame = Frame(doc.leftMargin, doc.bottomMargin, doc.width, doc.height, id="content")

    def decorate_page(canvas, document):
        canvas.saveState()
        width, height = A4
        canvas.setStrokeColor(colors.HexColor("#1E3A5F"))
        canvas.setLineWidth(1)
        canvas.line(14*mm, height - 12*mm, width - 14*mm, height - 12*mm)
        canvas.setFont("Helvetica", 7.5)
        canvas.setFillColor(colors.HexColor("#64748B"))
        canvas.drawString(14*mm, 9*mm, "CAB Test Automation Summary")
        canvas.drawRightString(width - 14*mm, 9*mm, f"Page {document.page}")
        canvas.restoreState()

    doc.addPageTemplates([PageTemplate(id="main", frames=frame, onPage=decorate_page)])
    story = []
    header = Table([
        [Paragraph(html.escape(metadata.monorepo_name.upper()), styles["Eyebrow"]), ""],
        [Paragraph("Test Automation Report", styles["ReportTitle"]), Paragraph(f'<font color="{STATUS_COLORS[run.status]}"><b>{run.status} - RUN {html.escape(metadata.run_id)}</b></font>', styles["CellRight"])],
    ], colWidths=[doc.width*0.66, doc.width*0.34])
    header.setStyle(TableStyle([("VALIGN",(0,0),(-1,-1),"BOTTOM"), ("SPAN",(0,0),(1,0)), ("BOTTOMPADDING",(0,0),(-1,-1),2)]))
    story.extend([header, Spacer(1, 8)])

    meta_rows = [
        ["Project", metadata.project, "Run Command", metadata.run_command],
        ["Tags", metadata.tags, "Framework", run.generator],
        ["Started", format_datetime(run.started), "Duration", format_duration(run.elapsed, precise=True)],
    ]
    meta_data = [[Paragraph(f"<font color='#64748B'>{html.escape(str(cell))}</font>", styles["Cell"]) if index % 2 == 0 else Paragraph(f"<b>{html.escape(str(cell))}</b>", styles["Cell"]) for index, cell in enumerate(row)] for row in meta_rows]
    meta = Table(meta_data, colWidths=[24*mm, 62*mm, 24*mm, doc.width-110*mm])
    meta.setStyle(TableStyle([("VALIGN",(0,0),(-1,-1),"TOP"), ("LEFTPADDING",(0,0),(-1,-1),0), ("RIGHTPADDING",(0,0),(-1,-1),5), ("TOPPADDING",(0,0),(-1,-1),2), ("BOTTOMPADDING",(0,0),(-1,-1),3)]))
    story.extend([meta, Spacer(1, 8)])

    stats = [
        ("Total", run.total, "#334155"),
        ("Passed", run.count("PASS"), STATUS_COLORS["PASS"]),
        ("Failed", run.count("FAIL") + run.count("ERROR"), STATUS_COLORS["FAIL"]),
        ("Skipped", run.count("SKIP"), STATUS_COLORS["SKIP"]),
    ]
    stat_cells = [Paragraph(f'<font color="{color}" size="16"><b>{value}</b></font><br/><font color="#64748B" size="8">{label}</font>', styles["Cell"]) for label, value, color in stats]
    stat_table = Table([stat_cells], colWidths=[doc.width/4]*4)
    stat_table.setStyle(TableStyle([("BACKGROUND",(0,0),(-1,-1),colors.HexColor("#F8FAFC")), ("BOX",(0,0),(-1,-1),0.5,colors.HexColor("#CBD5E1")), ("INNERGRID",(0,0),(-1,-1),0.5,colors.HexColor("#E2E8F0")), ("LEFTPADDING",(0,0),(-1,-1),8), ("TOPPADDING",(0,0),(-1,-1),8), ("BOTTOMPADDING",(0,0),(-1,-1),8)]))
    story.extend([stat_table, Paragraph("Test Suite Summary", styles["Section"])])

    suite_data = [[Paragraph(f"<b>{x}</b>", styles["Cell"]) for x in ["Status","Suite","Total","Passed","Failed","Skipped","Duration"]]]
    for suite in run.suites:
        suite_data.append([
            Paragraph(f'<font color="{STATUS_COLORS[suite.status]}"><b>{suite.status}</b></font>', styles["Cell"]),
            Paragraph(html.escape(suite.name), styles["Cell"]),
            Paragraph(str(suite.total), styles["CellRight"]),
            Paragraph(str(suite.count("PASS")), styles["CellRight"]),
            Paragraph(str(suite.count("FAIL") + suite.count("ERROR")), styles["CellRight"]),
            Paragraph(str(suite.count("SKIP")), styles["CellRight"]),
            Paragraph(format_duration(suite.elapsed), styles["CellRight"]),
        ])
    suite_table = Table(suite_data, repeatRows=1, colWidths=[17*mm, doc.width-84*mm, 11*mm, 13*mm, 12*mm, 15*mm, 16*mm])
    suite_table.setStyle(TableStyle([("BACKGROUND",(0,0),(-1,0),colors.HexColor("#EEF2F6")), ("TEXTCOLOR",(0,0),(-1,0),colors.HexColor("#475569")), ("GRID",(0,0),(-1,-1),0.35,colors.HexColor("#D8DEE6")), ("VALIGN",(0,0),(-1,-1),"TOP"), ("LEFTPADDING",(0,0),(-1,-1),4), ("RIGHTPADDING",(0,0),(-1,-1),4), ("TOPPADDING",(0,0),(-1,-1),4), ("BOTTOMPADDING",(0,0),(-1,-1),4)]))
    story.append(suite_table)

    if detail != "none":
        for suite in run.suites:
            tests = list(displayed_tests(suite, detail))
            if not tests:
                continue
            story.append(Paragraph(f"Test Suite: {html.escape(suite.name)}", styles["Section"]))
            test_data = [[Paragraph("<b>Status</b>", styles["Cell"]), Paragraph("<b>Test case</b>", styles["Cell"]), Paragraph("<b>Duration</b>", styles["CellRight"])]]
            for test in tests:
                name_content = Paragraph(html.escape(test.name), styles["Cell"])
                if test.status in {"FAIL", "ERROR"} and test.message:
                    name_content = [name_content, Paragraph(html.escape(test.message), styles["Failure"])]
                test_data.append([
                    Paragraph(f'<font color="{STATUS_COLORS[test.status]}"><b>{test.status}</b></font>', styles["Cell"]),
                    name_content,
                    Paragraph(format_duration(test.elapsed, precise=test.elapsed < 10), styles["CellRight"]),
                ])
            test_table = Table(test_data, repeatRows=1, colWidths=[18*mm, doc.width-37*mm, 19*mm])
            test_table.setStyle(TableStyle([("BACKGROUND",(0,0),(-1,0),colors.HexColor("#EEF2F6")), ("TEXTCOLOR",(0,0),(-1,0),colors.HexColor("#475569")), ("GRID",(0,0),(-1,-1),0.35,colors.HexColor("#E5E7EB")), ("VALIGN",(0,0),(-1,-1),"TOP"), ("LEFTPADDING",(0,0),(-1,-1),4), ("RIGHTPADDING",(0,0),(-1,-1),4), ("TOPPADDING",(0,0),(-1,-1),4), ("BOTTOMPADDING",(0,0),(-1,-1),4)]))
            story.append(test_table)

    story.extend([Spacer(1, 12), Paragraph("Generated from Robot Framework output.xml. Detailed keyword logs, requests, responses and stack traces are intentionally excluded from this CAB summary.", styles["Small"])])
    doc.build(story)


def default_run_id(run: RunResult) -> str:
    stamp = run.generated or run.started
    return stamp.strftime("%Y%m%d-%H%M%S") if stamp else "N/A"


def generate_report(
        *, # make all arguments keyword-only (i.e. you can't pass arguments positionally, you must name them)
        input_path: str | Path,
        output_path: str | Path = "test-automation-report",
        output_format: str = "both",
        detail: str = "all",
        run_id: str | None = None,
        monorepo_name: str = "KCB GROUP",
        project: str | None = None,
        run_command: str | None = "Not specified",
        tags: str | None = "",
) -> list[Path]:
    """Generate report files and return the paths that were created.

    ``input_path`` should point to Robot Framework's ``output.xml``. The
    ``output_path`` may be a base path or a path ending in ``.html``/``.pdf``;
    its suffix is selected using ``output_format``.

    This function raises an exception if the source XML cannot be read or a
    requested report cannot be created, allowing a listener to decide whether
    report-generation failure should fail or only warn the overall run.
    """
    if output_format not in {"both", "html", "pdf"}:
        raise ValueError("output_format must be one of: both, html, pdf")
    if detail not in {"all", "failed", "none"}:
        raise ValueError("detail must be one of: all, failed, none")

    source = Path(input_path)
    if not source.is_file():
        raise FileNotFoundError(f"Robot Framework output file not found: {source}")

    run = parse_robot_output(source)
    metadata = ReportMetadata(
        run_id=run_id or default_run_id(run),
        monorepo_name=monorepo_name,
        project=project or run.name,
        run_command=run_command,
        tags=tags,
    )

    base = Path(output_path)
    if base.suffix.lower() in {".html", ".pdf"}:
        base = base.with_suffix("")

    created: list[Path] = []
    if output_format in {"both", "html"}:
        html_path = base.with_suffix(".html")
        html_path.parent.mkdir(parents=True, exist_ok=True)
        html_path.write_text(html_report(run, metadata, detail), encoding="utf-8")
        created.append(html_path)

    if output_format in {"both", "pdf"}:
        pdf_path = base.with_suffix(".pdf")
        pdf_report(run, metadata, detail, pdf_path)
        created.append(pdf_path)

    if run.parser_warning:
        print(f"Warning: {run.parser_warning}", file=sys.stderr)
    return created


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path, help="Robot Framework output.xml")
    parser.add_argument("--output", "-o", type=Path, default=Path("test-automation-report"), help="Output path without extension, or an .html/.pdf path")
    parser.add_argument("--format", choices=("both", "html", "pdf"), default="both")
    parser.add_argument("--detail", choices=("all", "failed", "none"), default="all", help="Test-case detail to include")
    parser.add_argument("--run-id")
    parser.add_argument("--monorepo-name", default="KCB GROUP")
    parser.add_argument("--project")
    parser.add_argument("--run-command", default="Not specified")
    parser.add_argument("--tags", default="")
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    try:
        created = generate_report(
            input_path=args.input,
            output_path=args.output,
            output_format=args.format,
            detail=args.detail,
            run_id=args.run_id,
            monorepo_name=args.monorepo_name,
            project=args.project,
            run_command=args.run_command,
            tags=args.tags,
        )
    except (OSError, RuntimeError, ValueError, ET.ParseError) as error:
        print(f"Unable to generate report: {error}", file=sys.stderr)
        return 2

    for path in created:
        print(f"Created: {path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

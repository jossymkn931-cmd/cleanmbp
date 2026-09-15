import sys
from pathlib import Path
from typing import Optional, Any


from python_utils.robot_cab_report import generate_report


def generate_pdf_report(self) -> Optional[Path]:
    if self.output_xml_path is None or not self.output_xml_path.is_file():
        return None

    try:
        return generate_report(
            input_path=self.output_xml_path,
            output_path=self.output_xml_path.parent / "pdf-report.pdf",
            output_format="pdf",
            detail="all",
            run_id=self.run_id,
            monorepo_name=self.monorepo_inventory.monorepoName,
            project=self.project,
            run_command=self.run_command,
            tags=self.tags,
        )[0]
    except Exception as error:
        print(f"PDF report generation failed: {error}", file=sys.stderr)
        return None

def update_test_result_counts(self, result: Any) -> \
        None:
    self.total_tests += 1

    if result.status == "PASS":
        self.passed_tests += 1
    elif result.status == "FAIL":
        self.failed_tests += 1
    elif result.status == "SKIP":
        self.skipped_tests += 1

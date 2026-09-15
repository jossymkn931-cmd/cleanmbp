# MBP UI Automation Monorepo

## Overview

Monorepo for MBP test automation, currently delivering web UI automation using Robot Framework and Browser Library (Playwright). The structure supports adding API and mobile automation in future iterations.

## Monorepo Structure

```
mbp/
├── projects/
│   └── mbp/
│       └── web/                    # Web UI automation 
│           ├── resources/
│           │   ├── keywords/       # Page-specific keyword files
│           │   ├── locators/       # UI element selectors
│           │   └── variables/      # Environment configuration
│           ├── tests/
│           │   └── auth/           # Authentication test suites
│           ├── results/            # Test execution output
│           ├── robot.toml          # RobotCode profile config
│           └── pyproject.toml
├── shared/                         # Shared utilities and listeners
├── scripts/
│   ├── run.py                      # Monorepo test runner
│   └── clean_results.py            # Results cleanup
├── pyproject.toml                  # Root workspace config
└── Dockerfile
```

## Getting Started

### Prerequisites

- Python 3.11+
- uv (package manager)

### Installation

```bash
uv sync
```

### Initialize Browser Library

Run once after installation to download Playwright browser binaries:

```bash
uv run rfbrowser init
```

## Running Tests

Tests are executed via the monorepo runner script using the package name and environment profile:

```bash
# Run all tests against UAT
uv run python scripts/run.py mbp uat

# Run against SIT
uv run python scripts/run.py mbp sit

# Run against dev
uv run python scripts/run.py mbp dev

# With tag filter
uv run python scripts/run.py mbp uat --include smoke

# Run a specific test by name
uv run python scripts/run.py mbp uat --test "Admin Can Login Successfully"
```

### List Available Packages and Commands

```bash
uv run python scripts/run.py
```

## Tooling

- **Web Automation**: Robot Framework + Browser Library (Playwright)
- **Test Execution**: RobotCode CLI
- **Package Management**: uv

## Contributing

When adding new automation:

1. Follow the AAA (Arrange-Act-Assert) pattern in test cases
2. Place keywords in `resources/keywords/` with one file per page
3. Store all locators in `resources/locators/` — one file per page
4. Use environment-specific variables from `resources/variables/`


## Resources

- [Robot Framework Documentation](https://robotframework.org)
- [Browser Library Documentation](https://robotframework-browser.org/)
- [RobotCode Documentation](https://robotcode.io)
- [Browser Library Documentation](https://robotframework-browser.org/)
- [Playwright Documentation](https://playwright.dev)
- [RobotCode Documentation](https://robotcode.io/)
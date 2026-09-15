# MBP Web UI Automation

UI automation tests for the MBP admin portal using Robot Framework and Browser Library (Playwright).

## Structure

```
web/
├── resources/
│   ├── keywords/               - Page-specific keyword files
│   │   ├── common.robot        - Generic utilities (browser session, screenshots)
│   │   └── login.robot         - Login page keywords (Page Object Model)
│   ├── locators/               - UI element selectors
│   │   └── login.robot         - Login page locators
│   └── variables/              - Environment configuration
│       ├── dev.py
│       ├── sit.py
│       └── uat.py
├── tests/
│   └── auth/                   - Authentication test suites
│       └── login.robot
├── results/                    - Test execution output (gitignored)
├── robot.toml                  - RobotCode environment profiles
└── pyproject.toml
```

## Setup

### Prerequisites

- Python 3.11+
- uv (package manager)

### Installation

From the monorepo root:

```bash
uv sync
uv run rfbrowser init
```

`rfbrowser init` downloads Playwright browser binaries. Run this once after first install.

### Environment Configuration

Variable files in `resources/variables/` are gitignored to prevent credentials being committed. Copy the example files and fill in your credentials:

```bash
cp resources/variables/dev.example.py resources/variables/dev.py
cp resources/variables/sit.example.py resources/variables/sit.py
cp resources/variables/uat.example.py resources/variables/uat.py
```

Then fill in `ADMIN_USERNAME` and `ADMIN_PASSWORD` for each environment.

Example structure:

```python
# resources/variables/uat.py
BASE_URL = "https://app.mobile.uat.kcbgroup.com/uat02/boss/"
BROWSER = "chromium"
HEADLESS = True
DEFAULT_TIMEOUT = "40s"

ADMIN_USERNAME = ""
ADMIN_PASSWORD = ""
```

Available environments:
- `dev.py` - Development
- `sit.py` - System Integration Testing
- `uat.py` - User Acceptance Testing

## Running Tests

Run from the monorepo root using the runner script:

```bash
# Run all tests against UAT
uv run python scripts/run.py mbp uat

# Run against SIT
uv run python scripts/run.py mbp sit

# Run against dev
uv run python scripts/run.py mbp dev

# Filter by tag
uv run python scripts/run.py mbp uat --include smoke
uv run python scripts/run.py mbp uat --exclude negative
```

## Test Development

Tests follow the **AAA (Arrange-Act-Assert)** pattern.

### Browser Session Pattern

The suite opens one browser instance for all tests using Suite Setup/Teardown. Each test gets a fresh page via Test Teardown:

```robot
*** Settings ***
Suite Setup       Start Browser Session    ${BROWSER}    ${HEADLESS}    ${DEFAULT_TIMEOUT}
Suite Teardown    Close All Browsers
Test Teardown     Close Current Page
```

### Keywords Organization

- `resources/keywords/common.robot` - Browser session management, screenshots, generic utilities
- `resources/keywords/login.robot` - Login page interactions (Page Object Model)

### Locators

All selectors are centralized in `resources/locators/`. Update selectors in one place when the UI changes.

### Test Example

```robot
*** Test Cases ***
Admin Can Login Successfully
    [Documentation]    Verify that admin can successfully login to the admin portal
    [Tags]    smoke    auth    positive

    Open Login Page    ${BASE_URL}
    Enter Username    ${ADMIN_USERNAME}
    Enter Password    ${ADMIN_PASSWORD}
    Click Login Button
    Dashboard Should Be Displayed
```

## Resources

- [Robot Framework Documentation](https://robotframework.org)
- [Browser Library Documentation](https://robotframework-browser.org/)
- [Playwright Documentation](https://playwright.dev)

### Test Example

```robot
*** Settings ***
Library           Browser
Resource          ../../resources/pages/login_page.robot

*** Test Cases ***
Admin Can Login Successfully
    [Documentation]    Verify successful login
    [Tags]    smoke    auth
    
    # Arrange
    Open Login Page    ${BASE_URL}
    
    # Act
    Enter Username    ${ADMIN_USERNAME}
    Enter Password    ${ADMIN_PASSWORD}
    Click Login Button
    
    # Assert
    Dashboard Should Be Displayed
    Close All Browsers
```

### Locators

Locators are centralized in `resources/locators/` for easy maintenance:
- Update selectors in one place
- Support quick refactoring when UI changes

## Resources

- [Robot Framework Documentation](https://robotframework.org)
- [Browser Library Documentation](https://robotframework-browser.org/)
- [Playwright Documentation](https://playwright.dev)

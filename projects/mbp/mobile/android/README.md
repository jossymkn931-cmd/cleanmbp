# MBP Mobile (Android) Automation

UI automation for the KCB Mobile Banking Android app using Robot Framework, AppiumLibrary
and the UiAutomator2 driver.

## Structure

```
android/
├── apps/                       - APK under test
├── resources/
│   ├── Keywords/
│   │   ├── common.robot        - Session helpers, screenshot-on-failure
│   │   ├── login.robot         - Saved-number login, PIN entry, balance reveal
│   │   └── send_money.robot    - Send to Mobile transfer flow
│   ├── locators/
│   │   ├── login_locators.robot
│   │   └── send_money_locators.robot
│   └── variables/              - Per-environment configuration
│       ├── dev.py
│       ├── sit.py
│       └── uat.py
├── tests/
│   ├── auth/
│   │   ├── launch.robot        - App launch smoke test
│   │   └── login.robot         - Login and balance tests
│   └── payments/
│       └── send_to_mobile.robot - End-to-end Send to Self transfer
├── results/                    - Test output (gitignored)
├── robot.toml                  - RobotCode profiles (used by the VS Code extension)
└── pyproject.toml              - Dependencies and monorepo run commands
```

## Prerequisites

| Tool | Notes |
| --- | --- |
| Python 3.11+ | The monorepo venv is created by `uv`. |
| uv | Package manager for the whole monorepo. |
| Node.js | Required by Appium. |
| Appium 2.x | `npm install -g appium` |
| UiAutomator2 driver | `appium driver install uiautomator2` |
| Android platform-tools | Provides `adb`. |
| JDK 17 | Required by the UiAutomator2 driver. |

Environment variables that must be set for the Appium server process:

```powershell
$env:JAVA_HOME    = "C:\Program Files\Microsoft\jdk-17.0.19.10-hotspot"
$env:ANDROID_HOME = "C:\Users\<you>\AppData\Local\Microsoft\WinGet\Packages\Google.PlatformTools_Microsoft.Winget.Source_8wekyb3d8bbwe"
```

`adb` lives in `$env:ANDROID_HOME\platform-tools\adb.exe` and is not on `PATH` by default.

## Device setup

On the physical device (Xiaomi / MIUI / HyperOS), enable all three:

- Developer options → **USB debugging**
- Developer options → **Install via USB**
- Developer options → **USB debugging (Security settings)**

Confirm the device is visible and note its UDID:

```powershell
& "$env:ANDROID_HOME\platform-tools\adb.exe" devices -l
```

Put that UDID into `DEVICE_NAME` and `UDID` in the relevant `resources/variables/*.py`.

## Installation

From the monorepo root (`mbp/`):

```powershell
uv sync
```

If `uv sync` fails with `os error 396` (incompatible hardlinks, typical for
OneDrive-backed folders), use copy mode:

```powershell
$env:UV_LINK_MODE = "copy"
uv sync
```

This creates a single shared virtual environment at `mbp/.venv` for the whole
monorepo. The android folder does **not** get its own `.venv`.

## Running tests

Start the Appium server in its own terminal:

```powershell
appium
```

Then run from the **monorepo root** (`mbp/`):

```powershell
# All android tests against SIT
uv run robot-runner mbp-mobile-android sit

# Other environments
uv run robot-runner mbp-mobile-android dev
uv run robot-runner mbp-mobile-android uat

# Filter by tag
uv run robot-runner mbp-mobile-android sit --include smoke
uv run robot-runner mbp-mobile-android sit --include payments
uv run robot-runner mbp-mobile-android sit --exclude negative

# Run a single suite or test
uv run robot-runner mbp-mobile-android sit --test "User Can Login Successfully"
```

List every available package and command:

```powershell
uv run robot-runner
```

### Why it must be run from the root

`uv run` uses the environment belonging to the nearest uv project. `projects/mbp` is a
workspace member and resolves to the shared `mbp/.venv`, but `projects/mbp/mobile/android`
sits *inside* another member, so uv does not treat it as one — running `uv run` from the
android folder creates a throwaway local `.venv` and fails with
`Failed to spawn: robot-runner`. Run from the monorepo root instead.

The runner itself still discovers the android project, because it reads
`[tool.uv.workspace].members` directly rather than asking uv.

### Running RobotCode directly

`robot.toml` defines `dev` / `sit` / `uat` profiles for the VS Code RobotCode extension and
for direct invocation from this folder:

```powershell
cd projects\mbp\mobile\android
..\..\..\..\.venv\Scripts\robotcode.exe --profile sit robot tests
```

Note that `--profile` is a *global* robotcode option and must appear before the
`robot` / `run` subcommand.

## How the run commands are wired

`pyscripts` exposes a `robot-runner` entry point. It reads
`[tool.uv.workspace].members` from the monorepo root, then looks for
`[tool.monorepo.commands]` in each member's `pyproject.toml` and executes the named
command with that member's folder as the working directory.

For this project ([pyproject.toml](pyproject.toml)):

```toml
[tool.monorepo.commands]
sit = ["robotcode", "run", "--variablefile", "resources/variables/sit.py", "tests"]
```

Extra CLI arguments are inserted immediately after `run`, which is why the environment is
selected with `--variablefile` rather than the global `--profile` option.

## Environment configuration

Each file in `resources/variables/` must define the full set below, because the suites read
them at import time:

```python
APPIUM_HOST = "127.0.0.1"
APPIUM_PORT = "4723"
APPIUM_SERVER_URL = f"http://{APPIUM_HOST}:{APPIUM_PORT}"

PLATFORM_NAME = "Android"
PLATFORM_VERSION = ""

DEVICE_NAME = "<udid>"
UDID = "<udid>"

APP_PACKAGE = "com.kcb.mobilebanking.sit"
APP_ACTIVITY = "com.murong.bank.SplashActivity"
APP_WAIT_ACTIVITY = "com.murong.*"
AUTOMATION_NAME = "UiAutomator2"

MOBILE_PIN = "<pin>"
```

Test suites deliberately do **not** import a variable file, so the environment is chosen
entirely by the run command.

## App structure notes

The app moves through three activities:

| Screen | Activity |
| --- | --- |
| Splash | `com.murong.bank.SplashActivity` |
| Saved number | `com.murong.login.history.LoginHistoryActivity` |
| Login PIN | `com.murong.login.password.LoginPasswordActivity` |
| Dashboard and everything after it | `com.murong.web.vue.VueActivity` |

`VueActivity` is a Vue WebView. The dashboard, the transfer form, the confirmation sheet and
the receipt are all rendered inside it, so the activity never changes during a payment.

## Locator conventions and gotchas

These were all confirmed against the live app and are easy to get wrong.

**Use Appium's page source, not `adb shell uiautomator dump`.**
`uiautomator dump` omits nodes that are not flagged important-for-accessibility, which hides
every WebView CTA button (`makePayment`, `continue`, `cancel`). Only Appium's `Get Source`
shows them.

**Never use `id=` for a WebView element.**
AppiumLibrary's `id` strategy prefixes the app package, producing
`com.kcb.mobilebanking.sit:id/ion-input-0`, which can never match an HTML id. Use
`xpath=//*[@resource-id='ion-input-0']` instead.

**`Format String` uses `{}`, not `%s`.**
The login keypad locator template is
`//*[@resource-id='...keyboard_password']//android.widget.TextView[@text='{}']`.

**`Click Element At Coordinates` does not exist.**
AppiumLibrary offers `tap`, `tap_with_number_of_taps` and `tap_with_positions`. Use
`Tap With Positions    200ms    ${{ ($x, $y) }}`.

**`cancel` sits directly below `continue` on the confirmation sheet.**
`continue` is `[82,2010][995,2134]`, `cancel` is `[82,2164][995,2288]`. Always target them by
accessibility id, never by position.

**The balance eye toggle has no id and moves.**
It shifts right as the amount widens, so it is located relative to the amount:
`//*[@resource-id='home-card']//android.widget.TextView[starts-with(@text, 'KES')]/following-sibling::android.view.View[1]`.

**The transaction PIN pad is invisible to Appium.**
The *login* PIN pad is exposed normally, but the *transaction* PIN pad is excluded from the
accessibility tree as anti-scraping hardening — `Get Source` returns the stale underlying form
while the pad is plainly visible on screen. It is therefore tapped by coordinates, expressed as
a fraction of the window so the mapping is not bound to one device:

| Column | x ratio |
| --- | --- |
| 1 / 4 / 7 | 0.190 |
| 2 / 5 / 8 / 0 | 0.500 |
| 3 / 6 / 9 | 0.810 |

| Row | y ratio |
| --- | --- |
| 1 2 3 | 0.537 |
| 4 5 6 | 0.631 |
| 7 8 9 | 0.726 |
| 0 | 0.820 |

The keyword sleeps 3s before the first tap. There is nothing to wait on, and a tap sent while
the pad is still sliding in is silently swallowed — the symptom is only three of the four PIN
dots filling.

## Test coverage

| Suite | Test | Notes |
| --- | --- | --- |
| `tests/auth/launch.robot` | Android App Can Launch | |
| `tests/auth/login.robot` | User Can Launch Login Screen | |
| | User Can Navigate To Pin Screen | |
| | User Can Login Successfully | PIN auto-submits on the 4th digit |
| | User Can Reveal Account Balance | Taps the eye toggle and asserts the amount is unmasked |
| | User Cannot Login With Invalid Pin | Tagged `lockout`, see the warning below |
| `tests/payments/send_to_mobile.robot` | User Can Send Money To Self Via Mobile | Executes a real transfer |

### PIN lockout warning

`User Cannot Login With Invalid Pin` deliberately submits a wrong PIN, and the app responds
with *"You have entered the wrong KCB Mobile Banking PIN. Please try again, you have N
attempts remaining."* Every run consumes one attempt and will eventually lock the account.

It is tagged `lockout` and excluded from `smoke` for that reason. To skip it explicitly:

```powershell
uv run robot-runner mbp-mobile-android sit --exclude lockout
```

### Test isolation

The suites open a single Appium session in `Suite Setup`, so `Test Setup    Restart Application`
terminates and relaunches the app before each test. Without it, every test resumed wherever
the previous one stopped and only the first would pass.

### Send to Mobile flow

Dashboard tile → transfer-type sheet → **Send to Self** tab → amount → **Make Payment** →
**Confirm Summary** → **Continue** → transaction PIN → receipt.

The receipt is asserted on transaction status `In Processing`, a non-empty MBP reference
number, the principal amount, and the presence of the `done` button.

The transfer is asynchronous: the app only acknowledges receipt. Final settlement arrives
later by SMS and is out of scope. In SIT that SMS often reports a failure even though the app
accepted the request.

## Known issues

- **`Tap With Positions` deprecation warning** about integer millisecond durations is emitted
  by AppiumLibrary and is harmless.

"""Money parsing and arithmetic for financial assertions.

Amounts are handled as integer minor units (cents) so comparisons are exact.
Floats are never used: 0.1 + 0.2 != 0.3 in binary floating point, which would
otherwise produce phantom one-cent failures on a correctly behaving system.
"""

import re
from decimal import Decimal, InvalidOperation

from robot.api.deco import keyword


MINOR_UNITS_PER_MAJOR = 100

# Matches the numeric part of "KES 1,234.56", "1234", "(1,234.56)" or "-50.00".
_AMOUNT_PATTERN = re.compile(r"-?\d{1,3}(?:,\d{3})*(?:\.\d+)?|-?\d+(?:\.\d+)?")


@keyword("Parse Money")
def parse_money(text: str, currency: str = "KES") -> int:
    """Convert a displayed amount into integer minor units."""

    if text is None:
        raise AssertionError("Cannot parse money from an empty value.")

    raw = str(text).strip()

    if not raw:
        raise AssertionError("Cannot parse money from an empty value.")

    if "*" in raw:
        raise AssertionError(
            f"Amount is still masked and cannot be parsed: '{raw}'. "
            "Reveal the balance before reading it."
        )

    # Accounting notation: parentheses denote a negative amount.
    is_bracketed_negative = raw.startswith("(") and raw.endswith(")")
    body = raw[1:-1].strip() if is_bracketed_negative else raw

    if currency:
        body = re.sub(re.escape(currency), "", body, flags=re.IGNORECASE)

    # Removing the currency can leave the sign detached, as in "- 50.00".
    body = re.sub(r"\s+", "", body)

    match = _AMOUNT_PATTERN.search(body)

    if not match:
        raise AssertionError(f"No numeric amount found in '{raw}'.")

    digits = match.group(0).replace(",", "")

    try:
        amount = Decimal(digits)
    except InvalidOperation as error:
        raise AssertionError(f"Could not parse '{raw}' as an amount.") from error

    exponent = amount.as_tuple().exponent

    if isinstance(exponent, int) and exponent < -2:
        raise AssertionError(
            f"Amount '{raw}' has more precision than minor units allow. "
            "Refusing to round a financial value."
        )

    minor_units = int(amount.scaleb(2).to_integral_exact())

    return -minor_units if is_bracketed_negative else minor_units


@keyword("Format Money")
def format_money(minor_units: int, currency: str = "KES") -> str:
    """Render integer minor units back into a readable amount for messages."""

    units = int(minor_units)
    sign = "-" if units < 0 else ""
    major, minor = divmod(abs(units), MINOR_UNITS_PER_MAJOR)
    prefix = f"{currency} " if currency else ""

    return f"{sign}{prefix}{major:,}.{minor:02d}"


@keyword("Add Money")
def add_money(*amounts: int) -> int:
    """Sum amounts already expressed in minor units."""

    return sum(int(amount) for amount in amounts)


@keyword("Subtract Money")
def subtract_money(minuend: int, subtrahend: int) -> int:
    """Subtract two amounts expressed in minor units."""

    return int(minuend) - int(subtrahend)


@keyword("Money Delta")
def money_delta(before: int, after: int) -> int:
    """Return the signed movement between two balances in minor units."""

    return int(after) - int(before)


@keyword("Money Should Be Equal")
def money_should_be_equal(actual: int, expected: int, message: str = "") -> None:
    """Assert two amounts in minor units match exactly."""

    actual_units = int(actual)
    expected_units = int(expected)

    if actual_units != expected_units:
        detail = f" {message}" if message else ""
        raise AssertionError(
            f"Expected {format_money(expected_units)} "
            f"but was {format_money(actual_units)}.{detail}"
        )


@keyword("Money Should Be Debit Of")
def money_should_be_debit_of(delta: int, expected_debit: int, message: str = "") -> None:
    """Assert a balance movement is a debit of exactly the expected amount."""

    delta_units = int(delta)
    expected_units = abs(int(expected_debit))

    if delta_units >= 0:
        detail = f" {message}" if message else ""
        raise AssertionError(
            f"Expected a debit of {format_money(expected_units)} but the balance "
            f"moved by {format_money(delta_units)}, which is not a debit.{detail}"
        )

    money_should_be_equal(-delta_units, expected_units, message)


@keyword("Money Should Be Credit Of")
def money_should_be_credit_of(delta: int, expected_credit: int, message: str = "") -> None:
    """Assert a balance movement is a credit of exactly the expected amount."""

    delta_units = int(delta)
    expected_units = abs(int(expected_credit))

    if delta_units <= 0:
        detail = f" {message}" if message else ""
        raise AssertionError(
            f"Expected a credit of {format_money(expected_units)} but the balance "
            f"moved by {format_money(delta_units)}, which is not a credit.{detail}"
        )

    money_should_be_equal(delta_units, expected_units, message)


@keyword("Postings Should Balance")
def postings_should_balance(debits: list, credits: list) -> None:
    """Assert total debits equal total credits, so no money is created or lost."""

    total_debits = add_money(*debits)
    total_credits = add_money(*credits)

    if total_debits != total_credits:
        raise AssertionError(
            f"Postings do not balance: debits {format_money(total_debits)} "
            f"against credits {format_money(total_credits)}, "
            f"a difference of {format_money(total_debits - total_credits)}."
        )

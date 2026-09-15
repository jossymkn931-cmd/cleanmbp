from pathlib import Path

from PIL import Image


# The login error is visible on screen but absent from Android's accessibility
# hierarchy, so Appium cannot locate its text. This checks only that the error
# banner is displayed; it does not perform OCR or validate the message wording.
def login_error_banner_should_be_visible(screenshot_path: str) -> None:
    image_path = Path(screenshot_path)
    if not image_path.is_file():
        raise AssertionError(f"Screenshot does not exist: {image_path}")

    with Image.open(image_path) as screenshot:
        image = screenshot.convert("RGB")
        region = image.crop((0, int(image.height * 0.08), image.width, int(image.height * 0.28)))

    pink_pixels = 0
    red_pixels = 0
    for red, green, blue in region.get_flattened_data():
        pink_pixels += red >= 245 and 205 <= green <= 245 and 210 <= blue <= 250
        red_pixels += red >= 210 and green <= 160 and blue <= 170

    pixel_count = region.width * region.height
    pink_ratio = pink_pixels / pixel_count
    red_ratio = red_pixels / pixel_count
    if pink_ratio < 0.15 or red_ratio < 0.003:
        raise AssertionError(
            "Login error banner is not visible "
            f"(pink ratio={pink_ratio:.3f}, red ratio={red_ratio:.3f})"
        )
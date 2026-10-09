"""Export the configured portrait to Android launcher assets. Requires Pillow.

The original vector mark remains available for small notification icons.
"""
from pathlib import Path
from PIL import Image, ImageOps

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / 'assets' / 'branding'
RES = ROOT / 'android/app/src/main/res'
SOURCE = ASSETS / 'launcher-source.png'

with Image.open(SOURCE) as original:
    portrait = ImageOps.exif_transpose(original).convert('RGBA')
    portrait = ImageOps.fit(portrait, (1024, 1024), method=Image.Resampling.LANCZOS)

portrait.save(ASSETS / 'zhouji-icon.png')
for density, size in [('mdpi', 48), ('hdpi', 72), ('xhdpi', 96), ('xxhdpi', 144), ('xxxhdpi', 192)]:
    folder = RES / ('mipmap-' + density)
    folder.mkdir(parents=True, exist_ok=True)
    portrait.resize((size, size), Image.Resampling.LANCZOS).save(folder / 'ic_launcher.png')

# The visible image occupies the central 72dp of Android's 108dp adaptive
# canvas. This avoids enlarging the face when launchers apply their masks.
foreground = Image.new('RGBA', (432, 432))
foreground.alpha_composite(portrait.resize((288, 288), Image.Resampling.LANCZOS), (72, 72))
foreground_folder = RES / 'drawable-nodpi'
foreground_folder.mkdir(parents=True, exist_ok=True)
foreground.save(foreground_folder / 'ic_launcher_portrait.png')

(RES / 'values/icon_colors.xml').write_text(
    '<resources><color name="ic_launcher_background">#D9D9F3</color></resources>\n', encoding='utf-8')
for version in ['v26', 'v33']:
    folder = RES / ('mipmap-anydpi-' + version)
    folder.mkdir(parents=True, exist_ok=True)
    (folder / 'ic_launcher.xml').write_text('''<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
<background android:drawable="@color/ic_launcher_background"/>
<foreground android:drawable="@drawable/ic_launcher_portrait"/>
</adaptive-icon>
''', encoding='utf-8')
print('Generated portrait preview, five launcher densities and adaptive icons.')

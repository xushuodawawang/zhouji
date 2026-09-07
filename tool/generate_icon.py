"""Export the original Zhouji vector mark to Android launcher assets. Requires Pillow."""
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / 'assets' / 'branding'
RES = ROOT / 'android/app/src/main/res'
ASSETS.mkdir(parents=True, exist_ok=True)
GREEN, CREAM, GOLD = '#176B5B', '#F5F8EE', '#E9C978'
SVG = '''<svg xmlns="http://www.w3.org/2000/svg" width="108" height="108" viewBox="0 0 108 108">
<rect width="108" height="108" rx="28" fill="#176B5B"/>
<g fill="none" stroke="#F5F8EE" stroke-width="6" stroke-linecap="round" stroke-linejoin="round">
<rect x="27" y="30" width="54" height="51" rx="12"/>
<path d="M40 24V36 M68 24V36 M39 51H67L41 68H60"/>
</g><circle cx="70" cy="68" r="4" fill="#E9C978"/></svg>
'''
(ASSETS / 'zhouji.svg').write_text(SVG, encoding='utf-8')

def render(size):
    scale = 12
    image = Image.new('RGBA', (108 * scale, 108 * scale))
    draw = ImageDraw.Draw(image)
    def box(coords):
        return tuple(round(v * scale) for v in coords)
    draw.rounded_rectangle(box((0, 0, 108, 108)), 28 * scale, fill=GREEN)
    # Pillow strokes sit inside their bounds; expand half a stroke to match SVG.
    draw.rounded_rectangle(box((24, 27, 84, 84)), 15 * scale, fill=CREAM)
    draw.rounded_rectangle(box((30, 33, 78, 78)), 9 * scale, fill=GREEN)
    for points in [[(40, 24), (40, 36)], [(68, 24), (68, 36)], [(39, 51), (67, 51), (41, 68), (60, 68)]]:
        draw.line([(x * scale, y * scale) for x, y in points], fill=CREAM, width=6 * scale, joint='curve')
        for x, y in points:
            draw.ellipse(box((x-3, y-3, x+3, y+3)), fill=CREAM)
    draw.ellipse(box((66, 64, 74, 72)), fill=GOLD)
    return image.resize((size, size), Image.Resampling.LANCZOS)

render(1024).save(ASSETS / 'zhouji-icon.png')
for density, size in [('mdpi', 48), ('hdpi', 72), ('xhdpi', 96), ('xxhdpi', 144), ('xxxhdpi', 192)]:
    folder = RES / ('mipmap-' + density)
    folder.mkdir(exist_ok=True)
    render(size).save(folder / 'ic_launcher.png')

vector = '''<vector xmlns:android="http://schemas.android.com/apk/res/android" android:width="108dp" android:height="108dp" android:viewportWidth="108" android:viewportHeight="108">
<group android:pivotX="54" android:pivotY="54" android:scaleX="0.84" android:scaleY="0.84">
<path android:fillColor="#00000000" android:strokeColor="#F5F8EE" android:strokeWidth="6" android:strokeLineCap="round" android:strokeLineJoin="round" android:pathData="M39,30 H69 Q81,30 81,42 V69 Q81,81 69,81 H39 Q27,81 27,69 V42 Q27,30 39,30 Z M40,24 V36 M68,24 V36 M39,51 H67 L41,68 H60"/>
<path android:fillColor="#E9C978" android:pathData="M66,68 a4,4 0,1 0,8 0 a4,4 0,1 0,-8 0"/>
</group></vector>
'''
(RES / 'drawable/ic_launcher_foreground.xml').write_text(vector, encoding='utf-8')
(RES / 'values/icon_colors.xml').write_text('<resources><color name="ic_launcher_background">#176B5B</color></resources>\n', encoding='utf-8')
for version in ['v26', 'v33']:
    folder = RES / ('mipmap-anydpi-' + version)
    folder.mkdir(exist_ok=True)
    mono = '\n<monochrome android:drawable="@drawable/ic_launcher_foreground"/>' if version == 'v33' else ''
    (folder / 'ic_launcher.xml').write_text('''<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
<background android:drawable="@color/ic_launcher_background"/>
<foreground android:drawable="@drawable/ic_launcher_foreground"/>''' + mono + '\n</adaptive-icon>\n', encoding='utf-8')
print('Generated SVG, 1024px preview, five launcher densities and adaptive icons.')

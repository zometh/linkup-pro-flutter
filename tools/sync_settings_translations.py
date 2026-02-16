import re
import json
from pathlib import Path

root = Path(__file__).resolve().parent.parent
assets = root / 'assets' / 'translations'
settings_file = root / 'lib' / 'features' / 'settings' / 'presentation' / 'pages' / 'settings_page.dart'

en_file = assets / 'en.json'
fr_file = assets / 'fr.json'
ar_file = assets / 'ar.json'

# load translations
with en_file.open('r', encoding='utf-8') as f:
    en = json.load(f)
with fr_file.open('r', encoding='utf-8') as f:
    fr = json.load(f)
with ar_file.open('r', encoding='utf-8') as f:
    ar = json.load(f)

# extract keys from settings_page.dart
text = settings_file.read_text(encoding='utf-8')
# find patterns like 'key'.tr() and "key".tr()
keys = set()
for m in re.finditer(r"['\"]([a-zA-Z0-9_\- ]+)['\"]\s*\.tr\(\)", text):
    keys.add(m.group(1))
# Also find keys used in Text('logout'.tr()) or similar (covered)
# Also some keys might be used in code without .tr(), ignore those

print('Found keys in settings_page.dart:', keys)

# add missing keys to each language
added_fr = []
added_ar = []
added_en = []
for k in sorted(keys):
    if k not in en:
        en[k] = k
        added_en.append(k)
    if k not in fr:
        fr[k] = en.get(k, k)
        added_fr.append(k)
    if k not in ar:
        ar[k] = en.get(k, k)
        added_ar.append(k)

# write back (preserve order by writing en order then extras)
# We'll append additions at end (simple)
with en_file.open('w', encoding='utf-8') as f:
    json.dump(en, f, ensure_ascii=False, indent=2)
with fr_file.open('w', encoding='utf-8') as f:
    json.dump(fr, f, ensure_ascii=False, indent=2)
with ar_file.open('w', encoding='utf-8') as f:
    json.dump(ar, f, ensure_ascii=False, indent=2)

print('Added to en:', added_en)
print('Added to fr:', added_fr)
print('Added to ar:', added_ar)


import re
import json
from pathlib import Path

root = Path(__file__).resolve().parent.parent
assets = root / 'assets' / 'translations'
settings_file = root / 'lib' / 'features' / 'settings' / 'presentation' / 'pages' / 'settings_page.dart'

en_file = assets / 'en.json'
fr_file = assets / 'fr.json'
ar_file = assets / 'ar.json'

with settings_file.open('r', encoding='utf-8') as f:
    text = f.read()

keys = set()
for m in re.finditer(r"['\"]([a-zA-Z0-9_ \-]+)['\"]\s*\.tr\(\)", text):
    keys.add(m.group(1))

# also detect direct Text('...'.tr()) already covered

print('Keys found in settings_page.dart:', keys)

with en_file.open('r', encoding='utf-8') as f:
    en = json.load(f)
with fr_file.open('r', encoding='utf-8') as f:
    fr = json.load(f)
with ar_file.open('r', encoding='utf-8') as f:
    ar = json.load(f)

missing = {'en': [], 'fr': [], 'ar': []}
for k in sorted(keys):
    if k not in en:
        missing['en'].append(k)
    if k not in fr:
        missing['fr'].append(k)
    if k not in ar:
        missing['ar'].append(k)

print('\nMissing keys:')
for lang, arr in missing.items():
    print(f'{lang}: {len(arr)} -> {arr}')

# print values for sample keys
for k in ['change_password', 'help_support', 'logout', 'app_version']:
    print('\nSample values for', k)
    print('en:', en.get(k))
    print('fr:', fr.get(k))
    print('ar:', ar.get(k))


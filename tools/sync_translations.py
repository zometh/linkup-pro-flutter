import json
from pathlib import Path

root = Path(__file__).resolve().parent.parent
assets = root / 'assets' / 'translations'

en_file = assets / 'en.json'
fr_file = assets / 'fr.json'
ar_file = assets / 'ar.json'

with en_file.open('r', encoding='utf-8') as f:
    en = json.load(f)

# load targets, if missing create empty
for target_file in (fr_file, ar_file):
    if not target_file.exists():
        target_file.write_text('{}', encoding='utf-8')

with fr_file.open('r', encoding='utf-8') as f:
    fr = json.load(f)
with ar_file.open('r', encoding='utf-8') as f:
    ar = json.load(f)

# Keep keys from en order
new_fr = {}
new_ar = {}

added_fr = []
added_ar = []

for k, v in en.items():
    if k in fr:
        new_fr[k] = fr[k]
    else:
        new_fr[k] = v
        added_fr.append(k)
    if k in ar:
        new_ar[k] = ar[k]
    else:
        new_ar[k] = v
        added_ar.append(k)

# preserve extra keys present in fr/ar but not in en by appending them
extra_fr = {k: v for k, v in fr.items() if k not in en}
extra_ar = {k: v for k, v in ar.items() if k not in en}

if extra_fr:
    new_fr['__extra_keys_from_fr__'] = {}
    for k, v in extra_fr.items():
        new_fr['__extra_keys_from_fr__'][k] = v
if extra_ar:
    new_ar['__extra_keys_from_ar__'] = {}
    for k, v in extra_ar.items():
        new_ar['__extra_keys_from_ar__'][k] = v

# write back
with fr_file.open('w', encoding='utf-8') as f:
    json.dump(new_fr, f, ensure_ascii=False, indent=2)

with ar_file.open('w', encoding='utf-8') as f:
    json.dump(new_ar, f, ensure_ascii=False, indent=2)

print('Updated fr and ar translations.')
print('Added keys to fr:', len(added_fr))
print('Added keys to ar:', len(added_ar))
if added_fr:
    print('Sample added fr keys:', added_fr[:10])
if added_ar:
    print('Sample added ar keys:', added_ar[:10])


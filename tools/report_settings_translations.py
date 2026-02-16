import re, json
from pathlib import Path
root = Path(__file__).resolve().parent.parent
assets = root / 'assets' / 'translations'
settings_file = root / 'lib' / 'features' / 'settings' / 'presentation' / 'pages' / 'settings_page.dart'

en = json.load((assets / 'en.json').open('r', encoding='utf-8'))
fr = json.load((assets / 'fr.json').open('r', encoding='utf-8'))
ar = json.load((assets / 'ar.json').open('r', encoding='utf-8'))

text = settings_file.read_text(encoding='utf-8')
keys = set(m.group(1) for m in re.finditer(r"['\"]([a-zA-Z0-9_ \-]+)['\"]\s*\.tr\(\)", text))

report = []
for k in sorted(keys):
    ev = en.get(k)
    fv = fr.get(k)
    av = ar.get(k)
    issue = []
    if av is None:
        issue.append('missing in ar')
    else:
        # flag if same as en (placeholder) or looks ascii
        if av == ev:
            issue.append('placeholder (same as en)')
        if all(ord(c) < 128 for c in av) and any(c.isalpha() for c in av):
            issue.append('likely english')
    report.append((k, ev, fv, av, issue))

print('KEY | EN | FR | AR | ISSUE')
for row in report:
    print(row)

# write a json report
(json.dumps(report, ensure_ascii=False, indent=2))


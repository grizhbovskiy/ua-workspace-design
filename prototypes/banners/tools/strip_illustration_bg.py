# Remove full-canvas yellow/white background shapes from illustration SVGs.
# Usage: python3 strip_illustration_bg.py <src_svg_dir> <dst_dir>
import re, sys, os, glob, json
src, dst = sys.argv[1], sys.argv[2]
BG = {'#FEE600','#FFED00','#FFF0A6','WHITE','#FFFFFF','#FFE600','#FFD403','#225B45'}
num = r'(-?[\d.]+)'
rect_re = re.compile(r'<rect(?![^>]*\b(?:x|y|rx|transform)=)[^>]*?width="([\d.]+)"[^>]*?height="([\d.]+)"[^>]*?fill="([^"]+)"[^>]*/>')
path_re = re.compile(r'<path d="M\s*'+num+r'\s+'+num+r'\s*H\s*'+num+r'\s*V\s*'+num+r'\s*H\s*'+num+r'\s*V\s*'+num+r'\s*Z" fill="([^"]+)"\s*/>')
report = {}
for f in sorted(glob.glob(os.path.join(src, '*.svg'))):
    s = open(f, encoding='utf-8').read()
    removed = 0
    def rr(m):
        global removed
        w, h, fill = float(m.group(1)), float(m.group(2)), m.group(3).upper()
        if w >= 195 and h >= 195 and fill in BG:
            removed += 1; return ''
        return m.group(0)
    def pr(m):
        global removed
        xs = [float(m.group(i)) for i in (1,3,5)]; ys = [float(m.group(i)) for i in (2,4,6)]
        fill = m.group(7).upper()
        if max(xs)-min(xs) >= 195 and max(ys)-min(ys) >= 195 and fill in BG:
            removed += 1; return ''
        return m.group(0)
    # Only touch drawable content; shapes inside <defs> are clip paths, not backgrounds.
    i = s.find('<defs>'); head, tail = (s, '') if i < 0 else (s[:i], s[i:])
    head = rect_re.sub(rr, head); head = path_re.sub(pr, head); s = head + tail
    report[os.path.basename(f)] = removed
    open(os.path.join(dst, os.path.basename(f)), 'w', encoding='utf-8').write(s)
print(json.dumps({k:v for k,v in report.items() if v==0}, ensure_ascii=False, indent=0))
print('total', len(report), 'stripped', sum(1 for v in report.values() if v))

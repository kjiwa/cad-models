"""Mesh queries over triangle lists as returned by geometry_fingerprint.read_stl_triangles."""

# Irrational-ish direction so the ray never grazes an axis-aligned edge or face.
_RAY = (0.5773, 0.3711, 0.7311)


def _ray_hits_triangle(origin, tri):
    a, b, c = tri
    e1 = [b[i] - a[i] for i in range(3)]
    e2 = [c[i] - a[i] for i in range(3)]
    h = [
        _RAY[1] * e2[2] - _RAY[2] * e2[1],
        _RAY[2] * e2[0] - _RAY[0] * e2[2],
        _RAY[0] * e2[1] - _RAY[1] * e2[0],
    ]
    det = sum(e1[i] * h[i] for i in range(3))
    if abs(det) < 1e-12:
        return False
    s = [origin[i] - a[i] for i in range(3)]
    u = sum(s[i] * h[i] for i in range(3)) / det
    if u < 0 or u > 1:
        return False
    q = [
        s[1] * e1[2] - s[2] * e1[1],
        s[2] * e1[0] - s[0] * e1[2],
        s[0] * e1[1] - s[1] * e1[0],
    ]
    v = sum(_RAY[i] * q[i] for i in range(3)) / det
    if v < 0 or u + v > 1:
        return False
    return sum(e2[i] * q[i] for i in range(3)) / det > 0


def _cross(a, b):
    return (a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0])


def _unit(a):
    n = sum(x * x for x in a) ** 0.5
    return tuple(x / n for x in a)


# Plane perpendicular to _RAY: a ray can only hit a triangle whose projection onto it holds the
# projected origin, so a grid over the projected triangles narrows each query to a few candidates.
_U = _unit(_cross(_RAY, (1.0, 0.0, 0.0)))
_V = _unit(_cross(_RAY, _U))
_PAD = 1e-6
_index_cache = {}


def _project(p):
    return (sum(p[i] * _U[i] for i in range(3)), sum(p[i] * _V[i] for i in range(3)))


def _build_index(tris):
    boxes = []
    for t in tris:
        q = [_project(p) for p in t]
        xs = [c[0] for c in q]
        ys = [c[1] for c in q]
        boxes.append((min(xs) - _PAD, min(ys) - _PAD, max(xs) + _PAD, max(ys) + _PAD))
    x0 = min(b[0] for b in boxes)
    y0 = min(b[1] for b in boxes)
    span = max(max(b[2] for b in boxes) - x0, max(b[3] for b in boxes) - y0)
    cells = max(1, int(len(tris) ** 0.5))
    size = span / cells
    grid = {}
    for t, (bx0, by0, bx1, by1) in zip(tris, boxes):
        for i in range(int((bx0 - x0) / size), int((bx1 - x0) / size) + 1):
            for k in range(int((by0 - y0) / size), int((by1 - y0) / size) + 1):
                grid.setdefault((i, k), []).append(t)
    return x0, y0, size, grid


def contains(tris, point):
    entry = _index_cache.get(id(tris))
    if entry is None or entry[0] is not tris:
        entry = _index_cache[id(tris)] = (tris, _build_index(tris))
    x0, y0, size, grid = entry[1]
    px, py = _project(point)
    candidates = grid.get((int((px - x0) // size), int((py - y0) // size)), ())
    return sum(_ray_hits_triangle(point, t) for t in candidates) % 2 == 1


def _key(p):
    return tuple(round(x, 4) for x in p)


def shell_count(tris):
    parent = {}

    def find(x):
        parent.setdefault(x, x)
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    for t in tris:
        keys = [_key(p) for p in t]
        for k in keys[1:]:
            parent[find(k)] = find(keys[0])
    return len({find(k) for k in list(parent)})

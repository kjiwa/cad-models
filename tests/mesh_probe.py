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


def contains(tris, point):
    return sum(_ray_hits_triangle(point, t) for t in tris) % 2 == 1


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

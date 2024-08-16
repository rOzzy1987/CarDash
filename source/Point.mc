using Toybox.Lang;
using Toybox.Math;

class Point {
    public var X as Lang.Numeric;
    public var Y as Lang.Numeric;

    public function initialize(x as Lang.Numeric, y as Lang.Numeric) {
        X = x;
        Y = y;
    }

    public function Add(x as Point) as Point {
        return new Point(X + x.X, Y + x.Y);
    }

    public function Sub(x as Point) as Point {
        return new Point(X - x.X, Y - x.Y);
    }

    public function Mul(m as Lang.Numeric) as Point {
        return new Point(X * m, Y * m);
    }
    
    public function Copy() as Point {
        return new Point(X, Y);
    }

    public function Rotate(center as Point, angle as Lang.Numeric) as Point {
        var t = Sub(center);
        var rads = angle * Math.PI / 180;

        var c = Math.cos(rads);
        var s = Math.sin(rads);

        var t2 = new Point((c * t.X) - (s * t.Y), (s * t.X) + (c * t.Y));
        return t2.Add(center);
    }

    public function Round() as Point {
        return new Point(Math.round(X), Math.round(Y));
    }
}
import Toybox.Application;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Lang;
import Toybox.System;

class Gauge {

    public var Center = new Point(90,90);
    public var Size = 180;
    public var Margin = 4;

    public var ForegroundColor = Graphics.COLOR_WHITE; 
    public var RedlineColor = Graphics.COLOR_RED;
    public var CapColor = Graphics.COLOR_LT_GRAY;
    public var PointerColor = Graphics.COLOR_RED;

    public var AngleFrom = 0f as Lang.Float;
    public var AngleTo = 180f as Lang.Float;
    public var ValueFrom = 0 as Lang.Number;
    public var ValueTo = 100 as Lang.Number;
    public var RedlineFrom = 66f as Lang.Float;
    public var RedlineTo = 100f as Lang.Float;

    public var TickUnits = 10 as Lang.Number;
    public var SmallTickUnits = 2 as Lang.Number;

    public var PointerWidth = 10 as Lang.Number; 
    public var CapSize = -1 as Lang.Number;
    public var TickWidth = 3 as Lang.Number;
    public var TickLength = 20 as Lang.Number;
    public var SmallTickWidth = 2 as Lang.Number;
    public var SmallTickLength = 6 as Lang.Number;
    public var RedlineWidth = 15 as Lang.Number;
    public var BorderWidth = 1 as Lang.Number;

    public var Font = Graphics.FONT_XTINY;
    public var FontMargin = 15 as Lang.Number;

    public function initialize() {

    }

    // public function init(x) as Void {
    //     initProp(x, "Center");
    //     initProp(x, "Size");
    //     initProp(x, "Margin");
    //     initProp(x, "ForegroundColor");
    //     initProp(x, "RedlineColor");
    //     initProp(x, "AngleFrom");
    //     initProp(x, "AngleTo");
    //     initProp(x, "ValueFrom");
    //     initProp(x, "ValueTo");
    //     initProp(x, "RedlineFrom");
    //     initProp(x, "RedlineTo");
    //     initProp(x, "TickUnits");
    //     initProp(x, "SmallTickUnits");
    //     initProp(x, "TickWidth");
    //     initProp(x, "TickLength");
    //     initProp(x, "SmallTickWidth");
    //     initProp(x, "SmallTickLength");
    //     initProp(x, "RedlineWidth");
    //     initProp(x, "BorderWidth");
    //     initProp(x, "Font");
    //     initProp(x, "FontMargin");
    // }
    // public function initProp(x, prop as Lang.String) {
    //     if(x has prop) {
    //         self[prop] = x[prop];
    //     }
    // }

    public function draw(dc as Dc) {
        var r = (Size / 2) - Margin;
        var rr = r - RedlineWidth / 2;

        var d = AngleFrom < AngleTo ? Graphics.ARC_CLOCKWISE : Graphics.ARC_COUNTER_CLOCKWISE;

        dc.setColor(RedlineColor, -1);
        dc.setPenWidth(RedlineWidth);
        
        var dStep = (AngleTo - AngleFrom) / (ValueTo - ValueFrom).toFloat();

        var rlf = AngleFrom + (dStep * RedlineFrom);
        var rlt = AngleFrom + (dStep * RedlineTo);
        dc.drawArc(Center.X, Center.Y, rr, d, 90 - rlf, 90 - rlt);

        if (BorderWidth > 0) {
            dc.setPenWidth(BorderWidth);
            dc.setColor(ForegroundColor, -1);
            dc.drawArc(Center.X, Center.Y, r, d, 90 - AngleFrom, 90 - AngleTo);
        }

        drawTicks(dc);
    }

    private function drawTicks(dc as Dc){
        var current = ValueFrom;
        
        var dStep = (AngleTo - AngleFrom) / (ValueTo - ValueFrom).toFloat();

        var r = (Size / 2) - Margin;

        var p1 = new Point(Center.X, Center.Y - r);
        var p2 = p1.Add(new Point(0, SmallTickLength));
        var p3 = p1.Add(new Point(0, TickLength));
        var p4 = p3.Add(new Point(0, FontMargin));

        var l1 = p1;
        var l2 = p2; 

        dc.setColor(ForegroundColor, -1);

        while (current <= ValueTo) {
            var angle = AngleFrom + (current * dStep);
            if (current.toNumber() % TickUnits == 0) {
                l1 = p1.Rotate(Center, angle);
                l2 = p3.Rotate(Center, angle);

                dc.setPenWidth(TickWidth);
                dc.drawLine(l1.X, l1.Y, l2.X, l2.Y);

                if (Font != -1) {
                    l1 = p4.Rotate(Center, angle);
                    dc.drawText(l1.X, l1.Y, Font, current.format("%.0f"), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                }

            } else if (current.toNumber() % SmallTickUnits == 0 && SmallTickWidth > 0) {
                l1 = p1.Rotate(Center, angle);
                l2 = p2.Rotate(Center, angle);

                dc.setPenWidth(SmallTickWidth);
                dc.drawLine(l1.X, l1.Y, l2.X, l2.Y);
            }
            current++;
        }
    }

    function drawPointer(dc as Dc, value as Lang.Numeric) {
        
        var r = (Size / 2) - Margin - TickLength;
        var p1 = new Point(Center.X - 1, Center.Y - r);
        var p2 = new Point(Center.X + 1, Center.Y - r);
        var p3 = new Point(Center.X + PointerWidth / 2, Center.Y);
        var p4 = new Point(Center.X - PointerWidth / 2, Center.Y);

        var tv = value < ValueFrom 
            ? ValueFrom 
            : value > ValueTo 
                ? ValueTo 
                : value;
        var dStep = (AngleTo - AngleFrom) / (ValueTo - ValueFrom).toFloat();
        var a = AngleFrom + (tv * dStep);

        p1 = p1.Rotate(Center, a);
        p2 = p2.Rotate(Center, a);
        p3 = p3.Rotate(Center, a);
        p4 = p4.Rotate(Center, a);

        // dc.setPenWidth(0);
        dc.setColor(PointerColor, -1);

        dc.fillPolygon([[p1.X, p1.Y], [p2.X, p2.Y], [p3.X, p3.Y], [p4.X, p4.Y]]);

        if (CapSize > 0 && CapColor > -1) {
            dc.setColor(CapColor, -1);
            dc.fillCircle(Center.X, Center.Y, CapSize / 2);
        }
    }
}

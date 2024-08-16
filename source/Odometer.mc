import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

class Odometer {
    public var BackgroundColor = Graphics.COLOR_WHITE;
    public var ForegroundColor = Graphics.COLOR_BLACK;
    public var DecimalBackgroundColor = Graphics.COLOR_DK_GRAY;
    public var DecimalForegroundColor = Graphics.COLOR_WHITE;
    public var BorderColor = 0x333333;

    public var Center = new Point(120, 180);
    public var CharacterWidth = 15;
    public var Height = 20;
    public var BorderWidth = 1;

    public var Font = Graphics.FONT_SYSTEM_XTINY;

    public var CharacterCount = 5;
    public var Decimals = 3;

    public function draw2(dc as Dc, value as Lang.Numeric)
    {
        var w = (CharacterCount * CharacterWidth) + ((CharacterWidth + 1) * BorderWidth);
        var o = Center.Sub(new Point(w/2, Height / 2));

        dc.setPenWidth(BorderWidth);
        dc.setColor(BorderColor, BackgroundColor);

        dc.drawRectangle(o.X, o.Y, w, Height);

        var p = o.Copy();
        for(var i = 0; i < CharacterCount - 1; i++) {
            p.X += CharacterWidth + BorderWidth;
            dc.drawLine(p.X, p.Y, p.X, p.Y + Height);
        }

        for (var i = 0; i < Decimals; i++) {
            value = value * 10;
        }

        var strVal = Math.round(value).format("%.0f").toCharArray();
        var strs = strVal.size();

        p = o.Add(new Point(w - CharacterWidth / 2, Height / 2));
        var c = (strs > CharacterCount ? CharacterCount : strs) - 1;

        for (var i = 0; i < CharacterCount && c >= 0; i++, c--) {
            var isDecimal = c > strs - Decimals;
            dc.setColor(isDecimal ? DecimalForegroundColor : ForegroundColor, isDecimal ? DecimalBackgroundColor : BackgroundColor);
            dc.drawText(p.X, p.Y, Font, strVal[c], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            p.X -= CharacterWidth + BorderWidth;
        }
    }

    public function draw(dc as Dc, value as Lang.Numeric)
    {
        var w = (CharacterCount * CharacterWidth) + ((CharacterCount + 1) * BorderWidth);
        var o = Center.Sub(new Point(w/2, Height / 2));

        for (var i = 0; i < Decimals; i++) {
            value = value * 10;
        }

        var strVal = Math.round(value).format("%.0f").toCharArray();
        var strs = strVal.size();

        var c = (strs > CharacterCount ? CharacterCount : strs) - 1;

        for (var i = CharacterCount - 1; i >= 0 ; i--, c--) {
            var isDecimal = c >= strs - Decimals;
            var p = o.Add(new Point((CharacterWidth + BorderWidth) * i, 0));

            dc.setPenWidth(BorderWidth);
            dc.setColor(isDecimal ? DecimalBackgroundColor : BackgroundColor, -1);
            dc.fillRectangle(p.X, p.Y, CharacterWidth + (BorderWidth * 2), Height);
            dc.setColor(BorderColor, -1);
            dc.drawRectangle(p.X, p.Y, CharacterWidth + (BorderWidth * 2), Height);
            
            var ch = c >= 0 ? strVal[c] : '0';

            dc.setColor(isDecimal ? DecimalForegroundColor : ForegroundColor, -1);
            dc.drawText(p.X + (CharacterWidth / 2) + BorderWidth, p.Y + (Height / 2), Font, ch, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            p.X -= CharacterWidth + BorderWidth;
        }
    }

}
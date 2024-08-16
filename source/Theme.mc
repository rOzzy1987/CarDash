using Toybox.System;
using Toybox.Lang;
using Toybox.Graphics as Gr;

class Theme {
    static const LIGHT = 0;
    static const DARK = 1; 

    static var _lightTheme = new Theme();
    static var _darkTheme = new Theme();

    static var _themeType = DARK;

    public static function setTheme(theme as Lang.Number) as Void {
        _themeType = theme == LIGHT ? LIGHT : DARK;
    }

    public static function init() as Void {

        var t = new Theme();
        t.BgColor = Gr.COLOR_WHITE;
        t.FgColor = Gr.COLOR_BLACK;
        t.TickColor = Gr.COLOR_BLACK;

        _lightTheme = t;

        t = new Theme();
        t.BgColor = Gr.COLOR_BLACK;
        t.FgColor = Gr.COLOR_WHITE;

        t.TickColor = Gr.COLOR_WHITE;

        _darkTheme = t;
    }

    public static function getTheme() as Theme {
        if (_themeType == LIGHT) {
            return _lightTheme;
        }
        return _darkTheme;
    }

    public var BgColor = Gr.COLOR_ORANGE as Lang.Number;
    public var FgColor = Gr.COLOR_BLACK as Lang.Number;
    public var Margin = 4 as Lang.Number;

    public var TickColor = Gr.COLOR_BLACK as Lang.Number;
    public var RlWidth = 15 as Lang.Number;

    public var TickWidth = 3 as Lang.Number;
    public var SubtickWidth = 2 as Lang.Number;
    public var TickLength = 20 as Lang.Number;
    public var SubtickLength = 5 as Lang.Number;

    public var RpmTickWidth = 2 as Lang.Number;
    public var RpmTickLength = 10 as Lang.Number;
    public var RpmBorderWidth = 1 as Lang.Number;
    public var RpmRlWidth = 6 as Lang.Number;

    public var OdoBgColor = Gr.COLOR_LT_GRAY as Lang.Number;
    public var OdoFgColor = Gr.COLOR_BLACK as Lang.Number;
    public var OdoDivColor = Gr.COLOR_DK_GRAY as Lang.Number;
}
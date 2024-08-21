import Toybox.Application;
import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class CarDashView extends WatchUi.DataField {
    const DATA_SRC_HEART_RATE = 0;
    const DATA_SRC_CADENCE = 1;

    // Data related
    private var _dSpeed as Numeric;
    private var _dDistance as Numeric;
    private var _dSecondary as Numeric;

    private var _secondaryDataSource as Numeric = DATA_SRC_CADENCE;

    // View related
    private var _w = 0;
    private var _h = 0;

    private var _spdGauge = new Gauge();
    private var _rpmGauge = new Gauge();
    private var _odometer = new Odometer();

    private var _isDebug = false;

    function initialize() {
        DataField.initialize();

        _dSpeed = 0.0f;
        _dDistance = 0.0f;
        _dSecondary = 0.0f;

        Theme.init();
    }

    function onLayout(dc as Dc) as Void {
        View.setLayout(Rez.Layouts.MainLayout(dc));

        if (_w == 0 || _h == 0) {
            _w = dc.getWidth();
            _h = dc.getHeight();
            
            loadUserSettings();
        }
    }

    public function loadUserSettings() {
        Theme.setTheme(Application.Properties.getValue("theme"));
        var th = Theme.getTheme();
    
        var scale = _w / 240.0f;

        _spdGauge.Size = _w;
        _spdGauge.Center = new Point(_w/2, _h/2);
        _spdGauge.Margin = th.Margin * scale;
        _spdGauge.TickWidth = th.TickWidth * scale;
        _spdGauge.SmallTickWidth = th.SubtickWidth * scale;
        _spdGauge.TickLength = th.TickLength * scale;
        _spdGauge.SmallTickLength = th.SubtickLength * scale;
        _spdGauge.RedlineWidth = th.RlWidth * scale;
        _spdGauge.BorderWidth = 0;
        _spdGauge.CapSize = 30 * scale;
        _spdGauge.TickUnits = Application.Properties.getValue("spdDiv").toNumber();
        _spdGauge.SmallTickUnits = _spdGauge.TickUnits / 5;

        _spdGauge.ValueFrom = 0f;
        _spdGauge.ValueTo = Application.Properties.getValue("spdMax").toFloat();
        _spdGauge.AngleFrom = -120f;
        _spdGauge.AngleTo = 120f;
        _spdGauge.RedlineFrom = Application.Properties.getValue("spdRedline").toFloat();
        _spdGauge.RedlineTo = _spdGauge.ValueTo;

        _spdGauge.Font = Application.Properties.getValue("spdFont");
        _spdGauge.FontMargin = 15 * scale;
        _spdGauge.ForegroundColor = th.FgColor;
        _spdGauge.RedlineColor = Application.Properties.getValue("redlineColor").toNumber();
        _spdGauge.PointerColor = Application.Properties.getValue("pointerColor").toNumber();
        _spdGauge.CapColor = Application.Properties.getValue("pointerCapColor").toNumber();

        _rpmGauge.Size = _w / 2;
        _rpmGauge.Center = new Point(_w/2, _h * 3/4);
        _rpmGauge.Margin = th.Margin * scale;
        _rpmGauge.TickWidth = th.RpmTickWidth * scale;
        _rpmGauge.SmallTickWidth = 0;
        _rpmGauge.TickLength = th.RpmTickLength * scale;
        _rpmGauge.SmallTickLength = 0;
        _rpmGauge.RedlineWidth = th.RpmRlWidth * scale;
        _rpmGauge.BorderWidth = 1;
        _rpmGauge.CapSize = 12 * scale;

        _rpmGauge.ValueTo = Application.Properties.getValue("cadMax");
        _rpmGauge.AngleFrom = 240;
        _rpmGauge.AngleTo = 120;
        _rpmGauge.RedlineFrom = Application.Properties.getValue("cadRedline");
        _rpmGauge.RedlineTo = 100;

        _rpmGauge.TickUnits = 20;
        _rpmGauge.Font = -1;
        _rpmGauge.ForegroundColor = th.FgColor;
        _rpmGauge.RedlineColor = Application.Properties.getValue("redlineColor").toNumber();
        _rpmGauge.PointerColor = Application.Properties.getValue("pointerColor").toNumber();
        _rpmGauge.CapColor = Application.Properties.getValue("pointerCapColor").toNumber();

        _odometer.BorderWidth = 2 * scale;
        _odometer.Font = Application.Properties.getValue("odoFont");
        _odometer.Center = new Point(_w / 2, _h * Application.Properties.getValue("odoP").toNumber() / 64);
        _odometer.CharacterWidth = 0;
        _odometer.Height = 0;
        
        _isDebug = Application.Properties.getValue("isDebug");
        _secondaryDataSource = Application.Properties.getValue("cadData");
    }

    function compute(info as Activity.Info) as Void {

        if(info has :currentSpeed && info.currentSpeed != null) {
            _dSpeed = info.currentSpeed.toFloat();
        } else {
            _dSpeed = 0.0f;
        }

        if(info has :elapsedDistance && info.elapsedDistance != null) {
            _dDistance = info.elapsedDistance.toFloat();
        } else {
            _dDistance = 0.0f;
        }
        
        switch (_secondaryDataSource) {
            case DATA_SRC_CADENCE:
                if(info has :currentCadence && info.currentCadence != null) {
                    _dSecondary = (info.currentCadence).toFloat();
                } else {
                    _dSecondary = 0.0f;
                }
                break;
            case DATA_SRC_HEART_RATE:
                if(info has :heartRate && info.heartRate != null) {
                    _dSecondary = (info.heartRate).toFloat();
                } else {
                    _dSecondary = 0.0f;
                }
                break;
            default: 
                _dSecondary = 0.0f;
                break;
        }

        if (System.getDeviceSettings().distanceUnits == System.UNIT_METRIC) {
            _dDistance /= 1000f;
            _dSpeed *= Unit.MPS_TO_KPH; 
        } else {
            _dDistance /= Unit.METERS_IN_MILE;
            _dSpeed *= Unit.MPS_TO_KPH / Unit.KILOMETERS_IN_MILE;
        }
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        var th = Theme.getTheme();

        dc.setColor(Graphics.COLOR_TRANSPARENT, th.BgColor);
        dc.clear();


        if (_spdGauge.Font != -1) {
            var utxt = System.getDeviceSettings().distanceUnits == System.UNIT_METRIC
                ? WatchUi.loadResource(Rez.Strings.Kph)
                : WatchUi.loadResource(Rez.Strings.Mph);
            dc.setColor(0x808080, -1);
            dc.drawText(_w / 2, _h / 4, Graphics.FONT_SYSTEM_XTINY, utxt, Graphics.TEXT_JUSTIFY_CENTER) ;
        }

        _spdGauge.draw(dc);
        _rpmGauge.draw(dc);

        _odometer.draw(dc, _dDistance);

        _spdGauge.drawPointer(dc, _dSpeed);
        _rpmGauge.drawPointer(dc, _dSecondary);

        if (_isDebug) {
            dbgView(dc);
        }
    }

    function dbgView(dc as Dc){
        dc.setColor(Graphics.COLOR_GREEN, -1);
        dc.drawText(90, 60, Graphics.FONT_SYSTEM_XTINY, _dSpeed.format("%.2f"), Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(90, 75, Graphics.FONT_SYSTEM_XTINY, _dDistance.format("%.2f"), Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(90, 90, Graphics.FONT_SYSTEM_XTINY, _dSecondary.format("%.2f"), Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(90, 105, Graphics.FONT_SYSTEM_XTINY, _secondaryDataSource == DATA_SRC_CADENCE ? "Cad" : "HR", Graphics.TEXT_JUSTIFY_LEFT);
    }

}

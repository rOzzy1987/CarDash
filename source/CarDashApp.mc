import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class CarDashApp extends Application.AppBase {

    private var view = new CarDashView();

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ view ];
    }

    function onSettingsChanged() {
        view.loadUserSettings();
        view.requestUpdate();
    }

}
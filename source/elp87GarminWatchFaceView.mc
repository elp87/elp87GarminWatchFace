using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

class elp87GarminWatchFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }
    
    function drawAngleLine(dc, angle, r1, r2, color)
	{
		var width = dc.getWidth();
    	var height = dc.getHeight();
		var x1 = (width / 2) + (Math.sin(angle) * r1);
        var y1 = (height / 2) - (Math.cos(angle) * r1);
        var x2 = (width / 2) + (Math.sin(angle) * r2);
        var y2 = (height / 2) - (Math.cos(angle) * r2);
        dc.setColor(color, Graphics.COLOR_BLACK);
        dc.drawLine(x1, y1, x2, y2);
	}

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get and show the current time
        /*var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.min.format("%02d"), clockTime.sec.format("%02d")]);
        var view = View.findDrawableById("TimeLabel");
        view.setText(timeString);*/
        var clockTime = System.getClockTime();
    	var width;
    	var height;    	
    	
    	width = dc.getWidth();
    	height = dc.getHeight();
    	
    	// Заполняем фон черным
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(0, 0, width, height);
    	
    	// Рисуем гвоздик в центре
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
        dc.fillCircle(width / 2, height / 2, 3);
        
        // Рисуем засечки
        for (var i = 0; i < 12; i++) {
        	var angle = (Math.PI / 6) * i; 
        	var r1 = (width / 2);
        	var r2 = r1 * 0.9;
        	drawAngleLine(dc, angle, r1, r2, Graphics.COLOR_LT_GRAY);
        }
        
        // Рисуем секундную стрелку
        var sec = clockTime.sec;
        var secAngle = (Math.PI / 30) * sec;
        drawAngleLine(dc, secAngle, 0, (width / 2) * 0.9, Graphics.COLOR_RED); 

        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}

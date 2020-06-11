using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time.Gregorian;
using Toybox.Activity;

class elp87GarminWatchFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }
    
    function drawNonCenterAngleLine(dc, xCenter, yCenter, angle, r1, r2, color)
    {
    	var width = dc.getWidth();
    	var height = dc.getHeight();
		var x1 = xCenter + (Math.sin(angle) * r1);
        var y1 = yCenter - (Math.cos(angle) * r1);
        var x2 = xCenter + (Math.sin(angle) * r2);
        var y2 = yCenter - (Math.cos(angle) * r2);
        dc.setColor(color, Graphics.COLOR_BLACK);
        dc.drawLine(x1, y1, x2, y2);
    }
    
    function drawAngleLine(dc, angle, r1, r2, color)
	{
		var width = dc.getWidth();
    	var height = dc.getHeight();
    	drawNonCenterAngleLine(dc, (width / 2), (height / 2), angle, r1, r2, color);		
	}
	
	function drawClockHand(dc, angle, r, handWidth, color)
	{
		var semiHandWidth = (handWidth - (handWidth % 2)) / 2;
		var xCenter = dc.getWidth() / 2;
		var yCenter = dc.getHeight() / 2;
		
		drawNonCenterClockHand(dc, xCenter, yCenter, angle, r, handWidth, color);
	}
	
	function drawNonCenterClockHand(dc, xCenter, yCenter, angle, r, handWidth, color)
	{
		var semiHandWidth = (handWidth - (handWidth % 2)) / 2;		
		
		var coords = new [4];
		
		// Координаты 1-й точки у гвоздика [0]
		var x0 = xCenter + (Math.cos(angle) * semiHandWidth);
		var y0 = yCenter + (Math.sin(angle) * semiHandWidth);
		coords[0] = [x0, y0];
		
		// Координаты вершины [1]
		var x1 = xCenter + (Math.sin(angle) * r);
		var y1 = yCenter - (Math.cos(angle) * r);
		coords[1] = [x1, y1];
		
		// Координаты 2-й точки у гвоздика [2]
		var x2 = xCenter - (Math.cos(angle) * semiHandWidth);
		var y2 = yCenter - (Math.sin(angle) * semiHandWidth);
		coords[2] = [x2, y2];
		
		// Координаты хвостика
		var x3 = xCenter - (Math.sin(angle) * r * 0.1);
		var y3 = yCenter + (Math.cos(angle) * r * 0.1);
		coords[3] = [x3, y3];		
		
		dc.setColor(color, Graphics.COLOR_BLACK);
		dc.fillPolygon(coords);
	}
	
	function drawExtraClockFace (dc, x, y, r, color)
	{
		dc.setColor(color, Graphics.COLOR_BLACK);
        dc.drawCircle(x, y, r);
	}
	
	function drawDateBox( dc, x, y ) {
		dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
		dc.fillRoundedRectangle(x - 15, y , 30, 24, 7);
		
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		dc.drawRoundedRectangle(x - 15, y , 30, 24, 7);
		
        var info = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var dateStr = Lang.format("$1$", [info.day]);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_XTINY, dateStr, Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function drawHeartRate(dc, x, y) {
    	var value = Activity.getActivityInfo().currentHeartRate;//Application.getApp().getProperty("ShowHeartRate");
        if (value != null) {
        	dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        	dc.drawText(x, y, Graphics.FONT_MEDIUM, value, Graphics.TEXT_JUSTIFY_CENTER);
        } 
    }
    
    function drawBatteryLevel(dc, x, y)
    {    	
    	var stats = System.getSystemStats();
    	var charging = stats.charging;
    	var batteryLevel = stats.battery;
        var batteryText = "N/A";
        if (batteryLevel != null) {
        	var batteryValue = batteryLevel.toNumber();
            batteryText = batteryValue + "%";
            var color = Graphics.COLOR_GREEN;
            if (batteryValue < 50) { color = Graphics.COLOR_YELLOW; }
            if (batteryValue < 20) { color = Graphics.COLOR_RED; }
            if (charging == true) { color = Graphics.COLOR_WHITE; } 
            dc.setColor(color, Graphics.COLOR_BLACK);
            dc.drawText(x, y, Graphics.FONT_MEDIUM, batteryText, Graphics.TEXT_JUSTIFY_CENTER);
        }
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
        var clockTime = System.getClockTime();
        var day = clockTime.hour;
        var hour = clockTime.hour;
        var min = clockTime.min;
        var sec = clockTime.sec;
        
    	var width;
    	var height;    	
    	
    	width = dc.getWidth();
    	height = dc.getHeight();
    	
    	// Заполняем фон черным
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(0, 0, width, height);
        
        // Пишем 12
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText((width / 2), (height * 0.05), Graphics.FONT_LARGE, "12", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText((width * 0.9), (height * 0.42), Graphics.FONT_MEDIUM, "3", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText((width * 0.1), (height * 0.42), Graphics.FONT_MEDIUM, "9", Graphics.TEXT_JUSTIFY_CENTER);
    	
        
        // Рисуем засечки
        for (var i = 0; i < 12; i++) {
        	var angle = (Math.PI / 6) * i; 
        	var r1 = (width / 2);
        	var r2 = r1 * 0.9;
        	drawAngleLine(dc, angle, r1, r2, Graphics.COLOR_LT_GRAY);
        }
        
        // Рисуем секундный циферблат
        drawExtraClockFace(dc, (width * .5), (height * .75), (width * .15), Graphics.COLOR_DK_GRAY);
        
        // Рисуем ячейку с датой
        drawDateBox(dc, (width / 2), (height * 0.85));    
        
        // Рисуем секундную стрелку
        var secAngle = (Math.PI / 30) * sec;
        drawNonCenterClockHand(dc, (width * .5), (height * .75), secAngle, (width * .15), 5, Graphics.COLOR_RED);
        
        // Рисуем сердечный пульс
        drawHeartRate(dc, (width * .25), (height * .25));
        
        // Рисуем уровень батареи
        drawBatteryLevel(dc, (width * .75), (height * .25));

		// Рисуем часовую стрелку
        var hour12 = hour % 12 + (min / 60.0);
        var hourAngle = (Math.PI / 6) * hour12;
        drawClockHand(dc, hourAngle, (width / 2) * 0.6, 15, Graphics.COLOR_WHITE);
        //drawAngleLine(dc, hourAngle, 0, (width / 2) * 0.5, Graphics.COLOR_WHITE);        
        
        // Рисуем минутную стрелку
        var minAngle = (Math.PI / 30) * min;
        drawClockHand(dc, minAngle, (width / 2) * 0.9, 9, Graphics.COLOR_LT_GRAY);
        //drawAngleLine(dc, minAngle, 0, (width / 2) * 0.9, Graphics.COLOR_WHITE);
        
        // Рисуем гвоздик в центре
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(width / 2, height / 2, 3); 
        
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_BLACK);
        dc.fillCircle((width * .5), (height * .75), 1);   
        
        
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

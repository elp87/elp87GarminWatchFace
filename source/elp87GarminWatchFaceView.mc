using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;

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
		/*var x1 = (width / 2) + (Math.sin(angle) * r1);
        var y1 = (height / 2) - (Math.cos(angle) * r1);
        var x2 = (width / 2) + (Math.sin(angle) * r2);
        var y2 = (height / 2) - (Math.cos(angle) * r2);
        dc.setColor(color, Graphics.COLOR_BLACK);
        dc.drawLine(x1, y1, x2, y2);*/
	}
	
	/*function drawClockHand(dc, angle, r, handWidth, color)
	{
		var semiHandWidth = (handWidth - (handWidth % 2)) / 2;
		var xCenter = dc.getWidth() / 2;
		var yCenter = dc.getHeight() / 2;
		
		var coords = new [5];
		
		// Координаты 1-й точки у гвоздика [0]
		var x0 = xCenter + (Math.cos(angle) * semiHandWidth);
		var y0 = yCenter + (Math.sin(angle) * semiHandWidth);
		coords[0] = [x0, y0];
		
		// Координаты 2-й точки у гвоздика [1]
		var x1 = xCenter - (Math.cos(angle) * semiHandWidth);
		var y1 = yCenter - (Math.sin(angle) * semiHandWidth);
		coords[1] = [x1, y1];
		
		// Координаты 1-й точки у кромки [2]
		var x2 = xCenter + (Math.sin(angle) * r * 0.9) - (Math.cos(angle) * semiHandWidth);
		var y2 = yCenter - (Math.cos(angle) * r * 0.9) - (Math.sin(angle) * semiHandWidth);
		coords[2] = [x2, y2];
		
		// Координаты вершины [3]
		var x3 = xCenter + (Math.sin(angle) * r);
		var y3 = yCenter - (Math.cos(angle) * r);
		coords[3] = [x3, y3];
		
		// Координаты 2-й точки у кромки [4]
		var x4 = xCenter + (Math.sin(angle) * r * 0.9) + (Math.cos(angle) * semiHandWidth);
		var y4 = yCenter - (Math.cos(angle) * r * 0.9) + (Math.sin(angle) * semiHandWidth);
		coords[4] = [x4, y4];
		
		dc.setColor(color, Graphics.COLOR_BLACK);
		dc.fillPolygon(coords);
	}*/
	
	function drawClockHand(dc, angle, r, handWidth, color)
	{
		var semiHandWidth = (handWidth - (handWidth % 2)) / 2;
		var xCenter = dc.getWidth() / 2;
		var yCenter = dc.getHeight() / 2;
		
		var coords = new [3];
		
		// Координаты 1-й точки у гвоздика [0]
		var x0 = xCenter + (Math.cos(angle) * semiHandWidth);
		var y0 = yCenter + (Math.sin(angle) * semiHandWidth);
		coords[0] = [x0, y0];
		
		// Координаты 2-й точки у гвоздика [1]
		var x1 = xCenter - (Math.cos(angle) * semiHandWidth);
		var y1 = yCenter - (Math.sin(angle) * semiHandWidth);
		coords[1] = [x1, y1];
		
		// Координаты вершины [2]
		var x2 = xCenter + (Math.sin(angle) * r);
		var y2 = yCenter - (Math.cos(angle) * r);
		coords[2] = [x2, y2];
		
		dc.setColor(color, Graphics.COLOR_BLACK);
		dc.fillPolygon(coords);
	}
	
	function drawExtraClockFace (dc, x, y, r, color)
	{
		dc.setColor(color, Graphics.COLOR_BLACK);
        dc.drawCircle(x, y, r);
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
    	
    	
        
        // Рисуем засечки
        for (var i = 0; i < 12; i++) {
        	var angle = (Math.PI / 6) * i; 
        	var r1 = (width / 2);
        	var r2 = r1 * 0.9;
        	drawAngleLine(dc, angle, r1, r2, Graphics.COLOR_LT_GRAY);
        }
        
        // Рисуем секундный циферблат
        drawExtraClockFace(dc, (width * .5), (height * .75), (width * .15), Graphics.COLOR_DK_GRAY);
        
        
        // Рисуем секундную стрелку
        var secAngle = (Math.PI / 30) * sec;
        drawNonCenterAngleLine(dc, (width * .5), (height * .75), secAngle, 0, (width * .15), Graphics.COLOR_RED);
        //drawAngleLine(dc, secAngle, 0, (width / 2) * 0.9, Graphics.COLOR_RED); 

		// Рисуем часовую стрелку
        var hour12 = hour % 12 + (min / 60.0);
        var hourAngle = (Math.PI / 6) * hour12;
        drawClockHand(dc, hourAngle, (width / 2) * 0.6, 9, Graphics.COLOR_WHITE);
        //drawAngleLine(dc, hourAngle, 0, (width / 2) * 0.5, Graphics.COLOR_WHITE);        
        
        // Рисуем минутную стрелку
        var minAngle = (Math.PI / 30) * min;
        drawClockHand(dc, minAngle, (width / 2) * 0.9, 5, Graphics.COLOR_LT_GRAY);
        //drawAngleLine(dc, minAngle, 0, (width / 2) * 0.9, Graphics.COLOR_WHITE);
        
        // Рисуем гвоздик в центре
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(width / 2, height / 2, 3);
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

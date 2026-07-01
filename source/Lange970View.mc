import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class Lange970View extends WatchUi.WatchFace {

    var _isAwake = true;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        // We draw directly on the device context instead of using the generated layout.
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        drawBackground(dc);
        drawChapterRing(dc);
        drawBatteryArc(dc);
        drawMonthRing(dc);
        drawDateWindow(dc);
        drawComplicationPlaceholders(dc);
        drawTimeDial(dc);
        drawSignature(dc);
    }

    function drawBackground(dc) {
        dc.setColor(Colors.BACKGROUND, Colors.BACKGROUND);
        dc.clear();

        dc.setColor(Colors.DIAL_DARK, Colors.DIAL_DARK);
        dc.fillCircle(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.WATCH_RADIUS);

        dc.setPenWidth(Geometry.MONTH_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.MONTH_RING_RADIUS);
    }

    function drawChapterRing(dc) {
        dc.setPenWidth(Geometry.CHAPTER_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.CHAPTER_RING_RADIUS);

        dc.setPenWidth(Geometry.MONTH_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD_LIGHT, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.CHAPTER_RING_INNER_RADIUS);

        dc.setPenWidth(Geometry.DATE_BORDER_THICKNESS);
        dc.setColor(Colors.DIAL_DEPTH, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.DIAL_DEPTH_RADIUS);

        dc.setPenWidth(Geometry.MONTH_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.DIAL_INNER_RADIUS);

        for (var i = 0; i < Geometry.MINUTE_MARKER_COUNT; i += 1) {
            var isHourMarker = (i % Geometry.HOUR_MARKER_INTERVAL) == 0;
            var angle = degreesToRadians((i * Geometry.MINUTE_MARKER_STEP) + Geometry.MARKER_START_ANGLE);
            var innerRadius = isHourMarker ? Geometry.HOUR_MARKER_INNER_RADIUS : Geometry.MINUTE_MARKER_INNER_RADIUS;
            var x1 = Geometry.WATCH_CENTER_X + Math.cos(angle) * innerRadius;
            var y1 = Geometry.WATCH_CENTER_Y + Math.sin(angle) * innerRadius;
            var x2 = Geometry.WATCH_CENTER_X + Math.cos(angle) * Geometry.MARKER_OUTER_RADIUS;
            var y2 = Geometry.WATCH_CENTER_Y + Math.sin(angle) * Geometry.MARKER_OUTER_RADIUS;

            dc.setPenWidth(isHourMarker ? Geometry.HOUR_MARKER_WIDTH : Geometry.MINUTE_MARKER_WIDTH);
            dc.setColor(isHourMarker ? Colors.ROSE_GOLD_LIGHT : Colors.ROSE_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(x1, y1, x2, y2);
        }
    }

    function drawBatteryArc(dc) {
        var stats = System.getSystemStats();
        var battery = stats.battery;
        var span = Geometry.BATTERY_END_ANGLE - Geometry.BATTERY_START_ANGLE;
        if (span < 0) {
            span += Geometry.FULL_CIRCLE_DEGREES;
        }

        var fillEnd = Geometry.BATTERY_START_ANGLE + (span * battery / Geometry.FULL_BATTERY_PERCENT);
        if (fillEnd > Geometry.FULL_CIRCLE_DEGREES) {
            fillEnd -= Geometry.FULL_CIRCLE_DEGREES;
        }

        dc.setPenWidth(Geometry.BATTERY_ARC_THICKNESS);
        dc.setColor(Colors.BATTERY_TRACK, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.BATTERY_ARC_RADIUS, Graphics.ARC_CLOCKWISE, Geometry.BATTERY_START_ANGLE, Geometry.BATTERY_END_ANGLE);

        dc.setPenWidth(Geometry.BATTERY_FILL_THICKNESS);
        dc.setColor(Colors.BATTERY_FILL, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.BATTERY_ARC_RADIUS, Graphics.ARC_CLOCKWISE, Geometry.BATTERY_START_ANGLE, fillEnd);
    }

    function drawMonthRing(dc) {
        var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];

        dc.setColor(Colors.ROSE_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < Geometry.MONTH_COUNT; i += 1) {
            var deg = (i * Geometry.MONTH_STEP_ANGLE) + Geometry.MONTH_START_ANGLE;
            var angle = degreesToRadians(deg);
            var x = Geometry.WATCH_CENTER_X + Math.cos(angle) * Geometry.MONTH_TEXT_RADIUS;
            var y = Geometry.WATCH_CENTER_Y + Math.sin(angle) * Geometry.MONTH_TEXT_RADIUS;
            dc.drawText(x, y, Typography.MONTH_FONT_SIZE, months[i], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        dc.setPenWidth(Geometry.DATE_BORDER_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD_LIGHT, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(Geometry.MONTH_POINTER_X, Geometry.MONTH_POINTER_Y + Geometry.MONTH_POINTER_SIZE, Geometry.MONTH_POINTER_X, Geometry.MONTH_POINTER_Y - Geometry.MONTH_POINTER_SIZE);
        dc.drawLine(Geometry.MONTH_POINTER_X - Geometry.MONTH_POINTER_SIZE, Geometry.MONTH_POINTER_Y, Geometry.MONTH_POINTER_X, Geometry.MONTH_POINTER_Y + Geometry.MONTH_POINTER_SIZE);
        dc.drawLine(Geometry.MONTH_POINTER_X + Geometry.MONTH_POINTER_SIZE, Geometry.MONTH_POINTER_Y, Geometry.MONTH_POINTER_X, Geometry.MONTH_POINTER_Y + Geometry.MONTH_POINTER_SIZE);
    }

    function drawDateWindow(dc) {
        var info = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dayText = info.day.format("%02d");

        dc.setColor(Colors.SHADOW, Colors.SHADOW);
        dc.fillRoundedRectangle(Geometry.DATE_X, Geometry.DATE_Y, Geometry.DATE_WIDTH, Geometry.DATE_HEIGHT, Geometry.DATE_CORNER_RADIUS);
        dc.setPenWidth(Geometry.DATE_BORDER_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(Geometry.DATE_X, Geometry.DATE_Y, Geometry.DATE_WIDTH, Geometry.DATE_HEIGHT, Geometry.DATE_CORNER_RADIUS);
        dc.setColor(Colors.TEXT_WARM, Graphics.COLOR_TRANSPARENT);
        dc.drawText(Geometry.DATE_X + Geometry.DATE_WIDTH / Geometry.HALF_DIVISOR, Geometry.DATE_Y + Geometry.DATE_HEIGHT / Geometry.HALF_DIVISOR, Typography.DATE_FONT_SIZE, dayText, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function drawTimeDial(dc) {
        dc.setColor(Colors.SHADOW, Colors.SHADOW);
        dc.fillCircle(Geometry.SUBDIAL_X, Geometry.SUBDIAL_Y, Geometry.SUBDIAL_RADIUS);
        dc.setPenWidth(Geometry.SUBDIAL_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.SUBDIAL_X, Geometry.SUBDIAL_Y, Geometry.SUBDIAL_RADIUS);
        dc.setPenWidth(Geometry.MONTH_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.SUBDIAL_X, Geometry.SUBDIAL_Y, Geometry.SUBDIAL_INNER_RADIUS);

        for (var i = 0; i < Geometry.SUBDIAL_MARKER_COUNT; i += 1) {
            var angle = degreesToRadians((i * Geometry.SUBDIAL_MARKER_STEP) + Geometry.MARKER_START_ANGLE);
            var x1 = Geometry.SUBDIAL_X + Math.cos(angle) * (Geometry.SUBDIAL_RADIUS - Geometry.SUBDIAL_MARKER_INNER_RADIUS_OFFSET);
            var y1 = Geometry.SUBDIAL_Y + Math.sin(angle) * (Geometry.SUBDIAL_RADIUS - Geometry.SUBDIAL_MARKER_INNER_RADIUS_OFFSET);
            var x2 = Geometry.SUBDIAL_X + Math.cos(angle) * (Geometry.SUBDIAL_RADIUS - Geometry.SUBDIAL_MARKER_OUTER_RADIUS_OFFSET);
            var y2 = Geometry.SUBDIAL_Y + Math.sin(angle) * (Geometry.SUBDIAL_RADIUS - Geometry.SUBDIAL_MARKER_OUTER_RADIUS_OFFSET);
            dc.setPenWidth(Geometry.SUBDIAL_MARKER_WIDTH);
            dc.setColor(Colors.ROSE_GOLD_LIGHT, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(x1, y1, x2, y2);
        }

        drawHands(dc);
    }

    function drawHands(dc) {
        var clock = System.getClockTime();
        var hourAngle = ((clock.hour % Geometry.HOURS_ON_DIAL) * Geometry.HOUR_DEGREES) + (clock.min * Geometry.HOUR_MINUTE_DEGREES) + Geometry.MARKER_START_ANGLE;
        var minAngle = (clock.min * Geometry.MINUTE_DEGREES) + Geometry.MARKER_START_ANGLE;
        var secAngle = (clock.sec * Geometry.MINUTE_DEGREES) + Geometry.MARKER_START_ANGLE;

        drawHand(dc, hourAngle, Geometry.HOUR_HAND_LENGTH, Geometry.HOUR_HAND_WIDTH, Colors.ROSE_GOLD_LIGHT);
        drawHand(dc, minAngle, Geometry.MINUTE_HAND_LENGTH, Geometry.HAND_WIDTH, Colors.TEXT_WARM);

        if (_isAwake) {
            drawHand(dc, secAngle, Geometry.SECOND_HAND_LENGTH, Geometry.SECOND_HAND_WIDTH, Colors.SECOND_HAND);
        }

        dc.setColor(Colors.ROSE_GOLD_LIGHT, Colors.ROSE_GOLD_LIGHT);
        dc.fillCircle(Geometry.SUBDIAL_X, Geometry.SUBDIAL_Y, Geometry.HAND_HUB_RADIUS);
    }

    function drawComplicationPlaceholders(dc) {
        dc.setPenWidth(Geometry.MONTH_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.COMPLICATION_LEFT_X, Geometry.COMPLICATION_LEFT_Y, Geometry.COMPLICATION_LEFT_RADIUS);
        dc.drawCircle(Geometry.COMPLICATION_RIGHT_X, Geometry.COMPLICATION_RIGHT_Y, Geometry.COMPLICATION_RIGHT_RADIUS);
        dc.drawCircle(Geometry.MOON_X, Geometry.MOON_Y, Geometry.MOON_RADIUS);
    }

    function drawSignature(dc) {
        dc.setColor(Colors.ROSE_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawText(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y + Geometry.MOON_RADIUS, Typography.SIGNATURE_FONT_SIZE, "LANGE 970 // V0.1", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawHand(dc, deg, len, width, color) {
        var angle = degreesToRadians(deg);
        var x = Geometry.SUBDIAL_X + Math.cos(angle) * len;
        var y = Geometry.SUBDIAL_Y + Math.sin(angle) * len;
        dc.setPenWidth(width);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(Geometry.SUBDIAL_X, Geometry.SUBDIAL_Y, x, y);
    }

    function degreesToRadians(deg) {
        return deg * Geometry.RADIANS_PER_DEGREE;
    }

    function onHide() as Void {
    }

    function onExitSleep() as Void {
        _isAwake = true;
        WatchUi.requestUpdate();
    }

    function onEnterSleep() as Void {
        _isAwake = false;
        WatchUi.requestUpdate();
    }
}

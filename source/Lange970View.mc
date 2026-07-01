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

        dc.setPenWidth(Geometry.CHAPTER_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.BEZEL_HIGHLIGHT_RADIUS);

        dc.setPenWidth(Geometry.MONTH_RING_THICKNESS);
        dc.setColor(Colors.DIAL_GRAIN, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < Geometry.DIAL_TEXTURE_COUNT; i += 1) {
            dc.drawCircle(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.DIAL_TEXTURE_START_RADIUS + (i * Geometry.DIAL_TEXTURE_STEP));
        }

        dc.setPenWidth(Geometry.MONTH_RING_THICKNESS);
        dc.setColor(Colors.SHADOW, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.BEZEL_SHADOW_RADIUS);
    }

    function drawChapterRing(dc) {
        dc.setPenWidth(Geometry.CHAPTER_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.CHAPTER_RING_RADIUS);

        dc.setPenWidth(Geometry.MONTH_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD_LIGHT, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.CHAPTER_RING_INNER_RADIUS);

        dc.setPenWidth(Geometry.MONTH_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.MONTH_RING_RADIUS);

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
        var span = Geometry.BATTERY_START_ANGLE - Geometry.BATTERY_END_ANGLE;
        if (span < 0) {
            span += Geometry.FULL_CIRCLE_DEGREES;
        }

        var fillEnd = Geometry.BATTERY_START_ANGLE - (span * battery / Geometry.FULL_BATTERY_PERCENT);
        if (fillEnd < 0) {
            fillEnd += Geometry.FULL_CIRCLE_DEGREES;
        }

        dc.setPenWidth(Geometry.MONTH_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.BATTERY_ARC_RADIUS - Geometry.BATTERY_ARC_THICKNESS, Graphics.ARC_CLOCKWISE, Geometry.BATTERY_START_ANGLE, Geometry.BATTERY_END_ANGLE);
        dc.drawArc(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.BATTERY_ARC_RADIUS + Geometry.BATTERY_ARC_THICKNESS, Graphics.ARC_CLOCKWISE, Geometry.BATTERY_START_ANGLE, Geometry.BATTERY_END_ANGLE);

        dc.setPenWidth(Geometry.BATTERY_ARC_THICKNESS);
        dc.setColor(Colors.BATTERY_TRACK, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.BATTERY_ARC_RADIUS, Graphics.ARC_CLOCKWISE, Geometry.BATTERY_START_ANGLE, Geometry.BATTERY_END_ANGLE);

        dc.setPenWidth(Geometry.BATTERY_FILL_THICKNESS);
        dc.setColor(Colors.BATTERY_FILL, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(Geometry.WATCH_CENTER_X, Geometry.WATCH_CENTER_Y, Geometry.BATTERY_ARC_RADIUS, Graphics.ARC_CLOCKWISE, Geometry.BATTERY_START_ANGLE, fillEnd);

        var startRadians = degreesToRadians(Geometry.BATTERY_START_ANGLE);
        var endRadians = degreesToRadians(Geometry.BATTERY_END_ANGLE);
        var fillRadians = degreesToRadians(fillEnd);
        var startX = Geometry.WATCH_CENTER_X + Math.cos(startRadians) * Geometry.BATTERY_ARC_RADIUS;
        var startY = Geometry.WATCH_CENTER_Y - Math.sin(startRadians) * Geometry.BATTERY_ARC_RADIUS;
        var endX = Geometry.WATCH_CENTER_X + Math.cos(endRadians) * Geometry.BATTERY_ARC_RADIUS;
        var endY = Geometry.WATCH_CENTER_Y - Math.sin(endRadians) * Geometry.BATTERY_ARC_RADIUS;
        var fillX = Geometry.WATCH_CENTER_X + Math.cos(fillRadians) * Geometry.BATTERY_ARC_RADIUS;
        var fillY = Geometry.WATCH_CENTER_Y - Math.sin(fillRadians) * Geometry.BATTERY_ARC_RADIUS;

        dc.setColor(Colors.ROSE_GOLD_DIM, Colors.ROSE_GOLD_DIM);
        dc.fillCircle(startX, startY, Geometry.BATTERY_CAP_RADIUS);
        dc.fillCircle(endX, endY, Geometry.BATTERY_CAP_RADIUS);
        dc.setColor(Colors.BATTERY_FILL, Colors.BATTERY_FILL);
        dc.fillCircle(fillX, fillY, Geometry.BATTERY_CAP_RADIUS);
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
        var leftDigit = (info.day / 10).format("%d");
        var rightDigit = (info.day % 10).format("%d");

        dc.setColor(Colors.SHADOW, Colors.SHADOW);
        dc.fillRoundedRectangle(Geometry.DATE_X - Geometry.DATE_BORDER_THICKNESS, Geometry.DATE_Y - Geometry.DATE_BORDER_THICKNESS, Geometry.DATE_WIDTH + (Geometry.DATE_BORDER_THICKNESS * Geometry.HALF_DIVISOR), Geometry.DATE_HEIGHT + (Geometry.DATE_BORDER_THICKNESS * Geometry.HALF_DIVISOR), Geometry.DATE_CORNER_RADIUS);
        dc.setColor(Colors.APERTURE_FILL, Colors.APERTURE_FILL);
        dc.fillRoundedRectangle(Geometry.DATE_X, Geometry.DATE_Y, Geometry.DATE_WIDTH, Geometry.DATE_HEIGHT, Geometry.DATE_CORNER_RADIUS);
        dc.setPenWidth(Geometry.DATE_BORDER_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(Geometry.DATE_X, Geometry.DATE_Y, Geometry.DATE_WIDTH, Geometry.DATE_HEIGHT, Geometry.DATE_CORNER_RADIUS);
        dc.drawLine(Geometry.DATE_DIVIDER_X, Geometry.DATE_Y, Geometry.DATE_DIVIDER_X, Geometry.DATE_Y + Geometry.DATE_HEIGHT);
        dc.setColor(Colors.SHADOW, Graphics.COLOR_TRANSPARENT);
        dc.drawText(Geometry.DATE_LEFT_CENTER_X, Geometry.DATE_Y + Geometry.DATE_HEIGHT / Geometry.HALF_DIVISOR, Typography.DATE_FONT_SIZE, leftDigit, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(Geometry.DATE_RIGHT_CENTER_X, Geometry.DATE_Y + Geometry.DATE_HEIGHT / Geometry.HALF_DIVISOR, Typography.DATE_FONT_SIZE, rightDigit, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function drawTimeDial(dc) {
        dc.setColor(Colors.SHADOW, Colors.SHADOW);
        dc.fillCircle(Geometry.SUBDIAL_X, Geometry.SUBDIAL_Y, Geometry.SUBDIAL_SHADOW_RADIUS);
        dc.setColor(Colors.DIAL_DEPTH, Colors.DIAL_DEPTH);
        dc.fillCircle(Geometry.SUBDIAL_X, Geometry.SUBDIAL_Y, Geometry.SUBDIAL_RADIUS);
        dc.setPenWidth(Geometry.SUBDIAL_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.SUBDIAL_X, Geometry.SUBDIAL_Y, Geometry.SUBDIAL_RADIUS);
        dc.setPenWidth(Geometry.MONTH_RING_THICKNESS);
        dc.setColor(Colors.ROSE_GOLD_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.SUBDIAL_X, Geometry.SUBDIAL_Y, Geometry.SUBDIAL_INNER_RADIUS);
        dc.setColor(Colors.DIAL_GRAIN, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(Geometry.SUBDIAL_X, Geometry.SUBDIAL_Y, Geometry.SUBDIAL_HIGHLIGHT_RADIUS);

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

        drawSubdialNumerals(dc);
        drawHands(dc);
    }

    function drawSubdialNumerals(dc) {
        dc.setColor(Colors.TEXT_WARM, Graphics.COLOR_TRANSPARENT);
        dc.drawText(Geometry.SUBDIAL_X, Geometry.SUBDIAL_Y - Geometry.SUBDIAL_NUMERAL_RADIUS, Typography.SUBDIAL_FONT_SIZE, "XII", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(Geometry.SUBDIAL_X + Geometry.SUBDIAL_NUMERAL_RADIUS, Geometry.SUBDIAL_Y, Typography.SUBDIAL_FONT_SIZE, "III", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(Geometry.SUBDIAL_X, Geometry.SUBDIAL_Y + Geometry.SUBDIAL_NUMERAL_RADIUS, Typography.SUBDIAL_FONT_SIZE, "VI", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(Geometry.SUBDIAL_X - Geometry.SUBDIAL_NUMERAL_RADIUS, Geometry.SUBDIAL_Y, Typography.SUBDIAL_FONT_SIZE, "IX", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
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
        dc.setColor(Colors.SHADOW, Colors.SHADOW);
        dc.fillCircle(Geometry.COMPLICATION_LEFT_X, Geometry.COMPLICATION_LEFT_Y, Geometry.COMPLICATION_LEFT_RADIUS);
        dc.fillCircle(Geometry.COMPLICATION_RIGHT_X, Geometry.COMPLICATION_RIGHT_Y, Geometry.COMPLICATION_RIGHT_RADIUS);
        dc.fillCircle(Geometry.MOON_X, Geometry.MOON_Y, Geometry.MOON_RADIUS);
        dc.setColor(Colors.DIAL_DEPTH, Colors.DIAL_DEPTH);
        dc.fillCircle(Geometry.COMPLICATION_LEFT_X, Geometry.COMPLICATION_LEFT_Y, Geometry.COMPLICATION_LEFT_RADIUS - Geometry.DATE_BORDER_THICKNESS);
        dc.fillCircle(Geometry.COMPLICATION_RIGHT_X, Geometry.COMPLICATION_RIGHT_Y, Geometry.COMPLICATION_RIGHT_RADIUS - Geometry.DATE_BORDER_THICKNESS);
        dc.fillCircle(Geometry.MOON_X, Geometry.MOON_Y, Geometry.MOON_RADIUS - Geometry.DATE_BORDER_THICKNESS);
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

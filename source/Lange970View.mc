import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;

class Lange970View extends WatchUi.WatchFace {

    const COLOR_BG       = 0x11100F;
    const COLOR_DIAL     = 0x1A1816;
    const COLOR_DIAL_2   = 0x24211E;
    const COLOR_GOLD     = 0xC79A58;
    const COLOR_GOLD_2   = 0xE0B56E;
    const COLOR_MUTED    = 0x756A5E;
    const COLOR_DARK     = 0x080807;
    const COLOR_TEXT     = 0xE7D4B7;

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
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;
        var cy = h / 2;
        var r = (w < h ? w : h) / 2 - 6;

        drawBackground(dc, cx, cy, r);
        drawMonthRing(dc, cx, cy, r);
        drawBatteryArc(dc, cx, cy, r - 22);
        drawDateWindow(dc, cx, cy);
        drawOffCenterDial(dc, cx + 50, cy - 58, 86);
        drawSignature(dc, cx, cy);
    }

    function drawBackground(dc, cx, cy, r) {
        dc.setColor(COLOR_BG, COLOR_BG);
        dc.clear();

        dc.setColor(COLOR_DIAL, COLOR_DIAL);
        dc.fillCircle(cx, cy, r);

        // Subtle dial depth rings.
        dc.setPenWidth(2);
        dc.setColor(COLOR_DIAL_2, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, r - 10);
        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, r - 23);

        // Rose-gold outer ring.
        dc.setPenWidth(3);
        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, r - 2);
        dc.setPenWidth(1);
        dc.setColor(COLOR_GOLD_2, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, r - 9);

        // Minute / hour markers.
        for (var i = 0; i < 60; i += 1) {
            var a = degreesToRadians(i * 6 - 90);
            var outer = r - 17;
            var inner = (i % 5 == 0) ? r - 34 : r - 25;
            var x1 = cx + Math.cos(a) * inner;
            var y1 = cy + Math.sin(a) * inner;
            var x2 = cx + Math.cos(a) * outer;
            var y2 = cy + Math.sin(a) * outer;
            dc.setPenWidth(i % 5 == 0 ? 3 : 1);
            dc.setColor(i % 5 == 0 ? COLOR_GOLD_2 : COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(x1, y1, x2, y2);
        }
    }

    function drawMonthRing(dc, cx, cy, r) {
        var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
        var radius = r - 50;

        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < 12; i += 1) {
            // Put JUN at 6 o'clock, DEC at 12 o'clock, like a physical ring viewed from the front.
            var deg = (i * 30) + 120;
            var a = degreesToRadians(deg);
            var x = cx + Math.cos(a) * radius;
            var y = cy + Math.sin(a) * radius;
            dc.drawText(x, y, Graphics.FONT_XTINY, months[i], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        // Month pointer at 6 o'clock pointing outward to the month ring.
        dc.setPenWidth(2);
        dc.setColor(COLOR_GOLD_2, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(cx, cy + r - 57, cx, cy + r - 38);
        dc.drawLine(cx - 7, cy + r - 45, cx, cy + r - 57);
        dc.drawLine(cx + 7, cy + r - 45, cx, cy + r - 57);
    }

    function drawBatteryArc(dc, cx, cy, r) {
        var stats = System.getSystemStats();
        var battery = stats.battery;
        var startDeg = 232;   // about 7:45
        var endDeg = 30;      // about 2 o'clock
        var span = 158;
        var fillEnd = startDeg + (span * battery / 100.0);
        if (fillEnd > 360) { fillEnd -= 360; }

        dc.setPenWidth(6);
        dc.setColor(0x2C2925, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(cx, cy, r, Graphics.ARC_CLOCKWISE, startDeg, endDeg);

        dc.setPenWidth(5);
        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(cx, cy, r, Graphics.ARC_CLOCKWISE, startDeg, fillEnd);
    }

    function drawDateWindow(dc, cx, cy) {
        var info = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dayText = now.day.format("%02d");
        var x = cx - 108;
        var y = cy - 88;
        var ww = 74;
        var hh = 48;

        dc.setColor(COLOR_DARK, COLOR_DARK);
        dc.fillRoundedRectangle(x, y, ww, hh, 8);
        dc.setPenWidth(2);
        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(x, y, ww, hh, 8);
        dc.setColor(COLOR_TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + ww / 2, y + hh / 2, Graphics.FONT_NUMBER_MEDIUM, dayText, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function drawOffCenterDial(dc, cx, cy, r) {
        dc.setColor(COLOR_DARK, COLOR_DARK);
        dc.fillCircle(cx, cy, r);
        dc.setPenWidth(3);
        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, r);
        dc.setPenWidth(1);
        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, r - 12);

        for (var i = 0; i < 12; i += 1) {
            var a = degreesToRadians(i * 30 - 90);
            var x1 = cx + Math.cos(a) * (r - 23);
            var y1 = cy + Math.sin(a) * (r - 23);
            var x2 = cx + Math.cos(a) * (r - 10);
            var y2 = cy + Math.sin(a) * (r - 10);
            dc.setPenWidth(2);
            dc.setColor(COLOR_GOLD_2, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(x1, y1, x2, y2);
        }

        var clock = System.getClockTime();
        var hourAngle = ((clock.hour % 12) * 30) + (clock.min * 0.5) - 90;
        var minAngle = (clock.min * 6) - 90;
        var secAngle = (clock.sec * 6) - 90;

        drawHand(dc, cx, cy, hourAngle, r * 0.42, 5, COLOR_GOLD_2);
        drawHand(dc, cx, cy, minAngle, r * 0.68, 3, COLOR_TEXT);

        if (_isAwake) {
            drawHand(dc, cx, cy, secAngle, r * 0.72, 1, 0xD7C6A4);
        }

        dc.setColor(COLOR_GOLD_2, COLOR_GOLD_2);
        dc.fillCircle(cx, cy, 6);
    }

    function drawSignature(dc, cx, cy) {
        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx - 6, cy + 48, Graphics.FONT_XTINY, "LANGE 970 // V0.1", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawHand(dc, cx, cy, deg, len, width, color) {
        var a = degreesToRadians(deg);
        var x = cx + Math.cos(a) * len;
        var y = cy + Math.sin(a) * len;
        dc.setPenWidth(width);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(cx, cy, x, y);
    }

    function degreesToRadians(deg) {
        return deg * 3.14159265 / 180.0;
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

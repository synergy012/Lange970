module Geometry {
    // Screen
    const SCREEN_WIDTH = 454;
    const SCREEN_HEIGHT = 454;
    const WATCH_CENTER_X = 227;
    const WATCH_CENTER_Y = 227;

    // Outer dial
    const WATCH_RADIUS = 226;
    const CHAPTER_RING_RADIUS = 214;
    const CHAPTER_RING_THICKNESS = 3;
    const CHAPTER_RING_INNER_RADIUS = 205;
    const DIAL_DEPTH_RADIUS = 198;
    const DIAL_INNER_RADIUS = 190;
    const BEZEL_HIGHLIGHT_RADIUS = 218;
    const BEZEL_SHADOW_RADIUS = 202;
    const DIAL_TEXTURE_START_RADIUS = 32;
    const DIAL_TEXTURE_STEP = 22;
    const DIAL_TEXTURE_COUNT = 8;

    // Chapter markers
    const MINUTE_MARKER_COUNT = 60;
    const HOUR_MARKER_INTERVAL = 5;
    const MARKER_START_ANGLE = -90;
    const MINUTE_MARKER_STEP = 6;
    const HOUR_MARKER_WIDTH = 2;
    const MINUTE_MARKER_WIDTH = 1;
    const MARKER_OUTER_RADIUS = 202;
    const HOUR_MARKER_INNER_RADIUS = 188;
    const MINUTE_MARKER_INNER_RADIUS = 195;

    // Month ring
    const MONTH_RING_RADIUS = 213;
    const MONTH_RING_THICKNESS = 2;
    const MONTH_TEXT_RADIUS = 219;
    const MONTH_TEXT_SIZE = 0;
    const MONTH_COUNT = 12;
    const MONTH_STEP_ANGLE = 30;
    const MONTH_START_ANGLE = 120;
    const MONTH_POINTER_X = 227;
    const MONTH_POINTER_Y = 408;
    const MONTH_POINTER_SIZE = 13;

    // Battery arc
    const BATTERY_ARC_RADIUS = 204;
    const BATTERY_ARC_THICKNESS = 5;
    const BATTERY_START_ANGLE = 198;
    const BATTERY_END_ANGLE = 18;
    const BATTERY_FILL_THICKNESS = 3;
    const BATTERY_CAP_RADIUS = 3;
    const FULL_CIRCLE_DEGREES = 360;

    // Time subdial
    const SUBDIAL_X = 314;
    const SUBDIAL_Y = 219;
    const SUBDIAL_RADIUS = 110;
    const SUBDIAL_RING_THICKNESS = 2;
    const SUBDIAL_INNER_RADIUS = 69;
    const SUBDIAL_SHADOW_RADIUS = 113;
    const SUBDIAL_HIGHLIGHT_RADIUS = 106;
    const SUBDIAL_NUMERAL_RADIUS = 74;
    const SUBDIAL_MARKER_COUNT = 12;
    const SUBDIAL_MARKER_STEP = 30;
    const SUBDIAL_MARKER_OUTER_RADIUS_OFFSET = 18;
    const SUBDIAL_MARKER_INNER_RADIUS_OFFSET = 28;
    const SUBDIAL_MARKER_WIDTH = 2;

    // Date window
    const DATE_X = 138;
    const DATE_Y = 61;
    const DATE_WIDTH = 82;
    const DATE_HEIGHT = 45;
    const DATE_CORNER_RADIUS = 0;
    const DATE_BORDER_THICKNESS = 3;
    const DATE_DIVIDER_X = 179;
    const DATE_LEFT_CENTER_X = 158;
    const DATE_RIGHT_CENTER_X = 199;

    // Moonphase/seconds aperture
    const MOON_X = 221;
    const MOON_Y = 360;
    const MOON_RADIUS = 50;

    // Complications
    const COMPLICATION_LEFT_X = 106;
    const COMPLICATION_LEFT_Y = 159;
    const COMPLICATION_LEFT_RADIUS = 55;
    const COMPLICATION_RIGHT_X = 113;
    const COMPLICATION_RIGHT_Y = 297;
    const COMPLICATION_RIGHT_RADIUS = 68;

    // Hands
    const HOUR_HAND_LENGTH = 48;
    const MINUTE_HAND_LENGTH = 82;
    const SECOND_HAND_LENGTH = 78;
    const HAND_WIDTH = 3;
    const HOUR_HAND_WIDTH = 5;
    const SECOND_HAND_WIDTH = 1;
    const HAND_HUB_RADIUS = 5;

    // Time math
    const HOURS_ON_DIAL = 12;
    const HOUR_DEGREES = 30;
    const MINUTE_DEGREES = 6;
    const HOUR_MINUTE_DEGREES = 0.5;
    const HALF_DIVISOR = 2;
    const FULL_BATTERY_PERCENT = 100.0;
    const RADIANS_PER_DEGREE = 3.14159265 / 180.0;
}

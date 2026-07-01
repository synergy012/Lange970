module Geometry {
    // Screen
    const SCREEN_WIDTH = 454;
    const SCREEN_HEIGHT = 454;
    const WATCH_CENTER_X = 227;
    const WATCH_CENTER_Y = 227;

    // Outer dial
    const WATCH_RADIUS = 221;
    const CHAPTER_RING_RADIUS = 219;
    const CHAPTER_RING_THICKNESS = 3;
    const CHAPTER_RING_INNER_RADIUS = 212;
    const DIAL_DEPTH_RADIUS = 211;
    const DIAL_INNER_RADIUS = 198;

    // Chapter markers
    const MINUTE_MARKER_COUNT = 60;
    const HOUR_MARKER_INTERVAL = 5;
    const MARKER_START_ANGLE = -90;
    const MINUTE_MARKER_STEP = 6;
    const HOUR_MARKER_WIDTH = 3;
    const MINUTE_MARKER_WIDTH = 1;
    const MARKER_OUTER_RADIUS = 204;
    const HOUR_MARKER_INNER_RADIUS = 187;
    const MINUTE_MARKER_INNER_RADIUS = 196;

    // Month ring
    const MONTH_RING_RADIUS = 171;
    const MONTH_RING_THICKNESS = 1;
    const MONTH_TEXT_RADIUS = 171;
    const MONTH_TEXT_SIZE = 0;
    const MONTH_COUNT = 12;
    const MONTH_STEP_ANGLE = 30;
    const MONTH_START_ANGLE = 120;
    const MONTH_POINTER_X = 227;
    const MONTH_POINTER_Y = 391;
    const MONTH_POINTER_SIZE = 14;

    // Battery arc
    const BATTERY_ARC_RADIUS = 199;
    const BATTERY_ARC_THICKNESS = 6;
    const BATTERY_START_ANGLE = 232;
    const BATTERY_END_ANGLE = 30;
    const BATTERY_FILL_THICKNESS = 5;
    const FULL_CIRCLE_DEGREES = 360;

    // Time subdial
    const SUBDIAL_X = 277;
    const SUBDIAL_Y = 169;
    const SUBDIAL_RADIUS = 86;
    const SUBDIAL_RING_THICKNESS = 3;
    const SUBDIAL_INNER_RADIUS = 74;
    const SUBDIAL_MARKER_COUNT = 12;
    const SUBDIAL_MARKER_STEP = 30;
    const SUBDIAL_MARKER_OUTER_RADIUS_OFFSET = 10;
    const SUBDIAL_MARKER_INNER_RADIUS_OFFSET = 23;
    const SUBDIAL_MARKER_WIDTH = 2;

    // Date window
    const DATE_X = 119;
    const DATE_Y = 139;
    const DATE_WIDTH = 74;
    const DATE_HEIGHT = 48;
    const DATE_CORNER_RADIUS = 8;
    const DATE_BORDER_THICKNESS = 2;

    // Moonphase/seconds aperture
    const MOON_X = 165;
    const MOON_Y = 308;
    const MOON_RADIUS = 50;

    // Complications
    const COMPLICATION_LEFT_X = 112;
    const COMPLICATION_LEFT_Y = 191;
    const COMPLICATION_LEFT_RADIUS = 34;
    const COMPLICATION_RIGHT_X = 292;
    const COMPLICATION_RIGHT_Y = 326;
    const COMPLICATION_RIGHT_RADIUS = 28;

    // Hands
    const HOUR_HAND_LENGTH = 36;
    const MINUTE_HAND_LENGTH = 58;
    const SECOND_HAND_LENGTH = 62;
    const HAND_WIDTH = 3;
    const HOUR_HAND_WIDTH = 5;
    const SECOND_HAND_WIDTH = 1;
    const HAND_HUB_RADIUS = 6;

    // Time math
    const HOURS_ON_DIAL = 12;
    const HOUR_DEGREES = 30;
    const MINUTE_DEGREES = 6;
    const HOUR_MINUTE_DEGREES = 0.5;
    const HALF_DIVISOR = 2;
    const FULL_BATTERY_PERCENT = 100.0;
    const RADIANS_PER_DEGREE = 3.14159265 / 180.0;
}

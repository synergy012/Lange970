# Design Specification

## Design Language

Luxury mechanical-inspired analog watch face. Original design, inspired by high-end perpetual calendar watches without copying any commercial design.

## Colors

- Background: matte charcoal / near black
- Accents: rose gold
- Text: warm off-white / muted gold
- Secondary details: dark gray

## Layout

Screen size: 454 × 454  
Main center: 227, 227

## Major Elements

### Outer Month Ring

- Month abbreviations: JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC
- Text behaves like engraving on a physical rotating ring:
  - JUN at 6 o’clock is right-side up
  - DEC at 12 o’clock is upside down
  - All months rotate tangent to the ring

### Month Pointer

Small rose-gold triangle at 6 o’clock pointing outward toward the month ring.

### Battery Arc

- Starts around 7:15
- Ends around 2:00
- No numbers
- Should feel like a mechanical power-reserve indicator

### Off-Center Time Dial

- Center near x=285, y=170
- Analog hour and minute hands
- No center seconds hand

### Date Window

- Upper-left quadrant
- Large two-digit day
- Rose-gold frame

### Moonphase / Seconds

- Lower-left/lower-center aperture
- Seconds should eventually sweep here, not from the main center
## Get Application
Version: 0.1

GH-Pages site: https://alpiepho.github.io/hexcalc_tn/

or QR Code:

![QR Code](./qr-code.png)


## hexcalc_tn

This is my version of a hexcalc as a PWA (prgressive web app), written in Flutter.

I like the look and feel of [cp hexcalc](https://www.fileviewer.com/cphexcalc/) that is available for IOS.
But there are other features I would like:
- Deploy as a PWA for multiple platforms
- Allow showing multiple lines
- Allow for RPN (reverse polish notation, "enter" instead of "=")
- Allow for entering text expressions
- Allow for some scientific operations

So my goal is to build a Flutter Web app modeled after "cp hexcalc", then expand the features.

## Operation

Most of the opeartion should be self evident, but we should clarify a few things:
- select mode from top keys, digit keys will change
- enter setting page using 'i' button
- setting persist (for next start of app) upon the back button ("<-")
- hopefully settings are self evident
- memory functions:
- "M+" - add current value to MEM value
- "M-" - subract current value to MEM value
- "Min" - set internal MEM value
- "MR" - MEM recall
- "MC" = MEM clear


## Test/Record Keys

With so many functions in this application, it became a daunting task to add unit testing around the compute engine.
Instead, we have added keys to starting testing or record key strokes.  The idea is the application will have a 
set of built in tests that can be run at will.  It also has the ability to record new sequences and copy to a clipboard.

Those saved sequences can be emailed to the devloper to add to the tests, or debug issues found by a user.

## Learnings
- Flutter is fun
- Composed tree of widgets can get long and duplicate sections quickly
- Found some original features difficult to implement in Flutter, so deferred
- Found success doing small changes and deploying (using script run_peanut.sh)
- Like Flutter in VSCode
- Found my TODO list below to be good to track progress
- Found scattered TODO items in code distracting


## Ongoing Progress

- BASIC IMPLEMENTATION
- [done] copy/modify lib/components from scoreboard_tn
- [done] copy lib/consts
- [done] copy lib/engine
- [done] update main.dart
- [done] convert score_card to calc_button
- [done] clean up warnings
- [done] duplicate features from main screen
- [done] change labels
- [done] expand results lines based on engine
- [done] engine process chars
- [done] engine change result
- [done] remove settings_button
- [done] engine: key disable based on mode
- [done] engine: process number entry
- [done] engine: process CE
- [done] engine: process HEX,DEC,BIN,OCT
- [done] engine: process unary SHL,SHR,ROL,ROR,NEG,NOT
- [done] settings: number bits, 8,12,16,24,32,48,64
- [done] settings: signed/unsigned
- [done] settings: key click
- [done] settings: sounds
- [done] settings: CE as backspace
- [done] settings: dozenal (base 12)
- [done] settings: operator prcedences
- [done] settings: number lines, 1 or 4
- [done] settings: for rpn
- [done] settings: for float
- [done] settings: warning when not supported
- [done] engine/ui: buttons based on rpn and float
- [done] engine/ui: parse buttons adjust
- [done] cleanup commented out code
- [done] results: copy
- [done] results: paste
- [done] no landscape
- [done] favicon
- [done] review constants
- [done] from settings: ce as backspace
- [done] review stack display
- [done] add yellow text for op pending
- [done] add mem functions
- [done] add yellow text for mem active
- [done] results: use clipboard?
- [done] engine: fix NEG (as +/-)
- [done] from settings: number bits
- [done] from settings: unsigned
- [done] engine: process operations
- [done] from settings: dozenal
- [done] save preferences
- [done] update README
- [done] refactor duplicate code
- [done] refactor settings 1,2,3,4 toggle switch
- [done] refactor settings off/on toggle switch
- [done] from settings: rpm
- [done] engine/ui: rpm, stack (keys: push,pop,rot)
- [done] engine/ui: non-rpm expression instead of precedence (keys: push,pop,rot (, ) )
- [done] from settings: floating point
- [done] add decimal places
- [done] fp <-> dec stack
- [done] added copy button if swipe doesn't work
- [done] engine/ui: additional scientific functions
- [done] 1/x
- [done] x^2
- [done] sqrt(x)
- [done] y^x
- [done] pi
- [done] sin
- [done] cos
- [done] tan
- [done] rad?
- [done] deg?
- [done] e
- [done] 10^x
- [done] e^x
- [done] ln
- [done] asin
- [done] acos
- [done] atan
- [done] truncate
- [done] floor
- [done] ceil
- [done] remove swipe to copy?
- [na] fix InkWell splash, ink is behind the decoration/gradient

- EXAPNDED IMPLEMENTATION
- paste expression?
  - setting to allow "paste expressions"
  - on paste
    - verify floating
    - verify (mach parens etc?)
    - replace consts (pi, = etc)
    - replace stack[], x, y etc
    - build expression
    - evaluate
    - warning on errors

- store pasted expression???

- BUGS
- settings, rotate, rotate back, done...stuck on grey screen
- engine: unit testing
- fix 64 bit (BigInt for 64 and bitwise?)
- refactor engine, clean up dec/floating/scientific
- fix setting HEX->DOZ not auto change keys after settings

- DEVIATION FROM EXAMPLE
- from settings: key clicks
- from settings: sounds
- from settings: precedence
- finish hex/dec/oct/bin outline




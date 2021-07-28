## Get Application
Version: 0.1

GH-Pages site: https://alpiepho.github.io/hexcalc_tn/

## hexcalc_tn


Goal:<br>
semi-duplicate hexcalc from [cp hexcalc](https://www.fileviewer.com/cphexcalc/), 
then modify for RPN (reverse polish notation) and other features I want.

My intent is to practice with Flutter, not steal a design.  This will not be offered as a product.

Also want this to be a PWA.

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
- refactor duplicate code
- update README

- EXAPNDED IMPLEMENTATION
- from settings: rpm
- from settings: floating point
- engine/ui: rpm, stack (keys: push,pop,rot)
- engine/ui: non-rpm expression instead of precedence (keys: push,pop,rot (, ) )
- engine/ui: additional scientific functions

- BUGS
- engine: unit testing
- fix 64 bit (BigInt for 64 and bitwise?)
- fix InkWell splash, ink is behind the decoration/gradient
- fix setting HEX->DOZ not auto change keys after settings

- FUTURE
- from settings: key clicks
- from settings: sounds
- from settings: precedence
- finish hex/dec/oct/bin outline




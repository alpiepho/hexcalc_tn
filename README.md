## Get Application
Version: 0.1

GH-Pages site: https://alpiepho.github.io/hexcalc_tn/

## hexcalc_tn


Goal:<br>
semi-duplicate hexcalc from [cp hexcalc](https://www.fileviewer.com/cphexcalc/), 
then modify for RPN (reverse polish notation) and other features I want.

My intent is to practice with Flutter, not steal a design.  This will not be offered as a product.

Also want this to be a PWA.

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

- engine/ui: buttons based on rpn and float

- results: copy
- results: paste

- engine: process operations

- engine: refactor ops as function pointers

- cleanup commented out code
- look for refactor opportunies
- save preferences

- duplicate features from settings screen
- add rpn
- add decimal point and support for float
- add parens for non-rpn

- finish hex/dec/oct/bin outline
- fix InkWell splash, ink is plashed behind the decoration/gradient
- how to support 64 bit in pwa?

- review constants
- update README
- get devide symbol?


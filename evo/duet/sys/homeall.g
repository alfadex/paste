; homeall.g
;
; called to home all axes
;M117 Started Home All

G91               ; relative positioning
M400
M913 Z25          ; Z motors to 25% current
G1 Z5 F2000 S2    ; lift Z relative to current position
M400
M913 Z100         ; Z motors to 100% current
M280 P3 S160 I1   ; Reset bltouch in case it didn't have vertical clearance for self test.

; Reduce accelleration for the stall detection to be more reliable.
; We restore it later via configstd.g
;M566 X600 Y600 Z100 E600
;M201 X600 Y600 Z30 E600

M98 P"/sys/mode_stall.g"

; Home X
M400
M913 X35 Y35      ; XY motors to 35% current
G1 S1 X-320 F3600 ; move until motors hit X min and stall
G1 X10 F6000      ; go back a few mm on X
M400
M913 X100 Y100    ; XY motors to 100% current

; Home Y
M400
M913 X35 Y35      ; XY motors to 35% current
G1 S1 Y-320 F3600 ; move until motors hit Y min and stall
G1 Y10 F6000      ; go back a few mm on Y
M400
M913 X100 Y100    ; XY motors to 100% current

; Restore standard config
M98 P"/sys/mode_normal.g"

; Home Z
M400
G90               ; absolute positioning
G1 X5 Y29 F6000   ; go to probing point (close to edge, for better support if bltouch fails)
M400
M913 Z50          ; Z motors to 50% current, in case something goes wrong with bltouch
;M558 A1 F800      ; Set for probing at fast speed, single probe
M558 A1 F1200      ; Set for probing at fast speed, single probe
G30               ; Probe and home Z (pass 1)
M400
M400
M913 Z100         ; Z motors to 100% current
M558 A5 F100	  ; Set for probing at slow speed, allow multiple trys
G30               ; Probe and home Z

M98 P"/macros/park_up"

;M117 Ended Home All

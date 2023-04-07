; The CMD file.
;
; Two parts: 1. Command definition and  2. State entry
; (state entry is after the commands def section)
;
; 1. Command definition
; ---------------------
; Note: The commands are CASE-SENSITIVE, and so are the command names.
; The eight directions are:
;   B, DB, D, DF, F, UF, U, UB     (all CAPS)
;   corresponding to back, down-back, down, downforward, etc.
; The six buttons are:
;   a, b, c, x, y, z               (all lower case)
;   In default key config, abc are are the bottom, and xyz are on the
;   top row. For 2 button characters, we recommend you use a and b.
;   For 6 button characters, use abc for kicks and xyz for punches.
;
; Each [Command] section defines a command that you can use for
; state entry, as well as in the CNS file.
; The command section should look like:
;
;   [Command]
;   name = some_name
;   command = the_command
;   time = time (optional -- defaults to 15 if omitted)
;
; - some_name
;   A name to give that command. You'll use this name to refer to
;   that command in the state entry, as well as the CNS. It is case-
;   sensitive (QCB_a is NOT the same as Qcb_a or QCB_A).
;
; - command
;   list of buttons or directions, separated by commas.
;   Directions and buttons can be preceded by special characters:
;   slash (/) - means the key must be held down
;          egs. command = /D       ;hold the down direction
;               command = /DB, a   ;hold down-back while you press a
;   tilde (~) - to detect key releases
;          egs. command = ~a       ;release the a button
;               command = ~D, F, a ;release down, press fwd, then a
;          If you want to detect "charge moves", you can specify
;          the time the key must be held down for (in game-ticks)
;          egs. command = ~30a     ;hold a for at least 30 ticks, then release
;               command = ~30
;   dollar ($) - Direction-only: detect as 4-way
;          egs. command = $D       ;will detect if D, DB or DF is held
;               command = $B       ;will detect if B, DB or UB is held
;   plus (+) - Buttons only: simultaneous press
;          egs. command = a+b      ;press a and b at the same time
;               command = x+y+z    ;press x, y and z at the same time
;   You can combine them:
;     eg. command = ~30$D, a+b     ;hold D, DB or DF for 30 ticks, release,
;                                  ;then press a and b together
;   It's recommended that for most "motion" commads, eg. quarter-circle-fwd,
;   you start off with a "release direction". This matches the way most
;   popular fighting games implement their engine.
;
; - time (optional)
;   Time allowed to do the command, given in game-ticks. Defaults to 15
;   if omitted
;
; If you have two or more commands with the same name, all of them will
; work. You can use it to allow multiple motions for the same move.
;
; Some common commands are given below. Delete, add, or modify as you wish.


;-| Super Motions |--------------------------------------------------------
[Command]
name = "QCF_xy"
command = ~D, DF, F, x+y

;The following two have the same name, but different motion.
;Either one will be detected by a "command = TripleKFPalm" trigger.
;Time is set to 20 (instead of default of 15) to make the move
;easier to do.
;
[Command]
name = "TripleKFPalm"
command = ~D, DF, F, D, DF, F, x
time = 20

[Command] 
name = "TripleKFPalm"   ;Same name as above
command = ~D, DF, F, D, DF, F, y
time = 20

;-| Special Motions |------------------------------------------------------
[Command]
name = "QCF_x"
command = ~D, DF, F, x

[Command]
name = "QCF_y"
command = ~D, DF, F, y

[Command]
name = "QCB_a"
command = ~D, DF, F, a

[Command]
name = "QCB_b"
command = ~D, DF, F, b

;-| Double Tap |-----------------------------------------------------------
[Command]
name = "FF"     ;Required (do not remove)
command = F, F
time = 10

[Command]
name = "BB"     ;Required (do not remove)
command = B, B
time = 10

;-| 2/3 Button Combination |-----------------------------------------------
[Command]
name = "recovery";Required (do not remove)
command = x+y
time = 1

;-| Dir + Button |---------------------------------------------------------
[Command]
name = "fwd_a"
command = /F,a
time = 1

[Command]
name = "fwd_b"
command = /F,b
time = 1

[Command]
name = "back_a"
command = /B,a
time = 1

[Command]
name = "back_b"
command = /B,b
time = 1

[Command]
name = "down_a"
command = /$D,a
time = 1

[Command]
name = "down_b"
command = /$D,b
time = 1

;-| Single Button |---------------------------------------------------------
[Command]
name = "a"
command = a
time = 1

[Command]
name = "b"
command = b
time = 1

[Command]
name = "c"
command = c
time = 1

[Command]
name = "x"
command = x
time = 1

[Command]
name = "y"
command = y
time = 1

[Command]
name = "z"
command = z
time = 1

[Command]
name = "start"
command = s
time = 1

;-| Hold Dir |--------------------------------------------------------------
[Command]
name = "holdfwd";Required (do not remove)
command = /$F
time = 1

[Command]
name = "holdback";Required (do not remove)
command = /$B
time = 1

[Command]
name = "holdup" ;Required (do not remove)
command = /$U
time = 1

[Command]
name = "holddown";Required (do not remove)
command = /$D
time = 1

;---------------------------------------------------------------------------
; 2. State entry
; --------------
; This is where you define what commands bring you to what states.
;
; Each state entry block looks like:
;   [State -1, Label]           ;Change Label to any name you want to use to
;                               ;identify the state with.
;   type = ChangeState          ;Don't change this
;   value = new_state_number
;   trigger1 = command = command_name
;   . . .  (any additional triggers)
;
; - new_state_number is the number of the state to change to
; - command_name is the name of the command (from the section above)
; - Useful triggers to know:
;   - statetype
;       S, C or A : current state-type of player (stand, crouch, air)
;   - ctrl
;       0 or 1 : 1 if player has control. Unless "interrupting" another
;                move, you'll want ctrl = 1
;   - stateno
;       number of state player is in - useful for "move interrupts"
;   - movecontact
;       0 or 1 : 1 if player's last attack touched the opponent
;                useful for "move interrupts"
;
; Note: The order of state entry is important.
;   State entry with a certain command must come before another state
;   entry with a command that is the subset of the first.  
;   For example, command "fwd_a" must be listed before "a", and
;   "fwd_ab" should come before both of the others.
;
; For reference on triggers, see CNS documentation.
;
; Just for your information (skip if you're not interested):
; This part is an extension of the CNS. "State -1" is a special state
; that is executed once every game-tick, regardless of what other state
; you are in.


; Don't remove the following line. It's required by the CMD standard.
[Statedef -1]

[State -1, Light Kung Fu Palm]
type = VarSet
trigger1 = command = "start"
triggerall = command != "holdfwd"
v = 36
value = 1

[State -1, Light Kung Fu Palm]
type = VarSet
trigger1 = command = "start"
triggerall = command = "holdfwd"
v = 36
value = 0

[State -1, Triple Kung Fu Palm]
type = ChangeState
value = 3000
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "z"
triggerall = power >= 1000
trigger1 = statetype = A
trigger1 = ctrl
trigger2 = statetype = A
trigger2 = hitdefattr = SC, NA, SA
trigger2 = movecontact
[State -1, Triple Kung Fu Palm]
type = ChangeState
value = 3002
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "z"
triggerall = power >= 1000
trigger1 = statetype = S
trigger1 = ctrl
trigger2 = statetype = S
trigger2 = hitdefattr = SC, NA, SA
trigger2 = movecontact

;===========================================================================
;---------------------------------------------------------------------------
;Run Fwd
;�_�b�V��
[State -1, Run Fwd]
type = ChangeState
value = 100
trigger1 = command = "FF"
trigger1 = statetype = S
trigger1 = ctrl

;---------------------------------------------------------------------------
;Run Back
;��ރ_�b�V��
[State -1, Run Back]
type = ChangeState
value = 105
trigger1 = command = "BB"
trigger1 = statetype = S
trigger1 = ctrl

;---------------------------------------------------------------------------
;Stand_Throw
;����
[State -1, Standing Throw]
type = null;ChangeState
value = 900
triggerall = statetype = S
triggerall = ctrl
triggerall = stateno != 100
trigger1 = command = "fwd_b"
trigger1 = p2bodydist X < 3
trigger1 = (p2statetype = S) || (p2statetype = C)
trigger1 = p2movetype != H
trigger2 = command = "back_b";Near, p2 stand
trigger2 = p2bodydist X < 5
trigger2 = (p2statetype = S) || (p2statetype = C)
trigger2 = p2movetype != H


;===========================================================================
;---------------------------------------------------------------------------
;Stand Light Punch
;������p���`
[State -1, Stand Light Punch]
type = ChangeState
value = 260
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "x"
triggerall = command != "holddown"
trigger1 = statetype = S
trigger1 = ctrl

[State -1, Stand Light Punch]
type = ChangeState
value = 283
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "x"
triggerall = command = "holddown"
trigger1 = statetype != A
trigger1 = ctrl
trigger1 = (var(38)<2)
trigger2 = stateno = 283
trigger2 = time > 7
trigger2 = (var(38)<2)

[State -1, Stand Light Punch]
type = ChangeState
value = 261
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "x"
triggerall = command != "holddown"
trigger1 = stateno = 260
trigger1 = time > 7

[State -1, Stand Light Punch]
type = ChangeState
value = 262
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "y"
triggerall = command != "holddown"
trigger1 = statetype = S
trigger1 = ctrl

[State -1, Stand Light Punch]
type = ChangeState
value = 263
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "a"
triggerall = command != "holddown"
trigger1 = statetype = S
trigger1 = ctrl

[State -1, Stand Light Punch]
type = ChangeState
value = 264
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "b"
triggerall = command != "holddown"
trigger1 = statetype = S
trigger1 = ctrl

[State -1, Stand Light Punch]
type = ChangeState
value = 266
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "c"
triggerall = command != "holddown"
trigger1 = statetype = S
trigger1 = ctrl

[State -1, Stand Light Punch]
type = ChangeState
value = 200
triggerall = (palno != 7)&&(var(36)=0)
triggerall = command = "x"
triggerall = command != "holddown"
trigger1 = statetype = S
trigger1 = ctrl
trigger2 = stateno = 200
trigger2 = time > 7
trigger3 = stateno = 201
trigger3 = time > 7
trigger4 = stateno = 202
trigger4 = time > 7

[State -1, Stand Light Punch]
type = ChangeState
value = 201
triggerall = (palno != 7)&&(var(36)=0)
triggerall = command = "y"
triggerall = command != "holddown"
trigger1 = statetype = S
trigger1 = ctrl
trigger2 = stateno = 200
trigger2 = time > 7
trigger3 = stateno = 201
trigger3 = time > 7
trigger4 = stateno = 202
trigger4 = time > 7

[State -1, Stand Light Punch]
type = ChangeState
value = 202
triggerall = (palno != 7)&&(var(36)=0)
triggerall = command = "z"
triggerall = command != "holddown"
trigger1 = statetype = S
trigger1 = ctrl
trigger2 = stateno = 200
trigger2 = time > 7
trigger3 = stateno = 201
trigger3 = time > 7
trigger4 = stateno = 202
trigger4 = time > 7

[State -1, Stand Light Punch]
type = ChangeState
value = 203
triggerall = (palno != 7)&&(var(36)=0)
triggerall = command = "a"
triggerall = command != "holddown"
trigger1 = statetype = S
trigger1 = ctrl
trigger2 = stateno = 200
trigger2 = time > 7
trigger3 = stateno = 201
trigger3 = time > 7
trigger4 = stateno = 202
trigger4 = time > 7

[State -1, Stand Light Punch]
type = ChangeState
value = 213
triggerall = (palno != 7)&&(var(36)=0)
triggerall = command = "c"
triggerall = command != "holddown"
trigger1 = statetype = S
trigger1 = ctrl
trigger2 = stateno = 200
trigger2 = time > 7
trigger3 = stateno = 201
trigger3 = time > 7
trigger4 = stateno = 202
trigger4 = time > 7

;---------------------------------------------------------------------------
;Taunt
;����
[State -1, Taunt]
type = ChangeState
value = 195
triggerall = command = "start"
trigger1 = statetype != A
trigger1 = ctrl

;---------------------------------------------------------------------------
;Jump Light Punch
;�󒆎�p���`
[State -1, Jump Light Punch]
type = ChangeState
value = 612
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "x"
trigger1 = statetype = A
trigger1 = ctrl

[State -1, Jump Light Punch]
type = ChangeState
value = 613
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "y"
trigger1 = statetype = A
trigger1 = ctrl
trigger2 = stateno = 612

[State -1, Jump Light Punch]
type = ChangeState
value = 614
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "a"
trigger1 = statetype = A
trigger1 = ctrl

[State -1, Jump Light Punch]
type = ChangeState
value = 616
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "b"
trigger1 = statetype = A
trigger1 = ctrl
trigger2 = stateno = 612

[State -1, Jump Light Punch]
type = ChangeState
value = 626
triggerall = (palno != 7)&&(var(36)=1)
triggerall = command = "c"
trigger1 = statetype = A
trigger1 = ctrl


;---------------------------------------------------------------------------
;Jump Light Punch
;�󒆎�p���`
[State -1, Jump Light Punch]
type = ChangeState
value = 600
triggerall = (palno != 7)&&(var(36)=0)
triggerall = command = "x"
trigger1 = statetype = A
trigger1 = ctrl
trigger2 = stateno = 600
trigger2 = statetime >= 7
trigger3 = stateno = 601
trigger3 = statetime >= 7
trigger4 = stateno = 602
trigger4 = statetime >= 7
[State -1, Jump Light Punch]
type = ChangeState
value = 601
triggerall = (palno != 7)&&(var(36)=0)
triggerall = command = "y"
trigger1 = statetype = A
trigger1 = ctrl
trigger2 = stateno = 600
trigger2 = statetime >= 7
trigger3 = stateno = 601
trigger3 = statetime >= 7
trigger4 = stateno = 602
trigger4 = statetime >= 7
[State -1, Jump Light Punch]
type = ChangeState
value = 602
triggerall = (palno != 7)&&(var(36)=0)
triggerall = command = "z"
trigger1 = statetype = A
trigger1 = ctrl
trigger2 = stateno = 600
trigger2 = statetime >= 7
trigger3 = stateno = 601
trigger3 = statetime >= 7
trigger4 = stateno = 602
trigger4 = statetime >= 7
[State -1, Jump Light Punch]
type = ChangeState
value = 603
triggerall = (palno != 7)&&(var(36)=0)
triggerall = command = "a"
trigger1 = statetype = A
trigger1 = ctrl
trigger2 = stateno = 600
trigger2 = statetime >= 7
trigger3 = stateno = 601
trigger3 = statetime >= 7
trigger4 = stateno = 602
trigger4 = statetime >= 7
[State -1, Jump Light Punch]
type = ChangeState
value = 663
triggerall = (palno != 7)&&(var(36)=0)
triggerall = command = "c"
trigger1 = statetype = A
trigger1 = ctrl
trigger2 = stateno = 600
trigger2 = statetime >= 7
trigger3 = stateno = 601
trigger3 = statetime >= 7
trigger4 = stateno = 602
trigger4 = statetime >= 7
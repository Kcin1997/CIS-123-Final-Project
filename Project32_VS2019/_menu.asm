; Main Menu (_Menu.asm)

INCLUDE Team1Final.inc

.data
;------------------------------------------------
; Main Menu Strings
;------------------------------------------------
SelectAdd BYTE "1. Make Reservation", 0dh, 0ah, 0
SelectRem BYTE "2. Remove Reservation", 0dh, 0ah, 0
SelectDone BYTE "3. Exit Program", 0dh, 0ah, 0
StringAddOrRem BYTE "Select an option: ", 0

;------------------------------------------------------------
; Showings Menu Strings
;------------------------------------------------------------
Select1 BYTE "1. Movie 1. Time: 2:15PM", 0dh, 0ah, 0
Select2 BYTE "2. Movie 1. Time: 6:30PM", 0dh, 0ah, 0
Select3 BYTE "3. Movie 2. Time: 2:15PM", 0dh, 0ah, 0
Select4 BYTE "4. Movie 2. Time: 6:30PM", 0dh, 0ah, 0
Cancel BYTE "5. Cancel", 0dh, 0ah, 0

.code
;------------------------------------------------------------
MainMenu PROC
;------------------------------------------------------------
	pusha
	call	Clrscr
	mov		edx, OFFSET SelectAdd		;StringAdd used for output
	call	WriteString					;Writes the StringAdd to output
	mov		edx, OFFSET SelectRem		;StringRem used for output
	call	WriteString					;Writes the StringRem to output
	mov		edx, OFFSET SelectDone		;SelectDone used for output
	call	WriteString					;Writes the SelectDone to output

	mov		edx, OFFSET StringAddOrRem	;StringAddOrRem used for output
	call	WriteString					;Writes the StringAddOrRem to output
	popa
	ret
MainMenu ENDP

ShowingsMenu PROC
	pusha
	mov		edx, OFFSET Select1			;String1 used for output
	call	WriteString					;Writes the String1 to output
	mov		edx, OFFSET Select2			;String2 used for output
	call	WriteString					;Writes the String2 to output
	mov		edx, OFFSET Select3			;String3 used for output
	call	WriteString					;Writes the String3 to output
	mov		edx, OFFSET Select4			;String4 used for output
	call	WriteString					;Writes the String4 to output
	mov		edx, OFFSET Cancel			;Cancel used for output
	call	WriteString					;Writes SelectCancel to output
	popa
	ret
ShowingsMenu ENDP

END
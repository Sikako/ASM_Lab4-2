;Encryption Program               (Encrypt.asm)

; This program demonstrates simple symmetric
; encryption using the XOR instruction.

INCLUDE Irvine32.inc
BUFMAX = 128        ; maximum buffer size

.data
sPrompt  BYTE  "Enter the plain text: ",0
sEncrypt BYTE  "Cipher text:          ",0
sDecrypt BYTE  "Decrypted:            ",0
sKey     BYTE  "Enter the key: ",0
buffer   BYTE   BUFMAX+1 DUP(0)
K        BYTE   BUFMAX+1 DUP(0)
KSize    DWORD  ?
bufSize  DWORD  ?

.code
main PROC
    call    InputTheString      ; input the plain text
    call    InputTheKey
    call    TranslateBuffer ; encrypt the buffer
    mov edx,OFFSET sEncrypt ; display encrypted message
    call    DisplayMessage

    exit
main ENDP


InputTheKey    PROC
    pushad
    mov edx, OFFSET sKey    ; display a key
    call WriteString
    mov ecx,BUFMAX
    mov edx, OFFSET K
    call ReadString
    mov KSize, eax
    call    Crlf
    popad
    ret
InputTheKey    ENDP

;-----------------------------------------------------
InputTheString PROC
;
; Prompts user for a plaintext string. Saves the string 
; and its length.
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
    pushad
    mov edx,OFFSET sPrompt  ; display a prompt
    call    WriteString
    mov ecx,BUFMAX      ; maximum character count
    mov edx,OFFSET buffer   ; point to the buffer
    call    ReadString          ; input the string
    mov bufSize,eax         ; save the length
    call    Crlf
    popad
    ret
InputTheString ENDP

;-----------------------------------------------------
DisplayMessage PROC
;
; Displays the encrypted or decrypted message.
; Receives: EDX points to the message
; Returns:  nothing
;-----------------------------------------------------
    pushad
    call    WriteString
    mov edx,OFFSET buffer   ; display the buffer
    call    WriteString
    call    Crlf
    call    Crlf
    popad
    ret
DisplayMessage ENDP

;-----------------------------------------------------
TranslateBuffer PROC
;
; Translates the string by exclusive-ORing each
; byte with the encryption key byte.
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
    pushad
    mov ecx, bufSize
    mov esi,0
    mov edi,0
L1:
    cmp esi, KSize
    je ini
    mov dl, K[esi]
    xor buffer[edi], dl
    inc esi
    inc edi
    loop L1
    jmp Re
ini:
    mov esi,0
    jmp L2

L2:
    cmp esi, bufSize
    je ini
    mov dl, K[esi]
    xor buffer[edi], dl
    inc esi
    inc edi
    loop L2
    jmp Re

Re:
    popad
    ret
TranslateBuffer ENDP

END main
.model small         ;in main string delete string
.stack 100h          ;after inputing string
 
.data
message1    db "Enter string: $"
message2    db 0Ah, 0Dh, "Enter substring: $"
message3    db 0Ah, 0Dh, "Result string: $"
enter       db 0Ah, 0Dh, "$"
length      equ 200 
 
Strb db '$'
Strl db length
Str  db length dup('$')
 
SubStrb db '$'
SubStrl db length
SubStr  db length dup('$')
 
.code
start:
    mov ax, @data
    mov ds, ax
    
    lea dx, message1            ;output 'Enter string'
    call outputString
    lea dx, enter
    call outputString
    
    lea dx, Strb           ;input MainString
    call inputString
    lea dx, enter
    call outputString
    
    lea dx, message2            ;output  'Enter substring'
    call outputString
    lea dx, enter
    call outputString
    
    lea dx, SubStrb        ;input SubString
    call inputString
    lea dx, enter
    call outputString
    
    mov al, [Strl]              ;check on equality
    cmp al, [SubStrl]
    jb exit
    
    xor cx, cx
    lea si, Str             ;pointer on beginning of Str
    dec si
    jmp start_find
    
    find:
    inc si
    cmp [si], ' '           ;compare element of Str with ' '
    je start_find
    cmp [si], '$'           ;compare with end of Str
    je exit
    jmp find
    start_find:
    inc si
    cmp [si],' '
    je start_find
    lea di, SubStr          ;pointer on beginning of SubString
    call searchSubString
    jmp find 
    
    
    
searchSubString proc
    push ax
    push cx
    push di
    push si
 
    xor cx, cx
    mov cl, [SubStrl]           ;cl=SubString.length() 
    comparestr: 
    mov ah,[si] 
    dec cx
    cmp ah,[di]
    je  compare
    jne NotEqual
    compare:   
    inc si
    inc di
    cmp cx,0
    je check
    jne comparestr
 
check:
    cmp [si], ' '
    je Equal
    jne NotEqual
 
Equal:
    call length
    call shift
    call searchSubString
    
NotEqual:
    pop si
    pop di
    pop cx
    pop ax
    ret
    
searchSubString endp        
  
 
shift proc
    push cx
    push di
    push bx
     
    lea ax, Str
    add al, [Strl]
    sub ax,si
    mov cx,ax
    add cx,2 
    
    ;shifting the word
    sdvigg_vlevo:              
        mov ah,[si]         ;save current element
        sub si, bx          ;shift left
        mov [si], ah 
        add si, bx
        inc si
    loop sdvigg_vlevo  
    xor bh, bh
        
    pop bx
    pop di
    pop cx
    ret     
shift endp
 
length proc
    push ax
    skip:  
    inc si
    cmp [si], ' '
    je skip
    mov ax,si           ;compare element of Str with ' '  
    
    word:    
    mov dh,[si]
    inc si
    cmp [si], ' '           ;compare with end of Str
    je continue
    cmp [si], '$'
    je continue
    jmp word
    continue:
    push si
    sub si,ax
    mov bx,si
    
    pop si  
    pop ax  
    ret
length endp    
 
inputString proc
push ax 
mov ah, 0Ah
int 21h
pop ax   
ret 
inputString endp
 
outputString proc
push ax
mov ah, 09h
int 21h
pop ax
ret
outputString endp
 
exit:       
lea dx, Str
call OutputString
mov ax,4c00h
int 21h
 
end start






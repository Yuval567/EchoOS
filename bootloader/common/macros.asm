%macro print16 1
    mov si, %1
    call print16_loop
%endmacro

%macro print32 1
    mov esi, %1
    call print32_loop
%endmacro

%macro stop 0
    jmp $
%endmacro
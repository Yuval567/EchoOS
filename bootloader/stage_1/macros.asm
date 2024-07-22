; Define the PRINT macro
%macro print 1
    mov si, %1
    call print16_loop
%endmacro

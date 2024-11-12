global _start

section .data

    ; HTTP response with improved DVD logo SVG
    http_response db "HTTP/1.1 200 OK", 0xD, 0xA
    db "Content-Type: text/html; charset=UTF-8", 0xD, 0xA
    db "Connection: close", 0xD, 0xA
    db "Cache-Control: no-store", 0xD, 0xA
    db 0xD, 0xA
    db "<!DOCTYPE html><html><head>", 0xD, 0xA
    db "<style>", 0xD, 0xA
    db "body{margin:0;overflow:hidden;background:#000;height:100vh}", 0xD, 0xA
    db "#dvd{position:absolute;width:340px;height:150px}", 0xD, 0xA
    db ".logo{width:100%;height:100%;fill:currentColor}", 0xD, 0xA
    db "</style></head><body>", 0xD, 0xA
    db "<div id='dvd'><svg class='logo' viewBox='0 0 1000 500'><path d='", 0xD, 0xA
    db "m91.053 0-13.719 57.707 102.28 0.039063h24c65.747 0 105.91 26.44 94.746 73.4-12.147 51.133-69.613 73.4-130.67 ", 0xD, 0xA
    db "73.4h-22.947l29.787-125.45h-102.27l-43.521 183.2h145.05c109.07 0 212.76-57.573 231.01-131.15 3.3467-13.507 ", 0xD, 0xA
    db "2.8806-47.253-5.3594-67.359-0.21299-0.787-0.42594-1.4-1.1855-3-0.293-0.653-0.56012-3.6412 1.1465-4.2812 ", 0xD, 0xA
    db "0.947-0.36 2.7069 1.4944 2.9336 2.041 0.853 2.24 1.5059 3.9062 1.5059 3.9062l92.293 260.6 234.97-265.21 ", 0xD, 0xA
    db "99.535-0.089844h24c65.76 0 106.25 26.44 95.092 73.4-12.147 51.133-69.947 73.4-131 73.4h-22.959l29.799-125.47", 0xD, 0xA
    db "h-102.27l-43.533 183.21h145.07c109.05 0 213.48-57.4 231-131.15 17.52-73.75-59.107-131.15-168.69-131.15h-216.4", 0xD, 0xA
    db "s-57.319 67.88-67.959 80.693c-57.12 68.787-67.241 87.226-68.961 91.986 0.24-4.8-1.8138-23.412-26.174-92.959", 0xD, 0xA
    db "-6.48-18.52-27.359-79.721-27.359-79.721h-389.25zm408.77 324.16c-276.04 0-499.83 31.72-499.83 70.84s223.79", 0xD, 0xA
    db "70.84 499.83 70.84c276.04 0 499.83-31.72 499.83-70.84s-223.79-70.84-499.83-70.84zm-18.094 48.627c63.04 0", 0xD, 0xA
    db "114.13 10.573 114.13 23.613s-51.095 23.613-114.13 23.613c-63.027 0-114.13-10.573-114.13-23.613s51.106-23.613", 0xD, 0xA
    db "114.13-23.613z'/></svg></div>", 0xD, 0xA
    db "<script>", 0xD, 0xA
    db "const dvd=document.getElementById('dvd');", 0xD, 0xA
    db "let x=Math.random()*(window.innerWidth-300);", 0xD, 0xA
    db "let y=Math.random()*(window.innerHeight-150);", 0xD, 0xA
    db "let xSpeed=3,ySpeed=3;", 0xD, 0xA
    db "const colors=['#ff0000','#00ff00','#0000ff','#ffff00','#ff00ff','#00ffff'];", 0xD, 0xA
    db "let colorIndex=0;", 0xD, 0xA
    db "function changeColor(){", 0xD, 0xA
    db "colorIndex=(colorIndex+1)%colors.length;", 0xD, 0xA
    db "dvd.style.color=colors[colorIndex]}", 0xD, 0xA
    db "function animate(){", 0xD, 0xA
    db "x+=xSpeed;y+=ySpeed;", 0xD, 0xA
    db "if(x+dvd.offsetWidth>window.innerWidth||x<0){xSpeed=-xSpeed;changeColor()}", 0xD, 0xA
    db "if(y+dvd.offsetHeight>window.innerHeight||y<0){ySpeed=-ySpeed;changeColor()}", 0xD, 0xA
    db "dvd.style.transform=`translate(${x}px,${y}px)`;", 0xD, 0xA
    db "requestAnimationFrame(animate)}", 0xD, 0xA
    db "changeColor();animate();", 0xD, 0xA
    db "window.addEventListener('resize',()=>{", 0xD, 0xA
    db "x=Math.min(x,window.innerWidth-dvd.offsetWidth);", 0xD, 0xA
    db "y=Math.min(y,window.innerHeight-dvd.offsetHeight)});", 0xD, 0xA
    db "</script></body></html>", 0xD, 0xA
    http_response_len equ $ - http_response



    ; Constants for syscalls remain the same
    SYS_SOCKET equ 41
    SYS_BIND equ 49
    SYS_LISTEN equ 50
    SYS_ACCEPT equ 43
    SYS_READ equ 0
    SYS_WRITE equ 1
    SYS_CLOSE equ 3
    SYS_EXIT equ 60
    SYS_SETSOCKOPT equ 54

    ;Message constants remain the same
    SERVER_STARTED db "Server started on port 8080", 0xA

    ; Socket options remain the same
    SOL_SOCKET equ 1
    SO_REUSEADDR equ 2
    SO_REUSEPORT equ 15

    ; Network constants remain the same
    AF_INET equ 2
    SOCK_STREAM equ 1
    INADDR_ANY equ 0

    ; Port 8080 in network byte order
    PORT equ 0x901F   

    
section .bss
    client_addr resb 16
    client_addr_len resd 1
    request_buffer resb 4096

section .data
    server_addr:
        dw AF_INET
        dw PORT
        dd INADDR_ANY
        dq 0
    server_addr_len equ $ - server_addr

section .text

_start:
    ; Create socket
    mov rax, SYS_SOCKET
    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    xor rdx, rdx
    syscall
    
    cmp rax, 0
    jl exit_error
    
    ; Save socket descriptor
    mov r12, rax            

    ; Set socket options
    mov rax, SYS_SETSOCKOPT
    mov rdi, r12
    mov rsi, SOL_SOCKET
    mov rdx, SO_REUSEADDR
    push 1
    mov r10, rsp
    mov r8, 4
    syscall
    pop rax

    ; Bind socket
    mov rax, SYS_BIND
    mov rdi, r12
    mov rsi, server_addr
    mov rdx, server_addr_len
    syscall
    
    ; Listen for connections
    mov rax, SYS_LISTEN
    mov rdi, r12
    mov rsi, 10
    syscall

    ; Print message
    mov rax, SYS_WRITE
    mov rdi, 1
    mov rsi, SERVER_STARTED
    mov rdx, 30
    syscall

accept_loop:
    ; Accept connection
    mov rax, SYS_ACCEPT
    mov rdi, r12
    mov rsi, client_addr
    mov rdx, client_addr_len
    syscall
    
    mov r13, rax            ; Save client socket

    ; Read request (to clear buffer)
    mov rax, SYS_READ
    mov rdi, r13
    mov rsi, request_buffer
    mov rdx, 4096
    syscall

    ; Send HTTP response
    mov rax, SYS_WRITE
    mov rdi, r13
    mov rsi, http_response
    mov rdx, http_response_len
    syscall

    ; Close client socket
    mov rax, SYS_CLOSE
    mov rdi, r13
    syscall
    
    jmp accept_loop

exit_error:
    ; Close server socket if it exists
    cmp r12, 0
    jl exit_program
    mov rax, SYS_CLOSE
    mov rdi, r12
    syscall

exit_program:
    mov rax, SYS_EXIT
    mov rdi, 1
    syscall
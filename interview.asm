;*****************************************************************************************************************************
;Program name: "Interview". This program will conduct an interview and give you a job offer                                  *
;Copyright (C) 2021 Kendrick Ngo                                                                                             *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License   *
;version 3 as published by the Free Software Foundation.                                                                     *
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied          *
;Warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.      *
;A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                            *
;*****************************************************************************************************************************

;=============================================================================================================================
;
;Author information
;  Author name: Kendrick Ngo
;  Author email: Kendrickngo2000@csu.fullerton.edu
;
;Program information
;  Program name: main.cpp
;  Programming languages:  One file in C++, and One file in X68 Assembly
;  Date program began:     2021-Apr-17
;  Date program completed: 2021-May-7
;  Date comments upgraded: 2021-May-7
;  Files in this program:  main.cpp and interview.asm
;  Status: Complete.  No errors found after extensive testing.
;
;References for this program
;  Jorgensen, X86-64 Assembly Language Programming with Ubuntu, Version 1.1.40.
;
;Purpose
; To show how to take Char's as input and use them in the program structure
;
;This file
;   File name: interview.asm
;   Language: X86
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -l interview.lis -o interview.o interview.asm
;   Link:     g++ -m64 -no-pie -o interview.out -std=c++17 main.o interview.o
;   Optimal print specification: 132 columns width, 7 points, monospace, 8½x11 paper

extern printf
extern scanf

global interview

segment .data
stringFormat db "%s", 0                                                                                       ; Format for strings
floatFormat db "%lf", 0 ; Format for floats                                                                   ; Format for floats
welcomeMessage db "Hello %s. I am Ms Fenster. The interview will begin now.", 10, 0                           ; Welcome msg
salaryMessage db "Wow! $%1.2lf That's a lot of cash. Who do you think you are, Chris Sawyer (y or n)?", 10, 0 ; Salary msg
circuitMessage db "Alright. Now we will work on your electricity.", 10, 0                                     ; Circuit Test msg
circuitQuestion1 db "Please enter the resistance of circuit #1 in ohms: ", 0                                  ; Circuit Q1
circuitQuestion2 db "What is the resistance of circuit #2 in ohms: ", 0                                       ; Circuit Q2
circuitDone db "The total resistance is %1.3lf Ohms.", 10, 0                                                  ; Resistance message
compSciQuestion db "Were you a computer science major (y or n)? ", 0                                          ; CSMajor Question
byeMessage db "Thank you.  Please follow the exit signs to the front desk.", 10, 0                            ; Bye msg

section .bss

segment .text
interview:

; Backups
push rbp                                                    ; rbp
mov  rbp, rsp                                               ;
push rdi                                                    ; rdi
push rsi                                                    ; rsi
push rdx                                                    ; rdx
push rcx                                                    ; rcx
push r8                                                     ; r8
push r9                                                     ; r9
push r10                                                    ; r10
push r11                                                    ; r11
push r12                                                    ; r12
push r13                                                    ; r13
push r14                                                    ; r14
push r15                                                    ; r15
push rbx                                                    ; rbx
pushf                                                       ; rflags

; 16th push
push qword -1

mov r15, rdi      ; Store name array
movsd xmm15, xmm0 ; Store salary

; Welcome msg
push qword 0
mov rax, 0
mov rdi, welcomeMessage
mov rsi, r15
call printf
pop rax

; Print salary message
push qword 0
mov rax, 1
mov rdi, salaryMessage
movsd xmm0, xmm15
call printf
pop rax

; Get Answer y/n
push qword 0
mov rdi, stringFormat
mov rsi, rsp
call scanf
pop rax

mov r14, 'y'
cmp rax, r14
jne ResistanceTest ; If answer is not 'y' goto test

mov rax, 0x412E848000000000 ; Put 1000000.00 into rax
movq xmm14, rax             ; Put 1000000.00 into xmm14
jmp end                     ; Jump to the end

ResistanceTest:
; Resistance test
push qword 0
mov rax, 0
mov rdi, circuitMessage
call printf
pop rax

; Ask first question
push qword 0
mov rax, 0
mov rdi, circuitQuestion1
call printf
pop rax

; first input to xmm10
mov rax, 1
mov rdi, floatFormat
push qword 0
mov rsi, rsp
call scanf
movsd xmm10, [rsp]
pop rax

; Ask second question
push qword 0
mov rax, 0
mov rdi, circuitQuestion2
call printf
pop rax

; second input to xmm11
mov rax, 1
mov rdi, floatFormat
push qword 0
mov rsi, rsp
call scanf
movsd xmm11, [rsp]
pop rax

; inverse of resistances
mov r8, 1
cvtsi2sd xmm8, r8
divsd xmm8, xmm10
movsd xmm10, xmm8

cvtsi2sd xmm8, r8
divsd xmm8, xmm11
movsd xmm11, xmm8

; inverse resistances to xmm13
movsd xmm13, xmm10
addsd xmm13, xmm11

; Inverse result to get the resistance
mov r8, 1
cvtsi2sd xmm8, r8
divsd xmm8, xmm13
movsd xmm13, xmm8

; Print circuitDone message
push qword 0
mov rax, 1
mov rdi, circuitDone
movsd xmm0, xmm13
call printf
pop rax

; Ask if CS Major
push qword 0
mov rax, 0
mov rdi, compSciQuestion
call printf
pop rax

; Get Question Answer y/n
push qword 0
mov rdi, stringFormat
mov rsi, rsp
call scanf
pop rax

mov r14, 'y'
cmp rax, r14
je csMajor ; If answer is not 'y' jump to csMajor

mov rax, 0x4092C07AE147AE14 ; Put 1200.12 into rax
movq xmm14, rax             ; Put 1200.12 into xmm14
jmp end                     ; Jump to the end

csMajor:
mov rax, 0x40F57C0E147AE148 ; Put 88000.88 into rax
movq xmm14, rax             ; Put 88000.88 into xmm14

end:
; Bye msg
push qword 0
mov rax, 0
mov rdi, byeMessage
call printf
pop rax

; Restore Backups
pop rax                                                     ; Remove the extra -1 from the stack
popf                                                        ; rflags
pop rbx                                                     ; rbx
pop r15                                                     ; r15
pop r14                                                     ; r14
pop r13                                                     ; r13
pop r12                                                     ; r12
pop r11                                                     ; r11
pop r10                                                     ; r10
pop r9                                                      ; r9
pop r8                                                      ; r8
pop rcx                                                     ; rcx
pop rdx                                                     ; rdx
pop rsi                                                     ; rsi
pop rdi                                                     ; rdi
pop rbp                                                     ; rbp

movsd xmm0, xmm14
ret

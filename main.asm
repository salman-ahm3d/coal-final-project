section .data
menu db "*********** CLOUD SERVER MANAGEMENT ***********", 10, \
"1. Buy Compute-Optimized Server", 10, \
"2. Buy Memory-Optimized Server", 10, \
"3. Buy Storage-Optimized Server", 10, \
"4. Show Current Deployment", 10, \
"5. Remove a Server", 10, \
"6. Clear All Deployments", 10, \
"7. Exit", 10, 0
menu_len equ $ - menu
remove_menu db "***** REMOVE SERVER MENU *****", 10, \
"1. Remove Compute Server", 10, \
"2. Remove Memory Server", 10, \
"3. Remove Storage Server", 10, \
"4. Return to Main Menu", 10, 0
remove_menu_len equ $ - remove_menu
msg_full db "Server capacity reached! (Max 8)", 10, 0
msg_full_len equ $ - msg_full
msg_invalid db "Invalid selection!", 10, 0
msg_invalid_len equ $ - msg_invalid
msg_cleared db "*** All deployments cleared successfully ***", 10, 0
msg_cleared_len equ $ - msg_cleared
msg_removed db "Server removed successfully!", 10, 0
msg_removed_len equ $ - msg_removed
msg_none db "No servers of this type deployed!", 10, 0
msg_none_len equ $ - msg_none
msg_total_cost db "Total monthly cost: $", 0
msg_total_cost_len equ $ - msg_total_cost
msg_total_servers db "Total servers deployed: ", 0
msg_total_servers_len equ $ - msg_total_servers
msg_compute db "Compute servers: ", 0
msg_compute_len equ $ - msg_compute
msg_memory db "Memory servers: ", 0
msg_memory_len equ $ - msg_memory
msg_storage db "Storage servers: ", 0
msg_storage_len equ $ - msg_storage
newline db 10, 0
newline_len equ $ - newline
section .bss
total_cost resd 1
total_servers resd 1
compute_count resd 1
memory_count resd 1
storage_count resd 1
input resb 2
section .text
global _start
_start:
; Initialize counters to 0
mov dword [total_cost], 0
mov dword [total_servers], 0
mov dword [compute_count], 0
mov dword [memory_count], 0
mov dword [storage_count], 0
main_menu:
; Print menu
mov eax, 4
mov ebx, 1
mov ecx, menu
mov edx, menu_len
int 0x80
; Read user input
mov eax, 3
mov ebx, 0
mov ecx, input
mov edx, 2
int 0x80
; Check input
mov al, [input]
cmp al, '1'
je buy_compute
cmp al, '2'
je buy_memory
cmp al, '3'
je buy_storage
cmp al, '4'
je show_deployment
cmp al, '5'
je remove_server_menu
cmp al, '6'
je clear_deployments
cmp al, '7'
je exit_program
; Invalid input
mov eax, 4
mov ebx, 1
mov ecx, msg_invalid
mov edx, msg_invalid_len
int 0x80
jmp main_menu
buy_compute:
mov eax, [total_servers]
cmp eax, 8
jge capacity_full
add dword [total_cost], 100 ; $100/month
inc dword [total_servers]
inc dword [compute_count]
jmp main_menu
buy_memory:
mov eax, [total_servers]
cmp eax, 8
jge capacity_full
add dword [total_cost], 200 ; $200/month
inc dword [total_servers]
inc dword [memory_count]
jmp main_menu
buy_storage:
mov eax, [total_servers]
cmp eax, 8
jge capacity_full
add dword [total_cost], 300 ; $300/month
inc dword [total_servers]
inc dword [storage_count]
jmp main_menu
show_deployment:
; Total cost
mov eax, 4
mov ebx, 1
mov ecx, msg_total_cost
mov edx, msg_total_cost_len
int 0x80
mov eax, [total_cost]
call print_int
call print_nl
; Total servers
mov eax, 4
mov ebx, 1
mov ecx, msg_total_servers
mov edx, msg_total_servers_len
int 0x80
mov eax, [total_servers]
call print_int
call print_nl
; Compute servers
mov eax, 4
mov ebx, 1
mov ecx, msg_compute
mov edx, msg_compute_len
int 0x80
mov eax, [compute_count]
call print_int
call print_nl
; Memory servers
mov eax, 4
mov ebx, 1
mov ecx, msg_memory
mov edx, msg_memory_len
int 0x80
mov eax, [memory_count]
call print_int
call print_nl
; Storage servers
mov eax, 4
mov ebx, 1
mov ecx, msg_storage
mov edx, msg_storage_len
int 0x80
mov eax, [storage_count]
call print_int
call print_nl
jmp main_menu
remove_server_menu:
; Print remove menu
mov eax, 4
mov ebx, 1
mov ecx, remove_menu
mov edx, remove_menu_len
int 0x80
; Read user input
mov eax, 3
mov ebx, 0
mov ecx, input
mov edx, 2
int 0x80
; Check input
mov al, [input]
cmp al, '1'
je remove_compute
cmp al, '2'
je remove_memory
cmp al, '3'
je remove_storage
cmp al, '4'
je main_menu
; Invalid input
mov eax, 4
mov ebx, 1
mov ecx, msg_invalid
mov edx, msg_invalid_len
int 0x80
jmp remove_server_menu
remove_compute:
mov eax, [compute_count]
test eax, eax
jz no_compute
sub dword [total_cost], 100
dec dword [total_servers]
dec dword [compute_count]
mov eax, 4
mov ebx, 1
mov ecx, msg_removed
mov edx, msg_removed_len
int 0x80
jmp remove_server_menu
remove_memory:
mov eax, [memory_count]
test eax, eax
jz no_memory
sub dword [total_cost], 200
dec dword [total_servers]
dec dword [memory_count]
mov eax, 4
mov ebx, 1
mov ecx, msg_removed
mov edx, msg_removed_len
int 0x80
jmp remove_server_menu
remove_storage:
mov eax, [storage_count]
test eax, eax
jz no_storage
sub dword [total_cost], 300
dec dword [total_servers]
dec dword [storage_count]
mov eax, 4
mov ebx, 1
mov ecx, msg_removed
mov edx, msg_removed_len
int 0x80
jmp remove_server_menu
no_compute:
mov eax, 4
mov ebx, 1
mov ecx, msg_none
mov edx, msg_none_len
int 0x80
jmp remove_server_menu
no_memory:
mov eax, 4
mov ebx, 1
mov ecx, msg_none
mov edx, msg_none_len
int 0x80
jmp remove_server_menu
no_storage:
mov eax, 4
mov ebx, 1
mov ecx, msg_none
mov edx, msg_none_len
int 0x80
jmp remove_server_menu
clear_deployments:
xor eax, eax
mov [total_cost], eax
mov [total_servers], eax
mov [compute_count], eax
mov [memory_count], eax
mov [storage_count], eax
mov eax, 4
mov ebx, 1
mov ecx, msg_cleared
mov edx, msg_cleared_len
int 0x80
jmp main_menu
capacity_full:
mov eax, 4
mov ebx, 1
mov ecx, msg_full
mov edx, msg_full_len
int 0x80
jmp main_menu
exit_program:
mov eax, 1
xor ebx, ebx
int 0x80
print_nl:
mov eax, 4
mov ebx, 1
mov ecx, newline
mov edx, newline_len
int 0x80
ret
print_int:
; Handle zero case
test eax, eax
jnz .not_zero
push eax
mov eax, 4
mov ebx, 1
mov ecx, zero_char
mov edx, 1
int 0x80
pop eax
ret
.not_zero:
mov esi, eax
mov ecx, 0
mov ebx, 10
.reverse_digits:
xor edx, edx
div ebx
add dl, '0'
push edx
inc ecx
test eax, eax
jnz .reverse_digits
.print_digits:
pop eax
mov [digit], al
push ecx
mov eax, 4
mov ebx, 1
mov ecx, digit
mov edx, 1
int 0x80
pop ecx
loop .print_digits
ret
section .data
zero_char db '0'
digit db 0

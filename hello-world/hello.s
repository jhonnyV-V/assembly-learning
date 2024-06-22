.global _start
.intel_syntax noprefix

_start:
  // sys_write
  // rax indicates the type of syscall
  // for other syscalls see https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
  mov rax, 1
  // rdi indicates the file descriptor in this case stdout
  mov rdi, 1
  // rsi indicates the buffer
  // lea load effective address
  lea rsi, [hellow_world]
  // rdx indicates the length
  mov rdx, 14
  syscall

  // sys_exit
  mov rax, 60
  mov rdi, 0
  syscall

hellow_world:
  .ascii "Hello, World!\n"

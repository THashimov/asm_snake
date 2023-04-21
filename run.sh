#!/bin/bash

nasm snake.asm -f bin -o snake.bin 
qemu-system-x86_64 snake.bin 

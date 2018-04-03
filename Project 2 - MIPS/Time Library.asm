	.data
time:	.asciiz "03/04/2018"
	.text

	.globl main
main:
	la $s0,time
	
	addi $a0,$s0,0
	jal Day
	addi $a0,$v0,0
	addi $v0,$zero,1
	syscall
	
	addi $a0,$s0,0
	jal Month
	addi $a0,$v0,0
	addi $v0,$zero,1
	syscall
	
	addi $a0,$s0,0
	jal Year
	addi $a0,$v0,0
	addi $v0,$zero,1
	syscall
	
	addi $v0,$zero,10
	syscall
	
	
# ham lay ki tu thu $a1 cua string co dia chi $a0, tra ve trong $v0
getchar:	
	addi $t0,$zero,4
	div $a1,$t0
	mflo $t1
	sll $t1,$t1,2
	mfhi $t2
	
	add $t3,$a0,$t1
	lw $v0,0($t3)
	addi $t4,$zero,0x00ff
while:
	slt $t5,$zero,$t2
	beq $t5,$zero,end_while
	srl $v0,$v0,8
	addi $t2,$t2,-1
	j while
end_while:
	and $v0,$v0,$t4
	jr $ra
	
	
# Ham chuyen $a0 tu ki tu sang so
# Neu $a0 la chu so, tra ve $v1 = 1, $v0 la gia tri so duoc chuyen thanh
# Neu #a0 khong la chu so, tra ve $v1 = 0

char_to_number:
	addi $t1,$zero,'0'
	addi $t2,$zero,'9'
	slt $t3,$a0,$t1
	bne $t3,$zero,not_digit
	slt $t3,$t2,$a0
	bne $t3,$zero,not_digit
	addi $v1,$zero,1
	addi $v0,$v0,-48
	j end_char_to_number
not_digit:
	addi $v1,$zero,0
end_char_to_number:
	jr $ra


# Ham ket hop getchar va char_to_number
getchar_char_to_number:
	add $sp,$sp,-8
	sw $ra,4($sp)
	sw $a0,0($sp)
	
	jal getchar
	
	addi $a0,$v0,0
	
	jal char_to_number
	
	lw $a0,0($sp)
	lw $ra,4($sp)
	add $sp,$sp,8
	jr $ra	
	
# Ham lay gia tri ngay trong chuoi TIME (DD/MM/YYYY) co dia chi $a0
# Neu co the lay gia tri ngay, tra ve $v1 = 1, $v0 la gia tri ngay
# Neu khong the lay gia tri ngay, tra ve $v1 = 0

Day:
	add $sp,$sp,-12
	sw $ra,8($sp)
	sw $a0,0($sp)
	
	addi $a1,$zero,0
	jal getchar_char_to_number
	lw $a0,0($sp)
	beq $v1,$zero,incorrect_day
	addi $t1,$zero, 10
	mul $t0,$v0,$t1
	
	sw $t0,4($sp)
	
	addi $a1,$zero,1
	jal getchar_char_to_number
	lw $t0,4($sp)
	lw $a0,0($sp)
	beq $v1,$zero,incorrect_day
	add $t0,$t0,$v0
	
	addi $v1,$zero,1
	addi $v0,$t0,0
	j end_day
incorrect_day:
	addi $v1,$zero,1
end_day:
	lw $ra,8($sp)
	lw $a0,0($sp)
	add $sp,$sp,12
	jr $ra
	
# Ham lay gia tri ngay trong chuoi TIME (DD/MM/YYYY) co dia chi $a0
# Neu co the lay gia tri ngay, tra ve $v1 = 1, $v0 la gia tri ngay
# Neu khong the lay gia tri ngay, tra ve $v1 = 0

Month:
	add $sp,$sp,-12
	sw $ra,8($sp)
	sw $a0,4($sp)
	
	addi $a1,$zero,3
	jal getchar_char_to_number
	lw $a0,4($sp)
	beq $v1,$zero,incorrect_month
	addi $t1,$zero, 10
	mul $t0,$v0,$t1
	
	sw $t0,0($sp)
	
	addi $a1,$zero,4
	jal getchar_char_to_number
	lw $t0,0($sp)
	lw $a0,4($sp)
	beq $v1,$zero,incorrect_month
	add $t0,$t0,$v0
	
	addi $v1,$zero,1
	addi $v0,$t0,0
	j end_day
incorrect_month:
	addi $v1,$zero,1
end_month:
	
	lw $ra,8($sp)
	add $sp,$sp,12
	jr $ra
	
	
# Ham lay gia tri ngay trong chuoi TIME (DD/MM/YYYY) co dia chi $a0
# Neu co the lay gia tri ngay, tra ve $v1 = 1, $v0 la gia tri ngay
# Neu khong the lay gia tri ngay, tra ve $v1 = 0

Year:
	add $sp,$sp,-12
	sw $ra,8($sp)
	sw $a0,4($sp)
	
	addi $a1,$zero,6
	jal getchar_char_to_number
	lw $a0,4($sp)
	beq $v1,$zero,incorrect_year
	addi $t1,$zero, 1000
	mul $t0,$v0,$t1
	
	sw $t0,0($sp)
	
	addi $a1,$zero,7
	jal getchar_char_to_number
	lw $t0,0($sp)
	lw $a0,4($sp)
	beq $v1,$zero,incorrect_year
	addi $t1,$zero, 100
	mul $t2,$v0,$t1
	add $t0,$t0,$t2
	
	sw $t0,0($sp)
	
	addi $a1,$zero,8
	jal getchar_char_to_number
	lw $t0,0($sp)
	lw $a0,4($sp)
	beq $v1,$zero,incorrect_year
	addi $t1,$zero, 10
	mul $t2,$v0,$t1
	add $t0,$t0,$t2
	
	sw $t0,0($sp)
	
	addi $a1,$zero,9
	jal getchar_char_to_number
	lw $t0,0($sp)
	lw $a0,4($sp)
	beq $v1,$zero,incorrect_year
	add $t0,$t0,$v0
	
	addi $v1,$zero,1
	addi $v0,$t0,0
	j end_day
incorrect_year:
	addi $v1,$zero,1
end_year:
	
	lw $ra,8($sp)
	add $sp,$sp,12
	jr $ra
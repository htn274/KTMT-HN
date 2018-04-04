	.data
time:	.asciiz "01/01/2000"
week_day: .space 3 
	.text

	.globl main

main:
	la $s0,time
	addi $a0, $s0, 0
	jal WeekDay
	addi $a0, $v0, 0
	addi $v0, $zero, 4
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
	j end_month
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
	j end_year
incorrect_year:
	addi $v1,$zero,1
end_year:
	
	lw $ra,8($sp)
	add $sp,$sp,12
	jr $ra

# Kiem tra xem nam trong chuoi "DD/MM/YYYY" co phai la nam nhuan hay khong
# Neu co tra ve 1, nguoc lai tra ve 0
LeapYear:
	add $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	jal Year
	addi $t0, $v0, 0  # Lay nam trong chuoi luu vao $t0
	# Xet so du khi chia cho 400, neu nam chia het cho 400 thi la nam nhuan
	addi $t1, $zero, 400 
	div $t0, $t1
	mfhi $t2     # So du
	beq $t2, $zero, true
	addi $t1, $zero, 100    # Kiem tra chia het cho 100
	div $t0, $t1
	mfhi $t2     # So du
	beq $t2, $zero, false    # Neu chia het cho 100 thi tra ve false
	addi $t1, $zero, 4
	div $t0, $t1
	mfhi $t2         # So du
	beq $t2, $zero, true    # Neu chia het cho 4 va khong chia het cho 100 thi tra ve true
	j false
	true:
		addi $v0, $zero, 1   # return true;
		lw $a0, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		jr $ra
	false:
		addi $v0, $zero, 0   # return false;
		lw $a0, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		jr $ra
# Cho biet nam do thuoc the ki nao
getCentury:
	add $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	addi $t0, $a0, 0  # Year
	# Cong thuc tinh the ki tong quat la: century = (year + 99) / 100
	addi $t0, $t0, 99  # year + 99
	addi $t1, $zero, 100  
	div $t0, $t1
	mflo $t2      # (year + 99) / 100
	addi $v0, $t2, 0
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra

# Lenh tao chuoi mang ten thu trong tuan
getWeekDayString:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	la $t0, week_day    # week_day la chuoi tra ve
	beq $a0, $zero, Saturday
	addi $t2, $a0, -1
	beq $t2, $zero, Sunday
	addi $t2, $a0, -2
	beq $t2, $zero, Monday
	addi $t2, $a0, -3
	beq $t2, $zero, Tuesday
	addi $t2, $a0, -4
	beq $t2, $zero, Wednesday
	addi $t2, $a0, -5
	beq $t2, $zero, Thursday
	addi $t2, $a0, -6
	beq $t2, $zero, Friday
	#Tao cac chuoi tuong ung voi cac thu trong tuan
	Monday:
		addi $t1, $zero, 77
		sb $t1, 0($t0)
		addi $t1, $zero, 111
		sb $t1, 1($t0)
		addi $t1, $zero, 110
		sb $t1, 2($t0)
		j endGetWeekDayString
	Tuesday:
		addi $t1, $zero, 84
		sb $t1, 0($t0)
		addi $t1, $zero, 117
		sb $t1, 1($t0)
		addi $t1, $zero, 101
		sb $t1, 2($t0)
		j endGetWeekDayString
	Wednesday:
		addi $t1, $zero, 87
		sb $t1, 0($t0)
		addi $t1, $zero, 101
		sb $t1, 1($t0)
		addi $t1, $zero, 100
		sb $t1, 2($t0)
		j endGetWeekDayString
	Thursday:
		addi $t1, $zero, 84
		sb $t1, 0($t0)
		addi $t1, $zero, 104
		sb $t1, 1($t0)
		addi $t1, $zero, 117
		sb $t1, 2($t0)
		j endGetWeekDayString
	Friday:
		addi $t1, $zero, 70
		sb $t1, 0($t0)
		addi $t1, $zero, 114
		sb $t1, 1($t0)
		addi $t1, $zero, 105
		sb  $t1, 2($t0)
		j endGetWeekDayString
	Saturday:
		addi $t1, $zero, 83
		sb $t1, 0($t0)
		addi $t1, $zero, 97
		sb $t1, 1($t0)
		addi $t1, $zero, 116
		sb $t1, 2($t0)
		j endGetWeekDayString
	Sunday:	
		addi $t1, $zero, 83
		sb $t1, 0($t0)
		addi $t1, $zero, 117
		sb $t1, 1($t0)
		addi $t1, $zero, 110
		sb $t1, 2($t0)
		j endGetWeekDayString
	endGetWeekDayString:
		addi $v0, $t0, 0
		lw $a0, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		jr $ra		
		
# Lenh lay so m tuong ung voi cac thang
getM:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	jal Month
	addi $t8, $v0, 0             # Month
	jal LeapYear
	addi $t1, $v0, 0             # Kiem tra nam nhuan
	beq $t1, $zero, notLeapYear
	addi $t0, $t8, -1
	beq $t0, $zero, return6
	addi $t0, $t8, -2
	beq $t0, $zero, return2
notLeapYear:
	addi $t0, $t8, -1
	beq $t0, $zero, return0
	addi $t0, $t8, -2
	beq $t0, $zero, return3
	addi $t0, $t8, -3
	beq $t0, $zero, return3
	addi $t0, $t8, -4
	beq $t0, $zero, return6
	addi $t0, $t8, -5
	beq $t0, $zero, return1
	addi $t0, $t8, -6
	beq $t0, $zero, return4
	addi $t0, $t8, -7
	beq $t0, $zero, return6
	addi $t0, $t8, -8
	beq $t0, $zero, return2
	addi $t0, $t8, -9
	beq $t0, $zero, return5
	addi $t0, $t8, -10
	beq $t0, $zero, return0
	addi $t0, $t8, -11
	beq $t0, $zero, return3
	addi $t0, $t8, -12
	beq $t0, $zero, return5
	return0:
		addi $v0, $zero, 0
		j exitGetM
	return1:
		addi $v0, $zero, 1
		j exitGetM
	return2:
		addi $v0, $zero, 2
		j exitGetM
	return3:
		addi $v0, $zero, 3
		j exitGetM
	return4:
		addi $v0, $zero, 4
		j exitGetM
	return5:
		addi $v0, $zero, 5
		j exitGetM
	return6:
		addi $v0, $zero, 6
		j exitGetM
	exitGetM:
		lw $ra, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, 8
		jr $ra
# Cho biet ngay do la thu may trong tuan
WeekDay:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	jal Day               # $s0 = d
	addi $s0, $v0, 0
	jal getM
	addi $s1, $v0, 0      #  $s1 = m
	jal Year
	addi $s2, $v0, 0
	addi $t0, $zero, 100
	div $s2, $t0
	mfhi $s2              # $s2 = y
	addi $a0, $v0, 0
	jal getCentury
	addi $s3, $v0, 0        # $s3 = c
	add $s4, $s1, $s0      # d + m
	add $s4, $s3, $s4   # + c
	add $s4, $s2, $s4    # + y
	addi $t5, $zero, 4     # = 4
	div $s2, $t5           # y / 4
	mflo $s6
	add $s4, $s6, $s4   # d + m + y + y/4 + c
	addi $t0, $zero, 7
	div $s4, $t0
	mfhi $t1
	addi $a0, $t1, 0
	jal getWeekDayString
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp,  8
	jr $ra
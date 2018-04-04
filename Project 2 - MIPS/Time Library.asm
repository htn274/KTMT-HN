	.data
time:	.asciiz "05/04/2018"
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
	#exit

	addi $v0,$zero,10
	syscall

	
# ham lay ki tu thu $a1 cua string co dia chi $a0, tra gia tri ve $v0
Getchar:	
	# Vi lw chi lay gia tri trong cac dia chi la boi cua 4
	# nen ta load word o dia chi $a0 + ($a1 - $a1 % 4), sau do lay byte thu $a1 %4 cua word do
	
	# $t2 = $a1 % 4
	# $t1 = $a1 - $t2
	addi $t0,$zero,4	# $t0 = 4
	div $a1,$t0		
	mflo $t1		# $t1 = $a1 div 4
	sll $t1,$t1,2		# $t1 = ($a1 div 4) * 4 = $a1 - a1 % 4
	mfhi $t2		# $t1 = $a1 %4
	
	# Load word o dia chi $a0 + ($a1 - $a1 % 4)
	add $t3,$a0,$t1		 
	lw $v0,0($t3)		# $v0 = lw($a0 + $t1)
	
	# Lay byte o vi tri $a1 % 4 = $t2
	# Dich phai word ($t2-1)*4 don vi, sau do and voi 0000 0000 0000 0000 0000 0000 1111 1111
	addi $t4,$zero,0x00ff	# $t4 = 0000 0000 0000 0000 0000 0000 1111 1111
while:
	slt $t5,$zero,$t2	# $t5 = t2
	beq $t5,$zero,end_while	# while (t5>0) {
	srl $v0,$v0,8		#	$v0>>8;
	addi $t2,$t2,-1		#	$t5--;
	j while			# }
end_while:
	and $v0,$v0,$t4		# $v0 = $v0 & 0000 0000 0000 0000 0000 0000 1111 1111
	jr $ra
	
#----------------------------------------------------------	
# Ham chuyen $a0 tu ki tu sang so
# Neu $a0 la chu so, tra ve $v1 = 1, $v0 la gia tri so duoc chuyen thanh
# Neu #a0 khong la chu so, tra ve $v1 = 0
	
	# if (a0 < '0' || a0 > '9')
	#	$v1 = 0;
	# else {
	# 	$v1=0;
	#	$v0=$a0-48 (48= '0' - 0)
	# }
Char_to_number:
	addi $t1,$zero,'0'
	addi $t2,$zero,'9'
	slt $t3,$a0,$t1
	bne $t3,$zero,not_digit
	slt $t3,$t2,$a0
	bne $t3,$zero,not_digit
	addi $v1,$zero,1
	addi $v0,$v0,-48
	j end_Char_to_number
not_digit:
	addi $v1,$zero,0
end_Char_to_number:
	jr $ra

#----------------------------------------------------------
# Ham ket hop Getchar va Char_to_number
# Lay ki tu thu $a1 cua chuoi co dia chia $a0, doi ki tu do sang so, tra ve gia tri trong $v0
# Neu co the doi ki tu sang so, $v1 = 1, neu khong, $v1 = 0
Getchar_Char_to_number:
	# Luu $ra va $a0 vao stack
	add $sp,$sp,-8
	sw $ra,4($sp)
	sw $a0,0($sp)
	
	jal Getchar	# Tham so $a0 cua Getchar chinh la $a0 cua Getchar_Char_to_number nen khong can gan lai
	lw $a0,0($sp)	# Tra lai gia tri $a0 trong stack
	
	addi $a0,$v0,0	# Lay gia tri tra ve cua ham Getchar lam tham so $a0 cho ham Char_to_number
	
	jal Char_to_number
	lw $a0,0($sp)	# Tra lai gia tri $a0 trong stack
	
	#Khoi phuc stack
	lw $ra,4($sp)	
	add $sp,$sp,8
	jr $ra	
	
#----------------------------------------------------------
# Ham lay gia tri ngay trong chuoi TIME (DD/MM/YYYY) co dia chi $a0
# Neu co the lay gia tri ngay, tra ve $v1 = 1, $v0 la gia tri ngay
# Neu khong the lay gia tri ngay, tra ve $v1 = 0
Day:
	# Luu $ra va $a0 vao stack
	add $sp,$sp,-12
	sw $ra,8($sp)
	sw $a0,4($sp)
	
	# Lay ky tu dau tien cua chuoi va chuyen sang so
	addi $a1,$zero,0
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	
	# Neu ki tu dau tien khong phai la chu so -> incorrect
	beq $v1,$zero,incorrect_day
	
	# $t0 = $v0*10 (chu so hang chuc)
	addi $t1,$zero, 10
	mult $v0,$t1
	mflo $t0
	
	sw $t0,0($sp)	# Luu $t0 vao trong stack
	
	# Lay ky tu thu 2 cua chuoi va chuyen sang so
	addi $a1,$zero,1
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	lw $t0,0($sp)
	
	# Neu ki tu thu 2 khong phai la chu so -> incorrect
	beq $v1,$zero,incorrect_day
	
	# $t0 += $v0 (chu so hang don vi)
	add $t0,$t0,$v0
	
	addi $v1,$zero,1
	addi $v0,$t0,0
	j end_day
incorrect_day:
	addi $v1,$zero,0
end_day:
	lw $ra,8($sp)
	lw $a0,4($sp)
	add $sp,$sp,12
	jr $ra

#----------------------------------------------------------	
# Ham lay gia tri thang trong chuoi TIME (DD/MM/YYYY) co dia chi $a0
# Neu co the lay gia tri thang, tra ve $v1 = 1, $v0 la gia tri thang
# Neu khong the lay gia tri thang, tra ve $v1 = 0
Month:
	# Hoan toan tuong tu ham Day
	add $sp,$sp,-12
	sw $ra,8($sp)
	sw $a0,4($sp)
	
	# Lay ki tu thu 3, chuyen sang so
	addi $a1,$zero,3
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	
	beq $v1,$zero,incorrect_month
	
	# $t0 += $v0 *10 (chu so hang chuc)
	addi $t1,$zero, 10
	mult $v0,$t1
	mflo $t0
	
	sw $t0,0($sp)	# Luu gia tri cua $t0 vao stack
	
	# Lay ki tu thu 6, chuyen sang so
	addi $a1,$zero,4
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	lw $t0,0($sp)
	
	beq $v1,$zero,incorrect_month
	
	# $t0 += $v0 (chu so hang don vi)
	add $t0,$t0,$v0
	
	addi $v1,$zero,1
	addi $v0,$t0,0
	j end_month
incorrect_month:
	addi $v1,$zero,0
end_month:
	
	lw $ra,8($sp)
	add $sp,$sp,12
	jr $ra
	
#--------------------------------------------------------	
# Ham lay gia tri ngay trong chuoi TIME (DD/MM/YYYY) co dia chi $a0
# Neu co the lay gia tri ngay, tra ve $v1 = 1, $v0 la gia tri ngay
# Neu khong the lay gia tri ngay, tra ve $v1 = 0
Year:
	# Tuong tu ham Day
	add $sp,$sp,-12
	sw $ra,8($sp)
	sw $a0,4($sp)
	
	# Lay ki tu thu 6, chuyen sang so
	addi $a1,$zero,6
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	
	beq $v1,$zero,incorrect_year
	
	# $t0 = $v0 *1000 (chu so hang nghin)
	addi $t1,$zero, 1000
	mult $v0,$t1
	mflo $t0
	
	sw $t0,0($sp)	# Luu gia tri cua $t0 vao stack
	
	# Lay ki tu thu 7, chuyen sang so
	addi $a1,$zero,7
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	lw $t0,0($sp)
	
	beq $v1,$zero,incorrect_year
	
	# $t0 += $v0 *100 (chu so hang tram)
	addi $t1,$zero, 100
	mult $v0,$t1
	mflo $t2
	add $t0,$t0,$t2
	
	sw $t0,0($sp)	# Cap nhat gia tri cua $t0 vao stack
	
	# Lay ki tu thu 8, chuyen sang so
	addi $a1,$zero,8
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	lw $t0,0($sp)
	
	beq $v1,$zero,incorrect_year
	
	# $t0 += $v0 *10 (chu so hang chuc)
	addi $t1,$zero, 10
	mult $v0,$t1
	mflo $t2
	add $t0,$t0,$t2
	
	sw $t0,0($sp)	# Cap nhat gia tri cua $t0 vao stack
	
	# Lay ki tu thu 9, chuyen sang so
	addi $a1,$zero,9
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	lw $t0,0($sp)
	
	beq $v1,$zero,incorrect_year
	
	# $t0 += $v0 (chu so hang don vi)
	add $t0,$t0,$v0
	
	addi $v1,$zero,1
	addi $v0,$t0,0
	j end_year
incorrect_year:
	addi $v1,$zero,0
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
	addi $a0, $v0, 0  # Lay nam trong chuoi luu vao $a0
	jal isLeapYear
	lw $ra, 4($sp)
	lw $a0, 0($sp)
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

#Ham kiem tra nam nhuan
#$v0 giu gia tri 1 la nam nhuan
isLeapYear:
	..text
	#Luu du lieu
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	#Kiem tra year % 400 == 0
	lw $a0, 0($sp)
	addi $t0, $zero, 400
	rem $t1, $a0, $t0
	beq	$t1, $zero, returnTrue

	#Kiem tra chia het cho 4
	lw $a0, 0($sp)
	addi $t0, $zero, 4
	rem $t1, $a0, $t0
	bne $t1, $zero, returnFalse

	#Kiem tra chia het cho 100
	lw $a0, 0($sp)
	addi $t0, $zero, 100
	rem $t1, $a0, $t0
	beq $t1, $zero, returnFalse

returnTrue:
	addi $v0, $zero, 1
	j exitLeapYear
returnFalse:
	addi $v0, $zero, 0
	
exitLeapYear: 	
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra

#Xuat 2 nam nhuan lien ke
#Tham so truyen vao la char* TIME
next2LeapYear:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0,	4($sp) #dia chi chua chuoi TIME

	#Lay year ra
	lw $a0, 4($sp)
	jal Year
	addi $a0, $v0, 0
	
	addi $a1, $zero, 0 #bien dem so nam nhuan da tim duoc
findLeapYear:
	addi $a0, $a0, 1  #tang year len
	
	jal isLeapYear 		#Kiem tra nam nhuan
	addi $t0, $v0, 0
	
	beq $t0, $0, findLeapYear 	#Neu khong phai, tim tiep
	addi $a1, $a1, 1 		#Tang bien dem len 1 

	addi $t0, $zero, 4		#Xac dinh vi tri cua ket qua de luu vao stack
	sll $t1, $a1, 2
	add $t0, $t0, $t1
	
	add $sp, $sp, $t0		#Luu ket qua
	sw $a0, 0($sp)			
	sub $sp, $sp, $t0

	bne $a1, 2, findLeapYear

exitNext2LeapYear:
	lw $ra, 0($sp)
	
	lw $a0, 8($sp)		#In ket qua 1
	addi $v0, $zero, 1
	syscall

	lw $a0, 12($sp)		#ket qua 2
	addi $v0, $zero, 1
	syscall

	lw $a0, 4($sp) 	
	
	addi $sp, $sp, 16	
	jr $ra



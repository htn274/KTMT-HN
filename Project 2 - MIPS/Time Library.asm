	.data
# Nhan time chua chuoi TIME theo ðinh dang DD/MM/YYYY
time:	.asciiz "03/04/2018"


#-----------------------------------
#-----------------------------------
	.text

	.globl main
main:
	la $s0,time	# Luu dia chi cua chuoi time trong $s0
	
	#In gia tri ngay trong chuoi time
	addi $a0,$s0,0
	jal Day
	beq $v1,$zero, incorrect_input_main
	addi $a0,$v0,0
	addi $v0,$zero,1
	syscall
	
	#In gia tri thang trong chuoi time
	addi $a0,$s0,0
	jal Month
	beq $v1,$zero, incorrect_input_main
	addi $a0,$v0,0
	addi $v0,$zero,1
	syscall
	
	#In gia tri nam trong chuoi time
	addi $a0,$s0,0
	jal Year
	beq $v1,$zero, incorrect_input_main
	addi $a0,$v0,0
	addi $v0,$zero,1
	syscall
	j end_main
	
incorrect_input_main:
	addi $a0,$v1,0
	addi $v0,$zero,1
	syscall

end_main:
	#exit ham main
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
	j end_day
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
	j end_day
incorrect_year:
	addi $v1,$zero,0
end_year:
	lw $ra,8($sp)
	add $sp,$sp,12
	jr $ra

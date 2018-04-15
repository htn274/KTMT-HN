.globl main

main:	
	.data 
	day_promt:	.asciiz "\nNhap ngay DAY:"
	month_promt:	.asciiz "\nNhap thang MONTH:"
	year_promt:	.asciiz "\nNhap nam YEAR:"
	reinput_promt:	.asciiz "\nGia tri ngay thang nam khong phu hop. Nhap lai. \n"
	new_line:	.asciiz "\n"

	#------------------------------
	#------------------------------
	demand: .asciiz "\n-----Ban hay chon 1 trong cac yeu cau sau day: -----\n"
	demand0: .asciiz "0. Thoat\n"
	demand1: .asciiz "1. Xuat chuoi TIME theo dinh dang DD/MM/YYYY\n"
	demand2: .asciiz "2.Chuyen doi chuoi TIME thanh mot trong cac dinh dang sau:\n A.MM/DD/YYYY\n B.Month DD, YYYY\n C.DD Month, YYYY\n"
	demand3: .asciiz "3.Cho biet ngay vua nhap la thu may?\n"
	demand4: .asciiz "4.Kiem tra nam trong chuoi TIME co phai nam nhuan khong?\n"
	demand5: .asciiz "5.Cho biet khoang thoi gian giua 2 chuoi TIME_1, TIME_2\n"
	demand6: .asciiz "6. Cho biet 2 nam nhuan gan nhat voi nam trong chuoi\n"
	
	str_choice: .asciiz "Lua chon: "
	str_result: .asciiz "\nKet qua: "
	SPACE: .asciiz " "

	cau2_choice: .asciiz "Ban can chuyen doi qua dang nao? (nhap ki tu in hoa A/B/C)"
	
	cau4_result1: .asciiz "Nam nhuan"
	cau4_result0: .asciiz "Khong phai nam nhuan"
	.text
	
	#Goi ham nhap 
	jal Input
	addi $s0,$v0,0	# Luu dia chi cua chuoi time vua tao vao $s0
	
LoopforChoice: 
	printMENU:
		la $a0, demand
		addi $v0, $zero, 4
		syscall
		
		la $a0, demand0
		addi $v0, $zero, 4
		syscall
		
		la $a0, demand1
		addi $v0, $zero, 4
		syscall
		
		la $a0, demand2
		addi $v0, $zero, 4
		syscall
		
		la $a0, demand3
		addi $v0, $zero, 4
		syscall
		
		
		la $a0, demand4
		addi $v0, $zero, 4
		syscall
		
		la $a0, demand5
		addi $v0, $zero, 4
		syscall
		
		la $a0, demand6
		addi $v0, $zero, 4
		syscall
		
		la $a0, str_choice 
		add $v0, $zero, 4
		syscall
		
		add $v0, $zero, 5 	#Input lua chon cua nguoi nhap	
		syscall 
		add $t0, $v0, 0 	#luu lua chon vao $t0
		
	beq $t0, 1, Cau1
	beq $t0, 2, Cau2
	beq $t0, 3, Cau3
	beq $t0, 4, Cau4
	beq $t0, 5, Cau5
	beq $t0, 6, Cau6
	j exitLoop
	Cau1: #In ket qua chuoi da nhap
		la $a0, str_result	#In thong bao "Ket qua: "
		addi $v0, $zero, 4
		syscall
		
		addi $a0, $s0, 0
		addi $v0,$zero,4
		syscall
		
		j LoopforChoice
	Cau2:
		la $a0, cau2_choice
		addi $v0, $zero, 4
		syscall
		addi $v0, $zero, 12    #Input lua chon cua nguoi nhap	
		syscall 
		addi $a1, $v0, 0
    
		addi $t0, $a1, -97
		beq $t0, $zero, changeToABC
		addi $t0, $a1, -98
		beq $t0, $zero, changeToABC
		addi $t0, $a1, -99
		beq $t0, $zero, changeToABC
	changeToABC:
		addi $a1, $a1, -32
	
		la $a0, new_line 
		addi $v0, $zero, 4
		syscall 
	
		la $a0, str_result	#In cau thong bao ket qua
		addi $v0, $zero, 4
		syscall
		
		addi $a0, $s0, 0	#load chuoi TIME 
		jal Convert 		#Goi ham Convert
		
		addi $a0, $v0, 0	#Lay ket qua tra ve cua ham de in ra
		addi $v0, $zero, 4
		syscall
		j LoopforChoice
	Cau3:
		la $a0, str_result	#In thong bao "Ket qua: "
		addi $v0, $zero, 4
		syscall
		
		addi $a0, $s0, 0	#Load chuoi TIME
		jal WeekDay		#Goi ham Week Day
		addi $a0, $v0, 0	
		addi $v0, $zero, 4
		syscall
		
		j LoopforChoice
	Cau4:
		la $a0, str_result	#In thong bao "Ket qua: "
		addi $v0, $zero, 4
		syscall
		
		addi $a0, $s0, 0	#Load chuoi TIME 
		jal LeapYear		#Goi ham kiem tra LeapYear
		beq $v0, $zero, result0
		
		la $a0, cau4_result1
		addi $v0, $zero, 4
		syscall
		j exit_Cau4
	result0:	#truong hop khong la nam nhuan
		la $a0, cau4_result0
		addi $v0, $zero, 4
		syscall
	exit_Cau4:
		j LoopforChoice	
	Cau5:	#CHUA XONG
		#Nhap chuoi TIME_2
		jal Input
		addi $s1, $v0, 0
		
		la $a0, str_result	#In thong bao "Ket qua: "
		addi $v0, $zero, 4
		syscall
		
		#So sanh neu TIME_1 < TIME_2 goi distanceDate(time_1, time_2), nguoc lai distanceDate(time_2, time_1)
		addi $a0, $s0, 0
		addi $a1, $s1, 0
		jal compareDate 
		bne $v0, $zero, CallDistance
		addi $a0, $s1, 0
		addi $a1, $s0, 0
	CallDistance:			
		jal distanceDate
		
		addi $a0, $v0, 0
		addi $v0, $zero, 1
		syscall 
		
		j LoopforChoice
		
	Cau6:
		la $a0, str_result	#In thong bao "Ket qua: "
		addi $v0, $zero, 4
		syscall
		
		addi $a0, $s0, 0
		jal next2LeapYear
		
	
	j LoopforChoice
exitLoop: 

#exit
end_main:
	addi $v0,$zero,10
	syscall


# Ham nhap ngay, thang, nam
# Tra ve $v0 la dia chi cua chuoi time theo dinh danh DD/MM/YYYY
Input:
	addi $sp,$sp,-24
	sw $ra,20($sp)
	
	# Tao mot sub string de luu cac gia tri day, month, year duoc nhap vao
	addi $a0,$zero,5
	addi $v0,$zero,9
	syscall
	sw $v0,16($sp)
	
while_input:
while_input_day:
	# In chuoi "Nhap ngay DAY:"
	la $a0,day_promt
	addi $v0, $zero, 4
	syscall
	
	# Nhap ngay vao vung nho cua sub string da cap phat
	addi $a1,$zero,2
	lw $a0,16($sp)
	
	jal Scan_limited_string

	# Kiem tra chuoi ngay co toan la chu so hay khong
	addi $a1,$zero,0
	addi $a2,$v0,-1
	jal String_to_number
	beq $v1,$zero, while_input_day
	
	sw $v0,8($sp)	# Luu gia tri day vao stack
	
while_input_month:	
	# In chuoi "Nhap thang MONTH:"
	la $a0,month_promt
	addi $v0, $zero, 4
	syscall
	
	# Nhap thang vao vung nho cua sub string da cap phat
	addi $a1,$zero,2
	lw $a0,16($sp)
	
	jal Scan_limited_string
	
	# Kiem tra chuoi thang co toan la chu so hay khong
	addi $a1,$zero,0
	addi $a2,$v0,-1
	jal String_to_number
	beq $v1,$zero, while_input_month

	sw $v0,4($sp)	# Luu gia tri thang vao stack
	
while_input_year:	
	# In chuoi "Nhap nam YEAR:"
	la $a0,year_promt
	addi $v0, $zero, 4
	syscall
	
	# Nhap nam vao vung nho cua sub string da cap phat
	addi $a1,$zero,4
	lw $a0,16($sp)
	
	jal Scan_limited_string
	
	# Kiem tra chuoi nam co toan la chu so hay khong
	addi $a1,$zero,0
	addi $a2,$v0,-1
	jal String_to_number
	beq $v1,$zero, while_input_year
	
	sw $v0,0($sp)	# Luu gia tri year vao stack
	
	# Kiem tra xem cac gia tri day, month, year co hop pham vi gia tri khong
	lw $a0,8($sp)
	lw $a1,4($sp)
	lw $a2,0($sp)
	jal Check_date_value
	bne $v0,$zero, end_while_input
	la $a0,reinput_promt
	addi $v0, $zero, 4
	syscall
	j while_input
	
end_while_input:
	# Cap phat bo nho 11 byte de luu chuoi time, luu dia chi vao stack
	addi $a0,$zero,11
	addi $v0,$zero,9
	syscall
	sw $v0,12($sp)
	
	# Doi 3 gia tri day,month,year thanh chuoi DD/MM/YYYY
	lw $a0,8($sp)
	lw $a1,4($sp)
	lw $a2,0($sp)
	lw $a3,12($sp)
	jal Date	

	addi $v0,$v0,0	# Tra ve gia tri tra ve cua ham Date
	
	# Thu hoi stack va return
	lw $ra,20($sp)
	addi $sp,$sp,24
	jr $ra


#----------------------------------------------------------------
# Nhap string voi toi da $a1 ki tu, string da duoc cap phat kich thuoc on hon hoac bang $a1 o dia chi $a0
# Ket thuc nhap khi nhan enter hoac nhap du $a1 ki tu
# Tra ve chieu dai cua chuoi da nhap
Scan_limited_string:
	addi $sp,$sp,-16
	sw $ra,12($sp)
	sw $a0,8($sp)
	sw $a1,4($sp)
	
	addi $t0,$zero,0
while_scan_limited:
	slt $t1,$t0,$a1
	beq $t1,$zero,end_while_scan_limited
	addi $v0,$zero,12
	syscall
	
	beq $v0,'\n',end_while_scan_limited
	
	addi $a1,$t0,0
	addi $a2,$v0,0
	
	sw $t0,0($sp)
	jal Setchar
	lw $t0,0($sp)
	lw $a0,8($sp)
	lw $a1,4($sp)
	
	addi $t0,$t0,1
	j while_scan_limited
end_while_scan_limited:
	
	addi $v0,$t0,0
	
	lw $ra,12($sp)
	addi $sp,$sp,16
	
	jr $ra
	
#-----------------------------------------------------------------
# ham lay ki tu thu $a1 cua string co dia chi $a0, tra gia tri ve $v0
Getchar:	
	add $t0,$a0,$a1
	lb $v0,0($t0)
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
# Ham chuyen doi tu chuoi sang so
# Chuoi co dia chi luu trong $a0, chi so dau va cuoi cua chuoi su dung de chuyen sang so la $a1 va $a2
# Tra ve $v0 bang gia tri so tinh duoc, $v1 = 1: neu co the chuyen chuoi do sang so
# Tra ve $v1 = 0: neu khong the chuyen chuoi do sang so

String_to_number:
	addi $sp,$sp,-24
	sw $ra,20($sp)
	sw $a0,16($sp)
	sw $a1,12($sp)
	sw $a2,8($sp)
	
	addi $t0,$zero,0	# Gan so can tinh bang 0
	addi $t1,$a1,0		# Bat dau duyet tu $a1
	
while_String_to_number:
	slt $t2,$a2,$t1
	bne $t2,$zero, end_while_String_to_number
	
	sw $t0,0($sp)
	sw $t1,4($sp)
	addi $a1,$t1,0
	jal Getchar_Char_to_number
	lw $a1,12($sp)
	lw $a2,8($sp)
	lw $t1,4($sp)
	lw $t0,0($sp)
	
	beq $v1,$zero, String_to_number_false
	addi $t3,$zero, 10
	mult $t0,$t3
	mflo $t0
	add $t0,$t0,$v0
	
	addi $t1,$t1,1
	j while_String_to_number
	
end_while_String_to_number:
	addi $v1,$zero,1
	addi $v0,$t0,0
	j end_check_digit
String_to_number_false:
	addi $v1,$zero,0
end_check_digit:
	lw $ra,20($sp)
	addi $sp,$sp,24
	jr $ra

#-----------------------------------------------------------
# Ham kiem tra bo ba gia tri (ngay, thang, nam) = ($a0, $a1, $a2) co hop le khong
# Tra ve $v0=1 neu hop le, $v0=0 neu khong hop le
Check_date_value:
	# Luu $ra,$a0 vao stack
	addi $sp,$sp,-8
	sw $ra,4($sp)
	sw $a0,0($sp)
	
	# Kiem tra xem ngay va thang co bang 0 hay khong
	beq $a1,$zero,Check_date_value_false
	beq $a0,$zero,Check_date_value_false
	
	# Kiem tra xem thang co be hon hoac bang 12 khong
	addi $t1,$zero,12
	slt $t2,$t1,$a1
	bne $t2,$zero,Check_date_value_false
	
	# Kiem tra co phai thang 2 hay khong
	addi $t0,$zero,2
	beq $a1,$t0, month_28_days
	
	# Kiem tra co phai thang 4,6,9,11 (30 ngay) hay khong
	addi $t0,$zero,4
	beq $a1,$t0, month_30_days
	addi $t0,$zero,6
	beq $a1,$t0, month_30_days
	addi $t0,$zero,9
	beq $a1,$t0, month_30_days
	addi $t0,$zero,11
	beq $a1,$t0, month_30_days
	
	# Thang co 31 ngay
	addi $t1,$zero,31
	slt $t2,$t1,$a0
	beq $t2,$zero,Check_date_value_true
	j Check_date_value_false
	
month_28_days:
	addi $a0,$a2,0
	jal isLeapYear
	lw $a0,0($sp)
	bne $v0,$zero,month_28_days_leapyear
	
	addi $t1,$zero,28
	slt $t2,$t1,$a0
	beq $t2,$zero,Check_date_value_true
	j Check_date_value_false
	
month_28_days_leapyear:
	addi $t1,$zero,29
	slt $t2,$t1,$a0
	beq $t2,$zero,Check_date_value_true
	j Check_date_value_false
	
month_30_days:
	# Thang co 30 ngay
	addi $t1,$zero,30
	slt $t2,$t1,$a0
	beq $t2,$zero,Check_date_value_true
	j Check_date_value_false

Check_date_value_false:
	addi $v0,$zero,0
	j end_Check_date_value
Check_date_value_true:	
	addi $v0,$zero,1
end_Check_date_value:
	lw $ra,4($sp)
	lw $a0,0($sp)
	addi $sp,$sp,8
	jr $ra
	
#-------------------------------------------------------------
# Ham gan ki tu $a2 vao vi tri $a1 cua string $a0
Setchar:
	add $t0,$a0,$a1
	sb $a2,0($t0)
	jr $ra
			
#----------------------------------------------------------
# Ham lay gia tri ngay trong chuoi TIME (DD/MM/YYYY) co dia chi $a0
# Neu co the lay gia tri ngay, tra ve $v1 = 1, $v0 la gia tri ngay
# Neu khong the lay gia tri ngay, tra ve $v1 = 0
Date:
	addi $sp,$sp,-28
	sw $ra,24($sp)
	sw $a0,0($sp)
	sw $a1,4($sp)
	sw $a2,8($sp)
	sw $a3,12($sp)
	
	addi $t0,$zero,10
	sw $t0,16($sp)
	
	# Dua 'day' vao chuoi
	# Dua chu so hang chuc cua day vao chuoi
	lw $a0,0($sp)
	lw $t0,16($sp)
	div $a0,$t0
	mflo $t2
	addi $t1,$t2,48
	
	addi $a0,$a3,0
	addi $a1,$zero,0
	addi $a2,$t1,0
	jal Setchar
	
	# Dua chu so hang don vi cua day vao chuoi
	lw $a0,0($sp)
	lw $t0,16($sp)
	div $a0,$t0
	mfhi $t3
	addi $t1,$t3,48
	
	addi $a0,$a3,0
	addi $a1,$zero,1
	addi $a2,$t1,0
	jal Setchar
	
	# Dua ki tu '/' vaof chuoi
	addi $a0,$a3,0
	addi $a1,$zero,2
	addi $a2,$zero,'/'
	jal Setchar
	
	# Dua month vao chuoi
	# Dua chu so hang chuc cua month vao chuoi
	lw $a1,4($sp)
	lw $t0,16($sp)
	div $a1,$t0
	mflo $t2
	addi $t1,$t2,48
	
	addi $a0,$a3,0
	addi $a1,$zero,3
	addi $a2,$t1,0
	jal Setchar
	
	# Dua chu so hang don vi cua month vao chuoi
	lw $a1,4($sp)
	lw $t0,16($sp)
	div $a1,$t0
	mfhi $t3
	addi $t1,$t3,48
	
	addi $a0,$a3,0
	addi $a1,$zero,4
	addi $a2,$t1,0
	jal Setchar
	
	# Dua ki tu '/' vao chuoi
	addi $a0,$a3,0
	addi $a1,$zero,5
	addi $a2,$zero,'/'
	jal Setchar
	
	# Dua year vao chuoi
	# Dua chu so hang don vi cua year vao chuoi
	lw $a2,8($sp)
	lw $t0,16($sp)
	div $a2,$t0
	mflo $t2
	sw $t2,20($sp)
	mfhi $t3
	addi $t1,$t3,48
	
	addi $a0,$a3,0
	addi $a1,$zero,9
	addi $a2,$t1,0
	jal Setchar
	
	# Dua chu so hang chuc cua day vao chuoi
	lw $t2,20($sp)
	lw $t0,16($sp)
	div $t2,$t0
	mflo $t2
	sw $t2,20($sp)
	mfhi $t3
	addi $t1,$t3,48
	
	addi $a0,$a3,0
	addi $a1,$zero,8
	addi $a2,$t1,0
	jal Setchar
	
	# Dua chu so hang tram cua day vao chuoi
	lw $t2,20($sp)
	lw $t0,16($sp)
	div $t2,$t0
	mflo $t2
	sw $t2,20($sp)
	mfhi $t3
	addi $t1,$t3,48
	
	addi $a0,$a3,0
	addi $a1,$zero,7
	addi $a2,$t1,0
	jal Setchar
	
	# Dua chu so hang nghin cua day vao chuoi
	lw $t2,20($sp)
	lw $t0,16($sp)
	div $t2,$t0
	mflo $t2
	sw $t2,20($sp)
	mfhi $t3
	addi $t1,$t3,48
	
	addi $a0,$a3,0
	addi $a1,$zero,6
	addi $a2,$t1,0
	jal Setchar
	
	lw $v0,12($sp)
	lw $ra,24($sp)
	addi $sp,$sp,28
	
	jr $ra
			
#----------------------------------------------------------
# Ham lay gia tri ngay trong chuoi TIME (DD/MM/YYYY) co dia chi $a0
# Neu co the lay gia tri ngay, tra ve $v1 = 1, $v0 la gia tri ngay
# Neu khong the lay gia tri ngay, tra ve $v1 = 0
Day:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	addi $a1,$zero,0
	addi $a2,$zero,1
	jal String_to_number
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra

#----------------------------------------------------------	
# Ham lay gia tri thang trong chuoi TIME (DD/MM/YYYY) co dia chi $a0
# Neu co the lay gia tri thang, tra ve $v1 = 1, $v0 la gia tri thang
# Neu khong the lay gia tri thang, tra ve $v1 = 0
Month:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	addi $a1,$zero,3
	addi $a2,$zero,4
	jal String_to_number
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra

#--------------------------------------------------------	
# Ham lay gia tri ngay trong chuoi TIME (DD/MM/YYYY) co dia chi $a0
# Neu co the lay gia tri nam, tra ve $v1 = 1, $v0 la gia tri nam
# Neu khong the lay gia tri nam, tra ve $v1 = 0
Year:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	addi $a1,$zero,6
	addi $a2,$zero,9
	jal String_to_number
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra

#----------------------------------------------------
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
#--------------------------------------------------
# Ham lay tham so C trong cong thuc, tham so C chinh la hai so cuoi cua nam
getC:
	add $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	addi $t0, $a0, 0  # Year
	# C la hai chu so dau tien cua nam
	addi $t1, $zero, 100    
	div $t0, $t1               
	mflo $v0         # Tra ve hai chu so dau tien cua nam
	
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra

#--------------------------------------------------
# Ham lay tham so D trong cong thuc, tham so D chinh la 2 so cuoi cua nam
getD:
	add $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	addi $t0, $a0, 0  # Year
	# C la hai chu so dau tien cua nam
	addi $t1, $zero, 100    
	div $t0, $t1               
	mfhi $v0         # Tra ve hai chu so dau tien cua nam
	
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
#------------------------------------------------
# Lenh tao chuoi mang ten thu trong tuan
getWeekDayString:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	# Cap phat bo nho cho $t0
	addi $v0, $zero, 9
	addi $a0, $zero, 3
	syscall
	lw $a0, 0($sp)
	addi $t0, $v0, 0
	beq $a0, $zero, Sunday
	addi $t2, $a0, -1
	beq $t2, $zero, Monday
	addi $t2, $a0, -2
	beq $t2, $zero, Tuesday
	addi $t2, $a0, -3
	beq $t2, $zero, Wednesday
	addi $t2, $a0, -4
	beq $t2, $zero, Thursday
	addi $t2, $a0, -5
	beq $t2, $zero, Friday
	addi $t2, $a0, -6
	beq $t2, $zero,Saturday
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
	# Vi so thu tu cac thang bat dau tu thang 3 (March-1, April-2,...) nen 
	# ta co cong thuc m = (month + 10) % 12
	addi $t0, $a0, 10
	addi $t1, $zero, 12
	div $t0, $t1
	mfhi $t2
	beq $t2, $zero, returnFeb
	addi $v0, $t2, 0
	j exitGetM
	returnFeb:
		addi $v0, $zero, 12
	exitGetM:
		lw $ra, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, 8
		jr $ra
#--------------------------------------
# Cho biet ngay do la thu may trong tuan
# Su dung cong thuc: weekday = {k + [(13*m-1)/5] + D + [D/4] + [C/4] - 2*C} % 7
WeekDay:
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	jal Day
	sw $v0, 8($sp) # Luu vao stack
	
	jal Month
	addi $t8, $v0, 0   # $t8 = month
	
	addi $a0, $v0, 0
	jal getM
	sw $v0, 12($sp)  # Luu vao stack
	
	lw $a0, 0($sp)      # Khoi phuc lai chuoi input
	
	jal Year
	addi $a0, $v0, 0    # $a0 = year
	
	# Neu thang = 1 || thang = 2 thi nam = nam - 1
	addi $t7, $t8, -1
	beq $t7, $zero, YearMinus1
	addi $t7, $t8, -2
	beq $t7, $zero, YearMinus1
	j YearNormal
YearMinus1:
	addi $a0, $a0, -1
YearNormal:	
	jal getD
	sw $v0, 16($sp)
	jal getC
	sw $v0, 20($sp)
	
	lw $t0, 8($sp)  # $t0 = k
	lw $t1, 12($sp)  # $t1 = m
	lw $t2, 16($sp)   # $t2 = D
	lw $t3, 20($sp)   # $t3 = C
	add $t4, $t0, $t2     # k + D
	addi $t5, $zero, 4
	div $t2, $t5           
	mflo $t6             # [D/ 4]
	add $t4, $t4, $t6     # k + D + [D/ 4]
	div $t3, $t5           
	mflo $t6             # [C/ 4]
	add $t4, $t4, $t6     # k + D + [D/ 4] + [C/ 4]
	addi $t5, $zero, -2
	mult $t3, $t5         # -2*C
	mflo $t6              # k + D + [D/ 4] + [C/ 4] - 2*C
	add $t4, $t4, $t6
	addi $t5, $zero, 13
	mult $t1, $t5           # 13m
	mflo $t6
	addi $t6, $t6, -1      #13m - 1
	addi $t5, $zero, 5
	div $t6, $t5          #[(13m-1) / 5]
	mflo $t6  
	add $t4, $t4, $t6      # k + D + [D/ 4] + [C/ 4] - 2*C + [(13m-1) / 5]
	addi $t5, $zero, 7
	div $t4, $t5         # {k + D + [D/ 4] + [C/ 4] - 2*C + [(13m-1) / 5]} % 7
	mfhi $a0
	jal getWeekDayString
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp,  20
	jr $ra

#-------------------------------------------
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

#--------------------------------------
#Xuat 2 nam nhuan lien ke
#Tham so truyen vao la char* TIME
# $a0 : DD/MM/YYYY
#$v0 la nam nho, $v1 la nam lon
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

	la $a0, SPACE 
	addi $v0, $zero, 4
	syscall 
	
	lw $a0, 12($sp)		#ket qua 2
	addi $v0, $zero, 1
	syscall

	lw $a0, 4($sp) 	
	
	addi $sp, $sp, 16	
	jr $ra

# Convert Day sang chuoi
DayToString:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	
	addi $v0, $zero, 9
	addi $a0, $zero, 2
	syscall
	lw $a0, 0($sp)
	addi $t4,$v0, 0
	
	addi $t5, $a0, 0
	addi $t0, $zero, 10
	div $t5, $t0
	mfhi $t1             # So Hang Don Vi
	mflo $t2             # So Hang Chuc
	# Chuyen tung ki tu sang char roi luu vao chuoi
	addi $t3, $t1, 48
	sb $t3, 1($t4)
	addi $t3, $t2, 48
	sb $t3, 0($t4)
	addi $v0, ,$t4, 0
	# exit
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra

# Convert Month sang chuoi
MonthToString:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	addi $t0, $a1, -65
	beq $t0, $zero, numConvert
	addi $t0, $a1, -66
	beq $t0, $zero, nameConvert
	addi $t0, $a1, -67
	beq $t0, $zero, nameConvert
numConvert:
	addi $v0, $zero, 9
	addi $a0, $zero, 3
	syscall
	lw $a0, 0($sp)
	addi $t4,$v0, 0
	
	addi $t5, $a0, 0
	addi $t0, $zero, 10
	div $t5, $t0
	mfhi $t1             # So Hang Don Vi
	mflo $t2             # So Hang Chuc
	# Chuyen tung ki tu sang char roi luu vao chuoi
	addi $t3, $t1, 48
	sb $t3, 1($t4)
	addi $t3, $t2, 48
	sb $t3, 0($t4)
	addi $v0, ,$t4, 0
	j exitMonthToString
nameConvert:
	addi $t0, $a0, -1
	beq $t0, $zero, getJan
	addi $t0, $a0, -2
	beq $t0, $zero, getFeb
	addi $t0, $a0, -3
	beq $t0, $zero, getMar
	addi $t0, $a0, -4
	beq $t0, $zero, getApr
	addi $t0, $a0, -5
	beq $t0, $zero, getMay
	addi $t0, $a0, -6
	beq $t0, $zero, getJun
	addi $t0, $a0, -7
	beq $t0, $zero, getJul
	addi $t0, $a0, -8
	beq $t0, $zero, getAug
	addi $t0, $a0, -9
	beq $t0, $zero, getSep
	addi $t0, $a0, -10
	beq $t0, $zero, getOct
	addi $t0, $a0, -11
	beq $t0, $zero, getNov
	addi $t0, $a0, -12
	beq $t0, $zero, getDec
getJan:
	addi $a0, $zero, 'J'
	addi $a1, $zero, 'a'
	addi $a2, $zero, 'n'
	jal getNameOfMonth
	j exitMonthToString
getFeb:
	addi $a0, $zero, 'F'
	addi $a1, $zero, 'e'
	addi $a2, $zero, 'b'
	jal getNameOfMonth
	j exitMonthToString
getMar:
	addi $a0, $zero, 'M'
	addi $a1, $zero, 'a'
	addi $a2, $zero, 'r'
	jal getNameOfMonth
	j exitMonthToString
getApr:
	addi $a0, $zero, 'A'
	addi $a1, $zero, 'p'
	addi $a2, $zero, 'r'
	jal getNameOfMonth
	j exitMonthToString
getMay:
	addi $a0, $zero, 'M'
	addi $a1, $zero, 'a'
	addi $a2, $zero, 'y'
	jal getNameOfMonth
	j exitMonthToString
getJun:
	addi $a0, $zero, 'J'
	addi $a1, $zero, 'u'
	addi $a2, $zero, 'n'
	jal getNameOfMonth
	j exitMonthToString
getJul:
	addi $a0, $zero, 'J'
	addi $a1, $zero, 'u'
	addi $a2, $zero, 'l'
	jal getNameOfMonth
	j exitMonthToString
getAug:
	addi $a0, $zero, 'A'
	addi $a1, $zero, 'u'
	addi $a2, $zero, 'g'
	jal getNameOfMonth
	j exitMonthToString
getSep:
	addi $a0, $zero, 'S'
	addi $a1, $zero, 'e'
	addi $a2, $zero, 'p'
	jal getNameOfMonth
	j exitMonthToString
getOct:
	addi $a0, $zero, 'O'
	addi $a1, $zero, 'c'
	addi $a2, $zero, 't'
	jal getNameOfMonth
	j exitMonthToString
getNov:
	addi $a0, $zero, 'N'
	addi $a1, $zero, 'o'
	addi $a2, $zero, 'v'
	jal getNameOfMonth
	j exitMonthToString
getDec:
	addi $a0, $zero, 'D'
	addi $a1, $zero, 'e'
	addi $a2, $zero, 'c'
	jal getNameOfMonth
	j exitMonthToString
exitMonthToString:
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra

# Convert Year sang chuoi
YearToString:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	addi $t6, $a0, 0
	addi $v0, $zero, 9
	addi $a0, $zero, 4
	syscall
	lw $a0, 0($sp)
	addi $t4,$v0, 0
	
	addi $t2, $zero, 4
Loop:
	beq $t6, 0, exitYearToString    # while (year != 0)
	addi $t0, $zero, 10
	div $t6, $t0                
	mfhi $t3
	mflo $t6               # year = year / 10
	addi $t3, $t3, 48
	addi $t5, $t2, -4
	beq $t5, $zero, add3
	addi $t5, $t2, -3
	beq $t5, $zero, add2
	addi $t5, $t2, -2
	beq $t5, $zero, add1
	addi $t5, $t2, -1
	beq $t5, $zero, add0
add3:
	sb $t3, 3($t4)
	addi $t2, $t2, -1
	j Loop
add2:
	sb $t3, 2($t4)
	addi $t2, $t2, -1
	j Loop
add1:
	sb $t3, 1($t4)
	addi $t2, $t2, -1
	j Loop
add0:
	sb $t3, 0($t4)
	addi $t2, $t2, -1
	j Loop
exitYearToString:
	addi $v0, $t4, 0
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra

# Tao chuoi ten thang
getNameOfMonth:
	addi $sp, $sp, -16
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	
	addi $v0, $zero, 9
	addi $a0, $zero, 3
	syscall

	lw $a0, 0($sp)
	addi $t7, $v0, 0
	addi $t0, $a0, 0
	sb $t0, 0($t7)
	addi $t0, $a1, 0
	sb $t0, 1($t7)
	addi $t0, $a2, 0
	sb $t0, 2($t7)
	
	addi $v0, $t7, 0
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
# Convert chuoi ngay ra kieu A MM/DD/YYYY
convertAType:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	# Cap phat bo nho cho $t7
	addi $v0, $zero, 9
	addi $a0, $zero, 10
	syscall
	lw $a0, 0($sp)
	addi $t7,$v0, 0
	
	jal Month
	addi $a0, $v0, 0
	addi $a1, $zero, 65
	jal MonthToString
	addi $t1, $v0, 0
	lb $t2, 0($t1)
	sb $t2, 0($t7)
	lb $t2, 1($t1)
	sb $t2, 1($t7)
	addi $t2, $zero, 47
	sb $t2, 2($t7)
	lw $a0, 0($sp)
	jal Day
	addi $a0, $v0, 0
	jal DayToString
	addi $t1, $v0, 0
	lb $t2, 0($t1)
	sb $t2, 3($t7)
	lb $t2, 1($t1)
	sb $t2, 4($t7)
	addi $t2, $zero, 47
	sb $t2, 5($t7)
	lw $a0, 0($sp)
	jal Year
	addi $a0, $v0, 0
	jal YearToString
	addi $t1, $v0, 0
	lb $t2, 0($t1)
	sb $t2, 6($t7)
	lb $t2, 1($t1)
	sb $t2, 7($t7)
	lb $t2, 2($t1)
	sb $t2, 8($t7)
	lb $t2, 3($t1)
	sb $t2, 9($t7)
	# exit
	addi $v0, $t7, 0
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	j exitMainConvert

# Convert chuoi ngay ra kiem Month DD, YYYY
convertBType:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	# Cap phat bo nho cho $t8
	addi $v0, $zero, 9
	addi $a0, $zero, 10
	syscall
	lw $a0, 0($sp)
	addi $t8,$v0, 0
	
	jal Month
	addi $a0, $v0, 0
	addi $a1, $zero, 66
	jal MonthToString
	addi $t0, $v0, 0    # Month String
	lb $t1, 0($t0)
	sb $t1, 0($t8)
	lb $t1, 1($t0)
	sb $t1, 1($t8)
	lb $t1, 2($t0)
	sb $t1, 2($t8)
	addi $t1, $zero, 32
	sb $t1, 3($t8)
	# Gan chuoi Day
	lw $a0, 0($sp)
	jal Day
	addi $a0, $v0, 0
	jal DayToString
	addi $t0, $v0, 0   # Day String
	lb $t1, 0($t0)
	sb $t1, 4($t8)
	lb $t1, 1($t0)
	sb $t1, 5($t8)
	addi $t1, $zero, 44
	sb $t1, 6($t8)
	# Gan chuoi Year
	lw $a0, 0($sp)
	jal Year
	addi $t5, $v0, 0
	addi $t2, $zero, 10
	addi $t3, $zero, 4
setYear:
	beq $t5, $zero, exitConvert
	div  $t5, $t2
	mfhi $t1
	addi $t1, $t1, 48
	addi $t4, $t3, -4
	beq $t4, $zero, add10
	addi $t4, $t3, -3
	beq $t4, $zero, add9
	addi $t4, $t3, -2
	beq $t4, $zero, add8
	addi $t4, $t3, -1
	beq $t4, $zero, add7
add10:
	sb $t1, 10($t8)
	mflo $t5
	addi $t3, $t3, -1
	j setYear
add9:
	sb $t1, 9($t8)
	mflo $t5
	addi $t3, $t3, -1
	j setYear
add8:
	sb $t1, 8($t8)
	mflo $t5
	addi $t3, $t3, -1
	j setYear
add7:
	sb $t1, 7($t8)
	mflo $t5
	addi $t3, $t3, -1
	j setYear
exitConvert:	
	addi $v0, $t8, 0
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	j exitMainConvert

# Chuyen chuoi ngay thanh dang DD Month, YYYY
convertCType:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	# Cap phat bo nho cho $t8
	addi $v0, $zero, 9
	addi $a0, $zero, 10
	syscall
	lw $a0, 0($sp)
	addi $t8,$v0, 0
	
	jal Day
	addi $a0, $v0, 0
	jal DayToString
	addi $t0, $v0, 0   # Day String
	lb $t1, 0($t0)
	sb $t1, 0($t8)
	lb $t1, 1($t0)
	sb $t1, 1($t8)
	addi $t1, $zero, 32
	sb $t1, 2($t8)
	# Gan chuoi Month 
	lw $a0, 0($sp)
	jal Month
	addi $a0, $v0, 0
	addi $a1, $zero, 66
	jal MonthToString
	addi $t2, $v0, 0    # Month String
	lb $t1, 0($t2)
	sb $t1, 3($t8)
	lb $t1, 1($t2)
	sb $t1, 4($t8)
	lb $t1, 2($t2)
	sb $t1, 5($t8)
	addi $t1, $zero, 44
	sb $t1, 6($t8)
	# Gan chuoi Year
	lw $a0, 0($sp)
	jal Year
	addi $t5, $v0, 0
	addi $t2, $zero, 10
	addi $t3, $zero, 4
	j setYear  


Convert:
	addi $sp, $sp, -12
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	sw $a1, 8($sp)
	
	addi $t0, $a1, -65
	beq $t0, $zero, convertAType
	addi $t0, $a1, -66
	beq $t0, $zero, convertBType
	addi $t0, $a1, -67
	beq $t0, $zero, convertCType
	
exitMainConvert:
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	jr $ra

#-------------------------------------
#Tinh khoang cach giua 2 chuoi TIME_1 va TIME_2
#Input vao chuoi TIME_1 < TIME_2
#Don vi tinh: nam
distanceDate:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp) 	#Luu chuoi TIME_1
	sw $a1, 8($sp)	#Luu chuoi TIME_2
	
	#Lay Year cua TIME_1
	lw $a0, 4($sp)
	jal Year
	sw $v0, 12($sp)
	#Lay Year cua TIME_2
	lw $a0, 8($sp)
	jal Year
	sw $v0, 16($sp)

	lw $a0, 12($sp)		#Load year cua TIME_1
	lw $a1, 16($sp)		#Load year cua TIME_2

	sub $t0, $a1, $a0	#Tinh khoang cach nam
	sw $t0, 20($sp)		
	
compareMonth:
	#Lay thang cho TIME_1
	lw $a0, 4($sp)
	jal Month
	sw $v0, 12($sp)
	#Lay thang cho TIME_2
	lw $a0, 8($sp)
	jal Month
	sw $v0, 16($sp)
	
	#Neu thang cua TIME_2 nho hon TIME_1 thi giam ket qua di 1 
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	beq $t2, $t1, compareDay 	#Neu thang bang nhau thi so sanh ngay
	slt $t0, $t2, $t1  		#So sanh gia tri $t2 < $t1 
	bne $t0, $zero, decrease
	j exitDistanceDate
	
compareDay:
	#Lay ngay cho TIME_1
	lw $a0, 4($sp)
	jal Day
	sw $v0, 12($sp)
	#Lay ngay cho TIME_2
	lw $a0, 8($sp)
	jal Day
	sw $v0, 16($sp)
	
	#Neu ngay cua TIME_2 nho hon TIME_1 thi tru ket qua di 1
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	slt $t0, $t2, $t1
	beq $t0, $zero, exitDistanceDate 
	
#Giam ket qua xuong 1 
decrease:
	lw $v0, 20($sp)
	addi $v0, $v0, -1
	sw $v0, 20($sp) 
	
	
exitDistanceDate:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $v0, 20($sp)
	addi $sp, $sp, 24
	jr $ra

#Ham so sanh 2 TIME_1($a0) va TIME_2 ($a1)
#Ket qua ham duoc luu o dia chi $v0
#$v0 = 1 neu TIME_1 < TIME_2 nguoc lai thi $v0 = 0
compareDate: 
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp) 	#Luu chuoi TIME_1
	sw $a1, 8($sp)	#Luu chuoi TIME_2

	#Lay Year cua TIME_1
	lw $a0, 4($sp)
	jal Year
	sw $v0, 12($sp)
	#Lay Year cua TIME_2
	lw $a0, 8($sp)
	jal Year
	sw $v0, 16($sp)
	
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	beq $t1, $t2, cmpMonth
	slt $t0, $t1, $t2 	#so sanh nam
	bne $t0, $zero, Smaller
	beq $t0, $zero, Bigger 
cmpMonth:
	#Lay Month cua TIME_1
	lw $a0, 4($sp)
	jal Month
	sw $v0, 12($sp)
	#Lay Month cua TIME_2
	lw $a0, 8($sp)
	jal Month
	sw $v0, 16($sp)
	
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	beq $t1, $t2, cmpDay
	slt $t0, $t1, $t2 	#so sanh nam
	bne $t0, $zero, Smaller
	beq $t0, $zero, Bigger 	
cmpDay:
	#Lay Year cua TIME_1
	lw $a0, 4($sp)
	jal Day
	sw $v0, 12($sp)
	#Lay Year cua TIME_2
	lw $a0, 8($sp)
	jal Day
	sw $v0, 16($sp)
	
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	slt $t0, $t1, $t2 	#so sanh nam
	bne $t0, $zero, Smaller
Bigger:	
	addi $v0, $zero, 0
	j exitCompareDate
Smaller:
	addi $v0, $zero, 1
exitCompareDate:	
	lw $ra, 0($sp)
	lw $a0, 4($sp) 	
	lw $a1, 8($sp)
	addi $sp, $sp, 24
	jr $ra
	

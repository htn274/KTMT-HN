#pragma once
#include <iostream>
#include <string>
#include <vector>
#include "QNum.h"
using namespace std;

class QInt : public QNum{
private:
	// Chuyển một chuỗi ở hệ 2 sang QInt
	void scanBin(string source);
	// Chuyển chuỗi ở hệ 16 sang QInt
	void scanHex(string source);
	// Chuyển chuỗi ở hệ 10 sang QInt
	void scanDec(string source);
public:
	//Khởi tạo mặc định
	QInt();
	//Khởi tạo bởi một số nguyên x 
	QInt(unsigned int x);
	//Khởi tạo từ một vector<bool>
	QInt(vector<bool> x);
	//Hàm nhập một chuỗi ở 1 hệ cơ số bất kỳ vào QInt
	void ScanQInt(string source, int base);
	// Hàm xuất QInt ở 1 hệ cơ số bất kỳ
	void PrintQInt(int base);

	//Chuyển QInt sang hệ 2 
	vector<bool> convertToBin();
	//Chuyển QInt sang hệ 16
	string convertToHex();
	//Chuyển QInt sang hệ 10
	string convertToDec() const;
	
	//Phép dịch trái
	QInt operator <<(int index) const;
	//Phép dịch phải
	QInt operator >>(int index) const;

	//Kiểm tra có phải bằng 0 
	bool IsZero() const;
	//Kiểm tra số âm
	bool IsNegative() const;
	//Phép dịch trái logic
	QInt ShiftLeftLogical(int index) const;
	//Phép dịch phải logic
	QInt ShiftRightLogical(int index) const;
	//Phép chia là lưu phần dư vào biết remainder
	QInt Divide(const QInt& divisor, QInt& remainder) const;

	//Phép toán cộng
	QInt operator + (const QInt& a) const;
	//Phép toán trừ
	QInt operator -() const;
	//Phép lấy số đối 
	QInt operator - (const QInt& a) const;
	//Phép nhân
	QInt operator * (const QInt& a) const;
	//Phép chia
	QInt operator / (const QInt& a) const;
  
	QInt operator & (QInt& a); //Toán tử AND
	QInt operator | (QInt& a); // Toán tử OR
	QInt operator ^ (QInt& a); // Toán tử XOR
	QInt operator ~ (); // Toán tử NOT

	//Toán tử gán
	QInt& operator =(const QInt& a);
	
	bool isZero();
	vector<bool> toSignedNumber(bool &sign); //Đổi sang số lượng dấu
};


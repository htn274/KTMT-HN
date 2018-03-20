#include <iostream>
#include <string>
#include <vector>
#include "QNum.h"
using namespace std;

class QInt : public QNum{
private:
	void scanBin(string source);
	void scanHex(string source);
	void scanDec(string source);
public:
	QInt();
	QInt(unsigned int x);
	QInt(vector<bool> x);
	void ScanQInt(string source, int base);
	void PrintQInt(int base);

	vector<bool> convertToBin();
	string convertToHex();
	string convertToDec() const;

	friend istream& operator >> (istream is, QInt& a);
	friend ostream& operator << (ostream os, const QInt& a);
	
	QInt operator <<(int index) const;
	QInt operator >>(int index) const;


	bool IsZero() const;
	bool IsNegative() const;
	QInt ShiftLeftLogical(int index) const;
	QInt ShiftRightLogical(int index) const;
	QInt Divide(const QInt& divisor, QInt& remainder) const;

	QInt operator + (const QInt& a) const;
	QInt operator -() const;
	QInt operator - (const QInt& a) const;
	QInt operator * (const QInt& a) const;
	QInt operator / (const QInt& a) const;
  
	QInt operator & (QInt& a); //Toán tử AND
	QInt operator | (QInt& a); // Toán tử OR
	QInt operator ^ (QInt& a); // Toán tử XOR
	QInt operator ~ (); // Toán tử NOT

	QInt& operator =(const QInt& a);
	
	bool isZero();
	vector<bool> toSignedNumber(bool &sign); //Đổi sang số lượng dấu
};


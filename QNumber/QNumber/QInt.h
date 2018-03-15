#include <iostream>
#include "QNum.h"
using namespace std;

class QInt : public QNum{
public:
	QInt();
	QInt(unsigned int x);
	void ScanQInt();
	void PrintQInt();

	bool * DecToBin(QInt x);
	QInt BinToDec(bool *bit);
	char *BinToHex(bool *bit);
	char *DecToHex(QInt x);

	friend istream& operator >> (istream is, QInt& a);
	friend ostream& operator << (ostream os, const QInt& a);
  
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
};

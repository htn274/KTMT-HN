#include <iostream>
#include "QNum.h"
using namespace std;

class QInt : public QNum{
public:
	void ScanQInt();
	void PrintQInt();

	bool * DecToBin(QInt x);
	QInt BinToDec(bool *bit);
	char *BinToHex(bool *bit);
	char *DecToHex(QInt x);

	QInt& operator + (const QInt& a);
	QInt& operator - (const QInt& a);
	QInt& operator * (const QInt& a);
	QInt& operator / (const QInt& a);

	QInt operator & (QInt& a); //Toán tử AND
	QInt operator | (QInt& a); // Toán tử OR
	QInt operator ^ (QInt& a); // Toán tử XOR
	QInt operator ~ (); // Toán tử NOT

	QInt& operator =(const QInt& a);
};

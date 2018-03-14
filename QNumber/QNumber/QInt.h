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

	friend istream& operator >> (istream is, QInt& a);
	friend ostream& operator << (ostream os, const QInt& a);
	QInt& operator + (const QInt& a);
	QInt& operator - (const QInt& a);
	QInt& operator * (const QInt& a);
	QInt& operator / (const QInt& a);
};

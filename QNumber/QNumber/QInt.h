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
	void ScanQInt(string source, int base);
	void PrintQInt(int base);

	vector<bool> convertToBin();
	string convertToHex();
	string convertToDec();

	//bool * DecToBin(QInt x);
	//QInt BinToDec(bool *bit);
	//char *BinToHex(bool *bit);
	//char *DecToHex(QInt x);

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
#include <iostream>

using namespace std;

class QInt {
private:
	int arr[4]; // 4 int = 16 byte
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

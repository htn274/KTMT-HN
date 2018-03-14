#include "QInt.h"

QInt QInt::operator&(QInt & a)
{
	QInt res; // Biến lưu kết quả
	for (int i = 0; i < MAX_N; i++) {
		res.Init(i, this->arr[i] & a.arr[i]);
	}
	return res;
}

QInt QInt::operator|(QInt & a)
{
	QInt res; // Biến lưu kết quả
	for (int i = 0; i < MAX_N; i++) {
		res.Init(i, this->arr[i] | a.arr[i]);
	}
	return res;
}

QInt QInt::operator^(QInt & a)
{
	QInt res; // Biến lưu kết quả
	for (int i = 0; i < MAX_N; i++) {
		res.Init(i, this->arr[i] ^ a.arr[i]);
	}
	return res;
}

QInt QInt::operator~()
{
	QInt res; // Biến lưu kết quả
	for (int i = 0; i < MAX_N; i++) {
		res.Init(i, ~this->arr[i]);
	}
	return res;
}

QInt& QInt::operator=(const QInt & a)
{
	for (int i = 0; i < MAX_N; i++)
		this->arr[i] = a.arr[i];
	return *this;
}

string divideDecStringByTwo(string source) {
	string result = "";
	int remainder = 0;
	char quotent;
	int length = source.length();
	int currentDigitPosition = 0;
	
	while (currentDigitPosition < length) {
		int realDigitConvertedFromSource = source[currentDigitPosition] - '0' + remainder * 10;
		
		remainder = realDigitConvertedFromSource % 2;
		quotent = realDigitConvertedFromSource / 2 + '0';
		result += quotent;
		
		currentDigitPosition++;
	}

	return result;
}

bool isFullZero(string source) {
	int currentPosition = 0;
	
	while (source[currentPosition] == '0') {
		currentPosition++;
	}

	if (currentPosition == source.length())
		return true;
	else
		return false;
}

bool getRemainder(string dividend) {
	int lastDigit = dividend[dividend.length() - 1] - '0';
	return lastDigit % 2;
}

vector<bool> generateBinaryArrayFromDecString(string source) {
	vector<bool> result;
	string dividend = source;
	bool remainder;
	
	while (!isFullZero(dividend)) {
		remainder = getRemainder(dividend);
		result.push_back(remainder);
		dividend = divideDecStringByTwo(dividend);
	}

	return result;
}

QInt decStringToBinary(string source) {
	QInt result;
	vector<bool> binaryArray = generateBinaryArrayFromDecString(source);
	for (int i = 0; i < binaryArray.size(); i++) {
		result.setBitQNum(i, binaryArray[i]);
	}

	return result;
}

void QInt::ScanQInt(string source, int destBase) {
	if (destBase == 2) {
		*this = decStringToBinary(source);
	}
}

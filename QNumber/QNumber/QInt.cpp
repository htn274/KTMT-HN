#include "QInt.h"

QInt::QInt()
{

}
QInt::QInt(unsigned int x)
{
	arr[MAX_N-1] = x;
}
QInt QInt::operator + (const QInt& a) const
{
	QInt result(0);
	bool carry = 0;
	int sumBit;
	for (int i = 0; i < NUM_OF_BIT*MAX_N; i++) {
		sumBit = (*this).getBitQNum(i) + a.getBitQNum(i) + carry;
		result.setBitQNum(i,sumBit&1);
		carry = sumBit >> 1;
	}
	return result;
}
QInt QInt::operator -() const
{
	QInt temp = *this;
	for (int i = 0; i < NUM_OF_BIT*MAX_N; i++)
		temp.toogleBitQNum(i);
	QInt one(1);
	return temp + one;

}
QInt QInt::operator - (const QInt& a) const
{
	return (*this) + (-a);
}
//QInt QInt::operator * (const QInt& a);
//QInt QInt::operator / (const QInt& a);

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


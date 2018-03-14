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

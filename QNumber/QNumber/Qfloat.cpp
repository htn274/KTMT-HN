#include "Qfloat.h"

Qfloat::Qfloat()
{
	for (int i = 0; i < MAX_N; i++) arr[i] = 0;
}

void Qfloat::ScanQfloat(string source, int base)
{
	if (base == 2) scanBinString(source);
	else scanDecString(source);
}

void Qfloat::scanBinString(string source)
{
	for (int i = 0; i < source.length(); i++)
		this->setBitQNum(MAX_N * NUM_OF_BIT - i - 1, source[i] - '0');
}

void Qfloat::scanDecString(string source)
{
}

bool Qfloat::isEqualZero() const//Kiểm tra xem số đó bằng 0 
{
	for (int i = 1; i < MAX_N; i++)
		if (arr[i] != 0) return false;
	return true;
}

int Qfloat::getExpValue() const
{
	int value = - ((1 << (NUM_BIT_EXP - 1)) - 1); // Khởi tạo -2^14-1
	for (int i = 0; i < NUM_BIT_EXP; i++)
		if (this->getBitQNum(MAX_N * NUM_OF_BIT - NUM_BIT_EXP - 1 + i) == 1) 
			value += 1 << (i);
	return value;
}

vector<bool> Qfloat::getSignificant() const
{
	vector<bool> x;
	for (int i = 0; i < NUM_BIT_SIGNI; i++) {
		x.push_back(this->getBitQNum(NUM_BIT_SIGNI - 1 - i));
	}
	return x;
}

bool Qfloat::getSign() const
{
	return this->getBitQNum(MAX_N * NUM_OF_BIT - 1);
}

Qfloat & Qfloat::operator=(const Qfloat & a)
{
	for (int i = 0; i < MAX_N; i++)
		this->arr[i] = a.arr[i];
	return *this;
}

Qfloat Qfloat::operator+(const Qfloat & a) // (*this) + a = kq
{
	//Một trong 2 số bằng 0 thì trả về số kia
	if (this->isEqualZero()) return a;
	if (a.isEqualZero()) return *this;
	//Lấy giá trị mũ
	int exp1, exp2;
	exp1 = this->getExpValue(); // Giá trị mũ của *this
	exp2 = this->getExpValue(); // giá trị mũ của a
	//Lấy phần trị
	vector<bool> signi1, signi2;
	signi1 = this->getSignificant();
	signi2 = a.getSignificant();
	signi1.insert(signi1.begin(), 1); 
	signi2.insert(signi2.begin(), 1);
	//So sánh phần mũ 
	int d = exp1 - exp2;
	if (exp1 < exp2) {
		signi1 = shiftSignificantRight(signi1, abs(d));
		exp1 = exp2;
	} 
	else if (exp2 < exp1) {
		signi2 = shiftSignificantRight(signi2, abs(d));
		exp2 = exp1;
	}
	//Lấy dấu
	bool sign1, sign2, sign;
	sign1 = this->getSign();
	sign2 = a.getSign();
	sign = 0;

	vector<bool> resSignificant = addSignificant(signi1, signi2, sign1, sign2, sign);

	return Qfloat();
}

vector<bool> Qfloat::shiftSignificantRight(vector<bool> a, int x)
{
	vector<bool> a_shift(a.size(), 0);
	for (int i = 0; i < a.size() - x; i++)
		a_shift[i + x] = a[i];
	return a_shift;
}

vector<bool> Qfloat::shiftSignificantLeft(vector<bool> a, int x)
{
	vector<bool> a_shift(a.size(), 0);
	for (int i = 0; i < a.size() - x; i++)
		a_shift[i] = a[i + x];
	return a_shift;
}

vector<bool> Qfloat::addSignificant(vector<bool> x1, vector<bool> x2, bool sign1, bool sign2, bool & sign)
{
	QInt signi1, signi2, sumSigni;
	vector<bool> res;
	signi1 = convertToQInt(x1, sign);
	signi2 = convertToQInt(x2, sign);
	sumSigni = signi1 + signi2;
	
	res = sumSigni.toSignedNumber(sign);
	return res;
}

QInt Qfloat::convertToQInt(vector<bool> x1, int sign)
{
	QInt res(x1);
	if (sign) {
		res = -res;
	}
	return res;
}






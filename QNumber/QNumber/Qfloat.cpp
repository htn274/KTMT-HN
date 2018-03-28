#include "Qfloat.h"
#include "BitMani.h"

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
	int value = - ((1 << (NUM_BIT_EXP - 1)) - 1); // Khởi tạo -(2^14-1)
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

//Đổi các bit phần trị từ vector bool sang QInt
//thêm bit lớn nhất bằng 1 (tổng NUM_BIT_SIGNI+1 bit)
QInt VectorBoolToQInt(const vector<bool>& a)
{
	QInt result;
	for (bool i = 0; i < NUM_BIT_SIGNI; i++)
		result.setBitQNum(i, a[i]);
	result.setBitQNum(NUM_BIT_SIGNI, 1);
	return result;
}
//Nhân 2 số không dấu có NUM_BIT_SIGNI bit, trả về NUM_BIT_SIGNI bit lớn nhất trong kết quả
QInt MultiplySignficant(const QInt& a, const QInt& b)
{
	QInt result;
	for (int i = 0; i < NUM_BIT_SIGNI+1; i++)
		if (b.getBitQNum(i) == 1)
			result = result + a.ShiftRightLogical(NUM_BIT_SIGNI + 1 - i);
	return result;
}

Qfloat Qfloat::operator * (const Qfloat &a)
{
	QInt value1 = VectorBoolToQInt((*this).getSignificant());
	QInt value2 = VectorBoolToQInt(a.getSignificant());
	int exp1 = (*this).getExpValue();
	int exp2 = a.getExpValue();
	bool sign1 = (*this).getSign();
	bool sign2 = a.getSign();

	Qfloat result;

	//Gán dấu
	result.setBitQNum(BIT_SIGN, !(sign1^sign2));

	int exp = exp1 + exp2;
	exp += ((1 << (NUM_BIT_EXP - 1)) - 1);//cộng số bias
	if (exp < 0 || exp >= (1 << NUM_BIT_SIGNI)) {//tràn số
		//Gán bằng số infinity
		for (int i = 0; i < NUM_BIT_EXP; i++)
			result.setBitQNum(i + NUM_BIT_SIGNI, 1);

		for (int i = 0; i < NUM_BIT_SIGNI; i++)
			result.setBitQNum(i, 0);
	}
	else {
		for (int i = 0; i < NUM_BIT_EXP; i++)
			result.setBitQNum(i + NUM_BIT_SIGNI, getBit(exp, i));

		QInt pvalue = value1*value2;
		for (int i = NUM_BIT_SIGNI + 1; i <= 2 * NUM_BIT_SIGNI; i++)
			result.setBitQNum(i-NUM_BIT_SIGNI-1, pvalue.getBitQNum(i));
	}
	
	return result;
}

void Qfloat::Deformalize(vector<bool>& integer, vector<bool>& decimal) const
{
	int exp = (*this).getExpValue();
	cout << exp << endl;
	if (exp > 30) {
		cout << "Number exceeds limit." << endl;
		exp = 30;
	}
	else if (exp < -30){
		cout << "Number exceeds limit." << endl;
		exp = -30;
	}
	integer.clear();
	decimal.clear();
	vector<bool> signi = (*this).getSignificant();
	if (exp < 0) {
		for (int i = 0; i < -exp - 1; i++)
			decimal.push_back(0);
		decimal.push_back(1);
		decimal.insert(decimal.end(), signi.begin(), signi.end());
	}
	else if (exp >= NUM_BIT_SIGNI) {
		integer.push_back(1);
		integer.insert(integer.end(), signi.begin(), signi.end());
		for (int i = 0; i < exp - NUM_BIT_SIGNI; i++)
			integer.push_back(0);
	}
	else {
		integer.push_back(1);
		integer.insert(integer.end(), signi.begin(), signi.begin()+exp);
		decimal.insert(decimal.end(), signi.begin()+exp, signi.end());
	}
}

//Chuyển Qfloat về số thập phân tĩnh
string Qfloat::ToDec() const
{
	////Số signi lấy giá trị của phần trị số Qfloat
	//QInt signi;
	//for (int i = 0; i < NUM_BIT_SIGNI; i++) {
	//	signi.setBitQNum(i, (*this).getBitQNum(i));
	//}

	//int exp = (*this).getExpValue();
	////power2 là 2^exp
	//QInt power2(1);
	//if (exp>=0)
	//	for (int i = 0; i < exp; i++)
	//		power2 = power2 * 2;
	vector<bool> integerStr, decimalStr;
	(*this).Deformalize(integerStr, decimalStr);
	QInt integer(integerStr);
	QInt decimal(decimalStr);
	string integerDec = integer.convertToDec();
	string decimalDec = decimal.convertToDec();
	return integerDec + "." + decimalDec;
}

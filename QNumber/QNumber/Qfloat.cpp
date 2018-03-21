#include "Qfloat.h"

Qfloat::Qfloat()
{
	for (int i = 0; i < MAX_N; i++) arr[i] = 0;
}

Qfloat::Qfloat(vector<bool> a)
{
	for (int i = 0; i < a.size(); i++)
		this->setBitQNum(MAX_N * NUM_OF_BIT - i - 1, a[i]);
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

bool Qfloat::isEqualZero() const//Kiểm tra xem số đó bằng 0 
{
	int exp = this->getExpValue();
	vector<bool> signi = this->getSignificant();
	return (exp == 0 & isZero(signi));
}

int Qfloat::getExpValue() const
{
	int value = - MAX_EXP; // Khởi tạo -2^14-1
	for (int i = 0; i < NUM_BIT_EXP; i++)
		if (this->getBitQNum(112 + i) == 1) {
			int tmp = 1 << i;
			value += tmp;
		}

	if (value == -MAX_EXP) return 0;
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
	Qfloat zero;
	zero.scanBinString("0");
	//Một trong 2 số bằng 0 thì trả về số kia
	if (this->isEqualZero()) return a;
	if (a.isEqualZero()) return *this;
	//Lấy giá trị mũ
	int exp1, exp2, exp;
	exp1 = this->getExpValue(); // Giá trị mũ của *this
	exp2 = a.getExpValue(); // giá trị mũ của a
	exp = exp1;
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
		exp = exp2;
	} 
	else if (exp2 < exp1) {
		signi2 = shiftSignificantRight(signi2, abs(d));
		exp = exp1;
	}
	//Lấy dấu
	bool sign1, sign2, sign;
	sign1 = this->getSign();
	sign2 = a.getSign();
	sign = 0;

	vector<bool> resSignificant = addSignificant(signi1, signi2, sign1, sign2, sign);
	
	//Nếu resSignificant = 0 thì trả về 0
	if (isZero(resSignificant)) {
		return zero;
	}

	//Chuẩn hóa kết quả 
	d = normalizeSignificant(resSignificant);
	exp = exp + d;
	if (exp < MIN_EXP) return zero;
	if (exp > MAX_EXP) return inf(sign);
	vector<bool> e = toBias(exp);
	//Tạo kết quả Qfloat
	vector<bool> res(resSignificant);
	res.insert(res.begin(), e.begin(), e.end());
	res.insert(res.begin(), sign);
	return Qfloat(res);
}

Qfloat Qfloat::operator-(const Qfloat & a)
{
	//Đổi dấu của a lại
	Qfloat minus_a = a;
	minus_a.toogleBitQNum(0);
	return (*this) + minus_a;
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
	signi1 = convertToQInt(x1, sign1);
	signi2 = convertToQInt(x2, sign2);
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

bool Qfloat::isZero(vector<bool> a) const
{
	for (int i = 0; i < a.size(); i++)
		if (a[i]) return false;
	return true;
}

int Qfloat::normalizeSignificant( vector<bool> &a)
{
	while (a.size() > NUM_BIT_SIGNI + 2) a.erase(a.begin());
	int res = 0;
	//Overflow
	if (a[0]) {
		a = shiftSignificantRight(a, 1);
		res++;
		a.erase(a.begin());
	}
	else
	{
		a.erase(a.begin());
		while (!a[0]) {
			a = shiftSignificantLeft(a, 1);
			res--;
		}
	}
	a.erase(a.begin());
	return res;
}

vector<bool> Qfloat::toBias(int exp)
{
	exp = exp + MAX_EXP;
	vector<bool> e(NUM_BIT_EXP);
	for (int i = 0; i < NUM_BIT_EXP; i++)
		e[NUM_BIT_EXP - 1 - i] = getBit(exp, i);

	return e;
}

Qfloat Qfloat::inf(bool sign)
{
	Qfloat res;
	res.arr[0] = (1 << NUM_BIT_EXP) - 1;
	if (!sign) res.setBitQNum(0, 0);
	return res;
}

//ScanDec
string multiplyString(string decString) {
	int carry = 0;
	int doubleDigit;
	char resultDigit;
	string result = "";
	int currentIndex = decString.length() - 1;
	
	while (currentIndex >= 0) {
		int doubleDigit = (decString[currentIndex] - '0') * 2 + carry;
		resultDigit = doubleDigit % 10 + '0';
		carry = doubleDigit / 10;
		if (currentIndex != 0)
			result = resultDigit + result;
		else {
			char firstDigit = carry + '0';
			result = resultDigit + result;
			result = firstDigit + result;
		}

		currentIndex--;
	}

	if (result[0] == '0')
		return result.substr(1);
	else
		return result;
}

bool isZero(string decString) {
	for (int i = 0; i < decString.length(); i++)
		if (decString[i] != '0')
			return false;

	return true;
}

bool isNegative(string source) {
	return source[0] == '-';
}

bool isUnnormal(string source) {
	if (!isNegative(source))
		return source[0] == '0';
	else
		return source[1] == '0';
}

string getDecFraction(string source) {
	int dotPosition = source.find_first_of('.');
	return source.substr(dotPosition + 1);
}

string getDecSigni(string source) {
	int dotPostion = source.find_first_of('.');
	if (isNegative(source))
		return source.substr(1, dotPostion - 1);
	else
		return source.substr(0, dotPostion);
}

string getBinFraction(string decFraction) {
	string result = "";
	string sourceString = decFraction;
	string multipliedString = decFraction;

	while (!isZero(sourceString) && result.length() < NUM_BIT_SIGNI) {
		multipliedString = multiplyString(sourceString);
		if (multipliedString.length() > sourceString.length()) {
			result += "1";
			sourceString = multipliedString.substr(1);
		}
		else {
			result += "0";
			sourceString = multipliedString;
		}
	}

	return result;
}

string getBinSigni(string decSigni) {
	QInt signi;
	signi.ScanQInt(decSigni, 10);
	vector<bool> sig = signi.convertToBin();
	string result = "";
	for (int i = 0; i < sig.size(); i++)
		result += sig[i] + '0';

	return result;
}

void Qfloat::setSignBit(string source) {
	if (source[0] == '-')
		this->setBitQNum(0, 1);
	else
		this->setBitQNum(0, 0);
}

void Qfloat::setExpBits(string source) {
	if (isUnnormal(source)) {
		for (int i = 1; i < NUM_BIT_EXP + 1; i++)
			this->setBitQNum(i, 0);
	}
	else {
		string decInt = getDecSigni(source);
		string binInt = getBinSigni(decInt);
		int decExp = binInt.length() - 1;
		int biasExp = decExp + BIAS;

		QInt x(biasExp);
		vector<bool> exp = x.convertToBin();
		int lengthDifference = NUM_BIT_EXP - exp.size();
		for (int i = 0; i < NUM_BIT_EXP;i++) {
			if (i < lengthDifference)
				this->setBitQNum(i + 1, 0);
			else
				this->setBitQNum(i + 1, exp[i - lengthDifference]);
		}
	}
}

void Qfloat::setSignificantBits(string source) {
	if (isUnnormal(source)) {
		string decFraction = getDecFraction(source);
		string binFraction = getBinFraction(decFraction);
		for (int i = 0; i < NUM_BIT_SIGNI; i++) {
			this->setBitQNum(i + 1 + NUM_BIT_EXP, binFraction[i] - '0');
		}
	}
	else {
		string decSignificant = getDecSigni(source);
		string binSignificant = getBinSigni(decSignificant);
		string decFraction = getDecFraction(source);
		string binFraction = getBinFraction(decFraction);
		binFraction = binSignificant.substr(1) + binFraction;
		binFraction = binFraction.substr(0, NUM_BIT_SIGNI);

		for (int i = 0; i < NUM_BIT_SIGNI; i++) {
			if (i >= binFraction.length())
				this->setBitQNum(i + 1 + NUM_BIT_EXP, 0);
			else
				this->setBitQNum(i + 1 + NUM_BIT_EXP, binFraction[i] - '0');
		}
	}
}

void Qfloat::scanDecString(string source) {
	this->setSignBit(source);
	this->setExpBits(source);
	this->setSignificantBits(source);
}






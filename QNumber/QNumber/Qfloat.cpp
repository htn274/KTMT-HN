#include "Qfloat.h"
#include "BitMani.h"

Qfloat::Qfloat()
{
	for (int i = 0; i < MAX_N; i++) arr[i] = 0;
}

Qfloat::Qfloat(vector<bool> a)
{
	for (int i = 0; i < a.size(); i++)
		this->setBitQNum(MAX_N * NUM_OF_BIT - i - 1, a[i]);
}

// Hàm scan tổng quát với hai hệ cơ số là nhị phân và thập phân
void Qfloat::ScanQfloat(string source, int base)
{
	if (base == 2) scanBinString(source);
	else scanDecString(source);
}

// Đọc vào một chuỗi nhị phân và lưu giá trị
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
// Hàm có tác dụng nhân một giá trị thập phân kiểu chuỗi với 2
// Kết quả trả về là giá trị thập phân kiểu chuỗi kí tự sau khi nhân với 2
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

// Kiểm trả xem giá trị mà chuỗi biểu diễn có phải là 0 hay không
bool isZero(string decString) {
	for (int i = 0; i < decString.length(); i++)
		if (decString[i] != '0')
			return false;

	return true;
}

// Kiểm tra số âm
bool isNegative(string source) {
	return source[0] == '-';
}


// Lấy phần sau dấu "." của chuỗi dưới dạng thập phân
string getDecFraction(string source) {
	int dotPosition = source.find_first_of('.');
	return source.substr(dotPosition + 1);
}

// Lấy phần trước dấu "." của chuỗi dưới dạng thập phân
// Nếu chuỗi biểu diễn số âm thì không lấy dấu "-"
string getDecSigni(string source) {
	int dotPostion = source.find_first_of('.');
	if (isNegative(source))
		return source.substr(1, dotPostion - 1);
	else
		return source.substr(0, dotPostion);
}

// Chuyển phần sau dấu "." thành một chuỗi nhị phân
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

// Chuyển phần trước dấu "." thành chuỗi nhị phân
string getBinSigni(string decSigni) {
	QInt signi;
	signi.ScanQInt(decSigni, 10);
	vector<bool> sig = signi.convertToBin();
	string result = "";
	for (int i = 0; i < sig.size(); i++)
		result += sig[i] + '0';

	return result;
}

// Set bit dấu, nếu âm thì set bit dấu thành 1, ngược lại thành 0
void Qfloat::setSignBit(string source) {
	if (source[0] == '-')
		this->setBitQNum(BIT_LENGTH - 1, 1);
	else
		this->setBitQNum(BIT_LENGTH - 1, 0);
}

// Set các bit của phần mũ
void Qfloat::setExpBits(string source) {
		string decInt = getDecSigni(source);
		string binInt = getBinSigni(decInt);
		int decExp = binInt.length() - 1;
		int biasExp = decExp + BIAS;

		QInt x(biasExp);
		vector<bool> exp = x.convertToBin();
		int length = exp.size();
		
		for (int i = 0; i < NUM_BIT_EXP; i++) {
			if (i >= length)
				this->setBitQNum(i + NUM_BIT_SIGNI, 0);
			else {
				this->setBitQNum(i + NUM_BIT_SIGNI, exp[length - i - 1]);
			}
		}
}

// Set các bit phần trị
void Qfloat::setSignificantBits(string source) {
		string decSignificant = getDecSigni(source);
		string binSignificant = getBinSigni(decSignificant);
		string decFraction = getDecFraction(source);
		string binFraction = getBinFraction(decFraction);
		binFraction = binSignificant.substr(1) + binFraction;
		binFraction = binFraction.substr(0, NUM_BIT_SIGNI);

		for (int i = NUM_BIT_SIGNI - 1; i >= 0; i--) {
			if (NUM_BIT_SIGNI - 1 - i >= binFraction.length())
				this->setBitQNum(i, 0);
			else
				this->setBitQNum(i, binFraction[NUM_BIT_SIGNI - 1 - i] - '0');
		}
}

// Hàm scan tổng quát, bao gồm các thao tác set bit cho từng phần
void Qfloat::scanDecString(string source) {
	this->setSignBit(source);
	this->setExpBits(source);
	this->setSignificantBits(source);
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

void Qfloat::printBin() {
	for (int i = BIT_LENGTH - 1; i >= 0; i--)
	{
		cout << this->getBitQNum(i);
		if (i == BIT_LENGTH - 1)
			cout << " ";
		if (i == BIT_LENGTH - 1 - 15)
			cout << " ";
	}
}

void Qfloat::printDec() {
	string decValue = this->ToDec();
	cout << decValue;
}

void Qfloat::PrintQfloat(int base) {
	if (base == 2)
		this->printBin();
	else
		this->printDec();

}

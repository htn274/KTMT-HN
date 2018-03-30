#include "QInt.h"

QInt::QInt()
{

}
QInt::QInt(unsigned int x)
{
	arr[MAX_N-1] = x;
}
QInt::QInt(vector<bool> x)
{
	for (int i = 0; i < x.size(); i++)
		this->setBitQNum(i, x[x.size() - i - 1]);
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

QInt QInt::operator <<(int index) const
{
	if (index <= 0) return *this;
	else {
		QInt result;
		result.setBitQNum(BIT_LENGTH - 1, (*this).getBitQNum(BIT_LENGTH - 1));
		for (int i = BIT_LENGTH - 2; i >= index; i--)
			result.setBitQNum(i, (*this).getBitQNum(i - index));
		return result;
	}
}
QInt QInt::operator >>(int index) const
{
	if (index <= 0) return *this;
	else {
		QInt result;
		bool msb = (*this).getBitQNum(BIT_LENGTH - 1);
		for (int i = 0; i < BIT_LENGTH - 1 - index; i++)
			result.setBitQNum(i, (*this).getBitQNum(i + index));
		for (int i = BIT_LENGTH - 1 - index; i < BIT_LENGTH; i++)
			result.setBitQNum(i, msb);
		return result;
	}
}

//*************************************
// Multiply sub-functions
bool QInt::IsZero() const
{
	for (int i = 0; i < MAX_N; i++)
		if (arr[i] != 0)
			return false;
	return true;
}

QInt QInt::ShiftRightLogical(int index) const
{
	if (index <= 0) return *this;
	else {
		QInt result;
		for (int i = 0; i < BIT_LENGTH - index; i++)
			result.setBitQNum(i, (*this).getBitQNum(i + index));
		return result;
	}
}
QInt QInt::ShiftLeftLogical(int index) const
{
	if (index <= 0) return *this;
	else {
		QInt result;
		for (int i = index; i < BIT_LENGTH; i++)
			result.setBitQNum(i, (*this).getBitQNum(i - index));
		return result;
	}
}
bool QInt::IsNegative() const
{
	return (*this).getBitQNum(BIT_LENGTH - 1);
}


QInt QInt::operator * (const QInt& a) const
{
	QInt result;
	QInt at = a;
	bool bit0, bit1;//2 bit kề nhau trong dãy bit của *this
	bit0 = 0;
	bit1 = (*this).getBitQNum(0);

	for (int i = 0; i < BIT_LENGTH; i++) {
		if (bit1 == 1 && bit0 == 0)
			result = result - at;
		else if (bit1 == 0 && bit0 == 1)
			result = result + at;

		at = at.ShiftLeftLogical(1);
		bit0 = bit1;
		bit1 = (*this).getBitQNum(i + 1);
	}
	return result;
}
QInt QInt::Divide(const QInt& dvs, QInt& rmd) const
{
	QInt divisor, dividend;
	bool negate = false;
	if ((*this).IsNegative()) {
		dividend = -(*this);
		negate = !negate;
	}
	else
		dividend = *this;

	if (dvs.IsNegative()) {
		divisor = -dvs;
		negate = !negate;
	}
	else
		divisor = dvs;

	QInt result, remainder, shift;
	char ch;
	for (int i = BIT_LENGTH - 1; i >= 0; i--) {
		shift = divisor << i;
		if (!shift.IsZero()){
			remainder = dividend - shift;
			if (!remainder.IsNegative()) {
				dividend = remainder;
				result.setBitQNum(i, 1);
			}
		}
	}
	rmd = dividend;
	if (!negate)
		return result;
	else
		return -result;
}
QInt QInt::operator / (const QInt& a) const
{
	QInt rmd;
	return (*this).Divide(a, rmd);
}

// AND OR XOR NOT
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


bool QInt::isZero()
{
	for (int i = MAX_N - 1; i > 0; i--)
		if (this->arr[i] != 0) return false;
	return (arr[0] == 1 || arr[0] == (1 << NUM_OF_BIT) - 1);
}

vector<bool> QInt::toSignedNumber(bool &sign)
{
	if (this->getBitQNum(NUM_OF_BIT * MAX_N - 1)) {
		(*this) = -(*this);
		sign = 1;
	}
	vector<bool> res;
	for (int i = 0; i < NUM_OF_BIT * MAX_N; i++)
		res.insert(res.begin(), this->getBitQNum(i));
	return res;
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

bool checkNegativeDecString(string source) {
	if (source[0] == '-')
		return true;
	else
		return false;
}

vector<bool> generateBinaryArrayFromPositiveDecString(string source) {
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

vector<bool> generateBinaryArrayFromRandomDecString(string source) {
	vector<bool> result;
	if (!checkNegativeDecString(source))
		result = generateBinaryArrayFromPositiveDecString(source);
	else {
		string positiveString = source.substr(1);
		result = generateBinaryArrayFromPositiveDecString(positiveString);
	}
	return result;
}

//********************************************************
// Scan Hex string sub-functions

int convertHexCharacterToDecNumber(char hexChar) {
	if (hexChar >= '0' && hexChar <= '9')
		return hexChar - '0';
	else if (hexChar >= 'a' && hexChar <= 'f')
		return hexChar - 'a' + 10;
	else
		return hexChar - 'A' + 10;
}

string convertDecNumberToBinString(int decNum) {
	string result = "";
	char remainderChar;
	int remainderNum = 0;

	while (decNum != 0) {
		remainderNum = decNum % 2;
		remainderChar = remainderNum + '0';
		decNum /= 2;
		result = remainderChar + result;
	}

	return result;
}

string standardizeBinString(string source) {
	if (source.length() == 4)
		return source;
	else {
		string standadizedString = source;
		while (standadizedString.length() < 4) {
			standadizedString = "0" + standadizedString;
		}

		return standadizedString;
	}
}

//********************************************************
// Scan functions 

void QInt::scanDec(string source) {
	QInt result;
	vector<bool> binaryArray = generateBinaryArrayFromRandomDecString(source);
	for (int i = 0; i < binaryArray.size(); i++) {
		result.setBitQNum(i, binaryArray[i]);
	}

	if (checkNegativeDecString(source)) {
		QInt temp(1);
		for (int i = 0; i < NUM_OF_BIT * MAX_N; i++)
			result.toogleBitQNum(i);
		result = result + temp;
	}

	*this = result;
}

void QInt::scanBin(string source) {
	QInt result;
	int currentPosition = source.length() - 1;
	while (currentPosition >= 0) {
		if (source[currentPosition] == '1')
			result.setBitQNum(source.length() - 1 - currentPosition, true);
		else
			result.setBitQNum(source.length() - 1 - currentPosition, false);
		currentPosition--;
	}
	*this = result;
}

void QInt::scanHex(string source) {
	string resultBinString = "";
	int currentPosition = source.length() -1;
	
	while (currentPosition >= 0) {
		int decNumber = convertHexCharacterToDecNumber(source[currentPosition]);
		string tempBinString = convertDecNumberToBinString(decNumber);
		string standardizedSmallBinString = standardizeBinString(tempBinString);
		resultBinString = standardizedSmallBinString + resultBinString;
		currentPosition--;
	}

	this->scanBin(resultBinString);
}

void QInt::ScanQInt(string source, int sourceBase) {
	if (sourceBase == 10) {
		this->scanDec(source);
	}
	else if (sourceBase == 2) {
		this->scanBin(source);
	}
	else if (sourceBase == 16) {
		this->scanHex(source);
	}
}

//********************************************************
// Print Bin and Hex sub-functions

int getTheFirst1BitIndex(QInt x) {
	int index = MAX_N * NUM_OF_BIT - 1;
	
	while (x.getBitQNum(index) == 0 && index != 0) {
		index--;
	}

	return index;
}

vector<bool> QInt::convertToBin() {
	vector<bool> result;
	int index = getTheFirst1BitIndex(*this);
	while (index >= 0) {
		bool bit = this->getBitQNum(index);
		result.push_back(bit);
		index--;
	}
	
	return result;
}

char convertDecNumberToHexNumber(int decNum) {
	if (decNum >= 0 && decNum <= 9)
		return decNum + '0';
	else
		return decNum - 10 + 'A';
}

vector<bool> getTheFirst4BitsAtIndex(vector<bool> source, int &index) {
	vector<bool> result;
	for (int i = index; i < index + 4; i++) {
		if (i >= source.size())
			result.push_back(0);
		else
			result.push_back(source[i]);
	}
	index += 4;
	return result;
}

int convertFrom4BitsToDec(vector<bool> source) {
	int result = 0;
	for (int i = 0; i < source.size(); i++)
		result += source[i] * pow(2, i);

	return result;
}

vector<bool> revertBinArray(vector<bool> source){
	vector<bool> result;
	for (int i = source.size() - 1; i >= 0; i--) {
		result.push_back(source[i]);
	}
	return result;
}

string QInt::convertToHex() {
	
	vector<bool> wholeBitArray = this->convertToBin();
	wholeBitArray = revertBinArray(wholeBitArray);
	int currentIndex = 0;
	string result = "";

	while (currentIndex < wholeBitArray.size()) {
		int decNum;
		vector<bool> smallBitArray = getTheFirst4BitsAtIndex(wholeBitArray, currentIndex);
		decNum = convertFrom4BitsToDec(smallBitArray);
		char hexDigit = convertDecNumberToHexNumber(decNum);
		result = hexDigit + result;
	}

	return result;
}

string QInt::convertToDec() const
{
	if ((*this).IsZero()) {
		string result = "0";
		return result;
	}
	string result = "";
	QInt temp;
	if ((*this).IsNegative())
		temp = -(*this);
	else
		temp = *this;

	QInt base(10), q, rmd;
	int index = 0;

	int count = 0;
	char digit;
	while (!temp.IsZero()) {
		temp = temp.Divide(base, rmd);
		digit = rmd.getBitQNum(0) + rmd.getBitQNum(1) * 2 +
			rmd.getBitQNum(2) * 4 + rmd.getBitQNum(3) * 8 +'0';
		result = digit + result;
	}
	return result;
}
//********************************************************
// Print functions
void printBin(QInt x) {
	vector<bool> binString = x.convertToBin();
	for (int i = 0; i < binString.size(); i++)
		cout << binString[i];
}

void printHex(QInt x) {
	string hexString = x.convertToHex();
	cout << hexString;
}

void printDec(QInt x) {
	string decString = x.convertToDec();
	cout << decString;
}

void QInt::PrintQInt(int base) {
	if (base == 2)
		printBin(*this);
	else if (base == 16)
		printHex(*this);
	else if (base == 10)
		printDec(*this);
}


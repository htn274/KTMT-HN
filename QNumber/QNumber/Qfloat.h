#include "QInt.h"
#include <string>
#include <vector>

using namespace std;

#define NUM_BIT_EXP		15
#define NUM_BIT_SIGNI	112
#define BIT_SIGN		127
#define MAX_EXP			(1 << (NUM_BIT_EXP - 1)) - 1
#define MIN_EXP			- (1 << (NUM_BIT_EXP - 1)) + 2
#define BIAS			16383

class Qfloat : public QNum{
//Cấu trúc: 1 bit dấu, 15 bit exp, 112 bits significant
private:
	//Một số hàm chức năng 
	vector<bool> shiftSignificantRight(vector<bool> a, int x);
	vector<bool> shiftSignificantLeft(vector<bool> a, int x);
	vector<bool> addSignificant(vector<bool> x1, vector<bool> x2, bool sign1, bool sign2, bool &sign);
	QInt convertToQInt(vector<bool> x1, int sign);
	bool isZero(vector<bool> a) const;
	int normalizeSignificant(vector<bool> &a);
	vector<bool> toBias(int exp);
	Qfloat inf(bool sign);
	void setSignBit(string source);
	void setExpBits(string source);
	void setSignificantBits(string source);
public:
	Qfloat();
	Qfloat(vector<bool>);

	void ScanQfloat(string source, int base);
	void PrintQfloat();

	//Input là một chuỗi dưới dạng cơ số 2, hàm có tác dụng chuyển chuỗi input thành Qfloat
	void scanBinString(string source); 
	//Input là một chuỗi dạng cơ số 10, hàm có tác dụng chuyển chuỗi input thành Qfloat
	void scanDecString(string source);

	bool * DecToBin(Qfloat x);
	Qfloat BinToDec(bool *bit);
	Qfloat& operator = (const Qfloat &a);
	Qfloat operator + (const Qfloat &a);
	Qfloat operator - (const Qfloat &a);
	Qfloat operator * (const Qfloat &a);
	Qfloat operator / (const Qfloat &a);

	bool isEqualZero() const; //Kiểm tra số Qfloat = 0
	int getExpValue() const; //Lấy giá trị số mũ của QFloat
	vector<bool> getSignificant() const; // Lấy phần trị
	bool getSign() const; // Trả về dấu của số thực

};


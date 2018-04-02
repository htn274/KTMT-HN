#include "QInt.h"
#include <string>
#include <vector>

using namespace std;

#define NUM_BIT_EXP		15
#define NUM_BIT_SIGNI	112
#define BIT_SIGN		127
#define MAX_EXP			((1 << (NUM_BIT_EXP - 1)) - 1)
#define MIN_EXP			- (1 << (NUM_BIT_EXP - 1)) + 2
#define BIAS			16383

class Qfloat : public QNum{
//Cấu trúc: 1 bit dấu, 15 bit exp, 112 bits significant
private:
	//Một số hàm chức năng 
	//Dịch chuyển phần trị sang phải dấu chấm
	vector<bool> shiftSignificantRight(vector<bool> a, int x);
	//Dịch phần trị sang trái dấu chấm
	vector<bool> shiftSignificantLeft(vector<bool> a, int x);
	//Cộng phần trị 
	vector<bool> addSignificant(vector<bool> x1, vector<bool> x2, bool sign1, bool sign2, bool &sign);
	//Chuyển phần trị sang QInt
	QInt convertToQInt(vector<bool> x1, int sign);
	//Kiểm tra bằng 0 
	bool isZero(vector<bool> a) const;
	// Kiểm tra số vô cực
	bool isInf();
	// Kiểm tra số báo lỗi
	bool isNaN();
	//Chuẩn hóa phần trị 
	int normalizeSignificant(vector<bool> &a);
	//Chuyển số mũ sang bias
	vector<bool> toBias(int exp);
	//Lấy số dạng vô cực
	Qfloat inf(bool sign);

	void setSignBit(string source);
	void setExpBits(string source);
	void setSignificantBits(string source);
	//In Qfloat dưới hệ 2 
	void printBin();
	//In Qfloat dưới hệ 10 
	void printDec();
public:
	Qfloat();
	Qfloat(vector<bool>);

	//Nhập một chuỗi dưới dạng 1 hệ cơ số bất kỳ vào Qfloat
	void ScanQfloat(string source, int base);
	// In Qfloat dưới 1 hệ cơ số bất kỳ 
	void PrintQfloat(int base);

	//Input là một chuỗi dưới dạng cơ số 2, hàm có tác dụng chuyển chuỗi input thành Qfloat
	void scanBinString(string source); 
	//Input là một chuỗi dạng cơ số 10, hàm có tác dụng chuyển chuỗi input thành Qfloat
	void scanDecString(string source);

	//Phép toán gán 
	Qfloat& operator = (const Qfloat &a);
	//Phép cộng 
	Qfloat operator + (const Qfloat &a);
	//Phép trừ
	Qfloat operator - (const Qfloat &a);
	//Phép nhân
	Qfloat operator * (const Qfloat &a);
	Qfloat operator / (const Qfloat &a);

	bool isEqualZero() const; //Kiểm tra số Qfloat = 0
	int getExpValue() const; //Lấy giá trị số mũ của QFloat
	// Lấy các bit phần trị (bit bậc nhỏ có chỉ số nhỏ, bit bậc lớn chỉ số lớn)
	vector<bool> getSignificant() const; 
	bool getSign() const; // Trả về dấu của số thực
	vector<bool> Qfloat::getSignificantReverse() const;


	// Đưa về dạng dấu chấm tĩnh, lưu phần nguyên và phần phân vào integer và decimal
	void Deformalize(vector<bool>& integer, vector<bool>& decimal) const;
	//Chuyển Qfloat về số thập phân tĩnh
	string ToDec() const;
	vector<bool> ToBin() const;
};


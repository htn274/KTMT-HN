#include "QNum.h"

class Qfloat : public QNum{
public:
	void ScanQfloat();
	void PrintQfloat();

	bool * DecToBin(Qfloat x);
	Qfloat BinToDec(bool *bit);

	Qfloat operator + (const Qfloat a);
	Qfloat operator - (const Qfloat a);
	Qfloat operator * (const Qfloat a);
	Qfloat operator / (const Qfloat a);
};
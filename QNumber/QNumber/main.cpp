#include "QInt.h"
#include <iostream>

using namespace std;

int main() {
	QInt x, y, z;
	x.setBitQNum(127, 1);
	x.setBitQNum(3, 1);
	x.setBitQNum(4, 1);
	x.setBitQNum(0, 1);
	x.printTest();

	y.setBitQNum(3, 1);
	y.setBitQNum(0, 1);
	y.setBitQNum(64, 1);
	y.printTest();

	z = x & y;
	z.printTest();

	z = x | y;
	z.printTest();

	z = ~z;
	z.printTest();
	system("pause");
	return 0;
}
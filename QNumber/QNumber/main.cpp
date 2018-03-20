#include "Qfloat.h"
#include <iostream>

using namespace std;

int main() {
	Qfloat x, y, z;
	x.ScanQfloat("01000000000000111101111", 2);
	y.ScanQfloat("11000000000000111010100", 2);
	z = x + y;
	z.printTest();
	system("pause");
	return 0;
}
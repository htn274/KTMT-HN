#include "QNum.h"
#include <iostream>

using namespace std;

int main() {
	QNum x;
	x.printTest();
	x.setBitQNum(127, 1);
	x.setBitQNum(0, 1);
	x.setBitQNum(3, 1);
	x.setBitQNum(0, 0);
	x.printTest();
	system("pause");
	return 0;
}
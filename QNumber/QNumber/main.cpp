#include "QInt.h"
#include <iostream>

using namespace std;

int main() {
	QInt x(1);
	x.printTest();
	
	QInt y(2);
	y.printTest();
	
	QInt z = x + y;
	z.printTest();

	return 0;
}
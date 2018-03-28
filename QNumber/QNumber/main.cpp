#include "Qfloat.h"
#include <iostream>

using namespace std;


int main() {
	Qfloat x;
	string a = "-23.40625";
	x.scanDecString(a);
	x.printTest();
	return 0;
}
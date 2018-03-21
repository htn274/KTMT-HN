#include "Qfloat.h"
#include <iostream>

using namespace std;


int main() {
	Qfloat x;
	string a = "-0.0000000000000000000000000001";
	x.scanDecString(a);
	x.printTest();
	return 0;
}
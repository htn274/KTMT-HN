#include "CaculateQInt.h"
#include <iostream>

using namespace std;


int main() {
 //Test chương trình QInt
	mainCaculate("INPUT.TXT", "OUTPUT.TXT");
// Test chương trình Qfloat
	Qfloat x;
	string a = "-0.0000000000000000000000000001";
	x.scanDecString(a);
	x.printTest();
	return 0;
}
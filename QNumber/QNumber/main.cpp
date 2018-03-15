#include "QInt.h"

#include <iostream>

using namespace std;

int main() {

	string temp = "1166B";
	QInt x;
	x.ScanQInt(temp, 16);
	x.printTest();

	return 0;
}
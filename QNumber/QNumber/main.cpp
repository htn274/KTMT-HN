#include "QInt.h"
#include <iostream>

using namespace std;

int main() {

	string x = "-12";
	QInt a;
	a.ScanQInt(x, 10);
	a.PrintQInt(16);

	return 0;
}
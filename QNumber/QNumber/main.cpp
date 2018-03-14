#include "QInt.h"

#include <iostream>

using namespace std;

int main() {
	string a = "8793278316383117319";
	QInt temp;
	temp.ScanQInt(a, 2);
	temp.printTest();
	return 0;
}
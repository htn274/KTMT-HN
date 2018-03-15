#include "QInt.h"
#include <iostream>

using namespace std;

int main() {

	string temp = "24315";
	QInt x;
	x.ScanQInt(temp, 10);
	x.printTest();
	x.PrintQInt(2);
	cout << endl;
	x.PrintQInt(16);
	cout << endl;
	return 0;
}
#pragma once
#include "CaculateQInt.h"
#include "Qfloat.h"
#include <iostream>
#include "BoolVector.h"
using namespace std;

int main() {
	
	Qfloat a, b, c;
	a.scanDecString("123453453.34");
	b.scanDecString("833.32");
	c = a / b;
	string decc = c.ToDec();
	cout << decc << endl;
	return 0;
}
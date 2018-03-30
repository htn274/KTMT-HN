#pragma once
#include "CaculateQInt.h"
#include "Qfloat.h"
#include <iostream>

using namespace std;

int main() {
	Qfloat a, b,c;
	a.ScanQfloat("1.3", 10);
	b.ScanQfloat("14.5", 10);
	string ad = a.ToDec();
	cout << ad << endl;
	string bd = b.ToDec();
	cout << bd << endl;
	
	c = a*b;
	
	string cd = c.ToDec();
	cout << cd << endl;
	return 0;
}
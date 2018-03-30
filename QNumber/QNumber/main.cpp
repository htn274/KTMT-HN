#pragma once
#include "Calculator.h"
#include <iostream>
#include <conio.h>

using namespace std;

int main() {
	/*Qfloat x,z,a,b,p;
	x.scanDecString("12.2354");
	for (int i = 0; i < BIT_LENGTH; i++)
		z.setBitQNum(i, x.getBitQNum(BIT_LENGTH - 1 - i));
	Qfloat a, b,c;
	a.ScanQfloat("1.3", 10);
	b.ScanQfloat("14.5", 10);
	string ad = a.ToDec();
	cout << ad << endl;
	string bd = b.ToDec();
	cout << bd << endl;	
	c = a*b;

	a.scanDecString("32.1");
	for (int i = 0; i < BIT_LENGTH; i++)
		b.setBitQNum(i, a.getBitQNum(BIT_LENGTH - 1 - i));
	
	cout << b.getExpValue() << endl;
	b.printTest();

	p = z*b;
	p.printTest();
	string decp = p.ToDec();
	cout << decp << endl;
	*/
	//Test cho QInt
	//Test cho QFloat
	mainCaculate("","", 1);
	Qfloat x;
	x.ScanQfloat("1", 10);
	cout << x.isEqualZero();
	getch();
	return 0;
}

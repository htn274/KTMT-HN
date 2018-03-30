#pragma once
#include "CaculateQInt.h"
#include "Qfloat.h"
#include <iostream>
#include "Qfloat.h"
using namespace std;

int main() {


	Qfloat x,z,a,b,p;
	x.scanDecString("12.2354");
	for (int i = 0; i < BIT_LENGTH; i++)
		z.setBitQNum(i, x.getBitQNum(BIT_LENGTH - 1 - i));
	
	cout << z.getExpValue() << endl;
	z.printTest();
	string dec = z.ToDec();
	cout << dec << endl;
	
	a.scanDecString("32.1");
	for (int i = 0; i < BIT_LENGTH; i++)
		b.setBitQNum(i, a.getBitQNum(BIT_LENGTH - 1 - i));
	
	cout << b.getExpValue() << endl;
	b.printTest();

	p = z*b;
	p.printTest();
	string decp = p.ToDec();
	cout << decp << endl;

	Qfloat x;
	x.ScanQfloat("-23.40625", 10);
	x.PrintQfloat(2);

	return 0;
}
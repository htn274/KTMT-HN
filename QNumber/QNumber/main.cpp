#include "Qfloat.h"
#include <iostream>

using namespace std;

int main() {
	/*Qfloat x, y, z;
	x.ScanQfloat("100000000000000010101100", 2);
	y.ScanQfloat("000000000000000011101011", 2);
	vector<bool> signi = x.getSignificant();
	for (int i = 0; i < signi.size(); i++)
		cout << signi[i];
	cout << endl;
	QInt signi_Qint = x.convertToQInt(signi, x.getSign());
	signi_Qint.printTest();
	
	bool sign = x.getSign();
	vector<bool> signi2 = signi_Qint.toSignedNumber(sign);
	//cout << sign;
	for (int i = 0; i < signi2.size(); i++)
		cout << signi2[i];
	cout << endl;*/
	Qfloat x, y, z;
	x.ScanQfloat("101111111111111110101100", 2);
	vector<bool> integer, decimal;
	x.Deformalize(integer, decimal);
	cout << "I:";
	for (bool i : integer)
		cout << i;
	cout << endl;
	cout << "D:";
	for (bool i : decimal)
		cout << i;
	cout << endl;
	string dec = x.ToDec();
	cout << "Dec:" << endl<< dec << endl;
	return 0;
}
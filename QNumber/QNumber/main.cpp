#pragma once
#include "CaculateQInt.h"
#include "Qfloat.h"
#include <iostream>

using namespace std;


int main() {

	Qfloat x;
	x.ScanQfloat("0.8", 10);
	x.PrintQfloat(2);
	return 0;
}
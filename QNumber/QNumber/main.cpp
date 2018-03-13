#include "BitMani.h"
#include <iostream>

using namespace std;

int main() {
	int n;
	cin >> n;
	toogleBit(n, 1);
	int i = 0;
	while (i < 4) {
		cout << getBit(n, i);
		i++;
	}
	system("pause");
	return 0;
}
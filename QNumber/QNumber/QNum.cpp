#include "QNum.h"

QNum::QNum()
{
	for (int i = 0; i < MAX_N; i++)
		arr[i] = 0;
}

void QNum::printTest()
{
	for (int i = 0; i < MAX_N * NUM_OF_BIT; i++) {
		printf("%d", this->getBitQNum(i));
	}
	printf("\n");
}

bool QNum::getBitQNum(int index)
{
	int i = 3;
	while (index - NUM_OF_BIT >= 0) {
		index -= NUM_OF_BIT;
		i--;
	}

	return getBit(arr[i], index);
}

bool QNum::setBitQNum(int index, bool bit)
{
	if (index > NUM_OF_BIT * MAX_N || index < 0) return false;
	int i = 3;
	while (index - NUM_OF_BIT >= 0) {
		index -= NUM_OF_BIT;
		i--;
	}
	if (bit == 0) turnOffBit(arr[i], index);
	else turnOnBit(arr[i], index);
	return true;
}

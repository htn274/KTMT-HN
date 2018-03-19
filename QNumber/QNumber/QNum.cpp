#include "QNum.h"

QNum::QNum()
{
	for (int i = 0; i < MAX_N; i++)
		arr[i] = 0;
}

void QNum::Init(int index, int data)
{
	this->arr[index] = data;
}

void QNum::printTest()
{
	for (int i = MAX_N * NUM_OF_BIT - 1; i >= 0;  i--) {
		printf("%d", this->getBitQNum(i));
	}
	printf("\n");
}

bool QNum::getBitQNum(int index) const
{
	int i = MAX_N - 1;
	while (index - NUM_OF_BIT >= 0) {
		index -= NUM_OF_BIT;
		i--;
	}

	return getBit(arr[i], index);
}

bool QNum::setBitQNum(int index, bool bit)
{
	if (index > NUM_OF_BIT * MAX_N || index < 0) return false;
	int i = MAX_N - 1;
	while (index - NUM_OF_BIT >= 0) {
		index -= NUM_OF_BIT;
		i--;
	}
	if (bit == 0) turnOffBit(arr[i], index);
	else turnOnBit(arr[i], index);
	return true;
}
bool QNum::toogleBitQNum(int index)
{
	if (index > NUM_OF_BIT * MAX_N || index < 0) return false;
	int i = MAX_N - 1;
	while (index - NUM_OF_BIT >= 0) {
		index -= NUM_OF_BIT;
		i--;
	}
	toogleBit(arr[i], index);
	return true;
}

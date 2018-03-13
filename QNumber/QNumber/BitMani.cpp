#include "BitMani.h"

bool getBit(const int & x, int index)
{
	return (x >> index) & 1;
}

bool turnOnBit(int & x, int index)
{
	if (index > BIT_MAX || index < 0) return false;
	x = x | (1 << index);
	return true;
}

bool turnOffBit(int & x, int index)
{
	if (index > BIT_MAX || index < 0) return false;
	x = x & ~(1 << index);
	return true;
}

bool toogleBit(int & x, int index)
{
	if (index > BIT_MAX || index < 0) return false;
	x = x ^ (1 << index);
	return true;
}

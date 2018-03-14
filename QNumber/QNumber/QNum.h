#pragma once
#include "BitMani.h"
#include "stdio.h"

#define MAX_N		4

class QNum {
private: 
	int arr[MAX_N]; // 4 * 4 = 16 bytes = 128 bits
public:
	QNum();
	
	void printTest();
	//Lấy bit thứ index trong QNum
	bool getBitQNum(int index);
	//Gán bit thứ idex trong QNum có giá trị bit
	bool setBitQNum(int index, bool bit);
};
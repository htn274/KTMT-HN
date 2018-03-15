#pragma once
#include "BitMani.h"
#include "stdio.h"

#define MAX_N		4

class QNum {
protected: 
	int arr[MAX_N]; // 4 * 4 = 16 bytes = 128 bits
public:
	QNum();
	//Khởi tạo tại arr[index] = data
	void Init(int index, int data);
	//In ra màn hình từng bit để test
	void printTest();
	//Lấy bit thứ index trong QNum
	bool getBitQNum(int index) const;
	//Gán bit thứ index trong QNum có giá trị bit
	bool setBitQNum(int index, bool bit);
	//Đổi bit thứ index 1 sang 0 và ngược lại 
	bool toogleBitQNum(int index);
};
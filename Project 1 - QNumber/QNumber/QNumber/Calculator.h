#pragma once
#include "QInt.h"
#include "Qfloat.h"
using namespace std;

#define SPACE	' '
//Hàm cho nhập file input, và xuất output để xử lý 
//Có 2 chế độ mode = 0: Số nguyên (QInt), mode = 1: Số thực (QFloat)
void mainCaculate(char* file_input, char* file_output, bool mode);
//Cắt chuỗi nhập vào 
vector<string> cut_stringInput(string str_input);
//Xử lý QInt
void processQInt(vector<string> str_arr);
//Xử lý Qfloat
void processQfloat(vector<string> str_arr);
//Tính toán các phép tính cho QFloat
Qfloat CalculateOptFloat(Qfloat a, Qfloat, string opt);
//Tính toán các phép tính cho Qint
QInt CalculateOpt(QInt a, QInt b, string opt);
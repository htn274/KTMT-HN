#pragma once
#include "QNum.h"
#include "Qfloat.h"
#include "QInt.h"

void mainCaculate(char* file_input, char* file_output);
vector<string> cut_stringInput(string str_input);
void process(vector<string> str_arr);
QInt CaculateOpt(QNum* a, QNum* b, string opt);
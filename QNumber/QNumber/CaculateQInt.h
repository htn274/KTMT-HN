#pragma once
#include "QInt.h"

using namespace std;

#define SPACE	' '
void mainCaculate(char* file_input, char* file_output);
vector<string> cut_stringInput(string str_input);
void process(vector<string> str_arr);
QInt CaculateOpt(QInt a, QInt b, string opt);
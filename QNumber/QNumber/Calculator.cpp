#include "Calculator.h"

void mainCaculate(char*file_input, char* file_output, bool mode)
{
	FILE* fi = freopen(file_input, "r", stdin);
	FILE* fo = freopen(file_output, "w", stdout);
	string string_input;
	vector<string> string_arr;
	while (getline(cin, string_input)) {
		string_arr = cut_stringInput(string_input);
		if (mode) processQfloat(string_arr);
		else processQInt(string_arr);
	}
	fclose(fi);
	fclose(fo);
}

vector<string> cut_stringInput(string str_input)
{
	vector<string> str_arr;
	int i = 0;
	while (i < str_input.length()) {
		int j = i;
		while (j < str_input.length() && str_input[j] != SPACE) j++;
		string s = str_input.substr(i, j - i);
		str_arr.push_back(s);
		i = j + 1;
	}
	return str_arr;
}

void processQInt(vector<string> str_arr)
{
	if (str_arr.size() == 4) {
		int p = stoi(str_arr[0]);
		QInt s1, s2, s3;
		s1.ScanQInt(str_arr[1], p);
		//Phép shift
		if (str_arr[2] == "<<") {
			int numShift = stoi(str_arr[3]);
			s3 = s1 << numShift;
		}
		else if (str_arr[2] == ">>") {
			int numShift = stoi(str_arr[3]);
			s3 = s1 >> numShift;

		}
		else {
			s2.ScanQInt(str_arr[3], p);
			s3 = CalculateOpt(s1, s2, str_arr[2]);
		}
		s3.PrintQInt(p);
	}
	else if (str_arr.size() == 3) {
		int p1 = stoi(str_arr[0]);
		QInt s, res;
		s.ScanQInt(str_arr[2], p1);
		if (str_arr[1] == "~") {
			res = ~s;
			res.PrintQInt(p1);
		}
		else {
			int p2 = stoi(str_arr[1]);
			s.PrintQInt(p2);
		}
	}
	cout << endl;
}

void processQfloat(vector<string> str_arr)
{
	if (str_arr.size() == 4) {
		int p = stoi(str_arr[0]);
		Qfloat s1, s2, s3;
		s1.ScanQfloat(str_arr[1], p);
		s2.ScanQfloat(str_arr[3], p);
		s3 = CalculateOptFloat(s1, s2, str_arr[2]);
		s3.PrintQfloat(p);
	}
	else if (str_arr.size() == 3) {
		int p1 = stoi(str_arr[0]);
		int p2 = stoi(str_arr[1]);
		Qfloat x, res;
		x.ScanQfloat(str_arr[2], p1);
		x.PrintQfloat(p2);
	}
	cout << endl;
}

Qfloat CalculateOptFloat(Qfloat a, Qfloat b, string opt)
{
	switch (opt[0]) {
	case '+': return a + b;
	case '-': return a - b;
	case '*': return a * b;
	//case '/': return a / b;
	}
}

QInt CalculateOpt(QInt a, QInt b, string opt)
{
	switch (opt[0]) {
	case '+': return a + b;
	case '-': return a - b;
	case '*': return a * b;
	case '/': return a / b;
	case '&': return a & b;
	case '|': return a | b;
	case '^': return a ^ b;
	}
}


#include "BoolVector.h"
#include <iostream>

void PrintVector(const vector<bool>& a)
{
	for (bool i : a)
		cout << i;
	cout << endl;
}
vector<bool> StrToVectorBool(const string& a)
{
	vector<bool> result;
	for (int i = 0; i < a.length(); i++) {
		if (a[a.length() - 1 - i] == '1')
			result.push_back(1);
		else
			result.push_back(0);
	}
	return result;
}
bool getBitVector(const vector<bool>& a, int index)
{
	if (index < a.size())
		return a[index];
	else
		return 0;
}
vector<bool> AddBoolVector(const vector<bool>& a, const vector<bool>& b)
{
	vector<bool> result;
	result.reserve(a.size());
	result.reserve(b.size());
	bool carry = 0;
	int sumBit;
	for (int i = 0; i < a.size() || i < b.size(); i++) {
		sumBit = getBitVector(a, i) + getBitVector(b, i) + carry;
		result.push_back(sumBit & 1);
		carry = sumBit >> 1;
	}
	if (carry > 0)
		result.push_back(1);
	return result;
}
bool SubtractBoolVector(const vector<bool>& a, const vector<bool>& b,vector<bool>& result)
{
	if (a.size() < b.size())
		return false;
	result.clear();
	result.reserve(a.size());
	int carry=0;
	int subresult;
	for (int i = 0; i < a.size(); i++) {
		subresult = getBitVector(a, i) - carry - getBitVector(b, i);
		if (subresult < 0) {
			carry = 1;
			subresult += 2;
		}
		else
			carry = 0;
		result.push_back(subresult);
	}
	if (carry > 0)
		return false;
	else
		return true;
}
vector<bool> ShiftLeftLogicalVector(const vector<bool>& a, int index)
{
	if (index <= 0) return a;
	else {
		vector<bool> result(index, 0);
		result.insert(result.end(), a.begin(), a.end());
		return result;
	}
}
vector<bool> MultiplyBoolVector(const vector<bool>& a, const vector<bool>& b)
{
	vector<bool> result;
	vector<bool> mul = a;
	for (bool digit : b) {
		if (digit == 1)
			result = AddBoolVector(result, mul);
		mul = ShiftLeftLogicalVector(mul, 1);
	}
	return result;
}

vector<bool> DivideBoolVector(const vector<bool>& a, const vector<bool>& b, vector<bool>& rmd)
{
	vector<bool> divisor, dividend;
	dividend = a;
	divisor = b;

	vector<bool> result(a.size() - b.size() + 1, 0), shift, remainder;
	
	for (int i = a.size() - b.size(); i >= 0; i--) {
		shift = ShiftLeftLogicalVector(divisor, i);
		if (SubtractBoolVector(dividend, shift, remainder)) {
			dividend = remainder;
			result[i] = 1;
		}
	}
	rmd = dividend;
	if (result[result.size()-1]==0)
		result.pop_back();
	return result;
}
	
bool IsZero(const vector<bool>& a)
{
	for (bool digit : a)
		if (digit == 1)
			return false;
	return true;
}
void Reverse(vector<bool>& a)
{
	bool temp;
	for (int i = 0; i < a.size() / 2; i++) {
		temp = a[i];
		a[i] = a[a.size() - 1 - i];
		a[a.size() - 1 - i] = temp;
	}
}
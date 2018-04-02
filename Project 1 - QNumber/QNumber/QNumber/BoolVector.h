// Lớp các hàm xử lý số nguyên lớn không dấu, lưu bằng vector<bool> là dãy bit trong biểu diễn nhị phân
#include <vector>

using namespace std;

void PrintVector(const vector<bool>& a);
vector<bool> StrToVectorBool(const string& a);
bool getBitVector(const vector<bool>& a, int index);
vector<bool> AddBoolVector(const vector<bool>& a, const vector<bool>& b);
bool SubtractBoolVector(const vector<bool>& a, const vector<bool>& b, vector<bool>& result);
vector<bool> ShiftLeftLogicalVector(const vector<bool>& a, int index);
vector<bool> MultiplyBoolVector(const vector<bool>& a, const vector<bool>& b);
vector<bool> DivideBoolVector(const vector<bool>& a, const vector<bool>& b, vector<bool>& rmd);
bool IsZero(const vector<bool>& a);
void Reverse(vector<bool>& a);

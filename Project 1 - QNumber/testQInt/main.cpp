#include <iostream>
#include <stdlib.h>
#include <time.h>
#include <string>
#include <sstream>
#include <stdio.h>

using namespace std;

namespace patch
{
    template < typename T > std::string to_string( const T& n )
    {
        std::ostringstream stm ;
        stm << n ;
        return stm.str();
    }
}

const int MAX_LEN = 100;
const int NUM_BASE = 3;
const int NUM_OPT = 8;

#define     OPERATOR    0
#define     BASE        1
#define     SHIFT       2
int maxLen(int p){
    if (p == 2) return 128;
    if (p == 16) return 32;
    if (p == 10) return 38;
}


int chonThaoTac(){
    // Nếu là 0: thao tác tính
    //Nếu là 1: thao tác chuyển đổi hệ
    //Nếu là 2: thao tác shift
    int res = rand() % 3;
    return res;
}

int chonHeCoSo(int p){
    int base[NUM_BASE] = {2, 10, 16};
    int i = rand() % NUM_BASE;
    if (base[i] == p) i++;
    if (i == NUM_BASE) i = 0;
    return base[i];
}

string hexa(int n){
    if (n == 10) return "A";
    if (n == 11) return "B";
    if (n == 12) return "C";
    if (n == 13) return "D";
    if (n == 14) return "E";
    if (n == 15) return "F";
}

string sinhNumber(int he){
    int len = (rand() % maxLen(he)) + 1;
    string num = "", cs_string;
    for (int i = 0; i < len; i++){
        int cs = rand() % he; // Sinh từng chữ số
        if (he == 16 && cs >= 10){
            cs_string = hexa(cs);
        } else cs_string = patch::to_string(cs);
        num = num + cs_string;
    }

    if (he == 10) {
        int sign = rand() % 2;
        if (sign == 1) num.insert(0, "-");
    }
    return num;
}

int main()
{
    FILE * fp = freopen("C:/Users/Administrator/Documents/GitHub/KTMT-HN-QInt/QNumber/QNumber/INPUT03.TXT", "w", stdout);
    int nTest = 20;
    int p1, p2;
    string num1, num2;
    char opt_arr[NUM_OPT] = {'~', '+', '-' ,'*', '/' , '&', '|', '^'};
    string opt_shift_arr[2] = {"<<", ">>"};
    srand(time(NULL));
    for (int i = 0; i < nTest; i++){
        //int thaoTac = chonThaoTac();
        int thaoTac = SHIFT;
        if (thaoTac == BASE){
            p1 = chonHeCoSo(0);
            p2 = chonHeCoSo(p1);
            num1 = sinhNumber(p1);
            cout << p1 << " " << p2 << " " << num1 << endl;
        }
        else if (thaoTac == OPERATOR){
            p1 = chonHeCoSo(0);
            int opt = rand() % NUM_OPT;
            if (opt == 0){
                num1 = sinhNumber(p1);
                cout << p1 << " " << opt_arr[opt] << " "<< num1 << endl;
            } else {
                num1 = sinhNumber(p1);
                num2 = sinhNumber(p1);
                cout << p1 << " " << num1 << " " << opt_arr[opt] << " " << num2 << endl;
            }
        }
        else if (thaoTac == SHIFT){
            p1 = chonHeCoSo(0);
            int opt_shift = rand() % 2;
            int numShift = rand() % (maxLen(2) + 1);
            num1 = sinhNumber(p1);
            cout << p1 << " " << num1 << " " << opt_shift_arr[opt_shift] << " " << numShift << endl;
        }
    }
    fclose(fp);
    return 0;
}


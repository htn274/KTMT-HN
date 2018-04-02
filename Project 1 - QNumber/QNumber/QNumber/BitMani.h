#pragma once
#define NUM_OF_BIT 32

//Hàm getBit trả về bit thứ index của x 
bool getBit(const int& x, int index);
//Hàm turnOnBit sẽ bật bit thứ index của x lên 1 khi gọi hàm
//Bật thành công thì trả về TRUE, ngược lại FALSE
bool turnOnBit(int& x, int index);
//Hàm tắt bit thứ index của x
bool turnOffBit(int&x, int index);
//Hàm bật/tắt bit thứ index của x, tức là nếu index đang là 1 thì thành 0 và ngược lại
bool toogleBit(int&x, int index);
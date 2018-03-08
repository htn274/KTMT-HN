### KTMT-HN-QInt
## 1. Số nguyên lớn
Thiết kế kiểu dữ liệu biểu diễn số nguyên lớn có dấu (tạm gọi là QInt) có độ lớn 16 byte. Định nghĩa các hàm sau:
# a. Hàm Nhập: void ScanQInt (QInt &x). Trong đó:
- Tham số QInt &x: vùng nhớ biến nhập
- Kiểm tra xử lý các trường hợp nhập không hợp lệ.
# b. Hàm xuất: void PrintQInt(QInt x) Trong đó:
- Tham sốQInt x: chứa giá trị biến xuất
# c. Hàm chuyển đổi số QInt từ hệ thập phân sang hệ nhị phân bool * DecToBin (QInt x) trong đó:
- Tham số QInt &x: giá trị QInt cần chuyển đổi
- Trả về dãy bit kết quả

# d. Hàm chuyển đổi số QInt từ hệ nhị phân sang hệ thập phân
QInt BinToDec(bool *bit) trong đó bool *bit là dãy bit cần chuyển đổi. Trả về kết quả QInt.
# e. Hàm chuyển đổi số QInt từ hệ nhị phân sang hệ thập lục phân
char *BinToHex(bool *bit)
# f. Hàm chuyển đổi số QInt từ hệ thập phân sang hệ thập lục phân
char *DecToHex(QInt x)
# g. Các operator tính toán sau (Mỗi kiểu dữ liệu viết riêng 1 hàm)
- QInt operator + (QtInt a, QInt b)
- QInt operator - (QInt a, QInt b)
- QInt operator * (QInt a, QInt b)
- QInt operator / (QInt a, QInt b)
## 2. Số chấm động chính xác cao
Thiết kế kiểu dữ liệu biểu diễn số chấm động có độ chính xác Quadruple-precision (độ chính xác gấp 4 lần) độ lớn 128 bit có cấu trúc biểu diễn như sau:
Hãy định nghĩa các hàm sau:
# a. Hàm Nhập: void ScanQfloat (Qfloat &x). Trong đó:
- Tham số Qfloat &x: vùng nhớ biến nhập Qfloat.
# b. Hàm xuất: void PrintQfloat(Qfloat x) Trong đó:
- Tham số Qfloat x: giá trị biến xuất kiểu Qfloat.
# c. Hàm chuyển đổi số Qfloat từ hệ thập phân sang hệ nhị phân
bool * DecToBin (Qfloat x)
# d. Hàm chuyển đổi số Qfloat từ hệ nhị phân sang hệ thập phân
Qfloat BinToDec(bool *bit)
# e. Các operator tính toán sau
- Qfloat operator + (Qfloat a, Qfloat b)
- Qfloat operator - (Qfloat a, Qfloat b)
- Qfloat operator * (Qfloat a, Qfloat b) (yêu cầu nâng cao)
- Qfloat operator / (Qfloat a, Qfloat b) (yêu cầu nâng cao)
## 3. Chương trình minh họa
Viết chương trình calculator đơn giản gồm các chức năng sau:
- Chuyển đổi giá trị qua lại giữa các hệ 2,10,16 (số chấm động không chuyển đổi qua hệ 16)
- Tính toán cộng, trừ , nhân, chia giữa 2 số bất kỳ.
Sinh viên có thể tham khảo giao diện chương trình calculator có sẵn trên máy tính nếu viết chương
trình dạng winform, hoặc cần phải thể hiện các chức năng trực quan, hợp lý nếu viết ở dạng win
console.
## 4. Báo cáo
- Đối với source code: trước mỗi hàm, sinh viên comment mô tả rõ chức năng của hàm.
- Viết báo cáo (file word) với nội dung chính gồm các phần sau:
-- Đánh giá mức độ hoàn thành (%) ứng với từng yêu cầu và trên toàn bộ project
-- Cho biết phạm vi biểu diễn của các kiễu dữ liệu đã thiết kế
-- Chụp hình giao diện chương trình ứng với các testcase
-- Các nguồn tài liệu tham khảo

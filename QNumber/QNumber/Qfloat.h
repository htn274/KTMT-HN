class Qfloat {
private:
	int arr[4];
public:
	void ScanQfloat();
	void PrintQfloat();

	bool * DecToBin(Qfloat x);
	Qfloat BinToDec(bool *bit);

	Qfloat operator + (Qfloat a);
	Qfloat operator - (Qfloat a);
	Qfloat operator * (Qfloat a);
	Qfloat operator / (Qfloat a);
};
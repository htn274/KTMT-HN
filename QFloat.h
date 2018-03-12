class Qfloat {
private:
	int arr[4];
public:
	void ScanQfloat(Qfloat &x);
	void PrintQfloat(Qfloat x);

	bool * DecToBin(Qfloat x);
	Qfloat BinToDec(bool *bit);

	Qfloat operator + (Qfloat a);
	Qfloat operator - (Qfloat a);
	Qfloat operator * (Qfloat a); 
	Qfloat operator / (Qfloat a); 
};
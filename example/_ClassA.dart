import '_ClassB.dart';

class A
{
	final B b = B();


	showLog()
	{
		b.showLog();
	}

	void showDeepLogA()
	{
		b.showDeepLogB();
	}
}

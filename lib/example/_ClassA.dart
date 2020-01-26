import '_ClassB.dart';

class A
{
	final B b = B();


	showLog()
	{
		b.showLog();
	}

	void showDeepLog()
	{
		b.showDeepLog();
	}
}

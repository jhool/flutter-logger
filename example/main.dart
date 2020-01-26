import 'package:jlogger/jlogger.dart';

import '_ClassA.dart';


void main()
{
	JLogger.log('This is Simple Readable And Easly Traceable Log');

	A a = A();

	a.showLog();

	a.showDeepLogA();
}

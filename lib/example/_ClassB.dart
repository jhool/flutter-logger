import 'package:jlogger/jlogger.dart';

import '_ClassC.dart';

class B
{
	final C c = C();

	showLog()
	{
		JLogger.log('Simple Log With Label', label: 'LabeledLog');
	}

	void showDeepLog()
	{
		c.showDeepLog();
	}
}
import 'package:jlogger/jlogger.dart';

class C
{
	showDeepLog()
	{
		JLogger.log('This is Log has longer trace depth', depth: 3, label: 'TraceDepth');
	}
}
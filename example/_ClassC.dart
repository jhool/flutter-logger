import 'package:jlogger/jlogger.dart';

class C
{
	showDeepLogC()
	{
		JLogger.log('This is Log has longer trace depth', depth: 3, label: 'TraceDepth');
	}
}
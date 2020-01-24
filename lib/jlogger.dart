import 'dart:math';

class ConsoleLogger
{
	static final stackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');
	static final ConsoleLogger I = ConsoleLogger._internal();

	factory ConsoleLogger() => I;

	int debugMethodCount = 1;
	int errorMethodCount = 8;

	CLogPrinter logPrinter;

	ConsoleLogger._internal()
	{
		logPrinter = CLogPrinter(this);
	}


	void show(String msg, { StackTrace stackTrace, String label: '', depth: 1})
	{
		logPrinter._print(createJLog(msg, trace: stackTrace, label: label, depth: depth));
	}

	static void S(String msg, { StackTrace stackTrace, String label: '', int depth: 1})
	{
		I.show(msg, stackTrace: stackTrace, label: label, depth: depth);
	}


	JLog createJLog(String msg, { StackTrace trace, String label: '', depth: 1})
	{
		JLog jLog = JLog(msg, depth, label: label);

		trace ??= StackTrace.current;

		List<String> lines = trace.toString().split("\n");

		int count = 0;

		for (String line in lines)
		{
			var match = ConsoleLogger.stackTraceRegex.matchAsPrefix(line);
			if (match != null)
			{
				if (match.group(2).startsWith('package:chat/jhul/logger'))
				{
					continue;
				}

				String countPrefix = count
					.toString()
					.length < 2 ? '0' : '';

				String newLine = '$countPrefix$count ${match.group(2)} :: ${match.group(1).split('.')[1]}()';
				jLog.addLine(newLine.replaceAll('<anonymous closure>', '()'));

				if (++count == jLog.traceDepth)
				{
					break;
				}
			}
			else
			{
				jLog.addLine(line);
			}
		}

		return jLog;
	}
}

class JLog
{
	final int traceDepth;
	int width = 0;

	List<String> trace = [];

	JLog(String msg, this.traceDepth, { String label = '' })
	{
		if (label.length > 0)
		{
			addLine(label);
		}

		addLine('');
		addLine(msg);
		addLine('');
	}


	void addLine(String line)
	{
		if (line.length > width)
		{
			width = line.length;
		}

		trace.add(line);
	}
}


class CLogPrinter
{

	static const topLeftCorner = '┌';
	static const topRightCorner = '┐';

	static const bottomLeftCorner = '└';
	static const bottomRightCorner = '╝';

	static const middleCorner = '├';
	static const vChar = '│';
	static const hChar = "─";

	final ConsoleLogger logger;

	final int lineMaxLength = 120 - 4; // - |  |

	CLogPrinter(this.logger);

	BoxClass box = Box();

	void _print(JLog jLog)
	{
		jLog.width = min(jLog.width, lineMaxLength);

		_printBorderT(jLog);

		printLines(jLog);

		_printBorderB(jLog);
	}


	void _printBorderT(JLog jLog)
	{
		print(box.cornerTL + _createBorderH(jLog.width + 2) + box.cornerTR);
	}

	void _printBorderB(JLog jLog)
	{
		print(box.cornerBL + _createBorderH(jLog.width + 2) + box.cornerBR);
	}


	String _createBorderH(int msgLength)
	{
		String line = '';

		for (int i = msgLength; i >= 1; i--)
		{
			line = line + hChar;
		}

		return line;
	}

	void printLines(JLog jStackTrace)
	{
		for (String trace in jStackTrace.trace)
		{
			if (trace.length > lineMaxLength)
			{
				List<String> lines = splitByLength(trace, lineMaxLength);

				for (String line in lines)
				{
					_printLine(line, jStackTrace.width);
				}
			}
			else
			{
				_printLine(trace, jStackTrace.width);
			}
		}
	}

	void _printLine(String trace, int width)
	{
		print(_createLine(trace, width));
	}


	String _createLine(String msg, int boxWidth)
	{
		int appendWidth = boxWidth - msg.length + 1;

		return vChar + ' ' + msg + (' ' * appendWidth) + vChar;
	}

	List<String> splitByLength(String srcString, int size)
	{
		List<String> parts = [];
		int length = srcString.length;

		for (int i = 0; i < length; i += size)
		{
			parts.add(srcString.substring(i, min(length, i + size)));
		}

		return parts;
	}

}


abstract class BoxClass
{
	String get cornerTL;

	String get cornerTR;

	String get cornerBL;

	String get cornerBR;

	String get middleCorner;

	String get vChar;

	String get hChar;
}

class Box extends BoxClass
{
	String cornerTL = '┌';

	String cornerTR = '┐';

	String cornerBL = '└';
	String cornerBR = '┘';

	String middleCorner = '├';
	String vChar = '│';
	String hChar = "─";
}
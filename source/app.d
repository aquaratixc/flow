import std.file;
import std.getopt;

import core.interpreter;
import core.repl;
import utils.messages;

// compile with command: dub build --force --compiler=ldmd2 --build=release --arch=x86_64 --build-mode=singleFile
void main(string[] arguments)
{
	Flow interpreter = new Flow;
	
	void optionHandler(string option, string value)
	{
		import std.stdio;
		switch (option)
		{
			case "with-command|C":
				try
				{
					interpreter.execute(value);
				}
				catch (Throwable)
				{
					TerminalWriting.error("Invalid command(s)");
				}
				break;
			case "with-file|f":
				try
				{
					auto command = cast(string) std.file.read(value);
					interpreter.execute(command);
				}
				catch (Throwable)
				{
					TerminalWriting.error("Invalid file\n");
				}
				break;
			default:
				break;
		}
	}

	if (arguments.length == 1)
	{
		startREPL(interpreter);
	}
	else
	{
		try
		{
				getopt
				(
					arguments, 
					std.getopt.config.passThrough,
					"with-command|C", &optionHandler,
					"with-file|f", &optionHandler,
				);
		}
		catch (Throwable)
		{
			TerminalWriting.error("Missing argument for command-line option\n");
		}
	}
}

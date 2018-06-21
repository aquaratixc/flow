import std.conv : to;
import std.stdio;
import std.string;

import core.stdc.stdlib;

import core.interpreter;
import utils.messages;


void main()
{
	ModernFALSE falseInterpreter = new ModernFALSE;

	// welcome prompt
	write(WELCOME_PROMPT);
	
	while (!stdin.eof)
	{
		// show interpreter prompt
		showStandardPrompt;

		// get commands from stdin
		char[] expression;
		stdin.readln(expression);
		
		// get command
		string command = to!string(expression);
		
		// interpreters command
		switch (command.strip.toLower)
		{
			case ":about":
				write(ABOUT);
				break;
			// clear console
			case ":clear":
				clearConsole;
				break;
			// main help
			case ":help":
				write(MAIN_HELP);
				break;
			// print stack
			case ":stack":
				write("[stack]: ", falseInterpreter.getStack.content);
				break;
			// exit from interpreter
			case ":quit":
				exit(0);
				break;
			default:
				try
				{
					auto stripped = command.split;

					// if command is ":load"
					if (stripped[0] == ":load")
					{
						import std.file;

						auto filePath = stripped[1];
						auto fileContent = cast(string) std.file.read(filePath);
						
						command = fileContent;
					}

					// execute FALSE program
					falseInterpreter.execute(command);

				}
				catch(Throwable)
				{
					error(ERROR_MESSAGE.INVALID_COMMAND);
				}
				break;
		}
	}

	writeln;
}

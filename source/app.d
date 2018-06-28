import std.conv : to;
import std.stdio;
import std.string;

import core.stdc.stdlib;

import core.interpreter;
import utils.messages;


void main()
{
	ModernFALSE falseInterpreter = new ModernFALSE;
	string previousCommand;

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
			// about program
			case ":about":
				write(ABOUT);
				break;
			// ASCII table
			case ":ascii":
				write(ASCII_TABLE);
				break;
			// clear console
			case ":clear":
				clearConsole;
				break;
			// unused command
			case ":flow":
				break;
			// main help
			case ":help":
				write(MAIN_HELP);
				break;
			case ":reset":
				falseInterpreter.reset;
				break;
			// print stack
			case ":stack":
				write("[stack]: ", falseInterpreter.getStack.content);
				break;
			// show used variables
			case ":variables":
				auto variables = falseInterpreter.getVariables;
				if (variables.length == 0)
				{
					write("No used variables");
				}
				else
				{
					write("[variables]\n");
					foreach (variableName; variables.keys)
					{
						write(variableName, " => ", variables[variableName], "\n");
					}
					// magical command for delete last char
					write("\u001b[1A");
				}
				break;
			// exit from interpreter
			case ":quit":
				exit(0);
				break;
			default:
				try
				{
					auto stripped = command.split;

					if (stripped[0].toLower == ":load")
					{
						import std.file;
						// file name
						auto filePath = stripped[1];
						auto fileContent = cast(string) std.file.read(filePath);
						command = fileContent;
					}

					if (stripped[0].toLower == ":save")
					{
						if (stripped.length > 1)
						{
							if (previousCommand != "")
							{
								import std.path;
								auto filePath = stripped[1];

								File file;
								file.open(filePath, "w");
								file.write(previousCommand);
							}
						}
						command = "";
					}

					// execute FALSE program
					falseInterpreter.execute(command);
					previousCommand = command;

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

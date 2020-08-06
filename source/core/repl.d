module core.repl;

private
{
	import std.conv : to;
	import std.stdio;
	import std.string;

	import core.stdc.stdlib;

	import core.interpreter;
	import utils.messages;
}


// print variables from interpreter
auto printVariables(Flow interpreter)
{
	auto variables = interpreter.getVariables;
	
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
}

// load and save functions in interpreter
auto loadOrSave(ref string previousCommand, ref string command)
{
	import std.file;

	auto stripped = command.split;

	if (stripped[0].toLower == ":load")
	{
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
				auto filePath = stripped[1];

				File file;
				file.open(filePath, "w");
				file.write(previousCommand);
				file.close;
			}
		}
		command = "";
	}
}

// start Flow interpreter
auto startREPL(Flow interpreter)
{
	string previousCommand;
	
	// welcome prompt
	write(WELCOME);
	
	while (!stdin.eof)
	{
		// show interpreter prompt
		TerminalWriting.normal(PROMPT);

		// get commands from stdin
		char[] expression;
		stdin.readln(expression);
		
		// transform command to string
		string command = to!string(expression);
		
		// interpreters command
		switch (command.strip.toLower.chomp)
		{
			case "":
				break;
			// about program
			case ":about":
				write(ABOUT);
				break;
			// ASCII table
			case ":ascii":
				write(ASCII);
				break;
			// clear console
			case ":clear":
				TerminalWriting.clear;
				break;
			// unused command
			case ":flow":
				write(FLOW);
				break;
			// main help
			case ":help":
				write(LANGUAGE);
				break;
			case ":reset":
				interpreter.reset;
				break;
			// print stack
			case ":stack":
				write("[stack]: ", interpreter.getStack.content);
				break;
			// show used variables
			case ":variables":
				printVariables(interpreter);
				break;
			// exit from interpreter
			case ":quit":
				exit(0);
				break;
			default:
				try
				{
					// if ":save" or ":load" command
					loadOrSave(previousCommand, command);
					// execute program
					interpreter.execute(command);
					// store current program
					previousCommand = command;
				}
				catch(Throwable)
				{
					if (previousCommand != (cast(char) 10).to!string)
					{
						TerminalWriting.error("Invalid command(s)");
					}
					else
					{
						previousCommand = "";
					}
				}
				break;
		}
	}

	writeln;
}
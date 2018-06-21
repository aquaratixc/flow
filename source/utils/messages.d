module utils.messages;

private
{
	import std.stdio;
	import std.string;

	import utils.colorize;
}

// error messages
enum ERROR_MESSAGE : string
{
	EMPTY_STACK 	   = 	"Stack is empty",
	INVALID_COMMAND    = 	"Invalid command(s) in program",
	NOT_IMPLEMENTED	   = 	"Command not implemented",
}

// welcome screen
enum string WELCOME_PROMPT = 
`
	%1$sWelcome to Flow version 1.0 (linux)%2$s
	
	%1$sFlow%2$s is a modern dialect of the esoteric programming language FALSE.
	
	This interpreter allows executing Flow's code and supports the following commands:
		%1$s:about%2$s	 Show information about this program
		%1$s:clear%2$s 	 Clear console
		%1$s:help%2$s    Show a brief help on the Flow programming language
		%1$s:load%2$s    Load Flow file into interpreter
		%1$s:stack%2$s   Show the interpreter stack
		%1$s:quit%2$s    Exit from interpreter

	%3$sWarning:%2$s 
	        These commands can not be used in the Flow program
`.format("\u001b[97m\u001b[1m", "\u001b[0m", "\u001b[31m\u001b[1m");

// interpreter prompt
enum string INTERPRETER_PROMPT = "\nFlow> ";

// about interpreter
enum ABOUT = `
	Flow version 1.0 (FALSE programming language dialect)
	by Oleg Bakharev (D implementation), Ryan Holstien (Scala FALSE implementation);
`;

// Flow language help
enum string MAIN_HELP = cast(string) import("reference.txt");

// show interpreter prompt
void showStandardPrompt()
{
	stdout.write(ColoredTerminal.colorize2(INTERPRETER_PROMPT, "", "lightGreen"));
}

// clear main screen
void clearConsole()
{
	// magic command for clear screen
	write("\033[2J\033[;H");
}

// write error to stdout
void error(ERROR_MESSAGE message)
{
	stdout.write(ColoredTerminal.error(message));
}
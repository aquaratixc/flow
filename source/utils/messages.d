module utils.messages;

private
{
	import std.stdio;
	import std.string;
}

enum string FLOW_VERSION = "1.2b";

// determine platform
version (linux)
{
	enum string PLATFORM = "Linux";
}
else
{
	version (Win32)
	{
		enum string PLATFORM = "Win32";
	}

	version (Win64)
	{
		enum string PLATFORM = "Win64";
	}

	version (OSX)
	{
		enum string PLATFORM = "OSX";
	}
	else
	{
		enum string PLATFORM = "unknown";
	}
}

enum : string
{
	ABOUT = (cast(string) import("about.txt")).format(FLOW_VERSION),
	ASCII = cast(string) import("ascii.txt"),
	FLOW = cast(string) import("lhs.txt"),
	LANGUAGE = (cast(string) import("language.txt")).replace("%1$s", "\u001b[97m\u001b[1m").replace("%2$s","\u001b[0m"),
	PROMPT = "\n<Flow> ",
	WELCOME = (cast(string) import("welcome.txt"))
							.format("\u001b[97m\u001b[1m", "\u001b[0m", "\u001b[31m\u001b[1m", PLATFORM, FLOW_VERSION),
}

// class for colored terminal output
class TerminalWriting
{
	// terminal clear
	static void clear()
	{
		stdout.write("\033[2J\033[;H");
	}

	// print normal text (as green color)
	static void normal(string text)
	{
		stdout.write("\u001b[92m" ~ text ~ "\u001b[0m");
	}

	// print error (as red colored text with message "Error: <cause>")
	static void error(string text)
	{
		stdout.write("\u001b[31m" ~ "Error:" ~ "\u001b[0m " ~ text);
	}
}
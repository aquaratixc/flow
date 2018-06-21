module core.interpreter;

private
{
	import std.ascii;
	import std.conv;
	import std.stdio;
	import std.string;
	import core.exception : RangeError;

	import core.extended;
	import utils.messages;
	import utils.stack;
}

// FALSE programming language interpreter
class ModernFALSE
{
	private
	{
		// current FALSE program
		string falseProgram;
		// FALSE stack
		Stack!string stack;
		// FALSE variables and function storage
		string[string] variables;
		// features of modernFalse
		FunctionStorage extendedFunctions;

		// get integer from fragment of FALSE program
		auto getInteger(int startPosition)
		{
			string result;
			
			for (int i = startPosition; i < falseProgram.length; i++)
			{
				if (falseProgram[i].isDigit)
				{
					result = result ~ falseProgram[i].to!string;
				}
				else
				{
					break;
				}
			}
			return result;
		}

		// get string from fragment of FALSE program
		auto getString(int startPosition)
		{
			string result;
			
			for (int i = startPosition; i < falseProgram.length; i++)
			{
				if (falseProgram[i] != '\"')
				{
					result = result ~ falseProgram[i].to!string;
				}
				else
				{
					break;
				}
			}
			return result;
		}

		// get comment from fragment of FALSE program
		auto getComment(int startPosition)
		{
			int commentLength = 0;
			
			for (int i = startPosition; i < falseProgram.length; i++)
			{
				if (falseProgram[i] != '}')
				{
					commentLength = commentLength + 1;
				}
				else
				{
					break;
				}
			}
			return commentLength;
		}

		// get function from fragment of FALSE program
		auto getFunction(int startPosition)
		{
			string result;
			Stack!char bracketStack = new Stack!char;
			
			bracketStack.push('[');

			for (int i = startPosition; i < falseProgram.length; i++)
			{
				if (falseProgram[i]  == '[')
				{
					bracketStack.push('[');
					result = result ~ falseProgram[i].to!string;
				}
				else
				{
					if ((falseProgram[i] == ']') && (bracketStack.length == 1) && (bracketStack.top == '['))
					{
						break;
					}
					else
					{
						if (falseProgram[i] == ']')
						{
							bracketStack.pop;
							result = result ~ falseProgram[i].to!string;
						}
						else
						{
							result = result ~ falseProgram[i].to!string;
						}
					}
				}
			}
			return result;
		}

			// add program fragment
		auto addToProgram(int position, string program, string func)
		{
			string programBegin = program[0..position+1];
			string programEnd = "";

			if ((position + 1) != program.length)
			{
				programEnd = program[position+1..$];
			}

			return programBegin ~ func ~ programEnd;
		}
	}

	this()
	{
		// FALSE stack
		stack = new Stack!string;
		// ModernFALSE functions
		extendedFunctions = allExtendedFunctions;
	}

	// execute FALSE program
	auto execute(string mainProgram)
	{
		string fragmentOfProgram = mainProgram;
		falseProgram = mainProgram;
		
		// position of current character
		int i = 0;
		
		while (i < falseProgram.length)
		{
			// current character
			char current = falseProgram[i];
			
			// is digit character ?
			if (current.isDigit)
			{
				string number = getInteger(i);
				stack.push(number);
				i = i + number.length.to!int - 1;
			}
			else
			{
				// is alphabet character ?
				if (current.isAlpha)
				{
					stack.push("" ~ current.to!string);
				}
				else
				{
					// recognize FALSE operators
					switch (current)
					{
						// comment
						case '{':
							i = i + getComment(i+1) + 1;
							break;
						// unary minus
						case '_':
							stack.push((-1 * stack.pop.to!int).to!string);
							break;
						// addition
						case '+':
							stack.push((stack.pop.to!int + stack.pop.to!int).to!string);
							break;
						// subtraction
						case '-':
							stack.swap;
							stack.push((stack.pop.to!int - stack.pop.to!int).to!string);
							break;
						// multiplication
						case '*':
							stack.push((stack.pop.to!int * stack.pop.to!int).to!string);
							break;
						// division
						case '/':
							stack.swap;
							stack.push((stack.pop.to!int / stack.pop.to!int).to!string);
							break;
						// equal
						case '=':
							if (stack.pop == stack.pop)
							{
								stack.push("-1");
							}
							else
							{
								stack.push("0");
							}
							break;
						// logical not
						case '~':
							if (stack.pop == "0")
							{
								stack.push("-1");
							}
							else
							{
								stack.push("0");
							}
							break;
						// greather than
						case '>':
							int a = stack.pop.to!int;
							int b = stack.pop.to!int;
							if (b > a)
							{
								stack.push("-1");
							}
							else
							{
								stack.push("0");
							}
							break;
						// logical and
						case '&':
							int a = stack.pop.to!int;
							int b = stack.pop.to!int;
							if ((a == 0) || (b == 0))
							{
								stack.push("0");
							}
							else
							{
								stack.push("-1");
							}
							break;
						// logical or
						case '|':
							int a = stack.pop.to!int;
							int b = stack.pop.to!int;
							if ((a == -1) || (b == -1))
							{
								stack.push("-1");
							}
							else
							{
								stack.push("0");
							}
							break;
						// duplicate
						case '$':
							stack.push(stack.top);
							break;
						// drop
						case '%':
							stack.pop;
							break;
						// swap
						case '\\':
							stack.swap;
							break;
						// rotate
						case '@':
							stack.rot;
							break;
						// pick
						case '(':
							stack.pick;
							break;
						// push character
						case '\'':
							string character = falseProgram[i+1].to!int.to!string;
							stack.push(character);
							i = i + 1;
							break;
						// variable assignment
						case ':':
							string key = stack.pop;
							string value = stack.pop;
							variables[key] = value;
							break;
						// variable extraction
						case ';':
							string key = stack.pop;
							stack.push(variables[key]);
							break;
						// write integer
						case '.':
							try
							{
								string result = stack.pop;
								stdout.write(result);
							}
							catch (Throwable)
							{
								error(ERROR_MESSAGE.EMPTY_STACK);
								return;
							}
							break;
						// write character
						case ',':
							try
							{
								string value = stack.pop;
								stdout.write(value.parse!int.to!char);
							}
							catch(Throwable)
							{
								error(ERROR_MESSAGE.EMPTY_STACK);
								return;
							}
							break;
						// string
						case '\"':
							string s = getString(i+1);
							stdout.write(s);
							i = i + s.length.to!int + 1;
							break;
						// read character from stdin
						case '^':
							try
							{
								char expression;
								stdin.readf("%c", expression);
								string character = expression.to!int.to!string;
								stack.push(character);
							}
							catch (Throwable)
							{
								stack.push("-1");
							}
							break;
						// flush stdin and stdout;
						case ')':
							stdin.flush;
							stdout.flush;
							break;
						// lambda
						case '[':
							string func = getFunction(i+1);
							stack.push(func);
							i = i + func.length.to!int + 1;
							break;
						// apply function
						case '!':
							string func = stack.pop;
							fragmentOfProgram = addToProgram(i, fragmentOfProgram, func);
							falseProgram = fragmentOfProgram;
							break;
						// if
						case '?':
							string func = stack.pop;
							string cond = stack.pop;
							if (cond == "-1")
							{
								fragmentOfProgram = addToProgram(i, fragmentOfProgram, func);
								falseProgram = fragmentOfProgram;
							}
							break;
						// while
						case '#':
							string func = stack.pop;
							string cond = stack.pop;
							string loop = cond ~ "[" ~ func ~ "[" ~ cond ~ "][" ~ func ~ "]#]?";
							fragmentOfProgram = addToProgram(i, fragmentOfProgram, loop);
							falseProgram = fragmentOfProgram;
							break;
						// external function
						case '`':
							string functionNumber = stack.pop;
							if (functionNumber in extendedFunctions)
							{
								auto ef = extendedFunctions[functionNumber];
								ef(stack);
							}
							else
							{
								error(ERROR_MESSAGE.NOT_IMPLEMENTED);
								return;
							}
							break;
						// another character
						default:
							break;
					}
				}
			}
			i++;
		}
		// empty writing
		//writeln;
	}

	// get FALSE stack
	auto @property getStack()
	{
		return stack;
	}
}
module core.extended;

private
{
	import std.conv : to;

	import utils.stack;
}

// feature class
abstract class ModernFalseFunction
{
	void opCall(ref Stack!string stack);
}

// alias for type of storage for new features
alias FunctionStorage = ModernFalseFunction[string];

private
{
	// push number of stack items to top
	class DepthFunction : ModernFalseFunction
	{
		override void opCall(ref Stack!string stack)
		{
			stack.push(stack.length.to!string);
		}
	}

	// bitwise and
	class AndFunction : ModernFalseFunction
	{
		override void opCall(ref Stack!string stack)
		{
			stack.swap;
			stack.push((stack.pop.to!int & stack.pop.to!int).to!string);
		}
	}

	// bitwise or
	class OrFunction : ModernFalseFunction
	{
		override void opCall(ref Stack!string stack)
		{
			stack.swap;
			stack.push((stack.pop.to!int | stack.pop.to!int).to!string);
		}
	}

	// bitwise xor
	class XorFunction : ModernFalseFunction
	{
		override void opCall(ref Stack!string stack)
		{
			stack.swap;
			stack.push((stack.pop.to!int ^ stack.pop.to!int).to!string);
		}
	}

	// bitwise not
	class NotFunction : ModernFalseFunction
	{
		override void opCall(ref Stack!string stack)
		{
			stack.swap;
			stack.push((~(stack.pop.to!int)).to!string);
		}
	}
}

// load all extended function
auto allExtendedFunctions()
{
	// place for new features
	FunctionStorage functionStorage = [
		"0" : (new DepthFunction),
		"1" : (new AndFunction),
		"2" : (new OrFunction),
		"3" : (new XorFunction),
		"4" : (new NotFunction), 
	];

	return functionStorage;
}
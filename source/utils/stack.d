module utils.stack;

// stack class
class Stack(T)
{
	private
	{
		T[] elements;
	}
	
	public
	{
		// push element onto stack
		void push(T element)
		{
			elements ~= element;
		}
		
		// pop element from stack
		auto pop()
		{
			T topN = elements[$-1];
			--elements.length;
		
			return topN;
		}
		
		// number of elements in stack
		size_t length() const @property
		{
			return elements.length;
		}
		
		// top item
		T top() const @property
		{
			return elements[$-1];
		}
		
		// stack content
		T[] content() @property
		{
			return elements;
		}
		
		// is empty stack ?
		bool empty() const @property
		{
			if (elements.length == 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		// swap
		void swap()
		{
			T top = pop();
			T bottom = pop();

			push(top);
			push(bottom);
		}

		// roatate
		void rot()
		{
			T first = pop;
			T second = pop;
			T third = pop;
			
			push(second);
			push(first);
			push(third);
		}

		// copy n-th element to the top
		void pick()
		{
			import std.conv : to;
			int n = pop.to!int;
			push(elements[$-n-1]);
		}

		// clear stack
		void clear()
		{
			elements = typeof(elements).init;
		}
	}
}
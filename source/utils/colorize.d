module utils.colorize;

// class for colorize terminal output     
class ColoredTerminal
{
 	private
 	{
 		enum string reset = "\u001b[0m";
	 	
	 	enum string[string] backgroundColors = [
			"default"      :  "\u001b[49m",
			"black"        :  "\u001b[40m",
			"red"          :  "\u001b[41m",
			"green"        :  "\u001b[42m",
			"yellow"       :  "\u001b[43m",
			"blue"	       :  "\u001b[44m",
			"magenta"      :  "\u001b[45m",
			"cyan"	       :  "\u001b[46m",
			"lightGray"	   :  "\u001b[47m",
			"darkGrey"     :  "\u001b[100m",
			"lightRed"     :  "\u001b[101m",
			"lightGreen"   :  "\u001b[102m",
			"lightYellow"  :  "\u001b[103m",
			"lightBlue"    :  "\u001b[104m",
			"lightMagenta" :  "\u001b[105m",
			"lightCyan"    :  "\u001b[106m",
			"white"        :  "\u001b[107m"
	 	];
 
	 	enum string[string] foregroundColors = [
			"default"      :  "\u001b[39m",
			"black"        :  "\u001b[30m",
			"red"          :  "\u001b[31m",
			"green"        :  "\u001b[32m",
			"yellow"       :  "\u001b[33m",
			"blue"	       :  "\u001b[34m",
			"magenta"      :  "\u001b[35m",
			"cyan"	       :  "\u001b[36m",
			"lightGray"	   :  "\u001b[37m",
			"darkGrey"     :  "\u001b[90m",
			"lightRed"     :  "\u001b[91m",
			"lightGreen"   :  "\u001b[92m",
			"lightYellow"  :  "\u001b[93m",
			"lightBlue"    :  "\u001b[94m",
			"lightMagenta" :  "\u001b[95m",
			"lightCyan"    :  "\u001b[96m",
			"white"        :  "\u001b[97m"
	 	];
 
	 	enum string[string] textStyles = [
			"default"      :  "\u001b[0m",
			"bold"         :  "\u001b[1m",
			"bright"       :  "\u001b[1m",
			"dim"          :  "\u001b[2m",
			"underline"    :  "\u001b[4m",
			"blink"	       :  "\u001b[5m",
			"reverse"      :  "\u001b[7m",
			"hidden"	   :  "\u001b[8m",
	 	];
 	}
	
	// colorize your text
 	static string colorize(
 		string text, 
 		string foregroundColor = "default", 
 		string backgroundColor = "default", 
 		string textStyle = "default"
 		)
 	{
 		string foreground, background, style;
 		
 		// set foreground
 		if (foregroundColor in foregroundColors)
 		{
 			foreground = foregroundColors[foregroundColor];
 		}
 		else
 		{
 			foreground = foregroundColors["default"];
 		}
 
 		// set background
 		if (backgroundColor in backgroundColors)
 		{
 			background = backgroundColors[backgroundColor];
 		}
 		else
 		{
 			background = backgroundColors["default"];
 		}
 
 		// set style
 		if ((textStyle in textStyles) && (textStyle != "default"))
 		{
 			style = textStyles[textStyle];
 		}
 		else
 		{
 			style = "";
 		}
 
 		string newText = foreground ~ background ~ style ~ text ~ reset;
 
 		return newText;
 	}
 
 	// colorize with some caption style
 	static string colorize2(string caption, string text, string foregroundColor)
 	{
 		return colorize(caption, foregroundColor, "default", "bold") ~ " " ~ colorize(text, "white", "default", "bold");
 	}
 
 	// colorize as info message
 	static string info(string text)
 	{
 		return colorize2("Info:", text, "green");
 	}
 
 	// colorize as log message
 	static string log(string text)
 	{
 		return colorize2("Log:", text, "blue");
 	}
 
 	// colorize as warning message
 	static string warning(string text)
 	{
 		return colorize2("Warning:", text, "yellow");
 	}
 
 	// colorize as error message
 	static string error(string text)
 	{
 		return colorize2("Error:", text, "red");
 	}
}
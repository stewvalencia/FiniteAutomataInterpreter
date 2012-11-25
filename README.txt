This code sample came from a 2010 school project.

The Finite Automata Interpreter is an interpreter for commands to build/transform finite automata, print out 
various properties about them, and use them to accept/reject particular strings. The interpreter operates 
using a stack, where each object on the stack is a finite automaton. Commands pop zero, one, or two finite 
automata from the stack and push zero or one finite automata on stack as a result.

The purpose of the project is to show my understanding of finite automata and 
Ruby's Object-oriented fundamentals. 

Intepreter commands:
	symbol where symbol is a lowercase letter or the uppercase E. Former case creates FA that accepts just that 
		letter, and the latter case creates an automaton that accepts the empty string. The new automaton 
		is pushed onto the stack.
	. pops off top 2 FA on the stack, creates a new NFA representing concatcenation, pushing this new NFA 
		on to the stack
	| pops off top 2 FA on stack, creates a new NFA representing their union, pushing this new NFA on 
		to the stack
	* pops off top finite automaton on stack, creates a new NFA representing its closure, pushing this 
		new NFA on to the stack
	SIZE prints # of states in the finite automaton at the top of the stack (without popping it off)
	PRINT prints the finite automaton at the top of the stack (without popping it off). All output from 
		this command is preceded by %
	DFA converts finite automaton (DFA or NFA) at the top of the stack to a DFA
	MINIMIZE minimizes the finite automaton (must be a DFA) at the top of the stack
	"str" decides whether finite automaton (must be a DFA) at the top of the stack accepts or rejects string str
	GENSTR# prints all strings accepted by finite automaton (must be a DFA) at the top of the stack of length # or less
	DONE interpreter exits

Files:
	fa.rb - The interpreter 
	test (...).in - Text file input to test fa.rb
	test (...).out - Expected output of test (...)

Examples of how to use:
	ruby fa.rb < "test (1).in" tests the first text file input test case
	Example input:
		a b . PRINT SIZE c | * DONE
		The a creates an FA that accepts exactly the string a, and pushes it on the stack. The b creates an FA that accepts exactly the string b, 
			and pushes it on the stack. The . pops these two automata off of the stack, and constructs a new automaton that accepts the concatenation 
			of strings accepted by the two, i.e., ab. This new automaton is pushed back on the stack, and is now the only automaton on the stack.
		The output:
			% Start 0
			% Final { 1 }
			% States { 0 1 }
			% Alphabet { a }
			% Transitions {
			%  (0 a 1)
			% }
			
			
-Stewart Valencia

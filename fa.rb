#!/usr/bin/ruby -w

#Author: Stewart Valencia

#FA only used as a Base Class. Only used some methods. 
class FiniteAutomaton
    @@nextID = 0	# shared across all states
    attr_reader:state, :start, :final, :alphabet, :transition

    #---------------------------------------------------------------
    # Constructor for the FA
    def initialize
        @start = nil 		# start state 
        @state = { } 		# all states
        @final = { } 		# final states
        @transition = { }	# transitions
        @alphabet = [ ] 	# symbols on transitions
    end

    #---------------------------------------------------------------
    # Return number of states
    def num_states
        @state.size
    end

    #---------------------------------------------------------------
    # Creates a new state 
    def new_state
        newID = @@nextID
        @@nextID += 1
        @state[newID] = true
        @transition[newID] = {}
        newID 
    end

    #---------------------------------------------------------------
    # Creates a new state
    def add_state(v)
        unless has_state?(v)
            @state[v] = true
            @transition[v] = {}
        end
    end

    #---------------------------------------------------------------
    # Returns true if the state exists
    def has_state?(v)
        @state[v]
    end

    #---------------------------------------------------------------
    # Set (or reset) the start state
    def set_start(v)
        add_state(v)
        @start = v
    end

    #---------------------------------------------------------------
    # Set (or reset) a final state
    def set_final(v, final = true)
        add_state(v)
        if final
            @final[v] = true
        else
            @final.delete(v)
        end
    end

    #---------------------------------------------------------------
    # Returns true if the state is final
    def is_final?(v)
        @final[v]
    end

    #---------------------------------------------------------------
    # Creates a new transition from v1 to v2 with symbol x
    # Any previous transition from v1 with symbol x is removed
    def add_transition(v1, v2, x)
        add_state(v1)
        add_state(v2)
		if (x != "" && !@alphabet.include?(x))
			@alphabet.push x
		end
        @transition[v1][x] = v2
    end

    #---------------------------------------------------------------
    # Get the destination state from v1 with symbol x
    # Returns nil if non-existent
    def get_transition(v1,x)
        if has_state?(v1)
            @transition[v1][x]
        else
            nil
        end
    end

    #---------------------------------------------------------------
    # Returns true if the dfa accepts the given string
    def accept?(s, current = @start)
        if s == ""
            is_final?(current)
        else
            dest = get_transition(current,s[0,1])
            if dest == nil
                false
            else
                accept?(s[1..-1], dest)
            end
        end
    end

    #---------------------------------------------------------------
    # Returns all states reachable from states ss
    #   using only epsilon transitions
    def eClosure(ss)
    end

    #---------------------------------------------------------------
    # Prints FA 
    def prettyPrint
        print "% Start "
	puts @start
        # Final states in sorted order
	print "% Final {"
	@final.keys.sort.each { |x| print " #{x}" }
	puts " }" 

        # States in sorted order
	print "% States {"
	@state.keys.sort.each { |x| print " #{x}" }
	puts " }" 

        # Alphabet in alphabetical order
        print "% Alphabet {"
	@alphabet.sort.each { |x| print " #{x}" }
	puts " }" 

        # Transitions in lexicographic order
        puts "% Transitions {"
	@transition.keys.sort.each { |v1| 
            @transition[v1].keys.sort.each { |x| 
                v2 = get_transition(v1,x)
                puts "%  (#{v1} #{x} #{v2})" 
            }
        }
	puts "% }" 
    end
        
    #---------------------------------------------------------------
    # accepts just symbol ("" = epsilon)
    def symbol! sym
        initialize
        s0 = new_state
        s1 = new_state
        set_start(s0)
        set_final(s1, true)
        add_transition(s0, s1, sym)
    end

    #---------------------------------------------------------------
    # accept strings accepted by self, followed by strings accepted by newFA
    def concat! newFA
    end

    #---------------------------------------------------------------
    # accept strings accepted by either self or newFA
    def union! newFA
    end

    #---------------------------------------------------------------
    # accept any sequence of 0 or more strings accepted by self
    def closure! 
    end

    #---------------------------------------------------------------
    # returns DFA that accepts only strings accepted by self 
    def toDFA
        # create a new one, or modify the current one in place,
        # and return it
        FiniteAutomaton.new
    end

    #---------------------------------------------------------------
    # returns a DFA that accepts only strings accepted by self, 
    # but as minimal DFA.
    def minimize
        # create a new one, or modify the current one in place,
        # and return it
        FiniteAutomaton.new     
    end

    #---------------------------------------------------------------
    # return all strings accepted by FA with length <= strLen
    def genStr strLen
	sortedAlphabet = @alphabet.sort
        resultStrs = [ ] 
        testStrings = [ ]
        testStrings[0] = [] 
        testStrings[0].push ""
        1.upto(strLen.to_i) { |x|
            testStrings[x] = []
            testStrings[x-1].each { |s|
                sortedAlphabet.each { |c|
                    testStrings[x].push s+c
                }
            }
        }
        testStrings.flatten.each { |s|
            resultStrs.push s if accept? s
        }
        result = ""
        resultStrs.each { |x| result.concat '"'+x+'" ' }
        result
    end

    #---------------------------------------------------------------
    # Create a graphvis file for our FA
            
    def dotfile()
    end

end
#NFA extends from the FA class.
class NFA < FiniteAutomaton
	#---------------------------------------------------------------
    # Constructor for the FA
    def initialize
        @start = nil 		# start state 
        @state = { } 		# all states
        @final = { } 		# final states
        @transition = { }	# transitions
        @alphabet = [ ] 	# symbols on transitions
    end
	#---------------------------------------------------------------
    # Creates a new state 
    def new_state
        newID = @@nextID
        @@nextID += 1
        @state[newID] = true
        @transition[newID] = {}
        newID 
    end
    #---------------------------------------------------------------
    # Creates a new transition from v1 to v2 with symbol x
    # Any previous transition from v1 with symbol x is removed
    def add_transition(v1, v2, x)
        add_state(v1)
        add_state(v2)
		if (x != "" && !@alphabet.include?(x))
			@alphabet.push x
		end
        @transition[v1][v2] = x
    end

    #---------------------------------------------------------------
    # Get the symbol from v1 to v2
    # Returns nil if non-existent
    def get_transition(v1,v2)
        if has_state?(v1)
            @transition[v1][v2]
        else
            nil
        end
    end

    #---------------------------------------------------------------
    # Returns true if the dfa accepts the given string
    def accept?(s, current = @start)
        false
    end

    #---------------------------------------------------------------
    # Returns all states reachable from states ss
    #   using only epsilon transitions
    def eClosure(ss)
		closures = Array.new
		stack = Array.new
		stack.push ss
		stack.flatten!
		while(!stack.empty?)
			temp = stack.pop
			if(@transition[temp] != nil && !closures.include?(temp))
				closures.push temp
				@transition[temp].keys.sort.each{ |v2|
					if (get_transition(temp,v2) == "")
						stack.push(v2)
					end
				}
			end
		end	
		closures
    end
	
	#---------------------------------------------------------------
    # Returns all states reachable from states a
	def move(a, p)
		reachable = []
		temp = []
		temp.push a
		temp.flatten!
		temp.each{ |v1|
			if(@transition[v1] != nil)
				@transition[v1].keys.sort.each{ |v2|
					if (get_transition(v1,v2) == p)
						if (!reachable.include?(v2))
							reachable.push(v2)
						end
					end
					}
			end
		}
		reachable
	end

    #---------------------------------------------------------------
    # Prints FA 
    def prettyPrint
        print "% Start "
	puts @start
        # Final states in sorted order
	print "% Final {"
	@final.keys.sort.each { |x| print " #{x}" }
	puts " }" 
        # States in sorted order
	print "% States {"
	@state.keys.sort.each { |x| print " #{x}" }
	puts " }" 

        # Alphabet in alphabetical order
        print "% Alphabet {"
	@alphabet.sort.each { |x| print " #{x}" }
	puts " }" 

        # Transitions in lexicographic order
        puts "% Transitions {"
	@transition.keys.sort.each { |v1| 
            @transition[v1].keys.sort.each { |v2| 
                x = get_transition(v1,v2)
                puts "%  (#{v1} #{x} #{v2})" 
            }
        }
	puts "% }" 
    end
        
    #---------------------------------------------------------------
    # accepts just symbol ("" = epsilon)
    def symbol! sym
        initialize
        s0 = new_state
        s1 = new_state
        set_start(s0)
        set_final(s1, true)
        add_transition(s0, s1, sym)
    end

    #---------------------------------------------------------------
    # accept strings accepted by self, followed by strings accepted by newFA
    def concat!(f1)
		f1.state.keys.sort.each { |x| add_state(x) }
		@final.keys.sort.each { |x| add_transition(x, f1.start, "")		}
		@final = f1.final
		f1.transition.keys.each { |v1| 
            f1.transition[v1].keys.each { |v2| 
                add_transition(v1, v2, f1.get_transition(v1,v2))
            }
        }
		@state.delete(nil)
		@transition.delete(nil)
    end

    #---------------------------------------------------------------
    # accept strings accepted by either self or newFA
    def union!(f1)
		temp = new_state
		add_transition(temp, @start, "")
		@start = temp
		add_transition(temp, f1.start, "")
		temp = new_state
		@final.keys.sort.each { |x| set_final(x, false) 
		add_transition(x, temp, "") }
		set_final(temp)
		f1.final.keys.sort.each { |x| add_transition(x, temp, "") }
		f1.transition.keys.each { |v1| 
            f1.transition[v1].keys.each { |v2| 
                add_transition(v1, v2, f1.get_transition(v1,v2))
            }
        }
		@state.delete(nil)
		@transition.delete(nil)
    end

    #---------------------------------------------------------------
    # accept any sequence of 0 or more strings accepted by self
    def closure! 
		temp = new_state
		add_transition(temp, @start, "")
		@start = temp
		temp = new_state
		@final.keys.sort.each { |x| 
		add_transition(x, temp, "") 
		set_final(x, false) }
		
		@final = {temp=>true}
		add_transition(@start, temp, "")
		add_transition(temp, @start, "")
		@state.delete(nil)
		@transition.delete(nil)
    end

    #---------------------------------------------------------------
    # returns DFA that accepts only strings accepted by self 
    def toDFA
        # create a new one, or modify the current one in place,
        # and return it
        dfa = DFA.new
		stack = []
		stack.push eClosure(@start)
		#print "R = {" + stack.join(", ").to_s + "}\n"
		painted = []
		counter = @@nextID
		while(!stack.empty?)
			temp = stack.pop
			painted.push temp
			#print "Painted = {" + painted.join(", ").to_s + "}\n"
			b = counter
			if(!dfa.state_rep.has_value?(temp))
				b = counter
				dfa.state_rep[b] = temp
			else
				b = dfa.state_rep.index(temp)
			end
			
			if(dfa.start==nil)
				dfa.set_start(b)
				end
			if temp.is_a?(Array)
				temp.each{|fin|
				if(is_final?(fin))
					dfa.set_final(b)
				end
				}
			elsif(is_final?(temp) && !dfa.is_final?(temp))
				dfa.set_final(b)
			end
			@alphabet.sort.each{|a|
				s = move(temp,a)
				#print "Move (" + temp.join(", ").to_s + "," + a + ") = {" + s.join(", ").to_s + "}\n"
			if (!s.empty?)
				e = eClosure(s)
				#print "e = {" + e.join(", ").to_s + "}\n"
				c = counter
				if(!dfa.state_rep.has_value?(e))
					counter+=1
					c = counter
					dfa.state_rep[c] = e
				else
					c = dfa.state_rep.index(e)
				end
				
				if(!painted.include?(e))
					stack.push e
					#print "stack = {" + stack.join(", ").to_s + "}\n"
				end
				
				dfa.add_transition(b, c, a)
                #puts "transition  (#{b} #{a} #{c})" 
				#puts "-------------------------"
				e.flatten.each{ |f|
				if(is_final?(f) && !dfa.is_final?(f))
					dfa.set_final(c)
				end
				}
			end
				}
		end
		dfa
    end

    #---------------------------------------------------------------
    # returns a DFA that accepts only strings accepted by self, 
    # but as minimal DFA.
    def minimize
        # create a new one, or modify the current one in place,
        # and return it
        DFA.new     
    end
    #---------------------------------------------------------------
    # Create a graphvis file for our FA
            
    def dotfile()
    end
end

#Only declared as an extension to FA because I needed to change the initialize
class DFA < FiniteAutomaton
	attr_reader:state_rep, :nfa_trans, :transition
	def initialize
        @start = nil 		# start state 
        @state = { } 		# all states
        @final = { } 		# final states
        @transition = { }	# transitions
        @alphabet = [ ] 	# symbols on transitions
		@state_rep ={ }
		@nfa_trans = { }
    end
	
	def clear_trans(g)
        @transition[g] = { }	# transitions
    end
	
	#---------------------------------------------------------------
    # returns a DFA that accepts only strings accepted by self, 
    # but as minimal DFA.
    def minimize
		dfa = DFA.new
		if @alphabet.empty?
			return self
		end
		accept = @final.keys
		reject = @state.keys - accept
		#print "Accept { " + accept.join(", ").to_s + " }\n"
		#print "Reject { " + reject.join(", ").to_s + " }\n"
		counter = @@nextID
		a = counter
		if(!reject.empty?)
			counter+=1
		end
		b = counter
		symbol = nil
		destination = nil
		
		if(!reject.empty?)
			dfa.state_rep[a] = reject
			dfa.state_rep[b] = accept
		else
			dfa.state_rep[a] = accept
		end
			
		stack = Array.new
		stack.push a
		stack.push b
		partitions = Array.new
		#dfa.prettyPrint
		while(partitions != stack)
			partitions = stack
			stack = Array.new
			#puts "Part: " + partitions.to_s + "stak: " + stack.to_s
			#print "R = {" + partitions.join(", ").to_s + "}\n"
			partitions.flatten.each{ |p|
				#print "Split partition: { " + dfa.state_rep[p].join(", ").to_s + " }\n"
				dfa.state_rep[p], temp = split(dfa.state_rep[p], dfa.state_rep)
				#print p.to_s + " now contains: { " + dfa.state_rep[p].join(", ").to_s + " }\n"
				#print "Temp: { " + temp.join(", ").to_s + " }\n"
				if(!temp.empty?)
					counter+=1
					c = counter
					stack.push p
					stack.push c
					#print c.to_s + " now contains { " + temp.join(", ").to_s + " }\n"
					#dfa.prettyPrint
					dfa.state_rep[c] = temp
				end
				dfa.state_rep.keys.each { |state|
					dfa.clear_trans(state)
					dfa.state_rep[state].each { |stuffs|
					@alphabet.each{ |c|
						dest = get_transition(stuffs, c)
						if dest != nil
							parks = dfa.state_rep.keys.dup
							parks.each{ |place|
								if dfa.state_rep[place].include?(dest)
									#puts "adding (" + state.to_s + " " + c.to_s + " " + place.to_s + "\n" 
									dfa.add_transition(state, place, c)
								end
							}
							#end
						end
					}
					}
				}
				#print dfa.state.to_s + "\n"
				#puts "-------------------------------"
			}
			#puts "Part: " + partitions.to_s + "stak: " + stack.to_s
		end
		dfa.state.keys.each{ |parts|
			result = 0
			is_start = 0
			#puts parts
			dfa.state_rep[parts].each { |state|
				if(is_final?(state))
					result = 1
				end
				if(state == @start)
					is_start = 1
				end
				}
			if result == 1
				dfa.set_final(parts)
			end
			if(is_start == 1)
				dfa.set_start(parts)
			end
		}
		dfa
    end
	
	#---------------------------------------------------------------	
	def split(p, partitions)
		m = []
		other_states = p.dup
		r = other_states.first
		other_states.each{ |s|
			@alphabet.each{ |c|
				dest_1 = get_transition(r, c)
				dest_2 = get_transition(s, c)
				result = 0
				if (dest_1 != dest_2)
					partitions.keys.sort.each{ |part|
					if(partitions[part].include?(dest_1) != partitions[part].include?(dest_2))		
							result = 1
							break
						end	
					}
				end
				if(result == 1 && !m.include?(s))
					m.push s
				end
			}
		}
		return p-m, m
	end
end
#---------------------------------------------------------------
# read standard input and interpret as a stack machine

def interpreter
   dfaStack = [ ] 
   loop do
       line = gets
       words = line.scan(/\S+/)
       words.each{ |word|
           case word
               when /DONE/
                   return
               when /DOT/
                   f = dfaStack.last
                   f.dotfile
               when /SIZE/
                   f = dfaStack.last
                   puts f.num_states
               when /PRINT/
                   f = dfaStack.last
                   f.prettyPrint
               when /DFA/
                   f = dfaStack.pop
                   f2 = f.toDFA
                   dfaStack.push f2
               when /MINIMIZE/
                   f = dfaStack.pop
                   f2 = f.minimize
                   dfaStack.push f2
               when /GENSTR([0-9]+)/
                   f = dfaStack.last
                   puts f.genStr($1)
               when /"([a-z]*)"/
                   f = dfaStack.last
                   str = $1
                   if f.accept?(str)
                       puts "Accept #{str}"
                   else
                       puts "Reject #{str}"
                   end
               when /([a-zE])/
                   puts "Illegal syntax for: #{word}" if word.length != 1
                   f = NFA.new #changed from FA because it always gonna create a new NFA object
                   sym = $1
                   sym="" if $1=="E"
                   f.symbol!(sym)
                   dfaStack.push f
               when /\*/
                   puts "Illegal syntax for: #{word}" if word.length != 1
                   f = dfaStack.pop
                   f.closure!
                   dfaStack.push f
               when /\|/
                   puts "Illegal syntax for: #{word}" if word.length != 1
                   f1 = dfaStack.pop
                   f2 = dfaStack.pop
                   f2.union!(f1)
                   dfaStack.push f2
               when /\./
                   puts "Illegal syntax for: #{word}" if word.length != 1
                   f1 = dfaStack.pop
                   f2 = dfaStack.pop
                   f2.concat!(f1)
                   dfaStack.push f2
               else
                   puts "Ignoring #{word}"
           end
        }
   end
end

#---------------------------------------------------------------
# main( )

if false			# just debugging messages
    f = FiniteAutomaton.new
    f.set_start(1)
    f.set_final(2)
    f.set_final(3)
    f.add_transition(1,2,"a")   # need to keep this for NFA
    f.add_transition(1,3,"a")  
    f.prettyPrint
end

interpreter  # type "DONE" to exit


{-
  Title: Register Machine interpreter (RMi)
         ^        ^       ^
  Creator: Linisac Wu

  Date: June 05 2011

  Abstract: This program is written in Haskell which interprets the computation model ---
    Register Machine --- introduced in Section 2 of Chapter X of the textbook `Mathematical Logic'
    authored by H.-D. Ebbinghaus, J. Flum and W. Thomas.

  Specification: A register machine, with a fixed (finite) alphabet, consists of an infinite list of
    registers (its "memory"), indexed from 0 up. Each register in turn consists of a (possibly empty)
    string over the alphbet.

      In addition to the list of registers, the register machine contains a finite list of
    instructions (its "program"), drawn from the following set of instructions:

      1) ADD _index _symbol: Append _symbol to the register indexed by _index.
      2) SUB _index _symbol: If the register indexed by _index contains a nonempty string
           terminating with a character identical to _symbol, then drop that character from the
           string in the register; otherwise, do nothing.
      3) IF _index THEN _l0 ELSE _l1 OR _l2 OR ... OR _ln: n is the size of the alphabet. If the
           register indexed by _index contains the empty string, then the next instruction to be
           executed is labelled _l0; otherwise, if it contains a string terminating with the mth
           character from the alphabet, then the next instruction to be executed is labelled _lm.
      4) PRINT: Print the string in register indexed 0 as output.
      5) HALT: The register machine halts.

    and additionally

      6) GOTO _l: An abbreviation for "IF _index THEN _l ELSE _l OR _l ... OR _l", that is, an
           unconditional jump.

    Notice that "ADD _index _symbol" and "SUB _index _symbo" correspond to

      LET R_index := R_index + a_symbol

    and

      LET R_index := R_index - a_symbol

    respectively.

      Prior to execution, all registers contain the empty string, except possibly the register indexed
    0, which may contain a string from the input. Of course, if the input is void, then that register
    initially contains the empty string.

      The program is a finite list of instructions labelled from 0 up, with the last instruction being
    a HALT (the one and only).

      The register machine executes one instruction at a time, and starts by executing the first
    instruction of the program, that is, the instruction labelled 0. During execution, it may print
    as output the contents in register indexed 0 in a sequential fashion.

      Finally, note that as stated in the textbook, the register machine may not halt. Since this
    interpreter program completely interprets the register machine, if the latter does not halt then
    the former does not halt either.
-}

--BEGIN: The parameter _symbol in ADD and SUB is represented as [Char] instead of Char for ease of
--typing.
type Sym = [Char]
--END

--BEGIN: The alphabet is represented as [Char].
type Alphabet = [Char]
--END

--BEGIN: The registers are indexed by Int, from 0 up. The content of a register is represented as
--[Char].
type RegIndex = Int
type RegCtnt = [Char]
--END

--BEGIN: Label's are the indices of instructions in the program. The program is represented as list
--of Instr's.
type Label = Int
data Instr = ADD RegIndex Sym | SUB RegIndex Sym | IF RegIndex [Label] | PRINT | HALT | GOTO Label
type Program = [Instr]
--END

--BEGIN: Input and Output are both represented as [Char].
type Input = [Char]
type Output = [Char]
--END

--BEGIN: The registers taken as a whole are called memory. Given the index, Memory returns the
--contents in the register with that index.
type Memory = RegIndex -> RegCtnt
--END

--BEGIN: A register machine is characterized by its alphabet, its memory, and its program; hence
--RegMach is represented by the triple (Alphabet, Memory, Program).
--On the other hand, since all the registers except the one indexed by 0 (which contains the input)
--are empty initially, initial register machines, InitRegMach, are represented as a triple consisting
--of the alphabet, the input, and the program, which are necessary information for starting a register
--machine, with the memory left out since it is not informative for this purpose.
type RegMach = (Alphabet, Memory, Program)
type InitRegMach = (Alphabet, Input, Program)
--END

--BEGIN: Flag indicates whether the arguments to this interpreter program are valid. Message hints at
--invalid arguments (if any).
type Flag = Bool
type Message = [Char]
--END

--BEGIN: Auxiliary function, locates the first position where x occurs in the list xs (if any), and
--returns -1 if no such x occurs.
pos :: (Eq a) => a -> [a] -> Int
pos x xs = head ([i | (i, y) <- zip [0 .. ] xs, x == y] ++ [-1])
--END

--BEGIN: A family of invalid functions: invalidAB checks whether the alphabet contains repeated
--occurrences of characters; invalidInp checks the input against the alphabet whether it contains
--symbols other than those of the alphabet, assuming the alphabet valid; invalidP checks the program
--whether it misses the HALT instruction at the end, contains the HALT instruction with invalid
--labels, or contains in it an invalid instruction, with the help of invalidIns, assuming both the
--alphabet and the input valid. invalid simply combines all three.
invalidAB :: Alphabet -> (Flag, Message)
invalidAB a = if null (filter (/= -1) [pos x (drop i a) | (i, x) <- zip [1 .. ] a])
               then (False, "")
               else (True, "repeated occurrences of symbols in alphabet")

invalidInp :: Alphabet -> Input -> (Flag, Message)
invalidInp _  []      = (False, "")
invalidInp [] (_ : _) = (True, "empty alphabet, nonempty input")
invalidInp a  i       = if null (filter (== -1) [pos x a | x <- i])
                         then (False, "")
                         else (True, "invalid symbol(s) in input against alphabet")

invalidIns :: Alphabet -> Int -> Int -> Instr -> (Flag, Message)
invalidIns [] _ _ (ADD _ _) = (True, "no ADD is allowed with empty alphabet")
invalidIns [] _ _ (SUB _ _) = (True, "no SUB is allowed with empty alphabet")
invalidIns a l pl (ADD i s) = if l < pl - 1
                               then if i < 0
                                     then (True, "invalid register index")
                                     else if length s /= 1 || (pos (s !! 0) a) == -1
                                           then (True, "invalid symbol")
                                           else (False, "")
                               else (True, "no HALT at the end")
invalidIns a l pl (SUB i s) = if l < pl - 1
                               then if i < 0
                                     then (True, "invalid register index")
                                     else if length s /= 1 || (pos (s !! 0) a) == -1
                                           then (True, "invalid symbol")
                                           else (False, "")
                               else (True, "no HALT at the end")
invalidIns a l pl (IF i b)  = if l < pl - 1
                               then if i < 0
                                     then (True, "invalid register index")
                                     else if length b /= length a + 1
                                           then (True, "invalid branch degree")
                                           else if null (filter (< 0) b) && null (filter (>= pl) b)
                                                 then (False, "")
                                                 else (True, "label out of bound")
                               else (True, "no HALT at the end")
invalidIns a l pl PRINT     = if l < pl - 1
                               then (False, "")
                               else (True, "no HALT at the end")
invalidIns a l pl HALT      = if l == pl - 1
                               then (False, "")
                               else (True, "HALT not allowed here")
invalidIns a l pl (GOTO l') = if l < pl - 1
                               then if l' < 0 || l' >= pl
                                     then (True, "label out of bound")
                                     else (False, "")
                               else (True, "no HALT at the end")

invalidP :: Alphabet -> Program -> (Flag, Message)
invalidP a p =
 case [l | l <- [0 .. length p - 1], fst (invalidIns a l (length p) (p !! l)) == True] of
  [] -> (False, "")
  v  -> let l' = v !! 0
         in let (_, m) = invalidIns a l' (length p) (p !! l')
             in (True, "invalid program, label " ++ show l' ++ ": " ++ m)

invalid :: InitRegMach -> (Flag, Message)
invalid (a, i, p) = case invalidAB a of
                     (f, m) -> if f
                                then (True, m)
                                else case invalidInp a i of
                                      (f', m') -> if f'
                                                   then (True, m')
                                                   else case invalidP a p of
                                                         (f'', m'') -> if f''
                                                                        then (True, m'')
                                                                        else (False, "")
--END

--BEGIN: The contents of a void register is the empty string "".
emptyMem :: Memory
emptyMem n = ""
--END

--BEGIN: Writing the register with the given content.
extendMem :: RegIndex -> RegCtnt -> Memory -> Memory
extendMem ri ricnt mem rj | rj == ri  = ricnt
                          | otherwise = mem rj
--END

--BEGIN: If the instruction labelled l is HALT, then exec simply returns the current output. Otherwise
--it executes that instruction, given the register machine (which contains the alphabet, the memory,
--and the whole program), the label (which corresponds to the instruction being executed), and the
--current output (in case of need to update the output, that is, when it encoutners the PRINT
--instruction). After that, it executes the next instruction according to the new label ((b !! i) for
--IF, l' for GOTO, and (l + 1) for others) with the updated memory, the updated output, by invoking
--itself. It assumes that all arguments valid.
exec :: RegMach -> Label -> Output -> Output
exec (a, m, p) l o = case (p !! l) of
                      (ADD r s) -> exec (a, (extendMem r (m r ++ s) m), p) (l + 1) o
                      (SUB r s) -> if length (m r) > 0 && last (m r) == (s !! 0)
                                    then exec (a, (extendMem r (init (m r)) m), p) (l + 1) o
                                    else exec (a, m, p) (l + 1) o
                      (IF r b)  -> if null (m r)
                                    then exec (a, m, p) (b !! 0) o
                                    else let s = (pos (last (m r)) a) + 1
                                          in exec (a, m, p) (b !! s) o
                      PRINT     -> exec (a, m, p) (l + 1) (o ++ (m 0))
                      HALT      -> o
                      (GOTO l') -> exec (a, m, p) l' o
--END

--BEGIN: The main function of this interpreter program. Given the initial register machine as an 
--argument, if it is valid, then start starts interpreting by invoking exec with empty memory, with
--the label set to 0 (that is, the label of the first instruction), and with the output set to the
--empty string (initial state of a register machine). If otherwise the argument is invalid, then it
--simply aborts after delivering the error message. 
start :: InitRegMach -> Output
start (a, i, p) = case invalid (a, i, p) of
                   (f, m) -> if f
                              then error m
                              else exec (a, (extendMem 0 i emptyMem), p) 0 "" 
--END

{-
Sample (initial) register machines.
  1) sample0 prints as output the string "aabaab".
  2) sample1 tests whether the input string is "002" (it is in this case): it stops if the answer is
       yes, and loops forever otherwise.
  3) sample2 tests whether the input string is an "even" number (it is not in this case): here a
       natural number n is represented as a string "11..1" of length n over the singleton alphabet "1"
       This register machine prints as output the empty string "" if the input is even and the string
       "1" if the input is odd.
-}

sample0 :: InitRegMach
sample0 = ("abc", "", [ADD 0 "a", ADD 0 "a", ADD 0 "b", SUB 1 "c", IF 1 [5, 6, 6, 6], PRINT, PRINT, HALT])

sample1 :: InitRegMach
sample1 = ("012", "002", [IF 0 [7, 7, 7, 1], SUB 0 "2", IF 0 [7, 3, 7, 7], SUB 0 "0", IF 0 [7, 5, 7, 7], SUB 0 "0", IF 0 [8, 7, 7, 7], GOTO 7, HALT])


sample2 :: InitRegMach
sample2 = ("1", "111", [IF 0 [6, 1], SUB 0 "1", IF 0 [5, 3], SUB 0 "1", IF 0 [6, 1], ADD 0 "1", PRINT, HALT])


sample3 :: InitRegMach
sample3 = ("01", "011", [IF 0 [9, 1, 5], SUB 0 "0", ADD 1 "0", ADD 2 "0", GOTO 0, SUB 0 "1", ADD 1 "1", ADD 2 "1", GOTO 0, IF 1 [16, 10, 13], SUB 1 "0", ADD 0 "0", GOTO 9, SUB 1 "1", ADD 0 "1", GOTO 9, IF 2 [23, 17, 20], SUB 2 "0", ADD 0 "0", GOTO 16, SUB 2 "1", ADD 0 "1", GOTO 16, PRINT, HALT])

sample4 :: InitRegMach
sample4 = ("012", "12", [IF 0 [0, 1, 1, 1], HALT, PRINT])

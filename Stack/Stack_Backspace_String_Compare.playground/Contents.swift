import Cocoa

// MARK: - Problem Statement

/*
 Goal:
 Given two strings containing letters and '#',
 determine if they are equal after applying backspaces.
 
 Constraints:
 - 1 <= s.length, t.length <= 100,000
 - '#' removes the previous character if it exists
 
 Example:
 Input: s = "ab#c", t = "ad#c"
 Output: true
 
 Explanation:
 Each string is processed as if typed into a text editor where '#' represents a backspace.
 
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 Determine if two strings, s and t, are equal after simulating backspace operations ('#').
 Each '#' removes the previous character if it exists.
 
 Example:
 Input: s = "ab#c", t = "ad#c"
 Output: true  -> After processing: "ac" == "ac"
 
 - Obvious Approach:
 - Convert both strings into character arrays for easier manipulation.
 - Use a pointer to traverse each array.
 - If the current character is '#':
 - Remove the '#' itself.
 - Remove the previous character if it exists.
 - Adjust the pointer to account for removed elements.
 - Otherwise, move the pointer forward.
 - After processing both arrays, convert them back to strings and compare for equality.
 
 - Performance Analysis:
 
 Time Complexity: O(n + m)
 - n and m are the lengths of s and t.
 - Each element is processed at most once.
 
 Space Complexity: O(n + m)
 - Extra space is needed to store the processed characters in new arrays.
 */
func bruteForce(s: String, t: String) -> Bool {
    
    func process(_ s:String) -> String{
        var arr = Array(s)
        var pointer = 0
        
        while pointer < arr.count{
            
            if arr[pointer] == "#" {
                arr.remove(at: pointer)
                
                if pointer > 0{
                    arr.remove(at: pointer - 1)
                    pointer -= 1
                }
            } else {
                pointer += 1
            }
            
        }
        return String(arr)
        
    }
    
    return process(s) == process(t)
}

bruteForce(s:"ab#c", t:"ad#c")



// MARK: - Phase 2: Manual Tracing

/*
 Example:
 Input: s = "ab#c", t = "ad#c"
 Output: true  -> After processing: "ac" == "ac"
 
 Invariant:
 After scanning up to index i in the string:
 - The result array contains exactly the characters that remain after applying all backspaces up to i.
 - No '#' remains in the result array.
 
 Step-by-Step Trace:
 
 Processing string s:
 
 1. Initial array: ["a", "b", "#", "c"], pointer = 0
 - Current char: "a" → not '#', increment pointer → pointer = 1
 
 2. Array: ["a", "b", "#", "c"], pointer = 1
 - Current char: "b" → not '#', increment pointer → pointer = 2
 
 3. Array: ["a", "b", "#", "c"], pointer = 2
 - Current char: "#" → remove '#' and previous char "b"
 - Array becomes ["a", "c"]
 - Move pointer back to 1 (to point to "c")
 
 4. Array: ["a", "c"], pointer = 1
 - Current char: "c" → not '#', increment pointer → pointer = 2
 
 5. Pointer = 2 → equals array count, stop processing
 - Processed s = "ac"
 
 Processing string t:
 
 1. Initial array: ["a", "d", "#", "c"], pointer = 0
 - Current char: "a" → not '#', increment pointer → pointer = 1
 
 2. Array: ["a", "d", "#", "c"], pointer = 1
 - Current char: "d" → not '#', increment pointer → pointer = 2
 
 3. Array: ["a", "d", "#", "c"], pointer = 2
 - Current char: "#" → remove '#' and previous char "d"
 - Array becomes ["a", "c"]
 - Move pointer back to 1 (to point to "c")
 
 4. Array: ["a", "c"], pointer = 1
 - Current char: "c" → not '#', increment pointer → pointer = 2
 
 5. Pointer = 2 → equals array count, stop processing
 - Processed t = "ac"
 
 Final Comparison:
 - Processed s = "ac"
 - Processed t = "ac"
 - Result = true
 */

// MARK: - Phase 3: Pattern Discovery

/*
 Pattern Discovery from Phase 2: Manual Tracing
 
 Problem Insight:
 Each '#' depends on recent history — it removes the previous character.
 This makes a stack the ideal data structure for managing this “recent state.”
 
 Implementation Pattern:
 
 1) Initialize an empty stack.
 2) Convert the input string to an array (or iterate directly over characters).
 3) Traverse the array:
 a) If the current character is '#', remove the top of the stack (if it exists).
 b) Otherwise, push the current character onto the stack.
 4) After processing all characters, convert the stack to a string.
 5) Repeat the same process for the second string, then compare the results for equality.
 
 Invariant:
 - At any point during traversal, the stack contains all characters that remain after applying backspaces up to that index.
 - Each operation modifies only the top of the stack.
 
 Benefits of This Pattern:
 - Efficient: O(n) time, O(n) space
 - Clear and maintainable
 - Avoids messy pointer manipulations
 - Reusable for any problem where the current state depends on recent history
 
 Mini-Example:
 Input: "ab#c"
 Stack progression:
 push 'a' → ['a']
 push 'b' → ['a','b']
 '#' → pop 'b' → ['a']
 push 'c' → ['a','c']
 Final result: "ac"
 */

// MARK: - Phase 4: Optimized Stack Solution

func stack(s: String, t: String) -> Bool {
    
    func process(_ s: String) -> String {
        var stack: [Character] = []
        
        for char in s {
            
            if char != "#"{
                stack.append(char)
            } else if !stack.isEmpty {
                stack.removeLast()
            }
        }
        
        return String(stack)
    }
    
    return process(s) == process(t)
}

stack(s:"ab#c", t:"ad#c")

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n + m)
    → n = length of s, m = length of t
    → We traverse each string once, processing each character at most once.

 Space Complexity: O(n + m)
    → We use a stack (array) to store the processed characters of each string.
    → In the worst case, if there are no backspaces, the stack will store all characters.
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:

 - Using a stack allows us to efficiently track and remove the most recent character in linear time.
 
 - This problem fits the classic stack pattern because encountering a "#" requires removing the most recent character (LIFO behavior).
 
 - Recognizing this problem as history-dependent makes it clear that a stack is the appropriate data structure.

 - Key takeaway: When the current state depends on recent history, consider using a stack.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*
 
 Input: s = "ab#c", t = "ad#c"
 Output: true
 
 Invariant:
    - The stack always represents the processed string so far.
 
 Key Insight:
    - At each step, we check for backspace and once found, we pop top of the stack

 --------------------------------------------------
 */

func optimized(s: String, t: String) -> Bool {
    
    func process(_ str:String) -> String {
        var stack:[Character] = []
        
        for char in str {
            if char == "#" {
                if !stack.isEmpty {
                    stack.popLast()
                }
            } else {
                stack.append(char)
            }
        }
        
        return String(stack)
    }
    
    
    return process(s) == process(t)
    
}

optimized(s: "ab#c", t: "ad#d#c")

/*
 Phase 7 Validation Trace
 
 Input: s = "ab#c", t = "ad#d#c"
 
 Processing s: "ab#c"
 Step 1:
     stack = []
     current = a
     char is not # -> append to stack -> ["a"]
     current stack -> ["a"]
 Step 2:
     stack = ["a"]
     current = b
     char is not # -> append to stack -> ["a", "b"]
     current stack -> ["a", "b"]
 Step 3:
     stack = ["a", "b"]
     current = #
     char is # and stack not empty -> pop from stack -> ["a"]
     current stack -> ["a"]
 
 Step 4:
     stack = ["a"]
     current = c
     char is not # -> append  to stack -> ["a", "c"]
     current stack -> ["a", "c"]
 
 Final traversal done -> convert stack to string -> "ac"
 
 Processing s: "ad#d#c"
 Step 1:
     stack = []
     current = a
     char is not # -> append to stack -> ["a"]
     current stack -> ["a"]
 Step 2:
     stack = ["a"]
     current = d
     char is not # -> append to stack -> ["a", "d"]
     current stack -> ["a", "d"]
 Step 3:
     stack = ["a", "d"]
     current = #
     char is # and stack not empty -> pop from stack -> ["a"]
     current stack -> ["a"]
 
 Step 4:
     stack = ["a"]
     current = d
     char is not # -> append  to stack -> ["a", "d"]
     current stack -> ["a", "d"]
 
 Step 5:
     stack = ["a", "d"]
     current = #
     char is # and stack not empty -> pop from stack -> ["a"]
     current stack -> ["a"]
 
 Step 6:
     stack = ["a"]
     current = c
     char is not # -> append  to stack -> ["a", "c"]
     current stack -> ["a", "c"]
 
 Final traversal done -> convert stack to string -> "ac"
 
 
 Finished processing s and t -> checking s == t -> "ac" == "ac" -> true
 
 Invariant: The stack always represents the processed string so far.
 
 --------------------------------------------------
 
 */

// MARK: - Problem Statement

// MARK: Valid Parentheses
/*
 Goal:
     Given a string containing only parentheses characters, determine if the input string is valid.

 Constraints:
     - 1 <= s.length <= 10^5
     - s contains only '(', ')', '{', '}', '[', ']'

 Example:
     Input: s = "()[]{}"
     Output: true

 Explanation:
     Each opening bracket must be closed by the same type and in the correct order.
*/



// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:

 What am I trying to find?

    Determine if a given input string containing only parentheses is valid.
    A string is valid IFF:
      - Every opening bracket has a corresponding closing bracket.
      - Brackets are closed in the correct order.

    Examples:
      - Input: "()[]{}" → TRUE
        Explanation: Each opening bracket is properly closed.
      
      - Input: "([)] []{}" → FALSE
        Explanation: Even though each type of bracket exists, the order is wrong:
                     '(' is closed after '[', and '[' is closed after ')'.
                     Proper nesting is violated.

 Obvious brute force approach:

    - Convert the string to an array of characters for easier scanning.
    - Iterate through the array and repeatedly remove adjacent valid pairs: "()", "[]", "{}".
    - Use a pointer `i` to check each element with its neighbor (`i+1`).
    - If a valid pair is found:
        • Remove both elements from the array.
        • Restart scanning from the beginning.
    - Continue until no more pairs can be removed.

    At the end:
      - If the array is empty → string is valid.
      - If not → string is invalid.

 Why this is slow:

    - Time complexity: O(n²)
      • We may need to scan the string n times in the worst case.
    - Space complexity: O(n)
      • We store the characters in an array for faster access and modification.

 Notes / Edge Cases:

    - Must ensure we never access out-of-bounds elements when checking pairs (`i+1`).
    - This approach works for small inputs but becomes inefficient for large strings.
    - It also serves as a stepping stone to the optimized stack-based solution,
      which correctly handles nested and ordered brackets in O(n) time.
*/


func bruteForce(_ str: String) -> Bool {
     var chars = Array(str)
     var changes = true
    
    while changes {
        changes = false
        var i = 0
        
        while i < chars.count - 1 { // avoid out-of-bounds
            let pair = String([chars[i], chars[i+1]])
            
            if pair == "()" || pair == "{}" || pair == "[]" {
                chars.remove(at: i + 1)
                chars.remove(at: i)
                changes = true
                break // restart scanning
            } else {
                // pair == "(]"
                i += 1
            }
        }
    }
    
 
    return chars.isEmpty
}

bruteForce("()[]{}")

// MARK: - Phase 2: Manual Tracing

/*
 Goal: Understand exactly how the brute force pair-removal algorithm works.

 Input: s = "()[]{}"
 
 1) Convert string to array: ["(", ")", "[", "]", "{", "}"]

 1st Iteration:
    - changes = false
    - Check pair at i=0: "(" + ")" → match "()"
        • Remove both elements
        • changes = true → break
    - Updated array: ["[", "]", "{", "}"]

 2nd Iteration:
    - changes = false
    - Check pair at i=0: "[" + "]" → match "[]"
        • Remove both elements
        • changes = true → break
    - Updated array: ["{", "}"]

 3rd Iteration:
    - changes = false
    - Check pair at i=0: "{" + "}" → match "{}"
        • Remove both elements
        • changes = true → break
    - Updated array: []

 ✅ Array is empty → return true → input is valid
*/

// MARK: - Phase 3: Pattern Discovery

/*
 Observations from the brute force algorithm:

 - Convert string to array
 - Check each pair at i and i+1
 - Remove both elements

 Time complexity: O(n^2)
    - Scanning each pair: O(n)
    - Removing elements: O(n)

 Can we do better? ✅ Yes.

 Pattern discovered:

 1) Opening brackets must appear before their corresponding closing brackets.
 2) The most recently opened bracket must be closed first → Last-In, First-Out pattern.
 3) Instead of rescanning and removing pairs, we can use:
      - A stack to track open brackets
      - A hash map for constant-time matching of pairs

 Stack-based approach:

 - Push every opening bracket onto the stack.
 - For each closing bracket:
     • If the top of the stack matches the expected opening bracket, pop it.
     • Otherwise, return false immediately.
 - At the end:
     • If the stack is empty → all brackets matched → return true.
     • Otherwise → return false.
*/

// MARK: - Phase 4: Optimized Stack Solution

/*
 Stack-based solution:

  Initialize:
    - An empty stack: []
    - A set of opening parentheses: ["(", "{", "["]
    - A dictionary mapping closing → opening: [")":"(", "}":"{", "]":"["]

 Traverse each character in the string:

    - If the character is an opening parenthesis (exists in the opening set):
        • Push it onto the stack

    - Else (character is a closing parenthesis):
        • Look up the expected opening bracket in the dictionary
        • Check if the top of the stack matches the expected opening
            - If yes: pop the top element from the stack
            - If no: return false immediately (mismatched parentheses)

 After traversal:
    - If the stack is empty → all brackets matched → return true
    - If the stack is not empty → unmatched opening brackets remain → return false
*/

func stack(_ str: String) -> Bool {
    var stack: [Character] = []
    
    var opening: Set<Character> = ["(", "{", "["]
    var matching: [Character: Character] = [")": "(", "}":"{", "]" : "["]
    
    for char in str {
        if opening.contains(char) {
            stack.append(char)
        } else if let expectedOpen = matching[char] {
            guard let last = stack.last, last == expectedOpen else {
                return false
            }
            stack.removeLast()
        }
    }
    return stack.isEmpty
}

stack("()[]{}")

// MARK: - Phase 5: Complexity Analysis

/*
 Stack-based approach advantages:

 - Time complexity: O(n) → single traversal of the string
 - Space complexity: O(n) → stack stores unmatched opening brackets
 - Handles nested and consecutive brackets efficiently
 - Eliminates the need for repeated rescanning and element removals
 - Correctly validates all cases, including nested and consecutive brackets

 Compared to the brute force approach, this reduces time complexity from O(n^2) → O(n)
 and makes reasoning about bracket matching straightforward
*/

// MARK: - Phase 6: Final Insight

/*
 Key takeaways from solving the valid parentheses problem:

 - Using a stack allows checking the string in a single traversal,
    eliminating rescanning and array removals, and reducing time complexity to O(n)
 - Hash maps and hash sets enable constant-time lookups for matching parentheses
 - Systematically breaking down the problem (brute force → pattern discovery → optimized solution)
   helps understand both correctness and efficiency
*/

// MARK: - Phase 7: Re-Code (After Break)

/*
 Goal:
     Re-implement the optimized solution after a long break
     without referencing previous phases.

 Rules:
     - No peeking at Phase 4
     - Logic must be reconstructed mentally
     - If stuck, write reasoning before code

 Validation:
     - Code matches expected output
     - Invariant can be verbally explained
     - Time & space complexity are justified
*/


func optimized(_ str: String) -> Bool {
    var str: [Character] = Array(str)
    var stack: [Character] = []
    var opening: Set<Character> = ["(", "{", "["]
    var matching: [Character: Character] = [")": "(", "}":"{","]":"["]
    
    
    for char in str {
        if opening.contains(char) {
            stack.append(char)
        } else if let expectedOpen = matching[char] {
            guard let last = stack.last, last == expectedOpen else {
                return false
            }
            
            stack.removeLast()
        }
    }
    
    return stack.isEmpty
}


optimized("()[]{}")

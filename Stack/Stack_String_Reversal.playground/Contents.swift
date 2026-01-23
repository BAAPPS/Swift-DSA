// MARK: - Problem Statement

// MARK: Reverse a String Using Stack

/*
 Goal:
     Given a string, reverse it using a stack.

 Constraints:
     - 1 <= s.length <= 10^5
     - s contains printable ASCII characters

 Example:
     Input: s = "swift"
     Output: "tfiws"

 Explanation:
     Characters pushed into a stack are retrieved in reverse order due to the Last-In-First-Out property.

*/


// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 - What am I trying to find?
 
    The reverse ordering of our given input
 
    Example:
     Input: s = "taylor"
     Output: "rolyat"
     
 - Obvious approach
    
    - Convert the string into an array of characters
 
    - Traverse the string starting from the end
 
    - Add each character to our result array
 
    - Return the result and convert it to a String
 
 - Why this is slow
 
    - Time Complexity: O(n)
        • Single pass through the characters

    - Space Complexity: O(n)
        • Extra array to store reversed characters
*/

func bruteForce(_ str: String) -> String {
    var result:[Character] = []
    var chars = Array(str)
    
    
    for i in stride(from: chars.count - 1, through: 0, by: -1) {
        let char = chars[i]
        result.append(char)
    }
 
    return String(result)
}

bruteForce("taylor")

// MARK: - Phase 2: Manual Tracing

/*
 Goal: Understand exactly how the brute force string reversal works.
 
 Input: s = "taylor"
 
 1) Convert the string to array: ["t", "a", "y", "l", "o", "r"]
 
 2) Variable result = []
 
 1st Iteration:
 
    - ["t", "a", "y", "l", "o", "r"]
                                 _
    - Traverse backwards starting with r
 
     - Append it to result array

     - result = ["r"]
 
 2nd Iteration:
 
    - ["t", "a", "y", "l", "o", "r"]
                            _
    - Traverse backwards starting with o
 
    - Append it to result array
 
    - result = ["r","o"]
 
 3rd Iteration:
 
    - ["t", "a", "y", "l", "o", "r"]
                       _
    - Traverse backwards starting with l
 
     - Append it to result array

     - result = ["r","o", "l"]
 
 4th Iteration:
 
    - ["t", "a", "y", "l", "o", "r"]
                  _
    - Traverse backwards starting with y
 
     - Append it to result array

     - result = ["r","o", "l", "y"]

 
 5th Iteration:
 
    - ["t", "a", "y", "l", "o", "r"]
             _
    - Traverse backwards starting with a
 
    - Append it to result array

    - result = ["r","o", "l", "y", "a"]

 
 6th Iteration:
 
    - ["t", "a", "y", "l", "o", "r"]
        _
    - Traverse backwards starting with t
 
     - Append it to result array

     - result = ["r","o", "l", "y", "a", "t"]
 
 
    Final string after conversion = "rolyat"
 
*/

// MARK: - Phase 3: Pattern Discovery

/*
 Observations from the brute force algorithm:

 - Characters are accessed from the end toward the beginning
 - The last element added is the first one used
 - This matches a LIFO (Last In, First Out) pattern

 Time Complexity:
 - O(n)
   • Each character must be visited once
   • This is optimal for string reversal

 Pattern Discovered:

 1) A stack naturally supports reverse order processing
 2) The character array can be treated as a stack
 3) Repeatedly popping from the stack reverses the order

 Stack-Based Approach:

 - Convert the string into an array of characters (stack)
 - While the stack is not empty:
     • Pop the last character
     • Append it to the result array
 - Convert the result array into a String
*/

// MARK: - Phase 4: Pattern-Based Stack Solution

/*
 Stack-based solution:

 Initialize:
   - Convert the string into an array of characters (stack)
   - Create a result array to store reversed characters

 While the stack is not empty:
   - Pop the top character
   - Append it to the result array

 After traversal:
   - Convert the result array into a String
   - The string is now reversed
*/

func stack(_ str: String) -> String {
    var result: [Character] = []
    var stack = Array(str)

    while !stack.isEmpty {
        let current = stack.removeLast()
        result.append(current)
    }

    return String(result)
}


stack("taylor")

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity:
 - O(n)
   • Each character is processed exactly once
   • One pop and one append per character

 Space Complexity:
 - O(n)
   • Stack stores n characters
   • Result array stores n characters
*/


// MARK: - Phase 6: Final Insight

/*
 Key takeaways from reversing a string:

 - Problems that require processing elements in reverse order
   often match a LIFO (stack) pattern

 - Using a stack does not improve time complexity here,
   but it provides a clearer mental model for reverse traversal

 - Breaking the problem into phases (brute force → tracing →
   pattern discovery → implementation) prevents guessing
   and builds long-term intuition

 - Always identify whether a solution is clearer, faster,
   or simply a different expression of the same complexity
 */

// MARK: - Phase 7: Re-Code (After Break)

/*
 Goal:
 Re-implement the pattern-based solution from memory
 after a meaningful break (6–24 hours), without referencing previous phases.

 Rules:
 - No peeking at Phase 4 or earlier
 - Reconstruct the algorithm mentally first
 - If stuck, write the invariant and reasoning before coding

 Validation:
 - Output matches expected results
 - Invariant can be explained verbally
 - Time and space complexity are justified
*/


func optimized(_ str: String) -> String {
    var stack = Array(str)
    var result:[Character] = []
    
    while !stack.isEmpty {
        let currentChar = stack.removeLast()
        result.append(currentChar)
    }

    return String(result)
}

optimized("taylor")

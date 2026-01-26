// MARK: - Problem Statement
/*
 Goal:
     Given a string, repeatedly remove adjacent duplicate characters until no such duplicates remain.

 Constraints:
     - 1 <= s.length <= 100,000
     - s contains lowercase English letters

 Example:
     Input: "abbaca"
     Output: "abaca"

 Explanation:
     When two adjacent characters are the same, both are removed, which may expose new duplicates.

*/

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
    
    The removal of consecutive duplicate characters in the given string
 
    Example:
     Input: "abbbaaca"
     Output: "abaca"

 - Obvious approach
    
    The most obvious approach:
 
    - Convert string into character array for easier indexed traversal
    
    - Create a result array to append non-duplicate characters found
 
    - Create a pointer to traverse the current character of our converted array
 
    - Traverse until the pointer exceeds the length of the character array
 
    - As we traverse, we check the following:
 
        - If the array is initially empty, append the current character
 
            - This will store the first character,
            allowing us to compare the current character with the last stored character

 
        - Otherwise, we check:
            - If the current character is not the same as the last stored character
                - Append it to the array
                - Otherwise, we skip
 
    - After traverse, we convert the result array to a string
 
 
 - Performance Analysis
 
    Time Complexity: O(n)
     - We traverse the string once
     - Each character is processed in constant time

    Space complexity: O(n)
     - This is due to the final result being stored in a new array
 
 - Note:
     While this solution is already O(n), we label it as "Phase 1: Brute Force Attempt"
     because it represents the initial, straightforward approach to the problem.
     Phase 4 will explore further optimization or alternate approaches if needed.
*/

func bruteForce(_ str: String) -> String {
    var chars = Array(str)
    var result:[Character] = []
    var i: Int = 0
    
    while i < chars.count{
        let current = chars[i]
        
        if result.isEmpty {
            result.append(current)
        } else {
            if current != result.last {
                result.append(current)
            }
        }
       
        i+=1
    }
    
    return String(result)
}

bruteForce("abbbaaca")



// MARK: - Phase 2: Manual Tracing

/*
 Example:
    - Input: "abbbaaca"
 
 Invariant:
    - result never contains consecutive duplicate characters

 1st Iteration:
 
    result = []
    current = "a"
    result is empty -> append
        - ["a"]
     i+=1
 
 2nd Iteration:

    result = ["a"]
    current = "b"
    result not empty
        - Check current ("b") vs result.last ("a")
        - Append: ["a", "b"]
    i+=1
 
 
 3rd Iteration:

    result = ["a","b"]
    current = "b"
    result not empty
        - Check current ("b") vs result.last ("b")
        - Skip
    i+=1
 
 4th Iteration:

    result = ["a","b"]
    current = "b"
    result not empty
        - Check current ("b") vs result.last ("b")
        - Skip
    i+=1
 
 5th Iteration:

    result = ["a","b"]
    current = "a"
    result not empty
        - Check current ("a") vs result.last ("b")
        - Append: ["a", "b", "a"]
    i+=1
 
 6th Iteration:

    result = ["a","b", "a"]
    current = "a"
    result not empty
        - Check current ("a") vs result.last ("a")
        - Skip
    i+=1
 
 7th Iteration:

    result = ["a","b", "a"]
    current = "c"
    result not empty
        - Check current ("c") vs result.last ("a")
        - Append: ["a", "b", "a", "c"]
    i+=1
 
 8th Iteration:

    result = ["a","b", "a", "c"]
    current = "a"
    result not empty
        - Check current ("a") vs result.last ("c")
        - Append: ["a", "b", "a", "c", "a"]
 
    Loop condition fails: i < chars.count

 Final: Result: ["a", "b", "a", "c", "a"] = "abaca"
*/


// MARK: - Phase 3: Pattern Discovery

/*
 Observations from the brute force algorithm:
 
    - Check if result array is empty before adding current character
 
    - Check if current character is the same as the last character in result array
 
    - Pointer usage to traverse the chars array
 
 
 Time Complexity:
    - O(n)
     •  We traverse the string once
     •  Each character is processed in constant time

 Pattern Discovery:
 
  1) A stack naturally allows us to check the top
 
  2) Using the stack allows safe comparison with the top element without extra bounds checks

  3) Treat result array as a stack to either push or skip after checking top
 
 Stack-based approach:
 
    - Convert string into character array for easier indexed traversal
 
    - Create a result array to append non-duplicate characters found (stack)
 
    - Traverse the character array from left to right:
 
        • For each character:
             - If stack is empty or current != stack.top → push
             - Else → skip

    - After traversal, convert the stack to a string
    
*/

// MARK: - Phase 4: Optimized Stack Solution

func stack(_ str: String) -> String {
    var chars = Array(str)
    var result: [Character] = []
    
    for char in chars {
        if let last = result.last, last == char {
            continue
        }
        result.append(char)
        
    }

    return String(result)
}

stack("abbbaaca")

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
    → each character visited once

 Space Complexity: O(n)
    → result array stores non-duplicate characters

 Why:
 - Each index pushed and popped once
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:
 
 - Using a stack (or array treated as a stack) allows us to check the top element
   easily using `.last` to detect consecutive duplicates.

 - Converting an array of characters back to a string can be done with `String(array)`.

 - Problems that require removing adjacent duplicates naturally follow a LIFO (stack) pattern.

 - While using a stack does not improve the time complexity for this problem (still O(n)),
   it provides a clear and simple mental model for traversal and duplicate removal,
   making the solution easier to understand and reason about.
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
    var chars = Array(str)
    var stack: [Character] = []
    
    for char in chars {
        
        if let last = stack.last, last == char {
            continue
        }
    
        stack.append(char)
        
    }
    
return String(stack)
}

optimized("abbaca")

/*
 Phase 7 Validation Trace

 Input: "abbaca"
 Converted to array:
 ["a", "b", "b", "a", "c", "a"]

 Invariant:
 - Stack never contains consecutive duplicate characters
 - Stack represents the processed prefix of the string
 
 Key Insight:
 - At each step, we only need to compare the current character
     with the most recent kept character (stack top),
     which guarantees O(n) time with single pass.

 --------------------------------------------------

 Step 1:
 Stack before: []
 Current char: "a"

 Action:
 - Stack is empty → push

 Stack after:
 ["a"]

 --------------------------------------------------

 Step 2:
 Stack before: ["a"]
 Current char: "b"

 Action:
 - Top ("a") != current ("b") → push

 Stack after:
 ["a", "b"]

 --------------------------------------------------

 Step 3:
 Stack before: ["a", "b"]
 Current char: "b"

 Action:
 - Top ("b") == current ("b") → skip

 Stack after:
 ["a", "b"]

 --------------------------------------------------

 Step 4:
 Stack before: ["a", "b"]
 Current char: "a"

 Action:
 - Top ("b") != current ("a") → push

 Stack after:
 ["a", "b", "a"]

 --------------------------------------------------

 Step 5:
 Stack before: ["a", "b", "a"]
 Current char: "c"

 Action:
 - Top ("a") != current ("c") → push

 Stack after:
 ["a", "b", "a", "c"]

 --------------------------------------------------

 Step 6:
 Stack before: ["a", "b", "a", "c"]
 Current char: "a"

 Action:
 - Top ("c") != current ("a") → push

 Stack after:
 ["a", "b", "a", "c", "a"]

 --------------------------------------------------

 Final Result:
 Convert stack to string → "abaca"
*/

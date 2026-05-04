// MARK: - Problem Statement
/*
 MARK: - Proble: Remove All Adjacent Duplicates

 Goal:
 Repeatedly remove adjacent duplicates until none remain.
 
 Example:
 Input:  "abbaca"
 Output: "ca"
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
    
    Repeatedly remove adjacent duplicates until none remain.

 - Obvious approach
 
    The most obvious approach:
 
        - Convert the given string to array of characters for faster scanning
 
        - Create a boolean variable "changed" and set it to true to repeatedly scan for adjacent pairs
 
        - while changed is true:
 
            - Start by assuming no changed has happend (changed = false)
 
            - Scan the string from left to right looking for the first pair of adjacent pair
                - If adjcacent pair is found:
                 - Remove both characters
                 - Set changed = true (because we modified the string)
                 - Break the loop early to restart scanning from the beginning

 

 - Performance Analysis
 
    - Time Complexity:  O(n²)
    
         - Inner loop → O(n)
         - Each removal → O(n) due to shifting

    - Space Complexity: O(n)
        - Converting into a new array cost extra storage
 
 */

func bruteForce(_ input: String) -> String {
    var chars = Array(input)
    var changed = true
    
    while changed {
       changed = false
        for i in 0..<chars.count - 1 {
            if chars[i] == chars[i+1] {
                chars.remove(at:i+1)
                chars.remove(at:i)
                changed = true
                break
            }
        }

    }
    
    return String(chars)
}
var str =  "abbaca"

bruteForce(str)



// MARK: - Phase 2: Manual Tracing

/*
 Example:
 Input:  "abbaca"
 Output: "ca"
 
 Invariant:
    - At the start of each scan, we have not yet checked for adjacent duplicates in the current version of the array.
 ----------------------------------------------------

 Initial:
 
 chars = ["a","b","b","a","c","a"]
 changed = true
 ----------------------------------------------------
 Pass 1:
 changed = false

 i = 0
 "a" != "b" → continue

 i = 1
 "b" == "b" → remove

 chars = ["a","a","c","a"]
 changed = true
 → break (restart scan)

 --------------------------------------------------

 Pass 2:
 changed = false

 i = 0
 "a" == "a" → remove

 chars = ["c","a"]
 changed = true
 → break (restart scan)

 --------------------------------------------------

 Pass 3:
 changed = false

 i = 0
 "c" != "a" → continue

 (no more pairs found)

 --------------------------------------------------

 No changes in this pass → stop

 return "ca"
 
 */


// MARK: - Phase 3: Pattern Discovery

/*
 
 Observation from Brute Force:
 
 - For each character at index i, we compare the adjacent element (i+1)
 - If an adjacent pair has been found, we remove them and restart the scanning process from index 0 until no adjacent pair is found or loop reached count - 1

 ----------------------------------------------------
 
 Key Inefficiency:
 
   -  Using remove(at:) becomes very inefficent as the string grows, as all subsequent characters must be shifted left in O(n)
 
   - In cases with many adjacent pairs, multiple removals lead to an overall O(n²) time complexity
 
 ------------------------------------------------------------
 
 Key Insight (from tracing):
 
    - We only need to compare adjacent elements and not scan the entire string
 
    - Once adjacent pairs has been found and removed, we can compare the next adjacent element
 
    - The problem is now process adjacent pairs
 ------------------------------------------------------------
 
 Pattern Recognition:
 
    - The brute force approach can be optimzied using Two Pointer stack stimulation pattern
 
        - Slow pointer represent the top of the stack (write pointer)
 
        - Fast pointer scans the input (read pointer)
 
 ------------------------------------------------------------
 
 Data Structure Insight (toward optimal solution):
 
 - Iterate through the string using a faster pointer
 
 - The slow pointer represents the end of the current valid result
 
 - For each character:
 
    - If it matches the previous character (top of the stack):
 
        - Remove the duplicate by moving the slow pointer backward
 
    - Otherwise, we write the character at the slow pointer position and move the slow pointer forwards
 
 This way, we simulate adding and removing characters just like a stack, but in-place.
 
*/

// MARK: - Phase 4: Optimized Two Pointer Solution

func TwoPointer(_ input: String) -> String{
    var chars = Array(input)
    var slow = 0
    
    for fast in 0..<chars.count {
        
        if slow > 0 && chars[slow - 1] == chars[fast] {
            // perform pop stimulation
            slow -= 1
        } else {
            chars[slow] = chars[fast]
            slow += 1
        }
        
    }
    
    return String(chars[0..<slow])
    
}

var str1 =  "abbaca"


TwoPointer(str1)

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
 - Each character is processed at most once
 - Each character is either pushed or popped once

 Space Complexity: O(n)
 - We use an auxiliary array (or string as a stack) to store the result
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:

 The brute force approach repeatedly scans for adjacent duplicates and removes them using remove(at:), which causes O(n) shifts per removal. This leads to an overall O(n²) time complexity.

 ------------------------------------------------------------

 Core Insight:

 We only need to eliminate adjacent duplicates, not physically remove them during scanning.

 Instead of repeatedly modifying the structure, we can simulate the removal process while traversing once.

 ------------------------------------------------------------

 Pattern Recognition:

 This problem follows a stack pattern.

 We process characters from left to right and maintain a result:

 - If the current character matches the last added character, we remove the last character (simulate popping)

 - Otherwise, we add the current character (simulate pushing)

 ------------------------------------------------------------

 Two Pointer Interpretation:

 - Fast pointer scans the input
 - Slow pointer represents the end of the current valid result

 At each step:
 - If chars[fast] == chars[slow - 1]:
    → slow -= 1 (pop)
 - Else:
     → chars[slow] = chars[fast] (push)
     → slow += 1

 ------------------------------------------------------------

 Final Result:

 The valid result is stored in the range [0...slow)

 ------------------------------------------------------------

 Language Insight (Swift):

 Although this is a string problem, it cannot be efficiently
 implemented using String.Index for in-place mutation.

 This is because:
 - String does not support random access
 - String does not allow direct mutation at indices

 Therefore, we use:
 - Array for in-place simulation, or
 - String as a stack using append/removeLast
 
 ------------------------------------------------------------
 
 Pattern Learned:
 
 I learned that some problems that look like two-pointer problems are actually stack problems in disguise. Here, we simulate a stack using a write pointer for O(n) performance.

 I also learned that in Swift, even if the input is a String, we should switch to an Array or stack abstraction when we need random access and in-place updates, since String does not support those efficiently.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*
Invariant:

- At any point, chars[0..<slow] represents the current valid result
  with no adjacent duplicates.

------------------------------------------------------------

Key Insight:

- Convert the string into an array to enable in-place mutation

- Use two pointers to simulate a stack:
    - slow pointer (write pointer / stack top)
    - fast pointer (read pointer)

------------------------------------------------------------

Algorithm:

- Traverse the array using the fast pointer

    - If the current character matches the last written character:
        → simulate pop by decrementing slow

    - Otherwise:
        → write the current character at index slow
        → increment slow

------------------------------------------------------------

Final Result:

- The valid result is stored in chars[0..<slow]
*/

func optimized(_ input: String) -> String {
    var chars = Array(input)
    var slow = 0
    
    for fast in 0..<chars.count {
        if slow > 0 && chars[slow - 1] == chars[fast] {
            slow -= 1 // pop
        } else {
            chars[slow] = chars[fast] // push
            slow += 1
        }
    }
    
    return String(chars[0..<slow])
}

optimized("azxxzy")

/*
 Phase 7 Validation Trace
 --------------------------------------------------
 Example:
 
 input = "azxxzy"
 output = "ay"
 
 --------------------------------------------------
 Initial:
 chars = ["a","z","x","x","z","y"]
 slow = 0
 
 --------------------------------------------------
 fast = 0
 chars[fast] = "a"

 slow == 0 → push

 chars[0] = "a"
 slow = 1

 valid range: chars[0..<1] → ["a"]

 --------------------------------------------------
 fast = 1
 chars[fast] = "z"

 compare with chars[slow - 1] = "a"
 "a" != "z" → push

 chars[1] = "z"
 slow = 2

 valid range: chars[0..<2] → ["a","z"]

 --------------------------------------------------
 fast = 2
 chars[fast] = "x"

 compare with chars[slow - 1] = "z"
 "z" != "x" → push

 chars[2] = "x"
 slow = 3

 valid range: chars[0..<3] → ["a","z","x"]

 --------------------------------------------------
 fast = 3
 chars[fast] = "x"

 compare with chars[slow - 1] = "x"
 "x" == "x" → pop

 slow = 2

 valid range: chars[0..<2] → ["a","z"]

 --------------------------------------------------
 fast = 4
 chars[fast] = "z"

 compare with chars[slow - 1] = "z"
 "z" == "z" → pop

 slow = 1

 valid range: chars[0..<1] → ["a"]

 --------------------------------------------------
 fast = 5
 chars[fast] = "y"

 compare with chars[slow - 1] = "a"
 "a" != "y" → push

 chars[1] = "y"
 slow = 2

 valid range: chars[0..<2] → ["a","y"]

 --------------------------------------------------
 End:

 return String(chars[0..<slow]) → "ay"
 --------------------------------------------------
*/

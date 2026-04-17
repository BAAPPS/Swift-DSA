// MARK: - Problem Statement
/*
 MARK: - Problem: Valid Palindrome

 Goal:
 Determine if a string is a palindrome ignoring non-alphanumeric characters.

 Example:
 Input:  "A man, a plan, a canal: Panama"
 Output: true
 */
// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
    Given a string, we want to determine if it's a palindrome ignoring non-alphanumeric characters. A plaindrome is defined as a string is the same reading left-to-right and right-to-left
 

 - Obvious approach
 
    The most obvious approach:
 
    - Create a normalized version of the given input string
 
    - Create a reversed version of the normalized string
 
    - Check if the normalized version and the reversed version is a palindrome
 
 
 - Performance Analysis
 
    Time Complexity: O(n)
    
        - Filtering,reversing, and comparing → O(n)
 
    Space Complexity: O(n)
         
        - Storing filtered string
        - Storing reversed string
 
 */

func bruteForce(_ input: String) -> Bool {
    let filtered = input.lowercased().filter {$0.isLetter || $0.isNumber}
    let reversed = String(filtered.reversed())
    
    return filtered == reversed
}

bruteForce("A man, a plan, a canal: Panama")



// MARK: - Phase 2: Manual Tracing

/*
 
 Example:
 Input:  "A man, a plan, a canal: Panama"
 Output: true
 
 Invariant:
  - filtered contains only lowercase alphanumeric characters from input
  - reversed is the reverse of filtered
  
  ----------------------------------------------------
 
 Initial State:
 
 input =  "A man, a plan, a canal: Panama"
 
 filtered = ""
 
 ----------------------------------------------------
 Build filtered (normalization):
 
 'A'  → keep → "a"
 ' '  → skip
 'm'  → keep → "am"
 'a'  → keep → "ama"
 'n'  → keep → "aman"
 ','  → skip
 ' '  → skip
 'a'  → keep → "amana"
 ...
 
 Final:
 
 filtered = "amanaplanacanalpanama"
 
 ----------------------------------------------------
 Reverse:
 
 reversed = "amanaplanacanalpanama"
 
 ----------------------------------------------------
 Compare:
 
 filtered == reversed → true
 
 */

// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:

 - We normalize the string and create a reversed version to compare
 - This requires extra space (O(n)) to store the filtered and reversed strings

 ------------------------------------------------------------

 Key Inefficiency:

 - We are explicitly building new strings when it is not necessary
 - The palindrome property can be validated during traversal

 ------------------------------------------------------------

 Key Insight (from tracing):

 - A palindrome is defined by symmetric character matching
 - We do not need a reversed string if we compare characters from both ends

 - Instead of building a filtered string, we can:
     - skip non-alphanumeric characters dynamically
     - compare valid characters in-place

 ------------------------------------------------------------

 Pattern Recognition:

 - This is a two-pointer symmetric comparison problem
 - With conditional skipping of invalid characters

 ------------------------------------------------------------

 Data Structure Insight:

 - Use two pointers:
     left starts at index 0
     right starts at index n - 1

 - While left < right:

     - Skip non-alphanumeric characters:
         - if input[left] is not valid → left++
         - if input[right] is not valid → right--

     - Compare characters (case-insensitive):
         - if not equal → return false

     - Move pointers inward:
         - left++
         - right--
 
- return true as its a palindrome

 ------------------------------------------------------------
*/
// MARK: - Phase 4: Optimized Two Pointer Solution


func isAlphanumeric(_ char: Character) -> Bool {
    return char.isLetter || char.isNumber
}

func twoPointer(_ s: String) -> Bool {
    
    var left = s.startIndex
    var right = s.index(before: s.endIndex)
    
    while left < right {
        
        // move left until alphanumeric
        while left < right && !isAlphanumeric(s[left]) {
            left = s.index(after: left)
        }
        
        // move right until alphanumeric
        while left < right && !isAlphanumeric(s[right]) {
            right = s.index(before: right)
        }
        
        // compare (case-insensitive)
        if s[left].lowercased() != s[right].lowercased() {
            return false
        }
        
        // move right
        left = s.index(after: left)
        
        // move left
        right = s.index(before: right)
    }
    
    return true
}
twoPointer("A man, a plan, a canal: Panama")

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)

    - Each character is visited at most once using two pointers
    - Left and right pointers move inward without reprocessing elements

 Space Complexity: O(1)

    - No auxiliary data structures are used (no array, no reversed string)
    - Only a constant number of pointers (String.Index) are maintained
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:

 The brute force approach uses O(n) extra space by constructing
 a filtered string and its reversed version for comparison.

 This is unnecessary because palindrome checking is fundamentally
 a symmetry problem.

 ------------------------------------------------------------

 Core Insight:

 A string is a palindrome if characters mirror each other around its center.

 Instead of constructing a reversed string, we simulate this symmetry
 by comparing characters from both ends of the string simultaneously.

 ------------------------------------------------------------

 Pattern Recognition:

 This is a classic Two Pointer (Opposite Ends) pattern.

 - left pointer starts at startIndex
 - right pointer starts at index before endIndex

 While left < right:

    - Skip non-alphanumeric characters from both ends
    - Compare characters at left and right pointers

    - If mismatch → return false immediately
    - Otherwise, move both pointers inward using
      `index(after:)` and `index(before:)`

 If all comparisons succeed, the string is a valid palindrome.

 ------------------------------------------------------------

 Swift-Specific Insight:

 I avoid integer indexing and instead use Swift’s String.Index navigation APIs (`startIndex`,
 `endIndex`, `index(after:)`, `index(before:)`) because Swift Strings are Unicode-compliant
  and do not support random-access integer indexing like arrays.
 
*/
// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:
    - At every step, all previously compared characters are equal after normalization.
 Key Insight:
 
    - Use Two Pointer:
 
     left → start of array
     right → end of array
 
    - While left < right:
     
        Check for nonalphanumerics for left element
            - If found, increment left pointer to skip
     
        Check for nonalphanumerics for right element
            - If found, decrement right pointer to skip
 
        Check if left element is not the same as right element
 
            - return false
 
        increment left pointer
        decrement right pointer
     
*/

func isAlpha(_ char: Character) -> Bool {
    return char.isLetter || char.isNumber
}

func optimized(_ input: String) -> Bool{
    
    var left = input.startIndex
    var right = input.index(before:input.endIndex)

    while left < right {
        
        
        while left < right && !isAlpha(input[left]) {
            left = input.index(after: left)
        }
        
        while left < right && !isAlpha(input[right]) {
            right = input.index(before: right)
        }
        
        if input[left].lowercased() != input[right].lowercased() {
            return false
        }
        
        left = input.index(after: left)
        
        right = input.index(before: right)
        
    }
    return true
}

optimized("A man, nama")

/*
 Phase 7: Validation Trace
 --------------------------------------------------

 Input:
 "A man, nama"

 Normalization Rule:
 - Ignore non-alphanumeric characters
 - Compare case-insensitively

 --------------------------------------------------

 Initial State:

 left  → 'A'  (startIndex)
 right → 'a'  (index before endIndex)

 --------------------------------------------------

 Step 1:

 left  = 'A' → valid
 right = 'a' → valid

 Compare:
 'a' == 'a' ✅

 Move:
 left  → next → ' '
 right → prev → 'm'

 --------------------------------------------------

 Step 2:

 left  = ' ' → invalid → skip → 'm'
 right = 'm' → valid

 Compare:
 'm' == 'm' ✅

 Move:
 left  → next → 'a'
 right → prev → 'a'

 --------------------------------------------------

 Step 3:

 left  = 'a' → valid
 right = 'a' → valid

 Compare:
 'a' == 'a' ✅

 Move:
 left  → next → 'n'
 right → prev → 'n'

 --------------------------------------------------

 Step 4:

 left  = 'n' → valid
 right = 'n' → valid

 Compare:
 'n' == 'n' ✅

 Move:
 left  → next → ','
 right → prev → ' '

 --------------------------------------------------

 Step 5:

 left  = ',' → invalid → skip → ' '
 left  = ' ' → invalid → skip → 'n'

 right = ' ' → invalid → skip → ','
 right = ',' → invalid → skip → 'n'

 Now:
 left == right ('n')

 --------------------------------------------------

 Termination:

 left >= right → stop

 All comparisons matched → return true
*/

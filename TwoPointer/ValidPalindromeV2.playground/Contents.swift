// MARK: - Problem Statement
/*
 MARK: - Problem: Valid Palindrome II

 Goal:
 Return true if the string can be a palindrome after deleting at most one character.

 Example:
 Input:  "abca"
 Output: true
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
    Given a string, determine if it can become a palindrome
    after deleting at most one character.

 ------------------------------------------------------------

 Obvious approach:

 - First, create a helper function to check if a string is a palindrome:

    - A string is a palindrome if characters at symmetric positions match:
        - first == last
        - second == second-last
        - and so on

    - We only need to compare up to half of the string (n/2),
      because each comparison checks two positions at once.

        Example:
        "racecar"
        r == r
        a == a
        c == c
        (middle character does not need comparison)

    - If any pair does not match → return false
    - Otherwise → return true

 ------------------------------------------------------------

 - Convert the string into an array of characters for easy indexing

 ------------------------------------------------------------

 - We consider two cases:

    1. No deletion:
        - If the original string is already a palindrome → return true

    2. Try deleting each character:
        - For each index i:
            - Create a copy of the array
            - Remove the character at index i
            - Check if the resulting string is a palindrome

        - If any deletion results in a palindrome → return true

 ------------------------------------------------------------

 - If no valid case is found → return false

 ------------------------------------------------------------

 Performance Analysis:

 Time Complexity: O(n^2)
    - We try up to n deletions
    - Each palindrome check takes O(n)

 Space Complexity: O(n)
    - Each deletion creates a new array copy
*/

func isPalindrome(_ chars: [Character]) -> Bool {
    let n = chars.count
    
    for i in 0..<n/2 {
        if chars[i] != chars[n - 1 - i] {
            return false
        }
    }
    return true
}

func bruteForce(_ input: String) -> Bool {
    let chars = Array(input)
    
    // Case 1: no deletion
    if isPalindrome(chars) {
        return true
    }
    
    // Case 2: try deleting each character
    for i in 0..<chars.count {
        var temp = chars
        temp.remove(at: i)
        
        if isPalindrome(temp) {
            return true
        }
    }
    
    return false
}
bruteForce("abca")



// MARK: - Phase 2: Manual Tracing

/*
 
 Example:
 Input:  "abca"
 Output: true
 
 Invariant:
    - At each iteration i, we are testing whether removing index i results in a valid palindrome
  ----------------------------------------------------
 Initial:
 
 chars = ["a", "b", "c", "a"]

 --------------------------------------------------

 Step 1: No deletion

 Check: "abca"

 Compare:
 a == a ✔
 b != c

 → Not a palindrome

 --------------------------------------------------

 Step 2: Remove index 0 ('a')

 temp = ["b", "c", "a"] → "bca"

 Compare:
 b != a

 → Not a palindrome

 --------------------------------------------------

 Step 3: Remove index 1 ('b')

 temp = ["a", "c", "a"] → "aca"

 Compare:
 a == a ✔
 (center reached)

 → Palindrome ✔ → return true

 --------------------------------------------------
 */


// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:

 - For each index, we remove the current element and check if the resulting
   string is a palindrome

 - This results in O(n) deletions, and each deletion requires an O(n)
   palindrome check → O(n^2) time complexity

 ------------------------------------------------------------
 
 Key Inefficiency:

 - We are trying ALL possible deletions, even though most of them are unnecessary

 - From tracing, we observe that a valid deletion only matters at the point
   where a mismatch occurs between symmetric characters

 ------------------------------------------------------------
 
 Key Insight (from tracing):

 - A palindrome is defined by symmetric character matching

 - While comparing characters from both ends:
 
    - If characters match → continue inward
 
    - If a mismatch occurs:
 
        - We are allowed to delete at most one character
 
        - The only meaningful options are:
            1. Skip the left character
            2. Skip the right character
 
        - After skipping, we check if the remaining substring is a palindrome

 - Therefore, we only need to handle deletion at the FIRST mismatch,
   instead of trying all possible deletions

 ------------------------------------------------------------
 
 Pattern Recognition:

 - This is a Two Pointer (Opposite Ends) pattern with conditional branching

 - Normal case:
     - Move both pointers inward when characters match

 - Special case (mismatch):
     - Branch into two possibilities:
         - Skip left
         - Skip right

 ------------------------------------------------------------
 
 Data Structure Insight:

 - Use two pointers:
 
    left starts at index 0
    right starts at index n - 1

 - While left < right:
 
    - If input[left] == input[right]:
        → move both pointers inward
 
    - Else:
        → check:
            isPalindrome(left + 1, right) OR
            isPalindrome(left, right - 1)
 
        → return result immediately

 - If no mismatches exceed one deletion, return true
*/
// MARK: - Phase 4: Optimized Two Pointer Solution

func isPlaindrome(_ s:String, _ left: String.Index, _ right: String.Index) -> Bool {
    var l = left
    var r = right
    
    while l < r {
        if s[l] != s[r] {
            return false
        }
        
        l = s.index(after: l)
        r = s.index(before: r)
    }
    
    
    return true
}

func twoPointer(_ input: String) -> Bool {
    
    var left = input.startIndex
    var right = input.index(before: input.endIndex)
    
    while left < right {
        if input[left] != input[right] {
            return isPlaindrome(input, input.index(after:left), right) || isPlaindrome(input, left, input.index(before:right))
        }
        left = input.index(after:left)
        right = input.index(before:right)
    }
    
 return true
}

twoPointer("abca")

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
 - We traverse the string once using two pointers.
 - On the first mismatch, we perform at most one additional
   linear check to validate a substring.

 Therefore overall complexity remains O(n).

 ------------------------------------------------------------

 Space Complexity: O(1)
 - Only pointers and a few variables are used.
 - No additional data structures are created.
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:
 
 The brute force approach checks whether the string becomes a palindrome
 after removing each possible character.

 This is inefficient because most deletions are unnecessary and redundant.

 ------------------------------------------------------------
 
 Core Insight:
 
 A string is a palindrome if characters mirror each other around its center.

 Instead of trying every possible deletion, we scan from both ends
 and only consider deletion when a mismatch occurs.

 ------------------------------------------------------------

 Key Constraint:
 
 We are allowed to remove at most one character.

 Therefore, only the first mismatch matters.

 ------------------------------------------------------------

 While left < right:

    - If input[left] == input[right]:
        → move both pointers inward

    - Else (mismatch occurs):
        → try skipping one character:
            isPalindrome(left + 1, right) OR
            isPalindrome(left, right - 1)

        → return result immediately

 ------------------------------------------------------------

 Final Outcome:

 If no more than one mismatch requires deletion, the string can be considered a valid palindrome.
 
 ------------------------------------------------------------
 
 Pattern Learned:

 In the regular valid palindrome problem, we compare characters from both ends of the string using two pointers.

 In this variation, since we are allowed to delete at most one character, we still compare from both ends normally.

 However, at the first mismatch, we are allowed one deletion, so we branch into two possibilities:
     - skip the left character
     - skip the right character

 We then validate each resulting substring independently as a palindrome.
*/
// MARK: - Phase 7: Re-Code (After Break)

/*
Invariant:
- All characters outside the current [left, right] window are symmetric, and we have not yet used our single allowed deletion.

Key Insight:

1. Helper Function (Palindrome Check):
 
   - Use two pointers (left, right)
   - While left < right:
        - If characters mismatch → return false
        - Move both pointers inward
   - If loop completes → return true

2. Main Logic (Two Pointer):

   - Initialize left at start, right at end
   - While left < right:
        - If input[left] == input[right]:
            → move both pointers inward
        - Else (first mismatch):
            → try one deletion:
                return isPalindrome(left + 1, right)
                    OR
                       isPalindrome(left, right - 1)

   - If no mismatch occurs → return true
*/

func isPalindrome(_ input: String, _ left: String.Index,_ right: String.Index) -> Bool {
    var l = left
    var r = right
    
    while l < r {
        if input[l] != input[r] {
            return false
        }
        l = input.index(after: l)
        r = input.index(before: r)
    }
    
    return true
}

func optimized(_ input: String) -> Bool {
    
    var left: String.Index = input.startIndex
    var right: String.Index = input.index(before: input.endIndex)
    
    while left < right {
        if input[left] != input[right] {
            return isPalindrome(input, input.index(after:left), right) || isPalindrome(input, left,  input.index(before:right))
        }
        
        left = input.index(after:left)
        right = input.index(before:right)
    }
    

    return false
}

optimized("baccdab")

/*
 Phase 7 Validation Trace
 --------------------------------------------------

 Example 1: No mismatch case
 
 Input: "baccab"

 Indices:
 0  1  2  3  4  5
 b  a  c  c  a  b

 --------------------------------------------------

 Initial:
 left = 0 ('b')
 right = 5 ('b')

 --------------------------------------------------

 Step 1:
 'b' == 'b' ✔
 → move inward

 left = 1
 right = 4

 --------------------------------------------------

 Step 2:
 'a' == 'a' ✔
 → move inward

 left = 2
 right = 3

 --------------------------------------------------

 Step 3:
 'c' == 'c' ✔
 → move inward

 left = 3
 right = 2

 --------------------------------------------------

 Loop ends (left >= right)

 No mismatches encountered
 → return true

 --------------------------------------------------
 
 Example 2: Mismatch case

 Input: "baccdab"

 Indices:
 0  1  2  3  4  5  6
 b  a  c  c  d  a  b
 --------------------------------------------------

 Initial:
 left = 0 ('b')
 right = 6 ('b')

 --------------------------------------------------

 Step 1:
 'b' == 'b' ✔
 → move inward

 left = 1
 right = 5

 --------------------------------------------------

 Step 2:
 'a' == 'a' ✔
 → move inward

 left = 2
 right = 4

 --------------------------------------------------

 Step 3:
 'c' != 'd' (FIRST mismatch)

 → Try skipping left:
    isPalindrome(3, 4) → "cd"
        'c' != 'd' → false

 → Try skipping right:
    isPalindrome(2, 3) → "cc"
        'c' == 'c'  → true

 At least one valid → return true

 --------------------------------------------------
 
*/

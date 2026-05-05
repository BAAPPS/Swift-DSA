// MARK: - Problem Statement
/*
 MARK: - Problem: Merge Strings Alternately

 Goal:
 Merge two strings by alternating characters.

 Example:
 Input:  word1 = "abc", word2 = "pqr"
 Output: "apbqcr"
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
    Given two strings, we want to merge them by alternating characters from each string.

    If one string is longer, append the remaining characters at the end.

 ------------------------------------------------------------

 - Obvious approach
 
    The most straightforward approach:

    - Convert both strings into arrays of characters for easier index-based access

    - Create a result array to store the merged characters

    - Traverse up to the maximum length of both arrays

        - At each index:
            - If the index exists in str1 → append chars1[i]
            - If the index exists in str2 → append chars2[i]

 ------------------------------------------------------------

 - Edge Case Handling:

    - If one string is longer than the other:
        → its remaining characters will still be appended because we iterate up to the maximum length

    - This avoids needing a separate “leftover” step

 ------------------------------------------------------------

 - Why this works:

    - We safely check bounds before accessing each array
    - We alternate naturally by attempting both appends at every index

 ------------------------------------------------------------

 - Performance Analysis
 
    Time Complexity: O(n + m)
        - We traverse both strings once

    Space Complexity: O(n + m)
        - We store all characters in a new result array

 */

func bruteForce(_ str1: String, _ str2: String) -> String {
    var result:[Character] = []
    var chars1 = Array(str1)
    var chars2 = Array(str2)
    var maxLength = max(chars1.count, chars2.count)
    
    for i in 0..<maxLength{
        
        if i < chars1.count {
            result.append(chars1[i])
        }
        
        if i < chars2.count {
            result.append(chars2[i])
        }
    }
    
    
    return String(result)
}

bruteForce("abc", "defgh")

// MARK: - Phase 2: Manual Tracing

/*
 Example:
     Input:  word1 = "abc", word2 = "defgh"
     Output: "adbecfgh"
 
 Invariant:
 
 - At any point during iteration, the result contains the correct alternating merge of characters from both strings up to index i.
 
 ------------------------------------------------------------
 
 Initial:
 
 result = []
 
 chars1 = ["a", "b", "c"]     // count = 3
 chars2 = ["d", "e", "f", "g", "h"] // count = 5

 maxLength = max(3, 5) → 5
 
 ------------------------------------------------------------
 
 i = 0
 
 0 < 3 → append chars1[0] → "a"
 result = ["a"]
 
 0 < 5 → append chars2[0] → "d"
 result = ["a", "d"]
 
 ------------------------------------------------------------
 
 i = 1
 
 1 < 3 → append chars1[1] → "b"
 result = ["a", "d", "b"]
 
 1 < 5 → append chars2[1] → "e"
 result = ["a", "d", "b", "e"]
 
 ------------------------------------------------------------
 
 i = 2
 
 2 < 3 → append chars1[2] → "c"
 result = ["a", "d", "b", "e", "c"]
 
 2 < 5 → append chars2[2] → "f"
 result = ["a", "d", "b", "e", "c", "f"]
 
 ------------------------------------------------------------
 
 i = 3
 
 3 < 3 → skip chars1
 
 3 < 5 → append chars2[3] → "g"
 result = ["a", "d", "b", "e", "c", "f", "g"]
 
 ------------------------------------------------------------
 
 i = 4
 
 4 < 3 → skip chars1
 
 4 < 5 → append chars2[4] → "h"
 result = ["a", "d", "b", "e", "c", "f", "g", "h"]
 
 ------------------------------------------------------------
 
 End
 
 Final result = "adbecfgh"
*/


// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:
 
 - We iterate up to the maximum length and conditionally append characters from each string using index checks

 - This works, but requires converting strings into arrays and relying on integer indexing

 ------------------------------------------------------------
 
 Key Inefficiency:
 
 - Converting strings into arrays introduces unnecessary space usage

 - The logic is tied to index-based traversal, which is not natural for Swift Strings (since they use String.Index)

 ------------------------------------------------------------
 
 Key Insight (from tracing):
 
 - We are effectively traversing both strings simultaneously

 - At each step, we attempt to take one character from each string, if available

 - The “max length loop” is just a way of saying:
      → continue until BOTH strings are fully processed

 ------------------------------------------------------------
 
 Pattern Recognition:
 
 This maps directly to a Two Pointer (Same Direction) pattern:
 
 - Use two pointers:
     i → traverses str1
     j → traverses str2

 - While either pointer has not reached the end:
 
     - If i is valid → append str1[i], move i forward
     - If j is valid → append str2[j], move j forward

 ------------------------------------------------------------
 
 Key Transformation:
 
 max-length loop  →  while (i < end1 || j < end2)
 
 This removes the need for:
 
 - array conversion
 - manual index tracking
 - separate leftover handling
 
*/
// MARK: - Phase 4: Optimized Two Pointer Solution

func twoPointer(_ str1: String, _ str2: String) -> String {
    var result: String = ""
    var i = str1.startIndex
    var j = str2.startIndex
    
    while i < str1.endIndex || j < str2.endIndex {
        if i < str1.endIndex {
            result.append(str1[i])
            i = str1.index(after: i)
        }
        
        if j < str2.endIndex {
            result.append(str2[j])
            j = str2.index(after: j)
        }
    }
    
    
    return result
}

twoPointer("aefgm", "hij")

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n+m), where n = str1, m = str2

 Space Complexity: O(n + m)
    - Result contains ALL characters from both strings

 
*/

// MARK: - Phase 6: Final Insight
/*
 Final Insight & Patterns Learned:
 
 The brute force approach converts strings into arrays and relies on integer indexing, which introduces unnecessary space usage and
 moves away from Swift’s natural string handling.

 ------------------------------------------------------------
 
 Core Insight:
 
 Instead of converting to arrays, we can traverse both strings directly using String.Index.

 We process both strings simultaneously, taking one character from each when available.

 ------------------------------------------------------------

 Key Idea:
 
 We are not looping over indices — we are exhausting two sequences.

 This leads to the condition:
 
    while i < str1.endIndex || j < str2.endIndex

 ------------------------------------------------------------

 Two Pointer Pattern:
 
 - i → traverses str1
 - j → traverses str2

 At each step:
 
    - If i is valid → append str1[i], move i forward
    - If j is valid → append str2[j], move j forward

 ------------------------------------------------------------
 
 Pattern Learned:
 
 - Combining two sequences of different lengths requires:
 
     → iterating until BOTH are exhausted
     → independently checking each pointer’s validity

 - max-length loop  ⇄  while (i < end1 || j < end2)

 - Learned when to use:
     - Array conversion (for random access / mutation)
     - String.Index (for safe traversal)

*/
// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:
 Key Insight:
*/

func optimized(_ input: [Int]) -> [Int] {
    


    return []
}

optimized([1, 3, 2, 4])

/*
 Phase 7 Validation Trace
 --------------------------------------------------

*/

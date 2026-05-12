// MARK: - Problem Statement
/*
 MARK: - Problem: Longest Substring Without Repeating Characters

 Goal:
 Find the length of the longest substring without repeating characters.

 Example:
 Input:  "abcabcbb"
 Output: 3
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
    - Determine the length of the longest substring
      without repeating characters
 
 ------------------------------------------------------------
 
 - Obvious approach
 
    The most straightforward approach:
 
    - Convert the string into an array of characters for easier traversal
    - Use a variable to track the longest valid substring length

    - Traverse using two loops:
        - Outer loop selects the starting index of the substring
        - Inner loop expands the substring forward

    - For every starting index i:
        - Expand the substring using j
        - Maintain a Set of seen characters

        - If the current character already exists in the Set:
            → stop expanding (duplicate found)

        - Otherwise:
            → insert character into the Set
            → update the longest substring length
 
 ------------------------------------------------------------
 
 - Why this works:
    - For each starting position, we attempt to build the longest possible substring until a repetition occurs

 ------------------------------------------------------------
 
 - Performance Analysis
 
    Time Complexity: O(n²)
        - Outer loop runs n times
        - Inner loop expands at most n times

    Space Complexity: O(k)
        - k = size of character set stored in the Set
*/

func bruteForce(_ input: String) -> Int {
    
    var chars = Array(input)
    
    var longest: Int = 0
    
    for i in 0..<chars.count {
        var seen: Set<Character> = []
        for j in i..<chars.count {
            if seen.contains(chars[j]) {
                break
            }
            seen.insert(chars[j])
            longest = max(longest, j - i + 1)
        }
    }

    return longest
}

bruteForce("abcabdcbb")



// MARK: - Phase 2: Manual Tracing

/*
 Example:
 Input:  "abcabdcbb"
 Output: 4

 Invariant:
    - At any point during the inner loop, the Set contains all unique characters in the current substring chars[i...j].

 ------------------------------------------------------------
 Initial:

 chars   = ["a","b","c","a","b","d","c","b","b"]
 longest = 0

 ------------------------------------------------------------
 i = 0
 seen = []

 j = 0
 chars[j] = "a"

 "a" not in seen
 insert "a"

 seen = ["a"]

 longest = max(0, 1) → 1

 ------------------------------------------------------------
 j = 1
 chars[j] = "b"

 "b" not in seen
 insert "b"

 seen = ["a", "b"]

 longest = max(1, 2) → 2

 ------------------------------------------------------------
 j = 2
 chars[j] = "c"

 "c" not in seen
 insert "c"

 seen = ["a", "b", "c"]

 longest = max(2, 3) → 3

 ------------------------------------------------------------
 j = 3
 chars[j] = "a"

 seen contains "a"
 duplicate found → break

 ------------------------------------------------------------
 i = 1
 seen = []

 j = 1
 chars[j] = "b"

 "b" not in seen
 insert "b"

 seen = ["b"]

 longest = max(3, 1) → 3

 ------------------------------------------------------------
 j = 2
 chars[j] = "c"

 "c" not in seen
 insert "c"

 seen = ["b", "c"]

 longest = max(3, 2) → 3

 ------------------------------------------------------------
 j = 3
 chars[j] = "a"

 "a" not in seen
 insert "a"

 seen = ["b", "c", "a"]

 longest = max(3, 3) → 3

 ------------------------------------------------------------
 j = 4
 chars[j] = "b"

 seen contains "b"
 duplicate found → break

 ------------------------------------------------------------
 i = 2
 seen = []

 j = 2
 chars[j] = "c"

 "c" not in seen
 insert "c"

 seen = ["c"]

 longest = max(3, 1) → 3

 ------------------------------------------------------------
 j = 3
 chars[j] = "a"

 "a" not in seen
 insert "a"

 seen = ["c", "a"]

 longest = max(3, 2) → 3

 ------------------------------------------------------------
 j = 4
 chars[j] = "b"

 "b" not in seen
 insert "b"

 seen = ["c", "a", "b"]

 longest = max(3, 3) → 3

 ------------------------------------------------------------
 j = 5
 chars[j] = "d"

 "d" not in seen
 insert "d"

 seen = ["c", "a", "b", "d"]

 longest = max(3, 4) → 4

 ------------------------------------------------------------
 j = 6
 chars[j] = "c"

 seen contains "c"
 duplicate found → break

 ------------------------------------------------------------
 i = 3
 seen = []

 j = 3
 chars[j] = "a"

 "a" not in seen
 insert "a"

 seen = ["a"]

 longest = max(4, 1) → 4

 ------------------------------------------------------------
 j = 4
 chars[j] = "b"

 "b" not in seen
 insert "b"

 seen = ["a", "b"]

 longest = max(4, 2) → 4

 ------------------------------------------------------------
 j = 5
 chars[j] = "d"

 "d" not in seen
 insert "d"

 seen = ["a", "b", "d"]

 longest = max(4, 3) → 4

 ------------------------------------------------------------
 j = 6
 chars[j] = "c"

 "c" not in seen
 insert "c"

 seen = ["a", "b", "d", "c"]

 longest = max(4, 4) → 4

 ------------------------------------------------------------
 j = 7
 chars[j] = "b"

 seen contains "b"
 duplicate found → break

 ------------------------------------------------------------
 End

 longest = 4

 Longest valid substring:
    "cabd"
*/


// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:
 
 - For every starting index, we rebuild a new Set and rescan overlapping substrings repeatedly

 - Many substrings share the same characters, causing redundant work and O(n²) time complexity

 ------------------------------------------------------------

 Key Insight (from tracing):

 - We do not need to restart the substring every time

 - Instead, we can maintain one continuous valid window containing only unique characters

 - If a duplicate character appears:
    → shrink the window from the left
    → remove characters until the window becomes valid again

 ------------------------------------------------------------

 Pattern Recognition:

 This maps directly to the Sliding Window pattern:

 - left pointer:
    → represents the start of the current valid substring

 - right pointer:
    → expands the substring forward

 - Set:
    → tracks characters currently inside the window
 
 If chars[right] already exists in the current window, we shrink the window from the left side until the duplicate  character is removed.

 Once the window becomes valid again, we insert chars[right] into the Set.
 
 Keep track of the longest substring thus far
     → (right - left + 1)
     → right - left gives the distance between indices, so we add +1 to count all elements inside the window.
 ------------------------------------------------------------

 Why Array Conversion Helps:

 Although the input is a String, this problem requires:

 - frequent pointer movement
 - window length calculations
 - random-access style traversal

 Converting to Array<Character> simplifies:
 
    - indexing
    - pointer arithmetic
    - window size calculations
 
 Thus, although Swift Strings use String.Index for safe traversal, this problem behaves more like array-window manipulation, making Array<Character> the cleaner and more ergonomic approach.

*/
// MARK: - Phase 4: Optimized Two Pointer Sliding Window Solution

func twoPointerSW(_ input: String) -> Int{
    var chars = Array(input)
    var left = 0
    
    var longest: Int = 0
    var seen: Set<Character> = []

    for right in 0..<chars.count {
        while seen.contains(chars[right]) {
            seen.remove(chars[left])
            left += 1
        }
        
        seen.insert(chars[right])
        longest = max(longest, right - left + 1)
    }
    
    
    return longest
}

twoPointerSW("abcabdcbb")

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
 
  - Each character is visited at most twice:
        - once by the right pointer (expand window)
        - once by the left pointer (shrink window)
 
 Space Complexity: O(k)
 
  - Where: k = number of unique characters in the input (character set size)

*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:

 The brute force approach recomputes a new Set for every starting index and repeatedly rescans overlapping substrings, leading to O(n²) complexity.

 ------------------------------------------------------------

 Core Insight:

 Instead of rebuilding a Set for each substring:
    - Maintain a single sliding window of unique characters
    - Dynamically adjust the window as we scan the string

 ------------------------------------------------------------

 Key Idea:

 - If chars[right] already exists in the current window:
    → shrink the window from the left
    → remove characters until the duplicate is eliminated

 - Once the window becomes valid again:
    → insert chars[right] into the Set
    → update the longest substring length

 ------------------------------------------------------------

 Pattern Learned:

 This problem uses the Sliding Window pattern, which is a specialized form of the Two Pointer technique.

 - right pointer expands the window
 - left pointer shrinks the window when constraints are violated

 Instead of restarting for every index, we continuously adjust a single window to maintain validity.

 Sliding Window allows us to reuse previously computed state (like the Set), making the solution efficient compared to brute force.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*
 Invariant:
 
    - At any point during traversal, all characters inside the current window are unique.

 ------------------------------------------------------------

 Key Insight:
 
    - Convert the string into an array of characters for easier indexing and window calculations.

    - Use:
        - longest → stores the maximum valid substring length found so far
        - Set → tracks characters currently inside the window

 ------------------------------------------------------------

 Sliding Window (Two Pointer Pattern):
 
    - left pointer:
        → shrinks the window when duplicates appear

    - right pointer:
        → expands the window forward

 ------------------------------------------------------------

 Algorithm:
 
    - Traverse using the right pointer

    - While chars[right] already exists in the Set:
        → remove chars[left] from the Set
        → move left forward to shrink the window

    - Once the window becomes valid again:
        → insert chars[right] into the Set
        → update longest using:
              right - left + 1

*/

func optimized(_ input: String) -> Int {
    var chars = Array(input)
    var seen: Set<Character> = []
    var longest: Int = 0
    
    var left = 0
    
    for right in 0..<chars.count {
        while seen.contains(chars[right]) {
            seen.remove(chars[left])
            left += 1
        }
        
        seen.insert(chars[right])
        longest = max(longest, right - left + 1)
        
    }

    return longest
}

optimized("abaebcd")

/*
 Phase 7 Validation Trace
 --------------------------------------------------

 Example:

 input: "abaebcd"
 output: 5

 --------------------------------------------------
 Initial:

 chars = ["a","b","a","e","b","c","d"]
           R

 left = 0
 seen = []
 longest = 0

 --------------------------------------------------
 right = 0
 chars[right] = "a"

 seen does not contain "a"
 → insert "a"

 seen = ["a"]

 chars = ["a","b","a","e","b","c","d"]
          L/R

 window = "a"

 longest = max(0, 1) = 1

 --------------------------------------------------
 right = 1
 chars[right] = "b"

 seen does not contain "b"
 → insert "b"

 seen = ["a", "b"]

 chars = ["a","b","a","e","b","c","d"]
           L   R

 window = "ab"

 longest = max(1, 2) = 2

 --------------------------------------------------
 right = 2
 chars[right] = "a"

 seen contains "a"

 chars = ["a","b","a","e","b","c","d"]
           L       R

 → remove chars[left] = "a"
 → seen = ["b"]
 → left += 1

 chars = ["a","b","a","e","b","c","d"]
               L   R

 window valid again

 → insert "a"

 seen = ["b", "a"]

 window = "ba"

 longest = max(2, 2) = 2

 --------------------------------------------------
 right = 3
 chars[right] = "e"

 seen does not contain "e"
 → insert "e"

 seen = ["b", "a", "e"]

 chars = ["a","b","a","e","b","c","d"]
               L       R

 window = "bae"

 longest = max(2, 3) = 3

 --------------------------------------------------
 right = 4
 chars[right] = "b"

 seen contains "b"

 chars = ["a","b","a","e","b","c","d"]
               L           R

 → remove chars[left] = "b"
 → seen = ["a", "e"]
 → left += 1

 chars = ["a","b","a","e","b","c","d"]
                   L       R

 window valid again

 → insert "b"

 seen = ["a", "e", "b"]

 window = "aeb"

 longest = max(3, 3) = 3

 --------------------------------------------------
 right = 5
 chars[right] = "c"

 seen does not contain "c"
 → insert "c"

 seen = ["a", "e", "b", "c"]

 chars = ["a","b","a","e","b","c","d"]
                   L           R

 window = "aebc"

 longest = max(3, 4) = 4

 --------------------------------------------------
 right = 6
 chars[right] = "d"

 seen does not contain "d"
 → insert "d"

 seen = ["a", "e", "b", "c", "d"]

 chars = ["a","b","a","e","b","c","d"]
                   L               R

 window = "aebcd"

 longest = max(4, 5) = 5

 --------------------------------------------------

 Final substring = "aebcd"

 longest = 5
*/


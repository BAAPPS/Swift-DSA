// MARK: - Problem Statement
/*
 MARK: - Problem: Longest Repeating Character Replacement

 Goal:
 Find longest substring where you can replace at most k chars to make all same.

 Example:
 Input:  s = "AABABBA", k = 1
 Output: 4
 */
// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
    Given a string and a fixed number of replacements k, determine the longest substring that can become all the same character after at most k replacements.

 ------------------------------------------------------------

 - Obvious approach
 
    The most obvious approach:

    - Convert the string into an array of characters for easier scanning.

    - Create:
        - longest → tracks the maximum valid substring length
        - frequency map → tracks character frequencies inside the current substring

    - Traverse using two loops:
        - Outer loop:
            → selects the starting index i

        - Inner loop:
            → expands the substring using j

 ------------------------------------------------------------

 - For every substring chars[i...j]:

    - Update the frequency of chars[j]

    - Keep track of:
        maxFreq → highest character frequency
        inside the current substring

    - Compute:
        replacementsNeeded =
            windowSize - maxFreq

    - If replacementsNeeded > k:
        → stop expanding this substring

    - Otherwise:
        → update longest substring length

 ------------------------------------------------------------

 - Performance Analysis

    Time Complexity: O(n²)
        - Outer loop = n
        - Inner loop = at most n

    Space Complexity: O(1)
        - Frequency map stores at most 26 uppercase English letters

*/

func bruteForce(_ input: String, _ k: Int) -> Int {

    let chars = Array(input)

    var longest = 0

    for i in 0..<chars.count {

        var freq: [Character: Int] = [:]
        var maxFreq = 0

        for j in i..<chars.count {

            freq[chars[j], default: 0] += 1

            maxFreq = max(maxFreq, freq[chars[j]]!)

            let windowSize = j - i + 1
            let replacementsNeeded = windowSize - maxFreq

            if replacementsNeeded > k {
                break
            }

            longest = max(longest, windowSize)
        }
    }

    return longest
}

bruteForce("AABABBA", 1)



// MARK: - Phase 2: Manual Tracing

/*
 Example:
 Input:  "AABABBA"
 Output: 4

 Invariant:
    - At any point during the inner loop, the frequency map contains all characters inside the current substring chars[i...j].

 --------------------------------------------------
 Initial:

 chars   = ["A","A","B","A","B","B","A"]
 longest = 0

 --------------------------------------------------
 i = 0

 freq = [:]
 maxFreq = 0

 --------------------------------------------------
 j = 0
 chars[j] = "A"

 freq = ["A": 1]

 maxFreq = max(0, 1) = 1

 windowSize = (0 - 0 + 1) = 1

 replacementsNeeded = 1 - 1 = 0

 valid window

 longest = max(0, 1) = 1

 substring = "A"

 --------------------------------------------------
 j = 1
 chars[j] = "A"

 freq = ["A": 2]

 maxFreq = max(1, 2) = 2

 windowSize = (1 - 0 + 1) = 2

 replacementsNeeded = 2 - 2 = 0

 valid window

 longest = max(1, 2) = 2

 substring = "AA"

 --------------------------------------------------
 j = 2
 chars[j] = "B"

 freq = ["A": 2, "B": 1]

 maxFreq = max(2, 1) = 2

 windowSize = (2 - 0 + 1) = 3

 replacementsNeeded = 3 - 2 = 1

 valid window

 longest = max(2, 3) = 3

 substring = "AAB"

 --------------------------------------------------
 j = 3
 chars[j] = "A"

 freq = ["A": 3, "B": 1]

 maxFreq = max(2, 3) = 3

 windowSize = (3 - 0 + 1) = 4

 replacementsNeeded = 4 - 3 = 1

 valid window

 longest = max(3, 4) = 4

 substring = "AABA"

 --------------------------------------------------
 j = 4
 chars[j] = "B"

 freq = ["A": 3, "B": 2]

 maxFreq = max(3, 2) = 3

 windowSize = (4 - 0 + 1) = 5

 replacementsNeeded = 5 - 3 = 2

 replacementsNeeded > k

 invalid window → stop expanding

 --------------------------------------------------
 i = 1

 freq = [:]
 maxFreq = 0

 --------------------------------------------------
 j = 1
 chars[j] = "A"

 freq = ["A": 1]

 maxFreq = 1

 windowSize = 1

 replacementsNeeded = 0

 longest = max(4, 1) = 4

 --------------------------------------------------
 j = 2
 chars[j] = "B"

 freq = ["A": 1, "B": 1]

 maxFreq = 1

 windowSize = 2

 replacementsNeeded = 2 - 1 = 1

 valid window

 longest = max(4, 2) = 4

 substring = "AB"

 --------------------------------------------------
 j = 3
 chars[j] = "A"

 freq = ["A": 2, "B": 1]

 maxFreq = 2

 windowSize = 3

 replacementsNeeded = 3 - 2 = 1

 valid window

 longest = max(4, 3) = 4

 substring = "ABA"

 --------------------------------------------------
 j = 4
 chars[j] = "B"

 freq = ["A": 2, "B": 2]

 maxFreq = 2

 windowSize = 4

 replacementsNeeded = 4 - 2 = 2

 invalid window → stop expanding

 --------------------------------------------------

 Continue same process for remaining i...

 Final longest = 4
*/


// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:
 
 - For every starting index, we rebuild the frequency map and recompute character frequencies repeatedly.

 - Many substrings overlap, causing redundant rescanningand leading to O(n²) time complexity.

 ------------------------------------------------------------

 Key Insight (from tracing):

 - We do not need to restart the substring every time.

 - Instead, we can maintain one continuous sliding window while dynamically tracking character frequencies.

 - A window remains valid as long as:

        windowSize - maxFreq <= k

   where:
        - windowSize = total characters in the window
        - maxFreq = frequency of the most common character

 ------------------------------------------------------------

 Sliding Window Optimization:

 - If replacementsNeeded exceeds k:
    → shrink the window from the left
    → update frequencies accordingly

 - Otherwise:
    → continue expanding the window
    → update longest substring length

 ------------------------------------------------------------

 Pattern Recognition:

 This maps directly to the Sliding Window pattern
 (a specialized form of Two Pointers):

 - left pointer:
    → shrinks the window when invalid

 - right pointer:
    → expands the window forward

 - Hash Map:
    → tracks character frequencies inside the current window

 - maxFreq:
    → stores the highest frequency character
      inside the current window
*/

// MARK: - Phase 4: Optimized Monotonic Decreasing Stack Solution

func twoPointerSW(_ input: String, _ k: Int) -> Int {
    var chars: Array = Array(input)
    var left: Int = 0
    var freq: [Character: Int] = [:]
    var maxFreq: Int = 0
    var longest: Int = 0
    
    for right in 0..<chars.count {
        freq[chars[right], default: 0] += 1
        maxFreq = max(maxFreq, freq[chars[right]]!)

        while (right - left + 1) - maxFreq > k {
            freq[chars[left]]! -= 1
            left += 1
        }
        
        longest = max(longest, right - left + 1)
        
    }
    
 return longest
}

twoPointerSW("AABABBA", 1)

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)

    - The right pointer traverses the string once
    - The left pointer only moves forward and never resets

    - Each character is inserted and removed from the Hash Map at most once

 ------------------------------------------------------------

 Space Complexity: O(k)

    - Hash Map stores character frequencies inside the current window

    - k = size of the character set

    - For uppercase English letters, this is effectively O(1)

*/
// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:

 The brute force approach repeatedly rebuilds the frequency map and recomputes character frequencies for every substring,leading to O(n^2) time complexity due to redundant work.

 ------------------------------------------------------------

 Core Insight:

 Instead of restarting for every substring, we maintain a single sliding window and dynamically track character frequencies.

 A window is valid as long as:

    windowSize - maxFreq <= k

 where:
    - windowSize = right - left + 1
    - maxFreq = highest frequency of any character in the window

 ------------------------------------------------------------

 Key Idea:

 - If the window becomes invalid (replacementsNeeded > k):
     → shrink from the left
     → remove characters from frequency map

 - Once valid again:
     → expand window
     → update longest substring length

 ------------------------------------------------------------

 Pattern Learned:

 This is a Sliding Window problem (specialized Two Pointer pattern):

 - right pointer expands the window
 - left pointer shrinks the window when constraint is violated

 Instead of restarting computation for every index, we maintain one continuous window, thus avoid recomputing windowSize/replacementsNeeded explicitly because they are derived from left/right pointers.

 maxFreq acts as a guiding upper bound and does not need to be decreased when shrinking, since it still preserves correctness for determining validity.
*/
// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:
    - At any point during traversal, the current window is valid, meaning it can be transformed into a substring of repeating characters using at most k replacements.

 ------------------------------------------------------------
 Key Insight:

    - Convert the string into an array of characters for easier indexing and window calculations.

    - Use:
        - longest
            → stores the maximum valid substring length

        - Hash Map
            → tracks character frequencies inside the window

        - maxFreq
            → tracks the highest character frequency
              inside the current window

 ------------------------------------------------------------

 Sliding Window (Two Pointer Pattern):

    - left pointer
        → shrinks the window when it becomes invalid

    - right pointer
        → expands the window forward

 ------------------------------------------------------------
 Algorithm:

    - Traverse using the right pointer

    - Insert chars[right] into frequency map

    - Update maxFreq using the current character frequency

    - While the window is invalid:

            (windowSize - maxFreq) > k

        → decrement frequency of chars[left]
        → shrink window from the left

    - Once valid:
        → update longest substring length

*/

func optimized(_ input: String, _ k: Int) -> Int {
    var chars = Array(input)
    var freq: [Character: Int] = [:]
    var longest: Int = 0
    var left: Int = 0
    var maxFreq: Int = 0
    
    for right in 0..<chars.count {
        freq[chars[right], default: 0] += 1
        maxFreq = max(maxFreq, freq[chars[right]]!)
        
        while (right - left + 1) - maxFreq > k {
            freq[chars[left]]! -= 1
            left += 1
        }
        
        longest = max(longest, right - left + 1)
        
    }
    


    return longest
}

optimized("AABABBA", 1)

/*
 Phase 7 Validation Trace
 --------------------------------------------------
 Example:
 Input:  "AABABBA", k = 1
 Output: 4

 --------------------------------------------------
 Initial:

 chars   = ["A","A","B","A","B","B","A"]

 longest = 0
 maxFreq = 0

 left = 0

 freq = [:]

 --------------------------------------------------
 right = 0

 chars[right] = "A"

 freq = ["A": 1]

 maxFreq = max(0, 1) → 1

 windowSize = (0 - 0 + 1) = 1

 replacementsNeeded = 1 - 1 = 0

 valid window

 longest = max(0, 1) → 1

 window = ["A"]
           L R

 --------------------------------------------------
 right = 1

 chars[right] = "A"

 freq = ["A": 2]

 maxFreq = max(1, 2) → 2

 windowSize = (1 - 0 + 1) = 2

 replacementsNeeded = 2 - 2 = 0

 valid window

 longest = max(1, 2) → 2

 window = ["A","A"]
            L   R

 --------------------------------------------------
 right = 2

 chars[right] = "B"

 freq = ["A": 2, "B": 1]

 maxFreq = max(2, 1) → 2

 windowSize = (2 - 0 + 1) = 3

 replacementsNeeded = 3 - 2 = 1

 valid window

 longest = max(2, 3) → 3

 window = ["A","A","B"]
            L       R

 --------------------------------------------------
 right = 3

 chars[right] = "A"

 freq = ["A": 3, "B": 1]

 maxFreq = max(2, 3) → 3

 windowSize = (3 - 0 + 1) = 4

 replacementsNeeded = 4 - 3 = 1

 valid window

 longest = max(3, 4) → 4

 window = ["A","A","B","A"]
            L           R

 --------------------------------------------------
 right = 4

 chars[right] = "B"

 freq = ["A": 3, "B": 2]

 maxFreq = max(3, 2) → 3

 windowSize = (4 - 0 + 1) = 5

 replacementsNeeded = 5 - 3 = 2

 invalid window

 --------------------------------------------------
 shrink window:

 freq["A"] -= 1

 freq = ["A": 2, "B": 2]

 left = 1

 new windowSize = (4 - 1 + 1) = 4

 replacementsNeeded = 4 - 3 = 1

 valid again

 longest = max(4, 4) → 4

 window = ["A","B","A","B"]
                L       R

 --------------------------------------------------
 right = 5

 chars[right] = "B"

 freq = ["A": 2, "B": 3]

 maxFreq = max(3, 3) → 3

 windowSize = (5 - 1 + 1) = 5

 replacementsNeeded = 5 - 3 = 2

 invalid window

 --------------------------------------------------
 shrink window:

 freq["A"] -= 1

 freq = ["A": 1, "B": 3]

 left = 2

 new windowSize = (5 - 2 + 1) = 4

 replacementsNeeded = 4 - 3 = 1

 valid again

 longest = max(4, 4) → 4

 window = ["B","A","B","B"]
                    L   R

 --------------------------------------------------
 right = 6

 chars[right] = "A"

 freq = ["A": 2, "B": 3]

 maxFreq = max(3, 2) → 3

 windowSize = (6 - 2 + 1) = 5

 replacementsNeeded = 5 - 3 = 2

 invalid window

 --------------------------------------------------
 shrink window:

 freq["B"] -= 1

 freq = ["A": 2, "B": 2]

 left = 3

 new windowSize = (6 - 3 + 1) = 4

 replacementsNeeded = 4 - 3 = 1

 valid again

 longest = max(4, 4) → 4

 window = ["A","B","B","A"]
                       L R

 --------------------------------------------------
 Final Result:

 longest = 4

*/

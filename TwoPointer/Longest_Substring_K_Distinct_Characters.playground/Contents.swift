// MARK: - Problem Statement
/*
 MARK: - Problem: Longest Substring with At Most K Distinct Characters

 Goal:
 Find the longest substring containing at most k distinct characters.

 Example:
 Input:  s = "eceba", k = 2
 Output: 3
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:

 - What am I trying to find?

    Determine the longest substring containing at most k distinct characters.

 ------------------------------------------------------------

 - Obvious approach

    - Convert string into Array<Character>

    - Use two loops:
        - i = starting index
        - j = expanding ending index

    - For every substring chars[i...j]:

        - Maintain a frequency map for characters inside current substring

        - Insert chars[j] into frequency map

        - If distinct characters exceed k:
            → stop expanding current substring

        - Otherwise:
            → update longest substring length

 ------------------------------------------------------------

 - Performance Analysis

    Time Complexity: O(n²)
    Space Complexity: O(k)

*/
func bruteForce(_ s: String, _ k: Int) -> Int {
    
    var chars = Array(s)
    var longest: Int = 0
    
    for i in 0..<chars.count {
        var freq: [Character: Int] = [:]
        
        for j in i..<chars.count {
            freq[chars[j], default:0] += 1
            
            if freq.count > k {
               break
            }
            longest = max(longest, j - i + 1)
        }
    }

    return longest
}

bruteForce("eceba",2)



// MARK: - Phase 2: Manual Tracing

/*
 
 Example:
 Input:  s = "eceba", k = 2
 Output: 3

 Invariant:

    - During traversal of chars[i...j], freq stores the character frequencies of the current substring.

    - A substring remains valid as long as:
        freq.count <= k

 ------------------------------------------------------------

 Initial:

 chars = ["e", "c", "e", "b", "a"]

 longest = 0

 ------------------------------------------------------------
 i = 0

 freq = [:]

 ------------------------------------------------------------
 j = 0

 chars[j] = "e"

 freq = ["e": 1]

 freq.count = 1 <= 2 → valid

 longest = max(0, (0 - 0 + 1))  → 1

 ------------------------------------------------------------
 j = 1

 chars[j] = "c"

 freq = ["e": 1, "c": 1]

 freq.count = 2 <= 2 → valid

 longest = max(1, (1 - 0 + 1))  → 2

 ------------------------------------------------------------
 j = 2

 chars[j] = "e"

 freq = ["e": 2, "c": 1]

 freq.count = 2 <= 2 → valid

 longest = max(2, (2 - 0 + 1))  → 3

 ------------------------------------------------------------
 j = 3

 chars[j] = "b"

 freq = ["e": 2, "c": 1, "b": 1]

 freq.count = 3 > 2

 invalid window → break

 ------------------------------------------------------------
 continue and start from i = 1

 freq = [:]

 ------------------------------------------------------------
 i = 1

 j = 1

 chars[j] = "c"

 freq = ["c": 1]

 valid

 longest = max(3, 1)  → 3

 ------------------------------------------------------------
 j = 2

 chars[j] = "e"

 freq = ["c": 1, "e": 1]

 valid

 longest = max(3, 2)  → 3

 ------------------------------------------------------------
 j = 3

 chars[j] = "b"

 freq = ["c": 1, "e": 1, "b": 1]

 freq.count = 3 > 2

 invalid → break

 ------------------------------------------------------------
 continue and start from i = 2

 freq = [:]

 ------------------------------------------------------------
 j = 2

 chars[j] = "e"

 freq = ["e": 1]

 valid

 ------------------------------------------------------------
 j = 3

 chars[j] = "b"

 freq = ["e": 1, "b": 1]

 valid

 ------------------------------------------------------------
 j = 4

 chars[j] = "a"

 freq = ["e": 1, "b": 1, "a": 1]

 freq.count = 3 > 2

 invalid → break

 ------------------------------------------------------------

 Remaining windows produce no substring longer than length 3

 Final Answer:

 longest = 3

 substring = "ece"

*/

// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:

 - For every starting index, we repeatedly rebuild the frequency map and recheck overlapping substrings.

 - This leads to redundant work and O(n²) time complexity.

 ------------------------------------------------------------

 Key Inefficiency:

 - Each new starting index resets the hashmap and rescans many of the same characters again.

 ------------------------------------------------------------

 Key Insight (from tracing):

 - Instead of restarting for every substring, we can maintain one continuous dynamic sliding window.

 - A valid window must contain at most k distinct characters.

 - If the window becomes invalid:
        freq.count > k

    Instead of stopping:
        - Shrink the window from the left
        - Decrement left character frequency
        - Remove character if frequency becomes 0

 ------------------------------------------------------------

 Pattern Recognition:

 This maps directly to the Sliding Window pattern (a specialized form of Two Pointers).

 ------------------------------------------------------------

 Data Structure Insight:

 - Use two pointers:
        left  → shrinks window
        right → expands window

 - Hash Map:
        → tracks character frequencies inside current window

 - longest:
        → stores longest valid substring length

 ------------------------------------------------------------

 Algorithm:

 - Traverse using right pointer

 - Add chars[right] into frequency map

 - While distinct characters exceed k:
        - decrement chars[left]
        - remove character if frequency becomes 0
        - move left pointer forward

 - Update longest valid substring length

*/
// MARK: - Phase 4: Optimized Sliding Window (TP) Solution

func twoPointerSW(_ s: String, _ k: Int) -> Int {
    
    var chars = Array(s)
    var longest: Int  = 0
    
    var freq: [Character: Int] = [:]
    
    var left = 0
    
    for right in 0..<chars.count {
        freq[chars[right], default: 0] += 1
        
        while freq.count > k {
            freq[chars[left]]! -= 1
            
            if freq[chars[left]] == 0 {
                freq.removeValue(forKey: chars[left])
            }
            
            left += 1
        }
        
        longest = max(longest, right - left + 1)
        
    }
    
    return longest
}

twoPointerSW("eceba",2)

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)

    - Both left and right pointers only move forward
    - Each character is added and removed from the hashmap at most once

 ------------------------------------------------------------

 Space Complexity: O(k)

    - HashMap stores at most k distinct characters inside the sliding window

*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:

 The brute force approach repeatedly rebuilds the frequency map and rescans overlapping substrings.

 This leads to redundant work and O(n²) time complexity.

 ------------------------------------------------------------

 Core Insight:

 Instead of rebuilding state for every substring, we maintain a single dynamic sliding window with rolling character frequencies.

 ------------------------------------------------------------

 Key Constraint:

 A valid window must contain at most k distinct characters:
  - freq.count <= k

 If the window becomes invalid:
  - freq.count > k

 We shrink the window from the left until it becomes valid again.

 ------------------------------------------------------------

 Pattern Learned:

 The core of most sliding window problems is determining the window validity condition.

 This problem uses:
    - freq.count <= k

 However, many sliding window problems share the same framework while using different validity rules.
 
 Once the sliding window framework is understood, solving similar problems becomes a matter of identifying the correct validity condition.

*/

// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:
    - The current window [left, right] always contains at most k distinct characters
    - The frequency map reflects characters inside this window

 ------------------------------------------------------------

 Key Insight:

 This is a dynamic sliding window (two pointer) problem.

 - Convert string into Array<Character> for easier indexing
 - Use a frequency map to track characters in current window
 - Use two pointers:
        left  → shrinks window
        right → expands window

 ------------------------------------------------------------

 Algorithm:

 Traverse using right pointer:

    - Add chars[right] to frequency map

    - While freq.count > k:
        - decrement chars[left] frequency
        - remove it if frequency becomes 0
        - move left pointer forward

    - Update longest substring length:
        max(longest, right - left + 1)

*/

func optimized(_ s: String, _ k: Int) -> Int {
    
    var chars = Array(s)
    var longest: Int = 0
    
    var freq:[Character: Int] = [:]
    var left = 0
    
    for right in 0..<chars.count {
        freq[chars[right], default:0] += 1
        while freq.count > k {
            freq[chars[left]]! -= 1
            if freq[chars[left]] == 0 {
                freq.removeValue(forKey:chars[left])
            }
            
            left += 1
        }
        
        longest = max(longest, right - left + 1)
        
    }
    
    return longest
}

optimized("eceba",2)

/*
 Phase 7 Validation Trace
 --------------------------------------------------

 Input: s = "eceba", k = 2
 Output: 3

 ------------------------------------------------------------

 Initial:

 chars = ["e", "c", "e", "b", "a"]
 freq = [:]
 left = 0
 longest = 0

 ------------------------------------------------------------
 right = 0

 chars[right] = "e"
 freq = ["e":1]

 freq.count = 1 <= 2 → valid

 longest = 1

 window = "e"

 ------------------------------------------------------------
 right = 1

 chars[right] = "c"
 freq = ["e":1, "c":1]

 freq.count = 2 <= 2 → valid

 longest = 2

 window = "ec"

 ------------------------------------------------------------
 right = 2

 chars[right] = "e"
 freq = ["e":2, "c":1]

 freq.count = 2 <= 2 → valid

 longest = 3

 window = "ece"

 ------------------------------------------------------------
 right = 3

 chars[right] = "b"
 freq = ["e":2, "c":1, "b":1]

 freq.count = 3 > 2 → INVALID

 shrink left:

 remove "e" → freq = ["e":1, "c":1, "b":1]
 left = 1

 still invalid (3 > 2)

 remove "c" → freq = ["e":1, "b":1]
 left = 2

 now valid

 longest = max(3, 2) = 3

 window = "eb"

 ------------------------------------------------------------
 right = 4

 chars[right] = "a"
 freq = ["e":1, "b":1, "a":1]

 freq.count = 3 > 2 → INVALID

 shrink left:

 remove "e" → ["b":1, "a":1]
 left = 3

 now valid

 longest = 3

 window = "ba"

 ------------------------------------------------------------

 Final Answer = 3

*/

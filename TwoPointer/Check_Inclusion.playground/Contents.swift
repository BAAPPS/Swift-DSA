// MARK: - Problem Statement
/*
 MARK: - Problem: Check Inclusion (Permutation in String)

 Goal:
 Check if one string’s permutation exists in another.

 Example:
 Input:  s1 = "ab", s2 = "eidbaooo"
 Output: true
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:

 - What am I trying to find?

    Determine whether any substring of s2 is a permutation of s1.

 ------------------------------------------------------------

 - Key Observation:

    Two strings are permutations of each other if they contain the same character frequencies.

 ------------------------------------------------------------

 - Obvious approach:

    - Convert both strings into arrays of characters

    - Build a frequency map for s1

    - Traverse every possible substring in s2 with length equal to s1.count

    - For each substring:
        - Build a frequency map
        - Compare it with s1 frequency map

    - If both maps match:
        → permutation exists
        → return true

 ------------------------------------------------------------

 - Edge Case:
 
    - If s1.count > s2.count:
        → impossible to form permutation
        → return false

 ------------------------------------------------------------

 - Performance Analysis:

    Time Complexity: O(n * m)
        where:
            n = s2.count
            m = s1.count

        because we rebuild frequency maps for every substring.

    Space Complexity: O(k)
        where: k = character set size
*/

func bruteForce(_ s1: String, _ s2: String) -> Bool {
    
    // edgecase
    if s1.count > s2.count {
        return false
    }
    
    var chars1 = Array(s1)
    var chars2 = Array(s2)
    
    var s1Map: [Character: Int] = [:]
    
    for char in chars1 {
        s1Map[char, default: 0] += 1
    }

    let windowSize = chars1.count
    
    for i in 0..<(chars2.count - windowSize) {
        var s2Map: [Character: Int] = [:]
        
        for j in (i..<i+windowSize) {
            s2Map[chars2[j], default: 0] += 1
        }
        
        if s1Map == s2Map { return true }
    }
    return false
}

bruteForce("ab", "eidbaooo")



// MARK: - Phase 2: Manual Tracing

/*

 Example:
 Input:  s1 = "ab", s2 = "eidbaooo"
 Output: true

 Invariant:
 - During the inner loop, s2Map always represents the frequency count of the current substring
   chars2[i..<i + windowSize].
 
 ------------------------------------------------------------

 Initial:

 s1.count < s2.count → continue

 chars1 = ["a", "b"]

 chars2 = ["e", "i", "d", "b", "a", "o", "o", "o"]

 s1Map = ["a": 1, "b": 1]

 windowSize = 2

 ------------------------------------------------------------
 i = 0

 current substring:
 chars2[0..<2] → ["e", "i"]

 s2Map = [:]

 add "e"
 s2Map = ["e": 1]

 add "i"
 s2Map = ["e": 1, "i": 1]

 s1Map != s2Map

 ------------------------------------------------------------
 i = 1

 current substring:
 chars2[1..<3] → ["i", "d"]

 s2Map = [:]

 add "i"
 s2Map = ["i": 1]

 add "d"
 s2Map = ["i": 1, "d": 1]

 s1Map != s2Map

 ------------------------------------------------------------
 i = 2

 current substring:
 chars2[2..<4] → ["d", "b"]

 s2Map = [:]

 add "d"
 s2Map = ["d": 1]

 add "b"
 s2Map = ["d": 1, "b": 1]

 s1Map != s2Map

 ------------------------------------------------------------
 i = 3

 current substring:
 chars2[3..<5] → ["b", "a"]

 s2Map = [:]

 add "b"
 s2Map = ["b": 1]

 add "a"
 s2Map = ["b": 1, "a": 1]

 s1Map == s2Map

 permutation found

 return true

 ------------------------------------------------------------

 Final Result: true

*/


// MARK: - Phase 3: Pattern Discovery

/*
 
 Observation from Brute Force:
 
 For every starting index, we are always rebuild the frequnecy map of s2 and recompute character frequencies repeatedly.
 
 ------------------------------------------------------------

 Key Insight (from tracing):
 
 - We do not need to awlays rebuild the frequnecy map everytime.

 - Instead, we can maintain one continuous sliding window while dynamically tracking character frequencies.
 
 - For the given window size of s1, each time we finish checking the current window of size s1, we shrink the window and expand it forward
 
 ------------------------------------------------------------
  Pattern Recognition:

  This maps directly to a Fixed-Size Sliding Window pattern (a specialized form of Two Pointers).

  - right pointer
     → expands the window forward

  - left pointer
     → shrinks the window once the window exceeds s1.count

  ------------------------------------------------------------

  Hash Maps:

  - s1Map
     → stores required character frequencies

  - s2Map
     → stores frequencies inside the current window

  ------------------------------------------------------------

  Key Idea:

  Instead of rebuilding a new frequency map for every substring, we continuously update one sliding window by:

     - adding the new right character
     - removing the old left character

  This allows us to compare frequency maps in linear time.
 
*/

// MARK: - Phase 4: Optimized Two Pointer (Sliding Window) Solution

func twoPointerSW(_ s1: String, _ s2: String) -> Bool {
    
    var chars1 = Array(s1)
    var chars2 = Array(s2)
    
    var s1Map: [Character: Int] = [:]
    
    for char in chars1 {
        s1Map[char, default: 0] += 1
    }
    var left = 0
    
    var s2Map: [Character:Int] = [:]
    
    var windowSize = chars1.count
    
    for right in 0..<chars2.count {
        s2Map[chars2[right], default:0] += 1
        
        // shrink if window too large
        if right - left + 1 > windowSize {
            s2Map[chars2[left]]! -= 1
            
            if s2Map[chars2[left]] == 0 {
                s2Map.removeValue(forKey:chars2[left])
            }
            left += 1
        }

        if s1Map == s2Map {
             return true
         }
    }
    
    
    
    return false
}

twoPointerSW("ab", "eidbaooo")

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(m)
    where: m = s2.count

 ------------------------------------------------------------

 Why?

 - We build s1Map once: O(n)
 - We traverse s2 once using Sliding Window: O(m)
 - Each character is:
        - added once
        - removed once

 Therefore: O(n + m)

 Since traversal of s2 dominates → simplified to O(m)

 ------------------------------------------------------------

 Space Complexity: O(1)

 Why?

 - We only store character frequencies inside two hash maps.
 - If character set is fixed (English lowercase letters), the hashmap size never exceeds 26.
 
 Therefore: constant extra space

 ------------------------------------------------------------

 NOTE:

 If character set is NOT fixed, space complexity becomes: O(k)
 where: k = unique character count
 
*/


// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:

 The brute force approach repeatedly rebuilds the frequency map for every substring in s2
 and recomputes character frequencies from scratch.

 This leads to redundant work with time complexity of O(n * m).

 ------------------------------------------------------------

 Core Insight:

 Instead of rebuilding a new frequency map for every substring, we maintain a single
 fixed-size sliding window and dynamically update character frequencies as the window moves.

 ------------------------------------------------------------

 Key Idea:

 - The window size must always remain equal to s1.count

 - As the right pointer expands the window:
     → Add chars[right] into the frequency map

 - If the window exceeds the required size:
     → Shrink the window from the left
     → Decrement chars[left] frequency
     → If frequency becomes 0:
         → completely remove the character from the hashmap

 - Once the window size matches s1.count:
     → Compare the frequency maps

 - If both maps are equal:
     → permutation exists
     → return true

 ------------------------------------------------------------

 Pattern Learned:

 This problem uses a Fixed-Size Sliding Window, which is a specialized variation of the
 Two Pointer technique.

 Unlike dynamic sliding window problems, this window size never changes:
     fixed window size = s1.count

 The main challenge is maintaining a rolling frequency map efficiently while continuously
 adding new characters and removing old ones as the window slides forward.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:
 Key Insight:
*/

func optimized(_ s1: String, _ s2: String) -> Bool {
    

    return false
}

optimized("ab", "eidbaooo")

/*
 Phase 7 Validation Trace
 --------------------------------------------------

*/

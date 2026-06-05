// MARK: - Problem Statement
/*
 MARK: - Problem: Find All Anagrams in a String

 Goal:
 Find all start indices of anagrams of p in s.

 Example:
 Input:  s = "cbaebabacd", p = "abc"
 Output: [0,6]
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:

 - What am I trying to find?

   Find all starting indices in s where a substring is an anagram of p.

   An anagram means:
   - same character frequencies
   - order does not matter

 ------------------------------------------------------------

 - Obvious approach:

   - Convert s into Array<Character> for easier indexing
   - Build a frequency map for p

   - Traverse using two loops:
        - outer loop chooses starting index i
        - inner loop builds a substring of fixed size p.count

 ------------------------------------------------------------

 For every starting index i:

    - Build a frequency map for the substring s[i : i + p.count]

    - Compare it with p's frequency map

    - If they match:
        → add i to result

 ------------------------------------------------------------

 - Performance Analysis:

    Time Complexity: O(n * k)
    Space Complexity: O(k)
*/

func bruteForce(_ s: String, _ p: String) -> [Int] {
    
    var chars = Array(s)
    var result: [Int] = []
    let lookupP = p.reduce(into:[:]) { count, char in
        count[char, default: 0] += 1
    }
    
    let windowSize = p.count
    
    for i in 0...(chars.count - windowSize) {
        
        var freq: [Character: Int] = [:]
        
        for j in i..<(i + windowSize) {
            freq[chars[j], default: 0] += 1
        }
        
        if freq == lookupP {
            result.append(i)
        }
    }

    return result
}

bruteForce("cbaebabacd", "abc")



// MARK: - Phase 2: Manual Tracing

/*
 Example:
 Input:  s = "cbaebabacd", p = "abc"
 Output: [0,6]

 Invariant:
    freq represents characters in substring chars[i...j]

 ------------------------------------------------------------
 Initial:

 chars = ["c","b","a","e","b","a","b","a","c","d"]
 result = []
 lookupP = ["a":1,"b":1,"c":1]
 windowSize = 3

 ------------------------------------------------------------
 i = 0
 freq = [:]

 j = 0 → "c"
 freq = ["c":1]

 j = 1 → "b"
 freq = ["c":1,"b":1]

 j = 2 → "a"
 freq = ["c":1,"b":1,"a":1]

 freq == lookupP
 → result = [0]

 ------------------------------------------------------------
 i = 1
 freq = [:]

 j = 1 → "b"
 freq = ["b":1]

 j = 2 → "a"
 freq = ["b":1,"a":1]

 j = 3 → "e"
 freq = ["b":1,"a":1,"e":1]
 not match

 ------------------------------------------------------------
 i = 2
 freq = [:]

 j = 2 → "a"
 freq = ["a":1]

 j = 3 → "e"
 freq = ["a":1,"e":1]

 j = 4 → "b"
 freq = ["a":1,"e":1,"b":1]

 not match

 ------------------------------------------------------------
 i = 3
 ...

 ------------------------------------------------------------
 i = 6
 freq = [:]

 j = 6 → "b"
 j = 7 → "a"
 j = 8 → "c"

 freq = ["b":1,"a":1,"c":1]

 freq == lookupP
 → result = [0,6]
*/

// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:

 For every starting index, we rebuild the frequency map and recompute character frequencies repeatedly based on the fixed size of p.

 This leads to redundant work

 ------------------------------------------------------------
 
 
 Key Insight (from tracing):

 - We do not need to rebuild the frequency map every time.

 - Instead, we maintain one continuous sliding window while dynamically tracking character frequencies.

 - Once the current window of fixed size contains all required characters from p:
      - shrink the window from the left
      - continue shrinking while valid
      - expand forward again when invalid

 ------------------------------------------------------------

 Pattern Recognition:

 This maps directly to a fixed sized Sliding Window pattern (specialized form of Two Pointers).

 - right pointer
    → expands the window forward

 - left pointer
    → shrinks the window
      while the current window
      still remains valid

 - Hash Maps
    → track required frequencies
    → track current window frequencies
*/

// MARK: - Phase 4: Optimized Two Pointer SW Solution

func twoPointerSW(_ s: String, _ p: String) -> [Int] {
    var chars = Array(s)
    var result: [Int] = []
    
    let lookupP = p.reduce(into:[:]) { count, letter in
        count[letter, default: 0] += 1
    }
    var left = 0
    var freq:[Character:Int] = [:]
    
    let windowSize = p.count
    
    for right in 0..<chars.count {
        freq[chars[right], default: 0] += 1
        
        if right - left + 1 > windowSize {
            freq[chars[left]]! -= 1
            
            if freq[chars[left]] == 0 {
                freq.removeValue(forKey: chars[left])
            }
            left += 1
        }
        
        if right - left + 1  == windowSize {
            if freq == lookupP {
                result.append(left)
            }
        }
        
        
    }
    
    return result
}

twoPointerSW( "cbaebabacd", "abc")



// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
     - Each character is:
        added to the window once
        removed from the window at most once
 
     Even though you compare maps, the core sliding window work is linear.
     
 Space Complexity: O(k), where k = number of distinct characters in p
    Storing:
        - freq (window map)
        - lookupP (pattern map)
 
     Both grow based on distinct characters.
        Worst case: O(26) → O(1)
        General case:  O(k)
 
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:

 The brute force approach rebuilds a frequency map for every substring and revalidates it from scratch, leading to redundant work.

 ------------------------------------------------------------

 Core Insight:

 Instead of recomputing frequencies for every substring, we maintain a single fixed-size sliding window and update character frequencies incrementally.

 ------------------------------------------------------------

 Key Idea:

 - Expand window using right pointer:
     → add chars[right] to frequency map

 - If current window size exceeds p.count:
     → decrement chars[left] frequency
     → remove character if frequency becomes zero
     → shrink from left

 - When window size equals p.count:
     → compare frequency map of window with frequency map of p
     → if equal, add left index to result

 ------------------------------------------------------------

 Pattern Learned:

 This is a fixed-size Sliding Window problem, a specialized form of the Two Pointer technique.

 The key challenge is maintaining a valid window while preserving the fixed window size of p.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant (What is always true):
    - lookupS always stores the character frequencies of the current sliding window [left...right].
 
  Key Insight(Why the solution works):

  - An anagram contains the exact same character frequencies
    as string p, regardless of order.

  - Therefore, if we examine every substring of length p.count,
    any window whose character frequencies match p's frequencies
    must be an anagram.

  - Since all candidate substrings have the same fixed length,
    a sliding window allows us to efficiently move through the
    string without rebuilding frequencies from scratch.

  - As the window expands:
      - Add the new character entering from the right.
      - Remove the character leaving from the left.

  - At any moment:
      lookupS represents the frequencies of the current window.
      lookupP represents the frequencies required for an anagram.

  - Whenever the window size equals p.count:
      - Compare lookupS and lookupP.
      - If they match, the current window is an anagram,
        so record its starting index.
 */


func optimized(_ s: String, _ p: String) -> [Int] {
    
    var chars = Array(s)
    var result:[Int] = []

    let lookupP = p.reduce(into:[:]) { count, letter in
        count[letter, default: 0] += 1
    }
    
    let windowSize = p.count
    
    var lookupS: [Character: Int] = [:]
    var left = 0
    
    for right in 0..<chars.count {
        lookupS[chars[right], default: 0] += 1
        
        while (right - left + 1) > windowSize {
            lookupS[chars[left]]! -= 1
            if lookupS[chars[left]] == 0 {
                lookupS.removeValue(forKey:chars[left])
            }
            left += 1
        }
        
        if (right - left + 1) == windowSize {
            if lookupS == lookupP {
                result.append(left)
            }
        }
        
    }
    
    
    return result
}

optimized( "cbaebabacd", "abc")

/*
 Phase 7 Validation Trace
 --------------------------------------------------
  Example:

  Input:  s = "cbaebabacd", p = "abc"

  lookupP = ["a":1, "b":1, "c":1]
 
  windowSize = 3

  --------------------------------------------------

  Initial:

  left = 0
  lookupS = [:]

  --------------------------------------------------

  right = 0 ('c')

  lookupS = ["c":1]

  Window = "c"
  Size = 1

  --------------------------------------------------

  right = 1 ('b')

  lookupS = ["c":1, "b":1]

  Window = "cb"
  Size = 2

  --------------------------------------------------

  right = 2 ('a')

  lookupS = ["c":1, "b":1, "a":1]

  Window = "cba"
  Size = 3

  lookupS == lookupP

  result = [0]

  --------------------------------------------------

  right = 3 ('e')

  lookupS = ["c":1, "b":1, "a":1, "e":1]

  Window Size = 4 > 3

  Shrink:
  remove chars[left] = 'c'

  lookupS = ["b":1, "a":1, "e":1]

  left = 1

  Window = "bae"

  lookupS != lookupP

  --------------------------------------------------

  right = 4 ('b')

  lookupS = ["b":2, "a":1, "e":1]

  Window Size = 4 > 3

  Shrink:
  remove chars[left] = 'b'

  lookupS = ["b":1, "a":1, "e":1]

  left = 2

  Window = "aeb"

  lookupS != lookupP

  --------------------------------------------------

  right = 5 ('a')

  lookupS = ["b":1, "a":2, "e":1]

  Window Size = 4 > 3

  Shrink:
  remove chars[left] = 'a'

  lookupS = ["b":1, "a":1, "e":1]

  left = 3

  Window = "eba"

  lookupS != lookupP

  --------------------------------------------------

  right = 6 ('b')

  lookupS = ["b":2, "a":1, "e":1]

  Window Size = 4 > 3

  Shrink:
  remove chars[left] = 'e'

  lookupS = ["b":2, "a":1]

  left = 4

  Window = "bab"

  lookupS != lookupP

  --------------------------------------------------

  right = 7 ('a')

  lookupS = ["b":2, "a":2]

  Window Size = 4 > 3

  Shrink:
  remove chars[left] = 'b'

  lookupS = ["b":1, "a":2]

  left = 5

  Window = "aba"

  lookupS != lookupP

  --------------------------------------------------

  right = 8 ('c')

  lookupS = ["b":1, "a":2, "c":1]

  Window Size = 4 > 3

  Shrink:
  remove chars[left] = 'a'

  lookupS = ["b":1, "a":1, "c":1]

  left = 6

  Window = "bac"

  lookupS == lookupP

  result = [0, 6]

  --------------------------------------------------

  right = 9 ('d')

  lookupS = ["b":1, "a":1, "c":1, "d":1]

  Window Size = 4 > 3

  Shrink:
  remove chars[left] = 'b'

  lookupS = ["a":1, "c":1, "d":1]

  left = 7

  Window = "acd"

  lookupS != lookupP

  --------------------------------------------------

  Finished

  result = [0, 6]
 */
 
 

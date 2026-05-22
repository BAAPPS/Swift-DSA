// MARK: - Problem Statement
/*
 MARK: - Problem: Minimum Window Substring

 Goal:
 Find the smallest substring containing all characters of target.

 Example:
 Input:  s = "ADOBECODEBANC", t = "ABC"
 Output: "BANC"
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:

 - What am I trying to find?

    Find the smallest substring in s that contains all characters of t with correct frequencies.

 ------------------------------------------------------------

 Obvious Approach:

    - Convert s into Array<Character> for easier indexing

    - Build a frequency map for t

    - Traverse using two loops:
        - outer loop chooses starting index
        - inner loop expands substring forward

 ------------------------------------------------------------

 For every starting index i:

    - Create a new frequency map for the current substring

    - Expand j forward:
        - add chars[j] into current map

    - After every expansion:
        - check if current substring satisfies all required frequencies from t

    - Once valid:
        - calculate window length
        - update smallest substring if needed
        - break because further expansion
          only increases window size

 ------------------------------------------------------------

 Performance Analysis:

    Time Complexity: O(n²)
        - outer loop = n
        - inner expansion = at most n
        - frequency comparisons repeated

    Space Complexity: O(k)
        - hashmap storage

*/
func bruteForce(_ s: String, _ t: String) ->  String {
    
    var chars = Array(s)
    var result: [Character] = []
    let lookupT = t.reduce(into: [:]) { count, letter in
        count[letter,default: 0] += 1
    }
    
    for i in 0..<chars.count {
        var minLength = Int.max
        var freq:[Character: Int] = [:]
        for j in i..<chars.count {
            freq[chars[j], default: 0] += 1
            
            if lookupT.allSatisfy({char, count in
                freq[char, default: 0] >= count
            }) {
                let windowLength = j - i + 1
                
                if windowLength < minLength {
                    minLength = windowLength
                    result = Array(chars[i...j])
                }
            }
            
            
        }
    }

    return String(result)
}

bruteForce("ADOBECODEBANC", "ABC")



/*
 MARK: - Phase 2: Manual Tracing

 Example:
 Input:  s = "ADOBECODEBANC", t = "ABC"
 Output: "BANC"

 Invariant:

    - During the inner loop, freq always represents the frequency count of the current substring chars[i...j]

 ------------------------------------------------------------
 Initial:

 chars =
 ["A", "D", "O", "B", "E", "C", "O", "D", "E", "B", "A", "N", "C"]

 result = []

 lookupT = ["A": 1, "B": 1, "C": 1]

 minLength = Int.max

 ------------------------------------------------------------
 i = 0
 j = 0

 substring = "A"

 freq = ["A": 1]

 lookupT.allSatisfy → false
    missing:
       "B"
       "C"

 ------------------------------------------------------------
 i = 0
 j = 1

 substring = "AD"

 freq = ["A": 1, "D": 1]

 lookupT.allSatisfy → false
    missing:
       "B"
       "C"

 ------------------------------------------------------------
 i = 0
 j = 2

 substring = "ADO"

 freq = ["A": 1, "D": 1, "O": 1]

 lookupT.allSatisfy → false
    missing:
       "B"
       "C"

 ------------------------------------------------------------
 i = 0
 j = 3

 substring = "ADOB"

 freq = ["A": 1, "D": 1, "O": 1, "B": 1]

 lookupT.allSatisfy → false
    missing:
       "C"

 ------------------------------------------------------------
 i = 0
 j = 4

 substring = "ADOBE"

 freq =
 ["A": 1, "D": 1, "O": 1,
  "B": 1, "E": 1]

 lookupT.allSatisfy → false
    missing:
       "C"

 ------------------------------------------------------------
 i = 0
 j = 5

 substring = "ADOBEC"

 freq =
 ["A": 1, "D": 1, "O": 1,
  "B": 1, "E": 1, "C": 1]

 lookupT.allSatisfy → true

 currentLength = (5 - 0 + 1) = 6

 6 < Int.max → update result

 minLength = 6

 result = ["A","D","O","B","E","C"]

 break

 ------------------------------------------------------------
 i = 1

 freq = [:]

 ------------------------------------------------------------
 i = 1
 j = 1

 substring = "D"

 freq = ["D": 1]

 lookupT.allSatisfy → false
    missing:
       "A"
       "B"
       "C"

 ------------------------------------------------------------
 i = 1
 j = 2

 substring = "DO"

 freq = ["D": 1, "O": 1]

 lookupT.allSatisfy → false

 ------------------------------------------------------------
 i = 1
 j = 3

 substring = "DOB"

 freq = ["D": 1, "O": 1, "B": 1]

 lookupT.allSatisfy → false
    missing:
       "A"
       "C"

 ------------------------------------------------------------
 ...

 continue expanding until valid window found

 ------------------------------------------------------------
 i = 9
 j = 12

 substring = "BANC"

 freq =
 ["B": 1, "A": 1, "N": 1, "C": 1]

 lookupT.allSatisfy → true

 currentLength = (12 - 9 + 1) = 4

 4 < 6 → update result

 minLength = 4

 result = ["B","A","N","C"]

 break

 ------------------------------------------------------------

 Final Result:

 String(result)
    → "BANC"

*/

// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:

 For every starting index, we rebuild the frequency map and recompute character frequencies repeatedly.

 This leads to redundant work and O(n²) time complexity.

 ------------------------------------------------------------

 Key Insight (from tracing):

 - We do not need to rebuild the frequency map every time.

 - Instead, we maintain one continuous sliding window while dynamically tracking character frequencies.

 - Once the current window contains all required characters from t:
      - update the minimum substring
      - shrink the window from the left
      - continue shrinking while valid
      - expand forward again when invalid

 ------------------------------------------------------------

 Pattern Recognition:

 This maps directly to a Dynamic Sliding Window pattern (specialized form of Two Pointers).

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

func twoPointerSW(_ s: String, _ t: String) ->  String {
    var chars = Array(s)
    var result:[Character] = []
    let lookupT = t.reduce(into:[:]) { count, letter in
        count[letter, default:0] += 1
    }
    
    var left = 0
    var minLength = Int.max
    var lookupS: [Character: Int] = [:]
    
    for right in 0..<chars.count {
        lookupS[chars[right], default:0] += 1
        
        while lookupT.allSatisfy ({ char, count in
            lookupS[char, default: 0] >= count
        }) {
            
            if (right - left + 1) < minLength {
                minLength = right - left + 1
                result = Array(chars[left...right])
            }
            lookupS[chars[left]]! -= 1
            
            if lookupS[chars[left]] == 0 {
                lookupS.removeValue(forKey: chars[left])
            }
            left += 1
        }
        
    }
    
    
    return String(result)
}

twoPointerSW("ADOBECODEBANC", "ABC")

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n + m)
    where:
        - n = length of s
        - m = length of t

    Explanation:
        - Building lookupT takes O(m)
        - The right pointer traverses s once → O(n)
        - The left pointer also traverses s at most once while shrinking the window → O(n)
        - Hash map operations are O(1) average case

    Therefore: O(m + n + n) → O(n + m)

 ------------------------------------------------------------

 Space Complexity: O(k)

    where:
        - k = total unique characters stored inside both hash maps

    Explanation:
        - lookupT stores character frequencies from t
        - lookupS stores character frequencies inside the current window

    In the worst case:
        - both maps store all unique characters

*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:

 The brute force approach rebuilds a frequency map for every substring and revalidates it from scratch, leading to O(n²) time complexity.

 ------------------------------------------------------------

 Core Insight:

 Instead of recomputing frequencies for every substring, we maintain a single dynamic sliding window and update character frequencies incrementally.

 ------------------------------------------------------------

 Key Idea:

 - Expand window using right pointer:
     → add chars[right] to frequency map

 - While current window satisfies all requirements:
    - If current window length < minLength:
         → update minimum window length
         → store current best window
     → shrink from left to find smaller valid window
     → decrement frequency, remove if zero

 ------------------------------------------------------------

 Pattern Learned:

 This is a Dynamic Sliding Window problem, a specialized form of the Two Pointer technique.

 The key challenge is maintaining a valid window while continuously adjusting its boundaries
 and tracking the smallest valid substring.
*/
// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:

    - At any point during traversal, lookupS stores the character frequencies of the current
      sliding window chars[left...right]

 ------------------------------------------------------------
 Key Insight:

    - Convert s into an Array<Character> for easier indexing and traversal

    - Use:
        - lookupT → stores required character frequencies
        - lookupS → stores frequencies inside current window
        - left pointer → shrinks the window
        - right pointer → expands the window
        - minLength → stores the smallest valid window length found so far
        - result array → stores the current minimum valid substring

 ------------------------------------------------------------

 Dynamic Sliding Window:

    - First, traverse t and build its frequency map

    - Use lookupT to validate whether the current window contains all required character frequencies

 ------------------------------------------------------------

 Algorithm:

    - Traverse s using the right pointer

    - Insert chars[right] into lookupS

    - While current window satisfies all lookupT frequencies:

        - If current valid window is smaller than minLength:

            - Update minLength using:
                (right - left + 1)

            - Store current substring:
                chars[left...right]

        - Continue shrinking window from the left to search for a smaller valid substring

            - Decrement chars[left] frequency

            - If frequency becomes 0: remove character from lookupS

            - Move left pointer forward

*/

func optimized(_ s: String, _ t: String) ->  String {
    

    var chars = Array(s)
    var result: [Character] = []

    var lookupT = t.reduce(into: [:]) { count, letter in
        count[letter, default:0] += 1
    }
    
    var minLength = Int.max
    
    var left = 0
    var lookupS:[Character: Int] = [:]
    
    for right in 0..<chars.count {
        lookupS[chars[right], default: 0] += 1
        
        while lookupT.allSatisfy({ char,count in
            lookupS[char, default:0] >= count
        }) {
            
            if (right - left + 1) < minLength {
                minLength = right - left + 1
                result = Array(chars[left...right])
            }
            lookupS[chars[left]]! -= 1
            if lookupS[chars[left]] == 0 {
                lookupS.removeValue(forKey: chars[left])
            }
            left += 1
        }
        
    }
    
    
    return String(result)
}

optimized("ADOBECODEBANC", "ABC")
/*
 Phase 7 Validation Trace
 --------------------------------------------------

 Example:

 input: s = "ADOBECODEBANC", t = "ABC"
 output: "BANC"

 --------------------------------------------------

 Initial:

 chars = ["A","D","O","B","E","C","O","D","E","B","A","N","C"]

 result = []

 lookupT = ["A": 1, "B": 1, "C": 1]

 minLength = Int.max

 left = 0

 lookupS = [:]

 --------------------------------------------------
 right = 0

 chars[right] = "A"

 lookupS = ["A": 1]

 lookupT does not satisfy lookupS

 --------------------------------------------------
 right = 1

 chars[right] = "D"

 lookupS = ["A": 1, "D": 1]

 lookupT does not satisfy lookupS

 --------------------------------------------------
 right = 2

 chars[right] = "O"

 lookupS = ["A": 1, "D": 1, "O": 1]

 lookupT does not satisfy lookupS

 --------------------------------------------------
 right = 3

 chars[right] = "B"

 lookupS = ["A": 1, "D": 1, "O": 1, "B": 1]

 lookupT does not satisfy lookupS

 --------------------------------------------------
 right = 4

 chars[right] = "E"

 lookupS = ["A": 1, "D": 1, "O": 1, "B": 1, "E": 1]

 lookupT does not satisfy lookupS

 --------------------------------------------------
 right = 5

 chars[right] = "C"

 lookupS = ["A": 1, "D": 1, "O": 1, "B": 1, "E": 1, "C": 1]

 lookupT now satisfies lookupS

 currentLength = 5 - 0 + 1 = 6

 6 < Int.max
    → minLength = 6

    → result = ["A","D","O","B","E","C"]

 shrink window:

 remove chars[left] = "A"

 lookupS = ["D":1,"O":1,"B":1,"E":1,"C":1]

 left = 1

 lookupT no longer satisfies lookupS

 --------------------------------------------------
 right = 6

 chars[right] = "O"

 lookupS = ["D":1,"O":2,"B":1,"E":1,"C":1]

 lookupT does not satisfy lookupS

 --------------------------------------------------
 right = 7

 chars[right] = "D"

 lookupS = ["D":2,"O":2,"B":1,"E":1,"C":1]

 lookupT does not satisfy lookupS

 --------------------------------------------------
 right = 8

 chars[right] = "E"

 lookupS = ["D":2,"O":2,"B":1,"E":2,"C":1]

 lookupT does not satisfy lookupS

 --------------------------------------------------
 right = 9

 chars[right] = "B"

 lookupS = ["D":2,"O":2,"B":2,"E":2,"C":1]

 lookupT does not satisfy lookupS

 --------------------------------------------------
 right = 10

 chars[right] = "A"

 lookupS = ["A":1,"D":2,"O":2,"B":2,"E":2,"C":1]

 lookupT now satisfies lookupS

 currentLength = 10 - 1 + 1 = 10

 10 > 6
    → keep existing minimum

 shrink window:

 remove chars[left] = "D"

 lookupS = ["A":1,"D":1,"O":2,"B":2,"E":2,"C":1]

 left = 2

 lookupT still satisfies lookupS

 --------------------------------------------------

 currentLength = 10 - 2 + 1 = 9

 9 > 6

 shrink again:

 remove chars[left] = "O"

 lookupS = ["A":1,"D":1,"O":1,"B":2,"E":2,"C":1]

 left = 3

 lookupT still satisfies lookupS

 --------------------------------------------------

 currentLength = 10 - 3 + 1 = 8

 8 > 6

 shrink again:

 remove chars[left] = "B"

 lookupS = ["A":1,"D":1,"O":1,"B":1,"E":2,"C":1]

 left = 4

 lookupT still satisfies lookupS

 --------------------------------------------------

 currentLength = 10 - 4 + 1 = 7

 7 > 6

 shrink again:

 remove chars[left] = "E"

 lookupS = ["A":1,"D":1,"O":1,"B":1,"E":1,"C":1]

 left = 5

 lookupT still satisfies lookupS

 --------------------------------------------------

 currentLength = 10 - 5 + 1 = 6

 6 == 6

 shrink again:

 remove chars[left] = "C"

 lookupS = ["A":1,"D":1,"O":1,"B":1,"E":1]

 left = 6

 lookupT no longer satisfies lookupS

 --------------------------------------------------
 right = 11

 chars[right] = "N"

 lookupS = ["A":1,"D":1,"O":1,"B":1,"E":1,"N":1]

 lookupT does not satisfy lookupS

 --------------------------------------------------
 right = 12

 chars[right] = "C"

 lookupS = ["A":1,"D":1,"O":1,"B":1,"E":1,"N":1,"C":1]

 lookupT now satisfies lookupS

 currentLength = 12 - 6 + 1 = 7

 7 > 6

 shrink window:

 remove chars[left] = "O"

 lookupS = ["A":1,"D":1,"B":1,"E":1,"N":1,"C":1]

 left = 7

 lookupT still satisfies lookupS

 --------------------------------------------------

 currentLength = 12 - 7 + 1 = 6

 6 == 6

 shrink again:

 remove chars[left] = "D"

 lookupS = ["A":1,"B":1,"E":1,"N":1,"C":1]

 left = 8

 lookupT still satisfies lookupS

 --------------------------------------------------

 currentLength = 12 - 8 + 1 = 5

 5 < 6

 → minLength = 5

 → result = ["E","B","A","N","C"]

 shrink again:

 remove chars[left] = "E"

 lookupS = ["A":1,"B":1,"N":1,"C":1]

 left = 9

 lookupT still satisfies lookupS

 --------------------------------------------------

 currentLength = 12 - 9 + 1 = 4

 4 < 5

 → minLength = 4

 → result = ["B","A","N","C"]

 shrink again:

 remove chars[left] = "B"

 lookupS = ["A":1,"N":1,"C":1]

 left = 10

 lookupT no longer satisfies lookupS

 --------------------------------------------------

 Final Result: "BANC"

*/
 

// MARK: - Problem Statement
/*
 MARK: - Problem: Remove Duplicates from String

 Goal:
 Remove consecutive duplicate characters in-place.

 Example:
 Input:  "aaabbc"
 Output: "abc"
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
    Remove consecutive duplicate characters from the string
    while modifying the string in-place.
 

 - Obvious approach
 
    Use two pointers to traverse the string:
    
        - Pointer i → points to the current character
        - Pointer j → scans forward from i to check for duplicates
    
    For each position i:
    
        - Move j to the next index (i + 1)
        - While the next character is the same as the current:
            - Remove the duplicate character at index j
            - Do NOT move j forward after removal,
              because the string shifts left
        
        - Once duplicates are removed, move i forward
          to continue scanning the string
        

 - Key Insight
 
    Since we only care about consecutive duplicates,
    we do NOT need to scan the entire rest of the string—
    only adjacent characters.
    

 - Performance Analysis
    
    Time Complexity: O(n²)
     - Outer loop → O(n)
     - Each removal → O(n) due to shifting
     - In worst case (e.g. "aaaaa"), many removals occur
    
    Space Complexity: O(1)
     - Modifications are done in-place
 */

func bruteForce(_ input: inout String){

    var i = input.startIndex
    
    while i < input.endIndex {
        var j = input.index(after:i)
        
        while j < input.endIndex && input[i] == input[j] {
                input.remove(at:j)
            }
        i = input.index(after:i)
    }
}

var str =  "aaabbc"

bruteForce(&str)




// MARK: - Phase 2: Manual Tracing

/*
 Example:
 Input:  "aaabbc"
 Output: "abc"
 
 Invariant:
 - At each step, the prefix before i contains no consecutive duplicates,
   and we are currently removing duplicates for the character at i
 ----------------------------------------------------

 Initial: "aaabbc"

 ----------------------------------------------------
 i = 0, j = 1

 input[0] (a) == input[1] (a)
 → remove at j (1) → "aabbc"

 input[0] (a) == input[1] (a)
 → remove at j (1) → "abbc"

 input[0] (a) != input[1] (b)
 → stop inner loop

 i = 1

 ----------------------------------------------------
 i = 1, j = 2

 input[1] (b) == input[2] (b)
 → remove at j (2) → "abc"

 input[1] (b) != input[2] (c)
 → stop inner loop

 i = 2

 ----------------------------------------------------
 i = 2, j = 3 (endIndex)

 no duplicates → move i

 i = 3 (end)

 ----------------------------------------------------
 Final Output: "abc"
*/
 


// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:
 
 - For each character at index i, we compare it with the next character (j = i + 1)
 
 - While the next character is the same (consecutive duplicate),
   we repeatedly remove it using remove(at: j)
 
 - We stop once a different character is encountered,
   then move i forward to process the next group


 ----------------------------------------------------
 
 Key Inefficiency:

 - The main cost comes from remove(at:), which is O(n)
   because all subsequent characters must be shifted left
 
 - In cases with many duplicates (e.g. "aaaaa"),
   multiple removals lead to an overall O(n²) time complexity


 ------------------------------------------------------------
 
 Key Insight (from tracing):

 - We only need to compare adjacent (consecutive) characters,
   not scan the entire string
 
 - Once duplicates for a character are removed,
   that position is finalized and we move forward
 
 - The problem naturally breaks into processing
   consecutive "groups" of characters


 ------------------------------------------------------------
 
 Pattern Recognition:

 - This can be optimized using a Two Pointer pattern
 
     - Slow pointer (write pointer):
         Tracks the position to place the next unique character
 
     - Fast pointer (read pointer):
         Scans through the string to find new characters


 ------------------------------------------------------------
 
 Data Structure Insight (toward optimal solution):

 - Instead of removing characters (costly),
   we overwrite duplicates using the slow pointer
 
 - This avoids shifting and reduces time complexity to O(n)
*/

// MARK: - Phase 4: Optimized Two Pointer Solution

// Time: O(n)
// Space: O(1) extra (amortized)
func twoPointer(_ input: inout String){
    
    guard !input.isEmpty else { return }
    
    var left: String.Index = input.startIndex
    var right: String.Index = input.index(after: left)
    
    var lastKept = input[left]
    while right < input.endIndex{
        
        let current = input[right]
    
        if current != lastKept {
            left = input.index(after:left)
            input.replaceSubrange(left...left, with:String(current))
            lastKept = current
            
        }
        right = input.index(after:right)
    }
    
    let nextIndex = input.index(after:left)
    input.removeSubrange(nextIndex..<input.endIndex)
    
}


// without replaceSubrange
// O(n) time / space
func twoPointer2(_ input: inout String) {
    var chars = Array(input)
    var left = 0
    var lastKept = chars[left]
    
    for right in 1..<chars.count {
        var current = chars[right]
        
        if current != lastKept {
            left += 1
            chars[left] = chars[right]
            lastKept = current
        }
    }
    
    input = String(chars[0...left])
    
}

var str1 = "aaabbc"

twoPointer(&str1)

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)


 Space Complexity: O(1)

*/


// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:
 
 The brute force approach compares character at index i with j (j = i + 1).
 
 While the next character is the same (consecutive duplicate), we repeatedly remove it using remove(at: j).
 
 However, remove(at:) shifts all subsequent characters to the left, making each removal O(n), leading to an overall O(n²) time complexity in cases with long duplicate chains (e.g. "aaaaa").

 ------------------------------------------------------------

 Key Insight:

 We only need to eliminate consecutive duplicates.

 Therefore, physically removing characters is unnecessary.
 Instead, we can maintain a "compressed region" in the same string.

 ------------------------------------------------------------

 Fast & Slow Pointer Pattern:

 We use two pointers:

 - left (slow / write pointer)
   → tracks the end of the valid compressed result

 - right (fast / read pointer)
   → scans through the string


 ------------------------------------------------------------

 Core Idea:

 When we encounter a NEW character (different from last kept):

 - We extend the valid region by moving the left pointer forward
 - We "write" the new character into that position
 - We update lastKept to reflect the latest accepted character

 If the character is the same as lastKept:
 - We simply skip it (no write operation needed)
 
 
 At the end, we might have left over characters, so we remove these using     let nextIndex = input.index(after:left)
 input.removeSubrange(nextIndex..<input.endIndex)
 ------------------------------------------------------------
 
 Final Cleanup Step:

 During traversal, the left pointer represents the last valid position
 of the compressed (deduplicated) region.

 However, the original string may still contain leftover characters
 beyond this boundary that are no longer part of the valid result.

 Therefore, we explicitly trim the string to keep only the valid region:

 let nextIndex = input.index(after: left)
 input.removeSubrange(nextIndex..<input.endIndex)

 This ensures the string reflects exactly the compressed result.

 ------------------------------------------------------------

 Final Result:

 This transforms the problem from repeated deletion (O(n²)) into a single pass overwrite process (O(n)), achieving optimal time complexity with O(1) extra space.
 
 ------------------------------------------------------------
 
  Pattern Learned:

  This problem requires reducing consecutive duplicates in-place.

  In Swift, there are two valid approaches:
  - Converting to an array of characters (simpler mutation, but uses extra space)
  - Using String.Index to operate directly on the String without full conversion

  Using String.Index allows us to work directly on the original string
  while maintaining correctness with Swift’s Unicode-safe indexing system.

  To modify the string during traversal, we use:
  - replaceSubrange(...) to overwrite/extend the valid region

  At the end, since the string may still contain unused trailing characters
  beyond the valid region, we finalize the result using:
  - removeSubrange(...) to truncate everything after the last valid index
 
  However, even though the problem encourages an in-place solution, using String.Index is just one valid approach in Swift.

  In practice, converting the string into an array of charactersis often simpler to implement and reason about, since it avoids the complexity of String.Index and range-based mutations.

  Tradeoff:
     - Array approach → simpler logic, but uses O(n) extra space
     - String.Index approach → avoids full conversion, but introduces more complexity due to Swift’s String mutation rules

  In real-world scenarios, I would choose based on:
     - clarity and maintainability (array approach)
     - or strict space constraints (String.Index approach)
*/

// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:  At any point in time, everything from index 0 → left is already compressed with no consecutive duplicates.

 Key Insight:
*/

func optimized(_ input: inout String) {
    

}


var str2 = "aaabbc"

optimized(&str2)

/*
 Phase 7 Validation Trace
 --------------------------------------------------

*/

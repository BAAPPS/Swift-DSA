// MARK: - Problem Statement
/*
 MARK: - Problem: Reverse String

 Level: Beginner

 Goal:
 Reverse the array in-place using O(1) space.

 Pattern:
 Opposite Direction Two Pointer

 Key Idea:
 Swap elements from both ends moving inward.

 Example:
 Input:  ["h","e","l","l","o"]
 Output: ["o","l","l","e","h"]
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
    Given an array of characters, we want to reverse the string in-place
 

 - Obvious approach
 
    The most obvious approach:
 
 
        - Traverse using two loops:
 
            - First to traverse from left-to-right
 
            - Second to traverse from right-to-left
 
        - As we traverse, we perform insertion reversal:
            - We store the first element in a temporary variable
            - We shift all elements to the right
 
        - After we're done shifting, we move the stored temp element to be first
 
 
 - Performance Analysis
 
    Time Complexity: O(n^2)
        - Nested loop shifting elements
 
    Space Complexity: O(1)
        - We are reversing in-place so no extra space is required
 
 */

func bruteForce(_ input: inout [String]) {
    
    for i in 0..<input.count {
       // Move input[i] to the front by shifting all elements to the right
       let temp = input[i]
        for j in stride(from: i, through: 1, by: -1) {
            input[j] = input[j - 1]
        }
        input[0] = temp
    }
}

var arr =  ["h","e","l","l","o"]

bruteForce(&arr)



// MARK: - Phase 2: Manual Tracing

/*
 Example:
 Input:  ["h","e","l","l","o"]
 Output: ["o","l","l","e","h"]
 
 Invariant:
 After each iteration i, the subarray [0...i] is the reverse of the original prefix.
 
 ----------------------------------------------------
 
 Initial State:
 
 input = ["h","e","l","l","o"]
 
 ----------------------------------------------------
 
 i = 0
 temp = input[0] = "h"
 (no shifting happens because i = 0)
 input[0] = "h"
 
 input = ["h","e","l","l","o"]
 
 ----------------------------------------------------
 
 i = 1
 temp = input[1] = "e"
 
 Shift:
 j = 1
 input[1] = input[0] → "h"
 input = ["h","h","l","l","o"]
 
 Insert:
 input[0] = "e"
 
 input = ["e","h","l","l","o"]
 
 ----------------------------------------------------

 i = 2
 temp = input[2] = "l"
 
 Shift:
 j = 2
 input[2] = input[1] → "h"
 input = ["e","h","h","l","o"]
 
 j = 1
 input[1] = input[0] → "e"
 input = ["e","e","h","l","o"]
 
 Insert:
 input[0] = "l"
 
 input = ["l","e","h","l","o"]
 ----------------------------------------------------
 
 i = 3
 temp = input[3] = "l"

 Shift:
 j = 3
 input[3] = input[2] → "h"
 input = ["l","e","h","h","o"]
 
 j = 2
 input[2] = input[1] → "e"
 input = ["l","e","e","h","o"]
 
 j = 1
 input[1] = input[0]  → "l"
 input = ["l","l","e","h","o"]
 
 Insert:
 input[0] = "l"
 
 input = ["l","l","e","h","o"]
 
 ----------------------------------------------------
 i = 4
 temp = input[4] = "o"
 
 Shift:
 j = 4
 input[4] = input[3] → "h"
 input = ["l","l","e","h","h"]
 
 j = 3
 input[3] = input[2] → "e"
 input = ["l","l","e","e","h"]
 
 j = 2
 input[2] = input[1] → "l"
 input = ["l","l","l","e","h"]
 
 j = 1
 input[1] = input[0] → "l"
 input = ["l","l","l","e","h"]
 
 Insert:
 input[0] = "o"
 
 input = ["o","l","l","e","h"]

 ----------------------------------------------------
 
 
 */


// MARK: - Phase 3: Pattern Discovery

/*
 
 Observation from Brute Force:
 
 - We repeatedly shift the subarray [0...i] to insert elements at the front
 - This causes repeated movement of the same elements → O(n²) time complexity
 
 ------------------------------------------------------------
 
 Inefficiency:
 
 - Each insertion shifts many elements unnecessarily
 - We are moving elements instead of placing them directly in final positions

 ------------------------------------------------------------
 
 Key Insight (from tracing):

 - The final reversed array pairs elements symmetrically:
     first ↔ last
     second ↔ second last
     etc.

 - No element needs to be "shifted" — only swapped with its mirror position

 ------------------------------------------------------------
 
 Pattern Recognition:

 - This is not an insertion/shift problem
 - It is a symmetric pairing problem
 
 ------------------------------------------------------------
 
 Data Structure Insight:

 - We can use Two Pointers:
     left starts at index 0
     right starts at index n - 1

 - While left < right:
     swap(input[left], input[right])
     move pointers inward
 
 
*/

// MARK: - Phase 4: Optimized Two Pointer Solution

func twoPointer(_ input: inout [String])   {
    var left = 0
    var right = input.count - 1
    
    while left < right {
//        let temp = input[left]
//        input[left] = input[right]
//        input[right] = temp
        input.swapAt(left, right)
        left += 1
        right -= 1
    }
}


var arr2 =  ["h","e","l","l","o"]

twoPointer(&arr2)

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
    - We traverse the array using two pointers moving inward
    - Each element is swapped at most once
    - Total operations scale linearly with input size

 Space Complexity: O(1)
    - All operations are performed in-place
    - Only a constant amount of extra variables is used
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Pattern Learned:

 The brute force approach repeatedly shifts the subarray [0...i] to insert elements at the front,
 which leads to unnecessary repeated work.

 ------------------------------------------------------------

 Core Insight:

 From the Phase 2 tracing, we observe that the reversed array is formed by pairing elements
 at symmetric (mirror) positions:

    first ↔ last
    second ↔ second last
    etc.

 This shows that the problem is not about insertion or shifting,  but about mirror symmetry across the array center.

 ------------------------------------------------------------

 Data Structure / Pattern:

 We can apply the Two Pointer technique:

    - left starts at index 0
    - right starts at index n - 1

 While left < right:
    - swap elements at left and right
    - move both pointers inward

 ------------------------------------------------------------
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

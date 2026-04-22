// MARK: - Problem Statement
/*
 MARK: - Problem: Move Zeroes

 Goal:
 Move all zeros to the end while maintaining order.

 Example:
 Input:  [0,1,0,3,12]
 Output: [1,3,12,0,0]
 */
// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:

 - What am I trying to do?

    Move all zeros to the end of the array while maintaining the relative order of non-zero elements.

 ------------------------------------------------------------

 Obvious approach:

 - For each index i:

    - If input[i] is 0, search for the next non-zero element in the remaining array

    - Swap the zero with that non-zero element

 - This gradually pushes zeros toward the end

 ------------------------------------------------------------

 Performance Analysis:

 Time Complexity: O(n^2)

    - In the worst case, for each zero, we scan the remaining array to find a non-zero element

 Space Complexity: O(1)

    - No additional space is used; operations are done in-place
*/

func bruteForce(_ input: inout [Int]) {
    
    for i in 0..<input.count {
        for j in i+1..<input.count {
            if input[i] == 0 && input[j] != 0 {
                input.swapAt(i, j)
                break
            }
        }
    }
}

var arr = [0,1,0,3,12]

bruteForce(&arr)



// MARK: - Phase 2: Manual Tracing

/*
 
 Example:
 Input:  [0,1,0,3,12]
 Output: [1,3,12,0,0]
 
 Invariant:
   - At any point, all elements before index i are already correctly positioned, with non-zero elements moved forward and zeros shifted toward the end.

 Justification:
     - At each index i, if input[i] is 0, we search for the next non-zero element
       and swap it into position i.

     - Once this swap occurs, position i is fixed with the correct value.

     - If no non-zero element is found, the remaining elements must all be zeros,
       which are already in their correct final positions.

     - Therefore, after processing index i, all elements before i are correctly positioned,
       and we never revisit them again.

  ----------------------------------------------------
 
 Initial: [0,1,0,3,12]

 ----------------------------------------------------

 i = 0, j = 1
 input[0] = 0, input[1] = 1 → swap → [1,0,0,3,12]

 ----------------------------------------------------

 i = 1, j = 2
 input[1] = 0, input[2] = 0 → continue

 i = 1, j = 3
 input[1] = 0, input[3] = 3 → swap → [1,3,0,0,12]

 ----------------------------------------------------

 i = 2, j = 3
 input[2] = 0, input[3] = 0 → continue

 i = 2, j = 4
 input[2] = 0, input[4] = 12 → swap → [1,3,12,0,0]

 ----------------------------------------------------

 Final: [1,3,12,0,0]

 */


// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:

 - We check all possible pairs (i, j) before swapping, resulting in O(n^2) time.

 ------------------------------------------------------------
 
 Key Insight (from tracing):
 
 - For each index position, we check if current is a zero and next element is a non zero and perform a swap if needed
 
 - Instead of checking current and next element everytime, we scan perform a linear scan from left to right for zeros and right to left for non zeros and swap
 
 ------------------------------------------------------------
 
 Pattern Recognition:

 - This is a Two Pointer (Same Direction / Slow-Fast Pointer) pattern

 - right pointer scans the array
 - left pointer tracks the position to place the next non-zero element

 - At each step:

     - If input[right] is non-zero:
         - Swap it with input[left]
         - Increment left pointer

 - This ensures all non-zero elements are compacted at the front,
   while zeros are pushed toward the end
 
*/

// MARK: - Phase 4: Optimized Two Pointer Solution

func twoPointer(_ input: inout [Int]){

    var leftPointer: Int = 0
    
    for rightPointer in 0..<input.count {
        if input[rightPointer] != 0 {
            input.swapAt(leftPointer, rightPointer)
            leftPointer += 1
        }
    }
}

var arr2 = [0,1,0,3,12,0]

twoPointer(&arr2)

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
 - Each element is visited exactly once by the right pointer
 - Each non-zero element is swapped at most once

 Space Complexity: O(1)
 - No additional data structures are used
 - All operations are performed in-place
 
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:
 
 The brute force approach repeatedly scans ahead to find the next non-zero
 element for swapping, leading to O(n^2) time complexity.

 ------------------------------------------------------------
 
 Core Insight:

 Instead of searching for elements to swap, we can directly place non-zero
 elements into their correct positions during a single linear scan.

 ------------------------------------------------------------

 Pattern Recognition:
 
 This is a Two Pointer (Same Direction / Slow-Fast Pointer) pattern.
 
 - Left pointer tracks the position to place the next non-zero element
 - Right pointer scans the array
 
 At each step:
 
    - If input[right] is non-zero:
        - Swap it with input[left]
        - Increment left pointer
 
 This ensures all non-zero elements are compacted at the front, while zeros are naturally shifted to the end.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:
    - All indices < left are guaranteed to be non-zero and in correct order
 
 Key Insight:
 
    - Using Two Pointers:
 
        - Left pointer tracks the position to place the next non-zero element
        - Right pointer scans the array
 
    - At each step:
 
        - If input[right] != 0:
 
            - Swap places with input[left]
 
            - Increment left pointer to place the next available non-zero element
 
*/

func optimized(_ input: inout [Int]){
    
    var leftIndex: Int = 0
    
    for rightIndex in 0..<input.count {
        
        if input[rightIndex] != 0 {
            input.swapAt(leftIndex, rightIndex)
            leftIndex += 1
        }
        
    }
    
}

var arr3 = [1, 3, 0, 2, 4, 0]

optimized(&arr3)

/*
 Phase 7 Validation Trace
 --------------------------------------------------
 Initial:
 [1, 3, 0, 2, 4, 0]

 --------------------------------------------------

 leftIndex = 0, rightIndex = 0
 input[0] = 1 → non-zero

 leftIndex == rightIndex → already correct position
 leftIndex = 1

 --------------------------------------------------

 leftIndex = 1, rightIndex = 1
 input[1] = 3 → non-zero

 leftIndex == rightIndex → already correct position
 leftIndex = 2

 --------------------------------------------------

 leftIndex = 2, rightIndex = 2
 input[2] = 0 → skip

 --------------------------------------------------

 leftIndex = 2, rightIndex = 3
 input[3] = 2 → non-zero

 swap(2, 3)
 → [1, 3, 2, 0, 4, 0]

 leftIndex = 3

 --------------------------------------------------

 leftIndex = 3, rightIndex = 4
 input[4] = 4 → non-zero

 swap(3, 4)
 → [1, 3, 2, 4, 0, 0]

 leftIndex = 4

 --------------------------------------------------

 leftIndex = 4, rightIndex = 5
 input[5] = 0 → skip

 --------------------------------------------------

 Final:
 [1, 3, 2, 4, 0, 0]
 
*/

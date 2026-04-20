// MARK: - Problem Statement
/*
 MARK: - Problem 3: Two Sum II (Sorted)

 Goal:
 Find two numbers such that they add up to a target.

 Example:
 Input:  numbers = [2,7,11,15], target = 9
 Output: [1,2]
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
    Given a sorted array, we are trying to determine which two numbers add up to the target
 

 - Obvious approach
 
    The most obvious approach:
 
        - Create a result array to store the indices of the two numbers
 
        - Traverse using two loops:
 
            - First loop to traverse current element
 
            - Second loop to traverse all other elements
 
 
        - As we traverse, we check which two numbers sum up to the target
 
 
        - if found, add its indices in the result array in 1 based indexed format
 
 
 - Performance Analysis
 
  Time Complexity: O(n^2)

     - Two nested loops check all possible pairs

  Space Complexity: O(1)

     - Only a constant amount of extra space is used

  Note:
     - This approach does not utilize the sorted property of the array
 
 */

func bruteForce(_ input: [Int], _ target: Int) -> [Int] {
    
    for i in 0..<input.count {
        for j in i+1..<input.count {
            if input[i] + input[j] == target{
                return [i+1, j+1]
            }
        }
    }
    return []
}

bruteForce([2,7,11,15], 9)



// MARK: - Phase 2: Manual Tracing

/*
 Example:
 Input:  numbers = [0,1,2,7], target = 7
 Output: [1,4]
 
 Invariant:
    - At any point, all previously checked pairs (i, j) have been verified not to sum to the target.

 Justification:
    - If any pair summed to the target, the algorithm would have already returned, so any pair we continue past must be invalid.

  ----------------------------------------------------
   i = 0, j = 1
 
       input[0] = 0, input[1] = 1
       0 + 1 = 1 → 1 != 7
 
   i = 0, j = 2

      input[0] = 0, input[2] = 2
      0 + 2 = 2  → 2 != 7
 
  i = 0, j = 3

      input[0] = 0, input[3] = 7
      0 + 7 = 7  → 7 == 7  → return [1, 4]
     
 */


// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:

 - We check all possible pairs (i, j), resulting in O(n^2) time.
 - Many comparisons are unnecessary due to the sorted nature of the array.

 ------------------------------------------------------------

 Key Insight (from tracing):

 - The array is sorted, so:
 
    - If the sum is too small → we need a larger number
    - If the sum is too large → we need a smaller number

 - Instead of checking all pairs, we can eliminate entire ranges
   of possibilities based on the sum.

 ------------------------------------------------------------

 Pattern Recognition:

 - This leads to the Two Pointer (Opposite Ends) pattern:

    - left starts at the beginning (smallest value)
    - right starts at the end (largest value)

 - At each step:

    - If sum < target → move left pointer right (increase sum)
    - If sum > target → move right pointer left (decrease sum)

 - This allows us to find the solution in O(n) time
   by systematically narrowing the search space.
 
 ------------------------------------------------------------
 
 Data Structure Insight:

 - Use two pointers:
     left starts at index 0
     right starts at index n - 1
 
 - While left < right:
 
    - If the sum of elements at left and right pointers is less than target:
 
        - Increment left pointer to increase the sum
 
    - else if the sum of elements at left and right pointers is greater than target:
 
        - Decrement right pointer to decrease the sum
 
    - Otherwise, sum is equal to target, return [left+1, right+1]
 
*/

// MARK: - Phase 4: Optimized Two Pointer Solution

func twoPointer(_ input: [Int], _ target: Int) -> [Int]  {
    
    var left: Int = 0
    var right: Int = input.count - 1
    
    while left < right {
        let sum = input[left] + input[right]
        
        if sum < target {
            left += 1
        } else if sum > target {
            right -= 1
        } else {
            return [left + 1, right + 1]
        }
        
    }
    
    return []
}

twoPointer([0,1,2,7], 7)

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
    - Each element is processed once

 Space Complexity: O(1)
    - Only constant (2) of extra space is used

 
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:
 
 The brute force approach does not utilize the sorted property of the array,
 resulting in repeated comparisons and O(n^2) time complexity.

 ------------------------------------------------------------

 Core Insight:

 Since the array is sorted, we can use this ordering to make directional decisions
 and eliminate entire ranges of invalid pairs.

 - If the sum is too small → all smaller elements will also be too small
 - If the sum is too large → all larger elements will also be too large

 This allows us to safely discard portions of the search space.

 ------------------------------------------------------------

 Pattern Recognition:

 This is a classic Two Pointer (Opposite Ends) pattern.

 - left pointer starts at the beginning (smallest value)
 - right pointer starts at the end (largest value)

 While left < right:

    - If sum < target → increment left pointer to increase sum
    - If sum > target → decrement right pointer to decrease sum
    - Otherwise → return [left + 1, right + 1]

 ------------------------------------------------------------

 Reflection:

 Although the array was already sorted, performing the brute force approach
 helped reveal the inefficiency and led to recognizing how ordering enables
 elimination of unnecessary comparisons.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:
 
    - At any point, all pairs outside the current [left, right] window cannot sum to the target
    
 Justification:
 
     - If sum < target, increasing the left pointer is the only way to increase the sum,
     because all values to the left are smaller.

     - If sum > target, decreasing the right pointer is the only way to decrease the sum,
     because all values to the right are larger.
 
    - Therefore, we can safely eliminate portions of the search space at each step
 
 Key Insight:
 
    - Use Two Pointer:
 
        - Left pointer pointing at index 0
 
        - Right pointer pointing at index n - 1
 
    - While left < right
 
        - If sum < target
 
            - Increment left pointer to check for a larger value
 
        - Else if sum > target
 
            - Decrement right pointer to check for a smaller value
 
        - Otherwise, we have a valid pair that equals target
 
            - return [left + 1, right + 1]
 
    - If no valid pairs exists, return []
 
*/

func optimized(_ input: [Int], _ target: Int) -> [Int] {
    
    var left: Int = 0
    
    var right: Int = input.count - 1
    
    while left < right {
       let sum = input[left] + input[right]
        
        if sum < target {
            left += 1
        } else if sum > target {
            right -= 1
        } else {
            return [left + 1, right + 1]
        }
    }
    
    return []
}

optimized([1, 2, 3, 4], 6)

/*
 Phase 7: Validation Trace
 --------------------------------------------------

 Example:
 input = [1,2,3,4], target = 6

 --------------------------------------------------

 Initial State:
 left = 0 (value = 1)
 right = 3 (value = 4)

 Step 1:
 sum = 1 + 4 = 5 < 6
 → sum too small, move left pointer right

 left = 1

 --------------------------------------------------

 Step 2:
 left = 1 (value = 2)
 right = 3 (value = 4)

 sum = 2 + 4 = 6 == 6
 → valid pair found

 return [2, 4]

 --------------------------------------------------
*/

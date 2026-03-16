// MARK: - Problem Statement
/*
  MARK: - Problem 2: Next Smaller Element

  Goal:
      Given an array of integers, find the next smaller element to the right of each element.

      If there is no smaller element to the right, return -1.

  Example 1:
      Input:  [4, 5, 2, 10, 8]
      Output: [2, 2, -1, 8, -1]

  Example 2:
      Input:  [3, 7, 1, 7, 8]
      Output: [1, 1, -1, -1, -1]
 */
 
// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:

 - What are we trying to find?

    For each element in the array, we want to determine the next smaller element to its right.

    The "next smaller element" means the first element encountered to the right that is strictly smaller than the current element.

    If no such element exists, we return -1 for that position.


 - Obvious Approach (Brute Force)

    The simplest solution is to compare each element with all elements to its right until a smaller value is found.

    Steps:

    1. Create a result array initialized with -1 for every index.
       - This allows us to automatically handle cases where no smaller element exists.

    2. Use two loops:

       - The first loop selects the current element.
       - The second loop scans the elements to the right.

    3. During the scan:

       - If we find an element smaller than the current element, we record that value in the result array.

       - Since we only care about the first smaller element, we stop scanning immediately once it is found.


 - Performance Analysis

   - Time Complexity: O(n²)
       - In the worst case, every element scans all remaining elements to its right.

   - Space Complexity: O(n)
       - A separate result array is used to store the answer.
*/

func bruteForce(_ input: [Int]) -> [Int] {
    
    var result:[Int] = Array(repeating: -1, count: input.count)
    
    for i in 0..<input.count {
        for j in i+1..<input.count {
            if input[j] < input[i] {
                result[i] = input[j]
                break
            }
        }
    }

    return result
}

bruteForce([4, 5, 2, 10, 8])


// MARK: - Phase 2: Manual Tracing

/*
 Example:
     Input:  [3, 7, 1, 7, 8]
     Output: [1, 1, -1, -1, -1]

 Invariant:
     For each index i, we scan elements to the right until we either
     find the first smaller element or reach the end of the array.

 ----------------------------------------------------

 Initial State

 Result = [-1, -1, -1, -1, -1]

 ----------------------------------------------------

 Step 1

    i = 0
    current = 3

    j = 1 → input[j] = 7
    7 > 3 → continue searching

    j = 2 → input[j] = 1
    1 < 3 → next smaller element found

    result[0] = 1
    break

    Result = [1, -1, -1, -1, -1]

 ----------------------------------------------------

 Step 2

    i = 1
    current = 7

    j = 2 → input[j] = 1
    1 < 7 → next smaller element found

    result[1] = 1
    break

    Result = [1, 1, -1, -1, -1]

 ----------------------------------------------------

 Step 3

    i = 2
    current = 1

    j = 3 → input[j] = 7
    7 > 1 → continue

    j = 4 → input[j] = 8
    8 > 1 → continue

    No smaller element found

    Result = [1, 1, -1, -1, -1]

 ----------------------------------------------------

 Step 4

    i = 3
    current = 7

    j = 4 → input[j] = 8
    8 > 7 → continue

    No smaller element found

    Result = [1, 1, -1, -1, -1]

 ----------------------------------------------------

 Step 5

    i = 4
    current = 8

    No elements to the right

    Result = [1, 1, -1, -1, -1]
 */

// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:

    For every index i, we scan forward through the array until we find
    the next smaller element to the right.

    This means we repeatedly perform the same search operation for multiple elements.


 ------------------------------------------------------------

 Inefficiency:

    The brute force solution scans the future portion of the array for every index.

    Many elements are rechecked multiple times, which leads to redundant work and results in O(n²) time complexity.


 ------------------------------------------------------------

 Key Observation:

    While scanning from left to right, some elements are still "waiting" for their next smaller element.

    Instead of rescanning the array for each element, we can keep track of these unresolved elements.


 ------------------------------------------------------------

 Pattern Recognition:

    When a smaller number appears, it can resolve the "next smaller element" for multiple previous elements.

    This suggests that we should maintain a structure that stores indices of elements whose next smaller value has not yet been found.


 ------------------------------------------------------------

 Data Structure Insight:

    A stack is a natural fit for this because it allows us to track unresolved indices and resolve them in reverse order.


 ------------------------------------------------------------

 Optimization Strategy:

    By maintaining a Monotonic Increasing Stack:

    - The stack stores indices of elements waiting for their next smaller element.

    - When a smaller value appears, we pop indices from the stack and resolve their result immediately.

    - Each element is pushed and popped at most once.

    This reduces the time complexity from O(n²) → O(n).
*/
// MARK: - Phase 4: Optimized Monotonic Decreasing Stack Solution

func nextSmallerElement(_ input: [Int]) -> [Int] {
    
    // Stack stores indices of unresolved elements
    var stack: [Int] = []
    
    // Default result is -1 if no smaller element exists
    var result = Array(repeating: -1, count: input.count)
    
    for (i, current) in input.enumerated() {
        
        // Resolve elements larger than current
        while let lastIndex = stack.last, input[lastIndex] > current {
            let resolvedIndex = stack.removeLast()
            result[resolvedIndex] = current
        }
        
        stack.append(i)
    }
    
    return result
}

nextSmallerElement([3, 7, 1, 7, 8])

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
 - We are scanning each element, pushing and popping it once

 Space Complexity: O(n)
 - The stack may hold up to n indices in the worst case
 - The result array stores n values
 
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:

 The brute force approach repeatedly scans the right side of the array to determine whether a smaller element exists. This results in redundant work and leads to O(n²) time complexity.

 The key observation is that when a smaller element appears, it can resolve the "next smaller element" for multiple elements that appeared earlier n the array.

 Instead of repeatedly scanning forward, we can track indices whose next smaller element has not yet been found.

 Using a stack allows us to store these unresolved indices.

 When the current element is smaller than the element at the top of the stack:

    - The current element is the next smaller element for that index.

    - We pop the index from the stack.

    - We update the result for that index.

 This process may resolve multiple indices at once.

 Because each index is pushed onto the stack once and popped at most once, the total number of stack operations is linear, resulting in an O(n) time complexity.
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

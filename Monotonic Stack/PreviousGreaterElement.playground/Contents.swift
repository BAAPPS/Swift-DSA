// MARK: - Problem Statement
/*
 MARK: - Problem 3: Previous Greater Element

 Goal:
     For each element in the array, find the nearest greater element to its left.

     If none exists, return -1.

 Example 1:
     Input:  [2, 5, 3, 7, 1]
     Output: [-1, -1, 5, -1, 7]

 Example 2:
     Input:  [1, 6, 4, 10, 2]
     Output: [-1, -1, 6, -1, 10]
*/

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
    For each element, find the nearest greater element to its left.
    If none exists, return -1.
 

 - Obvious approach
 
    - Initialize a result array filled with -1 (default case when no greater element exists)
 
    - Use two loops:
 
        1. Outer loop to iterate through each element (current index i)
 
        2. Inner loop to scan left from (i - 1 → 0)
 
    - For each current element:
 
        - Check each element to its left
 
        - If a previous element is greater than the current:
 
            - Update result[i] with that value
 
            - Break immediately since we want the nearest greater element
 
        - If no greater element is found, result[i] remains -1
 

 - Performance Analysis
    
    Time Complexity: O(n^2)
        - In the worst case, we scan all previous elements for each index
 
    Space Complexity: O(n)
        - Additional array used to store results
*/

func bruteForce(_ input: [Int]) -> [Int] {

    var result:[Int] = Array(repeating:-1, count: input.count)
    
    for i in 0..<input.count {
        let current = input[i]
        
        for j in stride(from: i - 1, through: 0, by: -1) {
            let previous = input[j]
            
            if previous > current {
                result[i] = previous
                break
            }
        }
        
    }

    return result
}

bruteForce([2, 5, 3, 7, 1])



// MARK: - Phase 2: Manual Tracing

/*
 
 Example:
     Input:  [2, 5, 3, 7, 1]
     Output: [-1, -1, 5, -1, 7]

 Invariant:
    At each index i, we check elements to the left in reverse order (from i-1 down to 0)
    and stop at the first element greater than input[i], ensuring we capture the nearest greater element.

 ----------------------------------------------------

 Initial State

 Result = [-1, -1, -1, -1, -1]

 ----------------------------------------------------
 
 Step 1
 
    i = 0
    current = 2
 
    No elements to the left
    result[0] = -1
 
 ----------------------------------------------------
 
 Step 2
 
    i = 1
    current = 5
 
    j = 0 → previous = 2 → 2 < 5
 
    No greater element found
    result[1] = -1
 
 ----------------------------------------------------
 
 Step 3
 
    i = 2
    current = 3
 
    j = 1 → previous = 5 → 5 > 3
 
    Found nearest greater element
    result[2] = 5
    break
 
 ----------------------------------------------------
 
 Step 4
 
    i = 3
    current = 7
 
    j = 2 → previous = 3 → 3 < 7
    j = 1 → previous = 5 → 5 < 7
    j = 0 → previous = 2 → 2 < 7
 
    No greater element found
    result[3] = -1
 
 ----------------------------------------------------
 
 Step 5
 
    i = 4
    current = 1
 
    j = 3 → previous = 7 → 7 > 1
 
    Found nearest greater element
    result[4] = 7
    break
 
 ----------------------------------------------------
 
 End of traversal
 
 Result = [-1, -1, 5, -1, 7]

 */


// MARK: - Phase 3: Pattern Discovery

/*
 
 Observation from Brute Force:

    At each index i, we scan elements to the left (from i-1 down to 0)
    until we find the first greater element.

    This repeated backward scanning leads to redundant work.


 ------------------------------------------------------------
 
 
 Inefficiency:

    For every index, we may re-scan many of the same elements,
    resulting in O(n²) time complexity.
 
 ------------------------------------------------------------
 
 Key Observation:

    While scanning left, many elements are not useful candidates
    because they are smaller than the current element.

    These smaller elements will never be the "previous greater"
    for the current or any future larger elements.
 
 ------------------------------------------------------------

 Pattern Recognition:
 
    We can eliminate unnecessary comparisons by maintaining
    a set of useful candidates from the left.

    Specifically:
    
    - If an element is smaller than the current element,
      it can never serve as a previous greater element again.
 
 ------------------------------------------------------------

 Data Structure Insight:

    A stack is a natural fit because it allows us to efficiently
    maintain and update candidates in a last-in, first-out manner.

 ------------------------------------------------------------

 Optimization Strategy:

    By maintaining a Monotonic Decreasing Stack:

    - The stack stores elements (or indices) in decreasing order

    - Before processing the current element:
        - Pop all elements from the stack that are <= current
          (they are no longer useful)

    - The top of the stack (if any) is the nearest greater element

    - Push the current element onto the stack

    - Each element is pushed and popped at most once

    This reduces time complexity from O(n²) → O(n)
*/

// MARK: - Phase 4: Optimized Monotonic Decreasing Stack Solution

func monotonicDecreasingStack(_ input: [Int]) -> [Int] {
    
    var stack: [Int] = []
    var result: [Int] = Array(repeating: -1, count: input.count)
    
    
    for i in 0..<input.count {
        let current = input[i]
        while let lastIndex = stack.last, input[lastIndex] <= current {
            _ = stack.popLast()
        }
        
        if let top = stack.last {
            result[i] = input[top]
        }
        stack.append(i)
    }
 return result
}

monotonicDecreasingStack([1, 6, 4, 10, 2])

/*
 Time Complexity: O(n)

    Each element is pushed onto the stack once and popped at most once.
    Therefore, the total number of stack operations is linear.

 Space Complexity: O(n)

    We use a stack to store indices and a result array to store the output,
    both of which can grow up to size n in the worst case.
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:
 
 The brute force approach scans elements to the left (from i-1 down to 0)
 until it finds the first greater element. This results in repeated work
 and leads to O(n²) time complexity.
 
 The key observation is that as we process each element, many previous
 elements become irrelevant if they are less than or equal to the current element.
 These elements can never be the previous greater element for any future values,
 so we remove them.
 
 Instead of rescanning the left side, we maintain a stack of useful candidates
 from the past (elements greater than the current).
 
 By keeping the stack in decreasing order, the top of the stack always
 represents the nearest greater element to the left (if it exists).
 
 The key distinction is that, in this problem, the stack is used to provide
 the answer for the current element, rather than resolving previous elements.
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

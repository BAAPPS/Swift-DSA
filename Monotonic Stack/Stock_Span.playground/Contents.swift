// MARK: - Problem Statement
/*
 MARK: - Problem 6: Stock Span Problem
 
 Goal:
 Given daily stock prices, compute the span of each day.
 
 The span is defined as the number of consecutive days before the current day where the price was less than or equal to today's price.
 
 Example 1:
 Input:  [100, 80, 60, 70, 60, 75, 85]
 Output: [1, 1, 1, 2, 1, 4, 6]
 
 Example 2:
 Input:  [10, 20, 30, 40]
 Output: [1, 2, 3, 4]
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
 For each day, we compute the span, defined as the number of consecutive days before (and
 including) the current day where the price is less than or equal to the current day's
 price.
 
 
 - Obvious approach
 
 - Initialize a result array with 1s, since each day counts itself
 
 - Use two loops:
 
 - Outer loop to iterate through each day
 - Inner loop to scan previous days in reverse (i-1 → 0)
 
 - For each previous day:
 
 - If previous day ≤ current day:
 increment the span count by 1
 
 - Otherwise:
 break (since we only care about consecutive days)
 
 - Return the result array
 
 
 - Performance Analysis
 
 - Time Complexity: O(n²)
 For each day, we may scan all previous days
 
 - Space Complexity: O(n)
 We use a result array to store spans
 */

func bruteForce(_ input: [Int]) -> [Int] {
    var result:[Int] = Array(repeating: 1, count: input.count)
    for i in 0..<input.count {
        let current = input[i]
        for j in stride(from: i - 1, through: 0, by: -1) {
            if input[j] <= current {
                result[i] += 1
            } else {
                break
            }
        }
        
    }
    
    return result
}

bruteForce([100, 80, 60, 70, 60, 75, 85])



// MARK: - Phase 2: Manual Tracing

/*
 Example:
 Input:  [10, 20, 30, 40]
 Output: [1, 2, 3, 4]
 
 Invariant:
 For each index i, we scan left (i-1 → 0) and count consecutive days where the price is
 less than or equal to the current day. We stop when we encounter a greater price.
 
 ----------------------------------------------------
 
 Initial State
 
 result = [1, 1, 1, 1]
 
 ----------------------------------------------------
 
 Step 1
 
 i = 0
 current = 10
 
 No elements to the left
 result[0] = 1
 
 ----------------------------------------------------
 
 Step 2
 
 i = 1
 current = 20
 
 j = 0 → input[0] = 10
 
 10 <= 20 → valid span
 result[1] += 1 → result[1] = 2
 
 ----------------------------------------------------
 
 Step 3
 
 i = 2
 current = 30
 
 j = 1 → input[1] = 20
 20 <= 30 → result[2] += 1 → result[2] = 2
 
 j = 0 → input[0] = 10
 10 <= 30 → result[2] += 1 → result[2] = 3
 
 ----------------------------------------------------
 
 Step 4
 
 i = 3
 current = 40
 
 j = 2 → input[2] = 30
 30 <= 40 → result[3] += 1 → result[3] = 2
 
 j = 1 → input[1] = 20
 20 <= 40 → result[3] += 1 → result[3] = 3
 
 j = 0 → input[0] = 10
 10 <= 40 → result[3] += 1 → result[3] = 4
 
 ----------------------------------------------------
 
 End of traversal
 
 result = [1, 2, 3, 4]
 
 ----------------------------------------------------
 
 Additional Case (Break Condition)
 
 Example:
 Input: [100, 80]
 
 i = 1
 current = 80
 
 j = 0 → input[0] = 100
 
 100 > 80 → break (not a valid span)
 
 result[1] = 1
 
 ----------------------------------------------------
 */

// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:

 For every index i, we scan backward to count consecutive days
 where the price is less than or equal to the current price.

 This leads to repeatedly scanning the same elements multiple times.
 
 ------------------------------------------------------------
 
 Inefficiency:

 The brute force solution scans the previous portion of the array
 for every index.

 Many elements are rechecked multiple times, leading to redundant
 work and O(n²) time complexity.
 
 ------------------------------------------------------------
 
 Key Observation:

 While scanning left, we are counting consecutive elements that
 satisfy the condition.

 If a previous element has already computed its span, we can reuse
 that information instead of scanning one-by-one.
 
 ------------------------------------------------------------
 
 Pattern Recognition:

 Instead of checking each previous element individually, we can
 "jump" across spans that were already computed.

 This suggests maintaining a structure that stores indices of
 useful previous elements that can help compute the span efficiently.
 
 ------------------------------------------------------------
 
 Data Structure Insight:

 A stack is a natural fit because it allows us to keep track of
 relevant previous indices and efficiently skip over smaller values.
 
 ------------------------------------------------------------
 
 Optimization Strategy:

 By maintaining a Monotonic Decreasing Stack:

 - The stack stores indices of elements in decreasing order

 - For each current element:
     - Pop all elements smaller than or equal to current
     - Use the remaining top to compute the span distance

 - Each element is pushed and popped at most once
 
 This reduces the time complexity from O(n²) → O(n)
*/

// MARK: - Phase 4: Optimized Monotonic Decreasing Stack Solution

func monotonicDecreasingStack(_ input: [Int]) -> [Int] {
    var stack:[Int] = []
    var result: [Int] = Array(repeating:1, count: input.count)
    
    for i in 0..<input.count {
        let current = input[i]
        
        while let lastIndex = stack.last, input[lastIndex] <= current {
            _ = stack.popLast()
        }
        
        if let lastIndex = stack.last {
            result[i] = i - lastIndex
        } else {
            result[i] = i + 1
        }
        stack.append(i)
    }
    
    
    return result
}

monotonicDecreasingStack([1, 3, 2, 4])

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
    - Each element is pushed onto the stack once and popped at most once.
    - Therefore, the total number of stack operations is linear.
 
 
 Space Complexity: O(n)
    - We use additional space for the stack and the result array.
    - In the worst case, the stack may store all elements.
 
 */

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:

 The brute force approach scans previous elements (from i-1 to 0) until it finds a greater
 element. This leads to redundant work because the same elements are repeatedly checked.

 The key observation is that we only care about consecutive elements that are less than or
 equal to the current element.

 Instead of scanning, we can use a monotonic decreasing stack to maintain potential "boundary"
 elements.

 By popping all elements less than or equal to the current element, the top of the stack
 becomes the previous greater element, which serves as the left boundary of the span.

 The span is then calculated as the distance between the current index and this boundary.

 Thus, this problem is a boundary and distance problem, where the stack helps us efficiently
 locate the previous greater element, rather than resolving previous elements or directly
 building the answer.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*
 
Invariant:
    - The stack stores indices of elements in decreasing order.
    - After removing elements less than or equal to the current value,
      the top of the stack represents the previous greater element (boundary).

Key Insight:
    - Elements less than or equal to the current element cannot act as boundaries, so they are removed from the stack.

    - After popping, the top of the stack (if it exists) is the previous greater element, which serves as the left boundary.

    - The span is calculated as the distance between the current index and this boundary.

    - If no boundary exists, the span extends to the beginning of the array.
 
*/

func optimized(_ input: [Int]) -> [Int] {
    var stack: [Int] = []
    var result: [Int] = Array(repeating: 1, count: input.count)
    
    for i in 0..<input.count {
        while let lastIndex = stack.last, input[lastIndex] <= input[i] {
            _ = stack.popLast()
        }
        
        if let lastIndex = stack.last {
            result[i] = i - lastIndex
        } else {
            result[i] = i + 1
        }
        
        
        stack.append(i)
    }
    
    return result
}

optimized([1, 3, 2, 4])


/*
 Phase 7 Validation Trace
 --------------------------------------------------

 Input: [1, 3, 2, 4]

 Initial:
 stack = []
 result = [1, 1, 1, 1]

 --------------------------------------------------

 Step 1:

 i = 0
 current = 1

 Stack before popping: []

 → No elements to pop

 → No boundary exists

 span = i + 1 = 0 + 1 = 1

 result[0] = 1

 Push index 0

 Stack after push: [0]

 --------------------------------------------------

 Step 2:

 i = 1
 current = 3

 Stack before popping: [0]

 → input[0] = 1 ≤ 3 → pop

 Stack after popping: []

 → No boundary exists

 span = i + 1 = 1 + 1 = 2

 result[1] = 2

 Push index 1

 Stack after push: [1]

 --------------------------------------------------

 Step 3:

 i = 2
 current = 2

 Stack before popping: [1]

 → input[1] = 3 > 2 → stop popping

 → boundary = 1 (value = 3)

 span = i - boundary = 2 - 1 = 1

 result[2] = 1

 Push index 2

 Stack after push: [1, 2]

 --------------------------------------------------

 Step 4:

 i = 3
 current = 4

 Stack before popping: [1, 2]

 → input[2] = 2 ≤ 4 → pop
 → input[1] = 3 ≤ 4 → pop

 Stack after popping: []

 → No boundary exists

 span = i + 1 = 3 + 1 = 4

 result[3] = 4

 Push index 3

 Stack after push: [3]

 --------------------------------------------------

 End of traversal

 Final result = [1, 2, 1, 4]

 --------------------------------------------------

 Key Observations:

 - Stack stores indices in decreasing order of values
 - After popping, the top of the stack is the previous greater element (boundary)
 - Span is computed as distance to that boundary

*/

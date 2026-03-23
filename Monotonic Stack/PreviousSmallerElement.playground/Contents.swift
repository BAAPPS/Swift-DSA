// MARK: - Problem Statement
/*
 MARK: - Problem 4: Previous Smaller Element
 
 Goal:
 For each element, find the nearest smaller element to its left.
 
 If none exists, return -1.
 
 Example 1:
 Input:  [4, 5, 2, 10, 8]
 Output: [-1, 4, -1, 2, 2]
 
 Example 2:
 Input:  [3, 1, 4, 2]
 Output: [-1, -1, 1, 1]
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
 For this problem, we are trying to find the nearest smaller element to the left of the current element. If none exists, we return -1.
 
 
 - Obvious approach
 
 The most obvious approach:
 
 - Create an array and populate it with -1 values based on the count of our given input array
 
 Create two loops:
 - Outer loop to iterate through each element
 - Inner loop to scan left (i-1 → 0)
 
 - As we traverse backward, we check:
 
 - If the previous element is less than the current element.
 
 - If so, we update our array with the previous element
 
 - break, as we only need the first smallest element
 
 - Otherwise, our value of -1 remains unchanged
 
 -   We return the final array
 
 
 - Performance Analysis
 
 
 - Time Complexity: O(n^2)
 
 - For each element, we may scan all elements to its left
 
 
 - Space Complexity: O(n)
 
 - Using an array to store our findngs
 
 
 */

func bruteForce(_ input: [Int]) -> [Int] {
    
    var result: [Int] =  Array(repeating: -1, count: input.count)
    
    for i in 0..<input.count {
        let current = input[i]
        for j in stride(from: i - 1, through: 0, by: -1) {
            let previous =  input[j]
            if previous < current {
                result[i] = previous
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
 Input:  [3, 1, 4, 2]
 Output: [-1, -1, 1, 1]
 
 Invariant:
 At each index i, we check elements to the left in reverse order (from i-1 down to 0)
 and stop at the first element smaller than input[i], ensuring we capture the nearest
 smaller element.
 
 ----------------------------------------------------
 
 Step 1
 
 i = 0
 current = 3
 
 No elements to the left
 result[0] = -1
 
 ----------------------------------------------------
 
 Step 2
 
 i = 1
 current = 1
 
 j = 0 → previous = 3
 
 3 > 1 → not smaller
 
 No smaller element found
 result[1] = -1
 
 ----------------------------------------------------
 
 Step 3
 
 i = 2
 current = 4
 
 j = 1 → previous = 1
 
 1 < 4 → found smaller
 
 result[2] = 1
 break
 
 ----------------------------------------------------
 
 Step 4
 
 i = 3
 current = 2
 
 j = 2 → previous = 4 → 4 > 2
 j = 1 → previous = 1 → 1 < 2
 
 found smaller
 
 result[3] = 1
 break
 
 ----------------------------------------------------
 
 End of loop
 
 result = [-1, -1, 1, 1]
 
 */

// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:
 
 At each index i, we scan elements to its left from (i-1 to 0) until we find the first smaller element
 
 This process of backward scanning causes a lot of repeated work
 
 
 ------------------------------------------------------------
 
 Inefficiency:
 
 For every index, we may need to scan the same element multiple times.
 As a result, the time complexity will be O(n^2)
 
 ------------------------------------------------------------
 
 Key Observation:
 
 While scanning left, elements greater than or equal to the current are not useful candidates, because they cannot be the nearest smaller for the current or any future elements.
 
 Therefore, we remove them to maintain only valid candidates.
 
 ------------------------------------------------------------
 
 Pattern Recognition:
 
 We can eliminate unnecessary comparisons by maintaing a set of useful candidates from the left
 
 Specifically:
 
 - If elements are greater than the current element, it will never be used so we can safely discard them
 
 ------------------------------------------------------------
 
 Data Structure Insight:
 
 A stack is a natural fit for this process, because we are able to maintain and update candidates based on last-in, first-out manner.
 ------------------------------------------------------------
 
 Optimization Strategy:
 
 By maintaining a Monotic Increasing Stack:
 
 - The stack store index in increasing order
 
 - Before processing the current element:
 
 - Pop all elements from the stack if last element in the stack is >= current
 
 - If any element is remaining then top of the stack will be our nearest smaller element
 
 - Push the current elements indice to the stack
 
 This reduces time complexity from O(n²) → O(n) as each element is pushed and popped at most once
 
 */

// MARK: - Phase 4: Optimized Monotonic Decreasing Stack Solution

func monotonicIncreasingStack(_ input: [Int]) -> [Int] {
    var stack:[Int] = []
    var result: [Int] = Array(repeating: -1, count: input.count)
    
    for i in 0..<input.count {
        let current = input[i]
        while let lastIndex = stack.last, input[lastIndex] >= current {
            _ = stack.popLast()
        }
        
        if let top = stack.last {
            result[i] = input[top]
        }
        stack.append(i)
    }
    
    return result
}

monotonicIncreasingStack([1, 3, 2, 4])

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)

    Each element is pushed onto the stack once and popped at most once.
    Although there is a while loop, the total number of stack operations across the entire
    traversal is linear.

 Space Complexity: O(n)

    We use a stack to store indices and a result array to store the output, both of which can
    grow up to size n.
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:
 
 The brute force approach scans elements to the left (from i-1 down to 0), causing the same elements to be revisited multiple times. This redundant work leads to O(n²) time complexity.
 
 The key observation is that while scanning left, many elements become irrelevant if they are greater than or equal to the current element. These elements cannot be the nearest smaller element for the current or any future elements, so they can be safely discarded.
 
 Instead of repeatedly scanning the left side, we maintain a stack of useful candidates from the past.
 
 By keeping the stack in increasing order (monotonic increasing stack), the top of the stack always represents the nearest smaller element to the left (if it exists).
 
 At each step:
    - Remove elements that are greater than or equal to the current
    - The remaining top (if any) is the answer
    - Push the current element onto the stack
 
 The key distinction is that, in this problem, the stack is used to provide the answer for the current element, rather than resolving previous elements.
*/
// MARK: - Phase 7: Re-Code (After Break)

/*
 Invariant:
   - The stack stores indices such that their values are in increasing order, representing candidates for the previous smaller element
 Key Insight:
    - When a previous element is greater than  or equal the current element, it can be popped from the stack
    - After all the greater elements are popped, the top of the stack will hold the previous smaller element index
    - We use the index and extract the element from our given array and update our new arrays position
 */

func optimized(_ input: [Int]) -> [Int] {
    
    var stack:[Int] = []
    var result: [Int] = Array(repeating: -1, count: input.count)
    
    for i in 0..<input.count {
        let current = input[i]
        
        while let lastIndex = stack.last, input[lastIndex] >= current {
            _ = stack.popLast()
        }
        
        if let topIndex = stack.last {
            result[i] = input[topIndex]
        }
        
        stack.append(i)
    }
    
    return result
}

optimized([1, 3, 2, 4])

/*
 Phase 7 Validation Trace
 --------------------------------------------------
 
 Step 1
 
 i = 0
 current = 1
 
 No elements in the stack
 result[0] = -1
 stack = [0]
 
 Step 2
 
 i = 1
 current = 3
 
 lastIndex = 0, input[0] = 1 < 3
 
 topIndex = 0 → result[1] = 1
 
 stack = [0, 1]
 
 
 Step 3
 
 i = 2
 current = 2
 
 lastIndex = 1, input[1] = 3 >= 2  → pop
 
 lastIndex = 0, input[0] = 1 < 2
 
 topIndex = 0  → result[2] = 1
 
 stack = [0, 2]
 
 Step 4
 
 i = 3
 current = 4
 
 lastIndex = 2, input[2] = 2 < 4
 
 topIndex = 2  → result[3] = 2
 
 stack = [0, 2, 3]
 
 End of loop
 result = [-1,1,1,2]
 
 */

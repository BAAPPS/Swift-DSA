// MARK: - Problem Statement
/*
 MARK: - Problem: Next Greater Element
 Goal:
 Given an array of integers, find the next greater element
 for every element in the array.
 
 The next greater element is the first element to the right
 that is greater than the current element.
 
 If no such element exists, return -1.
 
 Example 1:
 Input:  [2, 1, 2, 4, 3]
 Output: [4, 2, 4, -1, -1]
 
 Example 2:
 Input:  [1, 3, 2, 4]
 Output: [3, 4, 4, -1]
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
 For this problem, we are trying to determine the next greater element to the right of the current element.
 If the next greater element exists, we will return that element.
 Otherwise, we will return -1
 
 - Obvious approach
 
 The most obvious approach:
 
 1) We create a new array and set the current array with starting values of -1 up to the count of our input array
 
 2) Use two loops:
 
 - One to traverse the current element
 
 - Second loop scans elements to the right to find the first greater value.
 
 3) As we traverse, determine if the next element is greater than the current:
 
 1) If so, we replace the current element with the next element
 
 - Once the next element has been found, we break, as no need to check further
 
 2) Otherwise the value remains -1.
 
 
 4) After traversal, our new array will have our final result
 
 
 - Performance Analysis
 
 - Time Complexity: O(n^2)
 
 - We're using two loops to traverse our given array
 
 - Space Complexity: O(n)
 
 - We will be using a new array to store our determination
 
 */

func bruteForce(_ input: [Int]) -> [Int] {
    var nextGreater: [Int] = Array(repeating:-1, count: input.count)
    for i in 0..<input.count {
        for j in i+1..<input.count {
            if input[j] > input[i] {
                nextGreater[i] = input[j]
                break
            }
        }
    }
    return nextGreater
}

bruteForce([2, 1, 2, 4, 3])



// MARK: - Phase 2: Manual Tracing

/*
 Example:
 Input:  [1, 3, 2, 4]
 Output: [3, 4, 4, -1]
 
 Invariant:
 For every index i, we scan the range (i+1...n-1)
 until the first greater element is found.
 
 Step 1 (i = 0)
 
 nextGreater = [-1,-1,-1,-1]
 
 input[i] = 1
 input[j] = 3
 
 3 > 1 → next greater found
 
 nextGreater[0] = 3
 
 nextGreater = [3,-1,-1,-1]
 
 
 Step 2 (i = 1)
 
 input[i] = 3
 
 input[j] = 2
 2 < 3 → continue scanning
 
 input[j] = 4
 4 > 3 → next greater found
 
 nextGreater[1] = 4
 
 nextGreater = [3,4,-1,-1]
 
 
 Step 3 (i = 2)
 
 input[i] = 2
 input[j] = 4
 
 4 > 2 → next greater found
 
 nextGreater[2] = 4
 
 nextGreater = [3,4,4,-1]
 
 
 Step 4 (i = 3)
 
 input[i] = 4
 
 No elements exist to the right
 
 nextGreater remains -1
 
 Final Result: [3,4,4,-1]
 */


// MARK: - Phase 3: Pattern Discovery

/*
 
 For this problem, we are checking if any element to the right
 is greater than the current element.

 In the brute force approach, we repeatedly scan the right side
 of the array for each element, which results in O(n²) time.

 Observation:
 
 When a larger element appears, it can resolve the "next greater"
 result for multiple smaller elements that appeared before it.

 This suggests we should keep track of unresolved elements.

 Pattern:

 We can use a Monotonic Decreasing Stack.

 The stack will store elements whose next greater value has not yet been found.

 When a new element is greater than the top of the stack,
 we pop from the stack and resolve their next greater element.

 This allows us to avoid repeatedly scanning the right side
 of the array and improves the solution to O(n).
 
*/

// MARK: - Phase 4: Optimized Monotonic Decreasing Stack Solution

func monotonicDecreasingStack(_ input: [Int]) -> [Int] {
    
    var nextGreater = Array(repeating: -1, count: input.count)
    var stack: [Int] = []
    
    for (i, current) in input.enumerated() {
        
        while let lastIndex = stack.last, input[lastIndex] < current {
            let resolvedIndex = stack.removeLast()
            nextGreater[resolvedIndex] = current
        }
        
        stack.append(i)
    }
    
    return nextGreater
}

monotonicDecreasingStack([1, 3, 2, 4])

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
 
 → Each element is pushed onto the stack once
 → Each element can be popped from the stack once
 → Therefore the total operations across the algorithm remain linear


 Space Complexity: O(n)

 → The stack can store up to n indices in the worst case
 → The result array stores n values
 
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:

 The brute force approach repeatedly scans the right side
 of the array to find the next greater element.

 The key observation is that when a larger element appears,
 it can resolve the next greater element for multiple
 smaller elements that came before it.

 Using a Monotonic Decreasing Stack allows us to keep track
 of indices whose next greater element has not yet been found.

 When the current element is greater than the element at
 the top of the stack:

    - The current element becomes the next greater element
      for that index.
    - We pop the index from the stack and update the result.

 We store indices in the stack instead of values so we can
 easily update the correct position in the result array.

 This approach ensures that every element is pushed and
 popped at most once, giving us an O(n) solution.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*
 */

func optimized(_ input: [Int]) -> [Int] {
    return []
}

optimized([1, 3, 2, 4])

/*
 Phase 7 Validation Trace
 
 Invariant:
 
 
 --------------------------------------------------
 
 
 */


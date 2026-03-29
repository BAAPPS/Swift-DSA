// MARK: - Problem Statement
/*
 MARK: - Problem 7: Largest Rectangle in Histogram
 
 Goal:
 Given an array representing the heights of histogram bars, find the largest rectangle that can be formed within the boundaries of the histogram.
 
 Example 1:
 Input:  [2,1,5,6,2,3]
 Output: 10
 
 Example 2:
 Input:  [2,4]
 Output: 4
 */
// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
 We want to find the largest rectangular area that can be formed in the histogram using the given bar heights.
 
 
 - Obvious approach
 
 - For each bar, treat it as the height of a potential rectangle
 
 - Expand to the left until we find a bar smaller than the current
 
 - Expand to the right until we find a bar smaller than the current
 
 - These two points define the boundaries of the rectangle
 
 - Compute:
 
 width = right boundary - left boundary - 1
 area  = current height * width
 
 - Track the maximum area found
 
 
 - Implementation Strategy
 
 - Use one loop to iterate through each bar
 
 - For each bar:
 
 - Use a loop to expand left
 
 - Use another loop to expand right
 
 - Performance Analysis
 
 Time Complexity: O(n²)
 - For each bar, we may scan left and right
 
 Space Complexity: O(1)
 - No extra data structures are used
 
 */

func bruteForce(_ input: [Int]) -> Int {
    
    var maxArea = 0
    for i in 0..<input.count {
        let currentHeight = input[i]
        
        var left = i
        var right = i
        
        // Expand Left
        while left - 1 >= 0 && input[left - 1] >= currentHeight {
            left -= 1
        }
        
        // Expand Right
        while right + 1 < input.count && input[right + 1] >= currentHeight {
            right += 1
        }
        
        
        let width = right - left + 1
        let area = currentHeight * width
        maxArea = max(maxArea, area)
        
        print("i:", i, "height:", currentHeight, "width:", width, "area:", area, "max area:", maxArea)
        
        
    }
    
    
    return maxArea
}

bruteForce([2,1,5,6,2,3])



// MARK: - Phase 2: Manual Tracing

/*
 Example:
 Input:  [2,1,5,6,2,3]
 Output: 10
 
 Invariant:
 For each index i, expand left and right while elements are greater than or equal to the current height. Stop when a smaller element is encountered, which defines the boundary.
 
 ----------------------------------------------------
 
 Initial State
 
 maxArea = 0
 
 ----------------------------------------------------
 
 Step 1
 
 i = 0
 currentHeight = 2
 
 left = 0
 right = 0
 
 // Expand Left
 No elements to the left
 
 // Expand Right
 Check index 1:
 input[1] = 1 < 2 → STOP
 
 (No expansion happens)
 
 left = 0
 right = 0
 
 width = right - left + 1
 = 0 - 0 + 1
 = 1
 
 area = 2 * 1 = 2
 
 maxArea = max(0, 2) = 2
 
 ----------------------------------------------------
 Step 2
 
 i = 1
 currentHeight = 1
 
 left = 1
 right = 1
 
 // Expand Left
 left - 1 = 0, input[0] = 2 >= 1 → expand
 left = 0
 
 No more elements to the left
 
 // Expand Right
 Check index 2: input[2] = 5 >= 1 → expand → right = 2
 Check index 3: input[3] = 6 >= 1 → expand → right = 3
 Check index 4: input[4] = 2 >= 1 → expand → right = 4
 Check index 5: input[5] = 3 >= 1 → expand → right = 5
 
 No more elements to the right
 
 left = 0
 right = 5
 
 width = right - left + 1
 = 5 - 0 + 1
 = 6
 
 area = 1 * 6 = 6
 
 maxArea = max(2, 6) = 6
 
 ----------------------------------------------------
 
 Step 3
 
 i = 2
 currentHeight = 5
 
 left = 2
 right = 2
 
 // Expand Left
 left - 1 = 1, input[1] = 1 < 5 → STOP
 
 // Expand Right
 Check index 3: input[3] = 6 >= 5 → expand → right = 3
 Check index 4: input[4] = 2 < 5 → STOP
 
 left = 2
 right = 3
 
 width = right - left + 1
 = 3 - 2 + 1
 = 2
 
 area = 5 * 2 = 10
 
 maxArea = max(6, 10) = 10
 
 ----------------------------------------------------
 
 Step 4
 
 i = 3
 currentHeight = 6
 
 left = 3
 right = 3
 
 // Expand Left
 left - 1 = 2, input[2] = 5 < 6 → STOP
 
 // Expand Right
 Check index 4: input[4] = 2 < 6 → STOP
 
 left = 3
 right = 3
 
 width = right - left + 1
 = 3 - 3 + 1
 = 1
 
 area = 6 * 1 = 6
 
 maxArea = max(10, 6) = 10
 
 ----------------------------------------------------
 
 Step 5
 
 i = 4
 currentHeight = 2
 
 left = 4
 right = 4
 
 // Expand Left
 Check index 3: input[3] = 6 >= 2 → expand → left = 3
 Check index 2: input[2] = 5 >= 2 → expand → left = 2
 Check index 1: input[1] = 1 < 2 → STOP
 
 left = 2
 
 // Expand Right
 Check index 5: input[5] = 3 >= 2 → expand → right = 5
 
 left = 2
 right = 5
 
 width = right - left + 1
 = 5 - 2 + 1
 = 4
 
 area = 2 * 4 = 8
 
 maxArea = max(10, 8) = 10
 
 ----------------------------------------------------
 
 Step 6
 
 i = 5
 currentHeight = 3
 
 left = 5
 right = 5
 
 // Expand Left
 Check index 4: input[4] = 2 < 3 → STOP
 
 // Expand Right
 No elements to the right
 
 left = 5
 right = 5
 
 width = right - left + 1
 = 5 - 5 + 1
 = 1
 
 area = 3 * 1 = 3
 
 maxArea = max(10, 3) = 10
 */




// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:
 
 For each index i, we expand left and right while elements are greater than or equal to the current height. Once a smaller element is encountered, it becomes the boundary for that index.
 
 This results in repeated scanning of the same elements across multiple indices.
 
 
 ------------------------------------------------------------
 
 Inefficiency:
 
 The brute force solution performs repeated expansions for each index, leading to redundant work and O(n²) time complexity.
 
 ------------------------------------------------------------
 
 Key Observation:
 
 Each bar is bounded by the first smaller element on its left and right. These boundaries determine the width of the largest rectangle where the current bar is the limiting height.
 
 
 ------------------------------------------------------------
 
 Pattern Recognition:
 
 Instead of re-expanding for every index, we can reuse previously processed information to determine boundaries efficiently without redundant comparisons.
 
 
 ------------------------------------------------------------
 
 Data Structure Insight:
 
 A stack can be used to maintain a monotonic order of indices. This allows us to efficiently track potential boundary candidates and avoid reprocessing elements multiple times.
 
 ------------------------------------------------------------
 
 Optimization Strategy:
 
 By maintaining a Monotonic Increasing Stack of indices, we can efficiently determine boundaries for each bar and compute the largest rectangle area in linear time.
 
 - The stack stores indices of elements in increasing order of height.
 
 - For each current element:
 - Pop all elements from the stack that have height greater than or equal to the current element.
 - The remaining top of the stack (if any) represents the left boundary (previous smaller element).
 - The current index acts as the right boundary for elements being popped.
 
 - Each element is pushed and popped at most once.
 
 This reduces the time complexity from O(n²) to O(n).
 */



// MARK: - Phase 4: Optimized Monotonic Increasing Stack Solution

func monotonicIncreasingStack(_ input: [Int]) -> Int {
    var stack:[Int] = []
    var maxArea: Int = 0
    
    for i in 0...input.count {
        let currentHeight = (i == input.count) ? 0 : input[i]
        
        while let lastIndex = stack.last, input[lastIndex] >= currentHeight {
            let height = input[stack.removeLast()]
            
            let leftBoundary = stack.last ?? -1
            let width = i - leftBoundary - 1
            
            let area = height * width
            maxArea = max(maxArea, area)
            
        }

        stack.append(i)
    }
    
    return maxArea
}

monotonicIncreasingStack([1, 3, 2, 4])



// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
 
 - Each element is pushed onto the stack once
 - Each element is popped from the stack at most once
 - Therefore, total operations scale linearly with input size
 
 Space Complexity: O(n)
 
 - The stack can hold up to n indices in the worst case
 - Additional variables (like maxArea) use O(1) space
 */

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:
 
 The brute force approach expands left and right for each index i, resulting in redundant work and repeated boundary checks.
 
 The key observation is that when we encounter a smaller element, we have discovered the right boundary for the elements being popped from the stack.
 
 Instead of expanding repeatedly, we use a Monotonic Increasing Stack to maintain indices of increasing heights. When a smaller height is encountered, we pop from the stack, and for each popped element:
 
 - The popped index represents the height of the rectangle
 - The current index acts as the right boundary
 - The new top of the stack represents the left boundary
 
 Using these boundaries, we compute:
 width = rightBoundary - leftBoundary - 1
 area = height * width
 
 This problem computes the area at the moment boundaries are discovered (during popping), rather than trying to resolve values during iteration.
 
 This transforms repeated boundary expansion into a single pass O(n) solution by leveraging previously processed structure.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*
 
 Invariant:
    - The stack store indices of bar  in strictly increasing height order
    - The stack represents indices whose maximum height has not yet been fully determined
 
 Key Insight:
 
    - When we encounter a bar shorter than the top of the stack, we have found the RIGHT boundary for the taller bar in the stack
    
    - While the current bar is smaller than or equal to the top of stack
 
        - Pop the stack
        - The popped index represents the height of the rectangle
        - The current index is the RIGHT boundary
        - The new top of thr stack (if any) is our LEFT boundary
 
    - Using these boundaries
 
        - width = rightBoundary - leftBoundary - 1
        - area = height * width
 
    - The sential value (height = 0) is used at the end to ensure all remaining bars are processed
 

 
 */

func optimized(_ input: [Int]) -> Int {
    
    var stack: [Int] = []
    var maxArea: Int = 0
    
    for i in 0...input.count {
        let currentHeight = (i == input.count) ? 0 : input[i]
        
        while let lastIndex = stack.last, input[lastIndex] >= currentHeight {
            let height = input[stack.removeLast()]
            
            let leftBoundary = stack.last ?? -1
            let width = i - leftBoundary - 1
            
            let area = height * width
            maxArea = max(maxArea, area)
        }
        
        stack.append(i)
    }
    
    return maxArea
}

optimized([1, 3, 2, 4])

/*
 Phase 7 Validation Trace
 --------------------------------------------------
 
 Initial:
    Input: [1, 3, 2, 4]
    stack = []
    maxArea = 0
 --------------------------------------------------
 Step 1
 
 i = 0
 curentHeight = 1
 
 stack empty → push index

 stack = [0]
 
 --------------------------------------------------
 
 Step 2
 
 i = 1
 currentHeight = 3
 
 lastIndex = 0, input[0] = 1 < 3 → no pop
 
 push index

 stack = [0, 1]
 
 --------------------------------------------------
 
 Step 3
 
 i = 2
 currentHeight = 2
 
 input[1] = 3 >= 2 → pop
 
    - height = 3
 
    - leftBoundary = 0
 
    - width = 2 - 0 - 1 = 1
 
    - area = 3 * 1 = 3
 
    - maxArea = (0, 3) = 3
 
 stack = [0]
 
 input[0] = 1 < 2 → stop popping

 push index
 
 stack = [0, 2]
 

 --------------------------------------------------
 
 Step 4
 
 i = 3
 currentHeight = 4
 
 input[2] = 2 < 4 → no pop
 
 push index
 
 stack = [0, 2, 3]
 
 --------------------------------------------------
 
 Step 5 (Sential Flush)
 
 i = 4
 currentHeight = 0
 
 
 input[3] = 4 >= 0 → pop
 
    height = 4
    leftBoundary = 2
    rightBoundary = 4

    width = 4 - 2 - 1 = 1
    area = 4 * 1 = 4
    maxArea = max(3, 4) = 4
 
 stack = [0, 2]
 
 input[2] = 2 >= 0 → pop
 
    height = 2
    leftBoundary = 0
    rightBoundary = 4

    width = 4 - 0 - 1 = 3
    area = 2 * 3 = 6
    maxArea = max(4, 6) = 6
 
 stack = [0]
 
 input[0] = 1 >= 0 → pop
 
    height = 1
 
    leftBoundary = -1
    rightBoundary = 4
 
    width = 4 - (-1) - 1 = 4
    area = 1 * 4 = 4
 
    maxArea = max(6,4) = 6
 
 stack = []

 push index

 stack = [4]

 --------------------------------------------------

 End of traversal

 Final maxArea = 6
 --------------------------------------------------

 Key Observations:

 - Stack stores indices in increasing order of heights
   (we pop greater or equal heights to maintain this)

 - When we pop an element:
     - The current index acts as the RIGHT boundary
     - The new top of the stack is the LEFT boundary (previous smaller element)

 - The width is determined using:
     width = rightBoundary - leftBoundary - 1

 - Sentinel value (height = 0) at i == input.count
   forces all remaining bars in the stack to be resolved

 - Monotonic stack has TWO modes:
     1. Resolve-on-the-fly (next greater, daily temperatures, etc.)
     2. Resolve-on-boundary (histogram → requires full boundary discovery + flush)
 */

// MARK: - Problem Statement
/*
 MARK: - Problem: Maximum Width Ramp
 
 Goal:
 A ramp is a pair (i, j) where i < j and nums[i] <= nums[j].
 Find the maximum width of a ramp in the array.
 
 Example 1:
 Input:  [6,0,8,2,1,5]
 Output: 4
 
 
 Example 2:
 Input:  [9,8,1,0,1,9,4,0,4,1]
 Output: 7
 */

// MARK: - Phase 1: Brute Force Attempt

/*
  Thought Process:
  
  - What are we trying to find?
  
  We are asked to find the maximum width of a ramp.
  A ramp is defined as a pair (i, j) such that:
     - i < j
     - nums[i] <= nums[j]
  
  The width of a ramp is calculated as (j - i).
  
  - Obvious / Brute Force Approach
  
  The most straightforward approach is to check every possible pair (i, j).
  
  - Initialize a variable `maxWidth` to track the largest width found
  
  - Use two nested loops:
     - The first loop selects the starting index `i`
     - The second loop scans all indices `j > i`
  
  - For each pair (i, j):
     - Check if it forms a valid ramp: nums[i] <= nums[j]
     - If valid, compute the width (j - i) and update `maxWidth`
  
  - After exploring all pairs, `maxWidth` will contain the largest ramp width
  
  - Performance Analysis
  
  Time Complexity: O(n²)
     - We examine all possible pairs (i, j)
  
  Space Complexity: O(1)
     - Only a single variable is used to store the result
 */

func bruteForce(_ input: [Int]) -> Int {
    
    var maxWidth: Int = 0
    
    for i in 0..<input.count {
        for j in i+1..<input.count {
            if input[i] <= input[j] {
                maxWidth = max(maxWidth, j - i)
            }
        }
    }
    
    return maxWidth
}

bruteForce([6,0,8,2,1,5])


// MARK: - Phase 2: Manual Tracing

/*
 Example:
 Input:  [6,0,8,2,1,5]
 Output: 4
 
 Invariant:
 For each index i, we scan all j > i.
 If nums[i] <= nums[j], we form a ramp and update maxWidth = max(maxWidth, j - i)
 
 ----------------------------------------------------
 Initial State
 
 maxWidth = 0
 
 ----------------------------------------------------
 i = 0 (nums[i] = 6)
 
 - Compare with all j > i:
   j = 2 → 6 <= 8 ✅ → width = 2 → maxWidth = 2
   All other j → not valid ramps
 
 maxWidth = 2
 
 ----------------------------------------------------
 i = 1 (nums[i] = 0)
 
 - Compare with all j > i:
   j = 2 → 0 <= 8 ✅ → width = 1
   j = 3 → 0 <= 2 ✅ → width = 2
   j = 4 → 0 <= 1 ✅ → width = 3
   j = 5 → 0 <= 5 ✅ → width = 4
 
 maxWidth = 4
 
 ----------------------------------------------------
 i = 2 (nums[i] = 8)
 
 - No j > i satisfies nums[i] <= nums[j]
 
 maxWidth = 4
 
 ----------------------------------------------------
 i = 3 (nums[i] = 2)
 
 - j = 5 → 2 <= 5 ✅ → width = 2
 
 maxWidth = 4
 
 ----------------------------------------------------
 i = 4 (nums[i] = 1)
 
 - j = 5 → 1 <= 5 ✅ → width = 1
 
 maxWidth = 4
 
 ----------------------------------------------------
 Final Result: maxWidth = 4
 */


// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:
 
 For each index i, we scan all j > i to find a valid ramp
 (nums[i] <= nums[j]) and compute the width (j - i).
 
 This leads to repeated scanning of the same elements, resulting in O(n²) time complexity.
 
 ------------------------------------------------------------
 
 Inefficiency:
 
 Many indices are unnecessarily reprocessed.
 We repeatedly check indices that are not useful starting points for forming wide ramps.
 
 ------------------------------------------------------------
 
 Key Observation:
 
 Not all indices are worth considering as starting points.
 
 If an index i has a value greater than a previous index,
 it will never produce a better (wider) ramp than that previous index.
 
 Therefore, we only care about indices where the value is smaller than all previous values.
 
 ------------------------------------------------------------
 
 Pattern Recognition:
 
 We can precompute and store only the "best" candidate indices
 (potential starting points) instead of checking all indices.
 
 These candidates form a sequence of decreasing values.
 
 ------------------------------------------------------------
 
 Data Structure Insight:
 
 A Monotonic Decreasing Stack can be used to store indices
 such that:
 
 - nums[stack[0]] > nums[stack[1]] > nums[stack[2]] ...
 
 This ensures:
 - Each index in the stack is a strong candidate for forming a wide ramp
 
 ------------------------------------------------------------
 
 Optimization Strategy:
 
 1. First pass (left → right):
    - Build a monotonic decreasing stack of indices
    - Only push index i if nums[i] is smaller than the top
 
 2. Second pass (right → left):
    - For each index j:
        - While stack is not empty and nums[stack.last] <= nums[j]:
            - Compute width (j - stack.last)
            - Update maxWidth
            - Pop from stack
 
 Each index is pushed and popped at most once, resulting in O(n) time complexity.
 */

// MARK: - Phase 4: Optimized Monotonic Decreasing Stack Solution

func monotonicDecreasingStack(_ input: [Int]) -> Int {
    var stack: [Int] = []
    
    // Phase 1: Build monotonic decreasing stack of indices
    for i in 0..<input.count {
        if stack.isEmpty || input[i] < input[stack.last!] {
            stack.append(i)
        }
    }
    var maxWidth = 0
    
    // Phase 2: Traverse from right to left
    for j in stride(from: input.count - 1, through: 0, by: -1 ){
        while let lastIndex = stack.last, input[j] >= input[lastIndex] {
            maxWidth = max(maxWidth, j - lastIndex)
            stack.removeLast()
        }
        
    }
  
    return maxWidth
}

monotonicDecreasingStack([6,0,8,2,1,5])

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
 
 - Phase 1 traverses the array once to build the stack
 - Phase 2 traverses the array again to compute the maximum width
 - Each element is pushed and popped at most once, resulting in linear time
 
 Space Complexity: O(n)
 
 - The stack may store up to n indices in the worst case
 - Additional variables (e.g., maxWidth) use constant space
 */

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:
 
 The brute force approach repeatedly scans the right side of the array to find valid ramps,
 resulting in redundant work and O(n^2) time complexity.
 
 The key observation is that a ramp is valid only if nums[i] <= nums[j].
 Instead of repeatedly scanning forward, we preserve useful candidate indices for i.
 
 We use a Monotonic Decreasing Stack of indices to maintain candidates with smaller values.
 This ensures that we keep potential left endpoints that are more likely to satisfy the ramp
 condition and help maximize width.
 
 However, this is not a single-pass problem. We solve it using two passes:
 
 Pass 1 (Candidate Preservation):
 We traverse the array from left to right and build a monotonic decreasing stack of indices.
 Larger values are discarded because they are worse candidates for i (they make it harder to
 satisfy nums[i] <= nums[j]).
 
 Pass 2 (Matching & Optimization):
 We traverse from right to left using j as the right endpoint. For each j, we check whether it
 forms a valid ramp with the top of the stack using nums[j] >= nums[stack.top].
 
 If valid, we compute the width j - i and update the maximum width.
 Since the stack is ordered, the top represents the best candidate for maximizing width at
 that moment.
 
 When a match is found, we pop and continue checking earlier candidates to explore all
 possible pairs efficiently.
 */

// MARK: - Phase 7: Re-Code (After Break)

/*
 
 Invariant:
 Key Insight:
 */

func optimized(_ input: [Int]) -> [Int] {
    
    
    
    return []
}

optimized([6,0,8,2,1,5])

/*
 Phase 7 Validation Trace
 --------------------------------------------------
 
 */

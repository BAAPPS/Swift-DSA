// MARK: - Problem Statement
/*
 MARK: - Problem: Maximum Width Ramp (Strict)

 Goal:
 A ramp is a pair (i, j) where: i < j AND nums[i] < nums[j].

 Find the maximum width (j - i).

 Example 1:
 Input:  [6,0,8,2,1,5]
 Output: 4

 Example 2:
 Input:  [5,4,3,2,1]
 Output: 0
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
    For this problem, we want to find  a ramp that has the maximum width denoted as (j - i)
 
 - Obvious approach
 
    The most obvious approach:
 
        - Create a maxWidth variable to hold the current max width found
 
        - Traverse using two loops
 
            - First loop to traverse the current element
 
            - Second loop traverses only elements to the right (j > i), since ramp requires i < j
 
        - As we traverse, we want to find a valid ramp, where: i < j AND nums[i] < nums[j]
 
            - If the constraints holds, we update maxWidth with the current width distance (j-i)
 
            - Otherwise, the width stays the same
 
        - Since we want to maximize (j - i), larger j values are more valuable
 
 
 - Performance Analysis
 
    - Time Complexity: O(n^2)
 
        - Each current element needs to traverse all other elements to find a valid ramp
 
    - Space Complexity: O(1)
    
        - We are only using a constant maxWidth variable to hold our final result

 
 */

func bruteForce(_ input: [Int]) -> Int {
    
    var maxWidth: Int = 0
    
    for i in 0..<input.count {
        for j in i+1..<input.count {
            if input[i] < input[j] {
                maxWidth = max(maxWidth, j - i)
            }
        }
    }

    return maxWidth
}

bruteForce([5,4,3,2,8])



// MARK: - Phase 2: Manual Tracing

/*
 
 Example:
 Input:  [5,4,3,2,8]
 Output: 4
 
 Invariant:
 For each index i, we scan all j > i.
 If nums[i] < nums[j], we form a ramp and update: maxWidth = max(maxWidth, j - i)
 
 ----------------------------------------------------
 Initial State
 
 maxWidth = 0
 
 ----------------------------------------------------
 
 i = 0 (nums[i] = 5)
 
 - Compare with all j > i:
   j = 4 → 5 < 8 ✅ → width = 4 → maxWidth = 4
   All other j → not valid ramps
 
 maxWidth = 4
 
 ----------------------------------------------------
 
 i = 1 (nums[i] = 4)
 
 - Compare with all j > i:
   j = 4 → 4 < 8 ✅ → width = 3 → maxWidth = 4
   All other j → not valid ramps
 
 maxWidth = 4
 
 ----------------------------------------------------
 
 i = 2 (nums[i] = 3)
 
 - Compare with all j > i:
   j = 4 → 3 < 8 ✅ → width = 2 → maxWidth = 4
   All other j → not valid ramps
 
 maxWidth = 4
 
 ----------------------------------------------------
 
 i = 3 (nums[i] = 2)
 
 - Compare with all j > i:
   j = 4 → 2 < 8 ✅ → width = 1 → maxWidth = 4
   All other j → not valid ramps
 
 maxWidth = 4
 
 ----------------------------------------------------
 
 Final Result: maxWidth = 4
 
 */


// MARK: - Phase 3: Pattern Discovery

/*
 
 Observation from Brute Force:
 
    For each index i, we repeatedly scan all j > i to find a valid ramp
    (nums[i] < nums[j]) and compute the width (j - i).
 
    This results in re-scanning the same right-side elements multiple times, leading to O(n²)
    time complexity.
 
 ------------------------------------------------------------
 
 Inefficiency:
 
 - The same indices on the right side are compared repeatedly (see Phase 2)
 - Many (i, j) pairs are invalid and wasted work
 - We do not reuse any previously computed information
 
 ------------------------------------------------------------
 
 Key Observation:
 
 Not all indices are worth considering as starting points.
 
 If we have two indices i < k such that: nums[i] <= nums[k]
 
 Then index k is NEVER a better starting point than i.
 
 Reason:
 - i is earlier → gives larger width (j - i)
 - nums[i] <= nums[k] → i has a better (or equal) chance of forming a valid ramp
 
 Therefore:
    index k is dominated by index i and can be ignored.
 
 ------------------------------------------------------------
 
 Pattern Recognition:
 
 We only care about indices that are:
    - Smaller than all previous values
 
 These indices form a sequence of strictly decreasing values.
 
 These are the ONLY candidates worth keeping as potential ramp starts.
 
 ------------------------------------------------------------
 
 Data Structure Insight:
 
 We can store these candidate indices in a Monotonic Decreasing Stack:
 
    nums[stack[0]] > nums[stack[1]] > nums[stack[2]] ...
 
 This ensures:
 - Each index is a strong candidate (not dominated)
 - We eliminate useless starting points early
 
 ------------------------------------------------------------
 
 Optimization Strategy:
 
 Unlike typical monotonic stack problems (single pass),
 this problem requires maximizing distance → we need TWO passes.
 
 1. First pass (left → right):
    - Build a monotonic decreasing stack of indices
    - Push index i ONLY if:
        nums[i] < nums[stack.last]
 
    → This keeps only the best starting candidates
 
 ------------------------------------------------------------
 
 2. Second pass (right → left):
 
    - Traverse from the end to maximize width first
    - For each index j:
 
        While stack is not empty AND:
            nums[stack.last] < nums[j]
 
            → We found a valid ramp
 
            - Compute width:
                j - stack.last
 
            - Update maxWidth
 
            - Pop index from stack
                (it cannot form a better ramp in the future)
 
 ------------------------------------------------------------
 
 Complexity:
 
 - Each index is pushed once and popped at most once
 → Time Complexity: O(n)
 
 - Stack stores at most n indices
 → Space Complexity: O(n)
 
 ------------------------------------------------------------
 
 Key Takeaway:
 
 Instead of checking all indices:
 
 - Eliminate dominated starting points early
 - Keep only decreasing candidates (monotonic stack)
 - Process from the right to maximize width greedily
 
 */


// MARK: - Phase 4: Optimized Monotonic Decreasing Stack Solution

func monotonicDecreasingStack(_ input: [Int]) -> Int {
    
    var stack: [Int] = []
    
    for i in 0..<input.count {
        if let last = stack.last, input[i] < input[last] {
            stack.append(i)
        } else if stack.isEmpty {
            stack.append(i)
        }
    }
    
    var maxWidth: Int = 0
    
    for j in stride(from: input.count - 1, through: 0, by: -1) {
        while let i = stack.last, input[j] > input[i] {
            maxWidth = max(maxWidth, j - i)
            
            // Found the BEST possible j for this i, can safely discard it forever
            // as the index is now useless going forward
            stack.removeLast()
        }
        
        if stack.isEmpty { break }
        
    }
    
 return maxWidth
}

monotonicDecreasingStack([5,4,3,2,8])

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
 
 The brute force approach repeatedly scans the right side of the array
 for every index i, leading to redundant work and O(n^2) time complexity.
 
 ------------------------------------------------------------
 
 Core Insight:
 
 A ramp is valid only if: nums[i] < nums[j]
 
 Instead of re-scanning the right side for every i, we preserve only the most valuable candidate indices.
 
 ------------------------------------------------------------
 
 Dominance Rule:
 
 If i < k and nums[i] <= nums[k], then k is dominated by i and can be ignored.
 
 Reason:
 - i is earlier → produces a larger width
 - nums[i] <= nums[k] → has an equal or better chance of forming a valid ramp
 
 Therefore, we only keep indices that are strictly decreasing in value.
 
 ------------------------------------------------------------
 
 Data Structure:
 
 We use a Monotonic Decreasing Stack to store candidate indices i such that:
 
    nums[stack[0]] > nums[stack[1]] > nums[stack[2]] ...
 
 These represent the only viable starting points for forming wide ramps.
 
 ------------------------------------------------------------
 
 Two-Pass Strategy:
 
 This problem requires two passes because we must maximize width.
 
 Pass 1 (Candidate Preservation - Left → Right):
 
 - Build a monotonic decreasing stack
 - Only push index i if:
    nums[i] < nums[stack.last]
 
 → This removes dominated indices early
 
 ------------------------------------------------------------
 
 Pass 2 (Matching & Optimization - Right → Left):
 
 - Traverse from right to left to prioritize larger widths
 - For each index j:
 
    While stack is not empty AND:
        nums[j] > nums[stack.last]
 
        → A valid ramp is found
 
        - Compute width: j - i
        - Update maxWidth
 
        - Pop index i from stack
 
        → This is safe because:
           we have found the maximum possible j for this i
 
 ------------------------------------------------------------
 
 Final Takeaway:
 
 - Eliminate dominated indices early
 - Keep only decreasing candidates (monotonic stack)
 - Traverse from right to left to greedily maximize width
 - Once a candidate is matched, it is permanently resolved
 
 ------------------------------------------------------------
 
 Note:
 
 This is a strict version of the Maximum Width Ramp problem.
 The only difference is:
    - Strict: nums[i] < nums[j]
    - Non-strict: nums[i] <= nums[j]
 
 The overall strategy remains the same, only the comparison changes.
 
 */

// MARK: - Phase 7: Re-Code (After Break)

/*
 Invariant:
 
 - The stack stores indices in strictly decreasing values
 - These indices represent non-dominated candidates for i
 
 Key Insight:
 
 This problem requires two passes:
 
 ------------------------------------------------------------
 
 Pass 1 (Build Candidates):
 
 - Traverse left → right
 - Build a monotonic decreasing stack
 - Only push index i if: nums[i] < nums[stack.last]
 
 - Larger values are discarded because they are dominated:
    - An earlier index with a smaller or equal value will always produce a better (wider) ramp
 
 ------------------------------------------------------------
 
 Pass 2 (Match & Maximize Width):
 
 - Traverse right → left
 - For each index j:
 
     While stack is not empty AND:
         nums[j] > nums[stack.last]
 
         → Valid ramp found
 
         - Compute width (j - i)
         - Update maxWidth
 
         - Pop from stack
 
         → This is safe because:
            we have found the maximum possible j for this i
 
 - Continue checking earlier candidates for additional ramps
 
 */

func optimized(_ input: [Int]) -> Int {
    var stack:[Int] = []
    var maxWidth: Int = 0
    
    // Pass 1 - Build stack in decreasing order (left-to-right)
    for i in 0..<input.count {
        if let lastIndex = stack.last, input[i] < input[lastIndex] {
            stack.append(i)
        } else if stack.isEmpty {
            stack.append(i)
        }
    }
    
    // Pass 2 - Match a valid ramp with stack (right-to-left)
    for j in stride(from: input.count - 1, through: 0, by: -1) {
        while let i = stack.last, input[j] > input[i] {
            maxWidth = max(maxWidth, j - i)
            stack.removeLast()
        }
        
        if stack.isEmpty { break }
    }


    return maxWidth
}

optimized([5,4,3,2,8])

/*
 Phase 7 Validation Trace
 --------------------------------------------------
 Initial:
    Input: [5,4,3,2,8]
    stack = []
    maxWidth = 0
 --------------------------------------------------
 
 Phase 1 (Build Decreasing Stack)
 
 i = 0
 stack is empty → append
 stack = [0]
 
 i = 1
 input[1] (4) < input[0] (5) → append
 stack = [0, 1]
 
 i = 2
 input[2] (3) < input[1] (4) → append
 stack = [0, 1, 2]
 
 i = 3
 input[3] (2) < input[2] (3) → append
 stack = [0, 1, 2, 3]
 
 i = 4
 input[4] (8) > input[3] (2) → skip (dominated)
 
 Final stack = [0, 1, 2, 3]
 Values = [5, 4, 3, 2] → strictly decreasing
 
 --------------------------------------------------
 
 Phase 2 (Right → Left Matching)
 
 j = 4 (value = 8)
 
 Stack: [0, 1, 2, 3]
 
 → 8 > 2 → width = 1 → maxWidth = 1 → pop → [0, 1, 2]
 → 8 > 3 → width = 2 → maxWidth = 2 → pop → [0, 1]
 → 8 > 4 → width = 3 → maxWidth = 3 → pop → [0]
 → 8 > 5 → width = 4 → maxWidth = 4 → pop → []
 
 Stack is now empty → stop early
 
 --------------------------------------------------
 
 Key Validation Insights:
 
 - Rightmost element (8) resolves ALL candidates in one pass
 - Each popped index i is permanently resolved because:
    this is the largest possible j for that i
 - Greedy popping ensures O(n) behavior
 - Earlier indices produce larger widths, which is why they are resolved last
 
 Final Result: maxWidth = 4
*/

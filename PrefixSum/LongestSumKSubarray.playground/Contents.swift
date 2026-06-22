// MARK: - Problem Statement

// MARK: Problem: Longest Subarray with Sum = K

/*
 Goal:
 Find the length of the longest contiguous subarray whose sum equals k.

 Example 1:
 Input: nums = [1,-1,5,-2,3], k = 3
 Output: 4   // [1,-1,5,-2]

 Example 2:
 Input: nums = [-2,-1,2,1], k = 1
 Output: 2
*/
// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
    We want to determine the maximum length of a continuous subarray whose elements add up exactly to k.
 
 - Obvious approach
 
    The most obvious approach:
 
        - Create a longest variable and set it to 0
        - Traverse using two loops:
            - First to traverse current
            - Second to traverse all other elements
 
        - As we traverse, keep track of:
             - The current subarray sum
             - The current subarray length

        - If the current subarray sum equals k:
             - Update the longest length found so far
     
 Performance Analysis:
     Time Complexity: O(n²)
     - Outer loop traverses every starting index
     - Inner loop expands every possible ending index
     - Total number of subarrays examined is O(n²)
        - n + (n-1) + (n-2) + ... + 1 -> O(n²)

     Space Complexity: O(1)
     - Only uses a few variables:
         - runningSum
         - currentLength
         - longest
     - No extra data structures proportional to input size
 */

func bruteForce(_ nums: [Int], _ k: Int) -> Int {
    var longest = 0
    
    for i in 0..<nums.count {
        var runningSum = 0
        for j in i..<nums.count {
            runningSum += nums[j]
            if runningSum == k {
                var currentLength = j - i + 1
               longest = max(longest, currentLength)
            }
        }
    }

    return longest
}

bruteForce( [1,-1,5,-2,3], 3)



// MARK: - Phase 2: Manual Tracing

/*
 Example:
     Input: nums = [1,-1,5,-2,3], k = 3
     Output: 4   // [1,-1,5,-2]
 
 Invariant:
    runningSum equals the sum of all elements from i through j
 
 ---
 Initial:

 longest = 0

 ---

 i = 0
 runningSum = 0

 j = 0
 runningSum += nums[0]
 runningSum = 1

 runningSum != 3

 ---

 j = 1
 runningSum += nums[1]
 runningSum = 1 + (-1) = 0

 runningSum != 3

 ---

 j = 2
 runningSum += nums[2]
 runningSum = 0 + 5 = 5

 runningSum != 3

 ---

 j = 3
 runningSum += nums[3]
 runningSum = 5 + (-2) = 3

 runningSum == 3

 currentLength = 3 - 0 + 1 = 4

 longest = max(0, 4)
 longest = 4
 */


// MARK: - Phase 3: Pattern Discovery

/*
 
 Observation From Brute Force:
 
 Every traversal, we are recomputing runningSum leading unnecessry recalculations
 
 ---
 
 Key Insight From Tracing:

 - runningSum always represents the sum of the current subarray nums[i...j].

 - We spend most of our time repeatedly calculating subarray sums.

 - If cumulative sums were precomputed, any subarray sum could be derived without rebuilding it element by element.

 ---

 
 Pattern Insight:
 
 We don't need to recompute runningSum for each traversal, but instead we can keep track of the current sum on the spot using prefix sum
 
 ---
 
 Optimization Direction:

 - Build cumulative (prefix) sums.


 
*/

// MARK: - Phase 4: Optimized Prefix Sum Solution

func prefixSum(_ nums: [Int], _ k: Int) -> Int {
    // prefix sum 0 exists before the array starts at index -1
    var lookup: [Int: Int] = [0: -1]
    var longest = 0
    var runningSum = 0
    
    for i in 0..<nums.count {
        runningSum += nums[i]

        /*
         subarraySum = k
         subarraySum = currentPrefix - previousPrefix
         
         Therefore:
         
         currentPrefix - previousPrefix = k

         Rearrange:
         previousPrefix = currentPrefix - k
         
         So we search for a previously seen prefix sum of:
         neededSum = runningSum - k
         */
        let neededSum = runningSum - k

        /*
         If a matching previous prefix sum exists, then the subarray between those two indices sums to k.
         */
        if let prevIndex = lookup[neededSum] {
            longest = max(longest, i - prevIndex)
        }

        /*
         Store the earliest occurrence of each prefix sum. We only store it once because earlier indices produce longer subarrays.
         */
        if lookup[runningSum] == nil {
            lookup[runningSum] = i
        }
        
    }
    
    return longest
}

prefixSum( [1,-1,5,-2,3], 3)

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
 - We traverse the array once.
 - Each element is processed in constant time:
     - update running sum
     - hashmap lookup
     - hashmap insert

 Space Complexity: O(n)
 - In the worst case, we store a prefix sum for every index in the hashmap.
 - This happens when all prefix sums are unique.
*/

// MARK: - Phase 6: Final Insight

/*
Final Insight & Patterns Learned:

From Brute Force:

For every iteration, we recompute running sums from scratch,
which leads to redundant calculations across overlapping subarrays.

---

Core Insight:

We transform the problem from recomputing subarray sums
to tracking prefix sum states.

Instead of working with full subarray sums, we use:

    currentPrefix - previousPrefix = k

Rearranged:

    previousPrefix = currentPrefix - k

This tells us the exact prefix sum we need to have seen before.

---

Key Pattern:

At each index, we compute:

    neededSum = runningSum - k

If this prefix sum has been seen before:
→ the subarray between the previous index and current index sums to k

Otherwise:
→ store the earliest occurrence of the current prefix sum

We only store the first occurrence because earlier indices
produce longer valid subarrays in future matches.

*/

// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:
 Key Insight:
*/

func optimized(_ nums: [Int], _ k: Int) -> Int {
    
    return 0
}

optimized( [1,-1,5,-2,3], 3)

/*
 Phase 7 Validation Trace
 --------------------------------------------------

*/

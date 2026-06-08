// MARK: - Problem Statement

// MARK: Problem: Range Sum Query (Static Array)

// Goal:
// Precompute prefix sums so any range sum query can be answered in O(1).

/*
 Example 1:
 Input:  nums = [2, 4, 6, 8], queries = (1,3)
 Output: 18   // 4 + 6 + 8

 Example 2:
 Input:  nums = [1, 2, 3, 4, 5], queries = (0,2)
 Output: 6
*/

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:

 - What am I trying to find?

   - Given a query (left, right), find the sum of all elements between those indices (inclusive).

 - Obvious approach

   The most straightforward solution is:

       1. Extract the left and right boundaries.
       2. Visit every index from left through right.
       3. Add each value to a running sum.
       4. Return the final sum.

 - Why does this work?

   Since we visit every element inside the requested range exactly once, the running sum will contain the total value of that range.

 - Performance Analysis

   Time Complexity: O(right - left + 1)
    - In the worst case, the query may span the entire array, resulting in O(n) time.

   Space Complexity: O(1)
    - We only use a few variables regardless of input size.
 
 
 */

func bruteForce(_ nums: [Int], _ queries: (Int, Int)) -> Int {
    
    var sum: Int = 0
    let (left, right) = queries
    
    for i in left...right {
        sum += nums[i]
    }

    return sum
}

bruteForce([2, 4, 6, 8], (1,3))



// MARK: - Phase 2: Manual Tracing

/*
 
 Example:
 Input: nums = [2, 4, 6, 8], query = (1, 3)

 Invariant:
 sum contains the total of all elements processed so far within the range [left...right].

 ---

 Initial:

 sum = 0
 left = 1
 right = 3

 ---

 i = 1

 nums[1] = 4

 sum += nums[1]
 sum = 0 + 4 = 4

 ---

 i = 2

 nums[2] = 6

 sum += nums[2]
 sum = 4 + 6 = 10

 ---

 i = 3

 nums[3] = 8

 sum += nums[3]
 sum = 10 + 8 = 18

 ---

 Loop Ends

 sum = 18

 Return 18
 
 */


// MARK: - Phase 3: Pattern Discovery

/*
 Observation from Brute Force:

 We are repeatedly traversing the range [left...right] for every query.

 This works, but becomes inefficient when:
 - the array is large
 - the number of queries is large

 because we recompute overlapping work again and again.

 ---

 Key Insight (from tracing):

 - The same elements are being summed repeatedly across queries
 - We are doing redundant work for overlapping ranges
 - Instead of recomputing sums, we should store partial results

 ---

 Optimization Direction:

 Instead of recalculating sums for every query,  we can precompute cumulative information so that any range sum can be derived in constant time.
*/

// MARK: - Phase 4: Optimized Prefix Sum Solution


func buildPrefix(_ nums:[Int]) -> [Int]{
    var prefix = Array(repeating: 0, count: nums.count)
    
    prefix[0] = nums[0]
    
    for i in 1..<nums.count {
        prefix[i] = prefix[i-1] + nums[i]
    }
    return prefix
}

func prefixSum(_ nums: [Int], _ queries: (Int, Int)) -> Int {
    
    let (left, right) = queries
    
    var prefix = buildPrefix(nums)
    
    if left == 0 {
        return prefix[right]
    } else {
        return prefix[right] - prefix[left - 1]
    }
}


prefixSum([2, 4, 6, 8], (1,3))

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)

 - Building the prefix sum array takes linear time.

 Space Complexity: O(n)

 - We store an additional prefix sum array of size n.
 - This trades memory for faster query responses.
*/


// MARK: - Phase 6: Final Insight

/*
 Final Insight & Pattern Learned:

 The brute force approach works for small inputs but becomes inefficient
 because it repeatedly traverses the range [left...right] for every query,
 leading to redundant work.

 ---

 Core Insight:

 Instead of recomputing the sum for every query, we preprocess the array
 into a prefix sum array.

 prefix[i] represents the sum of all elements from index 0 to i.

 ---

 Key Idea:

 1. Build Prefix Sum Array:

    - Initialize prefix[0] = nums[0]
    - For each index i:
        prefix[i] = prefix[i - 1] + nums[i]

    This stores cumulative sums as we iterate through the array.

 ---

 2. Answer Queries Efficiently:

    For a query (left, right), we use the prefix sum array:

    - prefix[right] contains the sum of nums[0...right]

    To isolate only nums[left...right], we remove everything before left:

    - result = prefix[right] - prefix[left - 1]

    This works because prefix[left - 1] represents the sum of all elements
    before the range we want.

    ---

    Edge Case:

    If left == 0, there is nothing to subtract because the range already
    starts from index 0.

    - In this case:
        result = prefix[right]

 ---

 Final Understanding:

 We trade extra space O(n) to eliminate repeated computation, allowing each range sum query to be answered in O(1) time.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:
 Key Insight:
*/

func optimized(_ nums: [Int], _ queries: (Int, Int)) -> Int {
    
    return 0
}

optimized([2, 4, 6, 8], (1,3))

/*
 Phase 7 Validation Trace
 --------------------------------------------------

*/

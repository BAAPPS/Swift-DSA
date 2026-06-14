// MARK: - Problem Statement

//MARK:  Problem: Continuous Subarray Sum Divisible by K

/*
 Goal:
 Given an array of integers and an integer k, return true if there exists a continuous subarray of length at least 2 whose sum is divisible by k; otherwise return false.


 Example 1:
 Input: nums = [23,2,4,6,7], k = 6
 Output: true

 Example 2:
 Input: nums = [23,2,6,4,7], k = 13
 Output: false
*/
// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:

 - What am I trying to find?

   Determine whether there exists a continuous subarray of length at least 2 whose sum is divisible by k.

 - Obvious approach

   Use two loops:
    - First loop chooses a starting index.
    - Second loop expands the ending index.
    - Maintain a running sum for the current subarray.

   For every subarray:
    - Check if its length is at least 2.
    - Check if its sum is divisible by k.

 
 - Performance Analysis
 
    - Time Complexity: O(n²)
         - Outer loop chooses a starting index.
         - Inner loop expands every possible ending index.
         - Every possible subarray is examined once.

    - Space Complexity: O(1)
        - Only a few variables are used regardless of input size.
 
 */

func bruteForce(_ nums: [Int], _ k: Int) -> Bool{
    
    for i in 0..<nums.count {
        var subArrSum = 0
        
        for j in i..<nums.count {
            subArrSum += nums[j]
            
            if (j - i + 1) >= 2 {
                if subArrSum % k == 0 {
                    return true
                }
            }
        }
    }

    return false
}

bruteForce([23,2,4,6,7], 6)



// MARK: - Phase 2: Manual Tracing

/*
 Example:
     nums = [23,2,4,6,7]
     k = 6

 Invariant:
     As j expands, subArrSum contains the total sum of all elements from index i through j.

 ---

 i = 0

 j = 0

 subArrSum = 0

 nums[0] = 23

 subArrSum = 23

 length = (0 - 0 + 1) = 1

 length < 2

 Skip

 ---

 j = 1

 nums[1] = 2

 subArrSum = 25

 length = (1 - 0 + 1) = 2

 25 % 6 = 1

 Not divisible

 ---

 j = 2

 nums[2] = 4

 subArrSum = 29

 length = (2 - 0 + 1) = 3

 29 % 6 = 5

 Not divisible

 ---

 j = 3

 nums[3] = 6

 subArrSum = 35

 length = (3 - 0 + 1) = 4

 35 % 6 = 5

 Not divisible

 ---

 j = 4

 nums[4] = 7

 subArrSum = 42

 length = (4 - 0 + 1) = 5

 42 % 6 = 0

 Divisible

 Return true
 
 */


// MARK: - Phase 3: Pattern Discovery

/*
Observation from Brute Force:

We are repeatedly computing subarray sums from scratch and checking whether each sum is divisible by k. This leads to redundant work because overlapping subarrays share repeated calculations.

---

Key Insight:

Instead of focusing on full subarray sums, we notice that what matters is the relationship between prefix sums.

A subarray sum can be expressed as:
    subarraySum = currentPrefix - previousPrefix

---

Core Pattern:

For a subarray sum to be divisible by k:
    (currentPrefix - previousPrefix) % k == 0

This is equivalent to:
    currentPrefix % k == previousPrefix % k

---

Critical Insight:

This means we do NOT need to track full sums or full subarrays.

We only need to track the remainder of prefix sums when divided by k.

If the same remainder appears again, it means:

- A valid subarray exists between those two indices
- That subarray sum is divisible by k

---

Optimization Direction:

Instead of recomputing subarray sums, we:

- Compute running prefix sums
- Store seen remainders in a lookup structure
- Check if the same remainder has appeared before

If yes → a valid subarray exists
*/

// MARK: - Phase 4: Optimized Preifx Sum  Solution

func prefixSum(_ nums: [Int], _ k: Int) -> Bool{
    
    var runningSum: Int = 0
    
    var lookup:[Int:Int] = [0:1]
    
    for i in 0..<nums.count {
        runningSum += nums[i]
        
        let remainder = runningSum % k
        
        if lookup[remainder] != nil {
            return true
        }
        
        
        lookup[remainder, default:0] += 1
        
    }
    
    return false
}

prefixSum([23,2,4,6,7], 6)


// MARK: - Phase 5: Complexity Analysis


/*
Time Complexity: O(n)
- We traverse the array once.
- Each step performs O(1) hashmap operations.

Space Complexity: O(n)
- In the worst case, we store one entry per prefix remainder.
- Although the number of possible remainders is bounded by k,
  we typically express it as O(n) in general analysis.
*/

// MARK: - Phase 6: Final Insight

/*
Final Insight & Pattern Learned:

The brute force approach repeatedly computes subarray sums from scratch
and checks divisibility by k. This causes redundant work across overlapping subarrays.

---

Core Insight:

Instead of tracking full subarray sums, we transform the problem into tracking
prefix sum remainders:

    remainder = prefixSum % k

This reduces the problem from managing values to managing states.

---

Key Pattern:

If two prefix sums have the same remainder when divided by k:

    prefixA % k == prefixB % k

Then their difference is divisible by k:

    (prefixA - prefixB) % k == 0

This means a valid subarray exists between those two indices.

---

Operational Rule:

We store each remainder in a lookup table as we traverse:

    if remainder has been seen before:
        → a valid subarray ending at the current index exists

Otherwise:
    → store the remainder and continue

---

Final Mental Model:

We are not tracking sums.

We are tracking repeated remainder states.

When a remainder repeats, it guarantees a subarray whose sum is divisible by k.

---

Why This Matters (Pattern Recognition):

This is a reusable pattern for many problems:

- Replace "sum comparison" with "prefix state comparison"
- Use modulo to compress state space
- Detect valid subarrays by repeated states in a hashmap
 
In short, repeated prefix remainder means the subarray between those two points has a sum divisible by k.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:
 Key Insight:
*/

func optimized(_ nums: [Int], _ k: Int) -> Bool{
    
    return true
}

optimized([23,2,6,4,7], 13)

/*
 Phase 7 Validation Trace
 --------------------------------------------------

*/

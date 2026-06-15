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

 If the same remainder appears again, then the subarray between those two prefix states has a sum divisible by k.

 For this problem we must additionally verify that the distance between the two indices is at least 2.

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
    
    // remainder -> first index
    var lookup: [Int:Int] = [0:-1]
    
    for i in 0..<nums.count {
        runningSum += nums[i]
        
        let remainder = runningSum % k
        
        if let previousIndex = lookup[remainder] {
            // current index - earlier index
            if i - previousIndex >= 2 {
                return true
            }
            
        } else {
            lookup[remainder] = i
        }

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

The brute force approach recomputes subarray sums repeatedly,
leading to redundant work across overlapping subarrays.

---

Core Insight:

We transform the problem from tracking values to tracking states.

Instead of full sums, we use:

    remainder = prefixSum % k

This compresses the problem into a finite state space.

---

Key Pattern:

If two prefix sums have the same remainder:

    prefixA % k == prefixB % k

Then their difference is divisible by k:

    (prefixA - prefixB) % k == 0

This implies a valid subarray exists between those two prefix states.

---

Operational Rule:

We maintain a lookup of previously seen remainders:

- If a remainder repeats → a valid subarray exists between two indices
- Otherwise → store the remainder and continue

---

Critical Detail:

We must ensure the two prefix states come from different indices,
so that the subarray length is valid (not zero or invalid).

---

Final Mental Model:

We are not tracking sums.

We are tracking repeated remainder states.

A repeated remainder guarantees a subarray whose sum is divisible by k.

---

Why This Pattern Matters:

This is a reusable transformation pattern:

- Replace sum comparisons with prefix state comparisons
- Use modulo to compress infinite sums into finite states
- Detect valid subarrays via repeated states in a hashmap
*/

// MARK: - Phase 7: Re-Code (After Break)

/*

Invariant:

At each index i:
- runningPrefix stores the sum of nums[0...i]
- lookup stores the first index where each remainder (prefixSum % k) was seen

This ensures that for any stored remainder, we can determine
the earliest position it appeared in order to measure subarray length.

---

Key Insight:

We transform the problem from checking subarray sums to tracking prefix remainders.

If the same remainder appears again at index i, it means:

    prefixA % k == prefixB % k

⇒ the subarray between these two indices has a sum divisible by k.

To satisfy the problem constraint, we also ensure:

    i - previousIndex >= 2

This guarantees the subarray has at least two elements.

Thus:
- repeated remainder ⇒ potential valid subarray
- index distance check ⇒ ensures valid length
*/

func optimized(_ nums: [Int], _ k: Int) -> Bool{
    
    var lookup:[Int:Int] = [0:1]
    var runningPrefix: Int = 0
    
    for i in 0..<nums.count {
        runningPrefix += nums[i]
        
        let remainder = runningPrefix % k
        
        if let previousIndex = lookup[remainder] {
            if i - previousIndex >= 2 {
                return true
            }
        } else {
            lookup[remainder] = i
        }
    }
    
    return false
}

optimized([23,2,6,4,7], 13)

/*
Phase 7 Validation Trace
--------------------------------------------------
Example:
    Input: nums = [23,2,6,4,7], k = 13
    Output: false

Invariant:
- runningPrefix tracks sum of nums[0...i]
- remainder = runningPrefix % k
- lookup stores FIRST index where each remainder appears

--------------------------------------------------

Initial:
runningPrefix = 0
lookup = [0: -1]   // remainder 0 seen before start

--------------------------------------------------

i = 0
nums[0] = 23

runningPrefix = 23
remainder = 23 % 13 = 10

lookup = [0: -1, 10: 0]

(not seen before → store index)

--------------------------------------------------

i = 1
nums[1] = 2

runningPrefix = 25
remainder = 25 % 13 = 12

lookup = [0: -1, 10: 0, 12: 1]

(not seen before → store index)

--------------------------------------------------

i = 2
nums[2] = 6

runningPrefix = 31
remainder = 31 % 13 = 5

lookup = [0: -1, 10: 0, 12: 1, 5: 2]

(not seen before → store index)

--------------------------------------------------

i = 3
nums[3] = 4

runningPrefix = 35
remainder = 35 % 13 = 9

lookup = [0: -1, 10: 0, 12: 1, 5: 2, 9: 3]

(not seen before → store index)

--------------------------------------------------

i = 4
nums[4] = 7

runningPrefix = 42
remainder = 42 % 13 = 3

lookup = [0: -1, 10: 0, 12: 1, 5: 2, 9: 3, 3: 4]

(not seen before → store index)

--------------------------------------------------

Final Result:
No remainder repeated with distance >= 2
→ return false
*/

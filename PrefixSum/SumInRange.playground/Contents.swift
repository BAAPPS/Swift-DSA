// MARK: - Problem Statement


// MARK: - Problem: Count of Subarrays With Sum in Range [L, R]

/*
 Goal:
    Given an integer array and two values L and R, determine the number of contiguous subarrays whose sum is greater than or equal to L and less than or equal to R.
 
 Example 1:
 Input: nums = [1,2,3], L = 3, R = 5
 Output: 3

 Example 2:
 Input: nums = [0,0,0], L = 0, R = 0
 Output: 6
*/
// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:

 - What am I trying to find?

   We want to count every contiguous subarray whose sum satisfies:
       L ≤ sum ≤ R
 ---

 - Obvious approach

   The most straightforward solution is to examine every possible subarray.

   - The first loop selects the starting index.
   - The second loop expands the ending index.

   Create a variable to count the number of valid subarrays.

   As the ending index expands:

   - Maintain a running sum for the current subarray.
   - Check whether the running sum falls within the inclusive range [L, R].
   - If it does, increment the valid subarray count.

 ---

 - Performance Analysis
   Time Complexity: O(n²)
   Space Complexity: O(1)
 */



func bruteForce(_ nums: [Int], _ L: Int, _  R:Int) -> Int {
    
    var valid: Int = 0
    
    for i in 0..<nums.count {
        var sum: Int = 0
        for j in i..<nums.count {
            sum += nums[j]
            if (L <= sum && sum <= R) {
                valid += 1
            }
        }
    }
    

    return valid
}

bruteForce([1,2,3], 3, 5)


// MARK: - Phase 2: Manual Tracing

/*
Example:
Input: nums = [1,2,3], L = 3, R = 5
Output: 3

Invariant:

For each starting index i, as j expands:

- sum always equals the sum of the current subarray nums[i...j].
- valid counts every subarray found so far whose sum satisfies:
      L ≤ sum ≤ R

--------------------------------------------------

Initial:

valid = 0

--------------------------------------------------

i = 0

sum = 0

j = 0
nums[0] = 1

sum = 1

1 < L
❌ Invalid

---

j = 1
nums[1] = 2

sum = 3

L ≤ 3 ≤ R
✅ Valid

valid = 1

---

j = 2
nums[2] = 3

sum = 6

6 > R
❌ Invalid

--------------------------------------------------

i = 1

sum = 0

j = 1
nums[1] = 2

sum = 2

2 < L
❌ Invalid

---

j = 2
nums[2] = 3

sum = 5

L ≤ 5 ≤ R
✅ Valid

valid = 2

--------------------------------------------------

i = 2

sum = 0

j = 2
nums[2] = 3

sum = 3

L ≤ 3 ≤ R
✅ Valid

valid = 3

--------------------------------------------------

Final:

valid = 3
*/


// MARK: - Phase 3: Pattern Discovery

/*
Observation from Brute Force:

- We repeatedly compute sums for overlapping subarrays.
- This leads to redundant work because many subarrays share the same elements.
- Within each starting index i, we continuously extend j and maintain a running sum.

---

Key Insight From Tracing:

Instead of recomputing sums for every subarray, we observe:

A subarray sum can be represented as a difference of two prefix sums:

    subarraySum = currentPrefix - previousPrefix

This means the problem can be reframed in terms of relationships between prefix states,
rather than explicit subarray computation.

---

Pattern Insight:

We transform the problem into a prefix sum interval problem:

- Maintain a running prefix sum
- Instead of checking subarrays directly, reason about previous prefix sums

A valid subarray must satisfy:
    L ≤ currentPrefix - previousPrefix ≤ R

Rearranging gives:
    currentPrefix - R ≤ previousPrefix ≤ currentPrefix - L

---

Optimization Direction:

At each index:

- Compute running prefix sum
- Convert the problem into:

    “How many previous prefix sums lie inside the range
     [currentPrefix - R, currentPrefix - L]?”

This reframes the problem from:
- finding a single matching prefix (exact lookup)
to:
- counting prefix sums within a valid interval
*/

// MARK: - Phase 4: Optimized Prefix Sum Solution

func mergeSort(_ prefix: inout [Int], _ left: Int, _ right: Int, _ L: Int, _ R: Int) -> Int {

    if left >= right {
        return 0
    }

    let mid = (left + right) / 2

    var count = 0

    count += mergeSort(&prefix, left, mid, L, R)
    count += mergeSort(&prefix, mid + 1, right, L, R)

    var j = mid + 1
    var k = mid + 1

    // count valid ranges
    for i in left...mid {

        while k <= right && prefix[k] - prefix[i] < L {
            k += 1
        }

        while j <= right && prefix[j] - prefix[i] <= R {
            j += 1
        }

        count += (j - k)
    }

    // merge step
    var temp: [Int] = []
    var i = left
    var m = mid + 1

    while i <= mid && m <= right {
        if prefix[i] <= prefix[m] {
            temp.append(prefix[i])
            i += 1
        } else {
            temp.append(prefix[m])
            m += 1
        }
    }

    while i <= mid {
        temp.append(prefix[i])
        i += 1
    }

    while m <= right {
        temp.append(prefix[m])
        m += 1
    }

    for idx in 0..<temp.count {
        prefix[left + idx] = temp[idx]
    }

    return count
}

func countRangeSum(_ nums: [Int], _ L: Int, _ R: Int) -> Int {

    var prefix = [0]

    for num in nums {
        prefix.append(prefix.last! + num)
    }

    return mergeSort(&prefix, 0, prefix.count - 1, L, R)
}

countRangeSum([1,2,3], 3, 5)

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n log n)

 Explanation:
 - We build prefix sums in O(n)
 - Merge sort splits array into log n levels
 - At each level, we perform linear work (two pointers + merge step)
 - Total: O(n log n)

---

 Space Complexity: O(n)

 Explanation:
 - Prefix sum array: O(n)
 - Temporary array during merge: O(n)
 - Recursion stack: O(log n)
*/

// MARK: - Phase 6: Final Insight

/*
Final Insight & Patterns Learned:

From Brute Force:

- We repeatedly recompute subarray sums for every (i, j) pair.
- This leads to redundant work due to overlapping subarrays.
- The same prefix computations are reused many times.

---

Core Insight:

The key realization is that subarray sums can be rewritten as:

    subarraySum = currentPrefix - previousPrefix

This shifts the problem away from subarrays and into relationships between prefix states.

---

🚨 New Pattern Discovered (Critical Breakthrough):

Not all prefix sum problems are exact-match problems.

There are TWO distinct categories:

1. Exact Match (HashMap Lookup)
   - “Have I seen this prefix sum before?”
   - Used for:
       • Subarray Sum = K
       • Equal 0/1 (after transformation)
       • Remainder / modulo problems

   → lookup[prefixSum]

---

2. Range Query (Interval of Prefix Sums) ← NEW PATTERN
   - “How many previous prefix sums fall within a range?”
   - This appears when constraints are:
       L ≤ subarraySum ≤ R

   Rewritten as prefix condition:

       currentPrefix - R ≤ previousPrefix ≤ currentPrefix - L

   → This is NOT a single lookup problem
   → It is a RANGE COUNTING problem over past prefix states

---

Key Insight:

The failure of a simple HashMap approach reveals the core distinction:

- HashMap solves: exact equality of prefix states
- This problem requires: counting prefix states within an interval

This is the transition from:
    “state lookup”
to:
    “state range query”

---

Final Mental Model:

Prefix sum problems split into:

- Exact Match → HashMap
- Range Query → Ordered structure / sorting / divide & conquer

The key insight is recognizing which type of prefix state query the problem requires.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:
 Key Insight:
*/

func optimized(_ nums: [Int], _ L: Int, _  R:Int) -> Int {
    
    return 0
}

optimized([1,2,3], 3, 5)

/*
 Phase 7 Validation Trace
 --------------------------------------------------

*/

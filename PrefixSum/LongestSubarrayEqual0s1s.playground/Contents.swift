// MARK: - Problem Statement

// MARK: - Problem: Longest Subarray with Equal 0s and 1s

// Goal:
// Find the length of the longest contiguous subarray containing an equal number of 0s and 1s.

/*
 Example 1:
 Input: nums = [0,1]
 Output: 2

 Example 2:
 Input: nums = [0,1,0]
 Output: 2
*/

// MARK: - Phase 1: Brute Force Attempt

/*
Thought Process:

- What am I trying to find?

  We want to determine the length of the longest continuous subarray containing an equal number of 0s and 1s.

- Obvious approach

  The most obvious approach is to examine every possible subarray.
  - The first loop selects the starting index.
  - The second loop expands the ending index.

  As the subarray grows:
  - Count the number of 0s.
  - Count the number of 1s.
  - Whenever the counts are equal,
    update the longest valid subarray found so far.

- Performance Analysis
  Time Complexity: O(n²)
  Space Complexity: O(1)
*/

func bruteForce(_ nums: [Int]) -> Int {
    
    var length: Int = 0
    
    for i in 0..<nums.count {
            var zero = 0
            var one = 0
        for j in i..<nums.count {
            if nums[j] == 0 {
                zero += 1
            } else {
                one += 1
            }
            if zero == one {
                length = max(length, j - i + 1)
            }
        }
    }

    return length
}

bruteForce([0,1])



// MARK: - Phase 2: Manual Tracing

/*
Example:
Input: nums = [0,1]
Output: 2

Invariant:

For each starting index i, as j expands:

- zero stores the number of 0s in nums[i...j]
- one stores the number of 1s in nums[i...j]
- length stores the longest valid subarray found so far.

--------------------------------------------------

Initial:

length = 0

--------------------------------------------------

i = 0

zero = 0
one = 0

j = 0

nums[0] = 0

nums[0] == 0
→ zero = 1

zero != one

--------------------------------------------------

j = 1

nums[1] = 1

nums[1] == 1
→ one = 1

zero == one

currentLength = 1 - 0 + 1
              = 2

length = max(0, 2)
       = 2

--------------------------------------------------

Return:

length = 2
*/
// MARK: - Phase 3: Pattern Discovery

/*
Observation From Brute Force:

For every starting index, we repeatedly recount the number of 0s and 1s in overlapping subarrays.

This leads to redundant work because many subarrays share the same elements.

---

Key Insight From Tracing:

Instead of keeping two separate counts (zero and one), we only care whether they are equal.

This suggests we can represent both counts with a single running value.

---

Pattern Insight:

Transform the problem into a prefix sum problem:
    - Treat 0 as -1
    - Treat 1 as +1

Now:

A subarray has an equal number of 0s and 1s ⇔ The subarray's sum equals 0.

---

Optimization Direction:

- Compute a running prefix sum.
- Store the earliest index where each prefix sum first appears.
- If the same prefix sum appears again,
  the subarray between those indices has a sum of 0,
  meaning it contains an equal number of 0s and 1s.
*/
// MARK: - Phase 4: Optimized Prefix Solution

func prefix(_ nums: [Int]) -> Int {
    
    var lookup: [Int: Int] = [0:-1]
    
    var runningSum = 0
    
    var longest: Int = 0
    
    for i in 0..<nums.count {
        if nums[i] == 0 {
            runningSum -= 1
        } else {
            runningSum += 1
        }
        
        
        if let prevIndex = lookup[runningSum] {
            longest = max(longest, i - prevIndex)
        }
        
        if lookup[runningSum] == nil {
            lookup[runningSum] = i
        }
       
    }
    
    
 return longest
}

prefix([0,1])

// MARK: - Phase 5: Complexity Analysis

/*
Time Complexity: O(n)
- We traverse the array once.
- Each index performs constant-time operations:
  - update running sum
  - hashmap lookup
  - hashmap insert (amortized O(1))

Space Complexity: O(n)
- In the worst case, we store one prefix sum per index in the hashmap.
- This happens when all prefix sums are unique.
*/

// MARK: - Phase 6: Final Insight

/*
Final Insight & Patterns Learned:

From Brute Force:

For every starting index, we repeatedly recount the number of 0s and 1s in overlapping subarrays.

This leads to redundant work because many subarrays share repeated elements.

---

Core Insight:

Instead of tracking 0s and 1s separately, we only care whether they are equal.

To convert this into a prefix sum problem, we transform the input:

- 0 → -1
- 1 → +1

Now the problem becomes:

A subarray has equal 0s and 1s ⇔ its sum equals 0

---

Key Pattern:

We compute a running prefix sum (balance):

- Each 0 decreases the balance by 1
- Each 1 increases the balance by 1

If the same prefix sum appears again:
    → the subarray between those indices sums to 0
    → therefore it contains equal 0s and 1s

We track:
- earliest index of each prefix sum

We only store the first occurrence because earlier indices produce longer valid subarrays in future matches.

---

Pattern Learned:

Prefix Sum + HashMap

Need COUNT?
────────────
Store frequencies.

lookup:
prefixSum -> count

Edge case:
[0:1]

---

Need LONGEST / DISTANCE?
────────────────────────
Store earliest index.

lookup:
prefixSum -> earliest index

Edge case:
[0:-1]
*/
// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:

     At each index i:

     - runningSum stores the transformed prefix sum (balance) after mapping:
         0 → -1
         1 → +1

     - lookup stores the earliest index where each transformed prefix sum was first seen.

     If the current runningSum has been seen before, the subarray between those two indices has a transformed sum of 0, meaning it contains an equal number of 0s and 1s.
 
 Key Insight:

 Instead of recounting 0s and 1s for every subarray,
 we maintain a transformed running prefix sum.

 For each element:

     if nums[i] == 0:
         runningSum -= 1

     else:
         runningSum += 1

 If the current runningSum has been seen before:

     → the subarray between the previous index and current index
       contains an equal number of 0s and 1s.

     → Update longest.

 Otherwise:
     → Store the first occurrence of the current runningSum.
 
 We only store the earliest occurrence because it produces
 the longest possible subarray for future matches.
*/

func optimized(_ nums: [Int]) -> Int {
    var longest: Int  = 0
    var lookup:[Int:Int] = [0:-1]
    var runningSum = 0
    
    for i in 0..<nums.count {
        
        if nums[i] == 0 {
            runningSum -= 1
        } else {
            runningSum += 1
        }
        
        if let prevIndex = lookup[runningSum] {
            longest = max(longest, i - prevIndex)
        }
        
        
        if lookup[runningSum] == nil {
            lookup[runningSum] = i
        }
        
    }


    return longest
}

optimized([0,1])

/*
 Phase 7 Validation Trace
 --------------------------------------------------
 
 Example:
 Input: nums = [0,1,0]
 Output: 2

 --------------------------------------------------

 Initial:

 runningSum = 0
 longest = 0
 lookup = [0:-1]

 --------------------------------------------------

 i = 0

 nums[0] = 0

 Transform:
 0 → -1

 runningSum = 0 - 1 = -1

 lookup[-1] not found
 → store earliest occurrence

 lookup = [0:-1, -1:0]

 --------------------------------------------------

 i = 1

 nums[1] = 1

 Transform:
 1 → +1

 runningSum = -1 + 1 = 0

 lookup[0] = -1

 longest = max(0, 1 - (-1))
          = 2

 lookup[0] already exists
 → keep earliest index (-1)

 --------------------------------------------------

 i = 2

 nums[2] = 0

 Transform:
 0 → -1

 runningSum = 0 - 1 = -1

 lookup[-1] = 0

 longest = max(2, 2 - 0)
          = 2

 lookup[-1] already exists
 → keep earliest index (0)

 --------------------------------------------------

 Return:

 longest = 2
*/

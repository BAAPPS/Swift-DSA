// MARK: - Problem Statement

// MARK: Problem : Subarray Sum Equals K

/*
Goal: Determine how many subarrays equals to the given k

 Example 1:
 Input: nums = [1,1,1], k = 2
 Output: 2

 Example 2:
 Input: nums = [1,2,3], k = 3
 Output: 2   // [1,2], [3]
*/

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
    - We are trying to find, how mny subarrays have the sum equals to the given k
 

 - Obvious approach
 
    - The most obvious approach:
 
        - Create a variable to count subarrays equals k
 
        - For every starting index:
 
            Start a running sum at 0.

            Extend the subarray one element at a time.

            After each extension:
                 - Update the running sum.
                 - Check if the sum equals k.

        This allows us to evaluate every possible subarray.
         
 - Performance Analysis
    
    Time Complexity: O(n^2)
        - Two loops traversal
            - Inner (O(n))
            - Outer (O(n))
 
    Space Complexity: O(1)
        - Stores total subarray count
 */

func bruteForce(_ nums: [Int], _ k: Int) -> Int {
    
    var totalSubarrays: Int = 0
    
    for i in 0..<nums.count {
        var count = 0
        
        for j in i..<nums.count {
            count += nums[j]
            
            if count == k {
                totalSubarrays += 1
            }
        }
    }

    return totalSubarrays
}

bruteForce([1,1,1], 2)



// MARK: - Phase 2: Manual Tracing

/*
Example:
Input: nums = [1,2,3], k = 3
Output: 2    // [1,2], [3]

Invariant:
 - Before checking count == k, count represents the sum of every element in the current
  subarray nums[i...j].

---

Initial:

totalSubarrays = 0

---

i = 0
count = 0

j = 0
Subarray = [1]

count = 0 + 1
count = 1

count != k

---

j = 1
Subarray = [1,2]

count = 1 + 2
count = 3

count == k
totalSubarrays = 1

---

j = 2
Subarray = [1,2,3]

count = 3 + 3
count = 6

count != k

---

i = 1
count = 0

j = 1
Subarray = [2]

count = 0 + 2
count = 2

count != k

---

j = 2
Subarray = [2,3]

count = 2 + 3
count = 5

count != k

---

i = 2
count = 0

j = 2
Subarray = [3]

count = 0 + 3
count = 3

count == k
totalSubarrays = 2

---

Return 2
*/


// MARK: - Phase 3: Pattern Discovery

/*
Observation From Brute Force:

For every starting index, we rebuild subarray sums from scratch.

This causes repeated work because many elements are added over and over again.

---

Key Insight From Tracing:

- count always represents the sum of the current subarray nums[i...j].

- We spend most of our time repeatedly calculating subarray sums.

- If cumulative sums were precomputed, any subarray sum could be derived without rebuilding it element by element.

---

Optimization Direction:

- Build cumulative (prefix) sums.

- Instead of searching all previous starting positions, determine whether a previously seen prefix sum exists that would make the current subarray sum equal to k.

- Store previously seen prefix sums for fast lookup.
*/

// MARK: - Phase 4: Optimized Prefix Sum Solution


func prefixSum(_ nums: [Int], _ k: Int) -> Int {
    var lookup: [Int:Int] = [0:1]
    var total: Int = 0
    var runningPrefix: Int = 0
    
    
    for i in 0..<nums.count {
        runningPrefix += nums[i]
        let neededPrefix = runningPrefix - k
        
        if let count = lookup[neededPrefix] {
            total += count
        }
        
        lookup[runningPrefix, default: 0 ] += 1
        
    }
    
    
    return total
}

prefixSum([1,2,3], 3)

// MARK: - Phase 5: Complexity Analysis

/*
Time Complexity: O(n)
- We traverse the array once.
- Each lookup and update in the hashmap is O(1) on average.

Space Complexity: O(n)
- We store prefix sums in a hashmap.
- In the worst case, we store one entry per element.
*/

// MARK: - Phase 6: Final Insight

/*
Final Insight & Patterns Learned:

The brute force approach works by checking every possible subarray, but it repeatedly recalculates sums, leading to unnecessary work.

---

Core Insight:

Instead of recomputing subarray sums, we maintain a running prefix sum as we iterate through the array.

This allows us to represent the sum of any subarray using:

    subarraySum = runningPrefix - previousPrefix

---

Key Idea:

- We compute a running prefix sum while iterating.
- For each position, we compute:
    
    neededPrefix = runningPrefix - k

- If we have seen this neededPrefix before in our lookup table, then a valid subarray ending at the current index exists.

- Otherwise, we store the current runningPrefix in the lookup table.

---

Edge Case Insight:

We initialize the lookup table depending on what we store:

- If storing frequencies (this problem):
    lookup[0] = 1
    → we have seen an empty prefix once

- If storing indices (other variations):
    lookup[0] = -1
    → prefix sum 0 occurs before array starts

---

Final Understanding:

The lookup table allows us to quickly determine whether a previous prefix sum exists that forms a valid subarray with sum k.
*/
// MARK: - Phase 7: Re-Code (After Break)


/*

Invariant:

* runningSum contains the prefix sum up to the current index.
* lookup stores the frequency of every prefix sum seen so far.
* totalCount stores the number of valid subarrays whose sum equals k.

---

Key Insight:

* Create:
  * runningSum to track the current prefix sum.
  * lookup table to store prefixSum -> frequency.
  * totalCount to count valid subarrays.

* Initialize:
  * lookup = [0:1]
  * This represents an empty prefix sum occurring once before the array begins.

---

Algorithm:

Traverse the array:

1. Update the running prefix sum.
    runningSum += nums[i]
 
2. Calculate the prefix sum needed to form a subarray sum of k.
    prefixNeeded = runningSum - k

3. Check whether prefixNeeded has been seen before.
    lookup[prefixNeeded]

4. If found:
   * A valid subarray exists.
   * Add the frequency to totalCount.

5. Store the current runningSum in the lookup table.
    lookup[runningSum, default: 0] += 1
---

Why It Works:

A subarray sum can be represented as:
    currentPrefix - previousPrefix = k

Rearranging:
    previousPrefix = currentPrefix - k

Therefore, if a previous prefix sum equal to (currentPrefix - k) exists, a valid subarray ending at the current index has been found.

---

Edge Case Insight:

When storing frequencies:
    lookup[0] = 1

    Meaning:
        * We have seen a prefix sum of 0 exactly once.
        * This allows subarrays that start at index 0 to be counted.

For problems storing indices instead:
    lookup[0] = -1

    Meaning:
        * Prefix sum 0 occurs before the array begins.

*/


func optimized(_ nums: [Int], _ k: Int) -> Int {
    
    var runningSum: Int = 0
    var lookup:[Int: Int] = [0:1]
    var totalCount: Int = 0
    
    for i in 0..<nums.count {
        runningSum += nums[i]
        
        let prefixNeeded = runningSum - k
        
        if let count = lookup[prefixNeeded] {
            totalCount += count
        }
        
        lookup[runningSum, default: 0] += 1
    }
    
    return totalCount
}

optimized([1,2,3], 3)

/*
 Phase 7 Validation Trace
 --------------------------------------------------
 
 Example:
 Input:
    nums = [1,2,3], k = 3
 
 Output: 2
 
 Valid Subarrays:  [1,2], [3]
 

 ---

 Initial State

 runningSum = 0

 lookup = [0:1]

 totalCount = 0

 ---

 i = 0

 nums[0] = 1

 Update runningSum:
    runningSum = 1
 
 Calculate prefixNeeded:
    prefixNeeded = 1 - 3
    prefixNeeded = -2

 Check lookup:
    lookup[-2] -> nil
 
 No valid subarray found.

 Store current prefix sum:
    lookup[1, default: 0] += 1
    lookup: [0:1, 1:1]

 totalCount:  0

 ---

 i = 1

 nums[1] = 2

 Update runningSum:
    runningSum = 3

 Calculate prefixNeeded:
    prefixNeeded = 3 - 3
    prefixNeeded = 0
 

 Check lookup:
    lookup[0] = 1

 Valid subarray found.

 totalCount += 1

 totalCount: 1
 
 Subarray: [1,2]
 

 Store current prefix sum:
     lookup[3, default: 0] += 1
     lookup: [0:1, 1:1, 3:1]
     
 ---

 i = 2

 nums[2] = 3

 Update runningSum:
    runningSum = 6

 Calculate prefixNeeded:
     prefixNeeded = 6 - 3
     prefixNeeded = 3


 Check lookup:
    lookup[3] = 1
 

 Valid subarray found.

 totalCount += 1

 totalCount: 2
 

 Subarray: [3]
 

 Store current prefix sum:
     lookup[6, default: 0] += 1
     lookup: [0:1, 1:1, 3:1, 6:1]
     
 ---

 Finished

 totalCount = 2

 Return: 2
 


*/

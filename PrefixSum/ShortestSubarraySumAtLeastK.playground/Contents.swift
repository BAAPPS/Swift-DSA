// MARK: - Problem Statement

// MARK:  Problem: Shortest Subarray With Sum At Least K


/*
 Goal:
    Given an integer array that may contain negative numbers, find the length of the shortest non-empty subarray whose sum is greater than or equal to K.
    Return -1 if no such subarray exists.

 
 
 Example 1:
 Input:
 nums = [2,-1,2]
 k = 3

 Output:
 3

 Explanation:
 [2,-1,2] has sum = 3


 Example 2:
 Input:
 nums = [1,2]
 k = 4

 Output:
 -1
*/
// MARK: - Phase 1: Brute Force Attempt

/*
Thought Process:

- What am I trying to find?

  Find the shortest contiguous subarray whose sum is >= k.

- Obvious approach:

  Examine every possible subarray.

  - First loop chooses starting index.
  - Second loop expands ending index.

  While expanding:
  - Maintain running sum of nums[i...j]
  - If running sum >= k:
        - Update shortest length
        - Continue searching because a shorter valid window may exist

- Performance:
  Time Complexity: O(n²)
  Space Complexity: O(1)
*/

func bruteForce(_ nums: [Int], _ k: Int) -> Int {
    var shortest = Int.max
    
    for i in 0..<nums.count {
        var sum = 0
        for j in i..<nums.count {
            sum += nums[j]
            
            if sum >= k  {
                shortest = min(shortest, j - i + 1)
            }
        }
    }

    return shortest == Int.max ? -1 : shortest
}

bruteForce( [2,-1,2], 3)



// MARK: - Phase 2: Manual Tracing

/*
Input:
nums = [2,-1,2]
k = 3

Output:
3

---

Initial:

shortest = Int.max

---

i = 0

j = 0
nums[0] = 2

sum = 2

2 < 3
Invalid

---

j = 1
nums[1] = -1

sum = 2 + (-1) = 1

1 < 3
Invalid

---

j = 2
nums[2] = 2

sum = 1 + 2 = 3

3 >= 3

Current length:
j - i + 1
2 - 0 + 1 = 3

shortest = min(Int.max, 3)

shortest = 3

---

i = 1

j = 1

sum = -1

-1 < 3

Invalid

---

j = 2

sum = -1 + 2 = 1

1 < 3

Invalid

---

i = 2

j = 2

sum = 2

2 < 3

Invalid

---

Final:

shortest = 3

*/


// MARK: - Phase 3: Pattern Discovery

/*
Observation From Brute Force:

- We repeatedly compute sums for overlapping subarrays.
- This creates redundant work because many subarrays share the same elements.
- For every starting index i, we extend j and maintain a running sum.

---

Key Insight From Tracing:

Instead of explicitly checking every subarray, represent a subarray sum using prefix sums:

    subarraySum = currentPrefix - previousPrefix

A subarray is valid when:

    currentPrefix - previousPrefix >= K

Rearrange:

    previousPrefix <= currentPrefix - K

This means for every current prefix sum, we need to find a previous prefix sum that is:

    1. Small enough to create a valid sum
    2. As far left as possible to minimize the subarray length

---

Pattern Insight:

This problem is not an exact prefix lookup problem.

We do not need:

    "Have I seen this prefix before?"

Instead, we need:

    "What is the best previous prefix state that satisfies a condition?"

For the shortest subarray:

- We want the earliest index with a qualifying prefix sum.
- We need to efficiently remove prefix states that can never produce a better answer.

---

Optimization Direction:

Maintain prefix sums while processing the array.

Use a data structure that allows:

- Removing dominated prefix states
- Quickly finding the smallest valid prefix sum

This leads to:

Prefix Sum + Monotonic Queue
*/

// MARK: - Phase 4: Optimized Prefix Sum + Montonic Queue Solution

struct PrefixState {
    let index: Int
    let sum: Int
}

func shortestSubarray(_ nums: [Int], _ k: Int) -> Int {
    var deque: [PrefixState] = []
    var shortest: Int = Int.max
    var prefix: Int = 0
    
    // start with empty prefix
    deque.append(PrefixState(index:0, sum: 0))
    
    for i in 1...nums.count {
        prefix += nums[i-1]
        
        // 1. Check if front gives valid subarray
        while let first = deque.first, prefix - first.sum >= k {
            shortest = min(shortest, i - first.index)
            deque.removeFirst()
        }
        
        // 2. Maintain increasing prefix sums
        while let last = deque.last, last.sum >= prefix {
            deque.removeLast()
        }
        
        // 3. Add current prefix state
        deque.append(PrefixState(index: i, sum: prefix))
    }
    
    
    return shortest == Int.max ? -1 : shortest
}

shortestSubarray( [2,-1,2], 3)


// MARK: - Phase 5: Complexity Analysis

/*
Time Complexity: O(n)

Each prefix sum is added to the monotonic deque once and removed at most once.
Although we use while loops, each element participates in a constant amount of work
(amortized O(1)).

Space Complexity: O(n)

The deque stores prefix states:
(index, prefixSum)

In the worst case, all prefix states may remain in the deque.
 
*/
 
// MARK: - Phase 6: Final Insight

 /*
 Final Insight & Patterns Learned:

 From the brute force:

 - We repeatedly compute sums for overlapping subarrays.

 - This creates redundant work because many subarrays share the same elements.

 - For every starting index i, we extend j and maintain a running sum.

 ---

 Core Insight:

 A subarray sum can be represented using prefix sums:

     subarraySum = currentPrefix - previousPrefix

 For every current prefix sum, we need to find a previous prefix sum that:

 1. Is small enough to satisfy:

        currentPrefix - previousPrefix >= K

 2. Is as far left as possible to minimize:

        currentIndex - previousIndex

 This transforms the problem into:

 "What is the best previous prefix state that satisfies a condition?"

 ---

 Pattern Learned:

 Prefix Sum + Monotonic Queue

 A monotonic queue maintains only useful prefix states.

 Unlike a normal queue:

 - Remove from the front when a prefix state already creates a valid shortest subarray.

 - Remove from the back when a prefix state is dominated by a newer, smaller prefix sum.

 The queue maintains increasing prefix sums from front to back.

 By removing useless states, we avoid checking every possible subarray.

 */

// MARK: - Phase 7: Re-Code (After Break)

/*
Invariant:

At each prefix state:

- prefix stores the running prefix sum up to the current index.
- deque stores candidate prefix states (index, prefixSum).
- The deque is maintained in increasing order of prefix sums.
- Every prefix state remaining in the deque is still capable of producing the shortest valid subarray for some future prefix.

Key Insight:

Represent every subarray using prefix sums:

    subarraySum = currentPrefix - previousPrefix

A valid subarray must satisfy:

    currentPrefix - previousPrefix >= K

Instead of remembering every previous prefix sum, we only keep useful prefix states.

- Remove from the front when the current prefix forms a valid subarray.
  This updates the shortest length, and that prefix state can never produce a shorter answer again.

- Remove from the back when a newer prefix sum is smaller than or equal to the previous one.
  The newer prefix state dominates the older one because it can produce the same or larger subarray sums while yielding shorter lengths.

This guarantees the deque always contains the best candidate prefix states for future iterations.
*/

struct prefixStateOptimized {
    let index: Int
    let sum: Int
}

func optimized(_ nums: [Int], _ k: Int) -> Int {
    var deque: [prefixStateOptimized] = []
    var shortest: Int = Int.max
    var prefix: Int = 0
    
    deque.append(prefixStateOptimized(index: 0, sum: 0))
    
    for i in 1...nums.count {
        prefix += nums[i - 1]
        
        while let first = deque.first, prefix - first.sum >= k {
            shortest = min(shortest, i - first.index)
            deque.removeFirst()
        }
        
        while let last = deque.last, last.sum >= prefix {
            deque.removeLast()
        }
        
        deque.append(prefixStateOptimized(index: i, sum: prefix))
    }
    
    
    return shortest == Int.max ? -1 : shortest
}

optimized( [2,-1,2], 3)


/*
 Phase 7 Validation Trace
 -------------------------------------------------
 
 Example 1:

 Input:
 nums = [2,-1,2]
 k = 3

 Output:
 3

 Explanation:
 [2,-1,2] has sum = 3

 ---

 Initial:

 prefix = 0
 shortest = Int.max

 deque = [(index: 0, sum: 0)]

 ---

 i = 1
 nums[0] = 2

 prefix = 0 + 2 = 2

 Front Check:

 2 - 0 = 2

 2 < 3

 No valid subarray.

 ---

 Back Check:

 last.sum = 0

 0 >= 2 ?

 No.

 Append current prefix state.

 deque = [(0,0),(1,2) ]

 ---

 i = 2
 nums[1] = -1

 prefix = 2 + (-1) = 1

 Front Check:

 1 - 0 = 1

 1 < 3

 No valid subarray.

 ---

 Back Check:

 last.sum = 2

 2 >= 1

 Yes.

 Remove (1,2)

 deque = [(0,0)]

 Check again:

 last.sum = 0

 0 >= 1 ?

 No.

 Append current prefix state.

 deque = [(0,0), (2,1)]

 ---

 i = 3
 nums[2] = 2

 prefix = 1 + 2 = 3

 Front Check:

 3 - 0 = 3

 3 >= 3

 Valid subarray.

 length = 3 - 0 = 3

 shortest = min(Int.max, 3)

 shortest = 3

 Remove front.

 deque = [(2,1)]

 Check front again:

 3 - 1 = 2

 2 < 3

 Stop.

 ---

 Back Check:

 last.sum = 1

 1 >= 3 ?

 No.

 Append current prefix state.

 deque = [(2,1), (3,3)]

 ---

 Final:

 shortest = 3

 Return 3
*/

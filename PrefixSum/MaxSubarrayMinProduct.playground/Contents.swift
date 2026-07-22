// MARK: - Problem Statement
// MARK: Problem (Advanced): Maximum Subarray Min-Product

/*
Goal:
Given an array of positive integers, find the maximum value of the minimum element of a subarray multiplied by the sum of that subarray. Return the result modulo 10⁹ + 7.

 Example 1:
 Input: nums = [1,2,3,2]
 Output: 14

 Example 2:
 Input: nums = [2,3,3,1,2]
 Output: 18
*/

// MARK: - Phase 1: Brute Force Attempt

/*
Thought Process:

- What am I trying to find?
    - We want to determine the maximum min-product among all contiguous subarrays.

  For every subarray:
  - Find its minimum element.
  - Find its sum.
  - Compute:
        min-product = minimum × subarray sum
 
  Return the largest min-product modulo 1_000_000_007.
 
---

- Obvious approach

  The most straightforward solution is to examine every possible subarray.

  - The first loop selects the starting index.
  - The second loop expands the ending index.

  Create a variable to keep track of the largest min-product found so far.

  As the ending index expands:

  - Maintain the running sum of the current subarray.
  - Maintain the minimum element seen in the current subarray.
  - Compute:
        min-product = minimum × runningSum

  - Update the largest min-product if the current one is greater.

  After examining every subarray, return the largest min-product modulo 1_000_000_007.

---

- Performance Analysis
  Time Complexity: O(n²)
  Space Complexity: O(1)

*/

func bruteForce(_ num: [Int]) -> Int {
    
    let MOD = Int64(1_000_000_007)
    var answer: Int64 = 0
    
    for i in 0..<num.count {
        var minimum: Int64 = Int64.max
        var sum: Int64  = 0
        for j in i..<num.count{
            var  minProduct:Int64 = 0
            minimum = min(minimum, Int64(num[j]))
            sum += Int64(num[j])
            minProduct = sum * minimum
            answer = max(answer, minProduct)
        }
    }
    
    return Int(answer % MOD)
}

bruteForce([1,2,3,2])

// MARK: - Phase 2: Manual Tracing

/*
Example:
Input: nums = [1,2,3,2]
Output: 14

---

Initial:

MOD = Int64(1_000_000_007)
answer = 0

---

i = 0

minimum = Int64.max
sum = 0

j = 0
Subarray = [1]

minimum = min(Int64.max, 1) = 1
sum = 0 + 1 = 1

minProduct = 1 * 1 = 1

answer = max(0, 1) = 1

---

j = 1
Subarray = [1,2]

minimum = min(1, 2) = 1
sum = 1 + 2 = 3

minProduct = 1 * 3 = 3

answer = max(1, 3) = 3

---

j = 2
Subarray = [1,2,3]

minimum = min(1, 3) = 1
sum = 3 + 3 = 6

minProduct = 1 * 6 = 6

answer = max(3, 6) = 6

---

j = 3
Subarray = [1,2,3,2]

minimum = min(1, 2) = 1
sum = 6 + 2 = 8

minProduct = 1 * 8 = 8

answer = max(6, 8) = 8

================================================

i = 1

minimum = Int64.max
sum = 0

j = 1
Subarray = [2]

minimum = min(Int64.max, 2) = 2
sum = 2

minProduct = 2 * 2 = 4

answer = max(8, 4) = 8

---

j = 2
Subarray = [2,3]

minimum = min(2, 3) = 2
sum = 5

minProduct = 2 * 5 = 10

answer = max(8, 10) = 10

---

j = 3
Subarray = [2,3,2]

minimum = min(2, 2) = 2
sum = 7

minProduct = 2 * 7 = 14

answer = max(10, 14) = 14

================================================

i = 2

minimum = Int64.max
sum = 0

j = 2
Subarray = [3]

minimum = 3
sum = 3

minProduct = 3 * 3 = 9

answer = max(14, 9) = 14

---

j = 3
Subarray = [3,2]

minimum = min(3, 2) = 2
sum = 5

minProduct = 2 * 5 = 10

answer = max(14, 10) = 14

================================================

i = 3

minimum = Int64.max
sum = 0

j = 3
Subarray = [2]

minimum = 2
sum = 2

minProduct = 2 * 2 = 4

answer = max(14, 4) = 14

---

Final:

answer = 14

Return:

14 % 1_000_000_007 = 14

*/

// MARK: - Phase 3: Pattern Discovery

/*
Observation From Brute Force:

- We repeatedly compute the running sum, minimum element, and min-product for overlapping subarrays.
- This creates redundant work because many subarrays share the same elements.
- For every starting index i, we extend j while maintaining a running sum and running minimum.

---

Key Insight From Tracing:

The running sum is easy to maintain as the subarray expands.

However, the minimum element determines how large the min-product can become.

Instead of asking:

    "What is the minimum of every subarray?"

We can reverse the question:

    "If nums[i] is the minimum, how far can it extend while remaining the minimum?"

This shifts our perspective from examining every subarray to examining every element.

---

Pattern Insight:

 Treat every element as the minimum of its own optimal subarray.

 For each element:

 - Find the furthest boundary to the left where it remains the minimum.
 - Find the furthest boundary to the right where it remains the minimum.

 Once these boundaries are known:

 - Use prefix sums to compute the subarray sum in O(1).
 - Compute the min-product for that element.
 - Keep the maximum answer.
 
    
*/

// MARK: - Phase 4: Optimized Prefix Sum + Monotonic Stack Solution

struct StackState {
    let index: Int
    let value: Int
}
func maxSubarrayMinProduct(_ num: [Int]) -> Int {
    let MOD = Int64(1_000_000_007)
    var stack: [StackState] = []
    var answer: Int64 = 0
    var prefix: [Int] = Array(repeating: 0, count: num.count + 1)
    
    for i in 0...num.count {
        let current:Int
        
        if i < num.count {
            prefix[i+1] = prefix[i] + num[i]
            current = num[i]
        } else {
            // Sentinel to flush remaining stack
            current = 0
        }
        
        while let last = stack.last, last.value > current {
            let resolvedState = stack.removeLast()
            let leftBoundary = stack.last?.index ?? -1
            let rightBoundary = i
            let rangedSum = prefix[rightBoundary] - prefix[leftBoundary + 1]
            let minProduct = Int64(resolvedState.value) * Int64(rangedSum)
            
            answer = max(answer, minProduct)

            
        }
        
        if i < num.count {
            stack.append(StackState(index: i, value: current))
        }
        
        
    }
    
    
    return Int(answer % MOD)
}

maxSubarrayMinProduct([1,2,3,2])

// MARK: - Phase 5: Complexity Analysis

/*
Time Complexity: O(n)
    → We traverse the array once while maintaining a monotonic stack.

    Each element is:
    - pushed onto the stack once
    - popped from the stack once

    Therefore, the total number of stack operations is linear.

    Prefix sum construction also takes O(n).

    Overall: O(n)


Space Complexity: O(n)
    → We store:
        - Prefix sum array of size n + 1
        - Monotonic stack containing up to n elements

    Therefore, the extra memory usage grows linearly with the input size.

    Overall: O(n)

*/

// MARK: - Phase 6: Final Insight

/*
Final Insight & Patterns Learned:

This problem introduced a new optimization pattern:
Monotonic Stack + Prefix Sum.

Unlike previous prefix sum problems where we search for previous prefix states,
this problem focuses on boundary discovery.

---

Core Insight:

Instead of asking:

"How do we find the minimum value for every subarray?"

We reverse the perspective:

"For each element, what is the largest subarray where this element remains the minimum?"

Each element becomes responsible for a range.

---

Boundary Checking Pattern:

A monotonic increasing stack maintains elements that are waiting to discover their right boundary.

For every current value:

- If current value is greater than the stack top:
    → The stack remains increasing.
    → The previous elements may extend further.

- If current value is smaller than the stack top:
    → The current value becomes the right boundary.
    → The popped element's range has been discovered.

The remaining stack after popping determines the left boundary.

---

Sentinel Flush Pattern:

Some elements never encounter a smaller value because they extend until the end of the array.

To resolve these remaining elements:

- Add a sentinel value smaller than all possible values.
- This forces the remaining stack elements to pop.
- Their boundaries can then be calculated normally.

---

Range Sum Pattern:

The monotonic stack determines:

- Which element is the minimum.
- The left and right boundaries of its range.

Prefix sum is then used to calculate the sum of that range in O(1).

The roles are separated:

Monotonic Stack:
→ Discover boundaries.

Prefix Sum:
→ Calculate range sum.

Final formula:

minProduct = minimum value × range sum

---

Pattern Learned:

When a problem asks for:
- minimum/maximum of every subarray
- largest possible range where an element dominates
- next smaller/greater boundaries

Think:

Boundary Discovery → Monotonic Stack

Range Calculation → Prefix Sum

Together:

Monotonic Stack + Prefix Sum
*/

// MARK: - Phase 7: Re-Code (After Break)

/*
*/

func optimized(_ num: [Int]) -> Int {
    return 0
}

optimized([1,2,3,2])

/*
 Phase 7 Validation Trace

 Invariant:


 --------------------------------------------------


*/


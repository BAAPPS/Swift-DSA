// MARK: - Problem Statement
/*
  MARK: - Problem 5: Daily Temperatures

  Goal:
      Given a list of daily temperatures, return an array where
      each element represents the number of days you would have
      to wait until a warmer temperature.

      If there is no future day with a warmer temperature,
      return 0 for that day.

  Example 1:
      Input:  [73,74,75,71,69,72,76,73]
      Output: [1,1,4,2,1,1,0,0]

  Example 2:
      Input:  [30,40,50,60]
      Output: [1,1,1,0]
 */

// MARK: - Phase 1: Brute Force Attempt

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:

 - What am I trying to find?

 For each day, determine how many days we must wait until a warmer temperature occurs.
 If a warmer day exists in the future, return the number of days between the current day and that warmer day.
 Otherwise, return 0.

 ------------------------------------------------------------

 - Obvious Approach

 The most straightforward approach is to compare each temperature with all future temperatures until a warmer one is found.

 Steps:

 1) Create a result array initialized with 0s, matching the size of the input array.

 2) Use two loops:
    - The first loop represents the current day (index i).
    - The second loop scans forward to find a warmer temperature.

 3) While scanning forward:
    - If a warmer temperature is found
        - Calculate the number of days waited using the difference between indices: days = j - i

    - Store this value in the result array and stop searching since we only care about the first warmer day.

 4) If no warmer day is found, the value remains 0.

 5) Return the result array.

 ------------------------------------------------------------

 - Performance Analysis

 Time Complexity: O(n²)
    In the worst case, each element may scan the rest of the array.

 Space Complexity: O(n)
    We allocate a new array to store the results.
*/

func bruteForce(_ input: [Int]) -> [Int] {

    var result:[Int] = Array(repeating: 0, count: input.count)
    for i in 0..<input.count {
        for j in i+1..<input.count {
            if input[j] > input[i] {
                result[i] = j - i
                break
            }
        }
    }
    
    return result
}

bruteForce([2, 1, 2, 4, 3]) // [3,1,1,0,0]
bruteForce([73,74,75,71,69,72,76,73]) // [1,1,4,2,1,1,0,0]

// MARK: - Phase 2: Manual Tracing

/*
 Example:
     Input:  [2, 1, 2, 4, 3]
     Output: [3,1,1,0,0]

 Invariant:
    For each index i, we scan the range (i+1...n-1) until the first warmer temperature is found.

 ----------------------------------------------------

 Step 1
 result = [0,0,0,0,0]

 i = 0

 j = 1
 input[j] = 1, input[i] = 2
 1 < 2 → continue

 j = 2
 input[j] = 2, input[i] = 2
 2 == 2 → continue

 j = 3
 input[j] = 4, input[i] = 2
 4 > 2 → warmer day found

 result[0] = 3 - 0 = 3
 break

 ----------------------------------------------------

 Step 2
 result = [3,0,0,0,0]

 i = 1

 j = 2
 input[j] = 2, input[i] = 1
 2 > 1 → warmer day found

 result[1] = 2 - 1 = 1
 break

 ----------------------------------------------------

 Step 3
 result = [3,1,0,0,0]

 i = 2

 j = 3
 input[j] = 4, input[i] = 2
 4 > 2 → warmer day found

 result[2] = 3 - 2 = 1
 break

 ----------------------------------------------------

 Step 4
 result = [3,1,1,0,0]

 i = 3

 j = 4
 input[j] = 3, input[i] = 4
 3 < 4 → continue

 No warmer day found
 result[3] remains 0

 ----------------------------------------------------

 Step 5

 i = 4
 No future elements to check

 result[4] remains 0

 ----------------------------------------------------

 Final Result: [3,1,1,0,0]
 */


// MARK: - Phase 3: Pattern Discovery

/*
 Observations from the brute force approach:

 For every index i, we scan forward until we find a temperature
 greater than the current temperature.

 This means we are repeatedly solving the same subproblem: "Find the next greater element to the right."

 ------------------------------------------------------------

 Inefficiency:

 The brute force solution repeatedly scans the future portion
 of the array for every index. This results in redundant work and leads to O(n²) time complexity.

 ------------------------------------------------------------

 Pattern Recognition:

 This problem belongs to the class of: Next Greater Element

 These problems can be optimized using a Monotonic Stack.

 ------------------------------------------------------------

 Key Insight:

 Instead of scanning forward repeatedly, we can keep track of
 indices whose next warmer temperature has not yet been found.

 By maintaining a Monotonic Decreasing Stack (based on temperature),
 we ensure that:

 - The stack stores indices of temperatures waiting for a warmer day
 - When a warmer temperature appears, we resolve multiple indices
   at once by popping from the stack
 - The difference between indices gives the number of days waited

 This allows us to solve the problem in O(n) time.
*/

// MARK: - Phase 4: Optimized Monotonic Decreasing Stack Solution

func monotonicDecreasingStack(_ input: inout [Int]) -> [Int] {
    var stack: [Int] = []
    var result: [Int] = Array(repeating:0, count: input.count)
    
    for (i, current) in input.enumerated() {
        while let lastIndex = stack.last, input[lastIndex] < current {
            var resolvedIndex = stack.removeLast()
            result[resolvedIndex] = i - resolvedIndex
        }
        stack.append(i)
    }
    
    return result
}

var input = [73,74,75,71,69,72,76,73]

monotonicDecreasingStack(&input)

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)

 Each element is pushed onto the stack once and popped at most once.
 Although a while loop exists inside the traversal, the total number
 of stack operations across the entire algorithm is bounded by n.

 Therefore, the overall runtime is linear.

 ------------------------------------------------------------

 Space Complexity: O(n)

 We use:
 - A stack to store indices of unresolved temperatures
 - A result array to store the number of days until a warmer temperature

 In the worst case, the stack may contain all elements.
*/

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:

 The brute force approach repeatedly scans the right side of the array
 until it finds the next greater temperature, resulting in redundant work.

 The key observation is that when a higher temperature appears, it can
 resolve the next greater temperature for multiple lower temperatures that came before it.

 Instead of repeatedly scanning forward, we can track indices whose
 next greater temperature has not yet been found.

 By using a Monotonic Decreasing Stack (based on temperature values),
 we maintain a stack of indices where temperatures are in decreasing order.

 When the current temperature becomes greater than the temperature at the top of the stack:

   - The current temperature is the next warmer day for that index
   - We pop the index from the stack
   - We compute the distance between the indices to determine the number of days waited

 This process may resolve multiple indices at once.

 Because each index is pushed onto the stack once and popped at most once, the algorithm runs in O(n) time.
*/

// MARK: - Phase 7: Re-Code (After Break)

/*

 Invariant:
 Key Insight:
*/

func optimized(_ input: [Int]) -> [Int] {
    


    return []
}

optimized([1, 3, 2, 4])

/*
 Phase 7 Validation Trace
 --------------------------------------------------

*/

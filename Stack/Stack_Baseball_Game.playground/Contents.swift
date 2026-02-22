// MARK: - Problem Statement
/*
 Goal:
 Given a list of operations representing baseball scores,
 calculate the total score after all operations are applied.
 
 Constraints:
 - 1 <= ops.length <= 10,000
 - ops[i] is an integer, "+", "D", or "C"
 
 Example:
 Input: ["5", "2", "C", "D", "+"]
 Output: 30
 
 Explanation:
 Each operation depends on previous valid scores, which must be tracked and updated dynamically.
 
 */

// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 
 - What am I trying to find?
 
 The total score after all operations are applied in the given array
 
 Example:
 Input: ["5", "2", "C", "D", "+"]
 Output: 30
 
 - Obvious approach
 
 The most obvious approach:
 
 - Create a new array to add the current score after operations are done
 
 - Create a pointer to traverse our given array input
 
 - As we traverse our given input array, we do the following:
 
 - Check if the current element is an operation of C, D, +:
 
 - If it is C, remove the previous element as we need to "cancel"
 
 - If it is D, we double the previous element
 
 - If it is +, we add the last two element
 
 - If current element is a digit, add it to the new array
 
 - Performance Analysis
 
 Time Complexity: O(n)
 - We traverse the array once
 - Each element is processed in constant time
 
 Space complexity: O(n)
 - This is due to the final result being stored in a new array
 
 - Note:
 While this solution is already O(n), we label it as "Phase 1: Brute Force Attempt"
 because it represents the initial, straightforward approach to the problem.
 Phase 4 will explore further optimization or alternate approaches if needed.
 */

func bruteForce(_ arr: [String]) -> Int {
    
    var result: [Int] = []
    var i: Int = 0
    
    while i < arr.count {
        let current = arr[i]
        
        switch current {
        case "C":
            result.removeLast()
        case "D":
            if let last = result.last {
                result.append( last * 2)
            }
        case "+":
            
            if result.count >= 2 {
                let sum = result[result.count - 1] + result[result.count - 2]
                result.append(sum)
            }
        default:
            if let num = Int(current) {
                result.append(num)
            }
        }
        i += 1
    }
    
    return result.reduce(0, +)
}

bruteForce(["5", "2", "C", "D", "+"])


// MARK: - Phase 2: Manual Tracing

/*
 Example Input:
 ["5", "2", "C", "D", "+"]
 
 Invariant:
 After processing arr[i], `result` accurately reflects the valid score history.
 
 Step-by-Step Trace:
 
 1st Iteration:
 result = []
 current = "5"
 - "5" is a number → add to result
 result = [5]
 Invariant holds ✅
 i += 1
 
 2nd Iteration:
 result = [5]
 current = "2"
 - "2" is a number → add to result
 result = [5, 2]
 Invariant holds ✅
 i += 1
 
 3rd Iteration:
 result = [5, 2]
 current = "C"
 - "C" cancels the previous score → remove last
 result = [5]
 Invariant holds ✅
 i += 1
 
 4th Iteration:
 result = [5]
 current = "D"
 - "D" doubles the previous score → 5 * 2 = 10 → add to result
 result = [5, 10]
 Invariant holds ✅
 i += 1
 
 5th Iteration:
 result = [5, 10]
 current = "+"
 - "+" adds last two scores → 5 + 10 = 15 → add to result
 result = [5, 10, 15]
 Invariant holds ✅
 i += 1
 
 Loop ends (i == arr.count)
 
 Final Result:
 result = [5, 10, 15]
 total = 5 + 10 + 15 = 30
 */

// MARK: - Phase 3: Pattern Discovery

/*
 Pattern Discovery from Phase 2: Manual Tracing
 
 Problem Insight:
 
 - Whenever an operation depends on recent history (previous valid values), a stack is the natural data structure.
 - A stack allows:
 1) Access to the most recent value (top of stack)
 2) Undoing previous values (pop)
 3) Combining recent values (peek last one or two)
 
 Mapping Operations to Stack Actions:
 
 | Operation | Stack Action                         |
 |-----------|--------------------------------------|
 | C         | Remove the previous element (pop)    |
 | D         | Double the previous element and push |
 | +         | Sum of last two elements and push    |
 | Number    | Push the value onto the stack        |
 
 Implementation Pattern:
 
 1) Initialize an empty stack (use result array)
 2) Traverse the input array
 3) For each element:
 - If it is a number → push onto stack
 - If it is "C" → pop last element
 - If it is "D" → append last element * 2
 - If it is "+" → append sum of last two elements
 4) After processing all elements, compute total by summing stack
 
 Invariant:
 - At any point in traversal, the stack contains all valid scores up to that index.
 - Each operation only modifies or uses the top one or two elements.
 
 Benefits of This Pattern:
 - Efficient: O(n) time, O(n) space
 - Clear and maintainable
 - Reusable for any problem where current state depends on recent history
 */

// MARK: - Phase 4: Optimized Stack Solution

func stack(_ arr: [String]) -> Int {
    var result: [Int] = []
    
    for op in arr {
        switch op {
        case "C":
            _ = result.popLast()
        case "D":
            if let last = result.last {
                result.append(last * 2)
            }
        case "+":
            if result.count >= 2 {
                let sum = result[result.count - 1] + result[result.count - 2]
                result.append(sum)
                
            }
        default:
            if let num = Int(op) {
                result.append(num)
            }
        }
    }
    
    return result.reduce(0, +)
}

stack(["5", "2", "C", "D", "+"])

// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity: O(n)
 - We traverse the input array once to process all operations (C, D, +, numbers). Each operation is handled in constant time.
 - The final `reduce` call to sum all elements in the result stack also iterates over all n elements.
 → Overall time complexity: O(n)
 
 Space Complexity: O(n)
 - We store all valid scores in the `result` array (stack).
 - In the worst case, all elements are numbers, so the stack grows to size n.
 → Overall space complexity: O(n)
 
 Note on `reduce`:
 - The `reduce` function is O(n) time and O(1) extra space.
 - Alternatively, a running total can be maintained during stack operations to avoid a separate iteration, but asymptotic complexity remains O(n).
 */

// MARK: - Phase 6: Final Insight

/*
 Final Insight & Patterns Learned:
 
 - Using a stack allows us to efficiently access the most recent element,
 enabling operations like pop (C), push double of last element (D), and sum of last two (+).
 
 - This problem fits the classic stack pattern because all operations depend on the most recently added values (LIFO behavior).
 
 - Recognizing these operations as “history-dependent” helps identify when a stack is the appropriate data structure.
 
 */

// MARK: - Phase 7: Re-Code (After Break)
/*
 Goal:
 Re-implement the pattern-based solution from memory
 after a meaningful break (6–24 hours), without referencing previous phases.
 
 Rules:
 - No peeking at Phase 4 or earlier
 - Reconstruct the algorithm mentally first
 - If stuck, write the invariant and reasoning before coding
 
 Validation:
 - Output matches expected results
 - Invariant can be explained verbally
 - Time and space complexity are justified
 */

func optimized(_ arr: [String]) -> Int {
    var result:[Int] = []
    
    for op in arr {
        switch op {
            case "C": // Cancel = remove
                _ = result.popLast()
            case "D": // Double = double last added element
                if let last = result.last {
                    result.append(last * 2)
                }
            case "+": // Add = add the last two element
                let sum = result[result.count - 1] + result[result.count - 2]
                if result.count >= 2 {
                    result.append(sum)
                    
                }
            default: // Add integer to the stack
                if let num = Int(op) {
                    result.append(num)
                }
        }
    }
    
    
    return result.reduce(0, +)
}

optimized(["5", "2", "C", "D", "+"])

/*
 Phase 7 Validation Trace
 
 Input: ["5", "2", "C", "D", "+"]

 Invariant:
    - After processing arr[i], the stack contains all valid scores up to index i in correct order.
 
 Key Insight:
    - At each step, we only need to compare the current operation
        with the most recent kept integer (stack top),
        which guarantees O(n) time with single pass.

 --------------------------------------------------

 Step 1:
    result: []
    Current op: "5"
    Checking op -> Integer -> convert (5) -> add to result
    result: [5]
 
 Step 2:
    result: [5]
    Current op: "2"
    Checking op -> Integer -> convert (2) -> add to result
    result: [5, 2]
 
 Step 3:
    result: [5, 2]
    Current op: "C"
    Checking op -> Cancel -> remove top of result
    result: [5]
 
 Step 3:
    result: [5]
    Current op: "D"
    Checking op -> Double -> double top of stack (5 * 2 = 10) -> add to result
    result: [5, 10]
 
 Step 4:
    result: [5, 10]
    Current op: "+"
    Checking op -> Add -> add last two elements (5 + 10 = 15) -> add to result
    result: [5, 10, 15]
 
 Traversal ended
 
 Final: result -> [5, 10, 15] -> total sum = 5 + 10, 15 -> 30
 
 */


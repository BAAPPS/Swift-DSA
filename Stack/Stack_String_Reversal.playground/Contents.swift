// MARK: - Problem Statement

// MARK: Reverse a String Using Stack

/*
 Goal:
     Given a string, reverse it using a stack.

 Constraints:
     - 1 <= s.length <= 10^5
     - s contains printable ASCII characters

 Example:
     Input: s = "swift"
     Output: "tfiws"

 Explanation:
     Characters pushed into a stack are retrieved in reverse order
     due to the Last-In-First-Out property.

 Hint:
     - Push characters one by one
     - Pop them to build the reversed result
     - Stack temporarily holds characters
*/


// MARK: - Phase 1: Brute Force Attempt

/*
 Thought Process:
 - What am I trying to find?
 - Obvious approach
 - Why this is slow
*/

func bruteForce(_ nums: [Int]) -> [Int] {
    // naive solution
    return []
}

// MARK: - Phase 2: Manual Tracing


// MARK: - Phase 3: Pattern Discovery



// MARK: - Phase 4: Optimized Stack Solution


// MARK: - Phase 5: Complexity Analysis

/*
 Time Complexity:
 - O(n)

 Space Complexity:
 - O(n)

 Why:
 - Each index pushed and popped once
*/

// MARK: - Phase 6: Final Insight

/*
 Pattern Learned:
 - Monotonic stack is used when future elements can invalidate past ones
 - Stack maintains decreasing order
 - Pop happens when invariant breaks
*/

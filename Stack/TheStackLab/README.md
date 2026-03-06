# TheStackLab

**TheStackLab** is a SwiftUI playground app designed to demonstrate **stack-based algorithm patterns** through interactive utilities and a mini math game.

This project is part of a larger **DSA consolidation system**, where each algorithm pattern (Stack, Two Pointers, Sliding Window, etc.) gets its **own focused app** to reinforce understanding through real usage — not just problem solving.

---

## Purpose

The goal of TheStackLab is to:

* Reinforce **Stack (LIFO)** fundamentals
* Apply DSA concepts in a real SwiftUI environment
* Bridge the gap between algorithm problems and real applications
* Build pattern recognition and interview-ready explanations

This app prioritizes **clarity and correctness over UI polish**.

---

## Stack Concepts Covered

A **Stack** follows **Last-In, First-Out (LIFO)** order.
It is ideal for problems involving:

* Reversal
* Nested structures
* State tracking
* Undo / backtracking behavior

All features in this app intentionally rely on stack operations such as:

* `push`
* `pop`
* `peek`

---

## Features

### 1️⃣ Parentheses Validator

Validates whether a given string has balanced parentheses.

**Example:**

```
Input:  ((a+b)*c)
Output: ✅ Balanced
```

**Why Stack?**
Opening brackets are pushed onto the stack, and matching closing brackets pop them off in the correct order.

---

### 2️⃣ Reverse String

Reverses a string using stack operations.

**Example:**

```
Input:  hello
Output: olleh
```

**Why Stack?**
Characters are pushed onto the stack and popped to reverse order.

---

### 3️⃣ Math Stack Game (RPN)

A mini game where the user performs a series of math operations in **Reverse Polish Notation (RPN)** to reach a target number.
Stacks are used to store numbers and intermediate results, applying operations in the correct order.

**Example:**

```
Target: 10
Input sequence: 5 2 + 3 +
Output: 10 ✅
```

**Why Stack?**
RPN is a textbook stack problem:

* Numbers are **pushed** onto the stack
* Operators **pop operands**, perform the operation, and **push the result**
* At the end, the **top of the stack** is the final result

This demonstrates **LIFO behavior, state tracking, and controlled computation** — all core stack concepts.

---

## Project Structure

```
TheStackLab/
├── Algorithms/
├── Models/
├── Utils/
├── ViewModels/
├── Views/
└── README.md
```

---

## Architecture Principles

* Clear separation of **logic vs UI**
* Reusable algorithm functions
* Single-responsibility views
* Pattern-focused design (no mixed DSA concepts)

---

## Part of a Larger Learning System

TheStackLab is the first in a series of **pattern-based Swift apps**, including:

* TheTwoPointerLab
* TheSlidingWindowLab
* TheHashMapLab
* (and more)

Each app focuses on **one DSA pattern** to strengthen conceptual understanding and practical application.

---

## Notes

* This project is **not optimized for production**
* UI is intentionally minimal
* Focus is on **learning, correctness, and explanation**
* Features are added only after completing structured DSA phases
* Built as part of a personal **Data Structures & Algorithms learning journey**, emphasizing disciplined practice, pattern mastery, and real-world application.

---

## 🛠 Built With

* Swift
* SwiftUI
* Xcode


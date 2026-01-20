# Stack — Core Concepts & Problem-Solving Reference

A **Stack** is one of the most fundamental data structures in computer science.
It follows the **Last-In, First-Out (LIFO)** principle — the most recently added
element is always the first one removed.

Think of a stack like a pile of plates:
you can only add or remove plates from the top.

---

## Purpose of a Stack

Stacks are designed to manage **ordered, temporary state**.

They are ideal when:
- You need to **reverse** something
- You must **track previous states**
- You are dealing with **nested or hierarchical structures**
- You want to process elements in **strict LIFO order**

---

## Why Stacks Are Powerful

Stacks shine because they:

- Enforce **strict processing order (LIFO)**
- Provide **O(1)** access to the most recent element
- Naturally model **recursion and nesting**
- Simplify problems involving **backtracking**
- Convert complex logic into **linear passes**

Many problems that seem complex become trivial once modeled with a stack.

---

## Core Stack Operations

| Operation | Description |
|---------|-------------|
| `push` | Add an element to the top |
| `pop` | Remove the top element |
| `peek / top` | View the top element without removing |
| `isEmpty` | Check if the stack is empty |

⏱️ All operations run in **O(1)** time.

---

## Common Use Cases

Stacks appear everywhere in real systems and interview problems:

- Validating parentheses / brackets (`()[]{}`)
- Undo / redo functionality
- Expression evaluation (postfix, prefix)
- unction calls & recursion (call stack)
- Depth-First Search (DFS)
- Monotonic stack problems  
  (Next Greater Element, Largest Rectangle in Histogram)
- Reversing strings, arrays, or linked lists

---

## What Stacks Unlock in DSA

Using stacks allows you to:

- Replace **recursion** with iteration
- Solve **nested structure** problems cleanly
- Track **previous elements** efficiently
- Perform **single-pass (O(n))** solutions
- Detect invalid states early (mismatch, imbalance)

Stacks often turn **brute force O(n²)** solutions into **optimized O(n)** ones.

---

## Important Notes & Pitfalls

- You can only access the **top element**
- No random access like arrays
- Always check if the stack is empty before `pop` or `peek`
- Improper pops lead to **stack underflow**
- Deep recursion can cause **stack overflow**

---

## Stack Patterns to Master

As you progress, focus on these patterns:

- Basic LIFO simulation
- Stack + HashMap (validation problems)
- Stack for reversal
- Monotonic Increasing Stack
- Monotonic Decreasing Stack
- Stack-based parsing

Mastering these patterns unlocks **dozens of problems** across platforms.

---

## Goal of This Section

This stack section is not just about implementation.
It is about learning **how to think in LIFO** and recognizing
when a stack is the **right mental model** for the problem.

> If a problem involves **nesting, history, or reversal** — think **Stack** first.


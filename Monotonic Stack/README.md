# Monotonic Stack — Core Concepts & Problem-Solving Reference

A **Monotonic Stack** is a specialized stack pattern where elements are maintained in **sorted order** (either increasing or decreasing) while processing data.

Unlike a regular stack that only follows **LIFO behavior**, a monotonic stack enforces an additional rule:

> The stack must remain **monotonic** — meaning elements are always kept in **increasing or decreasing order**.

This constraint allows us to efficiently solve problems involving **next greater/smaller elements**, which would otherwise require expensive nested loops.

---

## Purpose of a Monotonic Stack

Monotonic stacks are designed to efficiently track **nearest greater or smaller elements** during a single pass through an array.

They are ideal when:

* You need to find the **next greater element**
* You need to find the **previous smaller element**
* You must compare elements with their **nearest neighbors**
* You want to reduce **O(n²)** brute-force comparisons to **O(n)**

Instead of repeatedly scanning the array, a monotonic stack **filters out elements that are no longer useful**.

---

## Why Monotonic Stacks Are Powerful

Monotonic stacks are powerful because they:

* Maintain **ordered structure automatically**
* Eliminate unnecessary comparisons
* Enable **single-pass solutions**
* Transform brute-force **O(n²)** problems into **O(n)**
* Provide efficient access to **relevant previous elements**

Many well-known interview problems rely on this pattern.

---

## How a Monotonic Stack Works

When processing each element:

1. Compare the current element with the **top of the stack**
2. If the monotonic order is violated:

   * **Pop elements** from the stack
3. Once order is restored:

   * **Push the current element**

Example pattern:

```swift
while !stack.isEmpty && stack.last! < current {
    stack.popLast()
}

stack.append(current)
```

This ensures the stack always maintains the desired order.

---

## Types of Monotonic Stacks

There are two main types:

### Monotonic Increasing Stack

The stack maintains elements in **increasing order**.

Used when searching for:

* **Next smaller element**
* **Previous smaller element**

Example stack state:

```
[1, 3, 5, 8]
```

---

### Monotonic Decreasing Stack

The stack maintains elements in **decreasing order**.

Used when searching for:

* **Next greater element**
* **Previous greater element**

Example stack state:

```
[9, 7, 5, 2]
```

---

## Common Use Cases

Monotonic stacks frequently appear in algorithmic problems such as:

* Next Greater Element
* Next Smaller Element
* Daily Temperatures
* Stock Span Problem
* Largest Rectangle in Histogram
* Trapping Rain Water
* Remove K Digits

These problems all rely on efficiently identifying **nearest greater or smaller values**.

---

## What Monotonic Stacks Unlock in DSA

Using monotonic stacks allows you to:

* Convert **nested loops** into **linear scans**
* Track **useful previous elements**
* Eliminate unnecessary comparisons
* Solve **range and neighbor problems efficiently**
* Build powerful **O(n)** solutions

Once recognized, the monotonic stack pattern becomes a **go-to technique** for array processing problems.

---

## Important Notes & Pitfalls

* Always maintain the **monotonic order**
* Use a **while loop** to pop invalid elements
* Be careful with **equal values** depending on the problem
* The stack usually stores **indices**, not just values
* Forgetting to pop elements correctly leads to **incorrect results**

Understanding when to **pop vs push** is the key to mastering this pattern.

---

## Monotonic Stack Patterns to Master

Focus on these variations:

* Next Greater Element
* Next Smaller Element
* Previous Greater Element
* Previous Smaller Element
* Stock Span
* Largest Rectangle in Histogram

These patterns cover the majority of monotonic stack problems.

---

## Goal of This Section

This section focuses on developing the ability to **recognize monotonic stack patterns** and apply them confidently.

Once mastered, these patterns allow you to transform complex problems into **clean linear-time solutions**.

> If a problem involves **nearest greater/smaller elements or range comparisons** — think **Monotonic Stack**.


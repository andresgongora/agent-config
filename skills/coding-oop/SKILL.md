---
name: coding-oop
description: "Object-oriented design conventions. Load when writing, editing, or reviewing inheritance, class hierarchies, interfaces, or composition in object-oriented code. Use alongside cross-language coding conventions. Not for language syntax, framework-specific APIs, or general module design without object-oriented structure."
---

# coding-oop

## Core rules

- Prefer composition over inheritance. Use inheritance only for a true IS-A relationship with a shallow hierarchy.
- Prefer interfaces over class hierarchies when behavior must vary. Interface contracts decouple callers from implementations.

## Boundaries

- Keep language-specific mechanisms and framework APIs in owning language or framework guidance.
- Do not migrate an existing hierarchy without user scope.

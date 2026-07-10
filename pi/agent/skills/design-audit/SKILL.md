---
name: design-audit
description: >-
  Use when auditing UI/styling consistency, reviewing design system compliance,
  finding extractable components, or unifying visual patterns across templates.
  Triggers: "audit the design", "styling inconsistencies", "visual audit",
  "component extraction", "design system compliance", "unify the UI",
  "form consistency", "button patterns". Works with any CSS framework
  (Tailwind, daisyUI, Bootstrap, etc.) and any template system (HEEx, JSX,
  Svelte, Blade, ERB). Do NOT use for pure logic/backend audits.
  
disable-model-invocation: true
---

# Design Audit

Active for the entire audit. Off only: "stop design-audit" / "normal mode".

## Before You Start

Load in this order — form no opinions until step 4 is complete:

1. CSS/theme entry point (app.css, tailwind config, theme tokens)
2. Component library (core_components, ui/, design-system/)
3. Layout files
4. Every page/view template

If >30 templates, sample 2–3 per route group first. Load more only when the sample flags divergence.

## Report Sections

Produce a single report with these sections, in order:

### 1. Broken / Invalid Classes

Classes that don't exist, were removed in an upgrade, or are typos.

| File:line | Class | Fix |
|-----------|-------|-----|

### 2. Semantic Token Violations

Skip if project has no semantic token layer (raw Tailwind-only, no theme).

Hardcoded values bypassing the token layer (`text-gray-500`, `bg-white`, `#fff`, `rgb(...)`) where semantic alternatives exist (`text-base-content/50`, `bg-base-100`).

| File | Raw value | Semantic replacement |
|------|-----------|---------------------|

### 3. Pattern Divergence

Same visual intent, N different implementations. Group by intent:

**[Intent name] (N occurrences)**
| Pattern | Where |
|---------|-------|

### 4. Extractable Components

Repeated markup (3+ occurrences) → named component. For each:
- Name, repeated structure, occurrence count + files, proposed attrs

### 5. Proposed Fixes (ranked)

Rank by: `(occurrences_fixed × visual_impact) / diff_size`

Per fix: what to do (1 line), files affected, diff size (S/M/L).

## Decision Rules

- **Framework tokens > raw values.** Always.
- **Component > repeated markup.** 3+ = extract. 2 = note only.
- **One pattern per intent.** Pick closest to framework idiom, migrate the rest.
- **Smallest diff wins.**
- **Framework-native > custom.** Don't hand-roll what the framework ships.

## NOT a Finding

- Intentional `class` overrides (component API designed for it)
- One-off styling for genuinely unique UI (hero, landing)
- Framework utilities used as intended
- Accessibility markup (aria-*, role, sr-only)

## Output

Report first. Then: "Want me to implement these? I'd start with #N (reason)."

Commit per logical fix unit. Never batch all fixes into one commit.

## Anti-Patterns

- ❌ Hedging ("consider maybe possibly...")
- ❌ Flagging working, consistent code
- ❌ Proposing abstractions that aren't repeated (YAGNI)
- ❌ Redesigning the design system instead of enforcing it
- ❌ Mixing logic/behavior concerns into a visual audit

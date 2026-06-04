# Agent Icon Status Animation Design

## Goal

Add state-specific animation around live agent icons so users can identify running and attention states from the icon itself.

## Scope

Apply the animated decoration only where an icon represents a live agent session:

- Tab bar agent icon.
- Left sidebar workspace agent icon.
- Right agent overview panel icon.

Do not apply the decoration to static agent icons in settings, menus, Quick Open, inbox history, or launcher rows.

## States

- `running`: show a 2px blue line segment moving around a rounded rectangle that hugs the icon edge. The icon itself remains still.
- `attention`: show a 2px amber dashed rounded rectangle that fades in and out in a loop.
- `failed`: show a 2px red dashed rounded rectangle that fades in and out in a loop.
- `idle` and missing state: show no new edge decoration. Existing command-failure red dots and state labels remain unchanged.

## Component Design

Add a small wrapper view, tentatively `AgentStatusIconView`, that composes the existing `AgentIconView` and overlays the animated status decoration when needed.

Keep `AgentIconView` unchanged for static usage. This preserves its current role as the plain icon renderer and keeps animated state semantics explicit at call sites.

## Visual Rules

- Stroke width is 2px.
- The animated shape is a rounded rectangle, not a circle.
- The shape sits close to the icon edge without moving or scaling the icon.
- Running animation uses a moving stroke segment along the rounded rectangle path, not rotation of the whole icon or frame.
- Attention and failed animations use the same dashed fade behavior with different colors.

## Testing

Add focused tests for the status-decoration presentation mapping:

- `running` maps to running decoration.
- `attention` maps to attention decoration.
- `failed` maps to failed decoration.
- `idle` and no state map to no decoration.

Run the relevant KookyKit test target after implementation.

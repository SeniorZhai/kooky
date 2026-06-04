# Agent Icon Status Animation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add 2px status animations around live agent icons for running, attention, and failed states.

**Architecture:** Keep `AgentIconView` as the plain static icon renderer. Add `AgentStatusIconView` as a wrapper with a small presentation enum that maps live session state to an optional decoration. Use that wrapper only in tab bar, left workspace sidebar, and right agent overview panel call sites.

**Tech Stack:** Swift, SwiftUI, XCTest, existing `Theme` and `SessionActivityState` models.

---

### Task 1: Status Presentation Mapping

**Files:**
- Create: `Tests/KookyKitTests/AgentStatusIconViewTests.swift`
- Modify: `Sources/KookyKit/Sessions/AgentIconView.swift`

- [ ] **Step 1: Write the failing test**

```swift
import XCTest
@testable import KookyKit

final class AgentStatusIconViewTests: XCTestCase {
    func testDecorationMapsRunningToRunningRing() {
        XCTAssertEqual(AgentStatusDecoration(activity: .running, hasFailure: false), .running)
    }

    func testDecorationMapsAttentionBeforeFailure() {
        XCTAssertEqual(AgentStatusDecoration(activity: .attention, hasFailure: true), .attention)
    }

    func testDecorationMapsFailureToFailedRing() {
        XCTAssertEqual(AgentStatusDecoration(activity: .idle, hasFailure: true), .failed)
    }

    func testDecorationMapsIdleAndNilToNoRing() {
        XCTAssertNil(AgentStatusDecoration(activity: .idle, hasFailure: false))
        XCTAssertNil(AgentStatusDecoration(activity: nil, hasFailure: false))
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `./gradlew` is not relevant here. Use SwiftPM:

```bash
swift test --filter AgentStatusIconViewTests
```

Expected: compile failure because `AgentStatusDecoration` does not exist.

- [ ] **Step 3: Add minimal mapping implementation**

Add this to `Sources/KookyKit/Sessions/AgentIconView.swift` above `AgentIconView`:

```swift
enum AgentStatusDecoration: Equatable {
    case running
    case attention
    case failed

    init?(activity: SessionActivityState?, hasFailure: Bool) {
        if activity == .attention {
            self = .attention
        } else if hasFailure {
            self = .failed
        } else if activity == .running {
            self = .running
        } else {
            return nil
        }
    }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run:

```bash
swift test --filter AgentStatusIconViewTests
```

Expected: pass.

### Task 2: Animated Wrapper View

**Files:**
- Modify: `Sources/KookyKit/Sessions/AgentIconView.swift`

- [ ] **Step 1: Add `AgentStatusIconView`**

Add a SwiftUI wrapper that renders `AgentIconView` and overlays one of:

- running: `RoundedRectangle` stroke with trim animation and `Theme.activityRunning`.
- attention: dashed `RoundedRectangle` stroke with opacity animation and `Theme.activityAttention`.
- failed: dashed `RoundedRectangle` stroke with opacity animation and `Theme.activityFailure`.

Use 2px line width and keep the icon frame fixed.

- [ ] **Step 2: Build**

Run:

```bash
swift test --filter AgentStatusIconViewTests
```

Expected: pass with no compile errors.

### Task 3: Wire Live Icon Call Sites

**Files:**
- Modify: `Sources/KookyKit/Sessions/TabBarItem.swift`
- Modify: `Sources/KookyKit/Sidebar/SidebarWorkspaceRow.swift`
- Modify: `Sources/KookyKit/App/AgentMonitor.swift`

- [ ] **Step 1: Replace live icon renders**

Use `AgentStatusIconView` in:

- `TabBarItem`: pass `activity: tab.activityState`, `hasFailure: tab.lastCommandExit != 0`.
- `SidebarWorkspaceRow`: pass aggregated `readout.state` and `readout.hasCommandFailure`.
- `AgentOverviewRow` and `AgentOverviewCompactRow`: pass decoration derived from `entry.state`.

Do not change static `AgentIconView` call sites in settings, menus, Quick Open, inbox, or launcher rows.

- [ ] **Step 2: Run focused tests**

Run:

```bash
swift test --filter AgentStatusIconViewTests
```

Expected: pass.

### Task 4: Full Verification

**Files:**
- Existing test suite only.

- [ ] **Step 1: Run KookyKit tests**

Run:

```bash
swift test
```

Expected: pass.

- [ ] **Step 2: Inspect git status**

Run:

```bash
git status --short
```

Expected: only implementation files, tests, and the approved docs are changed. `.superpowers/` preview files remain untracked or ignored.

import XCTest
@testable import KookyKit

final class AgentStatusIconViewTests: XCTestCase {
    func testDecorationDoesNotSpinForActivityRunningAlone() {
        XCTAssertNil(AgentStatusDecoration(activity: .running, isShowingProgress: false))
    }

    func testDecorationSpinsForVisibleProgressEvenWhenActivityIsIdle() {
        XCTAssertEqual(AgentStatusDecoration(activity: .running, isShowingProgress: true), .running)
        XCTAssertEqual(AgentStatusDecoration(activity: .idle, isShowingProgress: true), .running)
    }

    func testDecorationMapsAttentionBeforeFailure() {
        XCTAssertEqual(AgentStatusDecoration(activity: .attention, isShowingProgress: true), .attention)
    }

    func testDecorationDoesNotUseDashedRingForFailure() {
        XCTAssertNil(AgentStatusDecoration(activity: .idle, isShowingProgress: false))
    }

    func testDecorationMapsIdleAndNilToNoRing() {
        XCTAssertNil(AgentStatusDecoration(activity: .idle, isShowingProgress: false))
        XCTAssertNil(AgentStatusDecoration(activity: nil, isShowingProgress: false))
    }

}

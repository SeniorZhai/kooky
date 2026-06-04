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

    func testDecorationMapsAgentMonitorStates() {
        XCTAssertEqual(AgentStatusDecoration(AgentMonitor.State.running), .running)
        XCTAssertEqual(AgentStatusDecoration(AgentMonitor.State.attention), .attention)
        XCTAssertEqual(AgentStatusDecoration(AgentMonitor.State.failed), .failed)
        XCTAssertNil(AgentStatusDecoration(AgentMonitor.State.idle))
    }
}

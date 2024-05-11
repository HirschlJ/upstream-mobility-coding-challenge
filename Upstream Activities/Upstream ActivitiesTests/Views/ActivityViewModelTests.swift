//
//  ActivityViewModelTests.swift
//  Upstream ActivitiesTests
//
//  Created by Jakob Hirschl on 11.05.24.
//

import XCTest
import Factory
import Mockingbird
@testable import Upstream_Activities

final class ActivityViewModelTests: XCTestCase {

    private var activityAPI = mock(ActivityAPI.self)

    private let activity = Activity(
        activity: "A very exiting activity",
        type: .diy,
        participants: 4,
        price: 0.2,
        accessibility: 0.5
    )

    private var viewModel: ActivityViewModelImpl!

    override func setUp() async throws {
        Container.shared.activityApi.register { self.activityAPI }
        given(await activityAPI.getActivity(activityType: any())).willReturn(activity)

        viewModel = ActivityViewModelImpl()
    }

    override func tearDownWithError() throws {
        Container.shared.reset()
    }

    private func awaitFetchActivity() {
        let expectation = expectation(description: "fetchActivitySuccessOrError")
        @Sendable func observeActivityViewState() {
            withObservationTracking {
                switch viewModel.activityViewState {
                case .loading: break // Not ready yet
                case .error:
                    expectation.fulfill()
                case .success:
                    expectation.fulfill()
                }
            } onChange: {
                DispatchQueue.main.async(execute: observeActivityViewState)
            }
        }
        observeActivityViewState()
        wait(for: [expectation], timeout: 1)
    }

    private func setUpActivityAPIGetActivityWithError(error: Error) async {
        given(await activityAPI.getActivity(activityType: any())).will { _ in throw error }
    }

    func testFetchNewActivity_CheckGetActivityCalled() async {
        viewModel.fetchNewActivity(activityType: .diy)
        awaitFetchActivity()
        verify(await activityAPI.getActivity(activityType: .diy)).wasCalled(1)
    }

    func testFetchNewActivity_Success_CheckActivityViewState() {
        viewModel.fetchNewActivity(activityType: .diy)
        XCTAssertEqual(.loading, viewModel.activityViewState)
        awaitFetchActivity()
        XCTAssertEqual(.success, viewModel.activityViewState)
    }

    func testFetchNewActivity_Success_CheckActivity() {
        viewModel.fetchNewActivity(activityType: .diy)
        awaitFetchActivity()
        XCTAssertEqual(activity, viewModel.activity)
    }

    func testFetchNewActivity_Success_CheckShowAlert() {
        viewModel.fetchNewActivity(activityType: .diy)
        awaitFetchActivity()
        XCTAssertFalse(viewModel.showAlert)
    }

    func testFetchNewActivity_Error_CheckActivityViewState() async {
        let expectedError = APIError.serverError(404, "Not found")
        await setUpActivityAPIGetActivityWithError(error: expectedError)
        viewModel.fetchNewActivity(activityType: .diy)
        awaitFetchActivity()
        XCTAssertEqual(.error(expectedError.toEquatableError()), viewModel.activityViewState)
    }

    func testFetchNewActivity_Error_CheckActivity() async {
        let expectedError = APIError.serverError(404, "Not found")
        await setUpActivityAPIGetActivityWithError(error: expectedError)
        viewModel.fetchNewActivity(activityType: .diy)
        awaitFetchActivity()
        XCTAssertNil(viewModel.activity)
    }

    func testFetchNewActivity_Error_CheckShowAlert() async {
        let expectedError = APIError.serverError(404, "Not found")
        await setUpActivityAPIGetActivityWithError(error: expectedError)
        viewModel.fetchNewActivity(activityType: .diy)
        awaitFetchActivity()
        XCTAssert(viewModel.showAlert)
    }
}

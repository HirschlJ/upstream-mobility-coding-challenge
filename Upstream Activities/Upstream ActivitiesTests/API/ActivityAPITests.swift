//
//  ActivityAPITests.swift
//  Upstream ActivitiesTests
//
//  Created by Jakob Hirschl on 11.05.24.
//

import XCTest
import Factory
import Mockingbird
@testable import Upstream_Activities

final class ActivityAPITests: XCTestCase {

    private var urlSession = mock(URLSessionAPI.self)

    private let expectedURL = URL(string: "https://www.boredapi.com/api/activity")!
    private var expectedURLWithQuery: URL {
        expectedURL.appending(queryItems: [URLQueryItem(name: "type", value: activity.type.rawValue)])
    }
    private let activity = Activity(
        activity: "A very exiting activity",
        type: .diy,
        participants: 4,
        price: 0.2,
        accessibility: 0.5
    )

    private var api: ActivityAPIImpl!

    override func setUp() async throws {
        Container.shared.urlSession.register { self.urlSession }

        given(await urlSession.data(for: any()))
            .willReturn((try getDataResponse(for: activity), getResponse(with: 200)))

        api = ActivityAPIImpl()
    }

    override func tearDownWithError() throws {
        Container.shared.reset()
        reset(urlSession)
    }

    private func getResponse(with statusCode: Int) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: expectedURL,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }

    private func getDataResponse(for activity: Activity) throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try encoder.encode(activity)
    }

    func testGetActivity_CheckReturnValue() async throws {
        let returnedActivity = try await api.getActivity(activityType: activity.type)
        XCTAssertEqual(activity, returnedActivity)
    }

    func testGetActivity_WithoutActivityType_CheckRequestURL() async throws {
        _ = try await api.getActivity(activityType: nil)
        verify(await urlSession.data(for: any(where: { $0.url == self.expectedURL }))).wasCalled()
    }

    func testGetActivity_WithActivityType_CheckRequestURL() async throws {
        _ = try await api.getActivity(activityType: activity.type)
        verify(await urlSession.data(for: any(where: { $0.url == self.expectedURLWithQuery }))).wasCalled()
    }

    func testGetActivity_CheckRequestMethod() async throws {
        _ = try await api.getActivity(activityType: activity.type)
        verify(await urlSession.data(for: any(where: { $0.httpMethod == "GET" }))).wasCalled()
    }

    func testGetActivity_RequestFails_CheckTransportErrorThrown() async {
        given(await urlSession.data(for: any())).will { _ in throw TestError() }
        await XCTAssertThrowsErrorAsync(try await api.getActivity(activityType: activity.type)) { error in
            XCTAssertEqual(
                APIError.transportError(TestError()).toEquatableError(),
                error.toEquatableError()
            )
        }
    }

    func testGetActivity_ServerError_CheckTransportErrorThrown() async {
        let errorCode = 404
        let errorMessage = "Not found"
        given(await urlSession.data(for: any()))
            .willReturn((errorMessage.data(using: .utf8)!, getResponse(with: errorCode)))
        await XCTAssertThrowsErrorAsync(try await api.getActivity(activityType: activity.type)) { error in
            XCTAssertEqual(
                APIError.serverError(errorCode, errorMessage).toEquatableError(),
                error.toEquatableError()
            )
        }
    }

    func testGetActivity_InvalidResponse_CheckParsingErrorThrown() async {
        given(await urlSession.data(for: any()))
            .willReturn(("Invalid data".data(using: .utf8)!, getResponse(with: 200)))
        await XCTAssertThrowsErrorAsync(try await api.getActivity(activityType: activity.type)) { error in
            if case APIError.parsingError = error {
                // passed
            } else {
                XCTFail("Expected APIError.parsingError but was \(error)")
            }
        }
    }
}

private struct TestError: Error {}

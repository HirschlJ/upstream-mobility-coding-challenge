//
//  XCTAssertThrowsErrorAsync.swift
//  Upstream ActivitiesTests
//
//  Created by Jakob Hirschl on 11.05.24.
//

import XCTest

public func XCTAssertThrowsErrorAsync<T>(
_ expression: @autoclosure () async throws -> T,
_ message: @autoclosure () -> String = "",
file: StaticString = #filePath,
line: UInt = #line,
_ errorHandler: (_ error: Error) -> Void = { _ in }
) async {
    do {
        _ = try await expression()
        var failureMessage = message()
        if failureMessage.isEmpty {
            failureMessage = "Function did not throw an exception!"
        }
        XCTFail(failureMessage, file: file, line: line)
    } catch {
        errorHandler(error)
    }
}

//
//  LargeNumberFormatterTests.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import XCTest
@testable import TakeHomeTest

final class LargeNumberFormatterTests: XCTestCase {
    let formatter = Formatter.largeNumber

    // MARK: - Trillion Tests

    func testTrillionFormatting() {
        let number = 1_234_567_890_123.0
        XCTAssertEqual(formatter.string(from: number), "1.2T")

        let exactTrillion = 1_000_000_000_000.0
        XCTAssertEqual(formatter.string(from: exactTrillion), "1T")

        let multiTrillion = 5_400_000_000_000.0
        XCTAssertEqual(formatter.string(from: multiTrillion), "5.4T")
    }

    // MARK: - Billion Tests

    func testBillionFormatting() {
        let number = 1_234_567_890.0
        XCTAssertEqual(formatter.string(from: number), "1.2B")

        let exactBillion = 1_000_000_000.0
        XCTAssertEqual(formatter.string(from: exactBillion), "1B")

        let multiBillion = 5_400_000_000.0
        XCTAssertEqual(formatter.string(from: multiBillion), "5.4B")
    }

    // MARK: - Million Tests

    func testMillionFormatting() {
        let number = 1_234_567.0
        XCTAssertEqual(formatter.string(from: number), "1.2M")

        let exactMillion = 1_000_000.0
        XCTAssertEqual(formatter.string(from: exactMillion), "1M")

        let multiMillion = 5_400_000.0
        XCTAssertEqual(formatter.string(from: multiMillion), "5.4M")
    }

    // MARK: - Regular Number Tests

    func testRegularNumberFormatting() {
        let number = 123_456.0
        XCTAssertEqual(formatter.string(from: number), "123.456")

        let smallNumber = 1_234.0
        XCTAssertEqual(formatter.string(from: smallNumber), "1.234")

        let tinyNumber = 123.0
        XCTAssertEqual(formatter.string(from: tinyNumber), "123")
    }

    // MARK: - Edge Cases

    func testEdgeCases() {
        // Zero
        XCTAssertEqual(formatter.string(from: 0), "0")

        // Negative numbers
        XCTAssertEqual(formatter.string(from: -1_234_567.0), "-1.2M")
        XCTAssertEqual(formatter.string(from: -1_234_567_890.0), "-1.2B")
        XCTAssertEqual(formatter.string(from: -1_234_567_890_123.0), "-1.2T")

        // Numbers just below thresholds
        XCTAssertEqual(formatter.string(from: 999_999.0), "999.999")
        XCTAssertEqual(formatter.string(from: 999_999_999.0), "1B")
        XCTAssertEqual(formatter.string(from: 999_999_999_999.0), "1T")
    }

    // MARK: - Separator Tests

    func testSeparators() {
        // Test that we're using dots, not commas
        let number = 123_456_789.0
        XCTAssertEqual(formatter.string(from: number), "123.5M")

        // Test negative numbers with separators
        let negativeNumber = -1_234_567.0
        XCTAssertEqual(formatter.string(from: negativeNumber), "-1.2M")
    }

    // MARK: - Rounding Tests

    func testRounding() {
        // Test rounding up
        XCTAssertEqual(formatter.string(from: 1_150_000.0), "1.2M")
        XCTAssertEqual(formatter.string(from: 1_150_000_000.0), "1.2B")
        XCTAssertEqual(formatter.string(from: 1_150_000_000_000.0), "1.2T")

        // Test rounding down
        XCTAssertEqual(formatter.string(from: 1_140_000.0), "1.1M")
        XCTAssertEqual(formatter.string(from: 1_140_000_000.0), "1.1B")
        XCTAssertEqual(formatter.string(from: 1_140_000_000_000.0), "1.1T")
    }

    func testFormatterReturnsNil_ShouldReturnDefaultValue() {
        // Given
        let formatter = LargeNumberFormatter(numberFormatter: FailingNumberFormatter())

        // When
        let result = formatter.string(from: 1_000_000_000_000) // A number that normally gets formatted as "1T"

        // Then
        XCTAssertEqual(result, "0.0", "When NumberFormatter fails, it should return '0.0'")
    }
}

#if DEBUG
// A mock NumberFormatter that always fails to format numbers.
// `@unchecked Sendable` is used here since this mock is only for testing purposes
// and does not require strict thread safety guarantees.
class FailingNumberFormatter: NumberFormatter, @unchecked Sendable {
    override func string(from number: NSNumber) -> String? {
        return nil
    }
}
#endif

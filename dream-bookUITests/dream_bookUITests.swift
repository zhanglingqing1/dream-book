//
//  dream_bookUITests.swift
//  dream-bookUITests
//
//  Created by 张凌青 on 2026/2/16.
//

import XCTest

final class dream_bookUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testDreamCardPageSheetPresentation() throws {
        let app = XCUIApplication()
        app.launch()

        openDreamCardTemplatePage(in: app)

        let firstRow = app.buttons["dream.list.row.0"]
        XCTAssertTrue(firstRow.waitForExistence(timeout: 2))
        firstRow.tap()

        let sheet = app.scrollViews["dream.detail.sheet"]
        XCTAssertTrue(sheet.waitForExistence(timeout: 2))

        let closeButton = app.buttons["dream.detail.close"]
        XCTAssertTrue(closeButton.waitForExistence(timeout: 2))
        XCTAssertTrue(closeButton.isHittable)
        XCTAssertFalse(firstRow.isHittable)

        closeButton.tap()
        assertElementDisappears(sheet, timeout: 4)
        XCTAssertTrue(firstRow.waitForExistence(timeout: 2))

        firstRow.tap()
        let reopenedSheet = app.scrollViews["dream.detail.sheet"]
        XCTAssertTrue(reopenedSheet.waitForExistence(timeout: 2))
        reopenedSheet.swipeDown()
        assertElementDisappears(reopenedSheet, timeout: 4)
        XCTAssertTrue(firstRow.waitForExistence(timeout: 2))
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    private func openDreamCardTemplatePage(in app: XCUIApplication) {
        let entry = app.buttons["dream.preview.templates.entry"]

        var attempts = 0
        while !entry.isHittable && attempts < 8 {
            app.swipeUp()
            attempts += 1
        }

        XCTAssertTrue(entry.waitForExistence(timeout: 2))
        entry.tap()
    }

    private func assertElementDisappears(_ element: XCUIElement, timeout: TimeInterval) {
        let predicate = NSPredicate(format: "exists == false")
        expectation(for: predicate, evaluatedWith: element)
        waitForExpectations(timeout: timeout)
    }
}

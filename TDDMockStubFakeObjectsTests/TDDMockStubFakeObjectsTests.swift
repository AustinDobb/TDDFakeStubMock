//
//  TDDMockStubFakeObjectsTests.swift
//  TDDMockStubFakeObjectsTests
//
//  Created by Austin Dobberfuhl on 1/31/24.
//

import XCTest
@testable import TDDMockStubFakeObjects

final class TDDMockStubFakeObjectsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
}

protocol ArcadeGameManager {
    func fetchAllGames(completed: (Data?) -> Void)
}

//Fake Object
class FakeGamesLibrary: ArcadeGameManager {
    func fetchAllGames(completed: (Data?) -> Void) {
        completed(nil)
    }
}

class StubGameLibrary: ArcadeGameManager {
    let data: Data
    
    func fetchAllGames(completed: (Data?) -> Void) {
        let data = Data()
        completed(data)
    }
    
    init(data: Data) {
        self.data = data
    }
}

class MockGameLibrary: ArcadeGameManager {
    var fetchAllGamesCalled = false
    
    func fetchAllGames(completed: (Data?) -> Void) {
        fetchAllGamesCalled = true
    }
    
    
}

class ArcadeGames {
    private let arcadeGameManager: ArcadeGameManager
    
    init(arcadeGameManager: ArcadeGameManager) {
        self.arcadeGameManager = arcadeGameManager
    }
    
    func doingWork(completed: (Data?) -> Void) {
        arcadeGameManager.fetchAllGames { data in
            completed(data)
        }
    }
    
    class ArcadeGamesTest: XCTestCase {
        
        func testFakeGameLibrary() {
            
            let fakeGameLibrary = FakeGamesLibrary()
            let arcadeGames = ArcadeGames(arcadeGameManager: fakeGameLibrary)
            var completionData: Data?
            
            arcadeGames.doingWork { data in
                completionData = data
            }
            
            XCTAssertNil(completionData)
            
        }
        
        func testStubGameLibrary() {
            let data = Data()
            let stubGameLibrary = StubGameLibrary(data: data)
            let arcadeGames = ArcadeGames(arcadeGameManager: stubGameLibrary)
            var completionData: Data?
            
            arcadeGames.doingWork { data in
                completionData = data
            }
            
            XCTAssertEqual(completionData, data)
            
        }
        
        func testMockGameLibrary() {
            let mockGameLibrary = MockGameLibrary()
            let arcadeGames = ArcadeGames(arcadeGameManager: mockGameLibrary)
            
            arcadeGames.doingWork { _ in }
            
            XCTAssertTrue(mockGameLibrary.fetchAllGamesCalled)
        }
        
    }
}

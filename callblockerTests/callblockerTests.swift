//
//  callblockerTests.swift
//  callblockerTests
//
//  Created by Ivo Valcic on 10/22/18.
//  Copyright © 2018 Ivo Valcic. All rights reserved.
//

import XCTest
@testable import callblocker

class callblockerTests: XCTestCase {
    
    let testNumber:Int64 = 11111111

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_init_coreDataStorage(){
        let instance = CoreDataStorage.sharedInstance
        XCTAssertNotNil( instance )
    }
    
    func test_create_blocked_phone_number() {
        let ctx = CoreDataStorage.mainQueueContext()
        let blockedNumber = PhoneNumber.createOrUpdate(number: testNumber, desc: nil, type: .blocked, ctx: ctx)
        XCTAssertNotNil( blockedNumber )
    }
    
    func test_create_suspicious_phone_number() {
        let ctx = CoreDataStorage.mainQueueContext()
        let blockedNumber = PhoneNumber.createOrUpdate(number: testNumber, desc: "some suspicious number", type: .suspicious, ctx: ctx)
        XCTAssertNotNil( blockedNumber )
    }
    
    func test_delete_phone_number() {
        let ctx = CoreDataStorage.mainQueueContext()
        let phoneNumbers = PhoneNumber.fetchAll(context: ctx)
        let numbersCount = phoneNumbers?.count
        let lastNumber = phoneNumbers!.last!
        PhoneNumber.deleteNumber(number: lastNumber.number, ctx: ctx)
        XCTAssertEqual(PhoneNumber.fetchAll(context: ctx)?.count, numbersCount!-1)
    }

}

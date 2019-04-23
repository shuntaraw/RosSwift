//
//  serviceTests.swift
//  rosswiftTests
//
//  Created by Thomas Gustafsson on 2018-10-24.
//

import XCTest
@testable import RosSwift
@testable import StdMsgs
@testable import BinaryCoder


class serviceTests: XCTestCase {

    static var allTests = [
        ("testCallService",testCallService),
        ("testCallEcho",testCallEcho),
        ("testCallInternalService",testCallInternalService),
        ("testServiceAdvCopy", testServiceAdvCopy),
        ("testServiceAdvMultiple",testServiceAdvMultiple),
        ("testCallSrvMultipleTimes",testCallSrvMultipleTimes)
    ]


    override func setUp() {
        print("##########  SETUP ##############")
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let _ = Ros.initialize(argv: &CommandLine.arguments, name: "serviceTests")

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Ros.shutdown()
        print("##########  SHUTDOWN ##############")

    }

    func srvCallback(req: TestStringString.Request) -> TestStringString.Response? {
        return TestStringString.Response("A")
    }

    func testCallService() {

        let node = Ros.NodeHandle()
        guard let serv = node.advertise(service: "/service_adv", srvFunc: srvCallback) else {
            XCTFail()
            return
        }

        var req = TestStringString.Request()
        var res = TestStringString.Response()
        req.data = "case_FLIP"

        XCTAssert(Service.waitForService(serviceName: "/service_adv"))
        if Service.call(serviceName: "/service_adv", req: req, response: &res) {
            print(res)
        }
        XCTAssert(Service.call(serviceName: "/service_adv", req: req, response: &res))
        XCTAssertEqual(res.data, "A")

        serv.shutdown()  // Just in case the ARC throws us away
    }

    func testCallEcho() {
        let _ = Ros.NodeHandle()

        var req = TestStringString.Request()
        var res = TestStringString.Response()
        req.data = "case_FLIP"

        if Service.waitForService(serviceName: "/echo", timeout: 10 )  {
            let message = Service.call(serviceName: "/echo", req: req, response: &res)
            XCTAssert(message)
            if message {
                XCTAssertEqual(res.data,req.data)
            }
        }
    }

    func serviceCallback(req : TestStringString.Request) -> TestStringString.Response? {
        return TestStringString.Response("test")
    }

    func testCallInternalService() {
        let n = Ros.NodeHandle()
        var t = TestStringString()

        let srv1 = n.advertise(service: "/test_srv", srvFunc: serviceCallback)
        XCTAssertNotNil(srv1)
        XCTAssert(Service.call(name: "/test_srv", service: &t))
        XCTAssertEqual(t.response.data, "test")


    }

    func testServiceAdvCopy()  {
        let n = Ros.NodeHandle()
        var t = TestStringString()

        do {
            let srv1 = n.advertise(service: "/test_srv_23", srvFunc: serviceCallback)
            sleep(4)
            XCTAssert(Service.call(name: "/test_srv_23", service: &t))
            do {
                let srv2 = srv1
                do {
                    let srv3 = srv2
                    XCTAssert(srv3 === srv2)
                    t.response.data = ""
                    XCTAssert(Service.call(name: "/test_srv_23", service: &t))
                    XCTAssertEqual(t.response.data, "test")
                }
                XCTAssert(srv2 === srv1);
                t.response.data = ""
                XCTAssert(Service.call(name: "/test_srv_23", service: &t))
                XCTAssertEqual(t.response.data, "test")
            }
            t.response.data = ""
            XCTAssert(Service.call(name: "/test_srv_23", service: &t))
            XCTAssertEqual(t.response.data, "test")
        }
        sleep(1)
        XCTAssertFalse(Service.call(name: "/test_srv_23", service: &t))

        print("\(n.isOK)")

    }






    func testServiceAdvMultiple()  {
        let n = Ros.NodeHandle()

        let srv = n.advertise(service: "/test_srv_19", srvFunc: serviceCallback)
        let srv2 = n.advertise(service: "/test_srv_19", srvFunc: serviceCallback)
        XCTAssert(srv != nil)
        XCTAssertNil(srv2)

    }



    func testCallSrvMultipleTimes() {

        let node = Ros.NodeHandle()
        let serv = node.advertise(service: "/service_adv2", srvFunc: srvCallback)
        XCTAssertNotNil(serv)
        var req = TestStringString.Request()
        var res = TestStringString.Response()
        req.data = "case_FLIP"

//        self.measure {
            for _ in 0..<10 {
                XCTAssert(Service.call(serviceName: "service_adv2", req: req, response: &res))
            }
//        }
    }



}

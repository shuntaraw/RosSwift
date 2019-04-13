//
//  connectionTests.swift
//  rosswiftTests
//
//  Created by Thomas Gustafsson on 2018-10-23.
//

import XCTest
@testable import RosSwift
@testable import StdMsgs
@testable import BinaryCoder
@testable import RosTime

class connectionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        _ = Ros.initialize(argv: &CommandLine.arguments, name: "connectionTests")

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    static var allTests = [
        ("testNodeHandleConstructionDestruction",testNodeHandleConstructionDestruction),
        ("testIntraprocess",testIntraprocess),
        ("testgetPublishedTopics",testgetPublishedTopics),
        ("testnodeHandleParentWithRemappings", testnodeHandleParentWithRemappings),
        ("testSubscriberDestructionMultipleCallbacks",testSubscriberDestructionMultipleCallbacks),
        ("testPublisherMultiple",testPublisherMultiple)
    ]


    func testNodeHandleConstructionDestruction() {
        do {
            XCTAssertFalse(Ros.isStarted)
            let _ = Ros.NodeHandle()
            XCTAssert(Ros.isStarted)
            do {
                let _ = Ros.NodeHandle()
                XCTAssert(Ros.isStarted)
                do {
                    let _ = Ros.NodeHandle()
                    XCTAssert(Ros.isStarted)
                    do {
                        let _ = Ros.NodeHandle()
                        XCTAssert(Ros.isStarted)
                    }
                }
            }
            XCTAssert(Ros.isStarted)
        }
        XCTAssertFalse(Ros.isStarted)
        sleep(1)
        do {
            let _ = Ros.NodeHandle()
            XCTAssert(Ros.isStarted)
        }
        sleep(1)
        XCTAssertFalse(Ros.isStarted)
    }


    func testIntraprocess() {
        var chatter : Float64 = 0.0
        let n = Ros.NodeHandle()
        guard let chatter_pub = n.advertise(topic: "/intrachatter", message: std_msgs.float64.self ) else {
            exit(1)
        }

        func chatterCallback(msg: std_msgs.float64) {
            print("I saw: [\(msg)]")
            chatter = msg.data
        }
        let vab = n.subscribe(topic: "/intrachatter", queueSize: 1, callback: chatterCallback)
        XCTAssertNotNil(vab)

        chatter_pub.publish(message: std_msgs.float64(10.0))
        usleep(100000)
        Ros.spinOnce()
        usleep(100000)

        XCTAssertEqual(chatter, 10.0)

    }

    func testgetPublishedTopics() {
        let n = Ros.NodeHandle()
        let advertised_topics = ["/test_topic_1","/test_topic_2","/test_topic_3","/test_topic_4","/test_topic_5","/test_topic_6","/test_topic_7","/test_topic_8"]

        var pubs = [Publisher]()
        for adv_it in advertised_topics {
            if let pub = n.advertise(topic: adv_it, message: std_msgs.float64.self) {
                pubs.append(pub)
            } else {
                XCTFail(adv_it)
            }
        }

        let topics = Master.shared.getTopics()

        for topic in advertised_topics {
            XCTAssert(topics!.contains { $0.name == topic })
        }
    }

    func testnodeHandleParentWithRemappings() {
        let remappings = ["a":"b", "c":"d"]
        let n1 = Ros.NodeHandle(ns: "", remappings: remappings)

        // Sanity checks

        XCTAssertEqual(n1.resolveName(name: "a"), "/b")
        XCTAssertEqual(n1.resolveName(name: "/a"), "/b")
        XCTAssertEqual(n1.resolveName(name: "c"), "/d")
        XCTAssertEqual(n1.resolveName(name: "/c"), "/d")

        let n2 = Ros.NodeHandle(parent: n1, ns: "my_ns")

        XCTAssertEqual(n2.resolveName(name: "a"), "/my_ns/a")
        XCTAssertEqual(n2.resolveName(name: "/a"), "/b")
        XCTAssertEqual(n2.resolveName(name: "c"), "/my_ns/c")
        XCTAssertEqual(n2.resolveName(name: "/c"), "/d")

        let n3 = Ros.NodeHandle(parent: n2)

        XCTAssertEqual(n3.resolveName(name: "a"), "/my_ns/a")
        XCTAssertEqual(n3.resolveName(name: "/a"), "/b")
        XCTAssertEqual(n3.resolveName(name: "c"), "/my_ns/c")
        XCTAssertEqual(n3.resolveName(name: "/c"), "/d")

    }

    var g_recv_count: Int32 = 0
    func subscriberCallback(_ f: std_msgs.float64) {
        g_recv_count = g_recv_count + 1
    }


    class SubscribeHelper {
        var recv_count_ : Int32 = 0

        func callback(_ f: std_msgs.float64) {
            recv_count_ = recv_count_ + 1
        }
    }


    func testSubscriberDestructionMultipleCallbacks() {
        let n = Ros.NodeHandle()
        guard let pub = n.advertise(topic: "test", message: std_msgs.float64.self) else {
            XCTFail()
            return
        }
        let msg = std_msgs.float64(3.14)
        do {
            let helper = SubscribeHelper()
            let sub_class = n.subscribe(topic: "test", queueSize: 0, callback: helper.callback)
            XCTAssertNotNil(sub_class)
            let d = RosTime.Duration(milliseconds: 50)
            var last_class_count = helper.recv_count_
            while last_class_count == helper.recv_count_ {
                pub.publish(message: msg)
                Ros.spinOnce()
                d.sleep()
            }

            var last_fn_count = g_recv_count
            do {
                let sub_fn = n.subscribe(topic: "test", queueSize: 0, callback: subscriberCallback)
                XCTAssertNotNil(sub_fn)
                last_fn_count = g_recv_count
                while last_fn_count == g_recv_count {
                    pub.publish(message: msg)
                    Ros.spinOnce()
                    d.sleep()
                }
            }

            last_fn_count = g_recv_count
            last_class_count = helper.recv_count_
            while last_class_count == helper.recv_count_ {
                pub.publish(message: msg)
                Ros.spinOnce()
                d.sleep()
            }

            XCTAssertEqual(last_fn_count, g_recv_count);
        }
    }

    func testPublisherMultiple() {
        let n = Ros.NodeHandle()

        do {
            let pub1 = n.advertise(topic: "/test", message: std_msgs.float64.self)

            do {
                let pub2 = n.advertise(topic: "/test", message: std_msgs.float64.self)

                let topics1 = Ros.ThisNode.getAdvertisedTopics()
                let t1 = topics1.first(where: { $0 == "/test" })
                XCTAssertNotNil(t1)
            }

            let topics2 = Ros.ThisNode.getAdvertisedTopics()
            let t2 = topics2.first(where: { $0 == "/test" })
            XCTAssertNotNil(t2)
       }
        print("leaving scope")
        let topics3 = Ros.ThisNode.getAdvertisedTopics()
        let t3 = topics3.first(where: { $0 == "/test" })
        XCTAssertNil(t3)
    }


}

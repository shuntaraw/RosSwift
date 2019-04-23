import Foundation
import RosSwift
import geometry_msgs
import StdMsgs

class A {
    let value : Int
    func chatterCallback(msg: String) {
        print("I [the class \(value)] saw: [\(msg)]")
    }
    init(value: Int) {
        self.value = value
    }
}

struct B {
    let value : Double
    func chatterCallback(msg: String) {
        print("I [the struct \(value)] saw: [\(msg)]")
    }
}

func natterCallback(msg: geometry_msgs.Accel) {
    print("I heard: [\(msg)]")
}

func chatterCallback(msg: String) {
    print("I saw: [\(msg)]")
}

func chatterCallbackEvent(event: MessageEvent<String>) {
    let msg = event.message
    print("I got [\(msg) from \(event.connectionHeader["callerid"] ?? "<no caller id>")")
}

let future = Ros.initialize(argv: &CommandLine.arguments, name: "listener")


guard let n = Ros.NodeHandle(ns: "~") else {
    exit(1)
}

let request = TestStringString.Request("request from listener")
if let respons : TestStringString.Response = try? Service.call(serviceName: "echo", req: request).wait() {
    print(respons)
} else {
    print("call returned nil")
}

let a = A(value: 345)
let b = B(value: 99.345)

let sub = n.subscribe(topic: "/accel", queueSize: 1, callback: natterCallback)
let vab = n.subscribe(topic: "/chatter", queueSize: 1, callback: chatterCallback)
let aab = n.subscribe(topic: "/chatter", queueSize: 1, callback: a.chatterCallback)
let bab = n.subscribe(topic: "/chatter", queueSize: 1, callback: b.chatterCallback)
let cab = n.subscribe(topic: "/chatter", queueSize: 1, callback: chatterCallbackEvent)

n.spinThread()

do {
    try future.wait()
} catch {
    print(error.localizedDescription)
}




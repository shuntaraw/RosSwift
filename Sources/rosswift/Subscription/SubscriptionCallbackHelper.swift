//
//  SubscriptionCallbackHelper.swift
//  RosSwift
//
//  Created by Thomas Gustafsson on 2018-03-06.
//

import BinaryCoder
import StdMsgs
import RosTime

public protocol SubscriptionCallbackHelper {
    var id: ObjectIdentifier { get }
    func deserialize(data: [UInt8]) -> Message?
    func call(msg: Message)
    var hasHeader: Bool { get }
}

public final class SubscriptionCallbackHelperT<M: Message>: SubscriptionCallbackHelper {

    typealias Callback = (M) -> Void

    let callback: Callback

    public var id: ObjectIdentifier {
        return ObjectIdentifier(self)
    }

    init(callback: @escaping Callback ) {
        self.callback = callback

    }

    public func deserialize(data: [UInt8]) -> Message? {
        return try? BinaryDecoder.decode(M.self, data: data)
    }

    public func call(msg: Message) {
        if let message = msg as? M {
            callback(message)
        }
    }

    public let hasHeader = M.hasHeader

}


public final class SubscriptionEventCallbackHelperT<M: Message>: SubscriptionCallbackHelper {

    typealias Callback = (MessageEvent<M>) -> Void

    let callback: Callback

    public var id: ObjectIdentifier {
        return ObjectIdentifier(self)
    }

    init(callback: @escaping Callback ) {
        self.callback = callback
    }

    public func deserialize(data: [UInt8]) -> Message? {
        return try? BinaryDecoder.decode(M.self, data: data)
    }

    public func call(msg: Message) {
        if let message = msg as? M {
            let event = MessageEvent(message: message, header: ["callerid":"unknown"], receiptTime: RosTime.Time())
            callback(event)
        }
    }

    public let hasHeader = M.hasHeader

}



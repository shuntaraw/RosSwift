//
//  ServiceServer.swift
//  RosSwift
//
//  Created by Thomas Gustafsson on 2018-10-24.
//

import Foundation
import NIOConcurrencyHelpers

public final class ServiceServer {
    public let service: String
    unowned var node: NodeHandle
    var isUnadvertised = NIOAtomic.makeAtomic(value: false)

    internal init(service: String, node: NodeHandle) {
        self.service = service
        self.node = node
    }

    deinit {
        unadvertise()
    }

    func unadvertise() {
        if isUnadvertised.compareAndExchange(expected: false, desired: true) {
            _ = node.ros.serviceManager.unadvertiseService(name: service)
        }
    }

    func isValid() -> Bool {
        return !isUnadvertised.load()
    }


    func shutdown() {
        unadvertise()
    }

}

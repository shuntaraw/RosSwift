//
//  XmlRpcServer.swift
//  swiftros
//
//  Created by Thomas Gustafsson on 2018-03-22.
//

import Foundation
import NIO
import _NIO1APIShims

extension SocketAddress {
    var host: String {
        switch self {
        case .v4(let addr):
            return addr.host
        case .v6(let addr):
            return addr.host
        case .unixDomainSocket:
            return ""
        }
    }
}

final class MessageHandler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    typealias OutboundOut = ByteBuffer
    weak var server: XMLRPCServer!

    func generateResponse(resultXML: String) -> String {
        let res = "<?xml version=\"1.0\"?>\r\n<methodResponse><params><param>"
        let req = "</param></params></methodResponse>\r\n"
        let body = res + resultXML + req
        let header = generateHeader(body: body)
        let response = header + body
        ROS_DEBUG("generateResponse: -----\n\(response)\n-----\n")
        return response
    }

    func generateHeader(body: String) -> String {
        let header = "HTTP/1.1 200 OK\r\nServer: "
            + xmlrpcVersion
            + "\r\n"
            + "Content-Type: text/xml\r\n"
            + "Content-length: "
            + "\(body.lengthOfBytes(using: .utf8))\r\n\r\n"
        return header
    }

    func channelActive(context: ChannelHandlerContext) {
        ROS_DEBUG("xmlrpcserver channelActive \(String(describing: context.remoteAddress))")
    }

    func channelInactive(context: ChannelHandlerContext) {
        ROS_DEBUG("xmlrpcserver channelInactive \(String(describing: context.remoteAddress))")

    }

    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var reqPart = self.unwrapInboundIn(data)
        guard let str = reqPart.readString(length: reqPart.readableBytes) else {
            return
        }

        guard let range = str.lowercased().range(of: "content-length: ")  else {
            fatalError("Header not read")
        }

        let content = String(str[range.upperBound..<str.endIndex])
        guard let index = content.firstIndex(of: "\r\n") else {
            fatalError()
        }
        guard let _ = Int(content[content.startIndex..<index]) else {
            fatalError("length error")
        }
        guard let ind2 = content.firstIndex(of: "<") else {
            fatalError()
        }

        let request = String(content[ind2..<content.endIndex])
        if str.contains("HTTP/1.0") {
            fatalError()
        }

        let obj = XMLRPCManager.parseRequest(xml: request)
        let methodName = obj.method
        let params = XmlRpcValue(anyArray: obj.params)

        let response = self.executeMethod(methodName: methodName, params: params)
        let xml = response.toXml()
        let responseXML = self.generateResponse(resultXML: xml)
        var outbuffer = context.channel.allocator.buffer(capacity: responseXML.utf8.count)
        let written = outbuffer.writeString(responseXML)
        assert(written == responseXML.utf8.count)

        context.writeAndFlush(self.wrapOutboundOut(outbuffer)).whenFailure { error in
            ROS_ERROR("write failed to \(String(describing: context.remoteAddress))\nerror: \(error))")
        }
    }

    func executeMethod(methodName: String, params: XmlRpcValue) -> XmlRpcValue {
        if let method = server.findMethod(name: methodName) {
            do {
                return try method.execute(params: params)
            } catch {
                ROS_ERROR(error.localizedDescription)
            }
        }
        return XmlRpcValue(str: "")
    }

}

final class XMLRPCServer {
    let handler: MessageHandler
    var channel: Channel?
    var boot: ServerBootstrap?
    var methods = [String: XmlRpcServerMethod]()

    init(group: EventLoopGroup) {
        handler = MessageHandler()

        boot = ServerBootstrap(group: group)
            // Specify backlog and enable SO_REUSEADDR for the server itself
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

            // Set the handlers that are appled to the accepted Channels
            .childChannelInitializer { channel in
                channel.pipeline.addHandler(self.handler)
            }

            // Enable TCP_NODELAY and SO_REUSEADDR for the accepted Channels
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
            .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())

        handler.server = self

    }

    func bindAndListen(port: Int) {
        do {
            channel = try boot?.bind(host: Ros.Network.getHost(), port: 0).wait()
        } catch {
            ROS_ERROR("bind failed to [\(Ros.Network.getHost())], \(error)")
        }
    }

    func addMethod(method: XmlRpcServerMethod) {
        if methods[method.name] != nil {
            methods.removeValue(forKey: method.name)
        }
        methods[method.name] = method
    }

    func removeMethod(method: XmlRpcServerMethod) {
        methods.removeValue(forKey: method.name)
    }

    func removeMethod(methodName: String) {
        methods.removeValue(forKey: methodName)
    }

    func findMethod(name: String) -> XmlRpcServerMethod? {
        return methods[name]
    }

}

//
//  HDPingTools.swift
//  HDPingTools
//
//  Created by Damon on 2021/1/4.
//

import Foundation

public typealias PingComplete = ((_ response: HDPingResponse?, _ error: Error?) -> Void)

public enum HDPingError: Error, Equatable {
    case requestError   //发起失败
    case receiveError   //响应失败
    case timeOut        //超时
}

public struct HDPingResponse {
    public var pingAddressIP = ""
    public var responseTime: TimeInterval = 0
    public var responseBytes: Int = 0
}

open class HDPingTools: NSObject {

    public var timeOut: TimeInterval = 100  //上次未响应的超时时间，毫秒
    public var debugLog = true              //是否开启日志输出

    public private(set) var isPing = false

    private var pinger: SimplePing
    private var complete: PingComplete?
    private var sendStartTime: Date?
    private var sendTimer: Timer?
    private var sendInterval: TimeInterval = 0
    private var pingAddressIP = ""

    public init(hostName: String) {
        pinger = SimplePing(hostName: hostName)
        super.init()
        pinger.delegate = self
    }

    public convenience init(url: URL) {
        self.init(hostName: url.host ?? "www.apple.com")
    }

    /// 开始ping请求
    /// - Parameters:
    ///   - pingType: ping的类型
    ///   - interval: 是否重复定时ping
    ///   - complete: 请求的回调
    public func start(pingType: SimplePingAddressStyle = .any, interval: TimeInterval = 0, complete: PingComplete? = nil) {
        self.stop()
        self.complete = complete
        self.pinger.addressStyle = pingType
        self.sendInterval = interval
        self.pinger.start()
        self.isPing = true
    }

    public func stop() {
        self.pinger.stop()
        self.isPing = false
        sendTimer?.invalidate()
        sendTimer = nil
        sendStartTime = nil
    }
}

private extension HDPingTools {
    func sendPingData() {
        if let sendStartTime = sendStartTime {
            let time = Date().timeIntervalSince(sendStartTime).truncatingRemainder(dividingBy: 1) * 1000
            if time > self.timeOut,  let complete = self.complete {
                complete(nil, HDPingError.timeOut)
            }
        } else {
            pinger.send(with: nil)
        }
    }

    func displayAddressForAddress(address: NSData) -> String {
        var hostStr = [Int8](repeating: 0, count: Int(NI_MAXHOST))

        let success = getnameinfo(
            address.bytes.assumingMemoryBound(to: sockaddr.self),
            socklen_t(address.length),
            &hostStr,
            socklen_t(hostStr.count),
            nil,
            0,
            NI_NUMERICHOST
        ) == 0
        let result: String
        if success {
            result = String(cString: hostStr)
        } else {
            result = "?"
        }
        return result
    }

    func shortErrorFromError(error: NSError) -> String {
        if error.domain == kCFErrorDomainCFNetwork as String && error.code == Int(CFNetworkErrors.cfHostErrorUnknown.rawValue) {
            if let failureObj = error.userInfo[kCFGetAddrInfoFailureKey as String] {
                if let failureNum = failureObj as? NSNumber {
                    if failureNum.intValue != 0 {
                        let f = gai_strerror(Int32(failureNum.intValue))
                        if f != nil {
                            return String(cString: f!)
                        }
                    }
                }
            }
        }
        if let result = error.localizedFailureReason {
            return result
        }
        return error.localizedDescription
    }
}

extension HDPingTools: SimplePingDelegate {
    public func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        pingAddressIP = self.displayAddressForAddress(address: NSData(data: address))
        if debugLog {
            print("ping: ", pingAddressIP)
        }
        self.sendPingData()
        if sendInterval > 0 && sendTimer == nil {
            sendTimer = Timer(timeInterval: sendInterval, repeats: true, block: { [weak self] (_) in
                guard let self = self else { return }
                self.sendPingData()
            })
            RunLoop.main.add(sendTimer!, forMode: .common)
        }
    }

    public func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        if debugLog {
            print("ping failed: ", self.shortErrorFromError(error: error as NSError))
        }
        if let complete = self.complete {
            complete(nil, HDPingError.requestError)
        }
        self.stop()
    }

    public func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        if debugLog {
            print("ping sent \(packet.count) data bytes, icmp_seq=\(sequenceNumber)")
        }
        sendStartTime = Date()
    }

    public func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        if debugLog {
            print("ping send error: ", sequenceNumber, self.shortErrorFromError(error: error as NSError))
        }
        sendStartTime = nil
        if let complete = self.complete {
            complete(nil, HDPingError.receiveError)
        }
    }

    public func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        if let sendTime = sendStartTime {
            let time = Date().timeIntervalSince(sendTime).truncatingRemainder(dividingBy: 1) * 1000
            if debugLog {
                print("\(packet.count) bytes from \(pingAddressIP): icmp_seq=\(sequenceNumber) time=\(time)ms")
            }
            sendStartTime = nil
            if let complete = self.complete {
                let response = HDPingResponse(pingAddressIP: pingAddressIP, responseTime: time, responseBytes: packet.count)
                complete(response, nil)
            }
        }
    }

    public func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        if debugLog {
            print("unexpected receive packet, size=\(packet.count)")
        }
    }
}

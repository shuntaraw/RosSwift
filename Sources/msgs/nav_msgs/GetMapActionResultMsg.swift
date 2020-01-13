import Foundation
import StdMsgs
import RosTime
import actionlib_msgs

extension nav_msgs {
/// ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
public struct GetMapActionResult: Message {
public static var md5sum: String = "ac66e5b9a79bb4bbd33dab245236c892"
public static var datatype = "nav_msgs/GetMapActionResult"
public static var definition = """
# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======

Header header
actionlib_msgs/GoalStatus status
GetMapResult result
"""
public static var hasHeader = false

public var header: std_msgs.Header
public var status: actionlib_msgs.GoalStatus
public var result: GetMapResult

public init(header: std_msgs.Header, status: actionlib_msgs.GoalStatus, result: GetMapResult) {
self.header = header
self.status = status
self.result = result
}

public init() {
    header = std_msgs.Header()
status = actionlib_msgs.GoalStatus()
result = GetMapResult()
}

}
}

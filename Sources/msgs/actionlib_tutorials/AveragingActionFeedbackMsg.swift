import Foundation
import StdMsgs
import RosTime
import actionlib_msgs

extension actionlib_tutorials {
/// ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
public struct AveragingActionFeedback: Message {
public static var md5sum: String = "78a4a09241b1791069223ae7ebd5b16b"
public static var datatype = "actionlib_tutorials/AveragingActionFeedback"
public static var definition = """
# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======

Header header
actionlib_msgs/GoalStatus status
AveragingFeedback feedback
"""
public static var hasHeader = false

public var header: std_msgs.header
public var status: actionlib_msgs.GoalStatus
public var feedback: AveragingFeedback

public init(header: std_msgs.header, status: actionlib_msgs.GoalStatus, feedback: AveragingFeedback) {
self.header = header
self.status = status
self.feedback = feedback
}

public init() {
    header = std_msgs.header()
status = actionlib_msgs.GoalStatus()
feedback = AveragingFeedback()
}

}
}

import Foundation
import StdMsgs
import RosTime


extension control_msgs {
/// ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
public struct GripperCommandGoal: Message {
public static var md5sum: String = "86fd82f4ddc48a4cb6856cfa69217e43"
public static var datatype = "control_msgs/GripperCommandGoal"
public static var definition = """
# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
GripperCommand command
"""
public static var hasHeader = false

public var command: GripperCommand

public init(command: GripperCommand) {
self.command = command
}

public init() {
    command = GripperCommand()
}

}
}

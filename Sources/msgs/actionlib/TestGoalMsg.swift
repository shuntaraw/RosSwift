import Foundation
import StdMsgs
import RosTime


extension actionlib {
/// ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
public struct TestGoal: Message {
public static var md5sum: String = "18df0149936b7aa95588e3862476ebde"
public static var datatype = "actionlib/TestGoal"
public static var definition = """
# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
int32 goal
"""
public static var hasHeader = false

public var goal: Int32

public init(goal: Int32) {
self.goal = goal
}

public init() {
    goal = Int32()
}

}
}

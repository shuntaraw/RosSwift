import Foundation
import StdMsgs
import RosTime


extension actionlib {
/// ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
public struct TwoIntsResult: Message {
public static var md5sum: String = "b88405221c77b1878a3cbbfff53428d7"
public static var datatype = "actionlib/TwoIntsResult"
public static var definition = """
# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
int64 sum
"""
public static var hasHeader = false

public var sum: Int64

public init(sum: Int64) {
self.sum = sum
}

public init() {
    sum = Int64()
}

}
}

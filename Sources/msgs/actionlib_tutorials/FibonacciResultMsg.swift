import Foundation
import StdMsgs
import RosTime


extension actionlib_tutorials {
/// ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
///result definition
public struct FibonacciResult: Message {
public static var md5sum: String = "b81e37d2a31925a0e8ae261a8699cb79"
public static var datatype = "actionlib_tutorials/FibonacciResult"
public static var definition = """
# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
#result definition
int32[] sequence
"""
public static var hasHeader = false

public var sequence: [Int32]

public init(sequence: [Int32]) {
self.sequence = sequence
}

public init() {
    sequence = [Int32]()
}

}
}

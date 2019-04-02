import Foundation
import StdMsgs
import RosTime
import geometry_msgs

extension control_msgs {
/// ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
public struct PointHeadGoal: Message {
public static var md5sum: String = "8b92b1cd5e06c8a94c917dc3209a4c1d"
public static var datatype = "control_msgs/PointHeadGoal"
public static var definition = """
# ====== DO NOT MODIFY! AUTOGENERATED FROM AN ACTION DEFINITION ======
geometry_msgs/PointStamped target
geometry_msgs/Vector3 pointing_axis
string pointing_frame
duration min_duration
float64 max_velocity
"""
public static var hasHeader = false

public var target: geometry_msgs.PointStamped
public var pointing_axis: geometry_msgs.Vector3
public var pointing_frame: String
public var min_duration: RosTime.Duration
public var max_velocity: Float64

public init(target: geometry_msgs.PointStamped, pointing_axis: geometry_msgs.Vector3, pointing_frame: String, min_duration: RosTime.Duration, max_velocity: Float64) {
self.target = target
self.pointing_axis = pointing_axis
self.pointing_frame = pointing_frame
self.min_duration = min_duration
self.max_velocity = max_velocity
}

public init() {
    target = geometry_msgs.PointStamped()
pointing_axis = geometry_msgs.Vector3()
pointing_frame = String()
min_duration = RosTime.Duration()
max_velocity = Float64()
}

}
}

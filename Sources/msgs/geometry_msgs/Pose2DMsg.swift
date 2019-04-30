import Foundation
import StdMsgs
import RosTime


extension geometry_msgs {
	/// Deprecated
	/// Please use the full 3D pose.
	/// In general our recommendation is to use a full 3D representation of everything and for 2D specific applications make the appropriate projections into the plane for their calculations but optimally will preserve the 3D information during processing.
	/// If we have parallel copies of 2D datatypes every UI and other pipeline will end up needing to have dual interfaces to plot everything. And you will end up with not being able to use 3D tools for 2D use cases even if they're completely valid, as you'd have to reimplement it with different inputs and outputs. It's not particularly hard to plot the 2D pose or compute the yaw error for the Pose message and there are already tools and libraries that can do this for you.
	/// This expresses a position and orientation on a 2D manifold.
	public struct Pose2D: Message {
		public static var md5sum: String = "938fa65709584ad8e77d238529be13b8"
		public static var datatype = "geometry_msgs/Pose2D"
		public static var definition = """
			# Deprecated
			# Please use the full 3D pose.
			# In general our recommendation is to use a full 3D representation of everything and for 2D specific applications make the appropriate projections into the plane for their calculations but optimally will preserve the 3D information during processing.
			# If we have parallel copies of 2D datatypes every UI and other pipeline will end up needing to have dual interfaces to plot everything. And you will end up with not being able to use 3D tools for 2D use cases even if they're completely valid, as you'd have to reimplement it with different inputs and outputs. It's not particularly hard to plot the 2D pose or compute the yaw error for the Pose message and there are already tools and libraries that can do this for you.
			# This expresses a position and orientation on a 2D manifold.
			float64 x
			float64 y
			float64 theta
			"""

		public static let hasHeader = false

		public var x: Float64
		public var y: Float64
		public var theta: Float64

		public init(x: Float64, y: Float64, theta: Float64) {
			self.x = x
			self.y = y
			self.theta = theta
		}

		public init() {
			x = Float64()
			y = Float64()
			theta = Float64()
		}
	}
}
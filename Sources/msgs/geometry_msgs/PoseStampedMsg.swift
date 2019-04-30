import Foundation
import StdMsgs
import RosTime


extension geometry_msgs {
	/// A Pose with reference coordinate frame and timestamp
	public struct PoseStamped: Message {
		public static var md5sum: String = "d3812c3cbc69362b77dc0b19b345f8f5"
		public static var datatype = "geometry_msgs/PoseStamped"
		public static var definition = """
			# A Pose with reference coordinate frame and timestamp
			Header header
			Pose pose
			"""

		public static let hasHeader = false

		public var header: std_msgs.Header
		public var pose: Pose

		public init(header: std_msgs.Header, pose: Pose) {
			self.header = header
			self.pose = pose
		}

		public init() {
			header = std_msgs.Header()
			pose = Pose()
		}
	}
}
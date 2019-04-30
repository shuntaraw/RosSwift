import Foundation
import StdMsgs
import RosTime


extension geometry_msgs {
	/// This represents a Point with reference coordinate frame and timestamp
	public struct PointStamped: Message {
		public static var md5sum: String = "c63aecb41bfdfd6b7e1fac37c7cbe7bf"
		public static var datatype = "geometry_msgs/PointStamped"
		public static var definition = """
			# This represents a Point with reference coordinate frame and timestamp
			Header header
			Point point
			"""

		public static let hasHeader = false

		public var header: std_msgs.Header
		public var point: Point

		public init(header: std_msgs.Header, point: Point) {
			self.header = header
			self.point = point
		}

		public init() {
			header = std_msgs.Header()
			point = Point()
		}
	}
}
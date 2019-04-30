import Foundation
import StdMsgs
import RosTime


extension geometry_msgs {
	/// This represents an orientation with reference coordinate frame and timestamp.
	public struct QuaternionStamped: Message {
		public static var md5sum: String = "e57f1e547e0e1fd13504588ffc8334e2"
		public static var datatype = "geometry_msgs/QuaternionStamped"
		public static var definition = """
			# This represents an orientation with reference coordinate frame and timestamp.
			Header header
			Quaternion quaternion
			"""

		public static let hasHeader = false

		public var header: std_msgs.Header
		public var quaternion: Quaternion

		public init(header: std_msgs.Header, quaternion: Quaternion) {
			self.header = header
			self.quaternion = quaternion
		}

		public init() {
			header = std_msgs.Header()
			quaternion = Quaternion()
		}
	}
}
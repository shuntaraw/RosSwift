// Generated by msgbuilder 2019-05-02 07:55:41 +0000

import StdMsgs

extension geometry_msgs {
	/// This expresses acceleration in free space broken into its linear and angular parts.
	public struct Accel: Message {
		public static let md5sum: String = "9f195f881246fdfa2798d1d3eebca84a"
		public static let datatype = "geometry_msgs/Accel"
		public static let definition = """
			# This expresses acceleration in free space broken into its linear and angular parts.
			Vector3  linear
			Vector3  angular
			"""

		public static let hasHeader = false

	
		public var linear: Vector3
		public var angular: Vector3

		public init(linear: Vector3, angular: Vector3) {
			self.linear = linear
			self.angular = angular
		}

		public init() {
			linear = Vector3()
			angular = Vector3()
		}
	}
}
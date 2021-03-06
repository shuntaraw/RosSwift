// Generated by msgbuilder 2019-05-02 07:55:41 +0000

import StdMsgs

extension geometry_msgs {
	/// This represents force in free space, separated into
	/// its linear and angular parts.
	public struct Wrench: Message {
		public static let md5sum: String = "4f539cf138b23283b520fd271b567936"
		public static let datatype = "geometry_msgs/Wrench"
		public static let definition = """
			# This represents force in free space, separated into
			# its linear and angular parts.
			Vector3  force
			Vector3  torque
			"""

		public static let hasHeader = false

	
		public var force: Vector3
		public var torque: Vector3

		public init(force: Vector3, torque: Vector3) {
			self.force = force
			self.torque = torque
		}

		public init() {
			force = Vector3()
			torque = Vector3()
		}
	}
}
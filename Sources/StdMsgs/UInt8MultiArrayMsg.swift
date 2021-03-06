// Generated by msgbuilder 2019-05-02 08:13:20 +0000



extension std_msgs {
	/// Please look at the MultiArrayLayout message definition for
	/// documentation on all multiarrays.
	public struct UInt8MultiArray: Message {
		public static let md5sum: String = "82373f1612381bb6ee473b5cd6f5d89c"
		public static let datatype = "std_msgs/UInt8MultiArray"
		public static let definition = """
			# Please look at the MultiArrayLayout message definition for
			# documentation on all multiarrays.
			MultiArrayLayout  layout        # specification of data layout
			uint8[]           data          # array of data
			"""

		public static let hasHeader = false

	
		public var layout: MultiArrayLayout
		public var data: [UInt8]

		public init(layout: MultiArrayLayout, data: [UInt8]) {
			self.layout = layout
			self.data = data
		}

		public init() {
			layout = MultiArrayLayout()
			data = [UInt8]()
		}
	}
}
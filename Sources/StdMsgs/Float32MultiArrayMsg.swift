// Generated by msgbuilder 2019-05-02 08:13:26 +0000



extension std_msgs {
	/// Please look at the MultiArrayLayout message definition for
	/// documentation on all multiarrays.
	public struct Float32MultiArray: Message {
		public static let md5sum: String = "6a40e0ffa6a17a503ac3f8616991b1f6"
		public static let datatype = "std_msgs/Float32MultiArray"
		public static let definition = """
			# Please look at the MultiArrayLayout message definition for
			# documentation on all multiarrays.
			MultiArrayLayout  layout        # specification of data layout
			float32[]         data          # array of data
			"""

		public static let hasHeader = false

	
		public var layout: MultiArrayLayout
		public var data: [Float32]

		public init(layout: MultiArrayLayout, data: [Float32]) {
			self.layout = layout
			self.data = data
		}

		public init() {
			layout = MultiArrayLayout()
			data = [Float32]()
		}
	}
}
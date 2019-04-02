import Foundation
import StdMsgs
import RosTime
import geometry_msgs

extension sensor_msgs {
/// Measurement of the Magnetic Field vector at a specific location.
public struct MagneticField: Message {
public static var md5sum: String = "2f3b0b43eed0c9501de0fa3ff89a45aa"
public static var datatype = "sensor_msgs/MagneticField"
public static var definition = """
# Measurement of the Magnetic Field vector at a specific location.

 # If the covariance of the measurement is known, it should be filled in
 # (if all you know is the variance of each measurement, e.g. from the datasheet,
 #just put those along the diagonal)
 # A covariance matrix of all zeros will be interpreted as "covariance unknown",
 # and to use the data a covariance will have to be assumed or gotten from some
 # other source


 Header header                        # timestamp is the time the
                                      # field was measured
                                      # frame_id is the location and orientation
                                      # of the field measurement

 geometry_msgs/Vector3 magnetic_field # x, y, and z components of the
                                      # field vector in Tesla
                                      # If your sensor does not output 3 axes,
                                      # put NaNs in the components not reported.

 float64[9] magnetic_field_covariance # Row major about x, y, z axes
                                      # 0 is interpreted as variance unknown
"""
public static var hasHeader = false

public var header: std_msgs.header
public var magnetic_field: geometry_msgs.Vector3
public var magnetic_field_covariance: [Float64]

public init(header: std_msgs.header, magnetic_field: geometry_msgs.Vector3, magnetic_field_covariance: [Float64]) {
self.header = header
self.magnetic_field = magnetic_field
self.magnetic_field_covariance = magnetic_field_covariance
}

public init() {
    header = std_msgs.header()
magnetic_field = geometry_msgs.Vector3()
magnetic_field_covariance = [Float64]()
}

}
}

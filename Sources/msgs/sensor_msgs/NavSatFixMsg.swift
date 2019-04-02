import Foundation
import StdMsgs
import RosTime


extension sensor_msgs {
/// Navigation Satellite fix for any Global Navigation Satellite System
///
/// Specified using the WGS 84 reference ellipsoid
/// header.stamp specifies the ROS time for this measurement (the
///        corresponding satellite time may be reported using the
///        sensor_msgs/TimeReference message).
///
/// header.frame_id is the frame of reference reported by the satellite
///        receiver, usually the location of the antenna.  This is a
///        Euclidean frame relative to the vehicle, not a reference
///        ellipsoid.
/// satellite fix status information
/// Latitude [degrees]. Positive is north of equator; negative is south.
/// Longitude [degrees]. Positive is east of prime meridian; negative is west.
/// Altitude [m]. Positive is above the WGS 84 ellipsoid
/// (quiet NaN if no altitude is available).
/// Position covariance [m^2] defined relative to a tangential plane
/// through the reported position. The components are East, North, and
/// Up (ENU), in row-major order.
///
/// Beware: this coordinate system exhibits singularities at the poles.
/// If the covariance of the fix is known, fill it in completely. If the
/// GPS receiver provides the variance of each measurement, put them
/// along the diagonal. If only Dilution of Precision is available,
/// estimate an approximate covariance from that.
public struct NavSatFix: Message {
public static var md5sum: String = "2d3a8cd499b9b4a0249fb98fd05cfa48"
public static var datatype = "sensor_msgs/NavSatFix"
public static var definition = """
# Navigation Satellite fix for any Global Navigation Satellite System
#
# Specified using the WGS 84 reference ellipsoid

# header.stamp specifies the ROS time for this measurement (the
#        corresponding satellite time may be reported using the
#        sensor_msgs/TimeReference message).
#
# header.frame_id is the frame of reference reported by the satellite
#        receiver, usually the location of the antenna.  This is a
#        Euclidean frame relative to the vehicle, not a reference
#        ellipsoid.
Header header

# satellite fix status information
NavSatStatus status

# Latitude [degrees]. Positive is north of equator; negative is south.
float64 latitude

# Longitude [degrees]. Positive is east of prime meridian; negative is west.
float64 longitude

# Altitude [m]. Positive is above the WGS 84 ellipsoid
# (quiet NaN if no altitude is available).
float64 altitude

# Position covariance [m^2] defined relative to a tangential plane
# through the reported position. The components are East, North, and
# Up (ENU), in row-major order.
#
# Beware: this coordinate system exhibits singularities at the poles.

float64[9] position_covariance

# If the covariance of the fix is known, fill it in completely. If the
# GPS receiver provides the variance of each measurement, put them
# along the diagonal. If only Dilution of Precision is available,
# estimate an approximate covariance from that.

uint8 COVARIANCE_TYPE_UNKNOWN = 0
uint8 COVARIANCE_TYPE_APPROXIMATED = 1
uint8 COVARIANCE_TYPE_DIAGONAL_KNOWN = 2
uint8 COVARIANCE_TYPE_KNOWN = 3

uint8 position_covariance_type
"""
public static var hasHeader = false

public var header: std_msgs.header
public var status: NavSatStatus
public var latitude: Float64
public var longitude: Float64
public var altitude: Float64
public var position_covariance: [Float64]
public let COVARIANCE_TYPE_UNKNOWN: UInt8 = 0
public let COVARIANCE_TYPE_APPROXIMATED: UInt8 = 1
public let COVARIANCE_TYPE_DIAGONAL_KNOWN: UInt8 = 2
public let COVARIANCE_TYPE_KNOWN: UInt8 = 3
public var position_covariance_type: UInt8

public init(header: std_msgs.header, status: NavSatStatus, latitude: Float64, longitude: Float64, altitude: Float64, position_covariance: [Float64], position_covariance_type: UInt8) {
self.header = header
self.status = status
self.latitude = latitude
self.longitude = longitude
self.altitude = altitude
self.position_covariance = position_covariance
self.position_covariance_type = position_covariance_type
}

public init() {
    header = std_msgs.header()
status = NavSatStatus()
latitude = Float64()
longitude = Float64()
altitude = Float64()
position_covariance = [Float64]()
position_covariance_type = UInt8()
}

}
}

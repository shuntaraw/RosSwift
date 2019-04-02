import Foundation
import StdMsgs
import RosTime


extension sensor_msgs {
/// Single photometric illuminance measurement.  Light should be assumed to be
public struct Illuminance: Message {
public static var md5sum: String = "8cf5febb0952fca9d650c3d11a81a188"
public static var datatype = "sensor_msgs/Illuminance"
public static var definition = """
# Single photometric illuminance measurement.  Light should be assumed to be
 # measured along the sensor's x-axis (the area of detection is the y-z plane).
 # The illuminance should have a 0 or positive value and be received with
 # the sensor's +X axis pointing toward the light source.

 # Photometric illuminance is the measure of the human eye's sensitivity of the
 # intensity of light encountering or passing through a surface.

 # All other Photometric and Radiometric measurements should
 # not use this message.
 # This message cannot represent:
 # Luminous intensity (candela/light source output)
 # Luminance (nits/light output per area)
 # Irradiance (watt/area), etc.

 Header header           # timestamp is the time the illuminance was measured
                         # frame_id is the location and direction of the reading

 float64 illuminance     # Measurement of the Photometric Illuminance in Lux.

 float64 variance        # 0 is interpreted as variance unknown
"""
public static var hasHeader = false

public var header: std_msgs.header
public var illuminance: Float64
public var variance: Float64

public init(header: std_msgs.header, illuminance: Float64, variance: Float64) {
self.header = header
self.illuminance = illuminance
self.variance = variance
}

public init() {
    header = std_msgs.header()
illuminance = Float64()
variance = Float64()
}

}
}

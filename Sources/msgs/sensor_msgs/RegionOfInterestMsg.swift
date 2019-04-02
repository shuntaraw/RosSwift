import Foundation
import StdMsgs
import RosTime


extension sensor_msgs {
/// This message is used to specify a region of interest within an image.
///
/// When used to specify the ROI setting of the camera when the image was
/// taken, the height and width fields should either match the height and
/// width fields for the associated image; or height = width = 0
/// indicates that the full resolution image was captured.
/// True if a distinct rectified ROI should be calculated from the "raw"
/// ROI in this message. Typically this should be False if the full image
/// is captured (ROI not used), and True if a subwindow is captured (ROI
/// used).
public struct RegionOfInterest: Message {
public static var md5sum: String = "bdb633039d588fcccb441a4d43ccfe09"
public static var datatype = "sensor_msgs/RegionOfInterest"
public static var definition = """
# This message is used to specify a region of interest within an image.
#
# When used to specify the ROI setting of the camera when the image was
# taken, the height and width fields should either match the height and
# width fields for the associated image; or height = width = 0
# indicates that the full resolution image was captured.

uint32 x_offset  # Leftmost pixel of the ROI
                 # (0 if the ROI includes the left edge of the image)
uint32 y_offset  # Topmost pixel of the ROI
                 # (0 if the ROI includes the top edge of the image)
uint32 height    # Height of ROI
uint32 width     # Width of ROI

# True if a distinct rectified ROI should be calculated from the "raw"
# ROI in this message. Typically this should be False if the full image
# is captured (ROI not used), and True if a subwindow is captured (ROI
# used).
bool do_rectify
"""
public static var hasHeader = false

public var x_offset: UInt32
public var y_offset: UInt32
public var height: UInt32
public var width: UInt32
public var do_rectify: Bool

public init(x_offset: UInt32, y_offset: UInt32, height: UInt32, width: UInt32, do_rectify: Bool) {
self.x_offset = x_offset
self.y_offset = y_offset
self.height = height
self.width = width
self.do_rectify = do_rectify
}

public init() {
    x_offset = UInt32()
y_offset = UInt32()
height = UInt32()
width = UInt32()
do_rectify = Bool()
}

}
}

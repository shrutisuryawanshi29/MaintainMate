//
//  Extensions.swift
//  PublicEye
//
//  Created by Shruti Suryawanshi on 2/24/24.
//

//https://github.com/AfrazCodes/CoreMLDemo-YT/blob/main/CoreMLDemo/Extensions.swift

import Foundation
import UIKit

extension UIImage {
    /// Resize image
    /// - Parameter size: Size to resize to
    /// - Returns: Resized image
    func resize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /// Create and return CoreVideo Pixel Buffer
    /// - Returns: Pixel Buffer
    func getCVPixelBuffer() -> CVPixelBuffer? {
        guard let image = cgImage else {
             return nil
        }
        let imageWidth = Int(image.width)
        let imageHeight = Int(image.height)

        let attributes : [NSObject:AnyObject] = [
            kCVPixelBufferCGImageCompatibilityKey : true as AnyObject,
            kCVPixelBufferCGBitmapContextCompatibilityKey : true as AnyObject
        ]

        var pxbuffer: CVPixelBuffer? = nil
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            imageWidth,
            imageHeight,
            kCVPixelFormatType_32ARGB,
            attributes as CFDictionary?,
            &pxbuffer
        )

        if let _pxbuffer = pxbuffer {
            let flags = CVPixelBufferLockFlags(rawValue: 0)
            CVPixelBufferLockBaseAddress(_pxbuffer, flags)
            let pxdata = CVPixelBufferGetBaseAddress(_pxbuffer)

            let rgbColorSpace = CGColorSpaceCreateDeviceRGB();
            let context = CGContext(
                data: pxdata,
                width: imageWidth,
                height: imageHeight,
                bitsPerComponent: 8,
                bytesPerRow: CVPixelBufferGetBytesPerRow(_pxbuffer),
                space: rgbColorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
            )

            if let _context = context {
                _context.draw(
                    image,
                    in: CGRect.init(
                        x: 0,
                        y: 0,
                        width: imageWidth,
                        height: imageHeight
                    )
                )
            }
            else {
                CVPixelBufferUnlockBaseAddress(_pxbuffer, flags);
                return nil
            }

            CVPixelBufferUnlockBaseAddress(_pxbuffer, flags);
            return _pxbuffer;
        }

        return nil
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

extension IssuesModel {
    var issueTypeSortOrder: Int {
        return ["Water Leakage", "Electricity Outage", "Somebody is locked", "Other"].firstIndex(of: issueType) ?? 0
    }
}

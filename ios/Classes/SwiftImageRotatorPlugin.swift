import Flutter
import UIKit

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: radians)).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: radians)
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

public class SwiftImageRotatorPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "io.siteplan.image_rotator", binaryMessenger: registrar.messenger())
    let instance = SwiftImageRotatorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "rotate") {
      let args = call.arguments as? [String: Any?]
      let filePath = args!["imagePath"] as? String
      let targetPath = args!["targetPath"] as? String
      let angle = args!["angle"] as? CGFloat
      self.rotate(filePath!, targetPath: targetPath!, angle: angle!, result: result)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }

  private func deg2rad(_ number: CGFloat) -> CGFloat {
    return number * .pi / 180
  }

  func saveImageToDocumentDirectory(_ chosenImage: UIImage, targetPath: String) {
    let fileManager = FileManager.default
    
    let imageData = chosenImage.jpegData(compressionQuality: 1)
    fileManager.createFile(atPath: targetPath, contents: imageData, attributes: nil)
  }

  private func rotate(_ filePath: String, targetPath: String, angle: CGFloat, result: @escaping FlutterResult) {
    let image = UIImage(contentsOfFile: filePath)
    let rad = deg2rad(angle)
    let rotatedImage = image!.rotate(radians: rad)
    self.saveImageToDocumentDirectory(rotatedImage!, targetPath: targetPath)
    result(nil)
  }
}

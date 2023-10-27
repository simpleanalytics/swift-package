//
//  UserAgent.swift
//  
//
//  Created by Roel van der Kraan on 27/10/2023.
//
//  Inspired by:
//  https://gist.github.com/majeedyaseen/61a177e7799ef4f68ae9174fc00f2a22
//

import Foundation
import UIKit

struct UserAgent {
    
    //eg. Darwin/16.3.0
    static private func DarwinVersion() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        let dv = String(bytes: Data(bytes: &sysinfo.release, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        return "Darwin/\(dv)"
    }
    //eg. CFNetwork/808.3
    static private func CFNetworkVersion() -> String {
        let dictionary = Bundle(identifier: "com.apple.CFNetwork")?.infoDictionary!
        let version = dictionary?["CFBundleShortVersionString"] as! String
        return "CFNetwork/\(version)"
    }
    
    //eg. iOS/10_1
   static private func deviceVersion() -> String {
       let currentDevice = UIDevice.current
       return "CPU OS \(currentDevice.systemVersion.replacingOccurrences(of: ".", with: "_")) like Mac OS X"
    }
    //eg. iPhone5,2
    static private func deviceName() -> String {
//        var sysinfo = utsname()
//        uname(&sysinfo)
//        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        return UIDevice.current.localizedModel
    }
    //eg. MyApp/1
   static private func appNameAndVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        let version = dictionary["CFBundleShortVersionString"] as! String
        let name = dictionary["CFBundleName"] as! String
        return "\(name)/\(version)"
    }
    
    static func userAgentString() -> String {
        //        userAgent = "Mozilla/5.0 (iPad; CPU OS 13_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148"
        return "\(appNameAndVersion()) (\(deviceName()); \(deviceVersion())) \(CFNetworkVersion()) \(DarwinVersion())"
    }
}


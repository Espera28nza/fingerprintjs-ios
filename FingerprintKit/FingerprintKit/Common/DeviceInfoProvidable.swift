//
//  DeviceInfoProvidable.swift
//  FingerprintKit
//
//  Created by Petr Palata on 13.03.2022.
//

import Foundation

public protocol DeviceInfoProvidable {
    func getDeviceInfo() -> [DeviceInfoCategory]
}

public struct DeviceInfoItem {
    public let label: String
    public let value: String
}

public struct DeviceInfoCategory {
    public let fingerprint: String?
    public let label: String
    public let items: [DeviceInfoItem]
    
    init(label: String, items: [DeviceInfoItem], fingerprint: String? = nil) {
        self.label = label
        self.items = items
        self.fingerprint = fingerprint
    }
}

extension HardwareInfoHarvester: DeviceInfoProvidable {
    public func getDeviceInfo() -> [DeviceInfoCategory] {
        return [DeviceInfoCategory(label: "Hardware information", items: [
            DeviceInfoItem(label: "Device type", value: deviceType),
            DeviceInfoItem(label: "Device model", value: deviceModel),
            DeviceInfoItem(label: "Display resolution", value: self.displayResolution.description),
        ], fingerprint: "Test")]
    }
}

extension OSInfoHarvester: DeviceInfoProvidable {
    public func getDeviceInfo() -> [DeviceInfoCategory] {
        return [DeviceInfoCategory(label: "OS Information", items: [
            DeviceInfoItem(label: "OS release", value: osRelease),
            DeviceInfoItem(label: "OS type", value: osType),
            DeviceInfoItem(label: "OS version", value: osVersion),
            DeviceInfoItem(label: "Kernel version", value: kernelVersion),
        ])]
    }
}

extension IdentifierHarvester: DeviceInfoProvidable {
    public func getDeviceInfo() -> [DeviceInfoCategory] {
        return [DeviceInfoCategory(label: "Identifier Information", items: [
            DeviceInfoItem(label: "Vendor ID", value: vendorIdentifier?.description ?? "Undefined")
        ])]
    }
}

//
//  Fingerprinter.swift
//  FingerprintKit
//
//  Created by Petr Palata on 16.03.2022.
//

import Foundation
import SwiftUI

public class Fingerprinter {
    private let configuration: Configuration
    private let identifiers: IdentifierHarvesting
    private let deviceInfoTree: DeviceInfoTreeProvider
    private let fingerprintCalculator: TreeFingerprintCalculator
    
    public convenience init(_ configuration: Configuration) {
        self.init(
            configuration,
            identifiers: IdentifierHarvester(),
            deviceInfoTree: FingerprintTreeBuilder(),
            fingerprintCalculator: TreeFingerprintCalculator()
        )
    }
    
    init(_ configuration: Configuration, identifiers: IdentifierHarvesting, deviceInfoTree: DeviceInfoTreeProvider, fingerprintCalculator: TreeFingerprintCalculator) {
        self.configuration = configuration
        self.identifiers = identifiers
        self.deviceInfoTree = deviceInfoTree
        self.fingerprintCalculator = fingerprintCalculator
    }
    
}

// MARK: - Public Interface:
public extension Fingerprinter {
    func getDeviceId(_ completion: @escaping (String?) -> Void) {
        completion(self.identifiers.vendorIdentifier?.uuidString)
    }
    
    func getFingerprint(_ completion: @escaping (String?) -> Void) {
        getFingerprintTree { deviceItem in
            completion(deviceItem.fingerprint)
        }
    }
    
    func getFingerprintTree(_ completion: @escaping (DeviceInfoItem) -> Void) {
        let inputTree = deviceInfoTree.buildTree(configuration)
        let fingerprintTree = fingerprintCalculator.calculateFingerprints(
            from: inputTree,
            hashFunction: configuration.hashFunction
        )
        completion(fingerprintTree)
    }
}

// MARK: - Public Interface: Async/Await (iOS 13+)
@available(iOS 13, macOS 11, *)
public extension Fingerprinter {
    func getDeviceId() async -> String? {
        return await withCheckedContinuation({ continuation in
            self.getDeviceId { deviceId in
                continuation.resume(with: .success(deviceId))
            }
        })
    }
    
    func getFingerprintTree() async -> DeviceInfoItem  {
        return await withCheckedContinuation({ continuation in
            self.getFingerprintTree({ tree in
                continuation.resume(with: .success(tree))
            })
        })
    }
    
    func getFingerprint() async -> String? {
        return await withCheckedContinuation({ continuation in
            self.getFingerprint { fingerprint in
                continuation.resume(with: .success(fingerprint))
            }
        })
    }
}

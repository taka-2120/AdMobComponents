//
//  NetworkObserver.swift
//  AdMobComponents
//
//  Created by Yu Takahashi on 10/12/24.
//

import Network
import Observation

/// `NetworkObserver` observes Internet connections to display offline Ad placeholder.
///
/// ## Notes ##
///  As soon as `NetworkObserver` initialized, observation will be started.
///
@Observable
final class NetworkObserver: @unchecked Sendable {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "NetworkObserver")
    /// Readonly flag to check if the device is connected to Internet or not.
    private(set) var isConnected = true

    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: workerQueue)
    }
}

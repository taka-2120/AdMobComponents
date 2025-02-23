//
//  NetworkObserver.swift
//  AdMobComponents
//
//  Created by Yu Takahashi on 2/23/25.
//

import Foundation
import Network
import Observation

///
/// `NetworkObserver` observes Internet connections to display offline ad placeholder.
///
class NetworkObserver {
    private let networkMonitor = NWPathMonitor()
    private var queue: DispatchQueue?

    @MainActor static let shared = NetworkObserver()
    private init() {}

    deinit {
        stopObservation()
    }

    func startObservation() {
        if queue == nil {
            self.queue = DispatchQueue.global(qos: .background)
        }

        guard let queue else { return }

        networkMonitor.pathUpdateHandler = { path in
            Task { @MainActor in
                NotificationCenter.default.post(
                    name: .onNetworkStatusChanged,
                    object: nil,
                    userInfo: ["isConnected": path.status == .satisfied]
                )
            }
        }
        networkMonitor.start(queue: queue)
    }

    func stopObservation() {
        queue = nil
        networkMonitor.cancel()
    }
}

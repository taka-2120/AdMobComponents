//
//  BannerAdView.swift
//  AdMobComponents
//
//  Created by Yu Takahashi on 8/13/24.
//

import GoogleMobileAds
import SwiftUI

struct BannerAdView: View {
    private let viewController: BannerAdViewController
    @State private var isConnected = true

    init(adUnitID: String) {
        viewController = BannerAdViewController(adUnitID: adUnitID)
    }

    var body: some View {
        Group {
            if isConnected && !viewController.isLoading {
                UIBannerAdView(viewController: viewController)
            } else if !isConnected {
                HStack(alignment: .center) {
                    Spacer()
                    Image(systemName: "network.slash")
                        .opacity(0.6)
                    Text("ad_offline", bundle: .module)
                    Spacer()
                }
                .frame(height: 60)
                .background(.regularMaterial)
            } else {
                HStack(alignment: .center) {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(height: 60)
                .background(.regularMaterial)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .onNetworkStatusChanged)) { notification in
            if let isConnected = notification.userInfo?["isConnected"] as? Bool {
                self.isConnected = isConnected
            }
        }
    }
}

private struct UIBannerAdView: UIViewControllerRepresentable {
    let viewController: BannerAdViewController

    func makeUIViewController(context _: Context) -> some UIViewController {
        return viewController
    }

    func updateUIViewController(_: UIViewControllerType, context _: Context) {}
}

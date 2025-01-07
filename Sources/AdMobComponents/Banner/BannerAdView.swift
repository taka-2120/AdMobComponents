//
//  BannerAdView.swift
//  AdMobComponents
//
//  Created by Yu Takahashi on 8/13/24.
//

import GoogleMobileAds
import SwiftUI

struct BannerAdView: View {
    @Environment(NetworkObserver.self) private var networkManager
    private let viewController: BannerAdViewController

    init(adUnitID: String) {
        viewController = BannerAdViewController(adUnitID: adUnitID)
    }

    var body: some View {
        if networkManager.isConnected && viewController.isAdLoading {
            UIBannerAdView(viewController: viewController)
        } else if !viewController.isAdLoading {
            HStack(alignment: .center) {
                Spacer()
                ProgressView()
                Spacer()
            }
            .frame(height: 60)
            .background(.regularMaterial)
        } else {
            HStack(alignment: .center) {
                Spacer()
                Image(systemName: "network.slash")
                    .opacity(0.6)
                Text("ad_offline", bundle: .module)
                Spacer()
            }
            .frame(height: 60)
            .background(.regularMaterial)
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

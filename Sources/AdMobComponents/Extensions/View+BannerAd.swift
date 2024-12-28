//
//  View+BannerAd.swift
//  AdMobComponents
//
//  Created by Yu Takahashi on 12/28/24.
//

import SwiftUI

public extension View {
    ///
    /// `bannerAd` modifier displays a Banner Ad at the bottom of view via Google AdMob library.
    ///
    /// - parameter isPresented:The flag determines wether load and display a Banner Ad or not.
    /// - parameter adUnitID: The unit ID for Banner Ads provided by Google AdMob.
    ///
    func bannerAd(isPresented: Bool, adUnitID: String) -> some View {
        modifier(BannerAd(isPresented: isPresented, adUnitID: adUnitID))
    }
}

private struct BannerAd: ViewModifier {
    let isPresented: Bool
    let adUnitID: String

    func body(content: Content) -> some View {
        content
            .padding(.bottom, isPresented ? 60 : 0)
            .overlay(alignment: .bottom) {
                if isPresented {
                    BannerAdView(adUnitID: adUnitID)
                        .frame(height: 60)
                }
            }
    }
}

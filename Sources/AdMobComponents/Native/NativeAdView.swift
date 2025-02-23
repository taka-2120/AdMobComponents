//
//  NativeAdView.swift
//  AdMobComponents
//
//  Created by Yu Takahashi on 8/13/24.
//

import GoogleMobileAds
import SwiftUI

/// `NativeAdView` displays a NativeAd which was loaded in `NativeAdViewModel`.
///
/// - parameter showsAt: The ad index specifies ad which loaded in `NativeAdViewModel`.
///
public struct NativeAdView: View {
    @Environment(NativeAdViewModel.self) private var nativeAdViewModel
    private let adIndex: Int

    public init(showsAt adIndex: Int) {
        self.adIndex = adIndex
    }

    public var body: some View {
        if !nativeAdViewModel.isLoading {
            UINativeAdView(nativeAdViewModel: nativeAdViewModel, adIndex: adIndex)
                .frame(height: 160)
        } else {
            HStack(alignment: .center) {
                Spacer()
                ProgressView()
                Spacer()
            }
            .frame(height: 160)
            .background(.regularMaterial)
        }
    }
}

#Preview {
    NativeAdView(showsAt: 0)
}

private struct UINativeAdView: UIViewRepresentable {
    let nativeAdViewModel: NativeAdViewModel
    let adIndex: Int

    func makeUIView(context _: Context) -> GADNativeAdView {
        guard let adView = Bundle.module.loadNibNamed(
            "NativeAdView",
            owner: nil,
            options: nil
        )?.first as? GADNativeAdView else {
            fatalError("Failed to cast to GADNativeAdView")
        }
        return adView
    }

    func updateUIView(_ nativeAdView: GADNativeAdView, context _: Context) {
        guard nativeAdViewModel.nativeAds.count > adIndex else { return }
        let nativeAd = nativeAdViewModel.nativeAds[adIndex]

        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline

        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image

        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)

        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store

        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price

        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser

        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)

        // For the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false

        // Associate the native ad view with the native ad object. This is required to make the ad
        // clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd
    }

    private func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
}

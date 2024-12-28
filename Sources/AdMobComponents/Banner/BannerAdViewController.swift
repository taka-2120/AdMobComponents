//
//  BannerAdViewController.swift
//  AdMobComponents
//
//  Created by Yu Takahashi on 8/13/24.
//

import GoogleMobileAds
import UIKit

class BannerAdViewController: UIViewController, GADBannerViewDelegate {
    private let adUnitID: String
    private var bannerView: GADBannerView?
    var isAdLoaded: Bool {
        bannerView != nil
    }

    init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBannerAd()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { [weak self] _ in
            guard let self = self else { return }
            self.loadBannerAd()
        }
    }

    private func loadBannerAd() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView?.adUnitID = adUnitID

        bannerView?.delegate = self
        bannerView?.rootViewController = self

        let bannerWidth = view.frame.size.width
        bannerView?.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(bannerWidth)

        let request = GADRequest()
        request.scene = view.window?.windowScene
        bannerView?.load(request)

        guard let bannerView else {
            return
        }
        setAdView(bannerView)
    }

    private func setAdView(_ view: GADBannerView) {
        bannerView = view
        self.view.addSubview(bannerView!)
        bannerView?.translatesAutoresizingMaskIntoConstraints = false
        let viewDictionary: [String: Any] = ["_bannerView": bannerView as Any]
        self.view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[_bannerView]|", metrics: nil, views: viewDictionary)
        )

        self.view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[_bannerView]|", metrics: nil, views: viewDictionary)
        )
    }
}

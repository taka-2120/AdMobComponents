//
//  ContentView.swift
//  AdMobComponentsSample
//
//  Created by Yu Takahashi on 2/23/25.
//

import AdMobComponents
import SwiftUI

struct ContentView: View {
    @State private var count = 0

    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Count: \(count)")
                Button {
                    count += 1
                } label: {
                    Image(systemName: "plus")
                }
                NativeAdView(showsAt: 0)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

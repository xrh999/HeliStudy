//
//  SettingsView.swift
//  Best Study App
//
//  Created by Huang XR on 3/9/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var e = false
    var body: some View {
        VStack{
            Toggle(isOn: $e) {
                Text("Dark mode")
            }
            .frame(width: 175)
        }
        .frame(width:300)
        .padding(16)
        .background(.thinMaterial)
        .cornerRadius(24)
    }
}

#Preview {
    SettingsView()
}

//
//  CustomTabBarView.swift
//  TheStackLab
//
//  Created by D F on 2/27/26.
//

import SwiftUI

struct CustomTabBarView: View {
    @State private var selectedTab: AppTab = .validate
    @Namespace private var animation
    var body: some View {
        ZStack{
            TabContentView(selectedTab: $selectedTab, animation: animation)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                TabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    CustomTabBarView()
}

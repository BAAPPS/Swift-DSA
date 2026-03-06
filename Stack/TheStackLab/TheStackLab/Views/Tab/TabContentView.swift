//
//  TabContentView.swift
//  TheStackLab
//
//  Created by D F on 2/27/26.
//

import SwiftUI

struct TabContentView: View {
    @Binding var selectedTab: AppTab
    var animation: Namespace.ID
    var body: some View {
        switch selectedTab {
        case .validate: ParenthesesView()
        case .reverse: StringReversalView()
        case .game: StackGameOperationView()
        }
    }
}

#Preview {
    @Previewable @Namespace var animation
    TabContentView(selectedTab: .constant(.reverse), animation: animation)
}

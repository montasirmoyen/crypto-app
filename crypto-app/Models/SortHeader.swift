//
//  SortHeader.swift
//  crypto-app
//
//  Created by Montasir Moyen on 9/27/25.
//

import SwiftUI

enum SortColumn {
    case rank
    case price
    case change7d
}

enum SortDirection {
    case ascending
    case descending
}

struct SortHeader: View {
    let title: String
    let isActive: Bool
    let direction: SortDirection
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                if isActive {
                    Image(systemName: "triangle.fill")
                        .rotationEffect(direction != .descending ? .degrees(0) : .degrees(180))
                        .foregroundColor(.purple)
                        .font(.system(size: 10, weight: .bold))
                }
            }
        }
        .buttonStyle(.plain)
    }
}

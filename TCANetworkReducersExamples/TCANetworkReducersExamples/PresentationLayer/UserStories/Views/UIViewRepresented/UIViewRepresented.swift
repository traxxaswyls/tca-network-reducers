//
//  UIViewRepresented.swift
//  verse-swiftui-examples
//
//  Created by incetro on 10/14/21.
//

import SwiftUI

// MARK: - UIViewRepresented

public struct UIViewRepresented<UIViewType>: UIViewRepresentable where UIViewType: UIView {

    // MARK: - Properties

    public let makeUIView: (Context) -> UIViewType
    public let updateUIView: (UIViewType, Context) -> Void

    // MARK: - UIViewRepresentable

    public func makeUIView(context: Context) -> UIViewType {
        makeUIView(context)
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
        updateUIView(uiView, context)
    }
}

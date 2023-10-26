//
//  UIViewControllerRepresented.swift
//  TheRun
//
//  Created by incetro on 4/7/22.
//  Copyright © 2022 Incetro Inc. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: - UIViewControllerRepresented

public struct UIViewControllerRepresented<Controller: UIViewController>: UIViewControllerRepresentable {

    // MARK: - Properties

    public let makeUIView: (Context) -> Controller
    public let updateUIView: (Controller, Context) -> Void

    // MARK: - UIViewRepresentable

    public func makeUIViewController(context: Context) -> Controller {
        makeUIView(context)
    }

    public func updateUIViewController(_ uiView: Controller, context: Context) {
        updateUIView(uiView, context)
    }
}

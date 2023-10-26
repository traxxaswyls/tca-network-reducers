//
//  ActivityIndicator.swift
//  verse-swiftui-examples
//
//  Created by incetro on 10/14/21.
//

import SwiftUI

// MARK: - ActivityIndicator

public struct ActivityIndicator: View {
    
    // MARK: - Properties

    public var color: UIColor?
    
    // MARK: - Initializer
    
    public init(color: UIColor? = nil) {
        self.color = color
    }

    // MARK: - View

    public var body: some View {
        UIViewRepresented { _ in
            let view = UIActivityIndicatorView()
            view.startAnimating()
            if let color {
                view.color = color
            }
            return view
        } updateUIView: { _, _ in }
    }
}

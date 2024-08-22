//
//  File.swift
//  
//
//  Created by incetro on 7/6/24.
//

import SwiftUI
import Foundation

// MARK: - ViewDidLoadModifier

/// A `ViewModifier` that triggers an action when the view is loaded.
///
/// This modifier uses a state variable to track whether the view has already been loaded.
/// The action is executed only the first time the view appears, mimicking the `viewDidLoad` behavior
/// from UIKit.
struct ViewDidLoadModifier: ViewModifier {
    
    // MARK: - Properties
    
    /// Tracks if the view has been loaded.
    @State private var viewDidLoad = false
    
    /// The action to perform when the view is loaded.
    /// - Note: This action can be nil, in which case no action will be performed.
    let action: (() -> Void)?
    
    // MARK: - ViewModifier
    
    /// Constructs the modified view that triggers `action` when it first appears.
    ///
    /// The `content` parameter represents the view that this modifier is applied to.
    /// The action is executed only once when the view appears for the first time.
    ///
    /// - Parameter content: The content of the view that the modifier is applied to.
    /// - Returns: The view constructed with the modifier applied.
    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}

// MARK: - View

/// An extension on `View` to add `onViewDidLoad` functionality.
extension View {
    
    /// Applies a `ViewDidLoadModifier` to a view to perform an action when the view is loaded.
    ///
    /// This method allows you to execute custom logic the first time the view appears,
    /// similar to the `viewDidLoad` method in UIKit controllers. It is useful for performing
    /// initialization tasks that are dependent on the view hierarchy.
    ///
    /// - Parameter action: The action to execute when the view is loaded. If nil, no action will be performed.
    /// - Returns: A modified view that performs the specified `action` the first time it appears.
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
}

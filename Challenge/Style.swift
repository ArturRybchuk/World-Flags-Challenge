//
//  Style.swift
//  Challenge
//
//  Created by Artur Rybchuk on 3/29/26.
//

import UIKit

/// A utility structure providing centralized UI styling and animations for the application.
struct Style {
    
    // MARK: - Button Styling
    
    /// Configures a button with a consistent border, corner radius, and image scaling.
    /// - Parameters:
    ///   - button: The target UIButton to style.
    ///   - borderWidth: The width of the border around the button.
    ///   - borderColor: The color of the button's border.
    @MainActor static func buttonStyle(for button: UIButton, borderWidth: CGFloat, borderColor: UIColor) {
        
        // Use modern UIButton.Configuration to reset default insets
        var config = button.configuration ?? UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets.zero
        
        // Core Layer Styling
        button.layer.cornerRadius = 10
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor.cgColor
        
        // Ensure the flag image fills the button area properly
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        
        button.configuration = config
    }
    
    // MARK: - Animations
    
    /// Performs a tactile 'bounce' effect to provide visual feedback on user selection.
    /// Uses CGAffineTransform to scale the view in a sequential animation spring.
    /// - Parameter view: The UIView (or UIButton) to animate.
    @MainActor static func animateSelectionBounce(for view: UIView) {
        // Step 1: Scale down (Press effect)
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            // Step 2: Overshoot slightly (Spring effect)
            UIView.animate(withDuration: 0.1, animations: {
                view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                // Step 3: Return to original size
                UIView.animate(withDuration: 0.1) {
                    view.transform = .identity
                }
            }
        }
    }
}

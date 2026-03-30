//
//  File.swift
//  Challenge
//
//  Created by Artur Rybchuk on 3/29/26.
//

import UIKit

struct Style {
    
    @MainActor static func buttonStyle(for button: UIButton, borderWidth: CGFloat, borderColor: UIColor) {
        
        var config = button.configuration ?? UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets.zero
        
        button.layer.cornerRadius = 10
        button.layer.borderWidth = borderWidth
        button.layer.borderColor = borderColor.cgColor
        button.imageView?.contentMode = .scaleAspectFill
        button.configuration = config
        button.clipsToBounds = true
    }
    
    
    @MainActor static func animateSelectionBounce(for view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    view.transform = .identity
                }
            }
        }
    }
}

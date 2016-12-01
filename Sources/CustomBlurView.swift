//
//  CustomBlurView.swift
//  PullToDismiss
//
//  Created by Suguru Kishimoto on 12/1/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit

class CustomBlurView: UIVisualEffectView {
    
    private enum PrivateKey: String {
        case blurRadius = "blurRadius"
        case colorTint = "colorTint"
        case colorTintAlpha = "colorTintAlpha"
    }
    
    private let blurEffect: UIBlurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    
    var blurRadius: CGFloat {
        get {
            return _value(forKey: .blurRadius)
        }
        set {
            _setValue(value: newValue, forKey: .blurRadius)
        }
    }
    
    var colorTint: UIColor? {
        get {
            return _valueOptional(forKey: .colorTint)
        }
        set {
            _setValue(value: newValue, forKey: .colorTint)
        }
    }

    var colorTintAlpha: CGFloat {
        get {
            return _value(forKey: .colorTintAlpha)
        }
        set {
            _setValue(value: newValue, forKey: .colorTintAlpha)
        }
    }

    public init(radius: CGFloat = 0.0) {
        super.init(effect: self.blurEffect)
        self.blurEffect.setValue(1.0, forKeyPath: "scale")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _setValue<T>(value: T?, forKey key: PrivateKey) {
        blurEffect.setValue(value, forKey: key.rawValue)
        if blurRadius > 0 {
            self.effect = blurEffect
        } else {
            self.effect = nil
        }
    }
    
    private func _value<T>(forKey key: PrivateKey) -> T {
        return blurEffect.value(forKey: key.rawValue) as! T
    }

    private func _valueOptional<T>(forKey key: PrivateKey) -> T? {
        return blurEffect.value(forKey: key.rawValue) as? T
    }
}

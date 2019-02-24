//
//  CustomBlurView.swift
//  PullToDismiss
//
//  Created by Suguru Kishimoto on 12/1/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
class CustomBlurView: UIVisualEffectView {
    
    private enum PrivateKey: String {
        case blurRadius = "blurRadius"
        case colorTint = "colorTint"
        case colorTintAlpha = "colorTintAlpha"
        case saturationDeltaFactor = "saturationDeltaFactor"
    }
    
    private let blurEffect: UIBlurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    
    var blurRadius: CGFloat {
        get {
            return value(forKey: .blurRadius)
        }
        set {
            setValue(value: newValue, forKey: .blurRadius)
        }
    }
    
    var colorTint: UIColor? {
        get {
            return valueOptional(forKey: .colorTint)
        }
        set {
            setValue(value: newValue, forKey: .colorTint)
        }
    }

    var colorTintAlpha: CGFloat {
        get {
            return value(forKey: .colorTintAlpha)
        }
        set {
            setValue(value: newValue, forKey: .colorTintAlpha)
        }
    }

    var saturationDeltaFactor: CGFloat {
        get {
            return value(forKey: .saturationDeltaFactor)
        }
        set {
            setValue(value: newValue, forKey: .saturationDeltaFactor)
        }
    }

    public init(radius: CGFloat = 0.0) {
        super.init(effect: self.blurEffect)
    }
    
    public init(style: UIBlurEffect.Style) {
        super.init(effect: self.blurEffect)
        switch style {
        case .light:
            blurRadius = 30.0
            colorTint = UIColor(white: 1.0, alpha: 0.3)
            colorTintAlpha = 1.0
            saturationDeltaFactor = 1.8
        case .extraLight:
            blurRadius = 20.0
            colorTint = UIColor(white: 0.97, alpha: 0.82)
            colorTintAlpha = 1.0
            saturationDeltaFactor = 1.8
        case .dark:
            blurRadius = 20.0
            colorTint = UIColor(white: 0.11, alpha: 0.73)
            colorTintAlpha = 1.0
            saturationDeltaFactor = 1.8
        default:
            () // todo regular, prominent
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setValue<T>(value: T?, forKey key: PrivateKey) {
        blurEffect.setValue(value, forKey: key.rawValue)
        if blurRadius > 0 {
            self.effect = blurEffect
        } else {
            self.effect = nil
        }
    }
    
    private func value<T>(forKey key: PrivateKey) -> T {
        return blurEffect.value(forKey: key.rawValue) as! T
    }

    private func valueOptional<T>(forKey key: PrivateKey) -> T? {
        return blurEffect.value(forKey: key.rawValue) as? T
    }
}

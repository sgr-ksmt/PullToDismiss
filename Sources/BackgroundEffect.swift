//
//  BackgroundEffect.swift
//  PullToDismiss
//
//  Created by Suguru Kishimoto on 12/3/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol BackgroundEffect: NSObjectProtocol {
    var color: UIColor? { get set }
    var alpha: CGFloat { get set }
    var target: BackgroundTarget { get }
    
    func makeBackgroundView() -> UIView
    func applyEffect(view: UIView?, rate: CGFloat)
}

/// A target type to add background view
///
/// - targetViewController: add background view to target viewcontroller
/// - presentingViewController: add background view to target viewcontroller's presenting viewcontroller
@objc public enum BackgroundTarget: Int {
    case targetViewController
    case presentingViewController
}

public final class ShadowEffect: NSObject, BackgroundEffect {
    public var color: UIColor?
    public var alpha: CGFloat
    public var target: BackgroundTarget = .targetViewController

    @objc(defaultShadowEffedt)
    public static let `default`: ShadowEffect = ShadowEffect(color: .black, alpha: 0.8)
    
    public init(color: UIColor?, alpha: CGFloat) {
        self.color = color
        self.alpha = alpha
    }
    
    // only Objective-C
    @available(*, unavailable)
    public class func shadowEffect(color: UIColor?, alpha: CGFloat) -> ShadowEffect {
        return ShadowEffect(color: color, alpha: alpha)
    }
    
    
    public func makeBackgroundView() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = color
        view.alpha = alpha
        return view
    }
    
    public func applyEffect(view: UIView?, rate: CGFloat) {
        view?.alpha = alpha * rate
    }
}

@available(iOS, introduced: 9.0)
public final class BlurEffect: NSObject, BackgroundEffect {
    public var color: UIColor?
    public var alpha: CGFloat
    public var blurRadius: CGFloat
    public var saturationDeltaFactor: CGFloat

    public var target: BackgroundTarget = .presentingViewController

    @objc(defaultBlur)
    public static let `default`: BlurEffect = BlurEffect(
        color: nil,
        alpha: 0.0,
        blurRadius: 20.0,
        saturationDeltaFactor: 1.8
    )
    
    @objc(extraLightBlurEffect)
    public static let extraLight: BlurEffect = BlurEffect(
        color: UIColor(white: 0.97, alpha: 0.82),
        alpha: 1.0,
        blurRadius: 20.0,
        saturationDeltaFactor: 1.8
    )
    
    @objc(lightBlurEffect)
    public static let light: BlurEffect = BlurEffect(
        color: UIColor(white: 1.0, alpha: 0.3),
        alpha: 1.0,
        blurRadius: 30.0,
        saturationDeltaFactor: 1.8
    )
    
    @objc(darkBlurEffect)
    public static let dark: BlurEffect = BlurEffect(
        color: UIColor(white: 0.11, alpha: 0.73),
        alpha: 1.0,
        blurRadius: 20.0,
        saturationDeltaFactor: 1.8
    )
    
    public init(color: UIColor?, alpha: CGFloat, blurRadius: CGFloat, saturationDeltaFactor: CGFloat) {
        self.color = color
        self.alpha = alpha
        self.blurRadius = blurRadius
        self.saturationDeltaFactor = saturationDeltaFactor
    }

    // only Objective-C
    @available(*, unavailable)
    public class func blurEffect(color: UIColor?, alpha: CGFloat, blurRadius: CGFloat, saturationDeltaFactor: CGFloat) -> BlurEffect {
        return BlurEffect(color: color, alpha: alpha, blurRadius: blurRadius, saturationDeltaFactor: saturationDeltaFactor)
    }
    
    public func makeBackgroundView() -> UIView {
        let view = CustomBlurView(radius: blurRadius)
        view.colorTint = color
        view.colorTintAlpha = alpha
        view.saturationDeltaFactor = saturationDeltaFactor
        return view
    }
    
    public func applyEffect(view: UIView?, rate: CGFloat) {
        guard let view = view as? CustomBlurView else {
            return
        }
        view.blurRadius = blurRadius * rate
        view.colorTintAlpha = alpha * rate
        view.saturationDeltaFactor = (saturationDeltaFactor - 1.0) * rate + 1.0
    }
}

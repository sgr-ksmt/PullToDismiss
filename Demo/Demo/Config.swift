//
//  Config.swift
//  Demo
//
//  Created by Suguru Kishimoto on 11/16/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import Foundation
import PullToDismiss

class Config {
    static let shared: Config = Config()
    
    var backgroundEffect: BackgroundEffect? = ShadowEffect.default
    var dismissableHeightPercentage: CGFloat = PullToDismiss.Defaults.dismissableHeightPercentage
    
    func adaptSetting(pullToDismiss: PullToDismiss?) {
        pullToDismiss?.backgroundEffect = backgroundEffect
        pullToDismiss?.dismissableHeightPercentage = dismissableHeightPercentage
    }
}

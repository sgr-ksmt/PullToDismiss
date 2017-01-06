//
//  EdgeShadow.swift
//  PullToDismiss
//
//  Created by Suguru Kishimoto on 1/6/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit

public struct EdgeShadow {
    static let `default` = EdgeShadow(
        opacity: 0.5, radius: 5.0, color: .black, offset: CGSize(width: 0.0, height: -5.0)
    )
    
    let opacity: Float
    let radius: CGFloat
    let color: UIColor
    let offset: CGSize
}

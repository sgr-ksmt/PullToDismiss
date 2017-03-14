//
//  EdgeShadow.swift
//  PullToDismiss
//
//  Created by Suguru Kishimoto on 1/6/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit

@objc public class EdgeShadow : NSObject {
    
    public init(opacity: Float, radius: CGFloat, color: UIColor, offset : CGSize){
        
        super.init()

        self.opacity = opacity
        self.radius = radius
        self.color = color
        self.offset = offset
        
        
    }
    
    static let `default` = EdgeShadow(
        opacity: 0.5, radius: 5.0, color: .black, offset: CGSize(width: 0.0, height: -5.0)
    )
    
    let opacity: Float
    let radius: CGFloat
    let color: UIColor
    let offset: CGSize
}

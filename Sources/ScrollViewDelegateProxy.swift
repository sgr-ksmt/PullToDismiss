//
//  ScrollViewDelegateProxy.swift
//  PullToDismiss
//
//  Created by Suguru Kishimoto on 3/7/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit

class ScrollViewDelegateProxy: DelegateProxy, UIScrollViewDelegate {
    @nonobjc convenience init(delegates: [UIScrollViewDelegate]) {
        self.init(__delegates: delegates)
    }
}

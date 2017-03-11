//
//  Unavailable.swift
//  PullToDismiss
//
//  Created by Suguru Kishimoto on 3/11/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation

extension PullToDismiss {
    @available(*, unavailable, renamed: "delegate")
    public weak var delegateProxy: AnyObject? {
        fatalError("\(#function) is no longer available")
    }
    
    @available(*, unavailable, message: "unavailable")
    public weak var scrollViewDelegate: UIScrollViewDelegate? {
        fatalError("\(#function) is no longer available")
    }
    
    @available(*, unavailable, message: "unavailable")
    public weak var tableViewDelegate: UITableViewDelegate? {
        fatalError("\(#function) is no longer available")
    }
    
    @available(*, unavailable, message: "unavailable")
    public weak var collectionViewDelegate: UICollectionViewDelegate? {
        fatalError("\(#function) is no longer available")
    }
    
    @available(*, unavailable, message: "unavailable")
    public weak var collectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout? {
        fatalError("\(#function) is no longer available")
    }
}

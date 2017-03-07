//
//  SampleCollectionLayout.swift
//  Demo
//
//  Created by Suguru Kishimoto on 11/17/16.
//  Copyright © 2016 Suguru Kishimoto. All rights reserved.
//

import UIKit

class SampleCollectionLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

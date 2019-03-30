//
//  CoverCell.swift
//  CoverScroller
//
//  Created by Tomek on 26/03/2019.
//  Copyright © 2019 Tomek. All rights reserved.
//

import UIKit

class CoverCell : UICollectionViewCell {
    let numberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(numberLabel)
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

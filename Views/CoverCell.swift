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
        let attr = layoutAttributes as! CoverLayoutAttributes
        self.backgroundColor = mixGreenAndRed(greenAmount:attr.scrollPercentage)
        print("Applaying with =",attr.scrollPercentage)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func mixGreenAndRed(greenAmount: CGFloat) -> UIColor {
        // the hues between red and green go from 0…1/3, so we can just divide percentageGreen by 3 to mix between them
        return UIColor(hue: greenAmount / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
}

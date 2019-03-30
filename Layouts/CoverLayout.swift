//
// Created by Tomek on 2019-03-29.
// Copyright (c) 2019 Tomek. All rights reserved.
//

import UIKit

class CoverLayout : UICollectionViewFlowLayout {


    var currentCellPath: NSIndexPath?
    var visibleMiddleCell: Int?
    var currentCellScale: CGFloat?

    
    let defaultCellScale: CGFloat = 1



    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if(collectionView?.bounds != newBounds){
            return true
        }else{
            return false
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at: indexPath)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)
    }
}

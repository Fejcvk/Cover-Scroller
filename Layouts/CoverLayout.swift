//
// Created by Tomek on 2019-03-29.
// Copyright (c) 2019 Tomek. All rights reserved.
//

import UIKit


class CoverLayoutAttributes : UICollectionViewLayoutAttributes {
    var scrollPercentage: CGFloat = 0
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CoverLayoutAttributes
        copy.scrollPercentage = self.scrollPercentage
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? CoverLayoutAttributes {
            if scrollPercentage != rhs.scrollPercentage {
                return false
            }
            return super.isEqual(object)
        } else {
            return false
        }
    }
}



class CoverLayout : UICollectionViewFlowLayout {
    
    private var cachedItemsAttributes: [IndexPath:CoverLayoutAttributes] = [:]
    
    private let scale: CGFloat = 0.8
    
    override var collectionViewContentSize: CGSize {
        let leftmostEdge = cachedItemsAttributes.values.map { $0.frame.minX }.min() ?? 0
        let rightmostEdge = cachedItemsAttributes.values.map { $0.frame.maxX }.max() ?? 0
        return CGSize(width: rightmostEdge - leftmostEdge, height: itemSize.height)
    }
    
    override open func prepare() {
        super.prepare()
        itemSize = CGSize(width: (collectionView!.bounds.width/CGFloat(3)) - 10, height: CGFloat(200))
        updateInsets()
        guard let collectionView = self.collectionView else { return }
        guard cachedItemsAttributes.isEmpty else { return }
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        for item in 0..<itemsCount {
            let indexPath = IndexPath(item: item, section: 0)
            cachedItemsAttributes[indexPath] = createAttributesForItem(at: indexPath)
        }
    }
    
    private func createAttributesForItem(at indexPath: IndexPath) -> CoverLayoutAttributes? {
        let attributes = CoverLayoutAttributes(forCellWith: indexPath)
        guard let collectionView = collectionView else { return nil }
        attributes.frame.size = itemSize
        attributes.frame.origin.y = (collectionView.bounds.height - itemSize.height) / 2
        attributes.frame.origin.x = CGFloat(indexPath.item) * (itemSize.width + 10)
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if(collectionView?.bounds != newBounds){
            cachedItemsAttributes.removeAll()
            return true
        }else{
            return false
        }
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext){
        if context.invalidateDataSourceCounts { cachedItemsAttributes.removeAll() }
        super.invalidateLayout(with: context)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = cachedItemsAttributes[indexPath] else { fatalError("No attributes cached") }
        return attributes
    }

    override func layoutAttributesForElements(in rect: CGRect) ->
        [UICollectionViewLayoutAttributes]? {
            let attributes = cachedItemsAttributes.map { $0.value }.filter { $0.frame.intersects(rect) }
            
            for itemAttributes in attributes {
                let itemAttributesCopy = itemAttributes.copy() as! CoverLayoutAttributes
                
                changeLayoutAttributes(itemAttributesCopy)
                
                let attr = changeScrollPercentage(itemAttributesCopy)
                
                cachedItemsAttributes[itemAttributes.indexPath] = attr
            }
            return cachedItemsAttributes.map { $0.value }.filter { $0.frame.intersects(rect) }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        let collectionViewMidX: CGFloat = collectionView.bounds.size.width / 2
        guard let closestAttribute = findClosestAttributes(toXPosition: proposedContentOffset.x + collectionViewMidX) else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        return CGPoint(x: closestAttribute.center.x - collectionViewMidX, y: proposedContentOffset.y)
    }
    
    private func updateInsets() {
        guard let collectionView = collectionView else { return }
        let emptySpace = (collectionView.bounds.width - itemSize.width*3)/CGFloat(4)
        collectionView.contentInset.left = emptySpace
        collectionView.contentInset.right = emptySpace
    }
    
    private func findClosestAttributes(toXPosition xPosition: CGFloat) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        let searchRect = CGRect(
            x: xPosition - collectionView.bounds.width, y: collectionView.bounds.minY,
            width: collectionView.bounds.width * 2, height: collectionView.bounds.height
        )
        return layoutAttributesForElements(in: searchRect)?.min(by: { abs($0.center.x - xPosition) < abs($1.center.x - xPosition) })
    }
    
    func changeLayoutAttributes(_ attributes: CoverLayoutAttributes) {
        let collectionCenter = collectionView!.frame.size.width/2
        let offset = collectionView!.contentOffset.x
        let normalizedCenter = attributes.center.x - offset
    
        let maxDistance = self.itemSize.width + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        
        let ratio = (maxDistance - distance)/maxDistance
        let scale = ratio * (1 - self.scale) + self.scale
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
    }
    
    private var continuousFocusedIndex: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let offset = collectionView.bounds.width / 2 + collectionView.contentOffset.x - itemSize.width / 2
        return offset / (itemSize.width + (collectionView.bounds.width - itemSize.width*3)/CGFloat(4))
    }
    
    func  changeScrollPercentage(_ attributes: CoverLayoutAttributes) -> CoverLayoutAttributes{
        let roundedFocusedIndex = round(continuousFocusedIndex)
        if (attributes.indexPath.item == Int(roundedFocusedIndex)){
            let shiftArea = (roundedFocusedIndex - 0.5)...(roundedFocusedIndex + 0.5)
            let distanceToClosestIdentityPoint = min(abs(continuousFocusedIndex - shiftArea.lowerBound), abs(continuousFocusedIndex - shiftArea.upperBound))
            let normalizedShiftFactor = distanceToClosestIdentityPoint
            print(100-normalizedShiftFactor*2)
            attributes.scrollPercentage = 0+normalizedShiftFactor*2
        }
        return attributes
    }
}

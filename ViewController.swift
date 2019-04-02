//
//  ViewController.swift
//  CoverScroller
//
//  Created by Tomek on 26/03/2019.
//  Copyright © 2019 Tomek. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var tileArray:Array<Int> = []
    let itemHeight: CGFloat = CGFloat(200)
    var currentPage: Int = 0
    
    var collectionView : UICollectionView {
        return self.view as! UICollectionView
    }
    
    let layout = CoverLayout.init()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tileArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func loadView() {
        self.view = UICollectionView(frame:.zero, collectionViewLayout: self.layout)
        self.tileArray = Array(0...99)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "covecell", for: indexPath) as! CoverCell
        cell.numberLabel.text = String(tileArray[indexPath.row])
        cell.numberLabel.sizeToFit()
        cell.numberLabel.textColor = .white

        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let indexPath = IndexPath(item: self.currentPage + 1, section: 0)
        
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionView.collectionViewLayout.invalidateLayout() // layout update
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }, completion: nil)
    }
    
    private func findClosestAttributes(toXPosition xPosition: CGFloat) -> UICollectionViewLayoutAttributes? {
        let searchRect = CGRect(
            x: xPosition - collectionView.bounds.width, y: collectionView.bounds.minY,
            width: collectionView.bounds.width * 2, height: collectionView.bounds.height
        )
        return layout.layoutAttributesForElements(in: searchRect)?.min(by: { abs($0.center.x - xPosition) < abs($1.center.x - xPosition) })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tileArray = Array(0...99)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        layout.scrollDirection = .horizontal
        
        collectionView.register(CoverCell.self, forCellWithReuseIdentifier: "covecell")
        collectionView.backgroundColor = .white

        
    }

    private func getItemWidth() -> CGFloat{
        return ((collectionView.bounds.width) / CGFloat(3.0)) - 10
    }
    
    func  scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        self.currentPage = Int(roundedIndex)
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
    

    extension ViewController : UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }

}


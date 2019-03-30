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
        cell.backgroundColor = .blue
        return cell
    }
    
    private func setInset(newSize: CGSize?) {
        let YInset:CGFloat
        if !(newSize == nil){
            YInset = (newSize!.height - itemHeight)/2
        } else {
        YInset = (collectionView.bounds.height - itemHeight)/2
        }
        collectionView.contentInset = UIEdgeInsets(top: YInset, left: 5, bottom: YInset, right: 5)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setInset(newSize: size)
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionView.collectionViewLayout.invalidateLayout() // layout update
        }, completion: nil)
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
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        self.collectionView.scrollToItem(at: IndexPath(item: 12, section: 0), at: .left, animated: true)
//    }
}

    extension ViewController : UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let itemWidht: CGFloat = getItemWidth()
            setInset(newSize: nil)
            return CGSize(width: itemWidht, height: itemHeight)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
}


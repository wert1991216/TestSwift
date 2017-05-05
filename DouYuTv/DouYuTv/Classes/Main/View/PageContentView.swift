//
//  pageContentView.swift
//  DouYuTv
//
//  Created by chen on 17/5/4.
//  Copyright © 2017年 chen. All rights reserved.
//

import UIKit

private let ContentCellID =  "ContentCellID"

protocol pageContentViewDelegate:class {
    func pageContentView(contentView:PageContentView,progress:CGFloat , soureceIndex :Int , targetIndex :Int)
}


class PageContentView: UIView {
    
    weak var delegate : pageContentViewDelegate?
    public  var childVcs :[UIViewController]
    public weak var parentViewController : UIViewController?
    fileprivate var startOffsetX : CGFloat = 0
    fileprivate var isFobidScrollDelegate : Bool = false
    
    
    public lazy var collectionView : UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        return collectionView
        }()
    
    init(frame: CGRect ,childVcs:[UIViewController] ,parentViewController: UIViewController) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        
        setUpUI()
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension PageContentView{
    
    public func setUpUI(){
        for childVc in childVcs {
            parentViewController?.addChildViewController(childVc)
        }
        addSubview(collectionView)
        collectionView.frame = self.bounds
    }
    
}

extension PageContentView :UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let childVC = childVcs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView .addSubview(childVC.view)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
}

extension PageContentView{
    func setCurrentIndex(currentIndex:Int){
        
        isFobidScrollDelegate = true
        
        self.collectionView.contentOffset = CGPoint.init(x: kScreenW * (CGFloat)(currentIndex), y: 0)
        
    }
}

extension PageContentView :UICollectionViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

       if  isFobidScrollDelegate{
            return
        }
        
        var progress :CGFloat = 0
        var sourceIndex :Int = 0
        var targetIndex :Int = 0
        
        let currentOffsetX = scrollView.contentOffset.x
        if currentOffsetX > startOffsetX {  //左滑
            progress = currentOffsetX/kScreenW - floor(currentOffsetX/kScreenW)
            sourceIndex = (Int) (currentOffsetX / kScreenW)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            if currentOffsetX - startOffsetX == kScreenW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{
            progress = 1 - currentOffsetX/kScreenW + floor(currentOffsetX/kScreenW)
            targetIndex = (Int) (currentOffsetX / kScreenW)
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
                    print("progress:\(progress) soureIndex:\(sourceIndex) targetIndex:\(targetIndex)")
        delegate?.pageContentView(contentView: self, progress: progress, soureceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isFobidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
        }
}

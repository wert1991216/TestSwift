//
//  HomeViewController.swift
//  DouYuTv
//
//  Created by chen on 17/5/4.
//  Copyright © 2017年 chen. All rights reserved.
//

import UIKit

private let kTittleH :CGFloat = 40
class HomeViewController: UIViewController {
    //懒加载
    public lazy var pageTittleView :PageTittleView = {[weak self] in
        let tittleFrame = CGRect.init(x: 0, y: kNavBarH, width: kScreenW, height:kTittleH )
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let tittleView = PageTittleView(frame:tittleFrame,tittles:titles)
        tittleView.delegate = self as pageTittleViewDelegate?
        return tittleView
    }()
    
    public lazy var pageContentView :PageContentView = {
        let contentH = kScreenH - kNavBarH - kTittleH
        let contentFrame = CGRect.init(x: 0, y: kNavBarH + kTittleH, width: kScreenW, height: contentH)
        
      var childVcs = [UIViewController]()

    for _ in 0..<4 {
                    let vc = UIViewController()
                    vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
                    childVcs.append(vc)
                }
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self as pageContentViewDelegate?
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}
//mark : -设置UI
extension HomeViewController{
    
    public func setupUI(){
        setNavBar()
        
        automaticallyAdjustsScrollViewInsets = false
        view .addSubview(pageTittleView)
        
        view.addSubview(pageContentView)
        
    }
    
    private func setNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "logo")
        
        let size = CGSize.init(width: 40, height: 40)

        let historyItem = UIBarButtonItem(imageName: "image_my_history", hightImageName: "image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", hightImageName: "btn_search_clicked", size: size)
        let qrCodeItem = UIBarButtonItem(imageName: "Image_scan", hightImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrCodeItem]
    }
    
    
    
}


extension HomeViewController :pageContentViewDelegate{
    func pageContentView(contentView: PageContentView, progress: CGFloat, soureceIndex sourceIndex: Int, targetIndex: Int){
        self.pageTittleView.setscrollLinePosition(progress:progress,soureIndex:sourceIndex ,targetIndex:targetIndex)
    }
}

extension HomeViewController :pageTittleViewDelegate{
    func pageTittleView(tittleView: PageTittleView, selectedIndex: Int) {
        self.pageContentView .setCurrentIndex(currentIndex:selectedIndex )
    }
}





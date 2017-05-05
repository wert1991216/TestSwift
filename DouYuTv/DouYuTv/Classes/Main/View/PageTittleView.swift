//
//  PageTittleView.swift
//  DouYuTv
//
//  Created by chen on 17/5/4.
//  Copyright © 2017年 chen. All rights reserved.
//

import UIKit

protocol pageTittleViewDelegate:class {
    func pageTittleView(tittleView:PageTittleView,selectedIndex: Int)
}

public let ScrollLineH : CGFloat = 2
fileprivate let kNormalColor :(CGFloat,CGFloat,CGFloat) = (85,85,85)
fileprivate let kSelectedColor :(CGFloat,CGFloat,CGFloat) = (255,128,0)

class PageTittleView: UIView {
    
    public var tittles :[String]
    public var currentIndex :Int = 0
    weak var delegate : pageTittleViewDelegate?
    
    
    public lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = false
        scrollView.bounces = false
        return scrollView
    }()
    
    public lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    public lazy var tittleLabels : [UILabel] = [UILabel]()
    
    init(frame: CGRect ,tittles :[String]) {
        self.tittles = tittles
        super.init(frame : frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension PageTittleView{
    public func setupUI(){
        addSubview(scrollView)
        
        scrollView.frame = bounds
        
        setupTittles()
        
        setupButtonLineAndScrollLine()
    }
    
    private func setupButtonLineAndScrollLine(){
        let buttonLine = UIView()
        buttonLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        buttonLine.frame = CGRect.init(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(buttonLine)
        
        guard let firstLabel =  tittleLabels.first else {
            return
        }
        
        firstLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        
        scrollLine.frame = CGRect.init(x: firstLabel.frame.origin.x, y: firstLabel.frame.size.height - ScrollLineH + 2, width: firstLabel.frame.size.width, height: ScrollLineH)
        scrollView .addSubview(scrollLine)
        
    }
    
    private func setupTittles(){
        let labelW :CGFloat = frame.width / CGFloat(tittles.count)
        let labelH :CGFloat = frame.height - ScrollLineH
        let labelY :CGFloat = 0
        
        for (index,tittle) in tittles.enumerated() {
            let label = UILabel()
            label.text = tittle
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .center
            let labelX :CGFloat = labelW * CGFloat(index)
            label.frame = CGRect.init(x: labelX, y: labelY, width: labelW, height: labelH)
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(tittleLabelClicked(tapGes:)))
            label .addGestureRecognizer(tapGes)
            scrollView.addSubview(label)
            tittleLabels .append(label)
        }
    }
}

extension PageTittleView {
    @objc public  func tittleLabelClicked(tapGes:UITapGestureRecognizer){
        guard let currentLabel = tapGes.view as? UILabel else{
            return
        }
        
        let oldLabel = tittleLabels[currentIndex]
        
        if currentLabel == oldLabel {
            return
        }
        oldLabel.textColor =  UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        currentLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        currentIndex = currentLabel.tag
        let scrollLinePosition = (CGFloat)(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLinePosition
        }
        
        delegate?.pageTittleView(tittleView: self,selectedIndex:currentIndex)
    }
}

extension PageTittleView{
    func setscrollLinePosition(progress:CGFloat,soureIndex:Int,targetIndex:Int){
        let sourceLabel = tittleLabels[soureIndex]
        let targetLabel = tittleLabels[targetIndex]
        
        let totalX  =  targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = totalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        let colorDetail = (kSelectedColor.0 - kNormalColor.0,kSelectedColor.1 - kNormalColor.1,kSelectedColor.2 - kNormalColor.2)
        
        sourceLabel.textColor = UIColor(r: kSelectedColor.0 - colorDetail.0 * progress, g: kSelectedColor.1 - colorDetail.1 * progress, b: kSelectedColor.2 - colorDetail.2 * progress)
        
        targetLabel.textColor = UIColor(r: kNormalColor.0  + colorDetail.0 * progress, g: kNormalColor.1 +  colorDetail.1 * progress, b: kNormalColor.2  + colorDetail.2 * progress)
        
        currentIndex = targetIndex
    }
}

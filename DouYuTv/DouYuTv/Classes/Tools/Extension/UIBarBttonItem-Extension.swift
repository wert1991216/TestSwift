//
//  UIBarBttonItem-Extension.swift
//  DouYuTv
//
//  Created by chen on 17/5/4.
//  Copyright © 2017年 chen. All rights reserved.
//


import UIKit

extension UIBarButtonItem{
//    class func createItem(imageName: String ,hightImageName:String ,size :CGSize) ->UIBarButtonItem{
//        let btn = UIButton()
//        btn.setImage(UIImage.init(named: imageName), for: .normal)
//        btn.setImage(UIImage.init(named: hightImageName), for: .highlighted)
//        btn.frame = CGRect.init(origin: CGPoint.zero, size: size)
//       return UIBarButtonItem.init(customView: btn)
//    }
    //便利构造函数
   convenience init(imageName: String  ,hightImageName:String = "" ,size :CGSize = CGSize.zero) {
    let btn = UIButton()
    btn.setImage(UIImage(named: imageName), for: .normal)
    if hightImageName != "" {
        
    btn.setImage(UIImage(named: hightImageName), for: .highlighted)
    }
    if size == CGSize.zero {
        btn.sizeToFit()
    }
    else{
    btn.frame = CGRect(origin: CGPoint.zero, size: size)
    }
    self.init(customView : btn)
    
    }
}

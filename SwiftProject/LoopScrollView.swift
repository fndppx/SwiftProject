//
//  LoopScrollView.swift
//  SwiftProject
//
//  Created by SXJH on 2017/5/25.
//  Copyright © 2017年 SXJH. All rights reserved.
//

import UIKit

class LoopScrollView: UIView ,UIScrollViewDelegate{

    var contentScrollView:UIScrollView!
    var leftImageView:UIImageView!
    var currentImageView:UIImageView!
    var nextImageView:UIImageView!
    
    var imageArray:[URL]?{
        willSet(newValue){
            self.imageArray = newValue
        }
        
        didSet{
            self.setScrollViewOfImage()
        }
    }
    
    var urlImageArray: [String]? {
        willSet(newValue) {
            self.urlImageArray = newValue
        }
        
        didSet {
            //这里用了强制拆包，所以不要把urlImageArray设为nil
            for urlStr in self.urlImageArray! {
//                let urlImage = URL(string: urlStr)
//                if urlImage == nil { break }
//                let dataImage = try? Data(contentsOf: urlImage!)
//                if dataImage == nil { break }
//                let tempImage = UIImage(data: dataImage!)
//                if tempImage == nil { break }
                imageArray?.append(URL(string: urlStr)!)
            }
        }
    }

    var indexPage:Int!
    
    var timer:Timer!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience  init(frame: CGRect,imageArray : [URL?]?) {
        self.init(frame: frame)
        self.imageArray = imageArray as? [URL]
        self.indexPage = 0
        self.setupScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupScrollView() {
        
        self.contentScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        contentScrollView.contentSize = CGSize(width: self.frame.size.width*3, height: self.frame.size.height)
        contentScrollView.isPagingEnabled = true;
        contentScrollView.bounces = true;
        contentScrollView.delegate = self;
        contentScrollView.backgroundColor = UIColor.gray
        self.addSubview(contentScrollView)
        
        self.leftImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 200))
        contentScrollView.addSubview(leftImageView)
        
        self.currentImageView = UIImageView.init(frame: CGRect(x: self.frame.size.width, y: 0, width: self.frame.size.width, height: 200))
        contentScrollView.addSubview(currentImageView)

            
        self.nextImageView = UIImageView.init(frame: CGRect(x: self.frame.size.width*2, y: 0, width: self.frame.size.width, height: 200))
        contentScrollView.addSubview(nextImageView)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    
    }
    
    func timerAction() {
        contentScrollView.setContentOffset(CGPoint(x: self.frame.size.width*2, y: 0), animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        if offset == 0 {
            self.indexPage = self.getLastImageViewIndex(indexOfCurrentImage: self.indexPage)
        }else if offset == self.frame.size.width * 2 {
            self.indexPage = self.getNextImageViewIndex(indexOfCurrentImage: self.indexPage)
        }
        // 重新布局图片
        self.setScrollViewOfImage()
        //布局后把contentOffset设为中间
        scrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
        
        //重置计时器
        if timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
    
    func setScrollViewOfImage() {
//        print(self.imageArray?[indexPage])
        self.currentImageView.image = UIImage(data:try! Data(contentsOf: (self.imageArray?[indexPage])!))
        self.leftImageView.image = UIImage(data:try! Data(contentsOf: (self.imageArray?[self.getLastImageViewIndex(indexOfCurrentImage: indexPage)])!))
        self.nextImageView.image = UIImage(data:try! Data(contentsOf: (self.imageArray?[self.getNextImageViewIndex(indexOfCurrentImage: indexPage)])!))
    }
    func getNextImageViewIndex(indexOfCurrentImage index:Int) -> Int {
        let tempIndex = index+1
        return tempIndex < self.imageArray!.count ? tempIndex : 0
    }
    func getLastImageViewIndex(indexOfCurrentImage index:Int) -> Int {
        let tempIndex = index-1
        if tempIndex == -1 {
            return self.imageArray!.count-1
        }else{
            return tempIndex
        }
    }

}

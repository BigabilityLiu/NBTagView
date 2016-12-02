//
//  NBTagView.swift
//  TestTagView
//
//  Created by forwor on 16/9/19.
//  Copyright © 2016年 forwor. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum NBTagViewOrientationType {
    case horizontal,vertical
}
@objc protocol NBTagViewDelegate {
    @objc optional func nbTagView(_ tagView: NBTagView,didClickedAtIndex: Int)
    @objc optional func nbTagView(_ tagView: NBTagView,didRemoveTagAtIndex: Int)
    @objc optional func nbTagView(_ tagView: NBTagView,didAddedTagAtIndex: Int)
    @objc optional func nbTagView(_ tagView: NBTagView,didAddedTags: [String])
}
class NBTagView: UIView {

    var delegate: NBTagViewDelegate!
    //是否点击消除
    fileprivate var clickTagToDelete = true
    //消除时是否有动画
    fileprivate var deleteWithAnimate = true
    //消除时动画颜色
    fileprivate var animateColor: UIColor!
    //是否自适应frame，例：垂直分布的话，如果高度大于设定frame，是否自动适应frame
    var autoFitSize = true{
        didSet{
            setupView()
        }
    }
    
    var tags = [String](){
        didSet{
            setupButtons()
        }
    }
    fileprivate var buttons = [UIButton]()
 
    //button背景颜色
    var tagBackgroundColor: UIColor = UIColor.white{
        didSet{
            setupButtons()
        }
    }
    //button文字的颜色
    var tagTitleColor: UIColor = UIColor.black{
        didSet{
            setupButtons()
        }
    }
    //button边框的颜色
    var tagBorderColor: UIColor = UIColor.black{
        didSet{
            setupButtons()
        }
    }
    //样式，水平或者竖着
    var orientationType = NBTagViewOrientationType.horizontal{
        didSet{
            setupButtons()
        }
    }
    //标签的高度
    var tagHeight: CGFloat! = 30
    func addTag(_ title: String){
        self.delegate?.nbTagView?(self, didAddedTagAtIndex: tags.count - 1)
        tags.append(title)
    }
    func addTags(_ titles: [String]){
        self.delegate?.nbTagView?(self, didAddedTags: titles)
        for title in titles{
            tags.append(title)
        }
    }
    func addTag(_ title: String,atIndex:Int){
        var index = Int()
        if atIndex > tags.count{
            index = tags.count
        }else if atIndex < 0 {
            index = 0
        }else{
            index = atIndex
        }
        self.delegate?.nbTagView?(self, didAddedTagAtIndex: index)
        tags.insert(title, at: index)
    }
    func removeTag(_ tagIndex: Int){
        self.delegate?.nbTagView?(self, didRemoveTagAtIndex: tagIndex)
        tags.remove(at: tagIndex)
    }
    
    func setClickToDelete(_ toDelete: Bool,withAnimate: Bool){
        clickTagToDelete = toDelete
        deleteWithAnimate = withAnimate
//        self.animateColor = animateColor
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        setupButtons()
    }
    init(frame: CGRect,tags: [String],type: NBTagViewOrientationType){
        super.init(frame: frame)
        self.tags = tags
        self.orientationType = type
        setupButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews(){
        setupButtons()
    }
    
    fileprivate func setupButtons(){
        buttons.removeAll()
        for i in 0..<tags.count{
            let button = UIButton()
            button.backgroundColor = tagBackgroundColor
            button.setTitleColor(tagTitleColor, for: UIControlState())
            button.layer.borderColor = tagBorderColor.cgColor
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.layer.borderWidth = 2
            button.tag = i
            button.layer.cornerRadius = tagHeight/2
            button.setTitle(tags[i], for: UIControlState())
            button.addTarget(self, action: #selector(NBTagView.tagDidClicked(_:)), for: .touchUpInside)
            button.sizeToFit()
            buttons.append(button)
        }
        setupView()
    }
    fileprivate func setupView(){
        for i in self.subviews{
            i.removeFromSuperview()
        }
        if orientationType == .horizontal{
//            if autoFitSize{
//                if tagHeight > self.frame.height - 4{
//                    tagHeight = self.frame.height - 4
//                }
//            }
            let scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: self.frame.width,height: self.frame.height))
            for i in 0..<buttons.count{
                scrollView.alwaysBounceHorizontal = true
                let button = buttons[i]
                if i == 0{
                    button.frame = CGRect(x: 0, y: (self.frame.height - tagHeight)/2, width: button.frame.width+15, height: tagHeight)
                }else{
                    let preButton = buttons[i-1]
                    button.frame = CGRect(x: preButton.frame.maxX + 2, y: (self.frame.height - tagHeight)/2, width: button.frame.width + 15, height: tagHeight)
                }
                scrollView.addSubview(button)
                if button.frame.maxX >= scrollView.contentSize.width{
                    scrollView.contentSize.width = button.frame.maxX + 5
                }
            }
            self.addSubview(scrollView)
        }
        if orientationType == .vertical{
            let scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: self.frame.width,height: self.frame.height))
            var maxWidth:CGFloat = 0
            var j = 1
            for i in 0..<buttons.count{
                let button = buttons[i]
                if i == 0{
                    button.frame = CGRect(x: 0, y: 2, width: button.frame.width+15, height: tagHeight)
                }else{
                    let preButton = buttons[i-1]
                    if (preButton.frame.maxX + 2 + button.frame.width) > self.frame.width{
                        button.frame = CGRect(x: 0, y: preButton.frame.minY + tagHeight + 4, width: button.frame.width + 15, height: tagHeight)
                        j += 1
                    }else{
                        button.frame = CGRect(x: preButton.frame.maxX + 2, y: preButton.frame.minY, width: button.frame.width + 15, height: tagHeight)
                    }
                }
                if button.frame.maxX > maxWidth {maxWidth = button.frame.maxX}
                scrollView.addSubview(button)
                scrollView.contentSize = CGSize(width: maxWidth,height: (tagHeight+4)*CGFloat(j))
                if autoFitSize{
                    self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: scrollView.contentSize.height)
                    scrollView.frame = CGRect(x: 0,y: 0,width: self.frame.width,height: self.frame.height)
                }
                self.addSubview(scrollView)
            }
        }
    }
    
    fileprivate var deleteLayer = CALayer()
    @objc fileprivate func tagDidClicked(_ sender: UIButton){
        if clickTagToDelete{
            //如果有动画的话
            if deleteWithAnimate{
                UIView.animate(withDuration: 1, animations: {
                    sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    sender.alpha = 0
                    let anima = CAKeyframeAnimation(keyPath: "transform.rotation")
                    let value1 = NSNumber(value: -Float(M_PI/180*4) as Float)
                    let value2 = NSNumber(value: Float(M_PI/180*4) as Float)
                    let value3 = NSNumber(value: -Float(M_PI/180*4) as Float)
                    anima.values = [value1,value2,value3]
                    anima.repeatCount = MAXFLOAT;
                    sender.layer.add(anima, forKey: "shakeAnimation")
                    
                    }, completion: { (completed) in
                        self.removeTag(sender.tag)
                })
            }else{
                self.removeTag(sender.tag)
            }

        }
        delegate?.nbTagView?(self, didClickedAtIndex: sender.tag)
    }
    @objc fileprivate func removeTagAtIndex(_ timer: Timer){
        let userInfo = timer.userInfo as! NSDictionary
        let tag = userInfo["tag"] as! Int
        self.removeTag(tag)
    }
    fileprivate func brustLayer(_ frame: CGRect) -> CALayer{
        let dazLayer = CAEmitterLayer()
        dazLayer.emitterPosition = CGPoint(x: frame.width/2.0, y: frame.height/2.0);
        dazLayer.renderMode    = kCAEmitterLayerAdditive;//渲染模式
        
        let brust = CAEmitterCell()
        brust.birthRate		= 150;//粒子产生系数，默认1.0
        brust.emissionRange	= 2 * CGFloat(M_PI);  //周围发射角度
        brust.velocity		= 40;//速度
        brust.lifetime		= 0.75;
        
        brust.contents		= UIImage(named: "FFRing")?.cgImage
        brust.scale			= 0.15;//缩放比例
        if animateColor == nil{
            brust.color         = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).cgColor
            brust.redRange      = 0.5
            brust.greenRange    = 0.5
            brust.blueRange     = 0.5
            
        }else{
            brust.color			= animateColor.cgColor
        }
        
        dazLayer.emitterCells = [brust]

        return dazLayer
    }
}

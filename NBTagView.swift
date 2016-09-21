//
//  NBTagView.swift
//  TestTagView
//
//  Created by forwor on 16/9/19.
//  Copyright © 2016年 forwor. All rights reserved.
//

import UIKit

enum NBTagViewOrientationType {
    case horizontal,vertical
}
@objc protocol NBTagViewDelegate {
    optional func nbTagView(tagView: NBTagView,didClickedAtIndex: Int)
    optional func nbTagView(tagView: NBTagView,didRemoveTagAtIndex: Int)
}
class NBTagView: UIView {

    var delegate: NBTagViewDelegate!
    //是否点击消除
    var clickTagToDelete = true
    //是否自适应frame，例：垂直分布的话，如果高度大于设定frame，是否自动适应frame
    var autoFitSize = false
    
    var tags = [String](){
        didSet{
            setupButtons()
        }
    }
    var buttons = [UIButton]()
 
    //button背景颜色
    var tagBackgroundColor: UIColor = UIColor.whiteColor(){
        didSet{
            setupButtons()
        }
    }
    //button文字的颜色
    var tagTitleColor: UIColor = UIColor.blackColor(){
        didSet{
            setupButtons()
        }
    }
    //button边框的颜色
    var tagBorderColor: UIColor = UIColor.blackColor(){
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
    var tagHeight: CGFloat! = 30{
        didSet{
            setupButtons()
        }
    }
    
    func removeTag(tagIndex: Int){
        tags.removeAtIndex(tagIndex)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
    }
    init(frame: CGRect,tags: [String],type: NBTagViewOrientationType){
        super.init(frame: frame)
        self.tags = tags
        self.orientationType = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews(){
        print("layoutSubviews")
        setupButtons()
    }
    
    private func setupButtons(){
        buttons.removeAll()
        for i in 0..<tags.count{
            let button = UIButton()
            button.backgroundColor = tagBackgroundColor
            button.setTitleColor(tagTitleColor, forState: .Normal)
            button.layer.borderColor = tagBorderColor.CGColor
            
            button.titleLabel?.font = UIFont.systemFontOfSize(14)
            button.layer.borderWidth = 2
            button.tag = i
            button.layer.cornerRadius = tagHeight/2
            button.setTitle(tags[i], forState: .Normal)
            button.addTarget(self, action: #selector(NBTagView.tagDidClicked(_:)), forControlEvents: .TouchUpInside)
            button.sizeToFit()
            buttons.append(button)
        }
        setupView()
    }
    private func setupView(){
        for i in self.subviews{
            i.removeFromSuperview()
        }
        if orientationType == .horizontal{
            let scrollView = UIScrollView(frame: CGRectMake(0,0,self.frame.width,tagHeight + 4))
            for i in 0..<buttons.count{
                scrollView.alwaysBounceHorizontal = true
                let button = buttons[i]
                if i == 0{
                    button.frame = CGRectMake(0, (self.frame.height - tagHeight)/2, button.frame.width+10, tagHeight)
                }else{
                    let preButton = buttons[i-1]
                    button.frame = CGRectMake(preButton.frame.maxX + 2, (self.frame.height - tagHeight)/2, button.frame.width + 15, tagHeight)
                }
                scrollView.addSubview(button)
                if button.frame.maxX >= scrollView.contentSize.width{
                    scrollView.contentSize.width = button.frame.maxX + 5
                }
            }
            if autoFitSize{
                self.frame = CGRectMake(self.frame.minX, self.frame.minY, self.frame.width, tagHeight + 4)
            }
            self.addSubview(scrollView)
        }
        if orientationType == .vertical{
            let scrollView = UIScrollView(frame: CGRectMake(0,0,self.frame.width,self.frame.height))
            var maxWidth:CGFloat = 0
            var j = 1
            for i in 0..<buttons.count{
                let button = buttons[i]
                if i == 0{
                    button.frame = CGRectMake(0, 2, button.frame.width+10, tagHeight)
                }else{
                    let preButton = buttons[i-1]
                    if (preButton.frame.maxX + 2 + button.frame.width) > self.frame.width{
                        button.frame = CGRectMake(0, preButton.frame.minY + tagHeight + 4, button.frame.width + 15, tagHeight)
                        j += 1
                    }else{
                        button.frame = CGRectMake(preButton.frame.maxX + 2, preButton.frame.minY, button.frame.width + 15, tagHeight)
                    }
                }
                if button.frame.maxX > maxWidth {maxWidth = button.frame.maxX}
                scrollView.addSubview(button)
                scrollView.contentSize = CGSizeMake(maxWidth,(tagHeight+4)*CGFloat(j))
                if autoFitSize{
                    self.frame = CGRectMake(self.frame.minX, self.frame.minY, self.frame.width, scrollView.contentSize.height)
                    scrollView.frame = CGRectMake(0,0,self.frame.width,self.frame.height)
                }
                self.addSubview(scrollView)
            }
        }
    }

    @objc private func tagDidClicked(sender: UIButton){
        if clickTagToDelete{
            removeTag(sender.tag)
            delegate?.nbTagView?(self, didRemoveTagAtIndex: sender.tag)
        }
        delegate?.nbTagView?(self, didClickedAtIndex: sender.tag)
    }
}

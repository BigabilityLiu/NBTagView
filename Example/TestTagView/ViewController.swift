//
//  ViewController.swift
//  TestTagView
//
//  Created by forwor on 16/9/19.
//  Copyright © 2016年 forwor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var titles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titles = ["唐  僧","孙悟空","🐖八戒","沙和尚","唐  僧","孙悟空","🐖八戒","沙和尚"]
        setupNBView()
        setupNBView2()
        let button = UIButton(frame: CGRect(x: self.view.frame.width/2,y: self.view.frame.height-50,width: 100,height: 50))
        button.setTitle("添加标签", for: UIControlState())
        button.addTarget(self, action: #selector(ViewController.addTag), for: .touchUpInside)
        button.backgroundColor = UIColor.blue
        self.view.addSubview(button)
    }
    func addTag(){
        self.performSegue(withIdentifier: "goTableSegue", sender: nil)
        nbView2.addTag("❤️❤️❤️",atIndex: 7)
    }
    
    let nbView = NBTagView()
    func setupNBView(){
        nbView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 80)
        nbView.addTags(titles)
        nbView.delegate = self
        self.view.addSubview(nbView)
    }
    
    var nbView2 = NBTagView()
    func setupNBView2(){
        nbView2 =  NBTagView(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 30), tags: titles, type: NBTagViewOrientationType.vertical)
        nbView2.delegate = self
        self.view.addSubview(nbView2)

    }
}
extension ViewController: NBTagViewDelegate{
    func nbTagView(_ tagView: NBTagView, didClickedAtIndex: Int) {
        print("otherView -\(didClickedAtIndex)-")
    }
    func nbTagView(_ tagView: NBTagView, didRemoveTagAtIndex: Int) {
        print("didRemovedTag -\(didRemoveTagAtIndex)-")
    }
    func nbTagView(_ tagView: NBTagView, didAddedTagAtIndex: Int) {
        print(tagView.frame.height)
    }
}

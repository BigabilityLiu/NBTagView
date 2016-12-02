//
//  TableViewController.swift
//  TestTagView
//
//  Created by forwor on 16/9/22.
//  Copyright © 2016年 forwor. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,NBTagViewDelegate {
    
    var titles = [String]()
    var tagView: NBTagView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titles = ["唐  僧","唐  僧","孙悟空","🐖八戒","唐  僧","孙悟空","🐖八戒","唐  僧","孙悟空","🐖八戒","孙悟空","🐖八戒","唐  僧","孙悟空","🐖八戒"]
        tagView = NBTagView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40), tags: titles, type: NBTagViewOrientationType.vertical)
        tagView.delegate = self
//        tagView.tagTitleColor = UIColor.white
//        tagView.tagBackgroundColor = UIColor.black
//        tagView.tagBorderColor = UIColor.white
//        tagView.backgroundColor = UIColor.black
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tagView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tagView.frame.height
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = titles[(indexPath as NSIndexPath).row] 

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        titles.append("红孩儿")
        tagView.tags = titles
        tableView.reloadData()
    }
    
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


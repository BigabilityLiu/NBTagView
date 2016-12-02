# NBTagView
标签栏控件

##Useage
```swift
var tagView: NBTagView!
titles = ["唐  僧","孙悟空","🐖八戒","唐  僧","孙悟空","🐖八戒","唐  僧","孙悟空","🐖八戒","孙悟空","🐖八戒","唐  僧","孙悟空","🐖八戒"]
tagView = NBTagView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40), tags: titles, type:  NBTagViewOrientationType.vertical)
self.view.addSubview(tagView)
```
###Useage in TableView
```swift 
override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return tagView
}
override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return tagView.frame.height
}
```

##Property
```swift
var delegate: NBTagViewDelegate!

var autoFitSize = true
var tags = [String]()
//button背景颜色
var tagBackgroundColor: UIColor = UIColor.white
//button文字的颜色
var tagTitleColor: UIColor = UIColor.black
//button边框的颜色
var tagBorderColor: UIColor = UIColor.black
//样式，水平或者竖着
var orientationType = NBTagViewOrientationType.horizontal
//标签的高度
var tagHeight: CGFloat! = 30
```
##Function
```swift
func addTag(_ title: String)

func addTags(_ titles: [String])

func addTag(_ title: String,atIndex:Int)

func removeTag(_ tagIndex: Int)

func setClickToDelete(_ toDelete: Bool,withAnimate: Bool)
```
##Protocol
```swift
func nbTagView(_ tagView: NBTagView,didClickedAtIndex: Int)
func nbTagView(_ tagView: NBTagView,didRemoveTagAtIndex: Int)
func nbTagView(_ tagView: NBTagView,didAddedTagAtIndex: Int)
func nbTagView(_ tagView: NBTagView,didAddedTags: [String])
```
##Use Example
##Example 1
```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        titles = ["唐  僧","唐  僧","孙悟空","🐖八戒","唐  僧","孙悟空","🐖八戒","唐  僧","孙悟空","🐖八戒","孙悟空","🐖八戒","唐  僧","孙悟空","🐖八戒"]
        tagView = NBTagView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40), tags: titles, type: NBTagViewOrientationType.vertical)
        tagView.delegate = self
        tagView.tagTitleColor = UIColor.white
        tagView.tagBackgroundColor = UIColor.black
        tagView.tagBorderColor = UIColor.white
        tagView.backgroundColor = UIColor.black
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tagView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tagView.frame.height
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
```
##Example 2
```swift
    let nbView = NBTagView()
    nbView.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 80)
    nbView.addTags(["唐  僧","孙悟空","🐖八戒","沙和尚","唐  僧","孙悟空","🐖八戒","沙和尚"])
    self.view.addSubview(nbView)
```

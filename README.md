# SwiftProject


AnyHashable 桥接类型

swift 中 class_copyPropertyList 只能读取NSObject subclass ，所以对于有些类型如果需要class_copyPropertyList获取到,需要用AnyHashable声明

block

    var testResponse : (() -> ())?
    var updateBallViewCountdown : ((_ time:Double) -> ())?
    
    
设置属性

```
view.blockLogin = {(obj_bolck:String) in
               print(obj_bolck)
            }
```
            
 
oc 调用 swift的属性的时候 swift文件要给与初始值，并且不能加？ 或者 ！

    var isValid:Bool = false


GCD

```
timer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
            timer?.scheduleRepeating(deadline: .now(), interval: .seconds(1))
            timer?.setEventHandler(handler: {
                DispatchQueue.main.async {
                    self.timerCallback()
                }
            })
            timer?.resume()
```

          
单利

    class var sharedInstance: QCBallCountDownTouch {
        struct Static {
            static let instance: QCBallCountDownTouch = QCBallCountDownTouch.init(frame: CGRect.init(x: 0, y: 100, width: 49, height: 49))
        }
        
        return Static.instance
    }
    
    

Guard


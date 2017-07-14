# Swift Note


* Objc Swift混编的问题

>属性变量声明

swift 文件中声明的可选值?(基础变量如Bool,Int等)属性，在swift.h 桥接文件中是看不到的，并且通过class_copyPropertyList是获取不到相应的属性值的，针对这种情况需要在swift文件中声明属性的时候不能携带 !和？符号 并且需要在init方法中初始化此变量属性。

```
声明
 var totalDuration:Int
初始化
 override init() {
        self.totalDuration = 0
        super.init()
    }
```

* AnyHashable 类型对应 NSObject类型,Any对应id类型

>block

    var testResponse : (() -> ())?
    var updateBallViewCountdown : ((_ time:Double) -> ())?
    
    
设置属性

```
view.blockLogin = {(obj_bolck:String) in
               print(obj_bolck)
            }
```
            

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


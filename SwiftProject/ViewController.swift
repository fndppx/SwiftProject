//
//  ViewController.swift
//  SwiftProject
//
//  Created by SXJH on 2017/5/19.
//  Copyright © 2017年 SXJH. All rights reserved.
//

import UIKit
let array = ["LoopScrollView","AVPlayer","BallCountView","SizeClass","PlaySystemVoice"]
//字典的两种写法
let dic:NSDictionary = ["LoopScrollView":ViewControllerOptionType.loopScrollView as AnyObject,"AVPlayer":ViewControllerOptionType.avplayer as AnyObject,"BallCountView":ViewControllerOptionType.ballView,"SizeClass":ViewControllerOptionType.ballView,"PlaySystemVoice":ViewControllerOptionType.playSystemVoice]
//let dic:[String:AnyObject] = ["LoopScrollView":ViewControllerOptionType.loopScrollView as AnyObject,"AVPlayer":ViewControllerOptionType.avplayer as AnyObject]

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "testcell")
        cell.textLabel?.text = array[indexPath.row];
//        dic.keys.index(0, offsetBy: 1)
//        dic.index(forKey: <#T##String#>)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let vc:SizeClassViewController =  UIStoryboard.init(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "SizeClass") as! SizeClassViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        let vc:SecondViewController =  UIStoryboard.init(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        let key:String = array[indexPath.row]
        
        vc.optionType = dic.object(forKey: key) as? ViewControllerOptionType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    


}


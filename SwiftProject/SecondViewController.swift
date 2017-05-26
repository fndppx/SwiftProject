
//
//  SecondViewController.swift
//  SwiftProject
//
//  Created by SXJH on 2017/5/23.
//  Copyright © 2017年 SXJH. All rights reserved.
//
//http://vid-17028.vod.chinanetcenter.broadcastapp.agoraio.cn/live-d831054b-8e83-4dc3-a161-0e55d433f877--20170406194436.mp4

//http://vid-17028.vod.chinanetcenter.broadcastapp.agoraio.cn/live-4cbc6b73-e2a9-48a5-90f3-c6d34f941824--20170302203036.mp4

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //轮播图
        let sc = LoopScrollView.init(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 200), imageArray: [URL(string: "http://cnstatic01.e.vhall.com/upload/webinars/img_url/14/07/1407086d801f383187d87a0b79feac78.png?size=640x360"),URL(string: "http://pic32.nipic.com/20130815/10675263_110224052319_2.jpg")])
        self.view.addSubview(sc)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}

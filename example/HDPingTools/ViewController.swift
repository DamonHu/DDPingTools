//
//  ViewController.swift
//  HDPingTools
//
//  Created by Damon on 2021/1/4.
//

import UIKit
import ZXKitCore

class ViewController: UIViewController {
    let pingTools = HDPingTools(hostName: "www.apple.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(start), for: .touchUpInside)

    }

    @objc func start() {
//        if pingTools.isPing {
//            pingTools.stop()
//        } else {
//            pingTools.start(pingType: .any, interval: .second(2)) { (response, error) in
//                if let error = error {
//                    print(error)
//                }
//            }
//        }

        ZXKit.regist(plugin: pingTools)
        ZXKit.show()
    }

    
}


//
//  ViewController.swift
//  DDPingTools
//
//  Created by Damon on 2021/1/4.
//

import UIKit

class ViewController: UIViewController {
    let pingTools = DDPingTools(hostName: "www.apple.com")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        let button = UIButton(type: .custom)
        button.setTitle("开始", for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 40)
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(start), for: .touchUpInside)


        let button2 = UIButton(type: .custom)
        button2.setTitle("结束", for: .normal)
        button2.frame = CGRect(x: 100, y: 200, width: 100, height: 40)
        button2.backgroundColor = UIColor.red
        self.view.addSubview(button2)
        button2.addTarget(self, action: #selector(stop), for: .touchUpInside)
    }

    @objc func start() {
        pingTools.start(pingType: .any, interval: .second(2)) { (response, error) in
            if let error = error {
                print(error)
            }
        }
    }

    @objc func stop() {
        pingTools.stop()
    }
    
}


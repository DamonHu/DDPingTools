//
//  HDPingNetworkActivityIndicator.swift
//  HDPingTools
//
//  Created by Damon on 2021/12/7.
//

import UIKit

class HDPingNetworkActivityIndicator {
    static let shared = HDPingNetworkActivityIndicator()
    var statusBarStyle: UIStatusBarStyle = .lightContent

    var isHidden = false {
        willSet {
            self.mIndicatorWindow.isHidden = newValue
        }
    }

    private init(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self._createUI()
            self.isHidden = false
            self.mIndicatorWindow.makeKeyAndVisible()
        }
    }

    func update(time: Int) {
        self.mLabel.isHidden = !HDPingTools.showNetworkActivityIndicator
        self.mLabel.text = "\(time)ms"
    }


    //MARK: UI
    lazy var mLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()

    lazy var mIndicatorWindow: UIWindow = {
        var window = UIWindow(frame: .zero)
        window.backgroundColor = UIColor.clear
        window.windowLevel = .statusBar + 1
        window.isUserInteractionEnabled = false
        return window
    }()
}

private extension HDPingNetworkActivityIndicator {
    func _createUI() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.windows.first?.windowScene, let statusBarManager = windowScene.statusBarManager {
                mIndicatorWindow.windowScene = windowScene
                mIndicatorWindow.frame = statusBarManager.statusBarFrame
                self.statusBarStyle = statusBarManager.statusBarStyle
            }
        } else {
            mIndicatorWindow.frame = UIApplication.shared.statusBarFrame
            self.statusBarStyle = UIApplication.shared.statusBarStyle
        }
        if self.statusBarStyle == .lightContent {
            self.mLabel.textColor = .lightText
        } else if self.statusBarStyle == .darkContent {
            self.mLabel.textColor = .darkText
        }
        print(mIndicatorWindow.frame.size.height)
        self.mIndicatorWindow.addSubview(mLabel)
        mLabel.snp.makeConstraints { make in
            if mIndicatorWindow.frame.size.height > 30 {
                make.right.equalToSuperview().offset(-40)
                make.top.equalToSuperview()
            } else {
                make.centerX.equalToSuperview().offset(self.mIndicatorWindow.frame.size.width/4)
                make.centerY.equalToSuperview()
            }
        }
    }
}

//
//  TabBarController.swift
//  DCard
//
//  Created by Fei Zhang on 2023/1/3.
//  Copyright © 2023 Flashwire. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    // tabBar viewcontrollers
    var tabVCs: [TabbarItem] = {
        var vcs: [TabbarItem] = []
        vcs.append(TabbarItem(title: "", vc: CardViewController(), normalImage: "iconTabbarCard", selectedImage: "iconTabbarCardSelected"))
        vcs.append(TabbarItem(title: "", vc: HomeViewController(), normalImage: "iconTabbarHome", selectedImage: "iconTabbarHomeSelected"))
        vcs.append(TabbarItem(title: "", vc: WalletViewController(), normalImage: "iconTabbarWallet", selectedImage: "iconTabbarWalletSelected"))
        return vcs
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        tabBar.backgroundColor = .white
        let maskLayer = CAShapeLayer()
        maskLayer.frame = .init(origin: .zero, size: .init(width: tabBar.width, height: tabBar.height+STATUSBARHEIGHT))
        maskLayer.path = UIBezierPath(roundedRect: .init(origin: .zero, size: maskLayer.frame.size), byRoundingCorners: [.topLeft, .topRight], cornerRadii: .init(width: 20, height: 20)).cgPath
        tabBar.layer.mask = maskLayer
    }

    private func setupViewControllers() {
        for item in tabVCs {
            addChildVC(childVC: item.vc,
                       title: item.title,
                       normalImage: item.normalImage,
                       selectedImage: item.selectedImage)
        }
        selectedIndex = 1
    }

    private func addChildVC(childVC: UIViewController, title: String, normalImage: String, selectedImage: String) {
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .highlighted)
        var img = UIImage(named: normalImage)
        img = img?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        var selectedImg = UIImage(named: selectedImage)
        selectedImg = selectedImg?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        childVC.tabBarItem.image = img
        childVC.tabBarItem.selectedImage = selectedImg
        childVC.title = title
        let nav = UINavigationController(rootViewController: childVC)
        addChild(nav)
    }
}

struct TabbarItem {
    let title: String
    let vc: UIViewController
    let normalImage: String
    let selectedImage: String
}


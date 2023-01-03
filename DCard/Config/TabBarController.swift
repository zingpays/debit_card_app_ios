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
//        vcs.append(TabbarItem(title: R.string.localizable.homeTitle(), vc: HomeViewController(), normalImage: "house", selectedImage: "house.fill"))
//        vcs.append(TabbarItem(title: R.string.localizable.settingTitle(), vc: SettingViewController(), normalImage: "gearshape", selectedImage: "gearshape.fill"))
        return vcs
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }

    private func setupViewControllers() {
        for item in tabVCs {
            addChildVC(childVC: item.vc,
                       title: item.title,
                       normalImage: item.normalImage,
                       selectedImage: item.selectedImage)
        }
    }

    private func addChildVC(childVC: UIViewController, title: String, normalImage: String, selectedImage: String) {
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .highlighted)
        // TODO: test code is here
        var img = UIImage(systemName: normalImage)//UIImage(named: normalImage)
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


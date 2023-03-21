//
//  TabbarViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class TabbarViewController: UITabBarController, UITabBarControllerDelegate{
    
    
    var currentUserEmail: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    
        let bucketListViewController = ViewController()
        let bucketListViewControllerBarItem = UITabBarItem(title: "Bucket List", image: UIImage(systemName: "trophy"), selectedImage: UIImage(systemName: "trophy.fill"))
        bucketListViewController.tabBarItem = bucketListViewControllerBarItem
        
        let myCheckListViewController = UINavigationController(rootViewController: MyCheckListViewController())
        let myCheckListViewControllerBarItem = UITabBarItem(title: "Check List", image: UIImage(systemName: "checklist"), selectedImage: UIImage(systemName: "checklist.checked"))
        myCheckListViewController.tabBarItem = myCheckListViewControllerBarItem
        
        
        
        let groupCheckRootViewController = GroupListViewController()
        let groupCheckListViewController = UINavigationController(rootViewController: groupCheckRootViewController)
        let groupCheckListViewControllerBarItem = UITabBarItem(title: "Group List", image: UIImage(systemName: "person.and.person"), selectedImage: UIImage(systemName: "person.and.person.fill"))
        groupCheckListViewController.tabBarItem = groupCheckListViewControllerBarItem
        groupCheckRootViewController.currentUserEmail = self.currentUserEmail
        
        
        
        
        let myAccountRootViewController = MyAccountViewController()
        let myAccountViewController = UINavigationController(rootViewController: myAccountRootViewController)
        
        let myAccountViewControllerBarItem = UITabBarItem(title: "ETC", image:UIImage(systemName: "ellipsis.circle"), selectedImage: UIImage(systemName: "ellipsis.circle.fill"))
        myAccountRootViewController.currentUserEmail = self.currentUserEmail
        myAccountViewController.tabBarItem = myAccountViewControllerBarItem
        
        self.viewControllers = [bucketListViewController,myCheckListViewController,groupCheckListViewController,myAccountViewController]
    }
}

//
//  SceneDelegate.swift
//  BlueCheck
//
//  Created by duck on 2023/01/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // 루트 뷰 컨트롤러가 될 뷰 컨트롤러를 생성합니다.
        let rootViewController = LogInViewController()
        // 위에서 생성한 뷰 컨트롤러로 내비게이션 컨트롤러를 생성합니다.
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
//        let tabBarController = UITabBarController()
//        let bucketListViewController = ViewController()
//        let myCheckListViewController = UINavigationController(rootViewController: MyCheckListViewController())
//        let groupCheckListViewController = UINavigationController(rootViewController: GroupListViewController())
//        let myAccountViewController = MyAccountViewController()
//
//        tabBarController.setViewControllers([bucketListViewController,myCheckListViewController,groupCheckListViewController,myAccountViewController], animated: true)
//
//        if let item = tabBarController.tabBar.items{
//            item[0].selectedImage = UIImage(systemName: "eye.fill")
//            item[0].image = UIImage(systemName: "eye")
//            item[0].title = "Bucket List"
//
//            item[1].selectedImage = UIImage(systemName: "checklist.checked")
//            item[1].image = UIImage(systemName: "checklist")
//            item[1].title = "Check List"
//
//            item[2].selectedImage = UIImage(systemName: "rectangle.3.group.bubble.left")
//            item[2].image = UIImage(systemName: "rectangle.3.group.bubble.left")
//            item[2].title = "Group List"
//
//            item[3].selectedImage = UIImage(systemName: "ellipsis.circle")
//            item[3].image = UIImage(systemName: "ellipsis.circle")
//            item[3].title = "ETC"
//        }
        
        

        // 윈도우의 루트 뷰 컨트롤러로 내비게이션 컨트롤러를 설정합니다.
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        self.window?.windowScene = windowScene
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


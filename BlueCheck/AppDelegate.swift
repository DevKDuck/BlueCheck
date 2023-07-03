//
//  AppDelegate.swift
//  BlueCheck
//
//  Created by duck on 2023/01/10.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        var window: UIWindow?
        // 13이상인 경우에는 SceneDelegate에서 이미 초기화 되었으니까 바로 return
        if #available(iOS 13.0, *) {
            FirebaseApp.configure()
            
            //MARK: FirebaseMessaging 푸시 권한 세팅
            Messaging.messaging().token{ token, error in
                if let error = error{
                    print("ERROR FCM 등록 토큰 가져오기: \(error.localizedDescription)")
                }
                else if let token = token{
                    print("FCM 등록 토큰: \(token)")
                }
            }
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
            
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions){ _, error in
                print("ERROR, Request Notifications Authorization:\(error.debugDescription)")
            }
            application.registerForRemoteNotifications()
            
            return true
        }
        
        // 13이전의 경우에는 SceneDelegate에서 해주었던 작업을 그대로 진행해주면 된다.
        window = UIWindow()
        
        //MARK: 로그인 뷰시작 설정
        //        window?.rootViewController = StartAnimationViewController() // 초기 ViewController
        
        window?.rootViewController = LogInViewController()
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        return true
        
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}



extension AppDelegate: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .badge, .sound])
    }
}

extension AppDelegate: MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else {return}
        print("FCM 등록토큰 갱신: \(token)")
    }
}

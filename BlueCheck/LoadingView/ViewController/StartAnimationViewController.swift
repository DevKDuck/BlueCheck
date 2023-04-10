//
//  StartAnimationViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/03/22.
//

import UIKit
import Lottie
import FirebaseAuth

class StartAnimationViewController: UIViewController{
    
    private var animationView: LottieAnimationView = .init(name:"BlueCheck.json")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let time = DispatchTime.now() + 5.0
        DispatchQueue.main.asyncAfter(deadline: time){ [weak self] in
                self?.goViewController()
            
            
        }
        
        
        self.view.backgroundColor = .white
        self.view.addSubview(animationView)
        animationView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height/2)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
//        animationView.animationSpeed = 1
        animationView.play()
    }
    
    func goViewController()
    {
        let rootVC = LogInViewController()
        
        let navigation = UINavigationController(rootViewController: rootVC)
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: true)
        
//        rootVC.modalPresentationStyle = .fullScreen
//        self.present(rootVC, animated: true)
    }
    
    
}

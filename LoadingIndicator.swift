//
//  LoadingIndigator.swift
//  BlueCheck
//
//  Created by duck on 2023/04/13.
//

import UIKit

class LoadingIndicator{
    static func showLoading(){
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.last else {return}
            
            let loadingIndicatorView: UIActivityIndicatorView
            
            if let existedView = window.subviews.first(where: {$0 is UIActivityIndicatorView}) as?UIActivityIndicatorView {
                loadingIndicatorView = existedView
            }
            else{
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.color = .systemBlue
                window.addSubview(loadingIndicatorView)
            }
            
            loadingIndicatorView.startAnimating()
        }
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.last else {return}

            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
    
}

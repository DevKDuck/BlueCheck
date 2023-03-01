//
//  InvitationGroupContentViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/28.
//

import UIKit

class InvitationGroupContentViewController: UIViewController{
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.layer.cornerRadius = 10
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var cancelButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tapCancelButoon(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapCancelButoon(_ sender: UIButton){
        dismiss(animated: true)
    }
    
    let centerView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        uiView.layer.cornerRadius = 10
        return uiView
    }()
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .darkGray
        return label
    }()
    
    let objectLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        label.textColor = .darkGray
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setLayoutConstraints()
        
    }
    
    
    private func setLayoutConstraints(){
        self.view.addSubview(scrollView)
        scrollView.addSubview(centerView)
        centerView.addSubview(titleLabel)
        centerView.addSubview(cancelButton)
        centerView.addSubview(objectLabel)
        centerView.addSubview(contentLabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        centerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        objectLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
       

        NSLayoutConstraint.activate([
            
//
//            self.view.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
//            self.view.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
//            self.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3),
//            self.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
            
            scrollView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 20),
            scrollView.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 3),
            scrollView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            
//            centerView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 20),
//            centerView.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 3),
//            centerView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
//            centerView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            
            centerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            centerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            centerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            centerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            ])
        
        centerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let contentViewHeight = centerView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
        NSLayoutConstraint.activate([
            
          
            
            cancelButton.trailingAnchor.constraint(equalTo: self.centerView.trailingAnchor, constant: -15),
            cancelButton.topAnchor.constraint(equalTo: self.centerView.topAnchor, constant: 15),
            cancelButton.widthAnchor.constraint(equalToConstant: 44),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.centerView.leadingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: self.centerView.topAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.cancelButton.leadingAnchor, constant: -5),
            
            
            objectLabel.leadingAnchor.constraint(equalTo: self.centerView.leadingAnchor, constant: 15),
            objectLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            
            contentLabel.topAnchor.constraint(equalTo: self.objectLabel.bottomAnchor, constant: 15),
            contentLabel.leadingAnchor.constraint(equalTo: self.centerView.leadingAnchor, constant: 15),
            contentLabel.trailingAnchor.constraint(equalTo: self.centerView.trailingAnchor, constant: -15),
            contentLabel.bottomAnchor.constraint(equalTo: self.centerView.bottomAnchor, constant: -10)
            
            
        
        ])
        
        
        
    }
    
}

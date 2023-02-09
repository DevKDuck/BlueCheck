//
//  LogInRequestViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/02/08.
//

import UIKit


class LogInRequestViewController: UIViewController {
    
    //MARK: 임시 뒤로가기 버튼
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("x", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 40, weight: .bold)
        button.addTarget(self, action: #selector(tapBackButton(_:)), for: .touchUpInside)
        
        return button
    }()
    @objc func tapBackButton(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    
    
    
    let blueCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "Blue Check"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .systemBlue
        return label
    }()
    
    let logInRequestDescrpitionLabel: UILabel = {
        let label = UILabel()
        label.text = "그룹 리스트 사용을 위해 \n 로그인 버튼을 눌러주세요!"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.textAlignment = . center
        label.numberOfLines = 2
        return label
    }()
    
    lazy var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(tapLogIntButton(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func tapLogIntButton(_ sender: UIButton){
        let goLogInButtonViewContoller = LogInViewController()
        
        goLogInButtonViewContoller.modalPresentationStyle = .fullScreen
        self.present(goLogInButtonViewContoller, animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setLayoutConstraints()
    }
    
    
    private func setLayoutConstraints(){
        self.view.addSubview(backButton)
        self.view.addSubview(blueCheckLabel)
        self.view.addSubview(logInRequestDescrpitionLabel)
        self.view.addSubview(logInButton)
        
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        blueCheckLabel.translatesAutoresizingMaskIntoConstraints = false
        logInRequestDescrpitionLabel.translatesAutoresizingMaskIntoConstraints = false
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            
            backButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            backButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            
            blueCheckLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            blueCheckLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            
            logInRequestDescrpitionLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            logInRequestDescrpitionLabel.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            
            logInButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            logInButton.topAnchor.constraint(equalTo: self.logInRequestDescrpitionLabel.bottomAnchor, constant: 10),
            logInButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 16),
            logInButton.widthAnchor.constraint(equalToConstant: self.view.bounds.width / 3),
            
            
        ])
        
    }
}

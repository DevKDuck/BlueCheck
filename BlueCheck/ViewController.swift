//
//  ViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/10.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK: TableView 설정
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BucketListTableViewCell.self, forCellReuseIdentifier: "BucketListTableViewCell")
        
        setConstraint()
        self.view.addSubview(tableView)
        
        //크기와 위치 CGRect를 이용하여 지정, 테이블 뷰의 데이터와 화면변화를 VC에서 처리할 것이기 때문에 self 로 지정
        //register 메서드를 이용하여 재사용할 셀을 등록해줌
    }
    
    private func setConstraint() {

        self.view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

           tableView.topAnchor.constraint(equalTo: self.view.topAnchor),

           tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

           tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),

           tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)

        ])

    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BucketListTableViewCell", for: indexPath) as? BucketListTableViewCell else {return UITableViewCell()}
        return cell
    }
}


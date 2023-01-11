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
    var tasks =  [BucketListTasks]()
    
    let topView: UIView = {
       let topview = UIView()
        topview.backgroundColor = .white
       return topview
   }()
    
    let addButton: UIButton = {
        let button = UIButton()
//        button.setTitle("+", for: .normal)
//        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(showAlert(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func showAlert(_ sender: UIButton){
        let alert = UIAlertController(title: "버킷 리스트", message: "올해 이루고 싶은 목표를 적어보세요", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default){ [weak self] _ in
            guard let title = alert.textFields?[0].text else {return}
            let task = BucketListTasks(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel){ (cancel) in
            //취소 눌렀을때
        }
        
        alert.addTextField{ textField in
            textField.placeholder = "꿈을 펼쳐보세요"
            textField.textColor = .systemBlue
        }
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert,animated: true,completion: nil)
    }
    
    
    let topViewCenterLabel : UILabel = {
        let label = UILabel()
        label.text = "버킷 리스트"
        label.textColor = .systemBlue
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //MARK: TableView 설정
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BucketListTableViewCell.self, forCellReuseIdentifier: "BucketListTableViewCell")
        
        setConstraint()
        
        //크기와 위치 CGRect를 이용하여 지정, 테이블 뷰의 데이터와 화면변화를 VC에서 처리할 것이기 때문에 self 로 지정
        //register 메서드를 이용하여 재사용할 셀을 등록해줌
    }
    
    private func setConstraint() {
        
        self.view.addSubview(topView)
        self.view.addSubview(addButton)
        self.view.addSubview(topViewCenterLabel)
        self.view.addSubview(tableView)
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        topViewCenterLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50),
            
            addButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -10),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            
            topViewCenterLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            topViewCenterLabel.centerXAnchor.constraint(equalTo: self.topView.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BucketListTableViewCell", for: indexPath) as? BucketListTableViewCell else {return UITableViewCell()}
        let task = self.tasks[indexPath.row]
        cell.label.text = task.title
        cell.label.textColor = .darkGray
        
        if task.done{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    //Row 선택시
}


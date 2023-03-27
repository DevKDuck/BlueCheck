//
//  ViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/10.
//

import UIKit

class BucketListViewController: UIViewController {
    
    //MARK: 변수 설정 
    var tableView: UITableView!
    
    //MARK: 추가
    var task: [BucketListTask] = [BucketListTask(title: "🔥이 곳에 여러분의 꿈을 적어보아요🔥", done: true),BucketListTask(title: "블루체크 앱을 이용해 더 멋진 사람되기 달성👋👋👋", done: false)]

    let topView: UIView = {
       let topview = UIView()
        topview.backgroundColor = .white
       return topview
   }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(showAlert(_:)), for: .touchUpInside)
        return button
    }()
    
    
    
    @objc func showAlert(_ sender: UIButton){
        let alert = UIAlertController(title: "버킷 리스트", message: "올해 이루고 싶은 목표를 적어보세요", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default){ [weak self] _ in
            guard let title = alert.textFields?[0].text else {return}
            
            //TextField가 비어있지 않을때만 저장하도록함
            if title != ""{
                self?.task.append(BucketListTask(title: title, done: true))
                let encoder = JSONEncoder()
                
                if let encoded = try? encoder.encode(self?.task){
                    UserDefaults.standard.setValue(encoded, forKey: "BucketListTasks UserDefaults")
                }

            }
            self?.tableView.reloadData()        }
        
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
        label.font = UIFont(name: "Maplestory OTF Bold.otf", size: 14)
        return label
    }()
    

    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        //MARK: TableView 설정
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BucketListTableViewCell.self, forCellReuseIdentifier: "BucketListTableViewCell")
        
//        MARK: UserDefualt 모두 삭제
//                for key in UserDefaults.standard.dictionaryRepresentation().keys {
//                    UserDefaults.standard.removeObject(forKey: key.description)
//                }
        
        getBucketListUserDefaultData()
        setConstraint()

        
        //크기와 위치 CGRect를 이용하여 지정, 테이블 뷰의 데이터와 화면변화를 VC에서 처리할 것이기 때문에 self 로 지정
        //register 메서드를 이용하여 재사용할 셀을 등록해줌
    }
    
    func getBucketListUserDefaultData(){
        if let savedData = UserDefaults.standard.object(forKey: "BucketListTasks UserDefaults") as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode([BucketListTask].self, from: savedData){
                task = savedObject
            }
        }
    }
    
    //MARK: AutoLayout 지정
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
            topView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            topView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            topView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topView.heightAnchor.constraint(equalToConstant: 50),
            
            addButton.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -10),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.widthAnchor.constraint(equalToConstant: 44),
            
            topViewCenterLabel.centerYAnchor.constraint(equalTo: self.topView.centerYAnchor),
            topViewCenterLabel.centerXAnchor.constraint(equalTo: self.topView.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
    }
}

extension BucketListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.task.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BucketListTableViewCell", for: indexPath) as? BucketListTableViewCell else {return UITableViewCell()}
        
        cell.label.text = task[indexPath.row].title
        task[indexPath.row].done ? cell.checkButton.setImage(UIImage(systemName: "squareshape"), for: .normal) : cell.checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        
        cell.contentView.backgroundColor = task[indexPath.row].done ? .white : UIColor(hue: 0.5944, saturation: 0.34, brightness: 1, alpha: 1.0)
        
        
        cell.checkButton.addTarget(self, action: #selector(pressedCheckButton(_:)), for: .touchUpInside)
        cell.checkButton.tag = indexPath.row
        
        
        
        return cell
    }
    
    @objc func pressedCheckButton(_ sender: UIButton){
        switch task[sender.tag].done{
        case true:
            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            task[sender.tag].done = false
        case false:
            sender.setImage(UIImage(systemName: "squareshape"), for: .normal)
            task[sender.tag].done = true
        }
    
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.task) {
            UserDefaults.standard.setValue(encoded, forKey: "BucketListTasks UserDefaults")
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "버킷 리스트", message: "올해 이루고 싶은 목표를 적어보세요", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .default){ [weak self] _ in
            guard let title = alert.textFields?[0].text else {return}
            self?.task[indexPath.row].title = title

            if self?.task[indexPath.row].title == ""{
                self?.task.remove(at: indexPath.row)
            }
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(self?.task) {
                UserDefaults.standard.setValue(encoded, forKey: "BucketListTasks UserDefaults")
            }
            
            self?.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel){ _ in
            //취소 눌렀을때
        }
        
        alert.addTextField{ textField in
            textField.text = self.task[indexPath.row].title
            textField.textColor = .systemBlue
        }
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert,animated: true,completion: nil)
        
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    
    
    //Row 선택시
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    //cell 의 높이 설정
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        self.task.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.task) {
            UserDefaults.standard.setValue(encoded, forKey: "BucketListTasks UserDefaults")
        }
        
    }
}


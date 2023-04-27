//
//  MyCheckListViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/10.
//

import UIKit


protocol MyCheckListTableViewDelegate: AnyObject{
    func delegateFunction()
}



class MyCheckListViewController: UIViewController, MyCheckListTableViewDelegate{
    
    func delegateFunction(){
        if let savedData = UserDefaults.standard.object(forKey: translateObjectKey) as? Data{
            let decoder = JSONDecoder()
            
            do{
                let saveObject = try decoder.decode([MyCheckListTask].self, from:savedData)
                
                if saveObject.isEmpty{
                    print("tableView를 재설정했을 경우 인스턴스는 생성했지만 비어있습니다.")
                }
                else{
                    taskArray = saveObject
                }
            }
            catch{
                print("This day \(translateObjectKey) have no UserDefaultData")
            }
        }
        else{
            taskArray = [MyCheckListTask]()
        }
        checkUserDefaultsTasks()
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    var taskArray: [MyCheckListTask]?
    
    let now = Date()
    var cal = Calendar.current
    let dateFormatter = DateFormatter()
    var components = DateComponents()
    var days: [String] = []
    var daysCountInMonth = 0
    var weekdayAdding = 0
    var haveScheduleArray = [Bool]()
    
    var translateObjectKey = ""
    
    var firstDayGapToday: Int = 0
    
    lazy var addTaskButton : UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50)
        button.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(tapAddTaskButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func tapAddTaskButton(_ sender: UIButton){
        let goMyCheckListSettingViewController = MyCheckListSettingViewController()
        goMyCheckListSettingViewController.delegate = self
        goMyCheckListSettingViewController.taskAddOrModify = 0 // 추가
        goMyCheckListSettingViewController.objectKey = translateObjectKey
        
        //        self.navigationController?.pushViewController(goMyCheckListSettingViewController, animated: true)
        self.present(goMyCheckListSettingViewController, animated: true, completion: nil)
    }
    
    
    lazy var preMonthButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(tapPreMonthButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var nextMonthButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(tapNextMonthButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func tapPreMonthButton(_ sender: UIButton){
        components.month = components.month! - 1
        
        
        self.calculation()
        checkUserDefaultsTasks()
        self.collectionView.reloadData()
    }
    
    @objc func tapNextMonthButton(_ sender: UIButton){
        components.month = components.month! + 1
        
        self.calculation()
        checkUserDefaultsTasks()
        self.collectionView.reloadData()
    }
    
    private var yearMonthLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    //연도, 월
    
    private var weekStackView = UIStackView()
    //일~토 요일 StackView
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.getCollectionViewLayout())
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyCheckListTableViewCell.self, forCellReuseIdentifier: "MyCheckListTableViewCell")
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setComponentDate()
        
        //MARK: UserDefualt 모두 삭제
//                for key in UserDefaults.standard.dictionaryRepresentation().keys {
//                    UserDefaults.standard.removeObject(forKey: key.description)
//                }

        
        getUserDefaultsTasks()
        self.setCollectionView()
        
        
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        
        setConstraints()
        
    }
    
    func        getUserDefaultsTasks(){
        let objectKey: String = "\(components.year!)년 \(components.month!)월 \(cal.component(.day, from: now))일"
        //        MARK: 제거
        //                UserDefaults.standard.removeObject(forKey: objectKey)
        
        translateObjectKey = objectKey
        if let savedData = UserDefaults.standard.object(forKey: objectKey) as? Data{
            let decoder = JSONDecoder()
            
            do{
                let saveObject = try decoder.decode([MyCheckListTask].self, from:savedData)
                if saveObject.isEmpty{
                    print("getUserDefaultsTasks saveObject isEmpty")
                }
                else{
                    taskArray = saveObject
                }
            }
            catch{
                print("This day \(objectKey) have no UserDefaultData")
            }
        }
        else{
            print("getUserDefaultsTasks Data failed")
        }
        checkUserDefaultsTasks()
    }
    
    
    func checkUserDefaultsTasks(){
        
        haveScheduleArray.removeAll()
        
        for day in days{
            let objectKey: String = "\(components.year!)년 \(components.month!)월 \(day)일"
            if let savedData = UserDefaults.standard.object(forKey: objectKey) as? Data{
                if !savedData.isEmpty{
                    haveScheduleArray.append(false)
                }
            }
            else{
                haveScheduleArray.append(true)
            }
        }
    }
    
    
    func getCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
            
            return CalendarCollectionLayout().create()
        }
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyCheckListCollectionViewCell.self, forCellWithReuseIdentifier: "MyCheckListCollectionViewCell")
        
    }
    
    
    private func setConstraints() {
        configureYearMonthLabel()
        configureWeekStackView()
        configureCollectionView()
        configureTableView()
        configureAddTaskButton()
    }
    
    private func setComponentDate() {
        dateFormatter.dateFormat = "yyyy년 MM월"
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        
        self.calculation()
    }
    
    
    private func calculation() {
        if let firstDayOfMonth = cal.date(from: components){
            let firstWeekday = cal.component(.weekday, from: firstDayOfMonth)
            //첫번째 시작 날짜 1일 2월 ... 7토
            
            daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth)!.count
            //매달 몇일까지 있는지
            
            weekdayAdding = 2 - firstWeekday
            
            
            self.yearMonthLabel.text = dateFormatter.string(from: firstDayOfMonth)
            
            var count = 0
            self.days.removeAll()
            for day in weekdayAdding...daysCountInMonth {
                if day < 1 {
                    self.days.append("")
                    count += 1
                } else {
                    self.days.append(String(day))
                }
                
                //MARK: 오늘 날짜 인덱스찾기
                firstDayGapToday = cal.component(.day, from: now) + count - 1
            }
        }
        
    }
    
    func configureCollectionView(){
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.weekStackView.bottomAnchor,constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: self.view.bounds.height / 3.5 )
        ])
    }
    
    func configureTableView(){
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureAddTaskButton(){
        self.view.addSubview(addTaskButton)
        self.addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.addTaskButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.addTaskButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            self.addTaskButton.heightAnchor.constraint(equalToConstant: 50),
            self.addTaskButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    func configureYearMonthLabel(){
        self.view.addSubview(yearMonthLabel)
        self.view.addSubview(preMonthButton)
        self.view.addSubview(nextMonthButton)
        
        
        self.yearMonthLabel.textColor = .systemBlue
        self.yearMonthLabel.font = .systemFont(ofSize: 20,weight: .bold)
        self.yearMonthLabel.textAlignment = .center
        
        self.yearMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        self.preMonthButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextMonthButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            self.yearMonthLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            self.yearMonthLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.yearMonthLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.yearMonthLabel.heightAnchor.constraint(equalToConstant: 44),
            
            
            self.preMonthButton.centerYAnchor.constraint(equalTo: self.yearMonthLabel.centerYAnchor),
            self.preMonthButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.preMonthButton.heightAnchor.constraint(equalToConstant: 44),
            self.preMonthButton.widthAnchor.constraint(equalToConstant: 44),
            
            self.nextMonthButton.centerYAnchor.constraint(equalTo: self.yearMonthLabel.centerYAnchor),
            self.nextMonthButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.nextMonthButton.heightAnchor.constraint(equalToConstant: 44),
            self.nextMonthButton.widthAnchor.constraint(equalToConstant: 44)
            
        ])
    }
    
    func configureWeekStackView(){
        self.view.addSubview(weekStackView)
        self.weekStackView.distribution = .fillEqually
        self.weekStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.weekStackView.topAnchor.constraint(equalTo: self.yearMonthLabel.bottomAnchor, constant: 10),
            self.weekStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.weekStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.weekStackView.heightAnchor.constraint(equalToConstant: 24)
        ])
        self.configureWeekLabel()
        
    }
    
    func configureWeekLabel(){
        let dayoftheWeek = ["일","월","화","수","목","금","토"]
        
        dayoftheWeek.forEach{
            let label = UILabel()
            label.text = $0
            label.textAlignment = .center
            self.weekStackView.addArrangedSubview(label)
            
            if $0 == "일"{
                label.textColor = .systemBlue
            }
            else{
                label.textColor = .darkGray
            }
        }
    }
    
}

extension MyCheckListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCheckListCollectionViewCell", for: indexPath) as? MyCheckListCollectionViewCell else {return UICollectionViewCell()}
        
        //MARK: components 전송
        
        cell.configureDayLabel(text: days[indexPath.row])

        cell.haveScheduleCircle.isHidden = haveScheduleArray[indexPath.row]
        
        
        //오늘 날짜 default Select
        if (indexPath.row == firstDayGapToday) && (cal.component(.year, from: now) == components.year) && (cal.component(.month, from: now) == components.month){
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        
        if indexPath.row == firstDayGapToday{
            cell.isSelected = true
        }
        else{
            cell.isSelected = false
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCheckListCollectionViewCell", for: indexPath) as? MyCheckListCollectionViewCell{
            if cell.isSelected == true{
                
                let changeDay = "\(components.year!)년 \(components.month!)월 \(days[indexPath.row])일"
                translateObjectKey = changeDay
                if let savedData = UserDefaults.standard.object(forKey: changeDay) as? Data{
                    let decoder = JSONDecoder()
                    
                    do{
                        let saveObject = try decoder.decode([MyCheckListTask].self, from:savedData)
                        if saveObject.isEmpty{
                        }
                        else{
                            taskArray = saveObject
                        }
                    }
                    catch{
                        print("This day \(changeDay) have no UserDefaultData")
                    }
                }
                else{
                    taskArray = [MyCheckListTask]()
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
}

extension MyCheckListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cellCount = taskArray?.count{
            return cellCount
        }
        else{
            print("Table Cell numberOfRowsInSection Error")
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCheckListTableViewCell", for: indexPath) as?
                MyCheckListTableViewCell else {return UITableViewCell()}
        if let taskArray = taskArray {
            
            
            cell.contentLabel.text = taskArray[indexPath.row].title
            
            if taskArray[indexPath.row].check == true{
                let imageConfig = UIImage.SymbolConfiguration(pointSize: 35)
                cell.checkButton.setImage(UIImage(systemName: "checkmark.square", withConfiguration: imageConfig), for: .normal)
                cell.checkButton.tintColor = .white
                cell.contentLabel.textColor = .white
                cell.contentView.backgroundColor = .systemBlue
            }
            
            else{
                let imageConfig = UIImage.SymbolConfiguration(pointSize: 35)
                cell.checkButton.setImage(UIImage(systemName: "squareshape", withConfiguration: imageConfig), for: .normal)
                cell.checkButton.tintColor = .systemBlue
                cell.contentLabel.textColor = .darkGray
                cell.contentView.backgroundColor = .white
            }
            
            cell.checkButton.tag = indexPath.row
            cell.checkButton.addTarget(self, action: #selector(tapCheckButton(_:)), for: .touchUpInside)
            
            cell.importLabel.text = taskArray[indexPath.row].importance
            switch taskArray[indexPath.row].importance{
            case "매우 중요":
                cell.importLabel.backgroundColor = .yellow
            case "중요":
                cell.importLabel.backgroundColor = UIColor(hue: 0.5333, saturation: 0.39, brightness: 0.95, alpha: 1.0)
            case "보통":
                cell.importLabel.backgroundColor = .white
            default:
                break
            }
            
            
        }
        
        return cell
    }
    
    
    
    
    @objc func tapCheckButton(_ sender: UIButton){
        guard let task = taskArray else {return}
        if task[sender.tag].check == true {
            taskArray?[sender.tag].check = false
        }
        else{
            taskArray?[sender.tag].check = true
            
        }

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(taskArray){
            UserDefaults.standard.set(encoded, forKey: translateObjectKey)
        }
        tableView.reloadData()
        
    }
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goMyCheckListSettingViewController = MyCheckListSettingViewController()
        goMyCheckListSettingViewController.delegate = self
        goMyCheckListSettingViewController.taskIndex = indexPath.row
        goMyCheckListSettingViewController.taskAddOrModify = 1 // 수정
        goMyCheckListSettingViewController.objectKey = translateObjectKey
        
        self.present(goMyCheckListSettingViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        self.taskArray?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        if self.taskArray?.isEmpty == true{
            UserDefaults.standard.removeObject(forKey: translateObjectKey)

            checkUserDefaultsTasks()
            collectionView.reloadData()
        }
        else{
            if let task = taskArray{
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(task){
                    UserDefaults.standard.set(encoded, forKey: translateObjectKey)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}

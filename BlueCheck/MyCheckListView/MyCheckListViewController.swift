//
//  MyCheckListViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/10.
//

import UIKit


protocol TableViewCellDelegate: AnyObject{
    func delegateFunction()
}

protocol DelegateCell: AnyObject{
    func delegateCell()
}

struct CalendarCollectionLayout {
    
    func create() -> NSCollectionLayoutSection? {
        let itemFractionalSize: CGFloat = 1.0 / 7.0
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalSize), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
}

class MyCheckListViewController: UIViewController, TableViewCellDelegate, DelegateCell{
    func delegateCell() {
        print("리로드")
        
        
        self.tableView.reloadData()
    }
    
    
    func delegateFunction(){
        getUserDefaultsTasks()
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
    
    
    
    //MARK: 전송할 componentsData
    var componentsData = DateComponents()
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
        guard let goMyCheckListSettingViewController = storyboard?.instantiateViewController(withIdentifier: "MyCheckListSettingViewController") as? MyCheckListSettingViewController else {return}
        goMyCheckListSettingViewController.delegate = self
        goMyCheckListSettingViewController.taskAddOrModify = 0 // 추가
        
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
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(tapNextMonthButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func tapPreMonthButton(_ sender: UIButton){
        components.month = components.month! - 1
        //MARK: components 기본 전송
        componentsData = components
        
        self.calculation()
        self.collectionView.reloadData()
    }
    
    @objc func tapNextMonthButton(_ sender: UIButton){
        components.month = components.month! + 1
        //MARK: components 기본 전송
        componentsData = components
        self.calculation()
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
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.setCollectionView()
        getUserDefaultsTasks()
        
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        
        
        setConstraints()
        
//        self.collectionView.reloadData()
        
    }
    
    func getUserDefaultsTasks(){
//        //MARK: 제거
//        UserDefaults.standard.removeObject(forKey: "MyCheckListTableViewTasks UserDefaults")
        let objectKey: String = "\(components.year!)년 \(components.month!)월 \(cal.component(.day, from: now))일"
        if let savedData = UserDefaults.standard.object(forKey: objectKey) as? Data{
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
                print("This day \(objectKey) have no UserDefaultData")
            }
        }
        else{
            taskArray = [MyCheckListTask(title: "모가요", content: "네네", importance: "중요")]
            print("됐지?")
        }
        
        
        
//        if let savedData = UserDefaults.standard.object(forKey: "MyCheckListTableViewTasks UserDefaults") as? Data{
//            let decoder = JSONDecoder()
//
//            do{
//                let saveObject = try decoder.decode([MyCheckListTask].self, from: savedData)
//                if saveObject.isEmpty{
//                    //UserDefaults에서 가져온 데이터를 디코딩 했을때 빈 배열일때
//                }
//                else{
//                    taskArray = saveObject
//                }
//            }
//            catch{
//                print(error)
//            }
//        }
//        else{
//            taskArray = [MyCheckListTask(title: "🔥클릭해서 계획을 세워보세요🔥", content: "계획을 수정해보세요", importance: "중요")]
//            let encoder = JSONEncoder()
//            if let encoded = try? encoder.encode(taskArray){
//                UserDefaults.standard.set(encoded, forKey: "MyCheckListTableViewTasks UserDefaults")
//            }
//        }
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
    
    private func initView() {
        dateFormatter.dateFormat = "yyyy년 MM월"
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        
        //MARK: componentsData 저장
        componentsData = components
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
        cell.components = componentsData
        cell.configureDayLabel(text: days[indexPath.row])

        //오늘 날짜 default Select
        if (indexPath.row == firstDayGapToday) && (cal.component(.year, from: now) == components.year) && (cal.component(.month, from: now) == components.month){
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        
        cell.isSelected = indexPath.row == firstDayGapToday
        
      
        self.taskArray = cell.collectionViewCellTaskArray
        print(self.taskArray)
        
        
        return cell
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
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCheckListTableViewCell", for: indexPath) as?
                MyCheckListTableViewCell else {return UITableViewCell()}
        if let taskArray = taskArray {
            cell.contentLabel.text = taskArray[indexPath.row].title
            cell.timeLabel.text = taskArray[indexPath.row].importance
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let goMyCheckListSettingViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyCheckListSettingViewController") as? MyCheckListSettingViewController else {return}
        
        goMyCheckListSettingViewController.delegate = self
        goMyCheckListSettingViewController.taskIndex = indexPath.row
        goMyCheckListSettingViewController.taskAddOrModify = 1 // 수정
        self.present(goMyCheckListSettingViewController, animated: true, completion: nil)
    }
    
}

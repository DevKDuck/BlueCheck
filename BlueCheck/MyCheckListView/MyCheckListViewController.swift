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

struct CalendarCollectionLayout {
    
    func create() -> NSCollectionLayoutSection? {
        let itemFractionalSize: CGFloat = 1 / 7
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalSize), heightDimension: .fractionalHeight(itemFractionalSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
}

class MyCheckListViewController: UIViewController, TableViewCellDelegate{
    
    
    func delegateFunction(){
        getUserDefaultsTasks()
        self.tableView.reloadData()
    }
    
    
    var tasks: [String] = ["🔥클릭해서 계획을 세워보세요🔥"]
    var content: [String] = ["내용도 작성해보세요"]
    var tasksTime: [String] = ["10:10"]
    
    var taskArray = [MyCheckListTask]()
    
    let now = Date()
    var cal = Calendar.current
    let dateFormatter = DateFormatter()
    var components = DateComponents()
    var days: [String] = []
    var daysCountInMonth = 0
    var weekdayAdding = 0
    
    
    let addTaskButton : UIButton = {
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
    
    
    let preMonthButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(tapPreMonthButton(_:)), for: .touchUpInside)
        return button
    }()
    
    let nextMonthButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right.circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(tapNextMonthButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func tapPreMonthButton(_ sender: UIButton){
        components.month = components.month! - 1
        self.calculation()
        self.collectionView.reloadData()
    }
    
    @objc func tapNextMonthButton(_ sender: UIButton){
        components.month = components.month! + 1
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
    
    
    //    let calendarDateFormatter = CalendarDateFormatter()
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.setCollectionView()
        //        self.setTableView()
        
        getUserDefaultsTasks()
        
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        
        setConstraints()
        self.collectionView.reloadData()
        
    }
    
    func getUserDefaultsTasks(){
        
        let t = MyCheckListTask(title: "제목", content: "내용")
        
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(t){
            UserDefaults.standard.set(encoded, forKey: "M")
        }

        if let savedData = UserDefaults.standard.object(forKey: "M") as? Data{
            let decoder = JSONDecoder()
            if let saveObject = try? decoder.decode(MyCheckListTask.self, from: savedData){
             print(saveObject)
            }
        }
        
        
        if let task = UserDefaults.standard.object(forKey: "MyCheckListTasks UserDefaults") as? [String]{
            tasks = task
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
    
    //    private func setTableView(){
    //        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height / 2))
    //        tableView.backgroundColor = .systemPink
    //        tableView.dataSource = self
    //        tableView.delegate = self
    //        tableView.register(MyCheckListTableViewCell.self, forCellReuseIdentifier: "MyCheckListTableViewCell")
    //
    //        if let task = UserDefaults.standard.object(forKey: "MyCheckListTasks UserDefaults") as? [String]{
    //            tasks = task
    //        }
    //    }
    
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
        self.calculation()
    }
    
    
    private func calculation() {
        if let firstDayOfMonth = cal.date(from: components){
            let firstWeekday = cal.component(.weekday, from: firstDayOfMonth)
            daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth)!.count
            weekdayAdding = 2 - firstWeekday
            
            
            self.yearMonthLabel.text = dateFormatter.string(from: firstDayOfMonth)
            
            self.days.removeAll()
            for day in weekdayAdding...daysCountInMonth {
                if day < 1 {
                    self.days.append("")
                } else {
                    self.days.append(String(day))
                }
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
        cell.configureDayLabel(text: days[indexPath.row])
        return cell
    }
    
}

extension MyCheckListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCheckListTableViewCell", for: indexPath) as?
                MyCheckListTableViewCell else {return UITableViewCell()}
        
        cell.contentLabel.text = tasks[indexPath.row]
        
        cell.timeLabel.text = tasksTime[0]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let goMyCheckListSettingViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyCheckListSettingViewController") as? MyCheckListSettingViewController else {return}
        
        
        goMyCheckListSettingViewController.taskAddOrModify = 1 // 수정
        self.present(goMyCheckListSettingViewController, animated: true, completion: nil)
    }
    
}

//
//  MyCheckListViewController.swift
//  BlueCheck
//
//  Created by duck on 2023/01/10.
//

import UIKit

struct CalendarCollectionLayout {
    
    func create() -> NSCollectionLayoutSection? {
        let itemFractionalSize: CGFloat = 1 / 7
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(itemFractionalSize), heightDimension: .fractionalHeight(itemFractionalSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(itemFractionalSize))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
}

class MyCheckListViewController: UIViewController{
    
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
    
    //    let calendarDateFormatter = CalendarDateFormatter()
    
    let now = Date()
    var cal = Calendar.current
    let dateFormatter = DateFormatter()
    var components = DateComponents()
    var days: [String] = []
    var daysCountInMonth = 0
    var weekdayAdding = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyCheckListCollectionViewCell.self, forCellWithReuseIdentifier: "MyCheckListCollectionViewCell")

        self.view.backgroundColor = .white

        setConstraints()
        
        self.collectionView.reloadData()
        
    }
    func getCollectionViewLayout() -> UICollectionViewCompositionalLayout {
            UICollectionViewCompositionalLayout { (section, _) -> NSCollectionLayoutSection? in
                return CalendarCollectionLayout().create()
            }
        }
    
    
    private func setConstraints() {
        configureYearMonthLabel()
        configureWeekStackView()
        configureCollectionView()
    }
    
    private func initView() {
        dateFormatter.dateFormat = "yyyy년 MM월"
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        self.calculation()
    }
    
    
    private func calculation() {
        let firstDayOfMonth = cal.date(from: components)
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!)
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        weekdayAdding = 2 - firstWeekday
        
        print(firstDayOfMonth)
        print(firstWeekday)
        print(daysCountInMonth)
        print(weekdayAdding)
        
        self.yearMonthLabel.text = dateFormatter.string(from: firstDayOfMonth!)
        
        self.days.removeAll()
        for day in weekdayAdding...daysCountInMonth {
            if day < 1 {
                self.days.append("")
            } else {
                self.days.append(String(day))
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
            collectionView.heightAnchor.constraint(equalToConstant: 320)
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

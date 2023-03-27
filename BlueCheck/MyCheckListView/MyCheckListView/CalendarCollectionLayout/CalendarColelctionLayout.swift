//
//  CalendarColelctionLayout.swift
//  BlueCheck
//
//  Created by duck on 2023/03/27.
//

import UIKit

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

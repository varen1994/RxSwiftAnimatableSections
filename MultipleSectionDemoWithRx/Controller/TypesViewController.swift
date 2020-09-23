//
//  TypesViewController.swift
//  MultipleSectionDemoWithRx
//
//  Created by Varender Singh on 22/09/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class TypesViewController: UIViewController {

    let disposeBag = DisposeBag()
    let identifier = "NormalCell"
    @IBOutlet weak var tableView: UITableView!
    var titlesTableView = ["Table View","Table View Animations"]
    var titleCollectionView = ["Collection View","Collection View Animations"]
    var subject = BehaviorRelay<[ZISectionWrapperModel]>.init(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataSource = dataSourceTV()
        self.setupData()
        dataSource.titleForHeaderInSection = { dataSource, index in
            return self.subject.value[index].sectionName
        }
        self.subject.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
        self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
       
     }
    
    func setupData() {
        let sectionName = TypesVCSection.tableView.rawValue
        if let secIndex = TypesVCSection.tableView.returnSectionIndex() {
            let section = ZISectionWrapperModel(sectionName: sectionName, items: ZISectionWrapperModel.convertItemOfAnyToZIWrapperItem(sectionName: sectionName, objects: titlesTableView), sectionIndex: secIndex)
            self.subject.accept([section])
        }
        
        let sectionNameCV = TypesVCSection.collectionView.rawValue
        if let secIndex = TypesVCSection.collectionView.returnSectionIndex() {
            let section = ZISectionWrapperModel(sectionName: sectionNameCV, items: ZISectionWrapperModel.convertItemOfAnyToZIWrapperItem(sectionName: sectionNameCV, objects: titleCollectionView), sectionIndex: secIndex)
            let sectionsAdded = self.subject.value + [section]
            self.subject.accept(sectionsAdded)
        }
    }
    
    // MARK:- TableView Datasource
    func dataSourceTV()->RxTableViewSectionedReloadDataSource<ZISectionWrapperModel> {
        return RxTableViewSectionedReloadDataSource<ZISectionWrapperModel>(configureCell: {
            datasource,tableView,indexPath,item in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath)
            cell.textLabel!.text = item.data as? String ?? ""
            cell.selectionStyle = .none
            return cell
        })
    }
    
}

// MARK:- UITableViewDelegate
extension TypesViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionName = self.subject.value[indexPath.section].sectionName
        switch TypesVCSection(rawValue: sectionName) {
        case .collectionView:
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "DefCollectionViewController") as? DefCollectionViewController else {
                return
            }
            nextVC.showAnimation =  (indexPath.row==0 ?  false : true)
            self.navigationController?.pushViewController(nextVC, animated: true)
            return
            
        case .tableView:
            guard let nextVC = self.storyboard?.instantiateViewController(identifier: "DefTableViewController") as? DefTableViewController else {
                return
            }
            nextVC.showAnimation = (indexPath.row==0 ? false : true)
            self.navigationController?.pushViewController(nextVC, animated: true)
            return
        case .none:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

/// Enum TypesVCSection
///
/// Method description
/// Enum with Associate type String - Because for each section we have to define a different identity
enum TypesVCSection:String {
    case tableView = "TableView"
    case collectionView = "CollectionView"
    
    func returnSectionIndex()->Int? {
        switch self {
        case .tableView:
            return 0
        case .collectionView:
            return 1
        }
    }
}

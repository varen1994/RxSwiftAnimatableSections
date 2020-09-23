//
//  DefTableViewController.swift
//  MultipleSectionDemoWithRx
//
//  Created by Varender Singh on 23/09/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DefTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let disposableBag = DisposeBag()
    var subject = BehaviorRelay<[ZISectionWrapperModel]>(value: [])
    var timer:Timer?
    var showAnimation = true
    var count = 0
    
    static let identifier1 = "Cell1"
    static let identifier2 = "Cell2"
    static let identifier3 = "Cell3"
    
    // MARK:- ****************** METHODS ********************
    override func viewDidLoad() {
        if showAnimation {
            self.title = "Animated TableView"
        } else {
            self.title = "Normal TableView"
        }
        self.setUpDataUsingTimer()
    }
    
    func setUpDataUsingTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            var newSection = self.subject.value
            
            if self.count%3 == 2 { // Pink
                guard let secIndex = SectionModelCustom.home.returnSectionIndex() else { return }
                let section1 = ZISectionWrapperModel(sectionName: SectionModelCustom.home.rawValue, items: ZISectionWrapperModel.convertItemOfAnyToZIWrapperItem(sectionName: SectionModelCustom.home.rawValue, objects: ["1","2","3","4"]), sectionIndex: secIndex)
                newSection += [section1]
            } else if self.count%3 == 1 { // Green
                guard let secIndex = SectionModelCustom.banner.returnSectionIndex() else { return }
                let section1 = ZISectionWrapperModel(sectionName: SectionModelCustom.banner.rawValue, items: ZISectionWrapperModel.convertItemOfAnyToZIWrapperItem(sectionName: SectionModelCustom.banner.rawValue, objects: ["5","6","7","8"]), sectionIndex: secIndex)
                newSection += [section1]
            } else {  // Blue
                guard let secIndex = SectionModelCustom.tryB.returnSectionIndex() else { return }
                let section1 = ZISectionWrapperModel(sectionName: SectionModelCustom.tryB.rawValue, items: ZISectionWrapperModel.convertItemOfAnyToZIWrapperItem(sectionName: SectionModelCustom.tryB.rawValue, objects: ["9","10","11","12","13","14"]), sectionIndex: secIndex)
                newSection += [section1]
            }
            newSection.sort { (obj1, obj2) -> Bool in
                return obj1.sectionIndex < obj2.sectionIndex
            }
            self.subject.accept(newSection)
            self.count += 1
            if self.count == 3 {
                self.timer?.invalidate()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if showAnimation {
            self.setUpDataSourceForAnimated()
        } else {
            self.setUpDataSourceWithOutAnimation()
        }
    }
    
    
    // MARK:- NORMAL DATA SOURCE
    func setUpDataSourceWithOutAnimation() {
        let datasource = self.datasources()
        self.tableView.rx.setDelegate(self).disposed(by: self.disposableBag)
        self.subject.bind(to: self.tableView.rx.items(dataSource: datasource)).disposed(by: self.disposableBag)
    }
    
    
    func datasources()->RxTableViewSectionedReloadDataSource<ZISectionWrapperModel> {
        return RxTableViewSectionedReloadDataSource<ZISectionWrapperModel>(configureCell: {
            datasource,tableView,indexPath,item in
            let sectionDisplaying = self.subject.value[indexPath.section].sectionName
            let type = SectionModelCustom(rawValue: sectionDisplaying)
            switch type {
            case .banner:
                return self.section2TypeCell(item, indexPath: indexPath)
            case .home:
                return self.section1TypeCell(item, indexPath: indexPath)
            case .tryB:
                return self.section3TypeCell(item, indexPath: indexPath)
            case .none:
                return UITableViewCell()
            }
        })
    }
    
    
    // MARK:- ANIMATED DATA SOURCE
    func setUpDataSourceForAnimated() {
        let datasource = self.datasourcesAnimated()
        self.tableView.rx.setDelegate(self).disposed(by: self.disposableBag)
        self.subject.bind(to: self.tableView.rx.items(dataSource: datasource)).disposed(by: self.disposableBag)
    }
    
    func datasourcesAnimated()->RxTableViewSectionedAnimatedDataSource<ZISectionWrapperModel> {
        return RxTableViewSectionedAnimatedDataSource<ZISectionWrapperModel>(configureCell: {
            datasource,tableView,indexPath,item in
            let sectionDisplaying = self.subject.value[indexPath.section].sectionName
            let type = SectionModelCustom(rawValue: sectionDisplaying)
            switch type {
            case .banner:
                return self.section2TypeCell(item, indexPath: indexPath)
            case .home:
                return self.section1TypeCell(item, indexPath: indexPath)
            case .tryB:
                return self.section3TypeCell(item, indexPath: indexPath)
            case .none:
                return UITableViewCell()
            }
        })
    }
    
    // MARK:- CELLS SETUP
    func section1TypeCell(_ item:ZIWrapperItem,indexPath:IndexPath)->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefTableViewController.identifier1, for: indexPath)
        cell.textLabel?.text = item.data as? String ?? ""
        cell.contentView.backgroundColor =  UIColor.orange.withAlphaComponent(0.35)
        return cell
    }
    
    func section2TypeCell(_ item:ZIWrapperItem,indexPath:IndexPath)->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefTableViewController.identifier2, for: indexPath)
        cell.textLabel?.text = item.data as? String ?? ""
        cell.contentView.backgroundColor =  UIColor.green.withAlphaComponent(0.25)
        return cell
    }
    
    func section3TypeCell(_ item:ZIWrapperItem,indexPath:IndexPath)->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefTableViewController.identifier3, for: indexPath)
        cell.textLabel?.text = item.data as? String ?? ""
        cell.contentView.backgroundColor = UIColor.blue.withAlphaComponent(0.25)
        return cell
    }
}

// MARK:- UITableViewDelegate
extension DefTableViewController:UITableViewDelegate {
    
    
}

//
//  ViewController.swift
//  MultipleSectionDemoWithRx
//
//  Created by Varender Singh on 20/09/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DefCollectionViewController: UIViewController,UICollectionViewDelegateFlowLayout {

    let disposableBag = DisposeBag()
    var subject = BehaviorRelay<[ZISectionWrapperModel]>(value: [])
    var timer:Timer?
    var showAnimation = true
    var count = 0
    
    @IBOutlet var collectionView:UICollectionView!
    static let identifier1 = "Cell1"
    static let identifier2 = "Cell2"
    static let identifier3 = "Cell3"
    
    // MARK:- ****************** METHODS ********************
    override func viewDidLoad() {
       if showAnimation {
            self.title = "Animated Collection View"
        } else {
            self.title = "Normal Collection View"
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
           self.collectionView.rx.setDelegate(self).disposed(by: self.disposableBag)
           datasource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) in
              if kind == UICollectionView.elementKindSectionHeader {
                  let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath)
                  section.backgroundColor = UIColor.systemPink
                  if let label = section.viewWithTag(101) as? UILabel {
                      let section = self.subject.value[indexPath.section]
                      label.text =  "Header" + section.sectionName
                  }
                  return section
              } else {
                  let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionFooter", for: indexPath)
                  section.backgroundColor = UIColor.orange
                  if let label = section.viewWithTag(101) as? UILabel {
                      let section = self.subject.value[indexPath.section]
                      label.text =  "Footer" + section.sectionName
                  }
                  return section
              }
           }
           self.subject.bind(to: self.collectionView.rx.items(dataSource: datasource)).disposed(by: self.disposableBag)
       }
    
    
    func datasources()->RxCollectionViewSectionedReloadDataSource<ZISectionWrapperModel> {
        return RxCollectionViewSectionedReloadDataSource<ZISectionWrapperModel>(configureCell: {
            datasource,collectionView,indexPath,item in
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
                    return UICollectionViewCell()
            }
        })
    }
    
    
    // MARK:- ANIMATED DATA SOURCE
      func setUpDataSourceForAnimated() {
          let datasource = self.datasourcesAnimated()
          self.collectionView.rx.setDelegate(self).disposed(by: self.disposableBag)
          datasource.configureSupplementaryView = { (dataSource, collectionView, kind, indexPath) in
             if kind == UICollectionView.elementKindSectionHeader {
                 let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath)
                 section.backgroundColor = UIColor.systemPink
                 if let label = section.viewWithTag(101) as? UILabel {
                     let section = self.subject.value[indexPath.section]
                     label.text =  "Header" + section.sectionName
                 }
                 return section
             } else {
                 let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionFooter", for: indexPath)
                 section.backgroundColor = UIColor.orange
                 if let label = section.viewWithTag(101) as? UILabel {
                     let section = self.subject.value[indexPath.section]
                     label.text =  "Footer" + section.sectionName
                 }
                 return section
             }
          }
          self.subject.bind(to: self.collectionView.rx.items(dataSource: datasource)).disposed(by: self.disposableBag)
      }
    
    func datasourcesAnimated()->RxCollectionViewSectionedAnimatedDataSource<ZISectionWrapperModel> {
        return RxCollectionViewSectionedAnimatedDataSource<ZISectionWrapperModel>(configureCell: {
            datasource,collectionView,indexPath,item in
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
                return UICollectionViewCell()
            }
            return UICollectionViewCell()
        })
    }
    
    // MARK:- CELLS SETUP
    func section1TypeCell(_ item:ZIWrapperItem,indexPath:IndexPath)->UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefCollectionViewController.identifier2, for: indexPath)
        if let label = cell.contentView.viewWithTag(101) as? UILabel {
            label.text = item.data as? String ?? ""
        }
        cell.contentView.backgroundColor =  UIColor.orange.withAlphaComponent(0.35)
        return cell
    }
    
    func section2TypeCell(_ item:ZIWrapperItem,indexPath:IndexPath)->UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefCollectionViewController.identifier2, for: indexPath)
        if let label = cell.contentView.viewWithTag(101) as? UILabel {
            label.text = item.data as? String ?? ""
        }
        cell.contentView.backgroundColor =  UIColor.green.withAlphaComponent(0.25)
        return cell
    }
    
    func section3TypeCell(_ item:ZIWrapperItem,indexPath:IndexPath)->UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefCollectionViewController.identifier3, for: indexPath) as! UICollectionViewCell
        if let label = cell.contentView.viewWithTag(101) as? UILabel {
            label.text = item.data as? String ?? ""
        }
        cell.contentView.backgroundColor = UIColor.blue.withAlphaComponent(0.25)
        return cell
    }
    
    // MARK:- COLLECTION VIEW DELEGATES
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionDisplaying = self.subject.value[indexPath.section].sectionName
        let type = SectionModelCustom(rawValue: sectionDisplaying)
        switch type {
            case .banner:
                return CGSize(width: (self.collectionView.layer.frame.width-32) / 3, height: 100)
            case .home:
                return CGSize(width: self.collectionView.layer.frame.width-32, height: 100)
            case .tryB:
                return CGSize(width: (self.collectionView.layer.frame.width-32) / 2, height: 100)
            default:
                return .zero
        }
    }
}


// MARK:- ENUM SectionModelCustom
enum SectionModelCustom:String {
    case home = "Home"
    case banner = "Banner"
    case tryB = "TryB"
    
    func returnSectionIndex()->Int? {
        switch self {
        case .home:
            return 0
        case .banner:
            return 1
        case .tryB:
            return 2
        }
    }
}

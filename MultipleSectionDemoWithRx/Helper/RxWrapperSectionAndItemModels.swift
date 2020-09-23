//
//  RxWrapperSectionAndItemModels.swift
//  MultipleSectionDemoWithRx
//
//  Created by Varender Singh on 22/09/20.
//  Copyright © 2020 Varender. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

/// Struct ZISectionWrapperModel
struct ZISectionWrapperModel {
    var sectionName:String
    var items = [ZIWrapperItem]()
    var sectionIndex:Int
}

extension ZISectionWrapperModel:AnimatableSectionModelType {
    init(original: ZISectionWrapperModel, items: [ZIWrapperItem]) {
        self = original
        self.items = items
    }

    typealias Identity = String
    
    var identity:Identity {
        return self.sectionName
    }
    
    /// Method description
    /// This method can is used to convert Section Items to ZIWrapperItem array
    ///
    /// - parameter content:  (sectionName) - Should be different for each section  (objects) - array of different objects
    ///
    /// - return: [ZIWrapperItem]
    static func convertItemOfAnyToZIWrapperItem(sectionName:String,objects:[Any])->[ZIWrapperItem] {
        var array = [ZIWrapperItem]()
        for (index,obj) in objects.enumerated() {
            let item = ZIWrapperItem(id: sectionName + "\(index)", data: obj)
            array.append(item)
        }
        return array
    }
}


/// Class ZISectionWrapperModel
class ZIWrapperItem:IdentifiableType,Equatable {
    typealias Identity = String
    
    var identity:Identity {
        return self.id
    }
    
    static func == (lhs: ZIWrapperItem, rhs: ZIWrapperItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id:String
    var data:Any
    
    /// Method description
    /// This method is used for initialization of ZIWrapperItem
    ///
    /// - parameter content:  (id) - SectionName + "\(index)"  (data) - information to pass
    ///
    fileprivate init(id:String,data:Any) {
        self.id = id
        self.data = data
    }
}

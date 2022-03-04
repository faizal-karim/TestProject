//
//  DocumentsListViewModel.swift
//  TestProject_Example
//
//  Created by Faizal on 3/4/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
enum DocumentsListViewCellTypes {
    case document 
    case addNew
}
struct DocumentsListViewModel {
    let model: KYCModel
    
    func getDataSourceCount() -> Int {
        model.documents.count
    }
    
    func getItem(for index: Int) -> UIImage{
        model.documents[index]
    }
}

//
//  DownloadLangageViewModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/26.
//

import Foundation
import MLKit
import Firebase

class DownloadLangageViewModel: ObservableObject {
    
    @Published var dataList = [DownloadLanguageObject]()
    
    init() {
        setupObject()
    }
    
    
    func setupObject() {
        let localModels = ModelManager.modelManager().downloadedTranslateModels
        
        data.removeAll()
        dataList = TranslateLanguage.allLanguages().map { lang -> DownloadLanguageObject in
            if let model = localModels.first(where: {$0.language.rawValue == lang.rawValue}) {
                return DownloadLanguageObject(type: model.language, state: .downloaded)
            } else {
                return DownloadLanguageObject(type: TranslateLanguage(rawValue: lang.rawValue), state: .none)
            }
            
        }
        
        .sorted(by: {$0.type.title < $1.type.title})
        
        print(dataList.count)
    }
    
    
}

struct DownloadLanguageObject{
    let type : TranslateLanguage
    var state : DownloadState
    
    init(type : TranslateLanguage, state : DownloadState) {
        self.type = type
        self.state = state
    }
}

enum DownloadState {
    case none
    case processing(Progress)
    case downloaded
}

//
//  DownloadLangageViewModel.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/26.
//

import Foundation
import SwiftUI
import MLKit
import Firebase


class DownloadLangageViewModel: ObservableObject {
    
    @Published var dataList = [DownloadLanguageObject]()
    @Published var alert : Alert = Alert(title: Text(""))
    @Published var showAlert : Bool = false
    
    init() {
        setupObject()
        setupNotificationCenter()
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
    
    func setupNotificationCenter() {
        NotificationCenter.default.addObserver(forName: .mlkitModelDownloadDidSucceed, object: nil, queue: nil) { [weak self]  notification in
            
            guard let strogeSelf = self, let userInfo = notification.userInfo, let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue] as? TranslateRemoteModel, let downloadedLanguageIndex = strogeSelf.dataList.firstIndex(where: {$0.type == model.language}) else {return}
            
            strogeSelf.dataList[downloadedLanguageIndex].state = .downloaded
            print("success")
        }
        
        NotificationCenter.default.addObserver(forName: .mlkitModelDownloadDidFail,
                                               object: nil,
                                               queue: nil
        ) { [weak self] notification in
            guard let strongSelf = self,
                let userInfo = notification.userInfo,
                let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue] as? TranslateRemoteModel,
                let failLanguageIndex = strongSelf.dataList.firstIndex(where: {$0.type == model.language}) else { return }
            // Error
            let error = userInfo[ModelDownloadUserInfoKey.error.rawValue]
            
            strongSelf.showAlert = true
            strongSelf.alert = Alert(title: Text("Download Error"), message: Text("\(strongSelf.dataList[failLanguageIndex].type.title) Model Download did Fail \n\(error.debugDescription)"), dismissButton: .default(Text("OK")))
      
            strongSelf.dataList[failLanguageIndex].state = .none
            
            print("DEBUG : \(error.debugDescription)")
       
        
        }
    }
    
    func checkdownloadLang(_ i : Int) {
        
        self.showAlert = true
        let lang = self.dataList[i].type
        self.alert = Alert(title: Text("\(lang.title)をダウンロードさせて頂きます。"), message: Text("Wi-fi 使用時のみ進行いたします"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .destructive(Text("OK"), action: {
            
            self.downloadLanguage(i)
        }))
    }
    
    func downloadLanguage(_ i  : Int) {
       
        let lang = self.dataList[i]
        let dlModel = TranslateRemoteModel.translateRemoteModel(language: lang.type)
        
        guard !ModelManager.modelManager().isModelDownloaded(dlModel) else {return}
        
        let progress = ModelManager.modelManager().download(dlModel, conditions: ModelDownloadConditions(allowsCellularAccess: false, allowsBackgroundDownloading: true))

        self.dataList[i].state = .processing(progress)
        print(progress)
    }
    
    
    func deleteLanguage(_ i : Int) {
        
        self.showAlert = true
        let lang = self.dataList[i].type
        
        alert = Alert(title: Text("Delete \(lang.title)"), message: nil, primaryButton: .cancel(Text("Cancel")), secondaryButton: .destructive(Text("Delete"), action: {
            
            let deleteModel = TranslateRemoteModel.translateRemoteModel(language: lang)
            
           
            guard ModelManager.modelManager().isModelDownloaded(deleteModel) else { return }
                
                ModelManager.modelManager().deleteDownloadedModel(deleteModel) { (error) in
                    
                    if error != nil {
                        self.alert = Alert(title: Text("Error"), message: Text(error!.localizedDescription), dismissButton: .default(Text("OK")))
                      
                       
                    } else {
                        
                        self.alert = Alert(title: Text("Delete Succes"), message: nil, dismissButton: .default(Text("OK")))
                        
                        self.dataList[i].state = .none
                      
                    }
                    
                    self.showAlert = true

                }
            
//
           
        }))
    }
    
    func deleteAllLanguage() {
        
        self.showAlert = true
        
        alert = Alert(title: Text("Delete All"), message: nil, primaryButton: .cancel(Text("Cancel")), secondaryButton: .destructive(Text("Delete"), action: {
            
            let localModel = ModelManager.modelManager().downloadedTranslateModels
            localModel.forEach { (model) in
                print(model)
                
                ModelManager.modelManager().deleteDownloadedModel(model) { (error) in
                    
                    if error != nil {
                        self.showAlert = true
                        self.alert = Alert(title: Text("Error"), message: Text(error!.localizedDescription), dismissButton: .default(Text("OK")))
                        print(error!.localizedDescription)
                        return
                    }
                    
                    guard let index = self.dataList.firstIndex(where: {$0.type == model.language}) else { return }
                    
                    self.dataList[index].state = .none
                    
                }
            }
        }))
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

//
//  DownloadLangageView.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/26.
//

import SwiftUI

struct DownloadLangageView: View {
    
    @StateObject var vm : DownloadLangageViewModel = DownloadLangageViewModel()
    
    var body: some View {
        VStack{
            
            
            List(vm.dataList.indices, id : \.self) { i in
                
                Button(action: {
                    vm.dataList[i].state = .processing(Progress())
                }) {
                    languageCell(lang: $vm.dataList[i])
                }
                
                   
            }

        }
        
    }
    
    private func rowView(data: DownloadLanguageObject) -> some View {
        #if DEBUG
        print(">> \(data.type)")
        #endif
        return NavigationLink(destination: Text("Details")) {
            Text("Go next from \(data.type.title)")
        }
    }
}

struct languageCell : View {
    
    @Binding var lang : DownloadLanguageObject
//    var lang : DownloadLanguageObject
    
    var body: some View {
        
        HStack{
            
            
            Text(lang.type.title)
                .padding(.leading,20)
            
            Spacer(minLength: 0)
            
            switch lang.state {
            case .downloaded :
                Text("Downloaded")
            case .processing(_):
                ProgressView()
            case .none:
                Text("DL")
                    .foregroundColor(.blue)
           
            }
            Spacer().frame(width: 20)
    
        }
    }
}

struct DownloadLangageView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadLangageView()
    }
}

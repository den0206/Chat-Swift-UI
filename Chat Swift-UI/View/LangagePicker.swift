//
//  LangagePicker.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/26.
//

import SwiftUI
import Firebase
import MLKit

struct LangagePicker: View {
    let locale = Locale.current
    @Binding var selectrdLangage : TranslateLanguage
    
    var body: some View {
        
        Text(selectrdLangage.title)
            .font(.title2)
        
        VStack(spacing : 10) {
            Picker("", selection: $selectrdLangage) {
                
                ForEach(TranslateLanguage.allLanguages().sorted(by: {locale.localizedString(forLanguageCode: $0.rawValue)! < locale.localizedString(forLanguageCode: $1.rawValue)! }), id : \.self) { i in
                    
                    Text(i.title)
                }
                
            }
 
        }

    }
}

extension TranslateLanguage {
  
    
    
    var title : String {
        
        switch self {
        case .afrikaans: return "Afrikaans"
        case .arabic: return "Arabic"
        case .belarusian: return "Belarusian"
        case .bulgarian: return "Bulgarian"
        case .bengali: return "Bengali"
        case .catalan: return "Catalan"
        case .czech: return "Czech"
        case .welsh: return "Welsh"
        case .danish: return "Danish"
        case .german: return "German"
        case .greek: return "Greek"
        case .english: return "English"
        case .eperanto: return "Esperanto"
        case .spanish: return "Spanish"
        case .estonian: return "Estonian"
        case .persian: return "Persian"
        case .finnish: return "Finnish"
        case .french: return "French"
        case .irish: return "Irish"
        case .galician: return "Galician"
        case .gujarati: return "Gujarati"
        case .hebrew: return "Hebrew"
        case .hindi: return "Hindi"
        case .croatian: return "Croatian"
        case .haitianCreole: return "Haitian"
        case .hungarian: return "Hungarian"
        case .indonesian: return "Indonesian"
        case .icelandic: return "Icelandic"
        case .italian: return "Italian"
        case .japanese: return "Japanese"
        case .georgian: return "Georgian"
        case .kannada: return "Kannada"
        case .korean: return "Korean"
        case .lithuanian: return "Lithuanian"
        case .latvian: return "Latvian"
        case .macedonian: return "Macedonian"
        case .marathi: return "Marathi"
        case .malay: return "Malay"
        case .maltese: return "Maltese"
        case .dutch: return "Dutch"
        case .norwegian: return "Norwegian"
        case .polish: return "Polish"
        case .portuguese: return "Portuguese"
        case .romanian: return "Romanian"
        case .russian: return "Russian"
        case .slovak: return "Slovak"
        case .slovenian: return "Slovenian"
        case .albanian: return "Albanian"
        case .swedish: return "Swedish"
        case .swahili: return "Swahili"
        case .tamil: return "Tamil"
        case .telugu: return "Telugu"
        case .thai: return "Thai"
        case .tagalog: return "Tagalog"
        case .turkish: return "Turkish"
        case .ukrainian: return "Ukranian"
        case .urdu: return "Urdu"
        case .vietnamese: return "Vietnamese"
        case .chinese: return "Chinese"
        
        default:
            return ""
        }
    }
}




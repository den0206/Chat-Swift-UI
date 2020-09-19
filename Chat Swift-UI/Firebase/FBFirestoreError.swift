//
//  FBFirestoreError.swift
//  Chat Swift-UI
//
//  Created by 酒井ゆうき on 2020/09/19.
//

import Foundation

enum FirestoreError : Error {
    case noAuthResult
    case noCurrentUser
    case noDocumentSNapshot
    case noSnapshotData
    case noUser
}

extension FirestoreError : LocalizedError {
    
    var errorDescription : String? {
        switch self {
        
        case .noAuthResult:
            return NSLocalizedString("No AUth", comment: "")
        case .noCurrentUser:
            return NSLocalizedString("No CurrentUser", comment: "")
        case .noDocumentSNapshot:
            return NSLocalizedString("No Document Snapshot", comment: "")
        case .noSnapshotData:
            return NSLocalizedString("No Snapshot", comment: "")
        case .noUser:
            return NSLocalizedString("No User", comment: "")
        }
    }
}

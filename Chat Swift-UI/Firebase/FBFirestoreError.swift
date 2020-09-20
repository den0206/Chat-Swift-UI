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
    case emptySnapshot
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
        case .emptySnapshot:
            return NSLocalizedString("emptySnapshot", comment: "")

        }
    }
}

enum EmailAuthError : Error {
    case incorrectPassword
    case invalidEmail
    case accountDoesnotExist
    case unknownError
    case couldNotCreate
    case extraDataNotCreated
    
    var errorDescription : String? {
        
        switch self {
        case .incorrectPassword:
            return NSLocalizedString("In Correct Password", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Not a valid email", comment: "")
        case .accountDoesnotExist:
            return NSLocalizedString("Account Does Not exist", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown Error", comment: "")
        case .couldNotCreate:
            return NSLocalizedString("Could not Create User", comment: "")
        case .extraDataNotCreated:
            return NSLocalizedString("could not save User na,e", comment: "")
            
        }
    }
}

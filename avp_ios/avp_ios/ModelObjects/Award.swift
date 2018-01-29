//
//  Award.swift
//  avp_ios
//
//  Created by kayeli dennis on 10/12/2017.
//  Copyright © 2017 kayeli dennis. All rights reserved.
//

import Foundation
import FirebaseDatabase

typealias Identifier = String

// Award Model

struct Award{

    // MARK: -Nominee

    struct Nominee {
        var email: String
        var id: Identifier
        var name: String

        init(dict: [String: String]) {
            self.email = dict[Key.email] ?? ""
            self.id = dict[Key.id] ?? ""
            self.name = dict[Key.name] ?? ""
        }
    }

    // MARK: -keys

    struct Key {
        static let endTime = "endTime"
        static let startTime = "startTime"
        static let votingOpen = "votingOpen"
        static let title = "title"
        static let nominees = "nominees"
        static let email = "email"
        static let id = "id"
        static let name = "name"
    }

    // MARK: -properties

    var endTime: Int
    var startTime: Int
    var title: String
    var votingOpen: Bool
    var id: Identifier
    var nominees: [Nominee]

    init(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String: AnyObject]
        self.endTime = value?[Key.endTime] as? Int ?? 0
        self.startTime = value?[Key.startTime] as? Int ?? 0
        self.title = value?[Key.title] as? String ?? ""
        self.votingOpen = value?[Key.votingOpen] as? Bool ?? false
        self.nominees = Award.listOFNominees(from: value?[Key.nominees] as? [String:[String: String]]) ?? [Award.Nominee]()
        self.id = snapshot.key 
    }

    // MARK: -helper func
    static func listOFNominees(from nominees: [String:[String: String]]?)-> [Nominee]?{
        guard let nominees = nominees?.values else { return nil }
        let nomineesList = nominees
            .reduce([Nominee]()) { (result, object) in
                // reflects current list
                var nomineesList = result
                let nominee = Nominee(dict: object)
                nomineesList.append(nominee)
                return nomineesList
        }
        return nomineesList
    }
}

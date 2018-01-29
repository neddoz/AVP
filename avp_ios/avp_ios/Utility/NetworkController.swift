//
//  NetworkController.swift
//  avp_ios
//
//  Created by kayeli dennis on 10/12/2017.
//  Copyright © 2017 kayeli dennis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

enum Result<T> {
    case success(T)
    case failure(Error)
}

class NetworkController {

    static let BaseURL = "https://us-central1-andela-avp-staging.cloudfunctions.net/"
    static let dataRootReference = Database.database().reference()

    static func fetchAwards(completion: @escaping ([Award])->Void){
        var awards = [Award]()
        dataRootReference.child("awards").observe(.value) { (datasnapshot) in
            for item in datasnapshot.children {
                if let item = item as? DataSnapshot {
                    let award = Award(snapshot: item)
                    awards.append(award)
                }
            }
            completion(awards)
        }
    }

    static func validateVote(completion: @escaping (Result<[String: Any]>)->Void){
        let urlSession = URLSession.shared
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard var componets = URLComponents(string: NetworkController.BaseURL + "fetchVotingData/") else { return }
        componets.queryItems = [URLQueryItem(name: "userId", value: userID)]
        guard let url = componets.url else { return }

        let task = urlSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }else{
                guard let data = data
                    else { return }

                do {

                    if let result = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        return completion(.success(result))
                    }

                } catch let error {
                    return completion(.failure(error))
                }
            }
        }

        task.resume()
    }

    static func postVote(for awardId: String, nomineeID: String, completion: @escaping (Result<[String: Any]>)->Void){
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let componets = URLComponents(string: NetworkController.BaseURL + "postVote/") else { return }
        guard let url = componets.url else { return }
        var request = URLRequest(url: url)
        let urlSession = URLSession.shared

        var object = [String: Any]()
        object["nomineeId"] = nomineeID
        object["awardId"] = awardId
        object["userId"] = userID

        guard  let dict = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return
        }
        request.httpBody = dict
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Verify that the user has not voted yet
        NetworkController.validateVote(){ result in
            switch result {
            case .failure(let error):
                 completion(.failure(error))
            case .success(let object):
                guard let alreadyVoted = object["alreadyVoted"] as? Bool else { return }
                if alreadyVoted {
                    let successMessage = ["status": "Looks Like you already voted😜! Never mind, your vote was updated!"]
                    let task = urlSession.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            completion(.failure(error))
                        }else{
                            guard let data = data
                                else { return }

                            do {

                                if let _ = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] {
                                    return completion(.success(successMessage))
                                }

                            } catch let error {
                                return completion(.failure(error))
                            }
                        }
                    }
                    task.resume()
                }else {
                    let successMessage = ["status": "Woot! Woot!😁...You have successfully voted!" ]
                    let task = urlSession.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            completion(.failure(error))
                        }else{
                            guard let data = data
                                else { return }

                            do {

                                if let _ = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] {
                                    return completion(.success(successMessage))
                                }

                            } catch let error {
                                return completion(.failure(error))
                            }
                        }
                    }
                    task.resume()
                }
            }
        }
    }
}

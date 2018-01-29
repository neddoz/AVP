//
//  CategoriesViewModel.swift
//  avp_ios
//
//  Created by kayeli dennis on 10/12/2017.
//  Copyright © 2017 kayeli dennis. All rights reserved.
//

import Foundation
import RxSwift

protocol AwardDelegate {
    func currentAwardChanged(with award: Award?, value: Bool)
}

class CategoriesViewModel{

    let awards: Variable<[Award]> = Variable([])

    var endDate: Date? {
        guard let currentAward = currentAward else { return nil }
        let date = Date(milliseconds: currentAward.endTime)
        return date
    }

    let disposeBag = DisposeBag()

    var currentAward: Award?{
        var value: Award?
        self.awards.value.forEach({ (award) in
            if award.votingOpen {
                value = award
            }
        })
        return value
    }

    var selectedCandidate: [Award.Nominee] = [Award.Nominee]()

    var awardDelegate: AwardDelegate?

    func numberOfRows()-> Int{
        guard let current = currentAward else { return 0 }
        return current.nominees.count
    }

    init() {

        // Kick Off awards fetch
        self.fetchAwards()

        // Listen for Awards change
            self.awards
                .asObservable()
                .subscribe { (awards) in
                    // clear the current award first

                    //self.currentAward = nil

//                    awards.element?.forEach({ (award) in
//                        if award.votingOpen {
//                            // self.currentAward = award
//                        }
//                    })
                    self.awardDelegate?.currentAwardChanged(with: self.currentAward, value: true)
        }.disposed(by: disposeBag)
    }

    func numberOfSections()-> Int{
        return 1
    }

    func fetchAwards() {
        NetworkController.fetchAwards(){ awards in
            // self.currentAward = nil
            self.awards.value = awards
        }
    }

    func candidateSelectedAt(at position: Int){
        // Be certain we have an open Award
        guard let currentAward = currentAward else { return }
        //making sure we always have one candidate
        if !self.selectedCandidate.isEmpty {
            selectedCandidate.remove(at: 0)
        }
        selectedCandidate.append(currentAward.nominees[position])
    }

    func deleteCandidateAt(at position: Int){
        if !self.selectedCandidate.isEmpty {
            if self.selectedCandidate.indices.contains(position){
                self.selectedCandidate.remove(at: position)
            }
        }
    }
}

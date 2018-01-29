//
//  CategoriesTableViewController.swift
//  avp_ios
//
//  Created by kayeli dennis on 09/12/2017.
//  Copyright © 2017 kayeli dennis. All rights reserved.
//

import UIKit
import RxSwift

class CategoriesTableViewController: UITableViewController {

    // MARK: -Outlets
    @IBOutlet weak var voteButton: UIBarButtonItem!
    @IBOutlet weak var timerLabel: UILabel!

    // MARK: -properties
    var viewModel: CategoriesViewModel?
    let disposeBag = DisposeBag()
    var seconds = 0
    var timer = Timer()
    var selectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        viewModel = appDel.viewModel
        viewModel?.awardDelegate = self

        self.voteButton.isEnabled = false
        self.navigationController?.navigationBar.tintColor = .white
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel?.numberOfRows() ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NomineeTableViewCell.reuseIdentifier) as? NomineeTableViewCell else { return UITableViewCell() }
        if let nominees = viewModel?.currentAward?.nominees{
            cell.configure(with: nominees[indexPath.row])
        }

        if(indexPath.row == selectedIndex)
        {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }

    // MARK: -Actions

    @IBAction func voteButtonPressed(_ sender: UIBarButtonItem) {
        submitSelection()
    }

    // MARK: -Functions

    func submitSelection(){
        guard let count = viewModel?.selectedCandidate.count else { return }
        let action = UIAlertAction(title: AlertTextMessages.oKText, style: .default, handler: nil)
        if count > 1 {
            let alertController = AlertCoordinator.alert(with: AlertTextMessages.InvalidSelection,
                                                         title: "Yo!",
                                                         actions: [action])
            self.present(alertController, animated: true, completion: nil)
            self.voteButton.isEnabled = true

        } else if count == 0 {
            let alertController = AlertCoordinator.alert(with: AlertTextMessages.NoSelection,
                                                         title: "Yo!",
                                                         actions: [action])
            self.present(alertController, animated: true, completion: nil)

        } else {
            submitVote()

        }
    }

    func submitVote() {
        guard let currentAward = viewModel?.currentAward else { return }
        guard let nomineeID = viewModel?.selectedCandidate[0].id else { return }
        NetworkController.postVote(for: currentAward.id, nomineeID: nomineeID) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                let alertController = AlertCoordinator.alert(with: AlertTextMessages.NetworkErrorMessage,
                                                             title: "Oops😔!",
                                                             actions: nil)
                self.present(alertController, animated: true, completion: nil)

            case .success(let object):
                let alertController = AlertCoordinator.alert(with: object["status"] as? String ?? "",
                                                             title: "Yo!",
                                                             actions: nil)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    @objc func updateTimer() {

        if seconds == 0 && viewModel?.currentAward != nil {
            self.voteButton.isEnabled = false
            timerLabel.text = "Time Out for this Category"
           // viewModel?.currentAward = nil
            tableView.reloadData()
            timer.invalidate()
        }else if seconds == 0 && viewModel?.currentAward == nil{
            timer.invalidate()
            self.voteButton.isEnabled = false
            timerLabel.text = "Time Out for this Category"
            tableView.reloadData()
        }else if self.seconds < 0{
            timer.invalidate()
            self.voteButton.isEnabled = false
            timerLabel.text = "Time Out for this Category"
            tableView.reloadData()
        }else {
            seconds -= 1     //This will decrement(count down)the seconds.
            timerLabel.text = "\(seconds)" //This will update the label.
        }
    }

    func runTimer() {
        let now = Date()
        let calendar = Calendar.current
        guard let endDate = viewModel?.endDate else { return }
        let dateComponents = calendar.dateComponents(Set<Calendar.Component>([.second]), from: now, to: endDate)
        guard let seconds = dateComponents.second else { return }
        self.seconds = seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        if self.seconds == 0{
            timer.invalidate()
        }
    }
}

extension CategoriesTableViewController: AwardDelegate {
    func currentAwardChanged(with award: Award?, value: Bool) {
        let title = viewModel?.currentAward?.title
        if let _ = award {
            self.voteButton.isEnabled = true
            runTimer()
        } else {
            timer.invalidate()
            timerLabel.text = "No Open Award"
            //viewModel?.currentAward = nil
        }
        self.title = title
        tableView.reloadData()
    }
}

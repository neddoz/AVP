//
//  CategoriesTableViewControllerDelegate.swift
//  avp_ios
//
//  Created by kayeli dennis on 11/12/2017.
//  Copyright © 2017 kayeli dennis. All rights reserved.
//

import Foundation

extension CategoriesTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        self.selectedIndex = indexPath.row
        cell.backgroundColor = UIColor(red: CGFloat(255), green: CGFloat(255), blue: CGFloat(255), alpha: 1)
        // update the selected Candidate
        toggleCellCheckbox(cell, at: indexPath.row)
        self.tableView.reloadData()
    }

    func toggleCellCheckbox(_ cell: UITableViewCell, at: Int) {
        // Dont allow multiple selection
        cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
        // update the selectedCandidate
        if cell.accessoryType == .none {
            viewModel?.deleteCandidateAt(at: at)
        }else {
            viewModel?.candidateSelectedAt(at: at)
        }
    }
}

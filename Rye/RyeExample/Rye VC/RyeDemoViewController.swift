//
//  ViewController.swift
//  RyeExample
//
//  Created by Andrei Hogea on 12/06/2019.
//  Copyright © 2019 Nodes. All rights reserved.
//

import UIKit
import Rye

class RyeDemoViewController: UITableViewController {
    
    enum Section: Int {
        case introduction
        case text
        case insets
        case dismissMode
        case viewType
        case position
        case animationtype
    }
    
    @IBOutlet weak var insetStepper: UIStepper!
    @IBOutlet weak var insetsLabel: UILabel!
    // MARK: - Outlets
    @IBOutlet weak var ryeMessageTextField: UITextField!
    @IBOutlet weak var dismissRyeButton: UIButton!
    @IBOutlet weak var generateMessageButton: UIButton!

    // MARK: - Variables
    var ryeViewController: RyeViewController?
    var isShowingNonDismissableMessage: Bool = false
    
    let contentInset: CGFloat = 20.0
    var dismissMode: Rye.DismissMode = .automatic(interval: Rye.defaultDismissInterval)
    var viewType: Rye.ViewType = .standard(configuration: nil)
    var position: Rye.Position = .top(inset: 20.0)
    var animationType: Rye.AnimationType = .slideInOut
    var uniformInset: CGFloat = 0 {
        didSet {
            insetsLabel.text = "\(uniformInset)"
        }
    }
    let customView = RyeImageView.fromNib()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        uniformInset = { uniformInset }()
        tableView.tableFooterView = UIView()
        dismissRyeButton.isHidden = true
    }
    
    // MARK: - TableView methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .introduction, .insets, .text:
            break
        case .dismissMode:
            updateDismissMode(for: indexPath)
        case .viewType:
            updateViewMode(for: indexPath)
        case .position:
            updatePosition(for: indexPath)
        case .animationtype:
            updateAnimationType(for: indexPath)
       
        }
    }
    
    private func updateDismissMode(for indexPath: IndexPath) {
        for row in 0...2 {
            tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section))?.accessoryType = .none
        }
        tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.accessoryType = .checkmark
        switch indexPath.row {
        case 0:
            dismissMode = .automatic(interval: Rye.defaultDismissInterval)
        case 1:
            dismissMode = .gesture
        case 2:
            dismissMode = .nonDismissable
        default:
            break
        }
    }
    
    private func updateViewMode(for indexPath: IndexPath) {
        for row in 0...1 {
            tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section))?.accessoryType = .none
        }
        tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.accessoryType = .checkmark
        switch indexPath.row {
        case 0:
            viewType = .standard(configuration: nil)
        case 1:
            viewType = .custom(customView, animationType: animationType)
//            viewType = .custom(customView, animationType: animationType, ignoreSafeAreas: true)
        default:
            break
        }
    }

    private func updatePosition(for indexPath: IndexPath) {
        for row in 0...1 {
            tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section))?.accessoryType = .none
        }
        tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.accessoryType = .checkmark
        switch indexPath.row {
        case 0:
            position = .top(inset: contentInset)
        case 1:
            position = .bottom(inset: contentInset)
        default:
            break
        }
    }


    private func updateAnimationType(for indexPath: IndexPath) {
        for row in 0...1 {
            tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section))?.accessoryType = .none
        }
        tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section))?.accessoryType = .checkmark
        switch indexPath.row {
        case 0:
            animationType = .slideInOut
        case 1:
            animationType = .fadeInOut
        default:
            break
        }
    }
    @IBAction func uniformInsetsChanged(_ sender: UIStepper) {
        
        self.uniformInset = CGFloat(sender.value)
    }
    
    // MARK: - IBActions
    @IBAction func didTapGenerateMessage(_ sender: UIButton) {
        var selectedViewType = viewType
        generateMessageButton.isEnabled = false

        if case Rye.ViewType.standard = viewType {
            let ryeConfiguration: RyeConfiguration = [
                .insets: UIEdgeInsets.init(top: uniformInset, left: uniformInset, bottom: uniformInset, right: uniformInset),
                .text : ryeMessageTextField.text ?? "",
                .backgroundColor: UIColor.black.withAlphaComponent(0.5),
                .animationType: animationType,
                .cornerRadius: CGFloat(15.0)
            ]
            selectedViewType = .standard(configuration: ryeConfiguration)
        }
        
        ryeViewController = RyeViewController(dismissMode: dismissMode,
                                              viewType: selectedViewType,
                                              at: position)
        
        ryeViewController?.show(withDismissCompletion: {
            self.ryeViewController = nil
            self.generateMessageButton.isEnabled = true
        })
        
        if case Rye.DismissMode.nonDismissable = dismissMode {
            dismissRyeButton.isHidden = false
        }
    }
    
    @IBAction func didTapDismissMessage(_ sender: UIButton) {
        ryeViewController?.dismiss()
        dismissRyeButton.isHidden = true
    }
}

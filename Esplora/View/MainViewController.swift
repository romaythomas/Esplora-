//
//  MainViewController.swift
//  CodeTest
//
//  Created by Thomas Romay on 26/10/2020.
//  Copyright © 2020 Thomas Romay. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, StoryboardBased {
    static var storyboardName: String {
        return "ViewController"
    }

    // MARK: - IBOutlet:
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var txCountLabel: UILabel!
    @IBOutlet weak var recivedLabel: UILabel!
    @IBOutlet weak var unspentLabel: UILabel!
    
    // MARK: - parameter:
    let searchViewcontroller = UISearchController(searchResultsController: nil)

    // MARK: - ViewModel:
    var viewModel = MainViewModel()

    // MARK: - Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.bindUI()
        self.viewModel.onViewLoaded()
    }

    // MARK: - Private helper methods:
    private func bindUI() {
        self.viewModel.address.addObserver(self) {
            self.addressLabel.text = $0
        }
        self.viewModel.texCount.addObserver(self) {
            self.txCountLabel.text = $0
        }
        self.viewModel.confrimedRecieved.addObserver(self) {
            self.recivedLabel.text = $0
        }
        self.viewModel.confrimedUnspent.addObserver(self) {
            self.unspentLabel.text = $0
        }
    }

    private func setupView() {
        self.setupNavBar()
        self.drawShadow(on: topView)
        self.drawShadow(on: middleView)
        self.drawShadow(on: bottomView)
    }

    private func setupNavBar() {
        self.searchViewcontroller.obscuresBackgroundDuringPresentation = false
        self.searchViewcontroller.searchBar.placeholder = "Search for address"
        self.searchViewcontroller.searchBar.delegate = self

        self.navigationItem.searchController = searchViewcontroller
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func drawShadow(on view: UIView) {
        view.layer.cornerRadius = 15

        view.layer.shadowColor = CGColor(srgbRed: 0, green: 0, blue: 20, alpha: 0.1)
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.9
        view.layer.shadowRadius = 5

        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
}

// MARK: - SearchBar Delegate:
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let value = searchBar.text else { return }
        self.viewModel.onSearchStringUpdated(to: value)
    }
}

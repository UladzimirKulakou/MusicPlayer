//
//  MainTabBarController.swift
//  MusicPlayer
//
//  Created by Владимир  on 23.04.22.
//

import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate: class {
    func minimiseTrackDetailController()
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?)
}


class MainTabBarController: UITabBarController {
    private var minimizedTopAnchorConstraints: NSLayoutConstraint!
    private var maximizedTopAnchorConstraints: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 0.9617310166, green: 0.2459604144, blue: 0.3703291714, alpha: 1)
        setupTrackDetailView()
        searchVC.tabBarDelegate = self
        var library = Library()
        library.tabBarDelegate = self
        let hostVC = UIHostingController(rootView: library)
        hostVC.tabBarItem.image = #imageLiteral(resourceName: "Library - Selected")
        hostVC.tabBarItem.title = "Library"

        viewControllers = [
            hostVC,
            generateViewController(rootViewController: searchVC, image: #imageLiteral(resourceName: "Search - Selected"), title: "Search")


        ]
    }

    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }

    private func setupTrackDetailView() {

        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)

        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraints = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraints = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)

        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true


        maximizedTopAnchorConstraints.isActive = true

        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

}

extension MainTabBarController: MainTabBarControllerDelegate {
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        minimizedTopAnchorConstraints.isActive = false
        maximizedTopAnchorConstraints.isActive = true

        maximizedTopAnchorConstraints.constant = 0
        bottomAnchorConstraint.constant = 0

        UIView.animate(withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
                self.tabBar.alpha = 0
                self.trackDetailView.miniTrackView.alpha = 0
                self.trackDetailView.maximaizedStackView.alpha = 1
            },
            completion: nil)

        guard let viewModel = viewModel else { return }
        self.trackDetailView.set(viewModel: viewModel)
    }

    func minimiseTrackDetailController() {

        maximizedTopAnchorConstraints.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraints.isActive = true

        UIView.animate(withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
                self.tabBar.alpha = 1
                self.trackDetailView.miniTrackView.alpha = 1
                self.trackDetailView.maximaizedStackView.alpha = 0
            },
            completion: nil)
    }


}

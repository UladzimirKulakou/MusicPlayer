//
//  FooterView.swift
//  MusicPlayer
//
//  Created by Владимир  on 1.05.22.
//

import UIKit

class FooterView: UIView {

    private var myLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.6313117146, green: 0.6470965147, blue: 0.6705061793, alpha: 1)
        return label
    }()

    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }

    private func setupElements() {
        addSubview(myLabel)
        addSubview(loader)

        loader.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        loader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        loader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true

        myLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        myLabel.topAnchor.constraint(equalTo: loader.bottomAnchor, constant: 8).isActive = true
    }

    func showLoader() {
        loader.startAnimating()
        myLabel.text = "LOADING"

    }
    func hideLoader() {
        loader.stopAnimating()
        myLabel.text = ""

    }

}

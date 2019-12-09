//
//  ViewController.swift
//  Oregano
//
//  Created by Dean Silfen on 12/8/19.
//  Copyright © 2019 Dean Silfen. All rights reserved.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    let analysisView = UITextView()
    var currentAnalysis: PhotoAnalysis?
    override func viewDidLoad() {
        super.viewDidLoad()
        analysisView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(analysisView)
        NSLayoutConstraint.activate([
            analysisView.topAnchor.constraint(equalTo: view.topAnchor),
            analysisView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            analysisView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            analysisView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        let barButtonItem = UIBarButtonItem(
            title: "📷",
            style: .plain,
            target: self,
            action: #selector(showPhotoPicker(sender:))
        )
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analysisView.text = "okay"
    }

    @objc
    func showPhotoPicker(sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }

}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let url = info[.imageURL] as? URL else {
            return
        }
        currentAnalysis = PhotoAnalysis(fileURL: url)
        try? currentAnalysis?.analysis { [weak self] (string) in
            DispatchQueue.main.async { [weak self] in
                self?.currentAnalysis = nil
                self?.analysisView.text = string ?? "N/A"
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension ViewController: UINavigationControllerDelegate {
    
}

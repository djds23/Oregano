//
//  ViewController.swift
//  Oregano
//
//  Created by Dean Silfen on 12/8/19.
//  Copyright © 2019 Dean Silfen. All rights reserved.
//

import UIKit
import SwiftUI
import Yams

class ViewController: UIViewController {
    let analysisView = UITextView()
    let segmentView = UISegmentedControl(items: EditingState.allCases.map { $0.text })
    let mainStack = UIStackView()
    var currentAnalysis: PhotoAnalysis?
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        analysisView.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        
        [
            segmentView,
            analysisView
        ].forEach { mainStack.addArrangedSubview($0) }

        segmentView.addTarget(
            self,
            action: #selector(segmentChanged(sender:)),
            for: .valueChanged
        )

        segmentView.selectedSegmentIndex = EditingState.default.segment
        
        analysisView.delegate = self
        let photoBarButtonItem = UIBarButtonItem(
            title: "📷",
            style: .plain,
            target: self,
            action: #selector(showPhotoPicker(sender:))
        )

        let exportBarButtonItem = UIBarButtonItem(
            title: "Export",
            style: .plain,
            target: self,
            action: #selector(exportFile(sender:))
        )

        navigationItem.leftBarButtonItem = exportBarButtonItem
        navigationItem.rightBarButtonItem = photoBarButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analysisView.text = Store.shared.currentText
    }

    @objc
    func showPhotoPicker(sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }

    @objc
    func exportFile(sender: Any) {
        let codable = Store.shared.currentState.recipe
        if let encoded = try? YAMLEncoder().encode(codable) {
            let activityController = UIActivityViewController(
                activityItems: [encoded],
                applicationActivities: nil
            )
            present(activityController, animated: true, completion: nil)
        }
    }
    
    @objc
    func segmentChanged(sender: Any) {
        let currentSegment = segmentView.selectedSegmentIndex
        if let state = EditingState.statesByIndex[currentSegment] {
            Store.shared.update(action: .updateEditingState(state))
        }
        analysisView.text = Store.shared.currentText
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
                Store.shared.update(action: .updateText(string))
                self?.analysisView.text = Store.shared.currentText
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        Store.shared.update(action: .updateText(textView.text))
    }
}

extension ViewController: UINavigationControllerDelegate { }

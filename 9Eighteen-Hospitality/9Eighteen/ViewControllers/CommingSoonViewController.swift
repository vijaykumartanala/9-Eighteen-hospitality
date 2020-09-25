//
//  CommingSoonViewController.swift
//  9Eighteen
//
//  Created by Vijaykumar Tanala on 23/03/20.
//  Copyright © 2020 vijaykumar Tanala. All rights reserved.
//

import UIKit
import PDFKit

class CommingSoonViewController: UIViewController {
    let pdfView = PDFView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Terms & Conditions"
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        guard let path = Bundle.main.url(forResource: "tc", withExtension: "pdf") else { return }
        if let document = PDFDocument(url: path) {
            pdfView.document = document
        }
    }
}

//Eliminating the gap between pools, rooms, docks and much more at our hospitality partner resorts

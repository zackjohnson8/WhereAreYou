//
//  AnnotationListViewController.swift
//  MapUsage
//
//  Created by Zachary Johnson on 6/8/20.
//  Copyright © 2020 Zachary Johnson. All rights reserved.
//

import UIKit
import TinyConstraints
import CoreData

class AnnotationListViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 10.0
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PersistanceService.saveContext()
        
        
        
        //scrollView.backgroundColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 0.5) /* #fefcf9 #f68009 */
        scrollView.showsVerticalScrollIndicator = false
        scrollView.layer.cornerRadius = 10.0
        SetupScrollViewConstraints()
        SetupScrollView()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).cgColor, UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0).cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.layer.frame
        //scrollView.layer.insertSublayer(gradientLayer, at: 0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
    }
    
    fileprivate func SetupScrollViewConstraints()
    {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // scrollView contraints (parent this) requires atleast iOS 11
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: guide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        // stackView constraints (parent scrollView)
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    fileprivate func SetupScrollView()
    {
        let fetchRequest: NSFetchRequest<PinLocation> = PinLocation.fetchRequest()
        do {
            let pinLocation = try PersistanceService.context.fetch(fetchRequest)
            for pin in pinLocation
            {
                let newUIView: StackViewContent = StackViewContent()
                stackView.addArrangedSubview(newUIView)
                newUIView.initialize(parent: stackView, title: pin.title!, description: pin.subtitle!, image: "pindrop")
            }
        }catch
        {
            print("Failed to load pin data")
        }
    }
    
}


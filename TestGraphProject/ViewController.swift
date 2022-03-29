//
//  ViewController.swift
//  TestGraphProject
//
//  Created by Taras Chernysh on 29.03.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var graphView: StatisticGraphView?
    
    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        graphView?.animateGraph()
    }

    private func setup() {
        let info = viewModel.makeConfigs()
        graphView = StatisticGraphView(
            configs: info.0,
            maxMoodLevel: info.1
        )
        guard let graphView = graphView else { return }
        view.addSubview(graphView)
        graphView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(350)
        }
    }

}


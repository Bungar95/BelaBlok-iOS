//
//  CalculationViewController.swift
//  BelotScore
//
//  Created by Borna Ungar on 24.11.2021..
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class CalculationViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let callView: UIView = {
        let view = UIView()
        return view
    }()
    
    let ourPointsContainerView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .systemTeal
        view.distribution = .fillEqually
        view.axis = .vertical
        view.layoutMargins = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        view.spacing = 10
        view.isLayoutMarginsRelativeArrangement = true
        view.layer.borderWidth = 1
        return view
    }()
    
    let theirPointsContainerView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .systemTeal
        view.distribution = .equalSpacing
        view.axis = .vertical
        view.spacing = 10
        view.layoutMargins = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        view.isLayoutMarginsRelativeArrangement = true
        view.layer.borderWidth = 1
        return view
    }()
    
    let ourCallButton: UIButton = {
        let btn = UIButton()
        btn.layer.borderWidth = 1
        return btn
    }()
    
    let theirCallButton: UIButton = {
        let btn = UIButton()
        btn.layer.borderWidth = 1
        return btn
    }()
    
    let callLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "Zvanje Aduta"
        label.textAlignment = .center
        return label
    }()
    
    let ourLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "MI"
        label.textAlignment = .center
        return label
    }()
    
    let theirLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "VI"
        label.textAlignment = .center
        return label
    }()
    
    let ourPointsScores: UITextField = {
        let field = UITextField()
        field.placeholder = "Bodovi"
        field.textAlignment = .center
        field.keyboardType = .numberPad
        field.adjustsFontSizeToFitWidth = true
        return field
    }()
    
    let theirPointsScores: UITextField = {
        let field = UITextField()
        field.placeholder = "Bodovi"
        field.textAlignment = .center
        field.keyboardType = .numberPad
        return field
    }()
    
    let ourCallScore: UITextField = {
        let field = UITextField()
        field.placeholder = "Zvanja"
        field.textAlignment = .center
        field.keyboardType = .numberPad
        return field
    }()
    
    let theirCallScore: UITextField = {
        let field = UITextField()
        field.placeholder = "Zvanja"
        field.textAlignment = .center
        field.keyboardType = .numberPad
        return field
    }()
    
    let ourScoreSumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.text = "0"
        label.textAlignment = .center
        label.backgroundColor = .gray
        return label
    }()
    
    let theirScoreSumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.text = "0"
        label.backgroundColor = .gray
        return label
    }()
    
    let addScoreButton: UIButton = {
        let btn = UIButton()
        btn.isEnabled = false
        btn.setTitle("DODAJ", for: .normal)
        btn.backgroundColor = .systemGray
        return btn
    }()
    
    let viewModel: CalculationViewModel
    
    init(viewModel: CalculationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeVM()
        initializeButton()
        initializeTextFields()
    }
    
}

private extension CalculationViewController {
    
    func setupUI(){
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        view.addSubviews(views: callView, ourPointsContainerView, theirPointsContainerView, ourScoreSumLabel, theirScoreSumLabel, addScoreButton)
        
        callView.addSubviews(views: ourCallButton, theirCallButton, callLabel)
        
        ourPointsContainerView.addArrangedSubview(ourLabel)
        ourPointsContainerView.addArrangedSubview(ourPointsScores)
        ourPointsContainerView.addArrangedSubview(ourCallScore)
        
        theirPointsContainerView.addArrangedSubview(theirLabel)
        theirPointsContainerView.addArrangedSubview(theirPointsScores)
        theirPointsContainerView.addArrangedSubview(theirCallScore)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        
        callView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        ourCallButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        theirCallButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
        callLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalTo(ourCallButton.snp.trailing).offset(20)
            make.trailing.equalTo(theirCallButton.snp.leading).offset(-20)

        }
        
        ourPointsContainerView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(callLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(callLabel.snp.leading)
        }
        
        theirPointsContainerView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(callLabel.snp.bottom).offset(25)
            make.trailing.equalToSuperview().offset(-10)
            make.leading.equalTo(callLabel.snp.trailing)
        }
        
        ourScoreSumLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(ourPointsContainerView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(callLabel.snp.leading).offset(-20)
        }
        
        theirScoreSumLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(theirPointsContainerView.snp.bottom).offset(30)
            make.leading.equalTo(callLabel.snp.trailing).offset(30)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        addScoreButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(ourScoreSumLabel.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: Initialize Button
    func initializeButton() {
        addScoreButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.calculationSubject.onNext(())
            }).disposed(by: disposeBag)
        
        ourCallButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.whoCalls = 0
                addScoreButton.isEnabled = true
                addScoreButton.backgroundColor = .systemGreen
                ourCallButton.backgroundColor = .gray
                theirCallButton.backgroundColor = .clear
            }).disposed(by: disposeBag)
        
        theirCallButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.whoCalls = 1
                addScoreButton.isEnabled = true
                addScoreButton.backgroundColor = .systemGreen
                theirCallButton.backgroundColor = .gray
                ourCallButton.backgroundColor = .clear
            }).disposed(by: disposeBag)
        
    }
    
    // MARK: Initialize TextFields
    func initializeTextFields() {
        
        ourPointsScores.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { _ in
                var points = Int(self.ourPointsScores.text  ?? "") ?? 0

                if points > 162 {
                    self.ourPointsScores.text = "162"
                    points = 162
                } else if (points < 0) {
                    self.ourPointsScores.text = "0"
                    points = 0
                }
                
                self.viewModel.ourPoints = points
                self.viewModel.theirPoints = 162-points
                self.theirPointsScores.text = "\(162-self.viewModel.ourPoints)"
                self.viewModel.sumSubject.onNext(())
            })
            .disposed(by: disposeBag)
        
        theirPointsScores.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { _ in
                var points = Int(self.theirPointsScores.text  ?? "") ?? 0
                
                if points > 162 {
                    self.theirPointsScores.text = "162"
                    points = 162
                } else if (points < 0) {
                    self.theirPointsScores.text = "0"
                    points = 0
                }
                
                self.viewModel.theirPoints = points
                self.viewModel.ourPoints = 162-points
                self.ourPointsScores.text = "\(162-self.viewModel.theirPoints)"
                self.viewModel.sumSubject.onNext(())
            })
            .disposed(by: disposeBag)
        
        ourCallScore.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { _ in
                let points = Int(self.ourCallScore.text  ?? "") ?? 0
                self.viewModel.ourCallPoints = points
                self.ourCallScore.text = "\(points)"
                self.viewModel.sumSubject.onNext(())
            })
            .disposed(by: disposeBag)
        
        theirCallScore.rx.controlEvent([.editingChanged])
            .asObservable()
            .subscribe(onNext: { _ in
                let points = Int(self.theirCallScore.text  ?? "") ?? 0
                self.viewModel.theirCallPoints = points
                self.theirCallScore.text = "\(points)"
                self.viewModel.sumSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }
}

private extension CalculationViewController{
    
    func initializeVM() {
        disposeBag.insert(self.viewModel.initializeViewModelObservables())
        initializeSumScoreObservable(subject: viewModel.sumSubject).disposed(by: disposeBag)
        initializeFinishVC(subject: viewModel.vcSubject).disposed(by: disposeBag)
    }
    
    func initializeSumScoreObservable(subject: ReplaySubject<()>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] score in
                let ourSum = self.viewModel.ourCallPoints + self.viewModel.ourPoints
                let theirSum = self.viewModel.theirCallPoints + self.viewModel.theirPoints
                ourScoreSumLabel.text = "\(ourSum)"
                theirScoreSumLabel.text = "\(theirSum)"
            })
    }
    
    func initializeFinishVC(subject: ReplaySubject<()>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] score in
                navigationController?.popViewController(animated: true)
            })
    }
    
}

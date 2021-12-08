//
//  ViewController.swift
//  BelotScore
//
//  Created by Borna Ungar on 13.11.2021..
//

import SnapKit
import RxSwift
import RxCocoa
import UIKit

class StartViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Bela Blok"
        label.font = .systemFont(ofSize: 28)
        return label
    }()
    
    let playedLabel: UILabel = {
        let label = UILabel()
        label.text = "Igra se do:"
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    let playedField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.placeholder = "1001"
        field.textAlignment = .center
        field.font = .systemFont(ofSize: 26)
        field.borderStyle = .roundedRect
        return field
    }()
    
    let startButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Nova igra", for: .normal)
        btn.backgroundColor = .systemTeal
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButton()
    }
}

private extension StartViewController {
    
    func setupUI(){
        view.backgroundColor = .white
        view.addSubviews(views: titleLabel, playedLabel, playedField, startButton)
        setupConstraints()
    }
    
    func setupConstraints(){
        
        titleLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        playedLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        playedField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(playedLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        
        startButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(playedField.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupButton() {
        
        startButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                
                if(playedField.text?.isEmpty == true){
                    navigationController?.pushViewController(PointsViewController(viewModel: PointsViewModelImpl(pointsNeededToWin: 1001)), animated: true)
                } else {
                    if let fieldValue = playedField.text {
                        if let num = Int(fieldValue) {
                            navigationController?.pushViewController(PointsViewController(viewModel: PointsViewModelImpl(pointsNeededToWin: num)), animated: true)
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
    }
    
}


//
//  PointsTableViewCell.swift
//  BelotScore
//
//  Created by Borna Ungar on 17.11.2021..
//

import UIKit
import SnapKit
import Foundation
import RxSwift
class PointsTableViewCell: UITableViewCell {
    
    let emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    let ourScoresLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    let theirScoresLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    let deleteButton: UIButton = {
        let infoButton = UIButton(type: .close)
        return infoButton
    }()
    
    var cellDisposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        cellDisposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(emptyMessage: String?, ourScore: Int?, theirScore: Int?) {
        if let emptyMessage = emptyMessage {
            emptyMessageLabel.text = emptyMessage
        }
        
        if let ourScore = ourScore {
            ourScoresLabel.text = "\(ourScore)"
        }
        
        if let theirScore = theirScore {
            theirScoresLabel.text = "\(theirScore)"
        }
    }
}

private extension PointsTableViewCell {
    
    func setupUI() {
        contentView.backgroundColor = .gray
        self.backgroundColor = .gray
        self.selectionStyle = .none
        
        contentView.addSubviews(views: ourScoresLabel, theirScoresLabel, deleteButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        ourScoresLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview().offset(-50)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        theirScoresLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview().offset(50)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        deleteButton.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.trailing.equalToSuperview().offset(-5)
        }
        
    }
}

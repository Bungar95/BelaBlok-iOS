//
//  PointsViewController.swift
//  BelotScore
//
//  Created by Borna Ungar on 15.11.2021..
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PointsViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let progressView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        return view
    }()
    
    let vsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.text = "MI : VI"
        label.textAlignment = .center
        return label
    }()
    
    let ourWinsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.backgroundColor = .gray
        return label
    }()
    
    let theirWinsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.backgroundColor = .gray
        return label
    }()
    
    let ourWinCountdownLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let theirWinCountdownLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let scoreWhiteSeperator: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28)
        return label
    }()
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .lightGray
        return tv
    }()
    
    let addScoreButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.backgroundColor = .systemRed
        return btn
    }()
    
    let viewModel: PointsViewModel
    
    init(viewModel: PointsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVM()
        setupUI()
        setupTableView()
        initializeButton()
        viewModel.restartGameSubject.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.refreshValuesSubject.onNext(())
    }
}

private extension PointsViewController {
    
    func setupTableView() {
        registerCells()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func registerCells() {
        tableView.register(PointsTableViewCell.self, forCellReuseIdentifier: "pointsTableViewCell")
    }
    
    func setupUI(){
        view.backgroundColor = .white
        view.addSubviews(views: progressView, vsLabel, ourWinsLabel, ourWinCountdownLabel, theirWinsLabel, theirWinCountdownLabel, scoreWhiteSeperator, scoreLabel, tableView, addScoreButton)
        
        view.bringSubviewToFront(progressView)
        
        refreshUIValues()
        setupConstraints()
    }
    
    func setupConstraints(){
        
        progressView.snp.makeConstraints{ (make) -> Void in
            make.centerX.centerY.equalToSuperview()
        }
        
        ourWinsLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalTo(vsLabel.snp.leading).offset(-15)
        }
        
        vsLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        theirWinsLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(vsLabel.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        scoreWhiteSeperator.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(vsLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        ourWinCountdownLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(vsLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalTo(scoreWhiteSeperator.snp.leading).offset(-15)
        }
        
        theirWinCountdownLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(vsLabel.snp.bottom).offset(20)
            make.leading.equalTo(scoreWhiteSeperator.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        scoreLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(scoreWhiteSeperator.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        tableView.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(scoreLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(addScoreButton.snp.top).offset(-5)
        }
        
        addScoreButton.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().offset(-50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
    }
    
    func initializeButton() {
        addScoreButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let controller = CalculationViewController(viewModel: CalculationViewModelImpl())
                navigationController?.pushViewController(controller, animated: true)
            }).disposed(by: disposeBag)
    }
}

extension PointsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayOfScores.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pointsCell = tableView.dequeueReusableCell(withIdentifier: "pointsTableViewCell", for: indexPath) as? PointsTableViewCell else {
            print("failed to dequeue the wanted cell")
            return UITableViewCell()
        }
        
        if (!viewModel.arrayOfScores.isEmpty){
            pointsCell.configureCell(emptyMessage: nil, ourScore: viewModel.arrayOfScores[indexPath.row][0], theirScore: viewModel.arrayOfScores[indexPath.row][1])
        }else{
            pointsCell.configureCell(emptyMessage: nil, ourScore: nil, theirScore: nil)
        }
        
        pointsCell.deleteButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.reducePoints(indexPath: indexPath.row, viewModel.arrayOfScores[indexPath.row][0], viewModel.arrayOfScores[indexPath.row][1])
            }).disposed(by: pointsCell.cellDisposeBag)
        
        return pointsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension PointsViewController{
    
    func initializeVM() {
        disposeBag.insert(self.viewModel.initializeViewModelObservables())
        initializeLoaderObservable(subject: viewModel.loaderSubject).disposed(by: disposeBag)
        initializeUIRefreshObservable(subject: viewModel.refreshUISubject).disposed(by: disposeBag)
    }
    
    func initializeLoaderObservable(subject: ReplaySubject<Bool>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (status) in
                if status {
                    showLoader()
                } else {
                    hideLoader()
                }
            })
    }
    
    func initializeUIRefreshObservable(subject: ReplaySubject<()>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (status) in
                refreshUIValues()
            })
    }
}

extension PointsViewController {
    func showLoader() {
        progressView.isHidden = false
        progressView.startAnimating()
    }
    
    func hideLoader() {
        progressView.isHidden = true
        progressView.stopAnimating()
    }
    
    func refreshUIValues(){
        tableView.reloadData()
        ourWinsLabel.text = "\(viewModel.wins[0])"
        theirWinsLabel.text = "\(viewModel.wins[1])"
        ourWinCountdownLabel.text = "\(viewModel.countDown[0])"
        theirWinCountdownLabel.text = "\(viewModel.countDown[1])"
        scoreLabel.text = "\(viewModel.currentScore[0]) : \(viewModel.currentScore[1])"
    }
}

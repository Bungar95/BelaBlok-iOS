//
//  PointsViewModelImpl.swift
//  BelotScore
//
//  Created by Borna Ungar on 15.11.2021..
//

import Foundation
import RxCocoa
import RxSwift
class PointsViewModelImpl: PointsViewModel {
    
    internal var pointsNeededToWin: Int
    var currentScore: [Int] = UserDefaults.standard.array(forKey: "currentScore") as? [Int] ?? [0, 0]
    var wins: [Int] = UserDefaults.standard.array(forKey: "wins") as? [Int] ?? [0, 0]
    var countDown: [Int] = UserDefaults.standard.array(forKey: "countdown") as? [Int] ?? [1001, 1001]
    var arrayOfScores: [[Int]] = UserDefaults.standard.array(forKey: "scores") as? [[Int]] ?? []
    
    var loaderSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var restartGameSubject = ReplaySubject<()>.create(bufferSize: 1)
    var refreshValuesSubject = ReplaySubject<()>.create(bufferSize: 1)
    var refreshUISubject = ReplaySubject<()>.create(bufferSize: 1)
    
    init(pointsNeededToWin: Int) {
        self.pointsNeededToWin = pointsNeededToWin
        UserDefaults.standard.set(pointsNeededToWin, forKey: "pointsNeededToWin")
    }
    
    func initializeViewModelObservables() -> [Disposable] {
        var disposables: [Disposable] = []
        disposables.append(initializeGameRestart(subject: restartGameSubject))
        disposables.append(initializeRefreshValues(subject: refreshValuesSubject))
        return disposables
    }
    
}

private extension PointsViewModelImpl {
    
    func initializeGameRestart(subject: ReplaySubject<()>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [self] _ in
                self.loaderSubject.onNext(true)
                UserDefaults.standard.set([0, 0], forKey: "wins")
                UserDefaults.standard.set([0, 0], forKey: "currentScore")
                UserDefaults.standard.set([], forKey: "scores")
                UserDefaults.standard.set(pointsNeededToWin, forKey: "pointsNeededToWin")
                UserDefaults.standard.set([pointsNeededToWin, pointsNeededToWin], forKey: "countdown")
                refreshValues()
                self.refreshUISubject.onNext(())
                self.loaderSubject.onNext(false)
            })
    }
    
    func initializeRefreshValues(subject: ReplaySubject<()>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [self] _ in
                self.loaderSubject.onNext(true)
                refreshValues()
                self.refreshUISubject.onNext(())
                self.loaderSubject.onNext(false)
            })
    }
    
}

private extension PointsViewModelImpl {
    
    func refreshValues() {
        self.pointsNeededToWin = UserDefaults.standard.integer(forKey: "pointsNeededToWin")
        self.currentScore = UserDefaults.standard.array(forKey: "currentScore") as? [Int] ?? [0, 0]
        self.wins = UserDefaults.standard.array(forKey: "wins") as? [Int] ?? [0, 0]
        self.countDown = UserDefaults.standard.array(forKey: "countdown") as? [Int] ?? [pointsNeededToWin, pointsNeededToWin]
        self.arrayOfScores = UserDefaults.standard.array(forKey: "scores") as? [[Int]] ?? []
        print(currentScore)
    }
}

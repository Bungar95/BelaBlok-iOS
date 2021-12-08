//
//  CalculationViewModelImpl.swift
//  BelotScore
//
//  Created by Borna Ungar on 25.11.2021..
//

import Foundation
import RxRelay
import RxSwift
class CalculationViewModelImpl: CalculationViewModel {
    
    var whoCalls = 0 // 0 - our, 1 - their
    var ourPoints = 0
    var theirPoints = 0
    var ourCallPoints = 0
    var theirCallPoints = 0
    var totalRoundPoints = 0
    var requiredPoints = 0
    var ourTotalPoints = 0
    var theirTotalPoints = 0
    
    var pointsNeededToWin = UserDefaults.standard.integer(forKey: "pointsNeededToWin")
    var currentScore = UserDefaults.standard.array(forKey: "currentScore") as? [Int] ?? [0, 0]
    var wins = UserDefaults.standard.array(forKey: "wins") as? [Int] ?? [0, 0]
    var countDown = UserDefaults.standard.array(forKey: "countdown") as? [Int] ?? [0, 0]
    var arrayOfScores = UserDefaults.standard.array(forKey: "scores") as? [[Int]] ?? []
    
    var sumSubject = ReplaySubject<()>.create(bufferSize: 1)
    var calculationSubject = ReplaySubject<()>.create(bufferSize: 1)
    let vcSubject = ReplaySubject<()>.create(bufferSize: 1)
    
    init() {}
    
    func initializeViewModelObservables() -> [Disposable] {
        var disposables: [Disposable] = []
        disposables.append(initializeGameCalculations(subject: calculationSubject))
        return disposables
    }
    
}

private extension CalculationViewModelImpl {
    
    func initializeGameCalculations(subject: ReplaySubject<()>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [self] _ in
                totalRoundPoints = ourPoints+theirPoints+ourCallPoints+theirCallPoints
                requiredPoints = (totalRoundPoints/2)+1
                
                ourTotalPoints = ourPoints + ourCallPoints
                theirTotalPoints = theirPoints + theirCallPoints
                
                // Caller needs to have half+1 of the points, otherwise opposition gets all the points.
                checkPointsOfCaller()
                
                //If a team has 0 points, their call points don't count towards their total points and opposition gets extra 90 points.
                checkZeroPointsRule()
                
                updateValues()
                
                checkIfSomeoneWon()
                
                vcSubject.onNext(())
            })
    }
}

private extension CalculationViewModelImpl {
    
    func checkPointsOfCaller() {
        print("Required points: \(requiredPoints)")
        if(ourTotalPoints < requiredPoints && whoCalls == 0){
            print("We don't have enough points.")
            ourTotalPoints = 0
            theirTotalPoints = totalRoundPoints
        } else if(theirTotalPoints < requiredPoints && whoCalls == 1){
            print("They don't have enough points.")
            theirTotalPoints = 0
            ourTotalPoints = totalRoundPoints
        }
    }
    
    func checkZeroPointsRule() {
        if(ourPoints == 0){
            ourTotalPoints = 0
            theirTotalPoints = totalRoundPoints + 90
        } else if (theirPoints == 0) {
            theirTotalPoints = 0
            ourTotalPoints = totalRoundPoints + 90
        }
    }
    
    func updateValues() {
        
        arrayOfScores.append([ourTotalPoints, theirTotalPoints])
        UserDefaults.standard.set(arrayOfScores, forKey: "scores")
        
        countDown = [countDown[0] - ourTotalPoints, countDown[1] - theirTotalPoints]
        UserDefaults.standard.set([countDown[0], countDown[1]], forKey: "countdown")

        currentScore = [currentScore[0]+ourTotalPoints, currentScore[1]+theirTotalPoints]
        UserDefaults.standard.set([currentScore[0], currentScore[1]], forKey: "currentScore")
    }
    
    func checkIfSomeoneWon() {
        
        for i in 0...1 {
            
            if(currentScore[i] >= pointsNeededToWin){
                wins[i] += 1
                restartValues()
            }
        }
        
    }
    
    func restartValues() {
        UserDefaults.standard.set([wins[0], wins[1]], forKey: "wins")
        UserDefaults.standard.set([0, 0], forKey: "currentScore")
        UserDefaults.standard.set([], forKey: "scores")
        UserDefaults.standard.set(pointsNeededToWin, forKey: "pointsNeededToWin")
        UserDefaults.standard.set([pointsNeededToWin, pointsNeededToWin], forKey: "countdown")
        
    }
    
}

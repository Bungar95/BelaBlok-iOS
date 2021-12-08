//
//  PointsViewModel.swift
//  BelotScore
//
//  Created by Borna Ungar on 15.11.2021..
//

import Foundation
import RxCocoa
import RxSwift
protocol PointsViewModel: AnyObject {
    
    var pointsNeededToWin: Int {get}
    var arrayOfScores: [[Int]] {get set}
    var wins: [Int] {get set}
    var countDown: [Int] {get set}
    var currentScore: [Int] {get set}
    
    var loaderSubject: ReplaySubject<Bool> {get}
    var refreshValuesSubject: ReplaySubject<()> {get set}
    var refreshUISubject: ReplaySubject<()> {get set}
    var restartGameSubject: ReplaySubject<()> {get}
    
    func initializeViewModelObservables() -> [Disposable]
}

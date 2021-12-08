//
//  CalculationViewModel.swift
//  BelotScore
//
//  Created by Borna Ungar on 25.11.2021..
//

import Foundation
import RxRelay
import RxSwift
protocol CalculationViewModel: AnyObject {
    
    var whoCalls: Int {get set}
    var ourPoints: Int {get set}
    var theirPoints: Int {get set}
    var ourCallPoints: Int {get set}
    var theirCallPoints: Int {get set}
    
    var totalRoundPoints: Int {get set}
    var requiredPoints: Int {get set}
    var ourTotalPoints: Int {get set}
    var theirTotalPoints: Int {get set}
    
    var sumSubject: ReplaySubject<()> {get}
    var calculationSubject: ReplaySubject<()> {get}
    var vcSubject: ReplaySubject<()> {get}

    func initializeViewModelObservables() -> [Disposable]
    
}

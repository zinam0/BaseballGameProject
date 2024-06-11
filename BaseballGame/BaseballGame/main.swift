//
//  main.swift
//  BaseballGame
//
//  Created by 남지연 on 6/11/24.
//

import Foundation


enum ViewType {
    case start
    case record
    case exit
}

class RecordManager  {
    private var recordValues: [Int] = []
    
    func addRecordValue(_ value: Int) {
        recordValues.append(value)
    }
    
    func viewRecord() {
        
        if recordValues.isEmpty {
            print("기록이 없습니다 게임을 시작하세요")
        } else {
            print("⭐️ 게임 기록 ⭐️")
            recordValues.enumerated().map { idx, record in
                print("\(idx + 1)번째 게임 : 시도 횟수 - \(record)")
            }
        }
    }
}

class SceneManager {
    private let recordManager: RecordManager
    private let game: BaseballGame
    
    init(recordManager: RecordManager, game: BaseballGame) {
        self.recordManager = recordManager
        self.game = game
    }
    
    func startGame() {
        while true {
            print("환영합니다! 원하시는 번호를 입력해주세요 \n 1. 게임 시작하기  2. 게임 기록 보기  3. 종료하기")
            guard let pick = readLine(), let option = Int(pick) else {
                print("올바른 숫자를 입력하세요")
                continue
            }
            switch option {
            case 1 :
                game.startGame()
                break
            case 2 :
                recordManager.viewRecord()
            case 3 :
                print("게임종료")
                return
            default :
                print("올바른 숫자를 다시 입력하세요")
                
            }
            
        }
    }
}

class BaseballGame {
    private var answer: [Int] = []
    private var attempt: Int = 0
    private var record: RecordManager
    init(record: RecordManager) {
        self.record = record
    }
    
    private func updateRandomNumber() {
//        var answer = Array(0...9).shuffled().prefix(3).map{ $0 }
//        while answer.contains(0) {
//            answer = Array(0...9).shuffled().prefix(3).map{ $0 }
//        }
        
        var answer = Array(Array(1...9).shuffled().prefix(3))
        
        self.answer = answer
        //print("⭐️ \(answer) ⭐️")
    }
    
    func startGame() {
        answer = []
        attempt = 0
        updateRandomNumber()
        playGame()
        
    }
    
    func validationNumber(number: String) -> [Int]? {
        guard number.count == 3, let checkNum = Int(number) else { return nil }
        let digit = String(checkNum).compactMap { $0.wholeNumberValue }
        return Set(digit).count == 3 && !digit.contains(0) ? digit : nil
        
    }
    
    func checkNumber(_ number: [Int]) -> (strike: Int, ball: Int) {
        let strike = zip(number, answer).filter { $0 == $1 }.count
        let ball = number.filter { answer.contains($0) }.count - strike
        return (strike, ball)
    }
    
    func incrementAttemp() {
        attempt += 1
    }
    
    func playGame() {
        
        while true {
            print("숫자를 입력하세요")
            
            guard let value = readLine(), let checkNum = validationNumber(number: value) else {
                print("올바르지 않은 입력값입니다 다시 입력하세요")
                continue
            }
            
            incrementAttemp()
            
            let valid = checkNumber(checkNum)
            
            if valid.strike != 3 {
                print("\(valid.strike)strike \(valid.ball)ball")
            }
            else {
                record.addRecordValue(attempt)
                print("빙고 입니다")
                break
            }
        }
    }
}

let recordManager = RecordManager()
let baseballGame = BaseballGame(record: recordManager)
let sceneManager = SceneManager(recordManager: recordManager, game: baseballGame)
sceneManager.startGame()



import Foundation


enum Message: String, CustomStringConvertible {
    var description: String {
        return rawValue
    }
    case win = "이겼습니다!"
    case draw = "비겼습니다!"
    case lose = "졌습니다!"
    case exit = "게임 종료"
}

enum Player: String, CustomStringConvertible {
    var description: String {
        return rawValue
    }
    case computer = "컴퓨터"
    case user = "사용자"
}

enum ErrorMessage: Error {
    case wrongInput
    case systemError
}

struct RockPaperScissorsGame {
    private enum RockPaperScissorsChoice: Int {
        case scissors = 1
        case rock = 2
        case paper = 3
        case exit = 0
    }
    
    private var generatedChoiceOfComputer: Int {
        return Int.random(in: 1...3)
    }
    
    func startRockPaperScissors() {
        selectUserChoice()
    }
    
    private func receiveInput() throws -> String {
        guard let input = readLine() else {
            throw ErrorMessage.systemError
        }
        return input
    }
    
    private func selectUserChoice() {
        print("가위(1), 바위(2), 보(3)! <종료 : 0>", terminator: " : ")
        
        do {
            let inputUserChoice = try receiveInput()
            try checkValidInput(from: inputUserChoice)
        } catch ErrorMessage.wrongInput {
            print("잘못된 입력입니다. 다시 시도해주세요.")
            selectUserChoice()
        } catch ErrorMessage.systemError {
            print("[SystemError: nil]")
        } catch {
            print(error)
        }
    }
    
    private func checkValidInput(from userChoice: String) throws {
        guard let userChoice = Int(userChoice) else {
            throw ErrorMessage.wrongInput
        }
        
        guard userChoice == RockPaperScissorsChoice.scissors.rawValue || userChoice == RockPaperScissorsChoice.rock.rawValue || userChoice == RockPaperScissorsChoice.paper.rawValue || userChoice == RockPaperScissorsChoice.exit.rawValue else {
            throw ErrorMessage.wrongInput
        }
        
        guard userChoice == RockPaperScissorsChoice.exit.rawValue else {
            decideGameResult(from: userChoice)
            return
        }
        print(Message.exit)
    }
    
    private func decideGameResult(from userChoice: Int) {
        let choiceOfComputer = generatedChoiceOfComputer
        var mukChiPaGame = MukChiPaGame()
        
        if choiceOfComputer == userChoice {
            print(Message.draw)
            selectUserChoice()
        } else if userChoice == choiceOfComputer + 1 || userChoice == choiceOfComputer - 2 {
            print(Message.win)
            mukChiPaGame.startMukChiPa(winner: Player.user)
        } else {
            print(Message.lose)
            mukChiPaGame.startMukChiPa(winner: Player.computer)
        }
    }
}


struct MukChiPaGame {
    private enum MukChiPaChoice: Int {
        case muk = 1
        case chi = 2
        case pa = 3
        case exit = 0
    }
    
    private var generatedChoiceOfComputer: Int {
        return Int.random(in: 1...3)
    }
    
    private var turn: Player = Player.user
    
    private func receiveInput() throws -> String {
        guard let input = readLine() else {
            throw ErrorMessage.systemError
        }
        return input
    }
    
    mutating func startMukChiPa(winner: Player) {
        turn = winner
        print("[\(turn)턴] 묵(1), 찌(2), 빠(3)! <종료 : 0>", terminator: " : ")
        
        do {
            let inputUserChoice = try receiveInput()
            try checkValidInput(from: inputUserChoice)
        } catch ErrorMessage.wrongInput {
            print("잘못된 입력입니다. 다시 시도해주세요.")
            turn = Player.computer
            startMukChiPa(winner: turn)
        } catch ErrorMessage.systemError {
            print("[SystemError: nil]")
        } catch {
            print(error)
        }
    }
    
    private mutating func checkValidInput(from userChoice: String) throws {
        guard let userChoice = Int(userChoice) else {
            throw ErrorMessage.wrongInput
        }
        
        guard userChoice == MukChiPaChoice.muk.rawValue || userChoice == MukChiPaChoice.chi.rawValue || userChoice == MukChiPaChoice.pa.rawValue || userChoice == MukChiPaChoice.exit.rawValue else {
            throw ErrorMessage.wrongInput
        }
        
        guard userChoice == MukChiPaChoice.exit.rawValue else {
            decideGameResult(from: userChoice)
            return
        }
        print(Message.exit)
    }
    
    private mutating func decideGameResult(from userChoice: Int) {
        let choiceOfComputer = generatedChoiceOfComputer
        
        if choiceOfComputer == userChoice {
            print("\(turn)의 승리!")
        } else if userChoice == choiceOfComputer - 1 || userChoice == choiceOfComputer + 2 {
            turn = Player.user
            print("\(turn)의 턴입니다")
            startMukChiPa(winner: turn)
        } else {
            turn = Player.computer
            print("\(turn)의 턴입니다")
            startMukChiPa(winner: turn)
        }
    }
}


let rockPaperScissors = RockPaperScissorsGame()
rockPaperScissors.startRockPaperScissors()

import UIKit

// Ошибки при оплате банковской картой


enum CardOperationError: Error {
    // ошибка: недостаточно средств на карте
    case notenoughmoney (moneyNeeded: Double)
    // ошибка: баланс карты заблокирован
    case frozeBalance
}


struct item {
    var price: Double
}


class CreditCardOperation {
    
    let limit: Double = -50000
    
    var balance: Double = 0
    
    var cardIsBlocked = false
    
  
    func buySomethig(thing: item)throws {
        guard cardIsBlocked == false else{
            throw CardOperationError.frozeBalance
        }
        
        guard thing.price <= (-limit + self.balance) else {
           
            if balance < 0 {
                throw CardOperationError.notenoughmoney(moneyNeeded: thing.price + limit + balance)
            } else {
                throw CardOperationError.notenoughmoney(moneyNeeded: thing.price + limit - balance)
            }
        }
      
        balance = self.balance - thing.price
    }
    // Пополнение счета
    func depositeMoney (someMoney: Double) {
        balance = self.balance + someMoney
    }
    
    // Узнать свой баланс
    func printBalance() {
        print ("Balance is \(balance) rub")
    }
    
    
    func changeCardState(cardIsBlocked: Bool) {
        switch cardIsBlocked {
        case true:
            self.cardIsBlocked = true
        case false:
            self.cardIsBlocked = false
        }
    }
}

extension CardOperationError: CustomStringConvertible {
    var description: String {
        switch self {
        case .notenoughmoney(let moneyNeeded): return "Недостаточно средств для проведения данной операции. Ваш баланс: \(operation.balance) rub, Не хватает: \(moneyNeeded) rub"
        case .frozeBalance: return "Ваша карта заблокирована. Для уточнения причины, пожалуйста обратитесь в Банк"
        }
    }
}


//балуемся с  нашей картой
let operation = CreditCardOperation()
do {
    try operation.buySomethig(thing: .init(price: 600.8))
} catch let error as CardOperationError {
    print(error.description)
}
operation.printBalance()
operation.depositeMoney(someMoney: 20000)
operation.printBalance()
do {
    try operation.buySomethig(thing: .init(price: 100000))
} catch let error as CardOperationError {
    print(error.description)
}
operation.printBalance()
do {
    try operation.buySomethig(thing: .init(price: 41000))
} catch let error as CardOperationError {
    print(error.description)
}
operation.printBalance()

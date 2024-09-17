//
//  QuoteTableViewController.swift
//  Purchase App
//
//  Created by 王嵩允 on 9/17/24.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    
    let productID = "com.songyunwang.purchaseApp.premiumQuotes"
    
    var quotesToShow = [
        "Be the best of whatever you are. — Martin Luther King, Jr.",
        "Promise me you’ll always remember: You’re braver than you believe, and stronger than you seem, and smarter than you think. — A. A. Milne",
        "I don’t like to gamble, but if there’s one thing I’m willing to bet on, it’s myself. — Beyoncé",
        "All our dreams can come true, if we have the courage to pursue them.— Walt Disney",
        "Do anything, but let it produce joy. — Henry Miller",
        "A woman is like a tea bag; you never know how strong it is until it’s in hot water.” ― Eleanor Roosevelt"
    ]
    
    let premiumQuotes = [
        "We need to take risks. We need to go broke. We need to prove them wrong, simply by not giving up. — Awkwafina",
        "Be courageous. Challenge orthodoxy. Stand up for what you believe in. When you are in your rocking chair talking to your grandchildren many years from now, be sure you have a good story to tell. — Amal Clooney",
        "It took me quite a long time to develop a voice, and now that I have it, I am not going to be silent. — Madeleine Albright",
        "Stay close to anything that makes you glad you are alive. — Hafez",
        "Be yourself; everyone else is already taken. ― Unknown",
        "The soul is stronger than its surroundings. — William James"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self)
        
        if isPurchased() {
            showPremiumQuotes()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return quotesToShow.count
        } else {
            return quotesToShow.count + 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = UIColor(.black)
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Get More Quotes..."
            cell.textLabel?.textColor = UIColor(red: 0.61, green: 0.53, blue: 1.00, alpha: 1.00)
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            buyPremiumQuotes()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - In-App Purchase Methods
    func buyPremiumQuotes() {
        // Check User can make payment
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("User can't make payment!")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                showPremiumQuotes()
                
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed due to error: \(errorDescription)")
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
            } else if transaction.transactionState == .restored {
                showPremiumQuotes()
                
                print("Transaction restored")
                
                // Once it been restored, then hide the restore button for better user experience
                navigationItem.setRightBarButton(nil, animated: true)
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func showPremiumQuotes() {
        // Store bool value that user has purchased it
        UserDefaults.standard.setValue(true, forKey: productID)
        
        quotesToShow.append(contentsOf: premiumQuotes)
        
        tableView.reloadData()
    }
    
    func isPurchased() -> Bool {
        return UserDefaults.standard.bool(forKey: productID)
    }

    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

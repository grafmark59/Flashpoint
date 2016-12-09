//
//  CenterViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//



import UIKit

@objc
protocol CardCenterViewControllerDelegate {
  @objc optional func toggleLeftPanel()
  @objc optional func toggleRightPanel()
  @objc optional func collapseSidePanels()
}

protocol SpecificDeckDelegate {
    func setAsMainDeck()->Deck?
}



class CardCenterViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var deckViewLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        mainDeck = (deckDelegate?.setAsMainDeck())!
        deckViewLabel.text = mainDeck?.deck_name
        mainDeck?.refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainDeck = (deckDelegate?.setAsMainDeck())!
        deckViewLabel.text = mainDeck?.deck_name
        mainDeck?.refresh()
    }
  
    var delegate: CardCenterViewControllerDelegate?
    var deckDelegate: SpecificDeckDelegate? = nil
    
    
    var mainDeck: Deck?
    
    //User.decks.names
    var cardLabels: [String] = ["Deck 1", "Deck 2", "Deck3", "Deck4", "Deck5", "Deck6"]
    var cardImages: [String] = ["back-1.png"]
    
    
    @IBAction func cancelToCardCenterViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveCardDetail(segue:UIStoryboardSegue) {
        //add the new player to the players array
        User.refresh()
        mainDeck?.refresh()
        //deckCardLabels = User.getDeckNames()
        collectionView.reloadData()
        //may need to update tableview
    }
    
  
    // MARK: Button actions
  
    @IBAction func test (_ sender: AnyObject) {
        //deckDelegate!.setAsMainDeck()
    }
  
    @IBAction func studyBarTapped(_ sender: AnyObject) {
        delegate?.toggleRightPanel?()
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddCard" {
            print("1")
            let navController = segue.destination as? UINavigationController
            print("2")
            if navController != nil {
                print("3")
                if navController?.visibleViewController is CardDetailsViewController {
                    print("4")
                    let AddCard = navController?.visibleViewController as! CardDetailsViewController
                    print("5")
                    AddCard.deck_id = mainDeck?.id
                    print("6")
                }
            }
        } else if segue.identifier == "StudySegue" {
            let viewController = segue.destination as? ViewController
            viewController?.deck = self.mainDeck
        }
    }
    
}



extension CardCenterViewController: UICollectionViewDataSource, CardCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mainDeck!.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCellIdentifier", for: indexPath) as! CardCell
        cell.cardLabel.text = mainDeck?.getCardInfo()[indexPath.row].0
        cell.cardImage.image = UIImage(named: cardImages[0])
        cell.delegate = self
        return cell
    }
    
    func toggleRightPanel() {
        print("REACHED DELEGATE",delegate)
        delegate?.toggleRightPanel?()
    }
}

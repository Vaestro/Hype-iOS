//
//  EPContactsPicker.swift
//  EPContacts
//
//  Created by Prabaharan Elangovan on 12/10/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit
import Contacts
import PopupDialog
import Branch
public protocol EPPickerDelegate {
	func epContactPicker(_: EPContactsPicker, didContactFetchFailed error: NSError)
    func epContactPicker(_: EPContactsPicker, didCancel error: NSError)
    func epContactPicker(_: EPContactsPicker, didSelectContact contact: EPContact)
	func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact])
    func epContactPicker(_: EPContactsPicker, didSubmitInvitesAndWantsToShowInquiry: PFObject)
    func epContactPickerDidSubmitInvitesAndWantsToShowEvent()
}

public extension EPPickerDelegate {
	func epContactPicker(_: EPContactsPicker, didContactFetchFailed error: NSError) { }
	func epContactPicker(_: EPContactsPicker, didCancel error: NSError) { }
	func epContactPicker(_: EPContactsPicker, didSelectContact contact: EPContact) { }
	func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) { }
    
}

typealias ContactsHandler = (_ contacts : [CNContact] , _ error : NSError?) -> Void

public enum SubtitleCellValue{
    case phoneNumber
    case email
    case birthday
    case organization
}

public enum PartyType{
    case generalAdmission
    case tableReservation
    case connect
}

open class EPContactsPicker: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: - Properties
    
    open var contactDelegate: EPPickerDelegate?
    var event: PFObject?
    var guestlistId: String?
    var contactsStore: CNContactStore?
    var resultSearchController = UISearchController()
    var orderedContacts = [String: [CNContact]]() //Contacts ordered in dicitonary alphabetically
    var sortedContactKeys = [String]()
    
    var selectedContacts = [EPContact]()
    var filteredContacts = [CNContact]()
    
    var subtitleCellValue = SubtitleCellValue.phoneNumber
    var partyType = PartyType.generalAdmission
    var multiSelectEnabled: Bool = false //Default is single selection contact
    
    // MARK: - Lifecycle Methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.title = EPGlobalConstants.Strings.contactsTitle
        self.view.backgroundColor = UIColor.black
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        registerContactCell()
        inititlizeBarButtons()
        initializeSearchBar()
        reloadContacts()
    }
    
    func initializeSearchBar() {
        self.resultSearchController = ( {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            self.tableView.tableHeaderView = controller.searchBar
            self.navigationController?.extendedLayoutIncludesOpaqueBars = true
            return controller
        })()
    }
    
    func inititlizeBarButtons() {
//        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(onTouchCancelButton))
//        self.navigationItem.leftBarButtonItem = cancelButton
        
        if multiSelectEnabled {
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(onTouchDoneButton))
            self.navigationItem.rightBarButtonItem = doneButton
            
        }
    }
    
    fileprivate func registerContactCell() {
        
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: EPGlobalConstants.Strings.bundleIdentifier, withExtension: "bundle") {
            
            if let bundle = Bundle(url: bundleURL) {
                
                let cellNib = UINib(nibName: EPGlobalConstants.Strings.cellNibIdentifier, bundle: bundle)
                tableView.register(cellNib, forCellReuseIdentifier: "Cell")
            }
            else {
                assertionFailure("Could not load bundle")
            }
        }
        else {
            
            let cellNib = UINib(nibName: EPGlobalConstants.Strings.cellNibIdentifier, bundle: nil)
            tableView.register(cellNib, forCellReuseIdentifier: "Cell")
        }
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Initializers
  
    convenience public init(delegate: EPPickerDelegate?) {
        self.init(delegate: delegate, multiSelection: false)
    }
    
    convenience public init(delegate: EPPickerDelegate?, multiSelection : Bool) {
        self.init(style: .plain)
        self.partyType = .generalAdmission
        self.multiSelectEnabled = multiSelection
        contactDelegate = delegate
    }

    convenience public init(delegate: EPPickerDelegate?, partyType: PartyType, multiSelection : Bool, subtitleCellType: SubtitleCellValue, event: PFObject, guestlistId: String) {
        self.init(style: .plain)
        self.multiSelectEnabled = multiSelection
        contactDelegate = delegate
        subtitleCellValue = subtitleCellType
        self.partyType = partyType
        self.event = event
        self.guestlistId = guestlistId
    }
    
    convenience public init(delegate: EPPickerDelegate?, partyType: PartyType, multiSelection : Bool, subtitleCellType: SubtitleCellValue, event: PFObject) {
        self.init(style: .plain)
        self.multiSelectEnabled = multiSelection
        contactDelegate = delegate
        subtitleCellValue = subtitleCellType
        self.partyType = partyType
        self.event = event
    }
    
    
    // MARK: - Contact Operations
  
      open func reloadContacts() {
        getContacts( {(contacts, error) in
            if (error == nil) {
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        })
      }
  
    func getContacts(_ completion:  @escaping ContactsHandler) {
        if contactsStore == nil {
            //ContactStore is control for accessing the Contacts
            contactsStore = CNContactStore()
        }
        let error = NSError(domain: "EPContactPickerErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "No Contacts Access"])
        
        switch CNContactStore.authorizationStatus(for: CNEntityType.contacts) {
            case CNAuthorizationStatus.denied, CNAuthorizationStatus.restricted:
                //User has denied the current app to access the contacts.
                
                let productName = Bundle.main.infoDictionary!["CFBundleName"]!
                
                let alert = UIAlertController(title: "Unable to access contacts", message: "\(productName) does not have access to contacts. Kindly enable it in privacy settings ", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {  action in
                    self.contactDelegate?.epContactPicker(self, didContactFetchFailed: error)
                    completion([], error)
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            
            case CNAuthorizationStatus.notDetermined:
                //This case means the user is prompted for the first time for allowing contacts
                contactsStore?.requestAccess(for: CNEntityType.contacts, completionHandler: { (granted, error) -> Void in
                    //At this point an alert is provided to the user to provide access to contacts. This will get invoked if a user responds to the alert
                    if  (!granted ){
                        DispatchQueue.main.async(execute: { () -> Void in
                            completion([], error! as NSError?)
                        })
                    }
                    else{
                        self.getContacts(completion)
                    }
                })
            
            case  CNAuthorizationStatus.authorized:
                //Authorization granted by user for this app.
                var contactsArray = [CNContact]()
                
                let contactFetchRequest = CNContactFetchRequest(keysToFetch: allowedContactKeys())
                
                do {
                    try contactsStore?.enumerateContacts(with: contactFetchRequest, usingBlock: { (contact, stop) -> Void in
                        //Ordering contacts based on alphabets in firstname
                        contactsArray.append(contact)
                        var key: String = "#"
                        //If ordering has to be happening via family name change it here.
                        if let firstLetter = contact.givenName[0..<1] , firstLetter.containsAlphabets() {
                            key = firstLetter.uppercased()
                        }
                        var contacts = [CNContact]()
                        
                        if let segregatedContact = self.orderedContacts[key] {
                            contacts = segregatedContact
                        }
                        contacts.append(contact)
                        self.orderedContacts[key] = contacts

                    })
                    self.sortedContactKeys = Array(self.orderedContacts.keys).sorted(by: <)
                    if self.sortedContactKeys.first == "#" {
                        self.sortedContactKeys.removeFirst()
                        self.sortedContactKeys.append("#")
                    }
                    completion(contactsArray, nil)
                }
                //Catching exception as enumerateContactsWithFetchRequest can throw errors
                catch let error as NSError {
                    print(error.localizedDescription)
                }
            
        }
    }
    
    func allowedContactKeys() -> [CNKeyDescriptor]{
        //We have to provide only the keys which we have to access. We should avoid unnecessary keys when fetching the contact. Reducing the keys means faster the access.
        return [CNContactNamePrefixKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactOrganizationNameKey as CNKeyDescriptor,
            CNContactBirthdayKey as CNKeyDescriptor,
            CNContactImageDataKey as CNKeyDescriptor,
            CNContactThumbnailImageDataKey as CNKeyDescriptor,
            CNContactImageDataAvailableKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
        ]
    }
    
    // MARK: - Table View DataSource
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        if resultSearchController.isActive { return 1 }
        return sortedContactKeys.count
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive { return filteredContacts.count }
        if let contactsForSection = orderedContacts[sortedContactKeys[section]] {
            return contactsForSection.count
        }
        return 0
    }

    // MARK: - Table View Delegates

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EPContactCell
        cell.accessoryType = UITableViewCellAccessoryType.none
        //Convert CNContact to EPContact
		let contact: EPContact
        
        if resultSearchController.isActive {
            contact = EPContact(contact: filteredContacts[(indexPath as NSIndexPath).row])
        } else {
			guard let contactsForSection = orderedContacts[sortedContactKeys[(indexPath as NSIndexPath).section]] else {
				assertionFailure()
				return UITableViewCell()
			}

			contact = EPContact(contact: contactsForSection[(indexPath as NSIndexPath).row])
        }
		
        if multiSelectEnabled  && selectedContacts.contains(where: { $0.contactId == contact.contactId }) {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
		
        cell.updateContactsinUI(contact, indexPath: indexPath, subtitleType: subtitleCellValue)
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! EPContactCell
        let selectedContact =  cell.contact!
        if multiSelectEnabled {
            //Keeps track of enable=ing and disabling contacts
            if cell.accessoryType == UITableViewCellAccessoryType.checkmark {
                cell.accessoryType = UITableViewCellAccessoryType.none
                selectedContacts = selectedContacts.filter(){
                    return selectedContact.contactId != $0.contactId
                }
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                selectedContacts.append(selectedContact)
            }
        }
        else {
            //Single selection code
			resultSearchController.isActive = false
			self.dismiss(animated: true, completion: {
				DispatchQueue.main.async {
					self.contactDelegate?.epContactPicker(self, didSelectContact: selectedContact)
				}
			})
        }
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override open func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if resultSearchController.isActive { return 0 }
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: UITableViewScrollPosition.top , animated: false)        
        return sortedContactKeys.index(of: title)!
    }

    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if resultSearchController.isActive { return nil }
        return sortedContactKeys[section]
    }
    
    override open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionTitle = self.tableView(tableView, titleForHeaderInSection: section)
        if (sectionTitle == nil) {
            return nil
        }
        
        let label = UILabel(frame: CGRect(x:10, y:5, width:tableView.bounds.size.width, height:20))
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = sectionTitle
        
        let headerView = UIView(frame: CGRect(x:0, y:0, width:tableView.bounds.size.width, height:20))
        headerView.backgroundColor = UIColor.black
        
        headerView.addSubview(label)
        
        return headerView
    }
    // MARK: - Button Actions
    
    func onTouchCancelButton() {
        contactDelegate?.epContactPicker(self, didCancel: NSError(domain: "EPContactPickerErrorDomain", code: 2, userInfo: [ NSLocalizedDescriptionKey: "User Canceled Selection"]))
        dismiss(animated: true, completion: nil)
    }
    
    func sendInvitationsForGeneralAdmission() {
        
    }
    func onTouchDoneButton() {
//        contactDelegate?.epContactPicker(self, didSelectMultipleContacts: selectedContacts)
//        dismiss(animated: true, completion: nil)
  
        
        if (partyType == .generalAdmission) {
            self.sendOutInvitations()
        } else {
            self.submitConnectInquiry()
            
                    }
    }
    
    func sendOutInvitations() {
        let guestPhoneNumbers = selectedContacts.map { $0.phoneNumbers[0].phoneNumber }
        
        let eventId:String = (event?.objectId)!
        let eventDate:Date = event?.value(forKey: "date") as! Date
        let location:PFObject = event?.value(forKey: "location") as! PFObject
        let locationName:String = location.value(forKey: "name") as! String
        let locationInfo:String = location.value(forKey: "info") as! String
        
        let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "event/\(event?.objectId)")
        branchUniversalObject.title = locationName
        branchUniversalObject.contentDescription = locationInfo
        branchUniversalObject.addMetadataKey("eventID", value: (event?.objectId)!)
        //        branchUniversalObject.addMetadataKey("admissionOption", value: "GeneralAdmission")
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "sharing"
        linkProperties.channel = "in-app"
        linkProperties.addControlParam("$desktop_url", withValue: "http://gethype.co/event/\((event?.objectId)!)")
        linkProperties.addControlParam("$android_url", withValue: "http://gethype.co/event/\((event?.objectId)!)")
        
        branchUniversalObject.getShortUrl(with: linkProperties, andCallback: {
            (url, error) in
            if error == nil {
                PFCloud.callFunction(inBackground: "sendOutInvitations", withParameters: ["eventId": eventId, "eventName": locationName, "eventTime": eventDate, "guestPhoneNumbers": guestPhoneNumbers, "guestlistId": self.guestlistId, "branchUrl": url]) {
                    (response, cloudError) in
                    if cloudError == nil {
                        self.dismiss(animated: true, completion: {
                            self.contactDelegate?.epContactPickerDidSubmitInvitesAndWantsToShowEvent()
                        })
                    } else {
                        
                    }
                }
            }
            
        })
    }
    
    func submitConnectInquiry() {
        let guestPhoneNumbers = selectedContacts.map { $0.phoneNumbers[0].phoneNumber }
        
        let eventId:String = (event?.objectId)!
        let eventDate:Date = event?.value(forKey: "date") as! Date
        let location:PFObject = event?.value(forKey: "location") as! PFObject
        let locationName:String = location.value(forKey: "name") as! String
        let locationInfo:String = location.value(forKey: "info") as! String
        
        PFCloud.callFunction(inBackground: "submitConnectInquiry", withParameters: ["guestPhoneNumbers": guestPhoneNumbers,
                                                                                    "eventId": eventId,
                                                                                    "eventTime":eventDate,
                                                                                    "description":"Hype Connect",
                                                                                    "admissionOptionId":"ExadEhXujO"]) {
                                                                                        (guestlistInvite, error) in
                                                                                        if error == nil {
                                                                                            (guestlistInvite as! PFObject).pinInBackground()
                                                                                            //                                let guestlist = (guestlistInvite as! PFObject).value(forKey: "Guestlist") as! PFObject
                                                                                            //                                let inquiry = guestlist.value(forKey: "Inquiry") as! PFObject
                                                                                            // Prepare the popup assets
                                                                                            let title = "SUCCESS"
                                                                                            let message = "Your inquiry was submitted!"
                                                                                            
                                                                                            // Create the dialog
                                                                                            let popup = PopupDialog(title: title, message: message)
                                                                                            
                                                                                            // Create buttons
                                                                                            let buttonOne = CancelButton(title: "OK") {
                                                                                                self.contactDelegate?.epContactPicker(self, didSubmitInvitesAndWantsToShowInquiry: (guestlistInvite as! PFObject))
                                                                                            }
                                                                                            
                                                                                            popup.addButton(buttonOne)
                                                                                            
                                                                                            // Present dialog
                                                                                            self.present(popup, animated: true, completion: nil)
                                                                                        } else {
                                                                                            // Prepare the popup assets
                                                                                            let title = "ERROR"
                                                                                            let message = "There was an issue with creating your inquiry. Please try again later!"
                                                                                            
                                                                                            // Create the dialog
                                                                                            let popup = PopupDialog(title: title, message: message)
                                                                                            
                                                                                            // Create buttons
                                                                                            let buttonOne = CancelButton(title: "OK") {
                                                                                                print("You canceled the car dialog.")
                                                                                            }
                                                                                            
                                                                                            popup.addButton(buttonOne)
                                                                                            
                                                                                            // Present dialog
                                                                                            self.present(popup, animated: true, completion: nil)
                                                                                        }
        }

    }
    
    // MARK: - Search Actions
    
    open func updateSearchResults(for searchController: UISearchController)
    {
        if let searchText = resultSearchController.searchBar.text , searchController.isActive {
            
            let predicate: NSPredicate
            if searchText.characters.count > 0 {
                predicate = CNContact.predicateForContacts(matchingName: searchText)
            } else {
                predicate = CNContact.predicateForContactsInContainer(withIdentifier: contactsStore!.defaultContainerIdentifier())
            }
            
            let store = CNContactStore()
            do {
                filteredContacts = try store.unifiedContacts(matching: predicate,
                    keysToFetch: allowedContactKeys())
                //print("\(filteredContacts.count) count")
                
                self.tableView.reloadData()
                
            }
            catch {
                print("Error!")
            }
        }
    }
    
    open func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
}

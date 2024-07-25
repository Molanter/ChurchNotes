//
//  ContactsListView.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 3/13/24.
//

import SwiftUI
import Contacts
import SwiftData

struct ContactsListView: View {
    @EnvironmentObject var published: PublishedVariebles
    @Environment(\.dismiss) var dismiss
    
    @Query var strings: [StringDataModel]

    @State private var contacts: [CNContact] = []
    @State private var searchText = ""
    
    var backgroundType: String {
        if let strModel = strings.first(where: { $0.name == "backgroundType" }) {
            return strModel.string
        }else {
            return "none"
        }
    }
    
    var body: some View {
        List(
            contacts
                .sorted { (contact1, contact2) in
                    // First, compare by givenName
                    let givenNameOrder = contact1.givenName.compare(contact2.givenName, options: .caseInsensitive)
                    if givenNameOrder == .orderedSame {
                        // If givenNames are the same, compare by familyName
                        return contact1.familyName.compare(contact2.familyName, options: .caseInsensitive) == .orderedAscending
                    }
                    return givenNameOrder == .orderedAscending
                }
                .filter { contact in
                    return !contact.givenName.isEmpty ||
                    !contact.familyName.isEmpty
                }
                .filter { contact in
                    if !searchText.isEmpty{
                        return contact.givenName.lowercased().contains(searchText.lowercased()) ||
                        contact.familyName.lowercased().contains(searchText.lowercased())
                    }else{
                        return true
                    }
                }
            , id: \.identifier) { contact in
                HStack(alignment: .top){
                    if contact.imageDataAvailable{
                        if let imageData = contact.imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35)
                                .cornerRadius(.infinity)
                        }
                    }else {
                        Image(systemName: "person.crop.circle.fill")
                            .symbolRenderingMode(.palette)
                            .resizable()
                            .foregroundStyle(.white, Color(K.Colors.lightGray))
                            .font(.largeTitle)
                            .frame(width: 35, height: 35)
                    }
                    VStack(alignment: .leading){
                        Text("\(contact.givenName) \(contact.familyName)")
                            .foregroundStyle(.primary)
                            .font(.title3)
                            .bold()
                        if let number = contact.phoneNumbers.first(where: { $0.label == CNLabelPhoneNumberMobile }){
                            Text(number.value.stringValue)
                                .foregroundStyle(.secondary)
                                .font(.body)
                        }else if let number = contact.phoneNumbers.first{
                            Text(number.value.stringValue)
                                .foregroundStyle(.secondary)
                                .font(.body)
                        }else if let email = contact.emailAddresses.first{
                            Text(email.value.lowercased)
                                .foregroundStyle(.secondary)
                                .font(.body)
                        }
//                        else{
//                            Text(contact.note)
//                                .foregroundStyle(.secondary)
//                                .font(.body)
//                        }
                    }
                }
                .frame(height: 40)
                .onTapGesture {
                    print("Selected contact: \(contact.givenName) \(contact.familyName)")
                    published.contactToAdd = contact
                    dismiss()
                }
                .listRowBackground(
                    GlassListRow()
                )
            }
        .scrollContentBackground(backgroundType == "none" ? .visible : .hidden)
        .background {
            ListBackground()
        }
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "search-name")
            .onAppear {
                requestContactsAccess { granted in
                    if granted {
                        self.contacts = fetchContacts()
                    }
                }
            }
    }
    
    func requestContactsAccess(completion: @escaping (Bool) -> Void) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            completion(granted)
        }
    }
    
    
    func fetchContacts() -> [CNContact] {
        let store = CNContactStore()
        
        let keysToFetch = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactImageDataKey,
            CNContactImageDataAvailableKey
        ] as [CNKeyDescriptor]

        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        var contacts: [CNContact] = []

        do {
            try store.enumerateContacts(with: fetchRequest) { (contact, stop) in
                contacts.append(contact)
            }
        } catch let error {
            print("Failed to fetch contacts: \(error)")
        }

        return contacts
    }

    
}
#Preview {
    ContactsListView()
}

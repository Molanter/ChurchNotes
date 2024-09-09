//
//  Badges.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 8/13/24.
//

import SwiftUI

struct Badges{
    let nNext = Badge(name: "Next", image: "arrowshape.turn.up.right", string: "", color: "", strId: "nNext", type: "sfSymbol")
    let nGoing = Badge(name: "Going", image: "signpost.right", string: "", color: "", strId: "nGoing", type: "sfSymbol")
    let nnext = Badge(name: "next", image: "hand.point.right.fill", string: "", color: "", strId: "nnext", type: "sfSymbol")
    
    let dDone = Badge(name: "Done", image: "checkmark", string: "", color: "", strId: "dDone", type: "sfSymbol")
    let dCongrats = Badge(name: "Congrats", image: "checklist.checked", string: "", color: "", strId: "dCongrats", type: "sfSymbol")
    let ddone = Badge(name: "done", image: "trophy", string: "", color: "", strId: "ddone", type: "sfSymbol")
    
    func getBadgeArray() -> [String: Any] {
        return [
            "nNext": nNext,
            "nGoing": nGoing,
            "nnext": nnext,
            "dDone": dDone,
            "dCongrats": dCongrats,
            "ddone": ddone
        ]
    }
    
}

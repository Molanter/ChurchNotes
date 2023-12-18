//
//  Constants.swift
//  ChurchNotes
//
//  Created by Edgars Yarmolatiy on 6/27/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct K{
    @AppStorage("language") static var language: String = "en"
    @AppStorage("choosedStages") static var choosedStages: Int = 0
    @AppStorage("favouriteSign") static var favouriteSign: String = "heart"
    @AppStorage("testFeatures") static var testFeatures: Bool = false
    @AppStorage("swipeStage") static var swipeStage: Bool = false

    struct Colors{
        static let colorsDictionary: [String: String] = [
            String(localized: "ppurple"): "blue-purple",
            String(localized: "llight-bblue"): "light-blue",
            String(localized: "bblue"): "bluee",
            String(localized: "ddark-bblue"): "dark-blue",
            String(localized: "oorange"): "orangee",
            String(localized: "ggreen"): "greenn",
            String(localized: "yyellow"): "yelloww",
            String(localized: "rred"): "redd"
        ]
        @AppStorage("mainColor") static var mainColor: String = "blue-purple"
        @AppStorage("appearance") static var appearance: Int = 0
        @AppStorage("favouriteSignColor") static var favouriteSignColor = "redd"
        static let red = "redd"
        static let blue = "bluee"
        static let yellow = "yelloww"
        static let green = "greenn"
        static let lightGray = "light-grayy"
        static let justLightGray = "justLightGray"
        static let gray = "grayy"
        static let darkGray = "dark-grayy"
        static let justDarkGray = "justDarkGray"
        static let background = "backgroundd"
        static let bluePurple = "blue-purple"
        static let lightGreen = "light-green"
        static let orange = "orangee"
        static let pink = "pinkk"
        static let lightBlue = "light-blue"
        static let darkBlue = "dark-blue"
        static let text = "text-appearance"
        static let blackAndWhite = "blackAndWhite"
        static let whiteGray = "whiteGray"
    }
    struct Countries{
        static var countryList = ["Afghanistan","Albania","Algeria","Andorra","Angola","Anguilla","Antigua &amp; Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia &amp; Herzegovina","Botswana","Brazil","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Cape Verde","Cayman Islands","Chad","Chile","China","Colombia","Congo","Cook Islands","Costa Rica","Cote D Ivoire","Croatia","Cruise Ship","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Polynesia","French West Indies","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guam","Guatemala","Guernsey","Guinea","Guinea Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kuwait","Kyrgyz Republic","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Mauritania","Mauritius","Mexico","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Namibia","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Saint Pierre &amp; Miquelon","Samoa","San Marino","Satellite","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","South Africa","South Korea","Spain","Sri Lanka","St Kitts &amp; Nevis","St Lucia","St Vincent","St. Lucia","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor L'Este","Togo","Tonga","Trinidad &amp; Tobago","Tunisia","Turkey","Turkmenistan","Turks &amp; Caicos","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States" ,"Uruguay","Uzbekistan","Venezuela","Vietnam","Virgin Islands (US)","Yemen","Zambia","Zimbabwe"]
    }
    struct CountryCodes{
        static let countryPrefixes: [String: String] = ["AF": "93",
                "AL": "355", "DZ": "213","AS": "1", "AD": "376","AO": "244","AI": "1", "AQ": "672","AG": "1","AR": "54",
                "AM": "374","AW": "297","AU": "61","AT": "43","AZ": "994","BS": "1","BH": "973", "BD": "880", "BB": "1", "BY": "375", "BE": "32", "BZ": "501", "BJ": "229", "BM": "1", "BT": "975", "BA": "387", "BW": "267", "BR": "55", "IO": "246", "BG": "359", "BF": "226", "BI": "257", "KH": "855", "CM": "237", "CA": "1", "CV": "238", "KY": "345", "CF": "236", "TD": "235", "CL": "56", "CN": "86", "CX": "61", "CO": "57", "KM": "269", "CG": "242", "CK": "682", "CR": "506", "HR": "385", "CU": "53", "CY": "537", "CZ": "420", "DK": "45", "DJ": "253", "DM": "1", "DO": "1", "EC": "593", "EG": "20", "SV": "503", "GQ": "240", "ER": "291", "EE": "372", "ET": "251", "FO": "298", "FJ": "679", "FI": "358",
                "FR": "33",
                "GF": "594",
                "PF": "689",
                "GA": "241",
                "GM": "220",
                "GE": "995",
                "DE": "49",
                "GH": "233",
                "GI": "350",
                "GR": "30",
                "GL": "299",
                "GD": "1",
                "GP": "590",
                "GU": "1",
                "GT": "502",
                "GN": "224",
                "GW": "245",
                "GY": "595",
                "HT": "509",
                "HN": "504",
                "HU": "36",
                "IS": "354",
                "IN": "91",
                "ID": "62",
                "IQ": "964",
                "IE": "353",
                "IL": "972",
                "IT": "39",
                "JM": "1",
                "JP": "81",
                "JO": "962",
                "KZ": "77",
                "KE": "254",
                "KI": "686",
                "KW": "965",
                "KG": "996",
                "LV": "371",
                "LB": "961",
                "LS": "266",
                "LR": "231",
                "LI": "423",
                "LT": "370",
                "LU": "352",
                "MG": "261",
                "MW": "265",
                "MY": "60",
                "MV": "960",
                "ML": "223",
                "MT": "356",
                "MH": "692",
                "MQ": "596",
                "MR": "222",
                "MU": "230",
                "YT": "262",
                "MX": "52",
                "MC": "377",
                "MN": "976",
                "ME": "382",
                "MS": "1",
                "MA": "212",
                "MM": "95",
                "NA": "264",
                "NR": "674",
                "NP": "977",
                "NL": "31",
                "AN": "599",
                "NC": "687",
                "NZ": "64",
                "NI": "505",
                "NE": "227",
                "NG": "234",
                "NU": "683",
                "NF": "672",
                "MP": "1",
                "NO": "47",
                "OM": "968",
                "PK": "92",
                "PW": "680",
                "PA": "507",
                "PG": "675",
                "PY": "595",
                "PE": "51",
                "PH": "63",
                "PL": "48",
                "PT": "351",
                "PR": "1",
                "QA": "974",
                "RO": "40",
                "RW": "250",
                "WS": "685",
                "SM": "378",
                "SA": "966",
                "SN": "221",
                "RS": "381",
                "SC": "248",
                "SL": "232",
                "SG": "65",
                "SK": "421",
                "SI": "386",
                "SB": "677",
                "ZA": "27",
                "GS": "500",
                "ES": "34",
                "LK": "94",
                "SD": "249",
                "SR": "597",
                "SZ": "268",
                "SE": "46",
                "CH": "41",
                "TJ": "992",
                "TH": "66",
                "TG": "228",
                "TK": "690",
                "TO": "676",
                "TT": "1",
                "TN": "216",
                "TR": "90",
                "TM": "993",
                "TC": "1",
                "TV": "688",
                "UG": "256",
                "UA": "380",
                "AE": "971",
                "GB": "44",
                "US": "1",
                "UY": "598",
                "UZ": "998",
                "VU": "678",
                "WF": "681",
                "YE": "967",
                "ZM": "260",
                "ZW": "263",
                "BO": "591",
                "BN": "673",
                "CC": "61",
                "CD": "243",
                "CI": "225",
                "FK": "500",
                "GG": "44",
                "VA": "379",
                "HK": "852",
                "IR": "98",
                "IM": "44",
                "JE": "44",
                "KP": "850",
                "KR": "82",
                "LA": "856",
                "LY": "218",
                "MO": "853",
                "MK": "389",
                "FM": "691",
                "MD": "373",
                "MZ": "258",
                "PS": "970",
                "PN": "872",
                "RE": "262",
                "RU": "7",
                "BL": "590",
                "SH": "290",
                "KN": "1",
                "LC": "1",
                "MF": "590",
                "PM": "508",
                "VC": "1",
                "ST": "239",
                "SO": "252",
                "SJ": "47",
                "SY": "963",
                "TW": "886",
                "TZ": "255",
                "TL": "670",
                "VE": "58",
                "VN": "84",
                "VG": "284",
                "VI": "340", "EH": "121"]
    }
    struct AppStages{
        static let stagesArray: [AppStage] = [
            AppStage(name: String(localized: "nnew-friend"), title: "New Friend", orderIndex: 0),
            AppStage(name: String(localized: "iinvited"), title: "Invited", orderIndex: 1),
            AppStage(name: String(localized: "aattanded"), title: "Attended", orderIndex: 2),
            AppStage(name: String(localized: "aacepted-cchrist"), title: "Acepted Christ", orderIndex: 3),
            AppStage(name: String(localized: "bbaptized"), title: "Baptized", orderIndex: 4),
            AppStage(name: String(localized: "sserving"), title: "Serving", orderIndex: 5),
            AppStage(name: String(localized: "jjoined-ggroup"), title: "Joined Group", orderIndex: 6)
        ]
    }
    struct Languages{
    static var languagesArray: [AppLanguage] = [
        AppLanguage(name: "English", short: "en", image: "🇺🇸", orderIndex: 0),
        AppLanguage(name: "Українська", short: "uk", image: "🇺🇦", orderIndex: 1)
    ]
    }
    struct Hiden{
        static let ok:[String] = ["Ok", "ok", "Ok", "Ok"]
    }
}

class Utilities {

    @AppStorage("appearance") var appearance: Int = 0
    var userInterfaceStyle: ColorScheme = .dark

    func overrideDisplayMode() {
        var userInterfaceStyle: UIUserInterfaceStyle

        if appearance == 0{
            userInterfaceStyle = .unspecified
        }else if appearance == 2 {
            userInterfaceStyle = .light
        } else if appearance == 1 {
            userInterfaceStyle = .dark
        } else {
            userInterfaceStyle = .unspecified
        }
    
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
    }
}

extension Character {
    var isEnglishCharacter: Bool {
        return ("A"..."Z" ~= self) || ("a"..."z" ~= self)
    }

    var isNumber: Bool {
        return "0"..."9" ~= self
    }

    var isAllowedSymbol: Bool {
        let allowedSymbols: Set<Character> = ["-", "_", "."]
        return allowedSymbols.contains(self)
    }
}

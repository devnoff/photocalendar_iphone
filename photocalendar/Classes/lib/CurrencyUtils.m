//
//  CurrencyUtils.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 27..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "CurrencyUtils.h"


#define CURRENCY_CODE @"code"
#define CURRENCY_DESCRIPTION @"description"


@implementation CurrencyUtils

+ (NSUInteger)count {
    return [[CurrencyUtils getCurrencies] count];
}


+ (NSString *)textAtIndex:(NSUInteger)index {
    NSDictionary *currency = [[CurrencyUtils getCurrencies] objectAtIndex:index];
    return [NSString stringWithFormat:@"%@ (%@)",
            [currency objectForKey:CURRENCY_CODE],
            [currency objectForKey:CURRENCY_DESCRIPTION]];
}


+ (NSString *)codeAtIndex:(NSUInteger)index {
    NSDictionary *currency = [[CurrencyUtils getCurrencies] objectAtIndex:index];
    return [currency objectForKey:CURRENCY_CODE];
}


+ (NSUInteger)indexOfUSD {
    return 148;
}



+ (NSArray *)getCurrencies {
    return [NSArray arrayWithObjects:
            [NSDictionary dictionaryWithObjectsAndKeys:@"AED", CURRENCY_CODE, @"United Arab Emirates Dirham", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"AFN", CURRENCY_CODE, @"Afghanistan Afghani", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"ALL", CURRENCY_CODE, @"Albania Lek", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"AMD", CURRENCY_CODE, @"Armenia Dram", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"ANG", CURRENCY_CODE, @"Netherlands Antilles Guilder", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"AOA", CURRENCY_CODE, @"Angola Kwanza", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"ARS", CURRENCY_CODE, @"Argentina Peso", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"AUD", CURRENCY_CODE, @"Australia Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"AWG", CURRENCY_CODE, @"Aruba Guilder", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"AZN", CURRENCY_CODE, @"Azerbaijan New Manat", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"BAM", CURRENCY_CODE, @"Bosnia and Herzegovina Convertible Marka", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"BBD", CURRENCY_CODE, @"Barbados Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"BDT", CURRENCY_CODE, @"Bangladesh Taka", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"BGN", CURRENCY_CODE, @"Bulgaria Lev", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"BHD", CURRENCY_CODE, @"Bahrain Dinar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"BIF", CURRENCY_CODE, @"Burundi Franc", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"BMD", CURRENCY_CODE, @"Bermuda Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"BND", CURRENCY_CODE, @"Brunei Darussalam Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"BOB", CURRENCY_CODE, @"Bolivia Boliviano", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"BRL", CURRENCY_CODE, @"Brazil Real", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"BSD", CURRENCY_CODE, @"Bahamas Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"BTN", CURRENCY_CODE, @"Bhutan Ngultrum", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"BWP", CURRENCY_CODE, @"Botswana Pula", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"BYR", CURRENCY_CODE, @"Belarus Ruble", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"BZD", CURRENCY_CODE, @"Belize Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"CAD", CURRENCY_CODE, @"Canada Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"CDF", CURRENCY_CODE, @"Congo/Kinshasa Franc", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"CHF", CURRENCY_CODE, @"Switzerland Franc", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"CLP", CURRENCY_CODE, @"Chile Peso", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"CNY", CURRENCY_CODE, @"China Yuan Renminbi", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"COP", CURRENCY_CODE, @"Colombia Peso", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"CRC", CURRENCY_CODE, @"Costa Rica Colon", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"CUC", CURRENCY_CODE, @"Cuba Convertible Peso", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"CUP", CURRENCY_CODE, @"Cuba Peso", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"CVE", CURRENCY_CODE, @"Cape Verde Escudo", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"CZK", CURRENCY_CODE, @"Czech Republic Koruna", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"DJF", CURRENCY_CODE, @"Djibouti Franc", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"DKK", CURRENCY_CODE, @"Denmark Krone", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"DOP", CURRENCY_CODE, @"Dominican Republic Peso", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"DZD", CURRENCY_CODE, @"Algeria Dinar", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"EGP", CURRENCY_CODE, @"Egypt Pound", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"ERN", CURRENCY_CODE, @"Eritrea Nakfa", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"ETB", CURRENCY_CODE, @"Ethiopia Birr", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"EUR", CURRENCY_CODE, @"Euro Member Countries", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"FJD", CURRENCY_CODE, @"Fiji Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"FKP", CURRENCY_CODE, @"Falkland Islands (Malvinas) Pound", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"GBP", CURRENCY_CODE, @"United Kingdom Pound", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"GEL", CURRENCY_CODE, @"Georgia Lari", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"GGP", CURRENCY_CODE, @"Guernsey Pound", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"GHS", CURRENCY_CODE, @"Ghana Cedi", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"GIP", CURRENCY_CODE, @"Gibraltar Pound", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"GMD", CURRENCY_CODE, @"Gambia Dalasi", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"GNF", CURRENCY_CODE, @"Guinea Franc", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"GTQ", CURRENCY_CODE, @"Guatemala Quetzal", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"GYD", CURRENCY_CODE, @"Guyana Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"HKD", CURRENCY_CODE, @"Hong Kong Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"HNL", CURRENCY_CODE, @"Honduras Lempira", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"HRK", CURRENCY_CODE, @"Croatia Kuna", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"HTG", CURRENCY_CODE, @"Haiti Gourde", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"HUF", CURRENCY_CODE, @"Hungary Forint", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"IDR", CURRENCY_CODE, @"Indonesia Rupiah", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"ILS", CURRENCY_CODE, @"Israel Shekel", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"IMP", CURRENCY_CODE, @"Isle of Man Pound", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"INR", CURRENCY_CODE, @"India Rupee", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"IQD", CURRENCY_CODE, @"Iraq Dinar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"IRR", CURRENCY_CODE, @"Iran Rial", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"ISK", CURRENCY_CODE, @"Iceland Krona", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"JEP", CURRENCY_CODE, @"Jersey Pound", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"JMD", CURRENCY_CODE, @"Jamaica Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"JOD", CURRENCY_CODE, @"Jordan Dinar", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"JPY", CURRENCY_CODE, @"Japan Yen", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"KES", CURRENCY_CODE, @"Kenya Shilling", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"KGS", CURRENCY_CODE, @"Kyrgyzstan Som", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"KHR", CURRENCY_CODE, @"Cambodia Riel", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"KMF", CURRENCY_CODE, @"Comoros Franc", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"KPW", CURRENCY_CODE, @"Korea (North) Won", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"KRW", CURRENCY_CODE, @"Korea (South) Won", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"KWD", CURRENCY_CODE, @"Kuwait Dinar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"KYD", CURRENCY_CODE, @"Cayman Islands Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"KZT", CURRENCY_CODE, @"Kazakhstan Tenge", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"LAK", CURRENCY_CODE, @"Laos Kip", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"LBP", CURRENCY_CODE, @"Lebanon Pound", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"LKR", CURRENCY_CODE, @"Sri Lanka Rupee", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"LRD", CURRENCY_CODE, @"Liberia Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"LSL", CURRENCY_CODE, @"Lesotho Loti", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"LTL", CURRENCY_CODE, @"Lithuania Litas", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"LVL", CURRENCY_CODE, @"Latvia Lat", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"LYD", CURRENCY_CODE, @"Libya Dinar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"MAD", CURRENCY_CODE, @"Morocco Dirham", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"MDL", CURRENCY_CODE, @"Moldova Leu", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"MGA", CURRENCY_CODE, @"Madagascar Ariary", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"MKD", CURRENCY_CODE, @"Macedonia Denar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"MMK", CURRENCY_CODE, @"Myanmar (Burma) Kyat", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"MNT", CURRENCY_CODE, @"Mongolia Tughrik", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"MOP", CURRENCY_CODE, @"Macau Pataca", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"MRO", CURRENCY_CODE, @"Mauritania Ouguiya", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"MUR", CURRENCY_CODE, @"Mauritius Rupee", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"MVR", CURRENCY_CODE, @"Maldives (Maldive Islands) Rufiyaa", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"MWK", CURRENCY_CODE, @"Malawi Kwacha", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"MXN", CURRENCY_CODE, @"Mexico Peso", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"MYR", CURRENCY_CODE, @"Malaysia Ringgit", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"MZN", CURRENCY_CODE, @"Mozambique Metical", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"NAD", CURRENCY_CODE, @"Namibia Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"NGN", CURRENCY_CODE, @"Nigeria Naira", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"NIO", CURRENCY_CODE, @"Nicaragua Cordoba", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"NOK", CURRENCY_CODE, @"Norway Krone", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"NPR", CURRENCY_CODE, @"Nepal Rupee", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"NZD", CURRENCY_CODE, @"New Zealand Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"OMR", CURRENCY_CODE, @"Oman Rial", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"PAB", CURRENCY_CODE, @"Panama Balboa", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"PEN", CURRENCY_CODE, @"Peru Nuevo Sol", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"PGK", CURRENCY_CODE, @"Papua New Guinea Kina", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"PHP", CURRENCY_CODE, @"Philippines Peso", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"PKR", CURRENCY_CODE, @"Pakistan Rupee", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"PLN", CURRENCY_CODE, @"Poland Zloty", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"PYG", CURRENCY_CODE, @"Paraguay Guarani", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"QAR", CURRENCY_CODE, @"Qatar Riyal", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"RON", CURRENCY_CODE, @"Romania New Leu", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"RSD", CURRENCY_CODE, @"Serbia Dinar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"RUB", CURRENCY_CODE, @"Russia Ruble", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"RWF", CURRENCY_CODE, @"Rwanda Franc", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"SAR", CURRENCY_CODE, @"Saudi Arabia Riyal", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"SBD", CURRENCY_CODE, @"Solomon Islands Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"SCR", CURRENCY_CODE, @"Seychelles Rupee", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"SDG", CURRENCY_CODE, @"Sudan Pound", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"SEK", CURRENCY_CODE, @"Sweden Krona", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"SGD", CURRENCY_CODE, @"Singapore Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"SHP", CURRENCY_CODE, @"Saint Helena Pound", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"SLL", CURRENCY_CODE, @"Sierra Leone Leone", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"SOS", CURRENCY_CODE, @"Somalia Shilling", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"SPL", CURRENCY_CODE, @"Seborga Luigino", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"SRD", CURRENCY_CODE, @"Suriname Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"STD", CURRENCY_CODE, @"S찾o Principe and Tome Dobra", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"SVC", CURRENCY_CODE, @"El Salvador Colon", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"SYP", CURRENCY_CODE, @"Syria Pound", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"SZL", CURRENCY_CODE, @"Swaziland Lilangeni", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"THB", CURRENCY_CODE, @"Thailand Baht", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"TJS", CURRENCY_CODE, @"Tajikistan Somoni", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"TMT", CURRENCY_CODE, @"Turkmenistan Manat", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"TND", CURRENCY_CODE, @"Tunisia Dinar", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"TOP", CURRENCY_CODE, @"Tonga Pa'anga", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"TRY", CURRENCY_CODE, @"Turkey Lira", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"TTD", CURRENCY_CODE, @"Trinidad and Tobago Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"TVD", CURRENCY_CODE, @"Tuvalu Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"TWD", CURRENCY_CODE, @"Taiwan New Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"TZS", CURRENCY_CODE, @"Tanzania Shilling", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"UAH", CURRENCY_CODE, @"Ukraine Hryvna", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"UGX", CURRENCY_CODE, @"Uganda Shilling", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"USD", CURRENCY_CODE, @"United States Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"UYU", CURRENCY_CODE, @"Uruguay Peso", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"UZS", CURRENCY_CODE, @"Uzbekistan Som", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"VEF", CURRENCY_CODE, @"Venezuela Bolivar Fuerte", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"VND", CURRENCY_CODE, @"Viet Nam Dong", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"VUV", CURRENCY_CODE, @"Vanuatu Vatu", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"WST", CURRENCY_CODE, @"Samoa Tala", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"XAF", CURRENCY_CODE, @"Communaut챕 Financi챔re Africaine (BEAC) CFA Franc BEAC", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"XAG", CURRENCY_CODE, @"Silver", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"XAU", CURRENCY_CODE, @"Gold", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"XCD", CURRENCY_CODE, @"East Caribbean Dollar", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"XDR", CURRENCY_CODE, @"International Monetary Fund (IMF) Special Drawing Rights", CURRENCY_DESCRIPTION, nil],
            
            [NSDictionary dictionaryWithObjectsAndKeys:@"XOF", CURRENCY_CODE, @"Communaut챕 Financi챔re Africaine (BCEAO) Franc", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"XPD", CURRENCY_CODE, @"Palladium", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"XPF", CURRENCY_CODE, @"Comptoirs Fran챌ais du Pacifique (CFP) Franc", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"XPT", CURRENCY_CODE, @"Platinum", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"YER", CURRENCY_CODE, @"Yemen Rial", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"ZAR", CURRENCY_CODE, @"South Africa Rand", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"ZMK", CURRENCY_CODE, @"Zambia Kwacha", CURRENCY_DESCRIPTION, nil],
            [NSDictionary dictionaryWithObjectsAndKeys:@"ZWD", CURRENCY_CODE, @"Zimbabwe Dollar", CURRENCY_DESCRIPTION, nil],
             nil];
}

@end

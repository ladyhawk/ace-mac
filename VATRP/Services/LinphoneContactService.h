//
//  LinphoneContactService.h
//  ACE
//
//  Created by User on 30/11/15.
//  Copyright © 2015 VTCSecure. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinphoneManager.h"
#include "linphone/linphonecore.h"
#include "linphone/linphone_tunnel.h"

@interface LinphoneContactService : NSObject

+ (LinphoneContactService *)sharedInstance;

- (BOOL)addContactFromByAddress:(LinphoneAddress*)address;
- (BOOL)addContactWithDisplayName:(NSString*)name andSipUri:(NSString*)sipURI;
- (LinphoneFriend*)createContactFromName:(NSString*)name andSipUri:(NSString*)sipURI;

- (NSMutableArray*)contactList;
- (NSMutableArray*)contactFavoritesList;
- (NSMutableArray*)contactListBySearchText:(NSString*)searchText;

- (void)deleteContact:(const LinphoneFriend*)contact;
- (void)deleteContactWithDisplayName:(NSString*)name andSipUri:(NSString*)sipURI;
- (void)deleteContactList;

- (NSString*)contactNameFromAddress:(LinphoneAddress*)address;

@end

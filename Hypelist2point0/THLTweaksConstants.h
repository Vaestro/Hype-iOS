//
//  THLTweaksConstants.h
//  HypeList
//
//  Created by Phil Meyers IV on 8/6/15.
//  Copyright (c) 2015 HypeList. All rights reserved.
//

//How to Tweak
//FBTweakBind(object, property, categoryName, groupName, tweakName, defaultValue...);
//defaultValue can be three things;
//    1. a single value. Ex: FBTweakBind(object, property, categoryName, groupName, tweakName, @"Some text");
//    2. an initial value + array/dictionary. Ex: FBTweakBind(object, property, categoryName, groupName, tweakName, @"Some text", @[@"Other", @"text", @"options"]);
//    3. an initial value, lower bound, upper bound (only for numbers). Ex: FBTweakBind(object, property, categoryName, groupName, tweakName, 0.5, 0.0, 10.0);

//Template
//#define kTHLFBTweaksCategory<#Name#>Key    @"<#Name#>";
//#define kTHLFBTweaksGroup<#Name#>Key       @"<#Name#>";

#ifndef HypeList_THLTweaksConstants_h
#define HypeList_THLTweaksConstants_h

//Category Keys
#define kTHLFBTweaksCategoryMainKey					@"Main";

#define kTHLFBTweaksGroupGuestListCreation			@"Guest List Creation";
#define kTHLFBTweaksGroupGuestListInvitationPopup	@"Guest List Invitation Popup"

#define kTHLFBTweaksGroupGlobalKey					@"Global";
#endif

//
//  THLUserDataWorker.m
//  Hype
//
//  Created by Nik Cane on 29/01/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLUserDataWorker.h"
#import "PFFile.h"

@implementation THLUserDataWorker

+ (void)addProfileImage:(UIImage *)profileImage
                forUser:(THLUser *) user
               delegate:(id<THLLoginInteractorDelegate>) delegate{
    PFFile *profileImageFile = [THLUserDataWorker profileImageFileForUser:user
                                                                withImage:profileImage];
    user.image = profileImageFile;
    [[user saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *task) {
        if (delegate != nil){
            [delegate interactor:nil didAddProfileImage:task.error];
        }
        return nil;
    }];
}

#pragma mark - Profile Image Helpers
+ (PFFile *)profileImageFileForUser:(THLUser *)user withImage:(UIImage *)image {
    NSData *imageData = UIImagePNGRepresentation(image);
    PFFile *imageFile = [PFFile fileWithName:[THLUserDataWorker profileImageNameForUser:user] data:imageData];
    return imageFile;
}

+ (NSString *)profileImageNameForUser:(THLUser *)user {
    NSArray *nameComponents = @[@"ProfilePicture",
                                user.fullName];
    return [nameComponents componentsJoinedByString:@"_"];
}


@end

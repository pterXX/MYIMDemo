//
//  NSFileManager+TLChat.m
//  TLChat
//
//  Created by 徐世杰 on 16/3/3.
//  Copyright © 2016年 徐世杰. All rights reserved.
//

#import "NSFileManager+IMChat.h"
#import "IMUserHelper.h"

@implementation NSFileManager (IMChat)

+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory
{
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)pathForDirectory:(NSSearchPathDirectory)directory
{
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

+ (NSURL *)documentsURL
{
    return [self URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)documentsPath
{
    return [self pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)libraryURL
{
    return [self URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)libraryPath
{
    return [self pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)cachesURL
{
    return [self URLForDirectory:NSCachesDirectory];
}

+ (NSString *)cachesPath
{
    return [self pathForDirectory:NSCachesDirectory];
}

+ (NSURL *)tempURL
{
    return [NSURL fileURLWithPath:NSTemporaryDirectory()];
}

+ (NSString *)tempPath
{
    return NSTemporaryDirectory();
}

+ (BOOL)addSkipBackupAttributeToFile:(NSString *)path
{
    return [[NSURL.alloc initFileURLWithPath:path] setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
}

+ (double)availableDiskSpace
{
    NSDictionary *attributes = [self.defaultManager attributesOfFileSystemForPath:self.documentsPath error:nil];
    
    return [attributes[NSFileSystemFreeSize] unsignedLongLongValue] / (double)0x100000;
}

+ (NSString *)pathTempSettingImage:(NSString *)imageName
{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Setting/Images/", [NSFileManager tempPath], [IMUserHelper sharedHelper].userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:imageName];
}

+ (NSString *)pathTempSettingVideo:(NSString *)video
{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Setting/Videos/", [NSFileManager tempPath], [IMUserHelper sharedHelper].userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:video];
}

+ (NSString *)pathTempSettingVoice:(NSString *)voice
{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Setting/Voice/", [NSFileManager tempPath], [IMUserHelper sharedHelper].userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:voice];
}

+ (NSString *)pathUserSettingImage:(NSString *)imageName
{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Setting/Images/", [NSFileManager documentsPath], [IMUserHelper sharedHelper].userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:imageName];
}

+ (NSString *)pathUserChatImage:(NSString*)imageName
{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Chat/Images/", [NSFileManager documentsPath], [IMUserHelper sharedHelper].userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:imageName];
}

+ (NSString *)pathUserChatBackgroundImage:(NSString *)imageName
{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Chat/Background/", [NSFileManager documentsPath], [IMUserHelper sharedHelper].userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:imageName];
}

+ (NSString *)pathUserAvatar:(NSString *)imageName
{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Chat/Avatar/", [NSFileManager documentsPath], [IMUserHelper sharedHelper].userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:imageName];
}

+ (NSString *)pathContactsAvatar:(NSString *)imageName
{
    NSString *path = [NSString stringWithFormat:@"%@/Contacts/Avatar/", [NSFileManager documentsPath]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:imageName];
}

+ (NSString *)pathUserChatVoice:(NSString *)voiceName
{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Chat/Voices/", [NSFileManager documentsPath], [IMUserHelper sharedHelper].userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:voiceName];
}


+ (NSString *)pathExpressionForGroupID:(NSString *)groupID
{
    NSString *path = [NSString stringWithFormat:@"%@/Expression/%@/", [NSFileManager documentsPath], groupID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return path;
}

+ (NSString *)pathContactsData
{
    NSString *path = [NSString stringWithFormat:@"%@/Contacts/", [NSFileManager documentsPath]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:@"Contacts.dat"];
}

+ (NSString *)pathScreenshotImage:(NSString *)imageName
{
    NSString *path = [NSString stringWithFormat:@"%@/Screenshot/", [NSFileManager documentsPath]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:imageName];
}

+ (NSString *)pathDBCommon
{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Setting/DB/", [NSFileManager documentsPath], [IMUserHelper sharedHelper].userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:@"common.sqlite3"];
}

+ (NSString *)pathDBMessage
{
    NSString *path = [NSString stringWithFormat:@"%@/User/%@/Chat/DB/", [NSFileManager documentsPath], [IMUserHelper sharedHelper].userID];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            DDLogError(@"File Create Failed: %@", path);
        }
    }
    return [path stringByAppendingString:@"message.sqlite3"];
}

+ (NSString *)cacheForFile:(NSString *)filename
{
    return [[NSFileManager cachesPath] stringByAppendingString:filename];
}

@end

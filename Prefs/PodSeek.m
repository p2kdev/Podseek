#import <Preferences/Preferences.h>

#define PodSeekPath @"/User/Library/Preferences/com.imkpatil.podseek.plist"

@interface PodSeekListController : PSListController
- (void)visitPaypal;
- (void)visitTwitter;
@end

@implementation PodSeekListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"PodSeek" target:self] retain];
	}
	return _specifiers;
}

-(id) readPreferenceValue:(PSSpecifier*)specifier {
    NSDictionary *podseeksettings = [NSDictionary dictionaryWithContentsOfFile:PodSeekPath];
    if (!podseeksettings[specifier.properties[@"key"]]) {
        return specifier.properties[@"default"];
    }
    return podseeksettings[specifier.properties[@"key"]];
}

-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:PodSeekPath]];
    [defaults setObject:value forKey:specifier.properties[@"key"]];
    [defaults writeToFile:PodSeekPath atomically:YES];
    //  NSDictionary *powercolorSettings = [NSDictionary dictionaryWithContentsOfFile:powercolorPath];
    CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
    if(toPost) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

- (void)visitPaypal {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/patilkiran08/5"]];
}

- (void)visitTwitter {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/imkpatil"]];
}

@end



// vim:ft=objc

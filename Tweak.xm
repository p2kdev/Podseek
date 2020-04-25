#import "MediaRemote.h"

@interface MPRemoteCommandCenter
  -(void)_pushMediaRemoteCommand:(unsigned)arg1 withOptions:(CFDictionaryRef)arg2 completion:(/*^block*/id)arg3;
  @property (nonatomic,copy,readonly) NSString * playerID;
  - (BOOL)isRightPlayer;
@end

static BOOL isEnabled = YES;
static int skipInterval = 15;

NSDictionary *pref = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.imkpatil.podseek.plist"];

%hook MPRemoteCommandCenter

  -(void)_pushMediaRemoteCommand:(unsigned)arg1 withOptions:(CFDictionaryRef)arg2 completion:(/*^block*/id)arg3
  {
    if(arg1 == 4 && isEnabled && [self isRightPlayer])
    {
      [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startForwardSeek) userInfo:nil repeats:NO];
      return;
    }

    if(arg1 == 5 && isEnabled && [self isRightPlayer])
    {
      [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startBackwardSeek) userInfo:nil repeats:NO];
      return;
    }

    %orig;
  }

  %new
  - (void)startForwardSeek
  {
    MRMediaRemoteSendCommand(8, nil);
    [NSTimer scheduledTimerWithTimeInterval:(skipInterval/10) target:self selector:@selector(stopForwardSeek) userInfo:nil repeats:NO];
  }

  %new
  - (void)stopForwardSeek
  {
    MRMediaRemoteSendCommand(9, nil);
  }

  %new
  - (void)startBackwardSeek
  {
    MRMediaRemoteSendCommand(10, nil);
    [NSTimer scheduledTimerWithTimeInterval:(skipInterval/10) target:self selector:@selector(stopBackwardSeek) userInfo:nil repeats:NO];
  }

  %new
  - (void)stopBackwardSeek
  {
    MRMediaRemoteSendCommand(11, nil);
  }

  %new
  - (BOOL)isRightPlayer
  {
    NSString *msg = [NSString stringWithFormat:@"PlayerID - %@ ", self.playerID];

    NSRange range = [msg rangeOfString:@"Podcast" options: NSCaseInsensitiveSearch];
    if (range.location != NSNotFound)
    {
      return YES;
    }
    return NO;
  }

%end

static void reloadSettings()
{
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.imkpatil.podseek.plist"];
  if(prefs)
  {
      isEnabled = [prefs objectForKey:@"twkEnabled"] ? [[prefs objectForKey:@"twkEnabled"] boolValue] : isEnabled;
      skipInterval = [prefs objectForKey:@"skipInt"] ? [[prefs objectForKey:@"skipInt"] intValue] : skipInterval;
  }
  [prefs release];
}


%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.imkpatil.podseek.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  reloadSettings();
}



// if(arg1 == 0 && isEnabled)
// {
//   arg1 = 1;
//   //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startForwardSeek) userInfo:nil repeats:NO];
//   return;
// }
// id Tmp2 = [[%c(MPNowPlayingInfoCenter) defaultCenter] _mediaRemoteNowPlayingInfo];
// msg = [NSString stringWithFormat:@"mediaNowPlayingInfo - %@",Tmp2];
// alertView = [[UIAlertView alloc] initWithTitle:@"_pushMediaRemoteCommand" message:msg delegate:UIApplication.sharedApplication.keyWindow.rootViewController cancelButtonTitle:@"Ok" otherButtonTitles:nil];
// [alertView show];
// [alertView release];

// NSRange range = [msg rangeOfString:@"Podcasts11" options: NSCaseInsensitiveSearch];
// if (range.location != NSNotFound)
// {
//   [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startSeek) userInfo:nil repeats:NO];
//   return;
// }
// MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information)
// {
//
//   NSDictionary *dict = (__bridge NSDictionary *)(information);
//   if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle] != nil)
//   {
// 			NSString *title= [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]];
//       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title" message:title delegate:UIApplication.sharedApplication.keyWindow.rootViewController cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//       [alertView show];
//       [alertView release];
//   }
//
//   if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] != nil)
//   {
//       NSString *artist= [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]];
//       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title" message:artist delegate:UIApplication.sharedApplication.keyWindow.rootViewController cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//       [alertView show];
//       [alertView release];
//   }
//
// });

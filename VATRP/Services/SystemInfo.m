//
//  SystemInfo.m
//  linphone
//
//  Created by Zack Matthews on 1/25/16.
//
//

#import "SystemInfo.h"
#import "DefaultSettingsManager.h"
#import <sys/utsname.h>
#import "LinphoneManager.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#import "SettingsHandler.h"

@interface SystemInfo()
+(NSString*) configSettingsAsString;
+(NSString *) platformType;
+(NSString*) hardwareId;
+(NSMutableArray*)getLinphoneLogs;
@end

@implementation SystemInfo

static inline NSString* NSStringFromBOOL(BOOL aBool) {
    return aBool? @"YES" : @"NO";
}

+(NSString*)hardwareId{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
    return platform;
}

+(NSString *)platformType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (China)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    if ([platform isEqualToString:@"AppleTV2,1"])   return @"Apple TV 2G";
    if ([platform isEqualToString:@"AppleTV3,1"])   return @"Apple TV 3";
    if ([platform isEqualToString:@"AppleTV3,2"])   return @"Apple TV 3 (2013)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}
+(NSString *) machineModel
{
    size_t len = 0;
    sysctlbyname("hw.model", NULL, &len, NULL, 0);
    
    if (len)
    {
        char *model = malloc(len*sizeof(char));
        sysctlbyname("hw.model", model, &len, NULL, 0);
        NSString *model_ns = [NSString stringWithUTF8String:model];
        free(model);
        return model_ns;
    }
    
    return @"Just an Apple Computer"; //incase model name can't be read
}
+(NSString*)formatedSystemInformation{
    
        // Load hardware.
        NSString* hardware = [self platformType];
        // Load app version.
        NSString* appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        // Load App Build Version
        NSString* buildNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];

        // Load SIP settings.
    LinphoneCore *lc = [LinphoneManager getLc];
    LinphoneProxyConfig *cfg = nil;
    //Get current proxy config
    NSString* sipSettings = @"Error retreiving account";
    if(lc){ cfg = linphone_core_get_default_proxy_config(lc); }
        if(cfg){
            const LinphoneAddress *addr = linphone_proxy_config_get_identity_address(cfg);
            DefaultSettingsManager *settingsManager = [[DefaultSettingsManager alloc] init];
            sipSettings = [NSString stringWithFormat:@"username: %s \ndomain: %s \nproxy: %s \ntransport: %@ \n port: %d",
                                        linphone_address_get_username(addr),
                                        linphone_address_get_domain(addr),
                                        linphone_proxy_config_get_identity(cfg),
                                        [settingsManager sipRegisterTransport],
                                        [settingsManager sipRegisterPort]];
        }
        NSString *coreConfigInfo = [SystemInfo configSettingsAsString];
        NSString* result = [NSString stringWithFormat:@"Hardware: %@\nMac Version: %@\nACE version: %@, Build %@\nSIP settings:\n%@\n%@\n", hardware, [SystemInfo machineModel], appVersionString, buildNumber, sipSettings,coreConfigInfo];
        return result;
    }

    +(NSString*) configSettingsAsString{
        LinphoneCore *lc = [LinphoneManager getLc];
            if(!lc) return @"LinphoneCore = null";
            if(!linphone_core_get_default_proxy_config(lc)) return @"config = null";

        NSString *config = @"";
        NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:@"CONFIG", nil];
        /**Account**/

        /**Video**/
        NSString *videoHeader = @"\nVIDEO: \n";
        [values addObject:videoHeader];
        linphone_core_set_video_preset(lc, "high-fps");
        NSString *video_preset = [NSString stringWithFormat:@"Video preset = %s", linphone_core_get_video_preset(lc)];
        [values addObject:video_preset];
        NSString *adaptiveRateAlgorithm = [NSString stringWithFormat:@"Adaptive rate algorithm = %s",         linphone_core_get_adaptive_rate_algorithm(lc)];
        
        [values addObject:adaptiveRateAlgorithm];
        /**Video codecs**/
        
        const MSList *videoCodecs = linphone_core_get_video_codecs(lc);
        PayloadType *pt;
        for(int i = 0; i < ms_list_size(videoCodecs); i++) {
                @try {
                    pt = ms_list_nth_data(videoCodecs, i);
                    BOOL isEnabled = linphone_core_payload_type_enabled(lc, pt);
                        NSString *isCodecEnabled = [NSString stringWithFormat:@"%s = %@", pt->mime_type,  NSStringFromBOOL(isEnabled)];
                        [values addObject:isCodecEnabled];
                        NSString *codecSendFmtp = [NSString stringWithFormat:@"%s send-fmtp = %s", pt->mime_type, pt->send_fmtp];
                        NSString *codecRecvFmtp = [NSString stringWithFormat:@"%s recv-fmtp = %s", pt->mime_type, pt->recv_fmtp];
                        [values addObject:codecSendFmtp];
                        [values addObject:codecRecvFmtp];
                    } @catch (NSError *e) {
                        NSLog(@"%@", [e description]);
                    }
            }

        /**Audio**/
        NSString *audioHeader = @"\nAUDIO: \n";
        [values addObject:audioHeader];
        /**Audio codecs**/
        const MSList *audioCodecs = linphone_core_get_audio_codecs(lc);
        for(int i = 0; i < ms_list_size(audioCodecs); i++) {

            @try {
                pt = ms_list_nth_data(audioCodecs, i);
                BOOL isEnabled = linphone_core_payload_type_enabled(lc, pt);
                NSString *isCodecEnabled = [NSString stringWithFormat:@"%s = %@", pt->mime_type,  NSStringFromBOOL(isEnabled)];
                [values addObject:isCodecEnabled];
                NSString *codecSendFmtp = [NSString stringWithFormat:@"%s send-fmtp = %s", pt->mime_type, pt->send_fmtp];
                NSString *codecRecvFmtp = [NSString stringWithFormat:@"%s recv-fmtp = %s", pt->mime_type, pt->recv_fmtp];
                [values addObject:codecSendFmtp];
                [values addObject:codecRecvFmtp];
            }
            @catch(NSError *e){
                NSLog(@"%@", [e description]);
            }
                
        //MISC settings
        NSString *miscHeader = @"\nMISC: \n";
        [values addObject:miscHeader];

        NSString *isVideoEnabled = [NSString stringWithFormat:@"video_enabled = %hhu", linphone_core_video_enabled(lc)];
        [values addObject:isVideoEnabled];
        /**Mute**/
        SettingsHandler* settingsHandler = [SettingsHandler settingsHandler];
        bool muteMicrophone = settingsHandler.isMicrophoneMuted;
        bool muteSpeaker = settingsHandler.isSpeakerMuted;
        NSString *isMicMuted = [NSString stringWithFormat:@"mic_mute = %@", NSStringFromBOOL(muteMicrophone)];
        [values addObject:isMicMuted];
        NSString *isSpeakerMuted = [NSString stringWithFormat:@"speaker_mute = %@", NSStringFromBOOL(muteSpeaker)];
        [values addObject:isSpeakerMuted];

        //Echo cancellation
        NSString *echoCancel = [NSString stringWithFormat:@"echo_cancellation = %@", NSStringFromBOOL(linphone_core_echo_cancellation_enabled(lc))];
        [values addObject:echoCancel];
        //Adaptive rate control
        NSString *adaptiveRateControl = [NSString stringWithFormat:@"adaptive_rate_control = %@", NSStringFromBOOL(linphone_core_adaptive_rate_control_enabled(lc))];
        [values addObject:adaptiveRateControl];
        //STUN
            NSString *stun = @"";
            @try{
                stun = [NSString stringWithFormat:@"stun = %s", linphone_core_get_stun_server(lc)];
            }
            @catch(NSError *e){
                stun = @"stun = none";
            }

        [values addObject:stun];

        //AVPF
            LinphoneProxyConfig *cfg = linphone_core_get_default_proxy_config(lc);
            NSString *AVPF = [NSString stringWithFormat:@"avpf = %@", NSStringFromBOOL( linphone_proxy_config_avpf_enabled(cfg))];
        [values addObject:AVPF];

        NSString *avpfRRInterval = [NSString stringWithFormat:@"avpf_rr_interval = %d", linphone_proxy_config_get_avpf_rr_interval(cfg)];
            [values addObject: avpfRRInterval];

        NSString *rtcpFeedback = [NSString stringWithFormat:@"rtcp_feedback = %d", [[LinphoneManager instance] lpConfigIntForKey:@"rtp" forSection:@"rtcp_fb_implicit_rtcp_fb" withDefault:0]];
        [values addObject:rtcpFeedback];
        //Video size
            MSVideoSize videoSize = linphone_core_get_preferred_video_size(lc);
        NSString *preferredVideoSize = [NSString stringWithFormat:@"preferred_video_size = %dX%d", videoSize.width, videoSize.height];
            [values addObject: preferredVideoSize];
        //Bandwidth
            NSString *downloadBW = [NSString stringWithFormat:@"download_bandwidth = %d", linphone_core_get_download_bandwidth(lc)];
        [values addObject:downloadBW];

            NSString *uploadBW =[NSString stringWithFormat:@"upload_bandwidth = %d", linphone_core_get_upload_bandwidth(lc)];
        [values addObject:uploadBW];
        /*** Linphone logs ***/
        NSString *linphoneLogHeader = @"\nLinphone Logs: \n";
        [values addObject: linphoneLogHeader];
            [values addObjectsFromArray:[SystemInfo getLinphoneLogs]];
            
        for(int i = 0; i < values.count; i++){
            config = [NSString stringWithFormat:@"%@\n%@", config, [values objectAtIndex:i]];
        }
        return config;
    }
}

+(NSMutableArray*)getLinphoneLogs {
    NSMutableArray *attachments = [[NSMutableArray alloc] initWithCapacity:3];
    
    // retrieve linphone logs if available
    char *filepath = linphone_core_compress_log_collection();
    if (filepath != NULL) {
        NSString *filename = [[NSString stringWithUTF8String:filepath] componentsSeparatedByString:@"/"].lastObject;
        NSString *mimeType = nil;
        if ([filename hasSuffix:@".txt"]) {
            mimeType = @"text/plain";
        } else if ([filename hasSuffix:@".gz"]) {
            mimeType = @"application/gzip";
        } else {
            NSLog(@"Unknown extension type: %@, not attaching logs", filename);
        }
        
        if (mimeType != nil) {
            system([[NSString stringWithFormat:@"mv %s ~/Desktop/", filepath] UTF8String]);
            [attachments addObject:@[ [NSString stringWithUTF8String:filepath], mimeType, filename ]];
        }
    }
    
    if ([LinphoneManager.instance lpConfigBoolForKey:@"send_logs_include_linphonerc_and_chathistory"]) {
        // retrieve linphone rc
        [attachments
         addObject:@[ [LinphoneManager documentFile:@"linphonerc"], @"text/plain", @"linphone-configuration.rc" ]];
        
        // retrieve historydb
        [attachments addObject:@[
                                 [LinphoneManager documentFile:@"linphone_chats.db"],
                                 @"application/x-sqlite3",
                                 @"linphone-chats-history.db"
                                 ]];
    }
    
    ms_free(filepath);
    return attachments;
}

@end


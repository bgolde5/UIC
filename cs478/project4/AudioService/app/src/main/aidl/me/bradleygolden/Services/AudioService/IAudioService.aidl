// IAudioService.aidl
package me.bradleygolden.Services.AudioService;

interface IAudioService {
    String playClip(String clip);
    String stopClip(String clip);
    String pauseClip(String clip);
    String resumeClip(String clip);
}

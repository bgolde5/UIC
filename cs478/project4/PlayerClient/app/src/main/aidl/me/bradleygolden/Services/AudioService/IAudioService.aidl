// IAudioService.aidl
package me.bradleygolden.Services.AudioService;

// Declare any non-default types here with import statements

interface IAudioService {
    String playClip(String clip);
    String stopClip(String clip);
    String pauseClip(String clip);
    String resumeClip(String clip);
}
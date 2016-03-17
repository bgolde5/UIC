package me.bradleygolden.project3part2.Indianpolis;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import me.bradleygolden.project3part2.R;

/**
 * Created by bradleygolden on 3/16/16.
 */
public class IndyAttractionWebViewFragment extends Fragment {
    private int mCurrIndex = -1;
    private int mAttractionArrayLen;
    private WebView attractionWebView;

    public int getShownIndex() {
        return mCurrIndex;
    }

    // Show the attraction web page at position newIndex
    public void showWebViewAtIndex(int newIndex) {
        if (newIndex < 0 || newIndex >= mAttractionArrayLen)
            return;

        // Get the index for an attraction string
        mCurrIndex = newIndex;

        attractionWebView.setVisibility(View.VISIBLE);

        // Load the webview with the URL at the given index
        attractionWebView.clearHistory(); // Ensure the history has been cleared for prior searches
        attractionWebView.loadUrl(IndyAttractionViewerActivity.mIndyAttractionURLArray[newIndex]);
        attractionWebView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return true;
            }
        });
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.web_view, container, false);
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        // Get the attraction webview activity
        attractionWebView = (WebView)getActivity().findViewById(R.id.webView);

        // Get he attraction array length for Chicago
        mAttractionArrayLen = IndyAttractionViewerActivity.mIndyAttractionArray.length;

        // Retain the state of this fragment
        setRetainInstance(true);
    }
}

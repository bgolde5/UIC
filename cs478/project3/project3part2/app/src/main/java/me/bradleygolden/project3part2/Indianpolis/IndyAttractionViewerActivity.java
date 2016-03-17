package me.bradleygolden.project3part2.Indianpolis;

import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.Toast;

import me.bradleygolden.project3part2.R;

/**
 * Created by bradleygolden on 3/16/16.
 */
public class IndyAttractionViewerActivity extends AppCompatActivity implements IndyListFragment.ListSelectionListener {

    public static String[] mIndyAttractionArray = null;
    public static String[] mIndyAttractionURLArray = null;

    private FrameLayout mListFrameLayout, mWebViewFrameLayout;
    private IndyAttractionWebViewFragment mWebViewFragment = new IndyAttractionWebViewFragment();;
    private IndyListFragment mListFragment;
    private FragmentManager mFragmentManager;

    private static final int MATCH_PARENT = LinearLayout.LayoutParams.MATCH_PARENT;

    @Override
    public void onListSelection(int index) {

        // If the ChicagoWebViewFragment has not been added, add it now
        if (!mWebViewFragment.isAdded()) {

            // Start a new FragmentTransaction
            FragmentTransaction fragmentTransaction = mFragmentManager
                    .beginTransaction();

            // Add the WebViewFragment to the layout
            fragmentTransaction.add(R.id.webview_fragtment_container,
                    mWebViewFragment);

            // Add this FragmentTransaction to the backstack
            fragmentTransaction.addToBackStack(null);

            // Commit the FragmentTransaction
            fragmentTransaction.commit();

            // Force Android to execute the committed FragmentTransaction
            mFragmentManager.executePendingTransactions();
        }

        if (mWebViewFragment.getShownIndex() != index) {

            // Show the webview
            enableWebView();
//            disableListView();

            // Tell the ChicagoWebViewFragment to show the web view a the specified index
            mWebViewFragment.showWebViewAtIndex(index);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Get List of Indy Attractions
        mIndyAttractionArray = getResources().getStringArray(R.array.indy_attractions);
        mIndyAttractionURLArray = getResources().getStringArray(R.array.indy_attraction_urls);

        setUp();
    }

    private void setUp(){
        setContentView(R.layout.main);

        // Get references to the TitleFragment and to the QuotesFragment
        mListFrameLayout = (FrameLayout) findViewById(R.id.list_view_fragment_container);
        mWebViewFrameLayout = (FrameLayout) findViewById(R.id.webview_fragtment_container);

        // Get a reference to the FragmentManager
        mFragmentManager = getFragmentManager();

        // Start a new FragmentTransaction
        FragmentTransaction fragmentTransaction = mFragmentManager
                .beginTransaction();

        // Add the ListFragment to the layout
        mListFragment = new IndyListFragment();
        fragmentTransaction.add(R.id.list_view_fragment_container,
                mListFragment);

        // Commit the FragmentTransaction
        fragmentTransaction.commit();

        // Add a OnBackStackChangedListener to reset the layout when the back stack changes
        mFragmentManager
                .addOnBackStackChangedListener(new FragmentManager.OnBackStackChangedListener() {
                    public void onBackStackChanged() {
                        setLayout();
                    }
                });
    }

    private void setLayout() {

        // Determine whether the WebView has been added
        if (!mWebViewFragment.isAdded()) {

            // Make the TitleFragment occupy the entire layout
            mListFrameLayout.setLayoutParams(new LinearLayout.LayoutParams(
                    MATCH_PARENT, MATCH_PARENT));
            mWebViewFrameLayout.setLayoutParams(new LinearLayout.LayoutParams(0,
                    MATCH_PARENT));
        } else {

            // Make the TitleLayout take 1/3 of the layout's width
            mListFrameLayout.setLayoutParams(new LinearLayout.LayoutParams(0,
                    MATCH_PARENT, 1f));

            // Make the QuoteLayout take 2/3's of the layout's width
            mWebViewFrameLayout.setLayoutParams(new LinearLayout.LayoutParams(0,
                    MATCH_PARENT, 2f));
        }
    }

    // Show the web view
    private void enableWebView(){
        FragmentManager fragmentManager = getFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        mWebViewFrameLayout = (FrameLayout) findViewById(R.id.webview_fragtment_container);
        fragmentTransaction.show(mWebViewFragment);
        fragmentTransaction.commit();

    }

    // Hide the web view
    private void disableWebView(){
        FragmentManager fragmentManager = getFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        mWebViewFrameLayout = (FrameLayout) findViewById(R.id.webview_fragtment_container);
        fragmentTransaction.hide(mWebViewFragment);
        fragmentTransaction.commit();
    }

    // Show the list view
    private void enableListView(){
        FragmentManager fragmentManager = getFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        mWebViewFrameLayout = (FrameLayout) findViewById(R.id.list_view_fragment_container);
        fragmentTransaction.show(mListFragment);
        fragmentTransaction.commit();
    }

    // Hid ethe list view
    private void disableListView(){
        FragmentManager fragmentManager = getFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();
        mWebViewFrameLayout = (FrameLayout) findViewById(R.id.list_view_fragment_container);
        fragmentTransaction.hide(mListFragment);
        fragmentTransaction.commit();
    }

    @Override
    public void onBackPressed() {

        // If the web view isn't present, we're at the home screen
        if(!mWebViewFragment.isAdded()){
            super.onBackPressed();
        }

        // Return to initial configuration
        FragmentManager manager = getFragmentManager();
        FragmentTransaction trans = manager.beginTransaction();
        trans.remove(mWebViewFragment);
        trans.remove(mListFragment);
        trans.commit();
        manager.popBackStack();
        setUp();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflator = getMenuInflater();
        setTitle("Attractions Viewer");
        inflator.inflate(R.menu.project3_menu, menu);

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle item selection
        switch (item.getItemId()){
            case R.id.chicago:
                startActivity(new Intent(getApplicationContext(), IndyAttractionViewerActivity.class));
                return true;
            case R.id.indy:
                Toast.makeText(getApplicationContext(), "You're already browsing Indianapolis", Toast.LENGTH_SHORT).show();

                return true;
            default:
                return false;
        }
    }

    @Override
    public void onSaveInstanceState(Bundle savedInstanceState) {
        // Always call the superclass so it can save the view hierarchy state
        super.onSaveInstanceState(savedInstanceState);
    }

    @Override
    protected void onRestoreInstanceState(Bundle savedInstanceState) {
        setUp();
    }
}
